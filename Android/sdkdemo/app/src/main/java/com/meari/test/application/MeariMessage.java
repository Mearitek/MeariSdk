package com.meari.test.application;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Vibrator;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.meari.sdk.callback.IMessageCallback;
import com.meari.sdk.common.ProtocalConstants;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.BellCallActivity;
import com.meari.test.LoginActivity;
import com.meari.test.R;
import com.meari.test.service.MqttDialogUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.Logger;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import java.util.Date;

import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.data.JPushLocalNotification;

import static com.ppstrong.ppsplayer.CameraPlayer.TAG;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/27
 * ================================================
 */

public class MeariMessage implements IMessageCallback {
    public static SoundPool soundPool;
    public static int soundID;//铃声的ID值，每次播放完会变
    @Override
    public void messageArrived( String message) {
        try {
            BaseJSONObject jsonObject = new BaseJSONObject(message.toString());
            int messageId = jsonObject.optInt("msgid", 0);
            switch (messageId) {
                case 104:
                    new Handler().post(new Runnable() {
                        @Override
                        public void run() {
                            //如果洞还没关掉，则需关掉
                            CameraPlayer cameraPlayer = CommonUtils.getSdkUtil();
                            if (cameraPlayer.IsLogined()) {
                                cameraPlayer.disconnectIPC(new CameraPlayerListener() {
                                    @Override
                                    public void PPSuccessHandler(String successMsg) {

                                    }

                                    @Override
                                    public void PPFailureError(String errorMsg) {

                                    }
                                });
                            }
                            //如果门铃来电，则挂断
                            if (BellCallActivity.getInstance() != null) {
                                Logger.i(TAG, "关闭来电页面");
                                //跳转至登录页面
                                Intent tmpIt = new Intent(BellCallActivity.getInstance(), LoginActivity.class);
                                BellCallActivity.getInstance().startActivity(tmpIt);
                                BellCallActivity.getInstance().finish();
                                dealLout(1000);
                                return;
                            }else
                            {
                                dealLout(0);
                            }
                        }
                    });

                    break;
                case 103: {
                    BaseJSONObject shareJson = jsonObject.optBaseJSONObject("data");
                    String deviceName = shareJson.optString("deviceName", "");
                    String deviceId = shareJson.optString("deviceID", "");
                    String content = MeariSmartApp.getInstance().getString(R.string.cancelDeviceDes) + deviceName;
                    CommonUtils.showToast(content);

                }
                break;
                case 101: {
                    BaseJSONObject deviceJson = jsonObject.optBaseJSONObject("data");
                    Intent intentBroad = new Intent();
                    Bundle bundle = new Bundle();
                    String deviceId = deviceJson.optString("deviceID", "");
                    bundle.putString("deviceID", deviceId);
                    bundle.putBoolean("state", true);
                    intentBroad.putExtras(bundle);
                    intentBroad.setAction(ProtocalConstants.DEVICE_ON_OFF_LINE);
                    CommonUtils.showToast(deviceId + "is online now");
                }
                break;
                case 102: {
                    BaseJSONObject deviceJson = jsonObject.optBaseJSONObject("data");
                    String deviceId = deviceJson.optString("deviceID", "");
                    CommonUtils.showToast(deviceId + "is offline now");
                }
                break;
                case 111:
                    Context context = MeariSmartApp.getInstance();
                    BaseJSONObject bellJson = jsonObject.optBaseJSONObject("data");
                    Intent alarmIntent = new Intent(context, BellCallActivity.class);
                    alarmIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    Bundle bundle = new Bundle();
                    bundle.putString("bellInfo", bellJson.toString());
                    alarmIntent.putExtras(bundle);
                    context.startActivity(alarmIntent);

                    //这里的代码用于规避OPPO这类奇葩手机ROM的权限限制，用户点击通知栏可以跳转到来电接听页面，前提是ROM给了通知栏权限
                    if (BellCallActivity.getInstance() == null) {
                        //极光创建本地通知
                        JPushInterface.removeLocalNotification(MeariSmartApp.getInstance(), BellCallActivity.NOTICE_ID);

                        JPushLocalNotification jNo = new JPushLocalNotification();
                        jNo.setNotificationId(BellCallActivity.NOTICE_ID);
                        jNo.setTitle(context.getString(R.string.bell_visit));
                        jNo.setContent(context.getString(R.string.str_visit));
                        //添加时间戳
                        long timeStamp = new Date().getTime();
                        jsonObject.put("timeStamp", timeStamp);
                        jNo.setExtras(jsonObject.toString());
                        JPushInterface.addLocalNotification(MeariSmartApp.getInstance(), jNo);

                        //震动一下
                        Vibrator vib = (Vibrator) MeariSmartApp.getInstance().getSystemService(Service.VIBRATOR_SERVICE);
                        vib.vibrate(new long[]{1000, 1000, 1000, 1000}, -1);

                        //播放声音，用新方法创建实例，老方法已被弃用
                        if (soundPool != null) {
                            soundPool.stop(soundID);
                            soundPool.release();
                        }
                        SoundPool.Builder sb = null;
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                            sb = new SoundPool.Builder();
                            sb.setMaxStreams(2);
                            //AudioAttributes是一个封装音频各种属性的方法
                            AudioAttributes.Builder attrBuilder = new AudioAttributes.Builder();
                            //设置音频流的合适的属性
                            attrBuilder.setLegacyStreamType(AudioManager.STREAM_MUSIC);
                            //加载一个AudioAttributes
                            sb.setAudioAttributes(attrBuilder.build());
                            soundPool = sb.build();
                        } else {
                            soundPool = new SoundPool(10, AudioManager.STREAM_SYSTEM, 5);
                        }
                        soundID = 1;
                        soundID = soundPool.load(context, R.raw.dingdong, soundID);
                        soundPool.setOnLoadCompleteListener(new SoundPool.OnLoadCompleteListener() {
                            @Override
                            public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
                                soundID = soundPool.play(soundID, 0.5f, 0.5f, 0, 3, 1);
                            }
                        });
                    }

                    break;

                case 803:
                    //OTA升级进度
                    Bundle otaBundle = new Bundle();
                    otaBundle.putString("mqttData", jsonObject.toString());
                    Intent otaIntent = new Intent();
                    otaIntent.setAction(com.meari.sdk.preferences.ProtocalConstants.OTA_UPGRADE_PROGRESS);
                    otaIntent.putExtras(otaBundle);
                    LocalBroadcastManager.getInstance(MeariSmartApp.getInstance()).sendBroadcast(otaIntent);
                    break;
                case 806:
                    //SD卡升级进度
                    Bundle formatSdBundle = new Bundle();
                    formatSdBundle.putString("mqttData", jsonObject.toString());
                    Intent formatSdIntent = new Intent();
                    formatSdIntent.setAction(com.meari.sdk.preferences.ProtocalConstants.FORMAT_SDCARD_PROGRESS);
                    formatSdIntent.putExtras(formatSdBundle);
                    LocalBroadcastManager.getInstance(MeariSmartApp.getInstance()).sendBroadcast(formatSdIntent);
                    break;
                case 809:
                    //刷新属性
                    Bundle refreshBundle = new Bundle();
                    refreshBundle.putString("mqttData", jsonObject.toString());
                    Intent refreshIntent = new Intent();
                    refreshIntent.setAction(com.meari.sdk.preferences.ProtocalConstants.DEVICE_REFRESH_PROPERTY);
                    refreshIntent.putExtras(refreshBundle);
                    LocalBroadcastManager.getInstance(MeariSmartApp.getInstance()).sendBroadcast(refreshIntent);
                    break;
                default:
                    break;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }


    }
    private void dealLout(int time)
    {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                MqttDialogUtils.getInstances().showDialog();
            }
        },time);
    }
}
