package com.meari.test.receiver;

import android.app.Activity;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/8/1
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ExitAppReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO Auto-generated method stub
        if (context != null) {
            if (context instanceof Activity) {
                ((Activity) context).finish();
            } else if (context instanceof Service) {
                ((Service) context).stopSelf();
            }
        }
    }
}
