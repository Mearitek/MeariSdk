package com.meari.test.application;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Application;
import android.app.Dialog;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.support.multidex.MultiDex;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;

import com.meari.sdk.MeariSdk;
import com.meari.sdk.preferences.ProtocalConstants;
import com.meari.test.BellCallActivity;
import com.meari.test.LoginActivity;
import com.meari.test.service.CommonData;
import com.meari.test.service.CommonDialogService;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.Logger;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import static com.ppstrong.ppsplayer.CameraPlayer.TAG;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/12
 * ================================================
 */

public class MeariSmartApp extends Application implements Application.ActivityLifecycleCallbacks {

    static private MeariSmartApp instance;
    public static int SPLASHTIME = 2000;
    public static boolean WELCOME = true;
    public final int MESSAGE_TOKEN_CHANGE = 1001;
    private Dialog mCanceShareDialog;
    public int activityCount;//activity数量，用于app前后台判断
    public CountDownTimer downTimer;//app切换后台后倒计时关洞
    public static MeariSmartApp getInstance() {
        return instance;
    }

    private void initSdk() {
//        MeariSdk.init(this,8,new MeariMessage(),false );
        MeariSdk.init(this, new MeariMessage(),false);
//        MeariSdk.getInstance().setPrivateCloudUrl("https://pre-apis-cn-hangzhou.meari.com.cn");
        MeariSdk.getInstance().setDebug(true);
        MeariSdk.getInstance().setLoginType(2);
//        closeSpeaker();
    }

    private boolean isInitAppkey() {
        String appKey = CommonUtils.getMataData("MEARI_APPKEY", this);
        String appSecret = CommonUtils.getMataData("MEARI_SECRET", this);
        if (TextUtils.isEmpty(appKey) || TextUtils.isEmpty(appSecret)) {
            throw new IllegalArgumentException("MEARI_APPKEY or MEARI_SECRET is null");
        }

        return true;
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

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        if (isInitAppkey()) {
            initSdk();
        }
        this.registerActivityLifecycleCallbacks(this);//注册
        ApplicationInitializer.initialize(instance);
        CommonData.applicationContext = this;
        Intent dialogservice = new Intent(this, CommonDialogService.class);
        startService(dialogservice);
        initPhoneStateListener();
//        MultiDex.install(this);
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    private void initPhoneStateListener() {
        TelephonyManager telephonyManager = (TelephonyManager) MeariSmartApp.getInstance().getSystemService((Service.TELEPHONY_SERVICE));
        if (telephonyManager != null) {
            try {
                // 注册来电监听
                telephonyManager.listen(listener, PhoneStateListener.LISTEN_CALL_STATE);
            } catch (Exception e) {
                // 异常捕捉
            }
        }
    }
    PhoneStateListener listener = new PhoneStateListener() {

        @Override
        public void onCallStateChanged(int state, String incomingNumber) {
            //state 当前状态 incomingNumber,貌似没有去电的API
            super.onCallStateChanged(state, incomingNumber);
            switch (state) {
                case TelephonyManager.CALL_STATE_IDLE:
                    Logger.i(TAG, "挂断");

                    break;
                case TelephonyManager.CALL_STATE_OFFHOOK:
                    Logger.i(TAG, "接听");
                    if (BellCallActivity.getInstance() != null) {
                        BellCallActivity.getInstance().finish();
                    }

                    break;
                case TelephonyManager.CALL_STATE_RINGING:
                    break;
            }
        }
    };
    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        if (activity.getParent() != null) {
            CommonData.mNowContext = activity.getParent();
        } else
            CommonData.mNowContext = activity;
    }

    @Override
    public void onActivityStarted(Activity activity) {
        if (activity.getParent() != null) {
            CommonData.mNowContext = activity.getParent();
        } else
            CommonData.mNowContext = activity;
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (activity.getParent() != null) {
            CommonData.mNowContext = activity.getParent();
        } else
            CommonData.mNowContext = activity;
    }

    @Override
    public void onActivityPaused(Activity activity) {

    }

    @Override
    public void onActivityStopped(Activity activity) {
        {
            Log.v(TAG, activity.getLocalClassName() + "==onActivityStopped");
            activityCount--;
            if (activityCount == 0) {
                Log.v(TAG, ">>>>>>>>>>>>>>>>>>>切到后台  lifecycle");
                downTimer = new CountDownTimer(30000, 1000) {
                    @Override
                    public void onTick(long millisUntilFinished) {
                    }

                    @Override
                    public void onFinish() {
                        Log.i(TAG, "时间到了，后台关洞");
                        //倒计时结束，关洞
                        CameraPlayer cameraPlayer = CommonUtils.getSdkUtil();
                        if (cameraPlayer.IsLogined()) {
                            cameraPlayer.disconnectIPC(new CameraPlayerListener() {
                                @Override
                                public void PPSuccessHandler(String successMsg) {

                                }

                                @Override
                                public void PPFailureError(String errorMsg) {

                                }
                            });
                        }
                    }
                };
                downTimer.start();
            }
        }

    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }

    @SuppressLint("HandlerLeak")
    private Handler mHandle = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_TOKEN_CHANGE:
                    Intent intentBroad = new Intent();
                    intentBroad.putExtra("msgId", ProtocalConstants.MESSAGE_ID_TOKEN_CHANGE);
                    intentBroad.setAction(ProtocalConstants.MESSAGE_EXIT_APP);
                    sendBroadcast(intentBroad);

                    Intent intent = new Intent();
                    Bundle bundle = new Bundle();
                    bundle.putBoolean("token", true);
                    if (CommonData.mNowContext instanceof Activity)
                        intent.setClass(CommonData.mNowContext, LoginActivity.class);
                    else {
                        intent.setClass(MeariSmartApp.this, LoginActivity.class);
                    }
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.putExtras(bundle);
                    startActivity(intent);
                    break;

            }
        }
    };


    public void tokenChange() {
        mHandle.sendEmptyMessage(MESSAGE_TOKEN_CHANGE);
    }


    public void exitApp(int type) {
        if (type == 1) {// 异常退出
            Intent intentBroad = new Intent();
            intentBroad.putExtra("msgId", ProtocalConstants.MESSAGE_ID_EXIT_APP);
            intentBroad.setAction(ProtocalConstants.MESSAGE_EXIT_APP);
            sendBroadcast(intentBroad);
        } else {// 正常退出
            Intent intentBroad = new Intent();
            intentBroad.putExtra("msgId", ProtocalConstants.MESSAGE_ID_EXIT_APP);
            intentBroad.setAction(ProtocalConstants.MESSAGE_EXIT_APP);
            sendBroadcast(intentBroad);
        }
    }
}
