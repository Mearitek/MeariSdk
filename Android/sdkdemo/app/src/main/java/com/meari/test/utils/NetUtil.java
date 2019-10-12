package com.meari.test.utils;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

import com.meari.test.application.MeariSmartApp;


/**
 * Created by Administrator on 2016/10/27.
 */
public class NetUtil {
    public static boolean checkNet(Context context) {
        try {
            ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            if (connectivity != null) {
                NetworkInfo info = connectivity.getActiveNetworkInfo();
                if (info != null && info.isConnected()) {
                    if (info.getState() == NetworkInfo.State.CONNECTED) {
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean isWifiConnect(Activity context) {
        ConnectivityManager connManager = (ConnectivityManager) context.getSystemService(Activity.CONNECTIVITY_SERVICE);
        NetworkInfo wifiInfo = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (wifiInfo == null) {
            return false;
        } else
            return wifiInfo.isConnected();
    }

    public static boolean isWifiConnect(MeariSmartApp context) {
        ConnectivityManager connManager = (ConnectivityManager) context.getSystemService(Activity.CONNECTIVITY_SERVICE);
        NetworkInfo wifiInfo = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (wifiInfo == null) {
            return false;
        } else
            return wifiInfo.isConnected();
    }

    public static WifiInfo getConnectWifiInfo(Context context) {
        WifiManager wifiManager = (WifiManager) context.getSystemService(context.WIFI_SERVICE);
        WifiInfo wifiInfo = wifiManager.getConnectionInfo();
        return wifiInfo;
    }

    public static WifiManager getConnectWifiManager(Context context) {
        WifiManager wifiManager = (WifiManager) context.getSystemService(context.WIFI_SERVICE);
        return wifiManager;
    }

    /**
     * 检查网络是否可用
     */
    public static boolean isNetworkAvailable() {
        return NetUtil.checkNet(MeariSmartApp.getInstance());
    }

    /**
     * * 检查手机网络
     * *
     * * @return 0 wifi 1：手机网络 2：无网络
     */
    public static int getConnectWifiType(Context context) {
        ConnectivityManager connMgr = (ConnectivityManager) context.getApplicationContext()
                .getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (networkInfo != null && networkInfo.isConnected()) {
            return 0;
        }
        networkInfo = connMgr.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
        if (networkInfo != null && networkInfo.isConnected()) {
            return 1;
        }
        return 2;
    }
}
