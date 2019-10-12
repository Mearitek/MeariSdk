package com.meari.test.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.PowerManager;
import android.util.Log;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.DeviceMessageStatusInfo;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.BellCallActivity;
import com.meari.test.LoginActivity;
import com.meari.test.MainActivity;
import com.meari.test.MessageDeviceActivity;
import com.meari.test.R;
import com.meari.test.utils.CommonUtils;

import org.json.JSONException;

import java.util.Iterator;

import cn.jpush.android.api.JPushInterface;

/**
 * 自定义接收器
 * <p>
 * 如果不定义这个 Receiver，则： 1) 默认用户会打开主界面 2) 接收不到自定义消息
 */
public class MyReceiver extends BroadcastReceiver {
    private static final String TAG = "JPush";
    private Handler mTimeHandler = new Handler();

    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();

        if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
            String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
            Log.d(TAG, "[MyReceiver] 接收Registration Id : " + regId);
            //send the Registration Id to your server...

        } else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
            Log.d(TAG, "[MyReceiver] 接收到推送下来的自定义消息: " + bundle.getString(JPushInterface.EXTRA_MESSAGE));

        } else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
            PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
            @SuppressWarnings("deprecation") final PowerManager.WakeLock mPowerWakeLock = pm.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK
                            | PowerManager.FULL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP | PowerManager.ON_AFTER_RELEASE,
                    "TAG");
            mPowerWakeLock.acquire();
            mTimeHandler.postDelayed(new Runnable() {
                public void run() {
                    mPowerWakeLock.release();
                }
            }, 10 * 1000);
            if (MainActivity.getInstance() != null) {
                MainActivity.getInstance().mAdapter.setbHasMeg(true);
                MainActivity.getInstance().mAdapter.notifyDataSetChanged();
            }
            int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);

        } else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
            Log.d(TAG, "[MyReceiver] 用户点击打开了通知");

            onMessageClick(bundle, context);

        } else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
            Log.d(TAG, "[MyReceiver] 用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));

        } else if (JPushInterface.ACTION_CONNECTION_CHANGE.equals(intent.getAction())) {
            boolean connected = intent.getBooleanExtra(JPushInterface.EXTRA_CONNECTION_CHANGE, false);
            Log.w(TAG, "[MyReceiver]" + intent.getAction() + " connected state change to " + connected);
        } else {
            Log.d(TAG, "[MyReceiver] Unhandled intent - " + intent.getAction());
        }

    }

    @SuppressWarnings("unused")
    private void onMessageClick(Bundle bundle, Context context) {
        String msgType = "";
        String deviceName = "";
        String uuid = "";
        long deviceID = 0;
        StringBuilder sb = new StringBuilder();
        for (String key : bundle.keySet()) {
            if (bundle.getString(JPushInterface.EXTRA_EXTRA).isEmpty()) {
                continue;
            }
            try {
                BaseJSONObject json = new BaseJSONObject(bundle.getString(JPushInterface.EXTRA_EXTRA));
                Iterator<String> it = json.keys();
                while (it.hasNext()) {
                    String myKey = it.next().toString();
                    if (myKey.equals("msgType")) {
                        msgType = json.optString(myKey, "0");
                    } else if (myKey.equals("deviceName")) {
                        deviceName = json.optString(myKey, "");
                    } else if (myKey.equals("deviceID")) {
                        deviceID = json.optLong(myKey, 0);
                    } else if (myKey.equals("uuid")) {
                        uuid = json.optString(myKey, "");
                    }
                }
                //如果是访客来电事件，即收到本地创建的通知栏
                String bellInfo = json.toString();
                if (bellInfo != null && bellInfo.contains("bellVoice")) {
                    //获取门铃信息

                    //判断是否有时间戳字段，如果有，则说明消息来自于用户点击BellCallService产生的通知栏
                    if (bellInfo.contains("msgTime")) {
                        //用户点击极光通知栏进来
                        long timeStamp = json.getLong("msgTime");
                        long curTime = System.currentTimeMillis();
                        if (curTime - timeStamp >= 15000) {
                            //消息已过期
                            CommonUtils.showToast(context.getString(R.string.str_msg_past));
                            return;
                        }
                    } else {

                        Intent alarmIntent = new Intent(context, BellCallActivity.class);
                        alarmIntent.setFlags(Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY | Intent.FLAG_ACTIVITY_NEW_TASK);
                        Bundle alarmBundle = new Bundle();
                        alarmBundle.putString("bellInfo", bellInfo);
                        alarmIntent.putExtras(alarmBundle);
                        context.startActivity(alarmIntent);
                    }
                }
            } catch (JSONException e) {
                return;
            }catch (Exception e)
            {
                return;
            }
        }
        if (CommonUtils.isAppAlive(context, context.getPackageName())) {
            if (!MeariUser.getInstance().isLogin()) {
                Intent intent = new Intent();
                intent.setFlags(Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                intent.setClass(context, LoginActivity.class);
                context.startActivity(intent);
                return;
            }
            if (msgType.equals("0")) {
                try {
                    Intent intent = new Intent();
                    intent.setClass(context, MessageDeviceActivity.class);
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    DeviceMessageStatusInfo mMsgInfo = new DeviceMessageStatusInfo();
                    mMsgInfo.setDeviceName(deviceName);
                    mMsgInfo.setDeviceID(deviceID);
                    mMsgInfo.setDeviceUUID(uuid);
                    Bundle bundle1 = new Bundle();
                    bundle1.putSerializable("msgInfo", mMsgInfo);
                    intent.putExtras(bundle1);
                    context.startActivity(intent);
                } catch (Exception e) {
                }

            } else if (msgType.equals("1")) {
                if (MainActivity.getInstance() == null) {
                    return;
                }
                Intent intent = new Intent();
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                intent.setClass(context, MainActivity.class);
                Bundle bundleMain = new Bundle();
                bundleMain.putBoolean("sysMessage", true);
                intent.putExtras(bundleMain);
                context.startActivity(intent);
            }
        } else {
            Intent launchIntent = context.getPackageManager().
                    getLaunchIntentForPackage(context.getPackageName());
            launchIntent.setFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
            Bundle args = new Bundle();
            args.putLong("deviceID", deviceID);
            args.putString("deviceName", deviceName);
            args.putString("type", msgType);
            launchIntent.putExtras(args);
            context.startActivity(launchIntent);
        }

    }
}
