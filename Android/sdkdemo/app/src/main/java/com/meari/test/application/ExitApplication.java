package com.meari.test.application;

/**
 * @author ljh
 * @date 2016-1-4
 * @功能描述：
 */
public class ExitApplication {
    private static ExitApplication instance;

    public ExitApplication() {
    }

    // 单例模式中获取唯一的ExitApplication实例
    public static ExitApplication getInstance() {
        if (null == instance) {
            instance = new ExitApplication();
        }
        return instance;
    }

    public void exitApp(int type) {
        if (type == 1) {// 异常退出
            android.os.Process.killProcess(android.os.Process.myPid());
            System.exit(1);// 非0参数都可以非正常的方式结束虚拟机
        } else {// 正常退出
            System.exit(0);// 正常退出
        }
    }

}
