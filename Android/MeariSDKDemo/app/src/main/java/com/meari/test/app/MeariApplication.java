package com.meari.test.app;

import android.app.Application;

import com.meari.sdk.MeariSdk;

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
            MeariSdk.getInstance().setDebug(true);

        }).start();

    }
}
