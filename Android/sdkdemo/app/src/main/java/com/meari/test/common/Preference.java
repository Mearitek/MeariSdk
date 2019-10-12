package com.meari.test.common;

/**
 * Created by Administrator on 2017/3/31.
 * 通用配置
 */

import android.app.Dialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.icu.util.VersionInfo;
import android.util.Log;

import com.meari.sdk.bean.CameraInfo;
import com.meari.test.application.MeariSmartApp;
import com.ppstrong.ppsplayer.CameraPlayer;

import java.util.ArrayList;

public class Preference {
    private static Preference mPreference;
    private CameraPlayer mSdkNativeUtil;
    private CameraPlayer mSdkNVRNativeUtil;
    private SharedPreferences mLoginSharedPreferences;
    private SharedPreferences mDeviceWifiPreferences;
    private SharedPreferences mMqttPreferences;
    private VersionInfo mVersionInfo;
    private boolean mUserChange = false;
    private Dialog mokenChangeDlg;
    private boolean bUpdate = true;
    public boolean bCanUpdate = false;
    public static String BASE_URL_DEFAULT;
    private ArrayList<String> mUpdateMarkArray;
    private String token;


    public Preference(Context paramContext) {
        mSdkNativeUtil = new CameraPlayer();
        mSdkNativeUtil.setCameraInfo(new CameraInfo());
        mSdkNVRNativeUtil = new CameraPlayer();
        mUpdateMarkArray = new ArrayList<>();
        mLoginSharedPreferences = paramContext.getSharedPreferences("pps_autoLgion", Context.MODE_PRIVATE);
        mDeviceWifiPreferences = paramContext.getSharedPreferences("pps_device_wifi", Context.MODE_PRIVATE);
        mMqttPreferences = paramContext.getSharedPreferences(StringConstants.SERVER_MQTT, Context.MODE_PRIVATE);
    }

    public boolean isConnectServer() {
        if (BASE_URL_DEFAULT != null && !BASE_URL_DEFAULT.isEmpty())
            return true;
        else {
            return false;
        }
    }

    /**
     * @param snNum 设备的snNum
     * @param ssid  设备的所Wifi
     */
    public void saveDeviceWifi(String snNum, String ssid) {
        SharedPreferences.Editor editor = getDeviceWifiPreferences().edit();
        editor.putString("snNum", ssid);
        editor.apply();
    }

    public static void init(Context paramContext) {
        if (paramContext == null)
            throw new NullPointerException();
        mPreference = new Preference(paramContext);
    }

    public static Preference getPreference() {
        if (mPreference == null) {
            init(MeariSmartApp.getInstance());
            Log.e("Preference", "null");
        }
        return mPreference;
    }

    public static void setPreference(Preference mPreference) {
        Preference.mPreference = mPreference;
    }

    public static void setBaseUrlDefault(String baseUrlDefault) {
        BASE_URL_DEFAULT = baseUrlDefault;
    }

    public CameraPlayer getSdkNativeUtil() {
        if (mSdkNativeUtil == null)
            mSdkNativeUtil = new CameraPlayer();
        return mSdkNativeUtil;
    }

    public SharedPreferences getLoginSharedPreferences() {
        return mLoginSharedPreferences;
    }

    public VersionInfo getmVersionInfo() {
        return mVersionInfo;
    }

    public void setVersionInfo(VersionInfo mVersionInfo) {
        this.mVersionInfo = mVersionInfo;
    }

    public boolean isUserChange() {
        return mUserChange;
    }

    public void setUserChange(boolean mUserChange) {
        this.mUserChange = mUserChange;
    }

    public boolean isbUpdate() {
        return bUpdate;
    }

    public void setbUpdate(boolean bUpdate) {
        this.bUpdate = bUpdate;
    }


    public void setSdkNativeUtil(CameraPlayer sdkNativeUtil) {
        this.mSdkNativeUtil = sdkNativeUtil;
    }

    public void setMokenChangeDlg(Dialog mokenChangeDlg) {
        this.mokenChangeDlg = mokenChangeDlg;
    }

    public void setbCanUpdate(boolean bCanUpdate) {
        this.bCanUpdate = bCanUpdate;
    }

    public CameraPlayer getSdkNVRNativeUtil() {
        if (mSdkNVRNativeUtil == null)
            mSdkNVRNativeUtil = new CameraPlayer();
        return mSdkNVRNativeUtil;
    }

    public void setmSdkNVRNativeUtil(CameraPlayer mSdkNVRNativeUtil) {
        this.mSdkNVRNativeUtil = mSdkNVRNativeUtil;
    }

    private SharedPreferences getDeviceWifiPreferences() {
        return mDeviceWifiPreferences;
    }

    public void setDeviceWifiPreferences(SharedPreferences mDeviceWifiPreferences) {
        this.mDeviceWifiPreferences = mDeviceWifiPreferences;
    }

    public String getDeviceWifiSSIDBySn(String snNum) {
        if (getDeviceWifiPreferences() == null)
            return null;

        return getDeviceWifiPreferences().getString("snNum", null);

    }

    public void setServerType(int serverType) {
    }

    public void setServerUrl(String serverType) {
        BASE_URL_DEFAULT = serverType;
    }

    public void initServer(String apiServer, String mqttServer, int mqttServerPort) {
        BASE_URL_DEFAULT = apiServer;
//        BASE_URL_DEFAULT = "http://pre-apis.meari.com.cn";
    }

    public ArrayList<String> getUpdateMarkArray() {
        return mUpdateMarkArray;
    }

    public boolean showDialogBySn(String snNum) {
        if (mUpdateMarkArray != null) {
            if (mUpdateMarkArray.contains(snNum))
                return true;
        }
        return false;
    }

    public void removeDeviceBySn(String snNum) {
        if (mUpdateMarkArray != null) {
            if (mUpdateMarkArray.contains(snNum))
                mUpdateMarkArray.remove(snNum);
        }
    }

    public SharedPreferences getMqttPreferences() {
        return mMqttPreferences;
    }

    public void setMqttPreferences(SharedPreferences mqttPreferences) {
        this.mMqttPreferences = mqttPreferences;
    }

    public String getToken() {
        return this.token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
