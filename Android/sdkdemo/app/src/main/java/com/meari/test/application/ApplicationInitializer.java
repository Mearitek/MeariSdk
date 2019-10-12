package com.meari.test.application;

import android.app.Application;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.meari.test.common.Constant;
import com.meari.test.common.Preference;
import com.meari.test.db.OpenHelper;
import com.tencent.bugly.crashreport.CrashReport;

/**
 * @author ljh
 * @date 2016-1-4
 * @功能描述：
 */
public class ApplicationInitializer {
    public static void initialize(final Application application) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Constant.init(application);
                OpenHelper.getInstance(application);
            }
        }).start();
        Fresco.initialize(application);
        Preference.init(application);
        CrashHandler crashHandler = new CrashHandler();
        Thread.setDefaultUncaughtExceptionHandler(crashHandler);
        CrashReport.initCrashReport(application, "327992a863", false);
    }
}
