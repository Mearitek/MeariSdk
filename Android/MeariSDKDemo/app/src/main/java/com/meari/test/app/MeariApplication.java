package com.meari.test.app;

import android.app.Application;

import com.meari.sdk.MeariSdk;

public class MeariApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        new Thread(() -> {
            MeariSdk.init(MeariApplication.this, new MyMessageHandler());
            MeariSdk.getInstance().setDebug(true);

        }).start();

    }
}
