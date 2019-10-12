package com.meari.test.utils;

import android.util.Log;

/**
 * Created by efan on 2017/4/13.
 */

public class Logger {

    //设为false关闭日志
    private static final boolean LOG_ENABLE = true;

    public static void i(String tag, String msg) {
        if (LOG_ENABLE) {
            //当文本量超过4K时，循环打印
            msg = msg.trim();
            int index = 0;
            int maxLength = 4000;
            String sub;
            while (index < msg.length()) {
                // java的字符不允许指定超过总的长度end
                if (msg.length() <= index + maxLength) {
                    sub = msg.substring(index);
                } else {
                    sub = msg.substring(index, maxLength);
                }

                index += maxLength;
                Log.i(tag, sub.trim());
            }
        }
    }

    public static void v(String tag, String msg) {
        if (LOG_ENABLE) {
            Log.v(tag, msg);
        }
    }

    public static void d(String tag, String msg) {
        if (LOG_ENABLE) {
            Log.d(tag, msg);
        }
    }

    public static void w(String tag, String msg) {
        if (LOG_ENABLE) {
            Log.w(tag, msg);
        }
    }

    public static void e(String tag, String msg) {
        if (LOG_ENABLE) {
            Log.e(tag, msg);
        }
    }

}
