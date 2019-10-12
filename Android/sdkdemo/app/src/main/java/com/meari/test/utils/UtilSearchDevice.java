package com.meari.test.utils;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.common.CameraSearchListener;
import com.meari.test.common.Preference;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by chengjianjia on 2016/1/29.
 */
public class UtilSearchDevice implements CameraPlayerListener {

    private static final String TAG = "UtilSearchDevice";
    private static UtilSearchDevice instance;
    private String mSsid, mPwd;
    private int mWifiMode;
    private CameraSearchListener cameraSearchListener;
    /**
     * 是否发包配网
     */
    private boolean bSend = true;
    public CameraPlayer mCameraPlayer;
    /**
     * 配网方式
     */
    public int mMode;

    public UtilSearchDevice(String ssid, String pwd, int wifiMode, CameraSearchListener cameraSearchListener) {
        this.mSsid = ssid;
        this.mPwd = pwd;
        this.mWifiMode = wifiMode;
        this.cameraSearchListener = cameraSearchListener;
        mCameraPlayer = new CameraPlayer();
        if (Preference.getPreference() != null && Preference.getPreference().getToken() != null && !Preference.getPreference().getToken().isEmpty())
            mCameraPlayer.updatetoken(Preference.getPreference().getToken());
    }

    public static UtilSearchDevice getInstance(String ssid, String pwd, int wifiMode, int mode, boolean send, CameraSearchListener cameraSearchListener) {
        if (instance == null) {
            instance = new UtilSearchDevice(ssid, pwd, wifiMode, cameraSearchListener);
        } else {
            if (mode != instance.getMode()) {
                instance = new UtilSearchDevice(ssid, pwd, wifiMode, cameraSearchListener);
            }
        }
        instance.bSend = send;
        instance.mMode = mode;
        return instance;
    }

    public int getMode() {
        return mMode;
    }

    public void start(int mode) {
        if (bSend) {
            mCameraPlayer.monitor(mSsid, mPwd, mWifiMode);
        }
        mCameraPlayer.searchIPC2(this, mode);
    }


    public static void stop() {
        instance = null;
    }

    public void setDeviceWifiStop() {
        if (mCameraPlayer != null)
            mCameraPlayer.setDeviceWifiStop();
    }

    public void stopSearchIPC() {
        mCameraPlayer.stopsearchIPC2();
        mCameraPlayer.stopmonitor();
    }

    @Override
    public void PPSuccessHandler(String successMsg) {
        BaseJSONObject baseJSONObject = null;
        try {
            baseJSONObject = new BaseJSONObject(successMsg);
            CameraInfo info = getBaseDeviceInfo(baseJSONObject);
            cameraSearchListener.onCameraSearchDetected(info);
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    @Override
    public void PPFailureError(String errorMsg) {

    }

    public void setToken(String token) {
        this.mCameraPlayer.updatetoken(token);
    }

    public CameraInfo getBaseDeviceInfo(JSONObject jsonObject) {
        CameraInfo info = new CameraInfo();
        String licenseId = jsonObject.optString("licenseId", "");
        if (!licenseId.isEmpty()) {
            info.setLicenseId(licenseId);
            info.setVersion(jsonObject.optString("version", ""));
//            info.setSn(jsonObject.optString("serialno", ""));
            info.setDeviceUUID(jsonObject.optString("p2p_uuid", ""));
            info.setTp(jsonObject.optString("tp", "0"));
            info.setDeviceName(jsonObject.optString("serialno", ""));
            info.setCapability(jsonObject.optString("capability", ""));
            info.setSnNum(licenseId);
        } else {
            info.setLicenseId("");
            info.setVersion(jsonObject.optString("version", ""));
            info.setSnNum(jsonObject.optString("sn", ""));
            info.setDeviceUUID(jsonObject.optString("p2p_uuid", ""));
            info.setTp(jsonObject.optString("tp", "0"));
            info.setDeviceName(jsonObject.optString("sn", ""));
        }
        info.setProduceAuth(jsonObject.optString("produceAuth", ""));
        info.setMac(jsonObject.optString("mac", ""));
        return info;
    }
}
