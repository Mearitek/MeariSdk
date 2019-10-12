package com.meari.test.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

import com.meari.test.utils.NetUtil;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/24
 * 描    述：联络变化接受器
 * 修订历史：
 * ================================================
 */

public class WifiReceiver extends BroadcastReceiver {
    private WifiChangeListener mListener;
    private boolean mBfirstChange = true;


    public WifiReceiver(WifiChangeListener wifiListActivity) {
        mListener = wifiListActivity;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO Auto-generated method stub
        if (mBfirstChange == true) {
            mBfirstChange = false;
            return;
        }
        ConnectivityManager manager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        WifiManager wifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        NetworkInfo wifiInfo = manager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        WifiInfo wifi = wifiManager.getConnectionInfo();
        if (wifiInfo.isConnected() == false) {
            if (!NetUtil.checkNet(context))
                mListener.disConnected();
            else
                mListener.connectTraffic();
        } else {
            mListener.changeWifi(wifi);
        }
    }

    public interface WifiChangeListener {

        void changeWifi(WifiInfo wifiInfo);

        void disConnected();

        void connectTraffic();
    }
}
