package com.meari.test;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.wifi.WifiInfo;
import android.os.Build;
import android.os.Bundle;
import androidx.annotation.RequiresApi;
import android.widget.TextView;

import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.bean.NvrDeviceStatusInfo;
import com.meari.test.common.ActivityType;
import com.meari.test.receiver.WifiReceiver;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;

import java.util.ArrayList;

import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/17
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class NVRWifiActivity extends BaseActivity implements WifiReceiver.WifiChangeListener {
    private NVRInfo mNvrInfo;
    private ArrayList<NvrDeviceStatusInfo> mInfos;
    private TextView mWifiText;
    private WifiReceiver mReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nvr_wifi);
        initData();
        registerWiFiChangeReceiver();
        initView();
    }

    public void registerWiFiChangeReceiver() {
        mReceiver = new WifiReceiver(this);
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction("android.net.conn.CONNECTIVITY_CHANGE");
        registerReceiver(this.mReceiver, exitFilter);
    }

    private void initData() {
        this.mInfos = (ArrayList<NvrDeviceStatusInfo>) getIntent().getExtras().getSerializable("unBindCameras");
        this.mNvrInfo = (NVRInfo) getIntent().getExtras().getSerializable("nvrInfo");
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.nvr_wifi_title));
        mWifiText =  findViewById(R.id.edit_ssid);
        if (!NetUtil.isWifiConnect(this)) {
            mWifiText.setText(getString(R.string.please_connect_wifi));
        } else {
            WifiInfo wifi = NetUtil.getConnectWifiInfo(this);
            if (wifi != null) {
                String sid = wifi.getSSID();
                sid = sid.substring(1, sid.length() - 1);
                mWifiText.setText(sid);
            }
        }
    }

    @OnClick(R.id.btn_connect)
    public void onConnectClick() {
        if (!NetUtil.isWifiConnect(this)) {
            CommonUtils.showDlg(this, getString(R.string.network_setting), getString(R.string.message_connect_wifi),
                    getString(R.string.ok), mPositiveListener, getString(R.string.cancel), negativeListener, true);
            return;
        } else {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            intent.setClass(this, AddNvrCameraActivity.class);
            ArrayList<NvrDeviceStatusInfo> infos = getUnBindCameras();
            bundle.putSerializable("unBindCameras", infos);
            bundle.putSerializable("nvrInfo", mNvrInfo);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_ADD_NVR_CAMERA);
        }
    }

    private DialogInterface.OnClickListener mPositiveListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialogInterface, int i) {
            dialogInterface.dismiss();
            Intent intent = new Intent();
            intent.setAction("android.net.wifi.PICK_WIFI_NETWORK");
            startActivity(intent);
        }
    };
    private DialogInterface.OnClickListener negativeListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialogInterface, int i) {
            dialogInterface.dismiss();
        }
    };

    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterReceiver(mReceiver);
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void changeWifi(WifiInfo wifiInfo) {
        if (NVRWifiActivity.this.isFinishing() || NVRWifiActivity.this.isDestroyed())
            return;
        if (wifiInfo != null) {
            String ssid = wifiInfo.getSSID();
            ssid = ssid.substring(1, ssid.length() - 1);
            mWifiText.setText(ssid);
        } else
            mWifiText.setText(getString(R.string.please_connect_wifi));
    }

    @Override
    public void disConnected() {

    }

    @Override
    public void connectTraffic() {

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_ADD_NVR_CAMERA:
                if (data == null)
                    return;
                Bundle bundle = data.getExtras();
                if (bundle == null)
                    return;
                ArrayList<NvrDeviceStatusInfo> bindInfos = (ArrayList<NvrDeviceStatusInfo>) bundle.getSerializable("bindNvrDeviceStatusInfos");
                changeCameraStatus(bindInfos);
                Boolean goRemoveActivity = bundle.getBoolean("isGoRemove", false);
                if (goRemoveActivity)
                    finish();
                break;
            default:
                break;
        }
    }

    private void changeCameraStatus(ArrayList<NvrDeviceStatusInfo> bindinfos) {
        for (NvrDeviceStatusInfo bindInfo : bindinfos) {
            for (NvrDeviceStatusInfo info : mInfos) {
                if (info.getSnNum().equals(bindInfo.getSnNum())) {
                    info.setAddStatus(bindInfo.getAddStatus());
                    continue;
                }
            }
        }
    }

    public ArrayList<NvrDeviceStatusInfo> getUnBindCameras() {
        ArrayList<NvrDeviceStatusInfo> infos = new ArrayList<>();
        if (mInfos == null || mInfos.size() == 0)
            return infos;
        for (NvrDeviceStatusInfo info : mInfos) {
            if (info.getAddStatus() == 0) {
                if (info.getAddStatus() == 0) {
                    infos.add(info);
                }
            }

        }
        return infos;
    }

    public ArrayList<NvrDeviceStatusInfo> getBindCameraInfos() {
        ArrayList<NvrDeviceStatusInfo> cameras = new ArrayList<>();
        if (mInfos == null)
            return cameras;
        for (NvrDeviceStatusInfo info : mInfos) {
            if (info.getAddStatus() != 0) {
                cameras.add(info);
            }
        }
        return cameras;
    }

    public void finish() {
        ArrayList<NvrDeviceStatusInfo> cameraInfos = getBindCameraInfos();
        if (cameraInfos.size() != 0) {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable("bindNvrDeviceStatusInfos", cameraInfos);
            bundle.putSerializable("unBindNvrDeviceStatusInfos", getUnBindCameras());
            intent.putExtras(bundle);
            setResult(RESULT_OK, intent);
        }
        super.finish();
    }

}
