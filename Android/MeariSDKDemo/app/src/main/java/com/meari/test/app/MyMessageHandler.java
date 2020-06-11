package com.meari.test.app;

import com.meari.sdk.MeariDeviceController;
import com.meari.sdk.MeariUser;
import com.meari.sdk.listener.MeariDeviceListener;
import com.meari.sdk.mqtt.MqttMessageCallback;

public class MyMessageHandler implements MqttMessageCallback {
    @Override
    public void otherMessage(int i, String s) {

    }

    @Override
    public void loginOnOtherDevices() {
        // todo Must deal with
        // Must handle account login on other devices
        // An account can only log in on one device at a time

        if (MeariUser.getInstance().isMqttConnected()) {
            MeariUser.getInstance().disConnectMqttService();
        }
        MeariUser.getInstance().removeUserInfo();

        MeariDeviceController controller = MeariUser.getInstance().getController();
        if (controller != null && controller.isConnected()) {
            controller.stopConnect(new MeariDeviceListener() {
                @Override
                public void onSuccess(String successMsg) {

                }

                @Override
                public void onFailed(String errorMsg) {

                }
            });
        }
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
    public void onVoiceDoorbellCall(String s) {

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
    public void onChimeDeviceLimit(String s) {

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
