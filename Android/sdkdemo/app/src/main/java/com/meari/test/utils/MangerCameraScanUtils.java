package com.meari.test.utils;

import android.os.CountDownTimer;

import com.meari.test.common.CameraSearchListener;
import com.meari.test.common.Preference;


/**
 * 扫描界面
 * Created by ljh on 2016/5/7.
 * 要等界面布局大小取得后才能开始请求数据，防止请求到数据后摆放的问题
 */
public class MangerCameraScanUtils {
    private final CameraSearchListener mCameraSearchListener;
    private TimeCounter mTimeCounter;
    private String mSsid;        // wifi SSID
    private String mPwd;         // wifi密码
    private int mWifiMode;       // wifi加密类型
    private UtilSearchDevice mUtilSearchDevice;       // wifi加密类型


    public UtilSearchDevice getUtilSearchDevice() {
        return mUtilSearchDevice;
    }

    public MangerCameraScanUtils(String ssid, String pwd, int wifiMode, CameraSearchListener scanningResultActivity, boolean status) {
        this.mSsid = ssid;
        this.mPwd = pwd;
        this.mWifiMode = wifiMode;
        this.mCameraSearchListener = scanningResultActivity;
    }

    /**
     * @param send       是否发包
     * @param searchMode 云搜索0/本地搜索1/云+本地
     * @param mode       搜索界面/二维码配网界面
     */
//
    public void startSearchDevice(boolean send, int searchMode, int mode) {
        mUtilSearchDevice = UtilSearchDevice.getInstance(this.mSsid, this.mPwd, 0, mode,send, mCameraSearchListener);
        mUtilSearchDevice.start(searchMode);
        mUtilSearchDevice.setToken(Preference.getPreference().getToken());
        this.mTimeCounter = new TimeCounter(100000, 1000);
        mTimeCounter.start();
    }

    public void startSearchDevice(boolean send, int searchMode, int time, int mode, String token) {
        mUtilSearchDevice = UtilSearchDevice.getInstance(this.mSsid, this.mPwd, this.mWifiMode, mode, send, mCameraSearchListener);
        mUtilSearchDevice.setToken(token);
        mUtilSearchDevice.start(searchMode);
        this.mTimeCounter = new TimeCounter(time * 1000, 1000);
        mTimeCounter.start();
    }

    public void stopSearch() {
        UtilSearchDevice.stop();
        mUtilSearchDevice.stopSearchIPC();
        if (mTimeCounter != null) {
            mTimeCounter.cancel();
        }
    }

    public void finish() {

        if (mUtilSearchDevice != null) {
            mUtilSearchDevice.setDeviceWifiStop();
            mUtilSearchDevice.stopSearchIPC();
        }
        if (mTimeCounter != null) {
            mTimeCounter.cancel();
        }
        UtilSearchDevice.stop();
    }

    public void stopDevieceSearch() {
        if (mUtilSearchDevice != null) {
            mUtilSearchDevice.setDeviceWifiStop();
            mUtilSearchDevice.stopSearchIPC();
        }
    }

    private class TimeCounter extends CountDownTimer {
        /**
         * @param millisInFuture    总时长
         * @param countDownInterval 计时时间间隔
         */
        public TimeCounter(long millisInFuture, long countDownInterval) {
            super(millisInFuture, countDownInterval);
        }

        @Override
        public void onTick(long millisUntilFinished) {// 计时过程显示
            if (mCameraSearchListener != null) {
                mCameraSearchListener.onRefreshProgress((int) (millisUntilFinished / 1000));
            }
            // 此时使用getString报错
        }

        @Override
        public void onFinish() {// 计时完毕时触发
            mCameraSearchListener.onRefreshProgress(0);
            mCameraSearchListener.onCameraSearchFinished();
        }
    }
}
