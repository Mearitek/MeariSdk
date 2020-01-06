package com.meari.test;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import android.view.View;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.DeviceUpgradeInfo;
import com.meari.sdk.bean.IotPropertyInfo;
import com.meari.sdk.callback.ICheckNewFirmwareForDevCallback;
import com.meari.sdk.callback.IPropertyCallback;
import com.meari.sdk.callback.IStringResultCallback;
import com.meari.sdk.common.IotConstants;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.sdk.preferences.ProtocalConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.widget.SwitchButton;
import com.ppstrong.ppsplayer.CameraPlayer;

import org.json.JSONException;

@SuppressLint("HandlerLeak")
public class CameraSettingIotActivity extends BaseActivity {

    private final int MSG_UPGRADE_SUCCESS = 1000;
    private final int MSG_UPGRADE_FAILED = 1002;


    private SwitchButton switch_led;
    private Button btn_upgrade;
    private TextView tv_progress;

    private CameraInfo mInfo;
    private CameraPlayer cameraPlayer;
    // 是否支持iot设置
    private boolean isIothub = false;
    private IotPropertyInfo iotInfo;
    private DeviceUpgradeInfo upgradeInfo;

    private IotBroadcastReceiver iotBroadcastReceiver;
    private LocalBroadcastManager localBroadcastManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_camera_setting_iot);
        initData();
        initView();
        initBroadcastReceiver();
        checkUpgrade();
    }

    private void initData() {
        Intent intent = getIntent();
        mInfo = (CameraInfo) intent.getSerializableExtra("cameraInfo");
        //判断设备是否支持iot设置
        if (mInfo.getProtocolVersion() >= 4) {
            isIothub = true;
        }

        if (isIothub) {
            getIotProperty();
        } else {
            // p2p 方式获得设备设置参数
        }

    }

    private void initView() {
        this.mCenter.setText("IOT设置Demo");


        switch_led = findViewById(R.id.switch_led);
        switch_led.setEnabled(true);
        switch_led.setEnabled(false);
        switch_led.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                //判断是否支持iot，然后调用不用方法设置
                if (isIothub) {
                    setRotateEnable(isChecked ? 1 : 0);
                } else {
                    // p2p设置，参考其他设置页面的方法
                    showToast("不支持");
                }

            }
        });

        tv_progress = findViewById(R.id.tv_progress);
        btn_upgrade = findViewById(R.id.btn_upgrade);
        btn_upgrade.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
    }

    private void getIotProperty() {
        MeariUser.getInstance().getIotProperty(mInfo.getSnNum(), this, new IPropertyCallback() {
            @Override
            public void onSuccess(IotPropertyInfo iotPropertyInfo) {
                iotInfo = iotPropertyInfo;
            }

            @Override
            public void onError(int code, String error) {

            }
        });
    }

    private void setRotateEnable(int status) {
        MeariUser.getInstance().setRotateEnable(mInfo.getSnNum(), status, this, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                showToast("设置成功");
            }

            @Override
            public void onError(int code, String error) {
                showToast("设置失败");
            }
        });
    }

    private void checkUpgrade() {
        String firmwareVersion = "";
        //固件信息："ppstrong-c2-neutral-2.7.0.20190409"
        if (isIothub) {
            firmwareVersion = iotInfo.getFirmwareCode();

        } else {
            // p2p 方式
//            firmwareVersion = cameraInfo.getDeviceVersionID();//CameraInfo 获取
        }
        MeariUser.getInstance().checkNewFirmwareForDev(firmwareVersion, "zh", this,
                new ICheckNewFirmwareForDevCallback() {
                    @Override
                    public void onSuccess(DeviceUpgradeInfo info) {
                        upgradeInfo = info;
                    }

                    @Override
                    public void onError(int code, String error) {

                    }
                });
    }

    private void upgradeFirmware() {
        if (upgradeInfo == null) {
            return;
        }
        int updateStatus = upgradeInfo.getUpdateStatus();
        //版本更新描述
        String des = upgradeInfo.getVersionDesc();
        if (updateStatus == 0) {
            showToast("已经是最新版本");
            return;
        }

        BaseJSONObject object = new BaseJSONObject();
        object.put("url",upgradeInfo.getDevUrl());
        object.put("version",upgradeInfo.getSerVersion() + "-upgrade.bin");
        MeariUser.getInstance().upgradeFirmware(mInfo.getSnNum(), object.toString(), this, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {

                Message msg = Message.obtain();
                msg.what = MSG_UPGRADE_SUCCESS;
                msg.obj = 1;
                handler.sendMessage(msg);
            }

            @Override
            public void onError(int code, String error) {

                Message msg = Message.obtain();
                msg.what = MSG_UPGRADE_FAILED;
                msg.obj = 0;
                handler.sendMessage(msg);
            }
        });
    }

    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MSG_UPGRADE_SUCCESS:

                    break;
                case MSG_UPGRADE_FAILED:

                    break;

                default:
                    break;
            }
        }
    };


    /**
     * 初始化Iot广播接收器
     */
    private void initBroadcastReceiver() {
        iotBroadcastReceiver = new IotBroadcastReceiver();
        IntentFilter intentFilter = new IntentFilter(ProtocalConstants.OTA_UPGRADE_PROGRESS);
        localBroadcastManager = LocalBroadcastManager.getInstance(this);
        localBroadcastManager.registerReceiver(iotBroadcastReceiver, intentFilter);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        localBroadcastManager.unregisterReceiver(iotBroadcastReceiver);
    }

    /**
     * Iot广播接收器
     * 调用固件升级、格式化SD卡、刷新属性这个三个接口，设备会异步同过mqtt发布数据
     * 在MeariMessage接收到消息后，发布本地广播，在需要显示的页面注册广播接收器进行接收显示。
     * 格式化SD卡、刷新属性 参考固件升级的使用。
     * 数据解析可以换成自己的json解析方式。
     */
    private class IotBroadcastReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            // 在 MeariMessage 中收到mqtt消息，发送本地广播，详见MeariMessage
            // 接收固件升级进度
            if (ProtocalConstants.OTA_UPGRADE_PROGRESS.equals(intent.getAction())) {
                String data = intent.getStringExtra("mqttData");
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(data);
                    jsonObject = jsonObject.optBaseJSONObject("items");
                    BaseJSONObject progressJson = jsonObject.optBaseJSONObject(IotConstants.OTAUpgradeTotal);
                    int progress = progressJson.optInt("value");
                    // 显示升级进度
                    tv_progress.setText(progress + "%");

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            //接收刷新属性
            if (ProtocalConstants.DEVICE_REFRESH_PROPERTY.equals(intent.getAction())) {
                String data = intent.getStringExtra("mqttData");
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(data);
                    jsonObject = jsonObject.optBaseJSONObject("items");
                    BaseJSONObject wifiJson = jsonObject.optBaseJSONObject(IotConstants.wifiStrength);
                    // wifi强度
                    int value = wifiJson.optInt("value");
//                    String wifiStrength = value + "%";
//                    tv_wifi.setText(wifiStrength);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            //接收格式化sd卡进度
            if (ProtocalConstants.FORMAT_SDCARD_PROGRESS.equals(intent.getAction())) {
                String data = intent.getStringExtra("mqttData");
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(data);
                    jsonObject = jsonObject.optBaseJSONObject("items");
                    BaseJSONObject progressJson = jsonObject.optBaseJSONObject(IotConstants.sdFormatProgress);
                    // 格式化sd卡进度
                    int progress = progressJson.optInt("value");
//                    showFormatPercent(progress);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
    }

}
