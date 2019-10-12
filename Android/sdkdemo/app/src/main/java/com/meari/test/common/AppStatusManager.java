package com.meari.test.common;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/13
 * ================================================
 */

public class AppStatusManager {

    private static AppStatusManager mInstance = null;

    private int appStatus = AppStatusConstant.APP_FORCE_KILLED;

    private AppStatusManager() {

    }

    public static AppStatusManager getInstance() {
        if (mInstance == null) {
            synchronized (AppStatusManager.class) {
                if (mInstance == null)
                    mInstance = new AppStatusManager();
            }
        }
        return mInstance;
    }

    public void setAppStatus(int appStatus) {
        this.appStatus = appStatus;
    }

    public int getAppStatus() {
        return appStatus;
    }


    public static class AppStatusConstant {

        /**
         * App被回收，初始状态
         */
        public static final int APP_FORCE_KILLED = 0;

        /**
         * 正常运行
         */
        public static final int APP_NORMAL = 1;
    }
}
