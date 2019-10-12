package com.meari.test.application;

import android.content.Context;
import android.os.Looper;
import android.widget.Toast;

import com.meari.test.R;

import java.lang.Thread.UncaughtExceptionHandler;

/**
 * @author ljh
 * @date 2016-1-4
 * @功能描述：
 */
public class CrashHandler implements UncaughtExceptionHandler {

    @Override
    public void uncaughtException(Thread thread, Throwable ex) {

        final Context mContext = MeariSmartApp.getInstance();
        new Thread(new Runnable() {
            @Override
            public void run() {
                Looper.prepare();
                Toast.makeText(mContext, mContext.getString(R.string.app_exitapp), Toast.LENGTH_SHORT).show();
                Looper.loop();
            }
        }).start();
        android.os.Process.killProcess(android.os.Process.myPid());
        ExitApplication.getInstance().exitApp(1);
    }
}
