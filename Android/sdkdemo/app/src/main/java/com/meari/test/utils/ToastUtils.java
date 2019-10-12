package com.meari.test.utils;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.widget.Toast;

import com.meari.test.application.MeariSmartApp;

import java.text.MessageFormat;

/**
 * Created by Administrator on 2016/10/27.
 */
@SuppressLint("HandlerLeak")
public class ToastUtils {

    private static ToastUtils sInstance;// 静态变量
    private final Context mContext;// 成员变量
    private final Handler mHandler;// 成员变量
    private Toast mLastToast;

    public static void init(Context context) {
        if (sInstance == null) {
            sInstance = new ToastUtils(context);
        }
    }

    public static ToastUtils getInstance() {
        if (sInstance == null) {
            synchronized (ToastUtils.class) {
                if(sInstance == null) {
                    sInstance = new ToastUtils(MeariSmartApp.getInstance());
                }
            }
        }
        return sInstance;
    }

    private ToastUtils(Context context) {
        this.mContext = context;
        this.mHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if(mLastToast != null) {
                    mLastToast.cancel();
                    mLastToast = null;
                }
                mLastToast = Toast.makeText(mContext, (String) msg.obj, msg.arg1);
                mLastToast.show();
            }
        };
    }

    /**
     * 直接显示文字
     *
     * @param text
     */

    public void showToast(String text) {
        showToast(text, Toast.LENGTH_SHORT);
    }

    /**
     * 显示string文件里的内容
     *
     * @param res
     */
    public void showToast(int res) {
        showToast(mContext.getString(res));
    }

    /**
     * 显示string文件里的内容
     *
     * @param res
     */
    public void showToast(int res, int duration) {
        showToast(mContext.getString(res), duration);
    }

    /**
     * 直接显示文字
     *
     * @param text
     */

    public void showToast(String text, int duration) {
        Message msg = Message.obtain(mHandler, 0, text);
        if(duration != Toast.LENGTH_LONG || duration != Toast.LENGTH_SHORT) {
            duration = Toast.LENGTH_SHORT;
        }
        msg.arg1 = duration;
        msg.sendToTarget();
    }

    /**
     * 显示相应格式的内容
     *
     * @param formatRes
     * @param params
     */

    public void showToast(int formatRes, Object[] params) {
        showToast(MessageFormat.format(mContext.getString(formatRes), params));
    }

    /**
     * 显示相应格式的内容
     *
     * @param formatRes
     * @param params
     * @param duration
     */

    public void showToast(int formatRes, Object[] params, int duration) {
        showToast(MessageFormat.format(mContext.getString(formatRes), params), duration);
    }

}

