package com.meari.test;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.interfaces.DraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.callback.IResultCallback;
import com.meari.sdk.callback.IUploadAudioCallback;
import com.meari.test.common.Constant;
import com.meari.test.permission_utils.Func;
import com.meari.test.permission_utils.PermissionUtil;
import com.meari.test.utils.AudioUtil;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.Logger;
import com.meari.test.widget.DragDelView;
import com.meari.test.widget.RoundProgressBar;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

public class WordActivity extends BaseActivity {

    private static final String TAG = "WordActivity";
    @BindView(R.id.ddv)
    DragDelView ddv;//左滑删除控件

    //录音UI
    final static int STATE_PRE_RECORD = 0;//预备录制状态
    final static int STATE_RECORD = 1;//长按录制状态
    final static int STATE_PLAY = 2;//长按释放试听录音状态
    final static int STATE_PRE_PLAY = 3;//预试听播放状态
    final static int STATE_DISABLE = 4;//不可录制状态，界面为灰色
    int recordState = STATE_PRE_RECORD;//默认为预录制状态
    @BindView(R.id.iv_center)
    ImageView iv_center;
    @BindView(R.id.rpb_countdown)
    RoundProgressBar rpb_countdown;
    int progress = 0;//倒计时进度
    final static int TIME_COUNTDOWN = 30;//默认倒计时时长60s
    CountDownTimer countdownTimer;//倒计时计时器
    @BindView(R.id.iv_ok)
    ImageView iv_ok;
    @BindView(R.id.iv_cancel)
    ImageView iv_cancel;
    Animator playAnimator;//试听动画
    AnimatorSet preRecordAnim;
    @BindView(R.id.iv_play)
    ImageView iv_play;//中心播放按钮，默认不显示
    @BindView(R.id.gif_playrecord)
    SimpleDraweeView gif_playrecord;//控制试听动画

    //本地录音
    String wordFileDir;//录音文件目录
    String pcmFilePath;
    String g711uFilePath;
    String wavFilePath;
    CameraPlayer cameraPlayer;
    CameraInfo cameraInfo;

    //语言留言下载地址，包含时间信息
    String wordURL = "";
    String fileTime = "";
    /**
     * 录音文件日期，时间
     */
    String wordDate, wordTime;
    String voiceDate;//当前录音时间

    //权限相关
    PermissionUtil.PermissionRequestObject mStoragePermissionRequest;
    PermissionUtil.PermissionRequestObject mRecordPermissionRequest;
    public static final String WRITE_EXTERNAL_STORAGE = android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
    public static final String RECORD_AUDIO = android.Manifest.permission.RECORD_AUDIO;

    final static int CODE_WRITE_FILE_PERMISSION = 110;
    final static int CODE_RECORD_AUDIO_PERMISSION = 120;

    //消息传递
    final static int MSG_UPDATE_PROGRESS = 0x1001;//通知设置倒计时进度
    final static int MSG_START_PLAY = 0x1002;//试听录音
    final static int MSG_PRE_PLAY = 0x1003;//预试听录音
    final static int MSG_HIDE_GIF = 0x1004;//隐藏左滑删除控件中的gif
    final static int MSG_SHOW_DOWN_DLG = 0x1005;//显示下载对话框
    final static int MSG_HIDE_DOWN_DLG = 0x1006;//隐藏下载对话框
    final static int MSG_DOWNLOAD_SUCCESS = 0x1007;//留言下载成功
    final static int MSG_DOWNLOAD_FAILED = 0x1008;//留言下载失败
    final static int MSG_UPLOAD_WORD = 0x1009;//上传语音留言文件
    final static int MSG_UPLOAD_WORD_SUCCESS = 0x1010;//上传语音留言文件成功
    final static int MSG_PRE_RECORD = 0x1011;//设置成预录制状态
    final static int MSG_DEL_WORD_SUCCESS = 0x1012;//向服务器删除语音留言成功
    @SuppressLint("HandlerLeak")
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MSG_UPDATE_PROGRESS:
                    progress += 1;
                    rpb_countdown.setProgress(progress);
                    if (progress >= 300) {
                        //如果已经到了30s,取消录音
                        countdownTimer.cancel();
                        handler.sendEmptyMessage(MSG_PRE_PLAY);
                    }
                    break;
                case MSG_PRE_PLAY:
                    //重置iv_center宽度、高度
                    iv_center.setScaleX(1f);
                    iv_center.setScaleY(1f);
                    //取消定时器
                    if (countdownTimer != null) {
                        countdownTimer.cancel();
                    }
                    //取消录制
                    cameraPlayer.stopRecordVoice();
                    //隐藏倒计时
                    rpb_countdown.setProgress(0);
                    rpb_countdown.setVisibility(View.GONE);
                    //中心录音按钮消失
                    iv_center.setVisibility(View.GONE);
                    //中心按钮图片显示，这样做可以不用考虑ontouch和onclick相冲，方便些
                    iv_play.setVisibility(View.VISIBLE);
                    //加载动画

                    //显示ok、cancel按钮
                    iv_cancel.setVisibility(View.VISIBLE);
                    iv_ok.setVisibility(View.VISIBLE);
                    break;
                case MSG_START_PLAY:
                    //开启动画
                    gif_playrecord.setVisibility(View.VISIBLE);
                    //开启试听线程
                    AudioUtil.getInstance().playPCM(pcmFilePath);
                    //监听是否播放结束
                    AudioUtil.getInstance().setOnPlayListener(new AudioUtil.OnPlayListener() {
                        @Override
                        public void isOver(boolean flag) {
                            //播放结束,隐藏ddv的播放动画
                            handler.sendEmptyMessage(MSG_HIDE_GIF);
                        }
                    });
                    break;
                case MSG_HIDE_GIF:
                    ddv.setGifVisiable(false);
                    gif_playrecord.setVisibility(View.GONE);
                    break;
                case MSG_SHOW_DOWN_DLG:
                    //开启对话框
                    startProgressDialog();
                    break;
                case MSG_HIDE_DOWN_DLG:
                    stopProgressDialog();
                    break;
                case MSG_DOWNLOAD_SUCCESS:
                    //文件下载成功
                    //设置ddv可见
                    ddv.setVisibility(View.VISIBLE);
                    //转换文件格式
                    cameraPlayer.changeG711u2Pcm(wavFilePath, pcmFilePath, new CameraPlayerListener() {
                        @Override
                        public void PPSuccessHandler(String successMsg) {
                            //转换成功,关闭对话框
                            handler.sendEmptyMessage(MSG_HIDE_DOWN_DLG);
                        }

                        @Override
                        public void PPFailureError(String errorMsg) {
                            //提示失败

                        }
                    });

                    break;
                case MSG_DOWNLOAD_FAILED:
                    //文件下载失败,提示失败
                    CommonUtils.showToast(R.string.download_failed);
                    stopProgressDialog();
                    break;
                case MSG_UPLOAD_WORD:
                    //上传语音留言文件
                    //录音文件上传服务器
                    startProgressDialog();
                    File wavFile = new File(wavFilePath);
                    List<File> fileList = new ArrayList<>();
                    fileList.add(wavFile);
                    if (wavFile.exists()) {
                        MeariUser.getInstance().uploadAudioWord(cameraInfo.getDeviceID(), voiceDate, fileList,this , new IUploadAudioCallback() {
                            @Override
                            public void onSuccess(String path) {
                                stopProgressDialog();
                                wordURL = path;
                                handler.sendEmptyMessage(MSG_UPLOAD_WORD_SUCCESS);
                            }

                            @Override
                            public void onError(int code, String error) {
                                showToast(error);
                            }
                        });
                    }
                    break;
                case MSG_UPLOAD_WORD_SUCCESS:
                    CommonUtils.showToast(R.string.upload_word_success);
                    //设置文字
                    decodeURL();
                    //关闭加载框
                    stopProgressDialog();
                    break;
                case MSG_PRE_RECORD:
                    //设置ddv控件不可见
                    ddv.setVisibility(View.GONE);
                    //进度条不可见
                    rpb_countdown.setProgress(0);
                    rpb_countdown.setVisibility(View.GONE);
                    //录制按钮变为可用状态
                    iv_center.setEnabled(true);
                    iv_center.setScaleX(1f);
                    iv_center.setScaleY(1f);
                    iv_center.setImageResource(R.mipmap.img_record);
                    recordState = STATE_PRE_RECORD;
                    break;
                case MSG_DEL_WORD_SUCCESS:
                    //提示删除成功
                    CommonUtils.showToast(R.string.delete_success);
                    //关闭加载框
                    stopProgressDialog();
                    break;
                default:
                    break;
            }
        }
    };

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case CODE_WRITE_FILE_PERMISSION:
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //授权成功
                    Log.i(TAG, "写文件权限==授权成功");
                } else {
                    //提示授权失败，关闭页面
                    Log.i(TAG, "写文件权限==授权失败");
                }
                break;
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
     * 检查是否有写文件权限
     */
    public void checkStroagePermission() {
        boolean hasStoragePermission = PermissionUtil.with(this).has(WRITE_EXTERNAL_STORAGE);
        if (!hasStoragePermission) {
            mStoragePermissionRequest = PermissionUtil.with(this).request(WRITE_EXTERNAL_STORAGE).onAllGranted(
                    new Func() {
                        @Override
                        protected void call() {

                        }
                    }).onAnyDenied(
                    new Func() {
                        @Override
                        protected void call() {
                        }
                    }).ask(CODE_WRITE_FILE_PERMISSION);
        } else {
            checkRecordPermission();
        }

    }

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
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_word);

        //请求权限
        checkStroagePermission();

        initData();

        //初始化topBar
        initTopBar();

        initView();

        //记得删
        cameraPlayer = new CameraPlayer();
    }

    private void initData() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        voiceDate = sdf.format(new Date());

        //初始化本地留言文件路径
        wordFileDir = Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount() + "/word";
        File tmpDir = new File(wordFileDir);
        if (!tmpDir.exists()) {
            //创建目录
            tmpDir.mkdirs();
        }

        //获取设备信息
        cameraInfo = (CameraInfo) getIntent().getSerializableExtra("cameraInfo");
        wordURL = cameraInfo.getBellVoiceURL();
        Logger.i(TAG, "start wordURL===>" + wordURL);
        //解析url中的文件名
        if (wordURL != null && !wordURL.equals("")) {
            fileTime = decodeURL();
            voiceDate = fileTime;
            pcmFilePath = wordFileDir + "/word" + voiceDate + ".pcm";
            g711uFilePath = wordFileDir + "/word" + voiceDate + ".g711";
            wavFilePath = wordFileDir + "/word" + voiceDate + ".wav";
            //如果本地没有录音
            File[] wordFiles = tmpDir.listFiles();
            Logger.i(TAG, "wordFiles===>" + wordFiles.toString());
            if (wordFiles.length == 0) {
                Logger.i(TAG, "下载录音文件");
                //显示加载对话框，不可取消
                handler.sendEmptyMessage(MSG_SHOW_DOWN_DLG);
                //去下载录音文件
                downloadWord();
                recordState = STATE_DISABLE;
            } else {
                boolean flag = true;//判断录音文件是否相同的标识
                //本地有录音文件,对比录音文件是否相同，根据文件名中的时间判断
                for (File tmpFile : wordFiles) {
                    String tmpFileName = tmpFile.getName();
                    int start = tmpFileName.indexOf("d");
                    int end = tmpFileName.indexOf(".");
                    String tmpFileTime = tmpFileName.substring(start + 1, end);
                    if (!tmpFileTime.equals(fileTime)) {
                        //文件不同，删除之
                        Log.i(TAG, "tmpFileTime===>" + tmpFileTime);
                        Log.i(TAG, "fileTime===>" + fileTime);
                        Log.i(TAG, "del file===>" + tmpFile.getName());
                        tmpFile.delete();
                        flag = false;
                    }
                }
                if (flag == false) {
                    //显示加载对话框，不可取消
                    handler.sendEmptyMessage(MSG_SHOW_DOWN_DLG);
                    //去下载录音文件
                    downloadWord();
                    recordState = STATE_DISABLE;
                } else {
                    //不用重复下载，显示本地的录音文件
                    recordState = STATE_DISABLE;
                }
            }
        } else {
            //删除本地所有后缀为wav、pcm、g711的文件
            if (tmpDir.exists()) {
                File[] wordFiles = tmpDir.listFiles();
                for (File tmpFile : wordFiles) {
                    tmpFile.delete();
                }
            }
            pcmFilePath = wordFileDir + "/word" + voiceDate + ".pcm";
            g711uFilePath = wordFileDir + "/word" + voiceDate + ".g711";
            wavFilePath = wordFileDir + "/word" + voiceDate + ".wav";
            //第一次录留言,此时可以录音
            recordState = STATE_PRE_RECORD;
        }
    }

    /**
     * 下载语音留言文件
     */
    private void downloadWord() {
        String destFileDir = Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount() + "/word";
        String destFileName = "word" + fileTime + ".wav";
//        MeariSdk.getInstance().getBellAudioFile(wordURL,destFileDir,){
//
//        }
//        OkGo.get(wordURL)
//                .execute(new FileCallback(destFileDir, destFileName) {
//                    @Override
//                    public void onSuccess(File file, Call call, Response response, int id) {
//                        //下载成功
//                        handler.sendEmptyMessage(MSG_DOWNLOAD_SUCCESS);
//                    }
//
//                    @Override
//                    public void downloadProgress(long currentSize, long totalSize, float progress, long networkSpeed) {
//                        super.downloadProgress(currentSize, totalSize, progress, networkSpeed);
//                    }
//
//                    @Override
//                    public void onError(Call call, Response response, Exception e, int id) {
//                        super.onError(call, response, e, id);
//                        //下载失败
//                        handler.sendEmptyMessage(MSG_DOWNLOAD_FAILED);
//                    }
//                });
    }

    /**
     * 解析留言url，获取时间信息
     */
    String decodeURL() {
        int index = wordURL.lastIndexOf("/") + 1;
        String fileName = wordURL.substring(index, wordURL.length());
        //获取时间
        int start = fileName.lastIndexOf("-") + 1;
        int end = fileName.lastIndexOf(".");
        String allTime = fileName.substring(start, end);
        //获取日期
        String date = allTime.substring(0, 8);
        //获取时间
        String time = allTime.substring(8, allTime.length());

        //国际化，获取语言版本
        String lang = CommonUtils.getLangType(this);
        if (lang.equals("zh")) {
            //加年月日
            StringBuilder dateBuilder = new StringBuilder(date);
            //注意插入的时候要倒序
            dateBuilder.insert(8, "日");
            dateBuilder.insert(6, "月");
            dateBuilder.insert(4, "年");
            wordDate = dateBuilder.toString();
        } else {
            //其它国家的则显示为形如：08/03/2017
            String year = date.substring(0, 4);
            String month = date.substring(4, 6);
            String day = date.substring(6, 8);
            wordDate = month + "/" + day + "/" + year;
        }
        //加冒号
        StringBuilder timeBuilder = new StringBuilder(time);
        timeBuilder.insert(4, ":");
        timeBuilder.insert(2, ":");
        wordTime = timeBuilder.toString();
        //设置控件年月日
        ddv.setVisibility(View.VISIBLE);
        ddv.setDateText(wordDate);
        ddv.setTimeText(wordTime);

        return allTime;
    }

    private void initView() {

        if (recordState == STATE_DISABLE) {
            //如果不可录制
            iv_center.setImageResource(R.mipmap.img_record_unable);
            iv_center.setEnabled(false);
            ddv.setVisibility(View.VISIBLE);
        } else if (recordState == STATE_PRE_RECORD) {
            //当前准备录制
            ddv.setVisibility(View.GONE);
            iv_center.setImageResource(R.mipmap.img_record);
            iv_center.setEnabled(true);
        }

        //设置ddv点击事件
        setDDVClick();

        rpb_countdown.setMax(300);//30s*10

        //设置录音的ontouch
        setIvCenterOnTouch();

        //初始化预录音动画
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(iv_center, "scaleX", 1f, 1.2f);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(iv_center, "scaleY", 1f, 1.2f);
        preRecordAnim = new AnimatorSet();
        preRecordAnim.setTarget(iv_center);
        preRecordAnim.setDuration(300);
        preRecordAnim.play(scaleX).with(scaleY);
        preRecordAnim.addListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animation) {
                Log.i(TAG, "===anim start===");
            }

            @Override
            public void onAnimationEnd(Animator animation) {
                Log.i(TAG, "===anim end===");
            }

            @Override
            public void onAnimationCancel(Animator animation) {
                Log.i(TAG, "===anim cancel===");
            }

            @Override
            public void onAnimationRepeat(Animator animation) {
                Log.i(TAG, "===anim repeat===");
            }
        });

        //初始化gif试听动画
        DraweeController mDraweeController = Fresco.newDraweeControllerBuilder()
                .setAutoPlayAnimations(true)
                .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.gif_playrecord_circle))//设置uri
                .build();
        gif_playrecord.setController(mDraweeController);
        gif_playrecord.setVisibility(View.GONE);

    }

    @OnClick({R.id.iv_ok, R.id.iv_cancel, R.id.iv_play})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_play:
                //播放录音
                handler.sendEmptyMessage(MSG_START_PLAY);
                break;
            case R.id.iv_ok:
                //先暂停
                AudioUtil.getInstance().stopPlayPCM();
                //隐藏掉ok、cancel
                this.iv_cancel.setVisibility(View.GONE);
                this.iv_ok.setVisibility(View.GONE);
                //显示加载框
                startProgressDialog();
                //转换成wav文件
                cameraPlayer.changeG711u2WAV(g711uFilePath, wavFilePath, new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        //转换成功,上传wav文件
                        handler.sendEmptyMessage(MSG_UPLOAD_WORD);
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        //提示失败

                    }
                });
                //显示右滑删除控件
                ddv.setVisibility(View.VISIBLE);
                //设置时间
                SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy年MM月dd日");
                ddv.setDateText(sdfDate.format(new Date()));
                SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm:ss");
                ddv.setTimeText(sdfTime.format(new Date()));
                //中心按钮变灰
                iv_center.setImageResource(R.mipmap.img_record_unable);
                iv_center.setVisibility(View.VISIBLE);
                iv_center.setEnabled(false);//不可点击
                iv_play.setVisibility(View.GONE);

                //取消动画
                if (playAnimator != null) {
                    playAnimator.cancel();
                }
                //改变录音状态
                recordState = STATE_DISABLE;//此时无法录制
                break;
            case R.id.iv_cancel:
                //先暂停
                AudioUtil.getInstance().stopPlayPCM();
                //删除录音文件
                File pcmFile = new File(pcmFilePath);
                File g711uFile = new File(g711uFilePath);
                if (pcmFile.exists()) {
                    //删除
                    pcmFile.delete();
                }
                if (g711uFile.exists()) {
                    //删除
                    g711uFile.delete();
                }
                if (countdownTimer != null) {
                    countdownTimer.cancel();
                    countdownTimer = null;
                }
                //隐藏ok、cancel
                this.iv_cancel.setVisibility(View.GONE);
                this.iv_ok.setVisibility(View.GONE);
                //中心按钮复原
                iv_center.setVisibility(View.VISIBLE);
                //中心播放按钮隐藏
                iv_play.setVisibility(View.GONE);

                //取消动画
                if (playAnimator != null) {
                    playAnimator.cancel();
                }
                //删除录音文件
                //改变录音状态
                recordState = STATE_PRE_RECORD;
                break;
        }
    }

    /**
     * 中心录音按钮的touch事件
     */
    private void setIvCenterOnTouch() {
        iv_center.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                //开启动画
                preRecordAnim.start();
                //改变状态
                recordState = STATE_RECORD;
                //删掉之前的录音pcm和g711

                //显示进度条
                progress = 0;//清空进度条
                rpb_countdown.setVisibility(View.VISIBLE);
                //开始录音
                cameraPlayer.startRecordVoice(pcmFilePath, g711uFilePath);
                if (countdownTimer == null) {
                    countdownTimer = new CountDownTimer(TIME_COUNTDOWN * 1000, 100) {
                        @Override
                        public void onTick(long l) {
                            handler.sendEmptyMessage(MSG_UPDATE_PROGRESS);
                        }

                        @Override
                        public void onFinish() {
                            //时间到
                            progress = 0;
                            //变成预录制状态
                            recordState = STATE_PRE_PLAY;
                            //设置成预试听状态
                            handler.sendEmptyMessage(MSG_PRE_PLAY);
                        }
                    };
                    countdownTimer.start();
                }

                return false;
            }
        });

        iv_center.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:

                        break;
                    case MotionEvent.ACTION_MOVE:

                        break;
                    case MotionEvent.ACTION_UP:
                        //正在录制状态才去响应UP事件
                        if (recordState == STATE_RECORD) {
                            //改变状态
                            recordState = STATE_PLAY;
                            //录音结束
                            //如果没有文件，说明之前没有权限，提示用户录制失败
                            File tmpDir = new File(wordFileDir);
                            //删除本地所有后缀为wav、pcm、g711的文件
                            if (tmpDir.exists()) {
                                File[] wordFiles = tmpDir.listFiles();
                                if (wordFiles.length == 0) {
                                    cameraPlayer.stopRecordVoice();
                                    //提示录制失败，请重试
                                    CommonUtils.showToast(R.string.toast_recordFailed);
                                    if (countdownTimer != null) {
                                        countdownTimer.cancel();
                                        countdownTimer = null;
                                    }
                                    progress = 0;
                                    //变成预录制状态
                                    recordState = STATE_PRE_RECORD;
                                    //设置成预录制状态
                                    handler.sendEmptyMessage(MSG_PRE_RECORD);
                                    return false;
                                }
                            }
                            //判断录音时间，如果小于1s则提示失败
                            if (progress < 10) {
                                cameraPlayer.stopRecordVoice();
                                CommonUtils.showToast(R.string.toast_recordTooShort);
                                //删除文件
                                //删除本地所有后缀为wav、pcm、g711的文件
                                if (tmpDir.exists()) {
                                    File[] wordFiles = tmpDir.listFiles();
                                    for (File tmpFile : wordFiles) {
                                        tmpFile.delete();
                                    }
                                }
                                if (countdownTimer != null) {
                                    countdownTimer.cancel();
                                    countdownTimer = null;
                                }
                                progress = 0;
                                //变成预录制状态
                                recordState = STATE_PRE_RECORD;
                                //设置成预录制状态
                                handler.sendEmptyMessage(MSG_PRE_RECORD);
                                return false;
                            }
                            cameraPlayer.stopRecordVoice();
                            if (countdownTimer != null) {
                                countdownTimer.cancel();
                            }
                            progress = 0;
                            handler.sendEmptyMessage(MSG_PRE_PLAY);
                        }

                        break;
                }
                return false;
            }
        });
    }

    private void setDDVClick() {
        //点击播放逻辑
        ddv.setOnMainClickListener(new DragDelView.MainClickListener() {
            @Override
            public void onClick(View view) {
                //播放录音试听预览
                ddv.setGifVisiable(true);//显示播放动画
                AudioUtil.getInstance().playPCM(pcmFilePath);
                AudioUtil.getInstance().setOnPlayListener(new AudioUtil.OnPlayListener() {
                    @Override
                    public void isOver(boolean flag) {
                        //播放结束,隐藏ddv的播放动画
                        handler.sendEmptyMessage(MSG_HIDE_GIF);
                    }
                });
            }
        });
        //点击删除逻辑
        ddv.setOnDeleteClickListener(new DragDelView.DeleteClickListener() {
            @Override
            public void onClick(View view) {
                //开启加载框
                startProgressDialog();
                //暂停播放录音
                AudioUtil.getInstance().stopPlayPCM();
                //删除录音文件
                File pcmFile = new File(pcmFilePath);
                File g711uFile = new File(g711uFilePath);
                File wavFile = new File(wavFilePath);
//                Log.i("PUPU", "DEL pcmFilePath===>" + pcmFilePath);
                if (pcmFile.exists()) {
                    //删除
                    pcmFile.delete();
                }
                if (g711uFile.exists()) {
                    //删除
                    g711uFile.delete();
                }
                if (wavFile.exists()) {
                    //删除
                    wavFile.delete();
                }
                //重置文件时间
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                voiceDate = sdf.format(new Date());
                pcmFilePath = wordFileDir + "/word" + voiceDate + ".pcm";
                g711uFilePath = wordFileDir + "/word" + voiceDate + ".g711";
                wavFilePath = wordFileDir + "/word" + voiceDate + ".wav";
                if (countdownTimer != null) {
                    countdownTimer.cancel();
                    countdownTimer = null;
                }
                MeariUser.getInstance().deleteAudioWord(cameraInfo.getDeviceID(),this , new IResultCallback() {
                    @Override
                    public void onSuccess() {
                        stopProgressDialog();
                        handler.sendEmptyMessage(MSG_DEL_WORD_SUCCESS);
                        //wordurl置空
                        wordURL = "";
                    }

                    @Override
                    public void onError(int code, String error) {
                        stopProgressDialog();
                        CommonUtils.showToast(error);
                    }
                });
                //设置成预录制状态
                handler.sendEmptyMessage(MSG_PRE_RECORD);
            }
        });
    }

    @Override
    protected void onPause() {
        super.onPause();
        //如果在录音，则做废弃处理
        if (recordState == STATE_RECORD) {
            //停止录音
            cameraPlayer.stopRecordVoice();
            //删除录音文件
            File pcmFile = new File(pcmFilePath);
            File g711uFile = new File(g711uFilePath);
            File wavFile = new File(wavFilePath);
//            Log.i("PUPU", "DEL pcmFilePath===>" + pcmFilePath);
            if (pcmFile.exists()) {
                //删除
                pcmFile.delete();
            }
            if (g711uFile.exists()) {
                //删除
                g711uFile.delete();
            }
            if (wavFile.exists()) {
                //删除
                wavFile.delete();
            }
            //设置成预录制状态
            recordState = STATE_PRE_RECORD;
            handler.sendEmptyMessage(MSG_PRE_RECORD);
        }
        //如果正在播放，则停止播放
        if (recordState == STATE_PLAY) {
            //停止播放录音
            AudioUtil.getInstance().stopPlayPCM();
        }
    }

    /**
     * 初始化topbar
     */
    private void initTopBar() {
        getTopTitleView();
        //后期记得修改，appcompat包冲突的bug（猜想）
        if (this.mCenter == null) {
            return;
        }
        this.mCenter.setText(getString(R.string.voice_reminder));
        this.mRightBtn.setVisibility(View.GONE);
        this.mBackBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //返回给上个页面wordurl
                Intent it = new Intent();
                it.putExtra("wordURL", wordURL);
                setResult(RESULT_OK, it);
                finish();
            }
        });
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            Intent it = new Intent();
            it.putExtra("wordURL", wordURL);
            setResult(RESULT_OK, it);
            finish();
            return false;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //关闭录音
        AudioUtil.getInstance().stopPlayPCM();
    }
}

