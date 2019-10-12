package com.meari.test;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.PixelFormat;
import android.media.AudioManager;
import android.net.wifi.WifiInfo;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.RequiresApi;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.DeviceUpgradeInfo;
import com.meari.sdk.callback.ICheckNewFirmwareForDevCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.adapter.FragmentTabsAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.common.PromptSharedPreferences;
import com.meari.test.common.VideoPlayCallback;
import com.meari.test.fragment.BabyMonitorPreviewFragment;
import com.meari.test.fragment.BellPreviewFragment;
import com.meari.test.fragment.PlaybackFragment;
import com.meari.test.fragment.SingleVideoPreviewFragment;
import com.meari.test.fragment.VideoFragment;
import com.meari.test.receiver.WifiReceiver;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import java.util.ArrayList;

import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/26
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class SingleVideoActivity extends PlayVideoActivity implements VideoPlayCallback, WifiReceiver.WifiChangeListener {
    private static final String TAG = "SingleVideoActivity";
    private final int MESSAGE_CONNECT_SUCCESS = 1001;
    private final int MESSAGE_LOGIN_FAILED = 1002;
    private final int MESSAGE_CHANGE_TAB_PREVIEW = 1003;
    private final int MESSAGE_CHANGE_TAB_PLAYBACK = 1004;
    private final int MSG_SEND_WAKE_UP_DATA = 1005;
    private final int MSG_DISCONNECT_BELL = 1006;
    private final int MSG_START_BELL_TIMER = 1007;
    private final int STATUS_PREVIEW = 0;
    public static final int STATUS_PLAYBACK_SD = 1;
    public static final int STATUS_PLAYBACK_CLOUD = 2;
    private CameraInfo mCameraInfo;
    public static final int STATUS_LOADING = 0;
    public static final int STATUS_REFRESH = 1;
    public static final int STATUS_PLAY = 2;
    public static final int STATUS_PLAYING = 3;
    public static final int STATUS_NONE = 4;
    public static final int STATUS_LOGIN_FAILED = -1;
    private final int TYPE_PREVIEW = 0;
    private final int TYPE_PLAY_BACK = 1;
    private int mPlaybackType;
    /**
     * uninit -1
     * connecting 0
     * connectted 1
     * failed -2
     */
    private int mConnectStatus = -1;
    /**
     * 0 preview, 1 SD or NVR playback 2Cloud playback
     */
    private int mType;
    private CameraPlayer mCurPlayer;
    private TextView mPreviewTab;//preview tab
    private TextView mPlaybackTab;//playback tab
    /**
     * 0 preview, 1 SD or NVR playback orCloud playback
     */
    private VideoFragment mCurrentFragment;
    private String mSeekTime;
    private ViewPager mViewPager;
    private ArrayList<Fragment> fragmentList;
    private VideoFragment mPreviewFragment;
    private PlaybackFragment mPlaybackFragment;
    private int mSdcardStatus;
    private boolean iSSoundStatus;
    private SharedPreferences mSoundPreferences;
    private FragmentTabsAdapter mAdapter;
    private boolean mIsSleep;
    private boolean mIsFinish = false;
    public static final String SOUND_INFOS = "SOUNDINFOS";
    private WifiReceiver mReceiver;
    private PromptSharedPreferences mPsp;
    private String mSid;
    private String mSerVersion;
    private String versionDesc;
    private String mDevUrl;
    private boolean isShowedDlg;
    private int updateStatus;//是否要升级
    private String updatePersion;//是否要升级
    private DeviceUpgradeInfo mDeviceUpgradeInfo;
    CountDownTimer bellConnectTimer;//专为门铃设计的21s倒计时
    boolean isNeedRetryConnect = false;//是否需要循环打洞
    boolean isFirstConnect = true;//是否为第一次打洞
    int mMode = -1;//是否为第一次打洞
    private int mNos;
    private int currVolume;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_single_video);
        initData();
        initView();
        registerWiFiChangeReceiver();
    }

    /**
     * connect ipc
     * params: cameraInfo.uuid ,cameraInfo.name("admin"),mCameraInfo.hostKey ,callback
     */
    private void connectCamera() {
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            if (mCurrentFragment != null)
                mCurrentFragment.videoViewStatus(STATUS_LOGIN_FAILED);
            return;
        }
        mConnectStatus = 0;
        this.mCurPlayer.connectIPC2(CommonUtils.getCameraString(mCameraInfo), new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isDestroyed() || isFinishing()) {
                    return;
                }
                mConnectStatus = 1;
                if (mEventHandler != null)
                    mEventHandler.sendEmptyMessage(MESSAGE_CONNECT_SUCCESS);
            }

            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPFailureError(String errorMsg) {
                if (isDestroyed() || isFinishing()) {
                    return;
                }
                mConnectStatus = -2;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(errorMsg);
                    int errorCode = jsonObject.optInt("code", 0);
                    Message msg = Message.obtain();
                    msg.what = MESSAGE_LOGIN_FAILED;
                    msg.obj = errorCode;
                    mEventHandler.sendMessage(msg);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

    }

    /**
     * connect ipc
     * params: cameraInfo.uuid ,cameraInfo.name("admin"),mCameraInfo.hostKey ,callback
     */
    private void connectBell(boolean isNeedSendData) {
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            if (mCurrentFragment != null)
                mCurrentFragment.videoViewStatus(STATUS_LOGIN_FAILED);
            return;
        }
        mConnectStatus = 0;
        if (mEventHandler != null)
            mEventHandler.removeMessages(MSG_DISCONNECT_BELL);
        if (mCurPlayer.IsLogined())
            return;
        this.mConnectStatus = 0;
        this.mCurPlayer.connectIPC2(CommonUtils.getCameraString(mCameraInfo), new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isDestroyed() || isFinishing()) {
                    return;
                }
                mConnectStatus = 1;
                if (mEventHandler != null)
                    mEventHandler.sendEmptyMessage(MESSAGE_CONNECT_SUCCESS);
            }

            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPFailureError(String errorMsg) {
                if (isDestroyed() || isFinishing()) {
                    return;
                }
                mConnectStatus = -2;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(errorMsg);
                    int errorCode = jsonObject.optInt("code", 0);
                    Message msg = Message.obtain();
                    msg.what = MESSAGE_LOGIN_FAILED;
                    msg.obj = errorCode;
                    if (mEventHandler != null)
                        mEventHandler.sendMessage(msg);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
        if (mEventHandler != null && isNeedSendData)
            mEventHandler.sendEmptyMessageDelayed(MSG_SEND_WAKE_UP_DATA, 8000);
        if (mEventHandler != null)
            mEventHandler.sendEmptyMessageDelayed(MSG_DISCONNECT_BELL, 8000);
    }

    public void postWakeUpData() {
        MeariUser.getInstance().remoteWakeUp(mCameraInfo.getDeviceID(), this, new IResultCallback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onError(int code, String error) {

            }
        });

    }

    private void initView() {
        getWindow().setFormat(PixelFormat.TRANSLUCENT);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        initConfiguration(getResources().getConfiguration().orientation);//根据屏幕方向，显示和隐藏部分视图。
        getTopTitleView();
        this.mCenter.setText(this.mCameraInfo.getDeviceName());
        if (mCameraInfo.getDevTypeID() == 3)
            this.mRightText.setTextColor(ContextCompat.getColor(this, R.color.btn_type_yellow));
        else
            this.mRightText.setTextColor(ContextCompat.getColor(this, R.color.btn_gree_white));

        initViewById(mType);
        initTypeLayout(mType);
        initPlaybackTypeView();
        changeTab(mType);
        if (mType == TYPE_PREVIEW) {
            this.action_bar_rl.setVisibility(View.VISIBLE);
            this.mRightBtn.setVisibility(View.GONE);
        } else {
            this.action_bar_rl.setVisibility(View.GONE);
            this.mRightBtn.setVisibility(View.VISIBLE);
        }
    }


    public void setSdcardStatus(int sdStatus) {
        this.mSdcardStatus = sdStatus;
    }

    private void initViewById(int type) {
        this.mPreviewTab = findViewById(R.id.single_video_preview);
        this.mPlaybackTab = findViewById(R.id.single_video_palyback);
        if (mCameraInfo.getDevTypeID() == 3) {
            this.mPreviewTab.setBackgroundResource(R.drawable.btn_tab_baby_single);
            this.mPlaybackTab.setBackgroundResource(R.drawable.btn_tab_baby_single);
        } else {
            this.mPreviewTab.setBackgroundResource(R.drawable.btn_tab_single);
            this.mPlaybackTab.setBackgroundResource(R.drawable.btn_tab_single);
        }
        this.mViewPager = findViewById(R.id.single_video_layout);
        this.mViewPager.setOffscreenPageLimit(0);
        this.mViewPager.setEnabled(false);
        initViewPager(type);
    }

    /*
     * 初始化ViewPager
     */
    public void initViewPager(int position) {
        if (position != 0) {
            position = 1;
        }
        //给ViewPager设置适配器
        mAdapter = new FragmentTabsAdapter(getSupportFragmentManager(), fragmentList);
        mViewPager.setAdapter(mAdapter);
        mViewPager.setCurrentItem(position);
        if (position == 0) {
            mCurrentFragment = mPreviewFragment;

        } else {
            mCurrentFragment = mPlaybackFragment;
        }
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                changeTab(position);
                mViewPager.setCurrentItem(position, false);
                if (position == 0) {
                    mCurrentFragment = mPreviewFragment;

                } else {
                    mCurrentFragment = mPlaybackFragment;
                }

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });//页面变化时的监听器
    }

    private PlaybackFragment onCreatePlayBack() {
        return this.mPlaybackFragment = PlaybackFragment.newInstance(this.mSeekTime, mCameraInfo);
    }

    private void initPlaybackTypeView() {
        if (mCameraInfo.getBindingTy().equals("ND")) {
            this.mRightBtn.setImageResource(R.mipmap.ic_cloud);
            if (mCameraInfo.getDevTypeID() == 3)
                this.mRightBtn.setImageResource(R.mipmap.ic_cloud_y);
            this.mRightBtn.setTag(1);
        } else {
            this.mRightBtn.setEnabled(false);
            this.mRightBtn.setTag(0);
            if (mCameraInfo.getNvrPort() < 0) {
                this.mRightBtn.setImageResource(R.mipmap.ic_gree_sd);
                if (mCameraInfo.getDevTypeID() == 3)
                    this.mRightBtn.setImageResource(R.mipmap.ic_cloud_y);
            } else {
                this.mRightBtn.setImageResource(R.mipmap.ic_square_nvr);
                if (mCameraInfo.getDevTypeID() == 3)
                    this.mRightBtn.setImageResource(R.mipmap.ic_square_nvr_y);
            }
        }
    }

    /**
     * init tabview
     */
    private void initTypeLayout(int type) {
        if (type != STATUS_PREVIEW)
            type = STATUS_PLAYBACK_SD;
        switch (type) {
            case STATUS_PREVIEW:
                this.mPreviewTab.setEnabled(false);
                this.mPlaybackTab.setEnabled(true);
                this.mRightBtn.setVisibility(View.GONE);
                this.action_bar_rl.setVisibility(View.VISIBLE);
                break;
            case STATUS_PLAYBACK_SD:
                this.mPreviewTab.setEnabled(true);
                this.mPlaybackTab.setEnabled(false);
                this.mRightBtn.setVisibility(View.VISIBLE);
                this.action_bar_rl.setVisibility(View.GONE);
                break;
            default:
                break;
        }
    }

    /**
     * 初始化双向语音
     *
     * @param context
     */
    private void initVoice(Context context) {
        AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        mMode = audioManager.getMode();
//        int maxVolume = audioManager.getStreamMaxVolume(mStreamType);
//        audioManager.setStreamVolume(mStreamType, audioManager.getStreamVolume(mStreamType),
//                AudioManager.FLAG_PLAY_SOUND);
        if (mCameraInfo.getVtk() == 4) {
//            MwAudioSdk.setSpeakerOn(context, true);
            openSpeaker();
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

    private void initData() {
        Bundle bundle = getIntent().getExtras();

        if (bundle == null) {
            finish();
            mCurrentFragment.removeVideo();
            return;
        }
        this.mCameraInfo = (CameraInfo) bundle.getSerializable("cameraInfo");

        this.mType = bundle.getInt("type");
        this.mSeekTime = bundle.getString("time", "");

        initPlaybackType();//初始化回放类型
        fragmentList = new ArrayList<>();
        this.mPreviewFragment = onCreatePreviewFragment();//根据不同的设备类型创建不同预览界面
        this.mPlaybackFragment = onCreatePlayBack();
        fragmentList.add(mPreviewFragment);
        fragmentList.add(mPlaybackFragment);
        mSoundPreferences = getSharedPreferences(SOUND_INFOS, Context.MODE_MULTI_PROCESS);
        iSSoundStatus = mSoundPreferences.getBoolean(mCameraInfo.getSnNum(), true);
        if (NetUtil.getConnectWifiType(this) == 1) {
            CommonUtils.showToast(getResources().getString(R.string.network_mobile));
        }
        this.mPsp = new PromptSharedPreferences();


    }

    private void initPlaybackType() {
        if (mCameraInfo.getBindingTy().equals("ND"))
            mPlaybackType = STATUS_PLAYBACK_CLOUD;
        else
            mPlaybackType = STATUS_PLAYBACK_SD;
    }


    @Override
    public void onConfigurationChanged(Configuration newConfig) {

        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            fullscreen(true);
            findViewById(R.id.top_view).setVisibility(View.GONE);
            findViewById(R.id.layout_tab).setVisibility(View.GONE);
            if (mViewPager != null) {
                mViewPager.setCurrentItem(mViewPager.getCurrentItem());
            }
        } else {
            fullscreen(false);
            findViewById(R.id.top_view).setVisibility(View.VISIBLE);
            findViewById(R.id.layout_tab).setVisibility(View.VISIBLE);
            if (mViewPager != null) {
                mViewPager.setCurrentItem(mViewPager.getCurrentItem());
            }
        }
    }

    private void fullscreen(boolean enable) {
        if (enable) { //显示状态栏
            if (Build.VERSION.SDK_INT < 19) { // lower api
                View v = this.getWindow().getDecorView();
                v.setSystemUiVisibility(View.GONE);
            } else if (Build.VERSION.SDK_INT >= 19) {
                //for new api versions.
                View decorView = getWindow().getDecorView();
                int uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY | View.SYSTEM_UI_FLAG_FULLSCREEN;
                decorView.setSystemUiVisibility(uiOptions);
                getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
            }
            WindowManager.LayoutParams lp = getWindow().getAttributes();
            lp.flags |= WindowManager.LayoutParams.FLAG_FULLSCREEN;
            getWindow().setAttributes(lp);
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
        } else { //隐藏状态栏
            WindowManager.LayoutParams lp = getWindow().getAttributes();
            lp.flags &= (~WindowManager.LayoutParams.FLAG_FULLSCREEN);
            getWindow().setAttributes(lp);
            getWindow().clearFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
            View decorView = getWindow().getDecorView();
            int uiOptions = View.SYSTEM_UI_FLAG_VISIBLE;
            decorView.setSystemUiVisibility(uiOptions);
        }
    }

    private void initConfiguration(int orientation) {
        if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            fullscreen(true);
            findViewById(R.id.top_view).setVisibility(View.GONE);
            findViewById(R.id.layout_tab).setVisibility(View.GONE);
        } else {
            fullscreen(false);
            findViewById(R.id.top_view).setVisibility(View.VISIBLE);
            findViewById(R.id.layout_tab).setVisibility(View.VISIBLE);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (bellConnectTimer != null) {
            bellConnectTimer.cancel();
        }
        if (mCurPlayer != null && mCurPlayer.getCameraInfo() != null) {
            mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                }

                @Override
                public void PPFailureError(String errorMsg) {
                }
            });
        }
        unregisterReceiver(mReceiver);
    }

    /**
     * 切换预览及回放
     *
     * @param index preview playback
     */
    private void changeTab(int index) {
        this.mPreviewTab.setSelected(index == 0);
        this.mPlaybackTab.setSelected(index == 1);
        initTypeLayout(index);
    }

    /**
     * receive message
     */
    private Handler mEventHandler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            if (isFinishing() || mEventHandler == null)
                return false;
            switch (msg.what) {
                case MESSAGE_CHANGE_TAB_PREVIEW:
                    mViewPager.setCurrentItem(TYPE_PREVIEW);
                    changeTab(STATUS_PREVIEW);
                    action_bar_rl.setVisibility(View.VISIBLE);
                    mRightBtn.setVisibility(View.GONE);
                    break;
                case MESSAGE_CHANGE_TAB_PLAYBACK:
                    changeTab(mPlaybackType);
                    action_bar_rl.setVisibility(View.GONE);
                    mRightBtn.setVisibility(View.VISIBLE);
                    mViewPager.setCurrentItem(TYPE_PLAY_BACK);
                    break;
                case MESSAGE_CONNECT_SUCCESS:
                    isNeedRetryConnect = false;
                    //关闭定时倒计时
                    if (bellConnectTimer != null) {
                        bellConnectTimer.cancel();
                        bellConnectTimer = null;
                    }
                    CommonUtils.setSdkUtil(mCurPlayer);
                    //消噪音，补漏，speed4声音小，所以需要app放大和消噪
//                    if (mCameraInfo.getDeviceTypeName().contains("speed4")) {
//                      mCurPlayer.setRaiseVolume(10);
//                    }
                    if (mCurrentFragment != null) {
                        mCurrentFragment.videoViewStatus(STATUS_PLAY);
                        if (mNos == 0)
                            mCurPlayer.setNoiseSuppression(1);
                    }
                    getSDCardStatus();
                    break;
                case MESSAGE_LOGIN_FAILED:
                    if (isNeedRetryConnect == true && (mCameraInfo.getDevTypeID() == 4 || mCameraInfo.getDevTypeID() == 5)) {
                        if (mCurPlayer != null && mCurPlayer.getCameraInfo() != null && mConnectStatus != -1) {

                            if (mCurPlayer == null) {
                                mCurPlayer = new CameraPlayer();
                                mCurPlayer.setCameraInfo(mCameraInfo);
                                if (mCameraInfo.getVtk() == 4) {
                                    mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                                }

                            }
                            connectBell(false);
                        }
                    } else {
                        if (mCurrentFragment != null) {
                            mCurrentFragment.videoViewStatus(STATUS_LOGIN_FAILED);
                        }
                        if (msg.obj != null) {
                            int errorCode = (int) msg.obj;
                            if (errorCode == CameraPlayer.PPSPLAYER_DEVICE_OFFLINE) {
                                CommonUtils.showToast(R.string.offline_warning);
                            } else if (errorCode == CameraPlayer.PPSPLAYER_REQUEST_FAILED) {
                                CommonUtils.showToast(R.string.connect_camera_failed);
                            } else if (errorCode == CameraPlayer.PPSPLAYER_ERROR_PASSWORD) {
                                CommonUtils.showToast(R.string.device_abnormal);
                            } else {
                                CommonUtils.showToast(R.string.connect_camera_failed);
                            }
                        }
                    }
                    break;
                case MSG_SEND_WAKE_UP_DATA:
                    postWakeUpData();
                    break;
                case MSG_DISCONNECT_BELL:
                    if (mCurPlayer == null || mConnectStatus == 0) {
                        if (isNeedRetryConnect)
                            mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                                @Override
                                public void PPSuccessHandler(String successMsg) {

                                    if (mCurPlayer == null) {
                                        mCurPlayer = new CameraPlayer();
                                        mCurPlayer.setCameraInfo(mCameraInfo);
                                        if (mCameraInfo.getVtk() == 4) {
                                            mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                                        }
                                    }
                                    connectBell(false);
                                }

                                @Override
                                public void PPFailureError(String errorMsg) {
                                    if (mCurPlayer == null) {
                                        mCurPlayer = new CameraPlayer();
                                        mCurPlayer.setCameraInfo(mCameraInfo);
                                        if (mCameraInfo.getVtk() == 4) {
                                            mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                                        }
                                    }
                                    connectBell(false);
                                }
                            });
                    }
                    break;
                case MSG_START_BELL_TIMER:
                    bellConnectTimer = new CountDownTimer(23000, 8000) {
                        @Override
                        public void onTick(long millisUntilFinished) {

                        }

                        @Override
                        public void onFinish() {
                            //倒计时完成，还没有打通，停止循环打洞，等待最后一次打洞结果
                            isNeedRetryConnect = false;
                            //20s时间到，强行掐断之前的链接
                        }
                    };
                    bellConnectTimer.start();
                    break;
                default:
                    break;
            }
            return false;
        }
    });

    public VideoFragment onCreatePreviewFragment() {
        if (this.mCameraInfo.getDevTypeID() == 3) {
            return BabyMonitorPreviewFragment.newInstance(mCameraInfo);
        } else if (this.mCameraInfo.getDevTypeID() == 4 || this.mCameraInfo.getDevTypeID() == 5) {
            //门铃
            return BellPreviewFragment.newInstance(mCameraInfo, this);
        } else {
            return SingleVideoPreviewFragment.newInstance(mCameraInfo);
        }
    }

    @OnClick(R.id.submitRegisterBtn)
    public void onVideoPlayTabClick(View param) {
        int tag = (int) param.getTag();
        mCurrentFragment.closeFragment();
        if (tag == 1) {
            this.mRightBtn.setTag(0);
            if (mCameraInfo.getNvrPort() < 0) {
                if (mCameraInfo.getDevTypeID() == 3)
                    this.mRightBtn.setImageResource(R.mipmap.ic_gree_sd_y);
                else
                    this.mRightBtn.setImageResource(R.mipmap.ic_gree_sd);
            } else {
                if (mCameraInfo.getDevTypeID() == 3)
                    this.mRightBtn.setImageResource(R.mipmap.ic_square_nvr_y);
                else
                    this.mRightBtn.setImageResource(R.mipmap.ic_square_nvr);

            }
            mPlaybackFragment.changeTab(0);
            this.mRightBtn.setTag(0);
        } else {
            if (mCameraInfo.getDevTypeID() == 3)
                this.mRightBtn.setImageResource(R.mipmap.ic_cloud_y);
            else
                this.mRightBtn.setImageResource(R.mipmap.ic_cloud);
            this.mRightBtn.setTag(1);
            mPlaybackFragment.changeTab(1);
        }
    }

    @OnClick(R.id.single_video_preview)
    public void onPreviewClick() {
        if (mEventHandler != null && isFinishing() == false) {
            mEventHandler.sendEmptyMessage(MESSAGE_CHANGE_TAB_PREVIEW);
        }
    }

    @OnClick(R.id.single_video_palyback)
    public void onPlaybackClick() {
        if (mEventHandler != null && isFinishing() == false) {
            mEventHandler.sendEmptyMessage(MESSAGE_CHANGE_TAB_PLAYBACK);
        }
    }

    @OnClick(R.id.right_text)
    public void onSettingClick() {
        //跳转到设备设置页面
        if (mCameraInfo.getDevTypeID() == 4 || mCameraInfo.getDevTypeID() == 5) {
            //进入门铃设置界面
            Bundle bundle = new Bundle();
            bundle.putSerializable("cameraInfo", mCameraInfo);
            CommonUtils.setSdkUtil(mCurPlayer);
            start2ActivityForResult(BellSettingActivity.class, bundle, ActivityType.ACTIVITY_BELL_SETTING);
        } else {
            //进入摄像头设置页面
            Bundle bundle = new Bundle();
            bundle.putSerializable("cameraInfo", mCameraInfo);
            CommonUtils.setSdkUtil(mCurPlayer);
            start2ActivityForResult(CameraSettingActivity.class, bundle, ActivityType.ACTIVITY_CAMERSSETINT);
        }
    }

    @Override
    public CameraPlayer getCameraPlayer() {
        return mCurPlayer;
    }

    @Override
    public TextView getRightView() {
        return this.mRightText;
    }

    @Override
    public ImageView getRightImageView() {
        return this.mRightBtn;
    }

    @Override
    public int getConnectStatus() {
        return mConnectStatus;
    }

    @Override
    public void setConnectStatus(int i) {
        mConnectStatus = i;
    }

    @Override
    public void onRefresh() {
        //检查网络
        if (NetUtil.isNetworkAvailable() == false) {
            //提示无网络连接
            CommonUtils.showToast(R.string.network_unavailable);
            return;
        }
        //门铃要做特殊处理
        if (mCameraInfo.getDevTypeID() == 4 || mCameraInfo.getDevTypeID() == 5) {
//            mCurPlayer = CommonUtils.getSdkUtil();
            if (mCurPlayer == null) {
                mCurPlayer = new CameraPlayer();
                mCurPlayer.setCameraInfo(mCameraInfo);
                if (mCameraInfo.getVtk() == 4) {
                    mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                }
            }
            mCurPlayer.setCameraInfo(this.mCameraInfo);
            isFirstConnect = true;
            this.mConnectStatus = 0;
            if (mCurPlayer != null && mCurPlayer.getCameraInfo() != null && mCurPlayer.IsLogined()) {
                mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        //清空定时器
                        if (mEventHandler == null || isFinishing()) {
                            return;
                        }
                        if (bellConnectTimer != null) {
                            bellConnectTimer.cancel();
                            bellConnectTimer = null;
                        }

                        connectCameraForBell();
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {

                    }
                });
                return;
            }
            //清空定时器
            if (bellConnectTimer != null) {
                bellConnectTimer.cancel();
                bellConnectTimer = null;
            }
            connectCameraForBell();

        } else {
            this.mConnectStatus = 0;
            if (mCurPlayer != null && mCurPlayer.getCameraInfo() != null) {
                mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        if (mEventHandler == null || isFinishing()) {
                            return;
                        }
                        if (mCurPlayer == null) {
                            mCurPlayer = new CameraPlayer();
                            mCurPlayer.setCameraInfo(mCameraInfo);
                            if (mCameraInfo.getVtk() == 4) {
                                mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                            }
                        }
                        connectCamera();
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        if (mCurPlayer == null) {
                            mCurPlayer = new CameraPlayer();
                            mCurPlayer.setCameraInfo(mCameraInfo);
                            if (mCameraInfo.getVtk() == 4) {
                                mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                            }
                        }
                        connectCamera();
                    }
                });
            } else {
                if (mCurPlayer == null) {
                    mCurPlayer = new CameraPlayer();
                    mCurPlayer.setCameraInfo(mCameraInfo);
                    if (mCameraInfo.getVtk() == 4) {
                        mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                    }
                }
                connectCamera();
            }
        }
    }

    /**
     * 专为门铃设计的唤醒打洞方法
     */
    private void connectCameraForBell() {
        isNeedRetryConnect = true;
        if (mCameraInfo.getFactory() == 9 || mCameraInfo.getFactory() == 3) {
            //开启定时器10s内循环打洞
            postWakeUpData();
            if (bellConnectTimer == null) {
                if (mEventHandler != null) {
                    mEventHandler.sendEmptyMessage(MSG_START_BELL_TIMER);
                }

            }
            //去打洞
            isNeedRetryConnect = true;
            if (mCurPlayer != null && mCurPlayer.getCameraInfo() != null && mConnectStatus != -1) {
                mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        if (mEventHandler == null || isFinishing()) {
                            return;
                        }
                        if (mCurPlayer == null) {
                            mCurPlayer = new CameraPlayer();
                            mCurPlayer.setCameraInfo(mCameraInfo);
                            if (mCameraInfo.getVtk() == 4) {
                                mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                            }
                        }
                        connectBell(true);
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        if (mEventHandler == null || isFinishing()) {
                            return;
                        }
                        if (mCurPlayer == null) {
                            mCurPlayer = new CameraPlayer();
                            mCurPlayer.setCameraInfo(mCameraInfo);
                            if (mCameraInfo.getVtk() == 4) {
                                mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                            }
                        }
                        connectBell(true);
                    }
                });
            } else
                connectBell(true);
        } else {
            //先去发送远程唤醒请求

            MeariUser.getInstance().remoteWakeUp(mCameraInfo.getDeviceID(), this, new IResultCallback() {
                @Override
                public void onSuccess() {
                    //开启定时器10s内循环打洞
                    if (bellConnectTimer == null) {
                        bellConnectTimer = new CountDownTimer(23000, 8000) {
                            @Override
                            public void onTick(long millisUntilFinished) {

                            }

                            @Override
                            public void onFinish() {
                                //倒计时完成，还没有打通，停止循环打洞，等待最后一次打洞结果
                                isNeedRetryConnect = false;
                                //20s时间到，强行掐断之前的链接
                            }
                        };
                        bellConnectTimer.start();
                    }
                    //去打洞
                    isNeedRetryConnect = true;
                    if (mCurPlayer != null && mCurPlayer.getCameraInfo() != null && mConnectStatus != -1) {
                        mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                            @Override
                            public void PPSuccessHandler(String successMsg) {
                                if (mEventHandler == null || isFinishing()) {
                                    return;
                                }
                                if (mCurPlayer == null) {
                                    mCurPlayer = new CameraPlayer();
                                    mCurPlayer.setCameraInfo(mCameraInfo);
                                    if (mCameraInfo.getVtk() == 4) {
                                        mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                                    }
                                }
                                connectBell(true);
                            }

                            @Override
                            public void PPFailureError(String errorMsg) {
                                if (mEventHandler == null || isFinishing()) {
                                    return;
                                }
                                if (mCurPlayer == null) {
                                    mCurPlayer = new CameraPlayer();
                                    mCurPlayer.setCameraInfo(mCameraInfo);
                                    if (mCameraInfo.getVtk() == 4) {
                                        mCurPlayer.setStreamType(AudioManager.STREAM_VOICE_CALL);
                                    }
                                }
                                connectBell(true);
                            }
                        });
                    } else
                        connectBell(true);
                }

                @Override
                public void onError(int code, String error) {
                    if (isFinishing() == false && mEventHandler != null) {
                        //失败，显示重新加载按钮
                        mConnectStatus = -2;
                        if (mEventHandler != null)
                            mEventHandler.sendEmptyMessage(MESSAGE_LOGIN_FAILED);
                    }
                }
            });
        }

    }

    @Override
    public void chagePlayType(boolean bPreView) {
        if (bPreView) {
            onPreviewClick();
        } else {
            onPlaybackClick();
        }
    }

    @Override
    public int getCurVideoType() {
        return mViewPager.getCurrentItem();
    }

    @Override
    public ViewPager getViewPage() {
        return mViewPager;
    }

    @Override
    public boolean getSleepMode() {
        return mIsSleep;
    }

    @Override
    public void setSleepMode(boolean b) {
        this.mIsSleep = b;
    }

    @Override
    public boolean getFinshStatus() {
        return mIsFinish;
    }


    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void finish() {
        if (mEventHandler != null)
            mEventHandler.removeCallbacksAndMessages(null);
        mEventHandler = null;
        mIsFinish = true;
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", mCameraInfo);
        intent.putExtras(bundle);
        setResult(RESULT_OK, intent);
        if (bellConnectTimer != null) {
            bellConnectTimer.cancel();
        }
        if (mCurPlayer != null && mCurPlayer.getCameraInfo() != null) {
            mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                }

                @Override
                public void PPFailureError(String errorMsg) {
                }
            });
        }
        super.finish();
    }

    /**
     * Restore the original sound mode
     */
    @Override
    public void onPause() {
        //支持双向语音
        closeSpeaker();

        super.onPause();
    }

    public boolean iSSoundStatus() {
        return iSSoundStatus;
    }


    @Override
    public void changeSoundStatus(boolean enable) {
        if (mSoundPreferences == null)
            return;
        setiSSoundStatus(enable);
        SharedPreferences.Editor editor = mSoundPreferences.edit();
        editor.putBoolean(mCameraInfo.getSnNum(), enable);
        editor.commit();
    }

    @Override
    public boolean getSDCardStatus() {
        return mSdcardStatus > 0;
    }


    
    /**
     * @param firmware_version 固件版本号
     */
    @Override
    public void postUpDataDevice(String firmware_version) {
        if (mCameraInfo.getUserID() != MeariUser.getInstance().getUserInfo().getUserID())
            return;
        mCameraInfo.setDeviceVersionID(firmware_version);
        if (NetUtil.checkNet(this) && !isShowedDlg) {

            MeariUser.getInstance().checkNewFirmwareForDev(firmware_version, CommonUtils.getLangType(this), this, new ICheckNewFirmwareForDevCallback() {
                @Override
                public void onError(int code, String error) {

                }

                @Override
                public void onSuccess(DeviceUpgradeInfo info) {
                    isShowedDlg = true;
                    mDeviceUpgradeInfo = info;
                    if (info.getUpdateStatus() == 1) {
                        if (mDeviceUpgradeInfo.getUpdatePersion().equals("Y"))
                            CommonUtils.showDlg(SingleVideoActivity.this, getString(R.string.app_meari_name), getString(R.string.force_updata_warning), getString(R.string.ok), mPositiveOnClickListener,
                                    getString(R.string.cancel), mNegativeOnClickListener, false);
                        else {
                            if (!Preference.getPreference().showDialogBySn(mCameraInfo.getSnNum())) {
                                CommonUtils.showDlg(SingleVideoActivity.this, getString(R.string.app_meari_name), getString(R.string.found_new_version), getString(R.string.ok), mPositiveOnClickListener,
                                        getString(R.string.cancel), mNegativeOnClickListener, true);
                                if (Preference.getPreference().getUpdateMarkArray() != null)
                                    Preference.getPreference().getUpdateMarkArray().add(mCameraInfo.getSnNum());
                            }

                        }
                    }
                }
            });

        }
    }

    public void setOrientation(boolean islandScape) {
        if (islandScape) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);

        } else {
            //切换成竖屏
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        }
    }

    public void setiSSoundStatus(boolean iSSoundStatus) {
        this.iSSoundStatus = iSSoundStatus;
    }

    /**
     * 注册网络变化发送广播
     */
    public void registerWiFiChangeReceiver() {
        this.mReceiver = new WifiReceiver(this);
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction("android.net.conn.CONNECTIVITY_CHANGE");
        registerReceiver(this.mReceiver, exitFilter);
    }

    @Override
    public void changeWifi(WifiInfo wifiInfo) {

    }

    @Override
    public void disConnected() {
        mCurrentFragment.networkClose();
        CommonUtils.showToast(getString(R.string.network_unavailable));
    }

    @Override
    public void connectTraffic() {

    }

    //显示引导图片

    @Override
    protected void onResume() {
        super.onResume();
        //重新设置设备名称
        //根据能力级判断是否需要初始化双向语音
        initVoice(this);
        mCenter.setText(mCameraInfo.getDeviceName());
    }


    public DialogInterface.OnClickListener mPositiveOnClickListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialogInterface, int i) {
            Intent intent = new Intent(SingleVideoActivity.this, DeviceForceVersionActivity.class);
            Bundle bundle = new Bundle();
            bundle.putString("devVersionID", mSerVersion);
            bundle.putString("versionDesc", versionDesc);
            bundle.putString("devUrl", mDevUrl);
            bundle.putInt("type", ActivityType.ACTIVITY_SIGPLAY);
            bundle.putInt("isUpgrade", updateStatus);
            bundle.putSerializable("cameraInfo", mCameraInfo);
            Preference.getPreference().setSdkNativeUtil(mCurPlayer);
            Preference.getPreference().getSdkNativeUtil().setCameraInfo(mCameraInfo);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_FORCEUPDATEDEVICE);
            dialogInterface.dismiss();
        }
    };

    public DialogInterface.OnClickListener mNegativeOnClickListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialogInterface, int i) {
            dialogInterface.dismiss();
            if (updateStatus == 1 && updatePersion != null && updatePersion.equals("Y"))
                finish();
        }
    };

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_BELL_SETTING:
                //如果从门铃设置页面返回，获取相关设置信息
                if (resultCode == RESULT_OK) {
                    //获取cameraInfo对象
                    CameraInfo tmpInfo = (CameraInfo) data.getExtras().getSerializable("cameraInfo");
                    boolean isFinish = data.getExtras().getBoolean("isClosePreview", false);
                    if (tmpInfo != null) {
                        mCameraInfo = tmpInfo;
                    }
                    if (isFinish)
                        finish();
                }
                break;
            case ActivityType.ACTIVITY_CAMERSSETINT:
                if (resultCode == RESULT_OK) {
                    //获取cameraInfo对象
                    CameraInfo tmpInfo = (CameraInfo) data.getExtras().getSerializable("cameraInfo");
                    if (tmpInfo != null) {
                        mCameraInfo = tmpInfo;
                        mPreviewFragment.setCameraInfo(mCameraInfo);
                    }
                    boolean isFinish = data.getExtras().getBoolean("isClosePreview", false);
                    if (isFinish)
                        finish();
                }
                break;
            case ActivityType.ACTIVITY_FORCEUPDATEDEVICE:
                if (resultCode == RESULT_OK) {
                    finish();
                }
                break;
            default:
                break;
        }
    }



    @Override
    public void setCameraInfo(CameraInfo info) {
        this.mCameraInfo = info;
    }

    @Override
    public CameraInfo getCameraInfo() {
        return mCameraInfo;
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        outState.putSerializable("cameraInfo", mCameraInfo);
        super.onSaveInstanceState(outState);
    }


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK)) {
            int or = getResources().getConfiguration().orientation;
            if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                return false;
            } else
                return super.onKeyDown(keyCode, event);

        } else {
            return super.onKeyDown(keyCode, event);
        }

    }

    /**
     * 关闭扬声器
     */
    public void closeSpeaker() {
        try {
            AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
            audioManager.setMode(AudioManager.MODE_NORMAL);
            if (audioManager != null) {
                if (audioManager.isSpeakerphoneOn()) {
                    audioManager.setSpeakerphoneOn(false);
                    audioManager.setStreamVolume(AudioManager.STREAM_VOICE_CALL, currVolume,
                            AudioManager.STREAM_VOICE_CALL);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
