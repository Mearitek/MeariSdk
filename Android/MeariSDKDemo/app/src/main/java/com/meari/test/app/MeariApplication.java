package com.meari.test.app;

import android.app.Application;

import com.meari.sdk.MeariSdk;
import com.meari.sdk.common.ServerType;

public class MeariApplication extends Application {

    private static MeariApplication instance;

    public static MeariApplication getInstance() {
        return instance;
    }
    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        new Thread(() -> {
            MeariSdk.init(MeariApplication.this, new MyMessageHandler());
            // set Debug model
            MeariSdk.getInstance().setDebug(true);
            // 设置开发环境，正式发布时去除
            // Set up the development environment and remove it when it is officially released
            MeariSdk.getInstance().setPrivateCloudUrl(ServerType.DEVELOPMENT);


        }).start();

    }
}
