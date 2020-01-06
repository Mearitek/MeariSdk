package com.meari.test;

import android.animation.ValueAnimator;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.app.KeyguardManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.SoundPool;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.GenericDraweeHierarchy;
import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder;
import com.facebook.drawee.generic.RoundingParams;
import com.facebook.drawee.interfaces.DraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.callback.IResultCallback;
import com.meari.sdk.callback.IStringResultCallback;
import com.meari.sdk.common.ProtocalConstants;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.sdk.utils.JsonUtil;
import com.meari.test.common.Constant;
import com.meari.test.permission_utils.Func;
import com.meari.test.permission_utils.PermissionUtil;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.Logger;
import com.meari.test.widget.LoadingView;
import com.meari.test.widget.ProgressLoadingDialog;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;
import com.ppstrong.ppsplayer.CameraPlayerRecordVolumeListener;
import com.ppstrong.ppsplayer.CameraPlayerVideoStopListener;
import com.ppstrong.ppsplayer.PPSGLSurfaceView;

import org.json.JSONException;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import cn.jpush.android.api.JPushInterface;

public class BellCallActivity extends Activity implements View.OnClickListener {

    private static final String TAG = "BellCallActivity";
    public final static int NOTICE_ID = 0x120;
    private int mRetryCount = 3;//弥补设备可能没上线就接到门铃消息
    private ProgressLoadingDialog mProgressDialog;
    private int mMode;
    public TextView tv_voice_status;
    private int currVolume;


    public ProgressLoadingDialog getProgressDialog() {
        return mProgressDialog;
    }

    public void setProgressDialog(ProgressLoadingDialog mProgressDialog) {
        this.mProgressDialog = mProgressDialog;
    }

    public static BellCallActivity instance;

    public static BellCallActivity getInstance() {
        synchronized (BellCallActivity.class) {
            return instance;
        }
    }

    @Override
    public void finish() {
        //如果由于SMS引起finish，则直接return
        try {
            AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
            if (mMode == AudioManager.MODE_IN_COMMUNICATION) {
                if (!audioManager.isSpeakerphoneOn()) {
                    audioManager.setMode(AudioManager.MODE_NORMAL);
                }
            } else
                audioManager.setMode(mMode);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (mIsStoppedByAMSOnce == true) {
            //之后一定要设置成false，否则陷入死循环
            mIsStoppedByAMSOnce = false;
            return;
        }
        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        mNotificationManager.cancel(NOTICE_ID);
        if (handler != null)
            handler.removeCallbacksAndMessages(null);
        handler = null;
        //取消定时器
        if (noticeTimer != null) {
            noticeTimer.cancel();
            noticeTimer = null;
        }
        if (keepAliveTimer != null) {
            keepAliveTimer.cancel();
            keepAliveTimer = null;
        }
        NotificationManager manager = (NotificationManager)
                getSystemService(NOTIFICATION_SERVICE);
        manager.cancel(NOTICE_ID);
        instance = null;
        cameraPlayer.stopvoicetalk(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                Logger.i(TAG, "stopvoicetalk success:" + successMsg);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                Logger.i(TAG, "stopvoicetalk errorMsg:" + errorMsg);
            }
        });
        if (soundPool != null) {
            soundPool.stop(soundID);
            //清理内存
        }
        super.finish();
    }

    @Override
    protected void onResume() {
        super.onResume();
        //提示用户可以点击通知栏返回
        openSpeaker();
        CommonUtils.showToast(R.string.toast_returnCall);
        try {
            AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
            mMode = audioManager.getMode();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void openSpeaker() {
        try {
            AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
            audioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
            currVolume = audioManager.getStreamVolume(AudioManager.STREAM_VOICE_CALL);
            if (!audioManager.isSpeakerphoneOn()) {
                //setSpeakerphoneOn() only work when audio mode set to MODE_IN_CALL.
                audioManager.setSpeakerphoneOn(true);
                audioManager.setStreamVolume(AudioManager.STREAM_VOICE_CALL,
                        audioManager.getStreamMaxVolume(AudioManager.STREAM_VOICE_CALL),
                        AudioManager.STREAM_VOICE_CALL);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onStop() {
        //WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED这个属性可能会导致页面起来的时候“闪退”，走的是resume->pause->stop->resume
        KeyguardManager keyguardManager = (KeyguardManager) getSystemService(KEYGUARD_SERVICE);
        if (keyguardManager.isKeyguardLocked() && !mIsStoppedByAMSOnce) {
            //记下是否由于SMS引起页面关闭
            mIsStoppedByAMSOnce = true;
        }
        super.onStop();
    }

    /**
     * 显示进度条
     */
    public void startProgressDialog() {
        if (isFinishing()) {
            return;
        }
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(this));
        }
        if (!getProgressDialog().isShowing()) {
            getProgressDialog().show();
        }
    }

    /**
     * 关闭进度条
     */
    public void stopProgressDialog() {
        if (getProgressDialog() != null && getProgressDialog().isShowing()) {
            getProgressDialog().dismiss();
        }
    }

    final static int CALL_TIME_OUT = 15 * 1000;//接听应答超时时间

    boolean mIsStoppedByAMSOnce = false;//默认false

    //接听之前的页面
    Button btn_accept, btn_refuse;
    SimpleDraweeView sdv_preview;
    RelativeLayout rl_bellcall;
    TextView tv_name;//未接听页面设备名称

    //接听之后的页面
    Button btn_mute, btn_talk, btn_hangup;
    LinearLayout ll_preview;
    TextView tv_bellName;
    SimpleDraweeView gif_voice;
    LoadingView loadingView;
    LinearLayout ll_op;
    ImageView iv_refresh;//刷新按钮
    RelativeLayout rl_preview;

    //call了又call二级通知
    RelativeLayout rl_callcall;
    ImageView iv_callcall;
    TextView tv_callcall;

    boolean isMute = false, isTalk = true;//是否静音、是否双向语音

    private SoundPool soundPool;//铃声
    int soundID;//铃声的ID值，每次播放完会变

    //预览cameraplayer
    CameraPlayer cameraPlayer;
    boolean isConnect = false;//是否成功连接设备
    boolean isReturn = false;//connect是否返回
    //设备对象
    CameraInfo bellInfo;
    //MQTT传过来的原始数据，避免camerainfo里加入了太多的bellinfo，有些字段只有这个页面使用
    BaseJSONObject bellJsonInfo;
    String bellJsonStr;

    //拒绝接听时的对话框，是否需要播放语言留言
    Dialog wordDialog;
    //产生通知栏的计时器
    Timer noticeTimer;
    //与服务器发送心跳的计时器
    Timer keepAliveTimer;

    PPSGLSurfaceView glv;

    //权限相关
    PermissionUtil.PermissionRequestObject mRecordPermissionRequest;
    public static final String RECORD_AUDIO = android.Manifest.permission.RECORD_AUDIO;
    final static int CODE_RECORD_AUDIO_PERMISSION = 120;

    //统一消息处理
    final static int MSG_ACCEPT = 0x1001;//接收门铃来电
    final static int MSG_CONNECT_IPC_SUCCESS = 0x1002;//连接设备成功
    final static int MSG_CALL_TIME_OUT = 0x1003;//接听应答超时
    final static int MSG_CALLCALL = 0x1004;//call了又call
    final static int MSG_REFRESH_IMG = 0x1005;//刷新门铃头像
    final static int MSG_CONNECT_IPC_FAILED = 0x1006;//连接设备失败
    final static int MSG_HIDE_PLAY_LOADING = 0x1007;//隐藏播放加载条
    final static int MSG_SEND_WORD = 0x1008;//发送语言留言指令
    private final int MESSAGE_STOP_TALK_FAILED = 0x1009;//对讲成功
    private final int MESSAGE_TALK_SUCCESS = 0x1010;//对讲成功
    private final int MESSAGE_TALK_FAILED = 0x1011;//对讲失败
    @SuppressLint("HandlerLeak")
    Handler handler = new Handler(new Handler.Callback() {
        @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public boolean handleMessage(Message msg) {
            if (isFinishing() || handler == null)
                return false;
            switch (msg.what) {
                case MSG_SEND_WORD:
                    if (isConnect == true) {
                        if (cameraPlayer != null && isConnect) {
                            //发送语言留言指令
                            startProgressDialog();
//                            POST /devices/voicemail
                            BaseJSONObject json = new BaseJSONObject();
                            json.put("action", "POST");
                            json.put("deviceurl", "http://127.0.0.1/devices/voicemail");
                            cameraPlayer.commondeviceparams2(json.toString(), new CameraPlayerListener() {
                                @Override
                                public void PPSuccessHandler(String successMsg) {
                                    Log.i(TAG, "发送语言留言指令成功");
                                    //发送成功,关闭页面
                                    //一定要设置成false，否则用户需要点击两次才能关闭页面
                                    mIsStoppedByAMSOnce = false;
                                    finish();
                                }

                                @Override
                                public void PPFailureError(String errorMsg) {
                                    Log.i(TAG, "发送语言留言指令失败！！！" + errorMsg);
                                    //发送指令失败,关闭页面
                                    //一定要设置成false，否则用户需要点击两次才能关闭页面
                                    mIsStoppedByAMSOnce = false;
                                    finish();
                                }
                            });
                            JPushInterface.clearAllNotifications(BellCallActivity.this);
                        }
                    } else {
                        //一定要设置成false，否则用户需要点击两次才能关闭页面
                        mIsStoppedByAMSOnce = false;
                        //关闭页面
                        finish();
                    }
                    break;
                case MSG_HIDE_PLAY_LOADING:
                    loadingView.setVisibility(View.GONE);
                    break;
                case MSG_REFRESH_IMG:
                    String imgUrl = (String) msg.obj;
                    Log.i("pupu", imgUrl);
                    sdv_preview.setImageURI(imgUrl);
                    break;
                case MSG_ACCEPT:
                    if (isConnect == true) {
                        startPreview();
                    }
                    //显示操作栏，开启出现动画
                    AlphaAnimation anim_op = new AlphaAnimation(0f, 1f);
                    anim_op.setDuration(2000);
                    ll_op.setAnimation(anim_op);
                    ll_op.startAnimation(anim_op);
                    ll_op.setVisibility(View.VISIBLE);
                    //停止铃声
                    soundPool.stop(soundID);
                    //停止震动
                    CommonUtils.virateCancel(BellCallActivity.this);
                    //隐藏接听布局
                    rl_bellcall.setVisibility(View.GONE);
                    break;
                case MSG_CONNECT_IPC_FAILED:


                    isConnect = false;
                    isReturn = true;
                    //提示连接失败
                    //用户可以点击重新加载按钮
                    iv_refresh.setVisibility(View.VISIBLE);
                    //隐藏加载条
                    loadingView.setVisibility(View.GONE);
                    break;
                case MSG_CONNECT_IPC_SUCCESS:
                    mRetryCount = 0;
                    isReturn = true;
                    isConnect = true;
                    //如果已经接受，则去预览
                    if (rl_bellcall.getVisibility() == View.GONE) {
                        startPreview();
                    }

                    break;
                case MSG_CALL_TIME_OUT:
                    if (isFinishing() || isDestroyed())
                        return false;
                    if (rl_bellcall != null) {
                        if (rl_bellcall.getVisibility() == View.VISIBLE) {
                            //关闭页面
                            //一定要设置成false，否则用户需要点击两次才能关闭页面
                            mIsStoppedByAMSOnce = false;
                            finish();
                        }
                    }
                    break;
                case MSG_CALLCALL:
                    if (msg.obj != null) {
                        BaseJSONObject jsonObject = (BaseJSONObject) msg.obj;
                        CameraInfo info = JsonUtil.getCameraInfo(jsonObject);
                        rl_callcall.setTag(jsonObject);
                        tv_callcall.setText(info.getDeviceName());
                        //开启弹出渐变动画
                        ValueAnimator transAnim = ValueAnimator.ofFloat(-rl_callcall.getHeight(), 0);
                        transAnim.setDuration(300);
                        transAnim.setInterpolator(new AccelerateDecelerateInterpolator());
                        transAnim.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                            @Override
                            public void onAnimationUpdate(ValueAnimator animation) {
                                float trans = (float) animation.getAnimatedValue();
                                rl_callcall.setTranslationY(trans);
                            }
                        });
                        transAnim.start();
                    }
                    break;
                case MESSAGE_TALK_FAILED:
                    btn_talk.setBackgroundResource(R.mipmap.img_talk_off);
                    isTalk = false;
                    gif_voice.setVisibility(View.GONE);
                    break;
                case MESSAGE_TALK_SUCCESS:
                    tv_voice_status.setVisibility(View.GONE);
                    btn_talk.setBackgroundResource(R.mipmap.img_talk_on);
                    isTalk = true;
                    gif_voice.setVisibility(View.VISIBLE);
                    break;
                case MESSAGE_STOP_TALK_FAILED:
                    btn_talk.setBackgroundResource(R.mipmap.img_talk_on);
                    isTalk = true;
                    gif_voice.setVisibility(View.VISIBLE);
                    break;
                default:
                    break;
            }
            return false;
        }
    });

    /**
     * 检查是否有录音权限
     */
    private void checkRecordPermission() {
        boolean hasPermission = PermissionUtil.with(this).has(RECORD_AUDIO);
        if (!hasPermission) {
            mRecordPermissionRequest = PermissionUtil.with(this).request(RECORD_AUDIO).onAllGranted(
                    new Func() {
                        @Override
                        protected void call() {

                        }
                    }).onAnyDenied(
                    new Func() {
                        @Override
                        protected void call() {
                        }
                    }).ask(CODE_RECORD_AUDIO_PERMISSION);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case CODE_RECORD_AUDIO_PERMISSION:
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //授权成功
                    Log.i(TAG, "录音权限==授权成功");
                } else {
                    //提示授权失败，关闭页面
                    Log.i(TAG, "录音权限==授权失败");
                }
                break;
        }
    }

    /**
     * 开启预览
     */
    private void startPreview() {
        //开启预览
        glv.screenWidth = glv.getWidth();
        glv.screenHeight = glv.getHeight();
        tv_voice_status.setVisibility(View.VISIBLE);
        //去预览
        cameraPlayer.startPreview(glv, 0, new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (handler == null || isFinishing())
                    return;
                handler.sendEmptyMessage(MSG_HIDE_PLAY_LOADING);
                //预览成功
                //开启声音
                cameraPlayer.enableMute(false);
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        cameraPlayer.startVoiceTalkForVQE(new CameraPlayerListener() {
                            @Override
                            public void PPSuccessHandler(String successMsg) {
                                if (handler != null)
                                    handler.sendEmptyMessage(MESSAGE_TALK_SUCCESS);
                            }

                            @Override
                            public void PPFailureError(String errorMsg) {
                                if (handler != null) {
                                    handler.sendEmptyMessage(MSG_HIDE_PLAY_LOADING);
                                    handler.sendEmptyMessage(MESSAGE_TALK_FAILED);
                                }
                            }
                        }, new CameraPlayerRecordVolumeListener() {
                            @Override
                            public void onCameraPlayerRecordvolume(int volume) {

                            }

                            @Override
                            public void error(String error) {

                            }
                        });
                    }
                }).start();

            }

            @Override
            public void PPFailureError(String errorMsg) {
                //预览失败，提示用户
                if (handler == null || isFinishing())
                    return;
                BaseJSONObject baseJSONObject = null;
                try {
                    baseJSONObject = new BaseJSONObject(errorMsg);
                    if (baseJSONObject.has("code")) {
                        int code = baseJSONObject.optInt("code");
                        {
                            if (code == -10) {
                                handler.sendEmptyMessage(MSG_HIDE_PLAY_LOADING);
                                cameraPlayer.enableMute(false);
                                new Thread(new Runnable() {
                                    @Override
                                    public void run() {
                                        cameraPlayer.startVoiceTalkForVQE(new CameraPlayerListener() {
                                            @Override
                                            public void PPSuccessHandler(String successMsg) {
                                                if (handler != null)
                                                    handler.sendEmptyMessage(MESSAGE_TALK_SUCCESS);
                                            }

                                            @Override
                                            public void PPFailureError(String errorMsg) {
                                                if (handler != null) {
                                                    handler.sendEmptyMessage(MSG_HIDE_PLAY_LOADING);
                                                    handler.sendEmptyMessage(MESSAGE_TALK_FAILED);
                                                }
                                            }
                                        }, new CameraPlayerRecordVolumeListener() {
                                            @Override
                                            public void onCameraPlayerRecordvolume(int volume) {

                                            }

                                            @Override
                                            public void error(String error) {

                                            }
                                        });
                                    }
                                }).start();
                                return;
                            }
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                handler.sendEmptyMessage(MSG_CONNECT_IPC_FAILED);

            }
        }, new CameraPlayerVideoStopListener() {
            @Override
            public void onCameraPlayerVideoClosed(int errorcode) {

            }
        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bell_call);
        tv_voice_status = findViewById(R.id.tv_voice_status);
        AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        mMode = audioManager.getMode();
        final Window win = getWindow();
        win.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                | WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                | WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                | WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
        //设置接听超时计时
        handler.sendEmptyMessageDelayed(MSG_CALL_TIME_OUT, CALL_TIME_OUT);
        instance = this;
        //去掉极光本地通知栏
        initVoice(this);

        //获取门铃信息
        bellJsonStr = getIntent().getExtras().getString("bellInfo");
        try {
            bellJsonInfo = new BaseJSONObject(bellJsonStr);
            bellInfo = JsonUtil.getCameraInfo(bellJsonInfo);

            //判断是否有时间戳字段，如果有，则说明消息来自于用户点击BellCallService产生的通知栏
            if (bellJsonStr.contains("timeStamp")) {
                //用户点击极光通知栏进来
                long timeStamp = bellJsonInfo.getLong("timeStamp");
                long curTime = new Date().getTime();
                if (curTime - timeStamp >= CALL_TIME_OUT) {
                    //消息已过期
                    CommonUtils.showDialog(this, getString(R.string.str_msg_past), closeClick, false);
                }
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }

        //每2s产生个通知栏,避免有些奇葩机型上设置通知栏可滑动取消的问题
        noticeTimer = new Timer();
        noticeTimer.schedule(new TimerTask() {
            @Override
            public void run() {
                createNotification();
            }
        }, 1000, 2000);

        initView();

        //开启电话广播监听，只响应最近的门铃电话时间
        CallReceiver callReceiver = new CallReceiver();
        //action名字：call了又call
        IntentFilter intentFilter = new IntentFilter(ProtocalConstants.BELL_CALLCALL);
        LocalBroadcastManager mReceiverManager = LocalBroadcastManager.getInstance(this);
        mReceiverManager.registerReceiver(callReceiver, intentFilter);
    }

    private void initVoice(Context context) {
        AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        mMode = audioManager.getMode();
        openSpeaker();
    }

    DialogInterface.OnClickListener closeClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            //关闭页面
            mIsStoppedByAMSOnce = false;
            finish();
        }
    };

    /**
     * 产生通知栏
     */
    private void createNotification() {
        Logger.i(TAG, "产生通知栏");
        //产生个通知栏
        Intent nfIntent = new Intent(this, BellCallActivity.class);
        Bundle nfBundle = new Bundle();
        nfBundle.putString("bellInfo", bellJsonStr);
        nfIntent.putExtras(nfBundle);
        nfIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setContentIntent(PendingIntent.getActivity(this, 0, nfIntent, 0))
                        .setSmallIcon(R.mipmap.ic_app)
                        .setContentTitle(getString(R.string.app_meari_name))
                        .setOngoing(true)//设置用户无法通过滑动取消它
                        .setContentText(getString(R.string.str_visit));
        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        mNotificationManager.notify(BellCallActivity.NOTICE_ID, mBuilder.build());
    }

//    /**
//     * 初始化双向语音
//     *
//     * @param context
//     */
//    private void initVoice(Context context) {
//        MwAudioSdk.sdkInit(context);
//        try {
//            AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
//            audioManager.setMode(AudioManager.ROUTE_SPEAKER);
//            if (!audioManager.isSpeakerphoneOn()) {
//                //setSpeakerphoneOn() only work when audio mode set to MODE_IN_CALL.
//                audioManager.setSpeakerphoneOn(true);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }

    private void initView() {
        //检查权限
        checkRecordPermission();

        //开启震动
        CommonUtils.vibrateStart(this, new long[]{1000, 1000, 1000, 1000}, 0);

        //findView,未接听页面
        btn_accept = findViewById(R.id.btn_accept);
        btn_refuse = findViewById(R.id.btn_refuse);
        rl_bellcall = findViewById(R.id.rl_bellcall);
        sdv_preview = findViewById(R.id.sdv_preview);
        tv_name = findViewById(R.id.tv_name);
        tv_name.setText(bellInfo.getDeviceName());

        //获取GenericDraweeHierarchy对象
        GenericDraweeHierarchy hierarchy = GenericDraweeHierarchyBuilder.newInstance(getResources())
                .setRoundingParams(RoundingParams.fromCornersRadii(new float[]{38, 38, 38, 38, 38, 38, 38, 38}))
                .setFadeDuration(2000)
                .setActualImageScaleType(ScalingUtils.ScaleType.FOCUS_CROP)
                .setPlaceholderImage(R.mipmap.img_head_default)
                .setPlaceholderImageScaleType(ScalingUtils.ScaleType.CENTER_CROP)
                //构建
                .build();
        sdv_preview.setHierarchy(hierarchy);
        if (!bellJsonInfo.optString("imgUrl").equals("")) {
            sdv_preview.setImageURI(Uri.parse(bellJsonInfo.optString("imgUrl")));
            Log.i("pupu", bellJsonInfo.optString("imgUrl"));
        }

        //接听后页面
        rl_preview = findViewById(R.id.rl_preview);
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) rl_preview.getLayoutParams();
        params.width = Constant.width;
        params.height = Constant.width * 9 / 16;
        rl_preview.setLayoutParams(params);

        ll_preview = findViewById(R.id.ll_preview);
        tv_bellName = findViewById(R.id.tv_bellName);
        tv_bellName.setText(bellInfo.getDeviceName());
        btn_hangup = findViewById(R.id.btn_hangup);
        btn_mute = findViewById(R.id.btn_mute);
        btn_talk = findViewById(R.id.btn_talk);
        gif_voice = findViewById(R.id.gif_voice);
        loadingView = findViewById(R.id.loadingView);
        loadingView.init(false);
        ll_op = findViewById(R.id.ll_op);
        iv_refresh = findViewById(R.id.iv_refresh);

        //call了又call二级通知栏
        rl_callcall = findViewById(R.id.rl_callcall);
        tv_callcall = findViewById(R.id.tv_callcall);
        iv_callcall = findViewById(R.id.iv_callcall);

        //onclick
        btn_accept.setOnClickListener(this);
        btn_refuse.setOnClickListener(this);
        btn_mute.setOnClickListener(this);
        btn_talk.setOnClickListener(this);
        btn_hangup.setOnClickListener(this);
        iv_refresh.setOnClickListener(this);
        //call了又call通知栏点击事件
        rl_callcall.setOnClickListener(this);

        //播放声音，用新方法创建实例，老方法已被弃用
        SoundPool.Builder sb = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            sb = new SoundPool.Builder();
            sb.setMaxStreams(2);
            //AudioAttributes是一个封装音频各种属性的方法
            AudioAttributes.Builder attrBuilder = new AudioAttributes.Builder();
            //设置音频流的合适的属性
            attrBuilder.setLegacyStreamType(AudioManager.STREAM_MUSIC);
            //加载一个AudioAttributes
            sb.setAudioAttributes(attrBuilder.build());
            soundPool = sb.build();
        } else {
            soundPool = new SoundPool(10, AudioManager.STREAM_SYSTEM, 5);
        }
        soundID = 1;
        soundID = soundPool.load(this, R.raw.dingdong, soundID);
        Logger.i(TAG, "load soundID:" + soundID);
        soundPool.setOnLoadCompleteListener(new SoundPool.OnLoadCompleteListener() {
            @Override
            public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
                Log.i(TAG, "load success");
                soundID = soundPool.play(soundID, 0.5f, 0.5f, 0, 7, 1);
                Log.i(TAG, "play soundID===>" + soundID);
            }
        });

        //初始化动画
        //加载gif图
        DraweeController mDraweeController = Fresco.newDraweeControllerBuilder()
                .setAutoPlayAnimations(true)
                .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.gif_voice))//设置uri
                .build();
        gif_voice.setController(mDraweeController);

        //预览
        cameraPlayer = new CameraPlayer();
        cameraPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
        cameraPlayer.setCameraInfo(bellInfo);
        glv = new PPSGLSurfaceView(this, Constant.width, Constant.height);
        glv.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
        ll_preview.addView(glv);
        gif_voice.setVisibility(View.GONE);
        //连接设备去
        connectIPC();
    }

    /**
     * 连接门铃设备
     */
    private void connectIPC() {
        cameraPlayer.connectIPC2(CommonUtils.getCameraString(bellInfo), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                Log.i(TAG, "connectIPC成功：" + successMsg);
                //预览去
                if (handler == null)
                    return;
                handler.sendEmptyMessage(MSG_CONNECT_IPC_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                Log.i(TAG, "connectIPC失败：" + errorMsg);
                if (handler == null)
                    return;
                //提示用户重试
                handler.sendEmptyMessage(MSG_CONNECT_IPC_FAILED);
            }
        });
    }

    Dialog.OnClickListener positiveListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            //关闭本对话框
            if (wordDialog != null) {
                wordDialog.dismiss();
            }
            //去打洞发送语言留言，为了保证对话框的唯一性，延时500ms
            handler.sendEmptyMessageDelayed(MSG_SEND_WORD, 500);
        }
    };

    Dialog.OnClickListener negativeListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            //一定要设置成false，否则用户需要点击两次才能关闭页面
            mIsStoppedByAMSOnce = false;
            //关闭页面
            finish();
        }
    };

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_refresh:
                //显示加载条
                loadingView.setVisibility(View.VISIBLE);
                //隐藏自己
                iv_refresh.setVisibility(View.GONE);

                //去重新连接设备
                connectIPC();
                break;
            case R.id.rl_callcall:
                //重置本页面
                resetCall();
                break;
            case R.id.btn_accept:
                JPushInterface.clearAllNotifications(this);
                handler.removeMessages(MSG_CALL_TIME_OUT);
                onBellAnswer();
                break;
            case R.id.btn_refuse:
                handler.removeMessages(MSG_CALL_TIME_OUT);
                JPushInterface.clearAllNotifications(this);
                onBellHangUp();
                break;
            case R.id.btn_hangup:

                JPushInterface.clearAllNotifications(this);
                mIsStoppedByAMSOnce = false;
                finish();
                //挂断
                onBellHangUp();
                break;
            case R.id.btn_mute:
                //静音
                if (isMute == false) {
                    //开启静音
                    btn_mute.setBackgroundResource(R.mipmap.img_mute);
                    isMute = true;
                } else {
                    //关闭静音
                    btn_mute.setBackgroundResource(R.mipmap.img_not_mute);
                    isMute = false;
                }
                if (cameraPlayer.IsLogined()) {
                    //切换静音状态
                    cameraPlayer.enableMute(isMute);
                }

                break;
            case R.id.btn_talk:
                //双向语音开关

                gif_voice.setVisibility(View.GONE);

                if (isTalk == true) {
                    //关闭麦克风
                    btn_talk.setBackgroundResource(R.mipmap.img_talk_off);
                    isTalk = false;
                    gif_voice.setVisibility(View.GONE);
//                    tv_voice_status.setText(getString(R.string.str_preparing));
                } else {
                    tv_voice_status.setVisibility(View.VISIBLE);
                    //开启麦克风
                    btn_talk.setBackgroundResource(R.mipmap.img_talk_on);
                    isTalk = true;
                    tv_voice_status.setText(getString(R.string.str_preparing));
                }
                if (cameraPlayer.IsLogined()) {
                    //切换语音开关
                    if (isTalk == true) {
                        cameraPlayer.startVoiceTalkForVQE(new CameraPlayerListener() {
                            @Override
                            public void PPSuccessHandler(String successMsg) {
                                stopProgressDialog();
                                handler.sendEmptyMessage(MESSAGE_TALK_SUCCESS);
                            }

                            @Override
                            public void PPFailureError(String errorMsg) {
                                handler.sendEmptyMessage(MESSAGE_TALK_FAILED);
                                stopProgressDialog();
                            }
                        }, new CameraPlayerRecordVolumeListener() {
                            @Override
                            public void onCameraPlayerRecordvolume(int volume) {

                            }

                            @Override
                            public void error(String error) {

                            }
                        });
                    } else {
                        cameraPlayer.stopvoicetalk(new CameraPlayerListener() {
                            @Override
                            public void PPSuccessHandler(String successMsg) {
                                stopProgressDialog();
                            }

                            @Override
                            public void PPFailureError(String errorMsg) {
                                stopProgressDialog();
                            }
                        });
                    }
                }
                break;
        }
    }

    /**
     * 门铃挂断时间处理
     */
    private void onBellHangUp() {
        startProgressDialog();
        if (getProgressDialog() != null)
            getProgressDialog().setCancelable(false);
        MeariUser.getInstance().postHangUpBell(bellInfo.getDeviceID(), this, new IResultCallback() {
            @Override
            public void onSuccess() {
                startProgressDialog();
                //判断当前是否已接听
                if (rl_bellcall.getVisibility() == View.GONE) {
                    //接听之后的挂断
                    //关闭页面
                    //一定要设置成false，否则用户需要点击两次才能关闭页面

                } else {
                    //未接听的挂断
                    if (bellInfo.getBellVoiceURL() != null && !bellInfo.getBellVoiceURL().equals("")) {
                        //弹出是否播放语言留言对话框
                        wordDialog = CommonUtils.showDlg(BellCallActivity.this, getString(R.string.app_meari_name), getString(R.string.str_needPlayWord),
                                getString(R.string.ok), positiveListener, getString(R.string.cancel), negativeListener, false);
                    } else {
                        //关闭页面
                        //一定要设置成false，否则用户需要点击两次才能关闭页面
                        mIsStoppedByAMSOnce = false;
                        finish();
                    }
                }
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
                mIsStoppedByAMSOnce = false;
                finish();
                return;
            }
        });

        JPushInterface.clearAllNotifications(BellCallActivity.this);
    }

    /**
     * 门铃接听事件处理
     */
    /**
     * 门铃接听事件处理
     */
    private void onBellAnswer() {
        startProgressDialog();
        MeariUser.getInstance().postAnswerBell(bellInfo.getDeviceID(),String.valueOf(bellInfo.getMsgID()), this, new IStringResultCallback() {
            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
                if (code == 1050) {
                    mIsStoppedByAMSOnce = false;
                    finish();
                    return;
                } else if (code == 1045) {
                    //有人已接听
                    CommonUtils.showDialog(BellCallActivity.this, getString(R.string.call_warning), closeClick, false);
                    return;
                }
            }

            @Override
            public void onSuccess(String result) {
                stopProgressDialog();
                handler.sendEmptyMessage(MSG_ACCEPT);
                //开启定时器，每20s发一次心跳
                if (keepAliveTimer == null) {
                    keepAliveTimer = new Timer();
                    keepAliveTimer.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            sendBellKeepAlive();
                        }
                    }, 0, 10 * 1000);
                }
            }
        });
    }

    /**
     * 用户点击新的门铃来电，进行重置本页面
     */
    private void resetCall() {
        //显示加载条
        loadingView.setVisibility(View.VISIBLE);
        //隐藏自己
        iv_refresh.setVisibility(View.GONE);
        BaseJSONObject jsonObject = (BaseJSONObject) rl_callcall.getTag();
        if (jsonObject != null) {
            CameraInfo info = JsonUtil.getCameraInfo(jsonObject);
            //替换之前的门铃信息
            bellJsonInfo = jsonObject;
            bellInfo = info;
            tv_voice_status.setVisibility(View.VISIBLE);
            gif_voice.setVisibility(View.GONE);
            //隐藏二级通知栏，收回去
            rl_callcall.setTranslationY(-rl_callcall.getHeight());
            if (rl_bellcall.getVisibility() == View.GONE) {
                //如果处于接听状态
                rl_bellcall.setVisibility(View.VISIBLE);
                //设置设备名称
                tv_bellName.setText(info.getDeviceName());
                tv_name.setText(info.getDeviceName());

                //换预览头像
                sdv_preview.setImageURI(jsonObject.optString("imgUrl"));

                //播放铃铛声音,暂定为不再播放
//            if (soundPool != null) {
//                soundPool.stop(1);
//                soundPool.play(1, 0.5f, 0.5f, 0, 3, 1);
//            }
            } else {
                //如果处于未接听状态
                //播放铃铛声音
//            if (soundPool != null) {
//                soundPool.stop(1);
//                soundPool.play(1, 0.5f, 0.5f, 0, 3, 1);
//            }
                //换预览头像
                sdv_preview.setImageURI(jsonObject.optString("imgUrl"));
                //换设备名称
                tv_bellName.setText(info.getDeviceName());
                tv_name.setText(info.getDeviceName());

            }

            //挂断之前的连接
            cameraPlayer.disconnectIPC(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    //去重连设备
                    if (handler == null)
                        return;
                    cameraPlayer.setCameraInfo(bellInfo);
                    connectIPC();
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    //去重连设备
                    if (handler == null)
                        return;
                    cameraPlayer.setCameraInfo(bellInfo);
                    connectIPC();
                }
            });
            isConnect = false;

        }

    }

    @Override
    protected void onDestroy() {
        Logger.i(TAG, "===onDestroy===");
        if (noticeTimer != null) {
            noticeTimer.cancel();
            noticeTimer = null;
        }
        //如果有通知栏，则干掉它
        NotificationManager manager = (NotificationManager)
                getSystemService(NOTIFICATION_SERVICE);
        manager.cancel(NOTICE_ID);
        stopProgressDialog();
        //重置页面
        Log.e("BellCallActivity", "ppsljh start disconnectIPC" + System.currentTimeMillis());
        if (cameraPlayer != null) {
            cameraPlayer.disconnectIPC(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    Log.e("BellCallActivity", "ppsljh end disconnectIPC " + System.currentTimeMillis());
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    Log.e("BellCallActivity", "ppsljh end disconnectIPC " + System.currentTimeMillis());
                }
            });
        }
        //停止震动
        CommonUtils.virateCancel(this);
        //停止铃铛声音
        if (soundPool != null) {
            soundPool.stop(soundID);
            //清理内存
            soundPool.release();
        }
        //关闭对话框
        if (wordDialog != null) {
            wordDialog.dismiss();
        }
        super.onDestroy();
    }

    @Override
    public void onPause() {
        //支持双向语音
        //支持双向语音
        closeSpeaker();

        super.onPause();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_BACK:
                Log.i(TAG, "===finish===");
                //关闭自己
                //一定要设置成false，否则用户需要点击两次才能关闭页面
                JPushInterface.clearAllNotifications(this);
                //挂断
                onBellHangUp();
                mIsStoppedByAMSOnce = false;
                finish();
                return true;
        }
        return super.onKeyDown(keyCode, event);
    }


    /**
     * 发心跳包
     */
    private void sendBellKeepAlive() {
        //发送心跳,保持设备在线
        MeariUser.getInstance().postSendBellHeartBeat(this, bellInfo.getDeviceID());
    }


    public CameraInfo getBellInfo() {
        return bellInfo;
    }

    /**
     * call了又call监听
     */
    public class CallReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            //获取最新的门铃设备信息
            String data = intent.getExtras().getString("bellInfo");
            Log.i(TAG, "call了又call==>" + data);
            try {
                BaseJSONObject dataJson = new BaseJSONObject(data);
                CameraInfo tmpBellInfo = JsonUtil.getCameraInfo(dataJson);
                //判断是否为同一个消息
                if (dataJson.optString("msgID").equals(bellJsonInfo.optString("msgID"))) {
                    //判断第一次收到的MQTT消息中是否包含图片信息
                    String imgUrl = bellJsonInfo.getString("imgUrl");
                    if (imgUrl == null || imgUrl.equals("")) {
                        //判断第二次传来的MQTT消息中是否包含图片信息
                        imgUrl = dataJson.getString("imgUrl");
                        if (imgUrl != null && !imgUrl.equals("")) {
                            //刷新图片
                            Message refreshImgMsg = Message.obtain();
                            refreshImgMsg.obj = imgUrl;
                            refreshImgMsg.what = MSG_REFRESH_IMG;
                            if (handler != null)
                                handler.sendMessage(refreshImgMsg);
                        }
                    } else {
                        //不管新消息

                    }
                } else if (!tmpBellInfo.getSnNum().equals(bellInfo.getSnNum())) {
                    //判断是否为同一台设备
                    //弹出通知栏
                    Message msg = Message.obtain();
                    msg.obj = dataJson;
                    msg.what = MSG_CALLCALL;
                    if (handler != null)
                        handler.sendMessage(msg);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }

        }
    }

    /**
     * 关闭扬声器
     */
    public void closeSpeaker() {
        try {
            AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
            audioManager.setMode(AudioManager.MODE_NORMAL);
            if (audioManager.isSpeakerphoneOn()) {
                audioManager.setSpeakerphoneOn(false);
                audioManager.setStreamVolume(AudioManager.STREAM_VOICE_CALL, currVolume,
                        AudioManager.STREAM_VOICE_CALL);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
