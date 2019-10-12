package com.meari.test.service;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

/**
 * Created by ljh on 17-4-6.
 * 用于接受设备上线下线消息
 */
public class DeviceStatusReceiver extends BroadcastReceiver {
    private final DeviceStatusCallback mCallBack;

    public DeviceStatusReceiver(DeviceStatusCallback call)
    {
        this.mCallBack = call;
    }
    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO Auto-generated method stub
        Bundle bundle = intent.getExtras();
        String deviceId = bundle.getString("deviceID","");
        boolean onLine = bundle.getBoolean("state",false);
        mCallBack.setDeviceStatus(deviceId,onLine);
    }
    public interface DeviceStatusCallback
    {
        void setDeviceStatus(String deviceId, boolean onLine);
    }
}
