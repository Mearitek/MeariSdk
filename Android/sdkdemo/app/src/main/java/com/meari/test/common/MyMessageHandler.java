package com.meari.test.common;

import com.meari.sdk.mqtt.MqttMessageCallback;

/**
 * 描述: MQTT消息处理器
 * 作者: wu
 * 日期: 2020/3/3
 * 版本: 2.2
 */
public class MyMessageHandler implements MqttMessageCallback {


    @Override
    public void otherMessage(int i, String s) {

    }

    @Override
    public void loginOnOtherDevices() {

    }

    @Override
    public void onCancelSharingDevice(String s, String s1) {

    }

    @Override
    public void deviceUnbundled() {

    }

    @Override
    public void onDoorbellCall(String s, boolean b) {

    }

    @Override
    public void addDeviceSuccess(String s) {

    }

    @Override
    public void addDeviceFailed(String s) {

    }

    @Override
    public void addDeviceFailedUnbundled(String s) {

    }

    @Override
    public void ReceivedDevice(String s) {

    }

    @Override
    public void requestReceivingDevice(String s, String s1, String s2) {

    }

    @Override
    public void requestShareDevice(String s, String s1, String s2) {

    }
}
