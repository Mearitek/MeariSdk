package com.meari.test;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.wifi.WifiInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;

import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;
import com.meari.test.utils.WifiConnectHelper;
import com.meari.test.widget.CustomDialog;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/2
 * 描    述：配置Ap模式页面
 * 修订历史：
 * ================================================
 */

public class ApConnectActivity extends BaseActivity {
    private WifiConnectHelper mWifiHelper;
    private String mServiceSetIdentifier;
    private String mPwd;
    private APModelDistrbutionTask mApModelTask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_connect);
        initData();
        mWifiHelper = new WifiConnectHelper(this);
        mWifiHelper.openWifi();
        initView();
    }

    private RotateAnimation mLoadAnimation = new RotateAnimation(0, 360, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);

    private void initData() {
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            this.mServiceSetIdentifier = bundle.getString(StringConstants.WIFI_NAME);
            this.mPwd = bundle.getString(StringConstants.WIFI_PWD);
            this.mDeviceTypeID = bundle.getInt("deviceTypeID", 2);
        }
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.text_try_manual));
    }

    @OnClick(R.id.text_nonecnting_tips)
    public void onNextClick() {
        Intent helpIntent = new Intent(this, APHelpActivity.class);
        startActivity(helpIntent);
    }

    @OnClick(R.id.pps_next)
    public void goWifiSettingactivity() {
        WifiInfo info = mWifiHelper.getWifiManager().getConnectionInfo();
        if (info != null) {
            String ssid = info.getSSID();
            ssid = ssid.substring(1, ssid.length() - 1);
            if (ssid.startsWith("STRN_")) {
                showLoadView(1);
                CameraPlayer apPlayer = new CameraPlayer();
                apPlayer.setAP(this.mServiceSetIdentifier, this.mPwd, new CameraPlayerListener() {
                            @Override
                            public void PPSuccessHandler(String successMsg) {

                                if (mEventHandle != null) {
                                    mEventHandle.sendEmptyMessage(0);
                                }
                            }

                            @Override
                            public void PPFailureError(String errorMsg) {
                                mEventHandle.sendEmptyMessage(3);
                            }
                        }
                );
                return;
            }
        }
        Intent intent = new Intent(Settings.ACTION_WIFI_SETTINGS);
        startActivityForResult(intent, 0);

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 0:
                setApConnect();
                break;
            case ActivityType.ACTIVITY_SEARCHCANERARESLUT:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK, data);
                    finish();
                }
                break;
        }
    }

    private void showLoadView(int status) {
        switch (status) {
            case 0:
                findViewById(R.id.loading_dialog_img).setVisibility(View.GONE);
                findViewById(R.id.loading_ok_img).setVisibility(View.GONE);
                findViewById(R.id.loading_failed_img).setVisibility(View.GONE);
                findViewById(R.id.pps_next).setVisibility(View.VISIBLE);
                break;
            case 1:
                findViewById(R.id.loading_dialog_img).setVisibility(View.VISIBLE);
                findViewById(R.id.loading_ok_img).setVisibility(View.GONE);
                findViewById(R.id.loading_failed_img).setVisibility(View.GONE);
                findViewById(R.id.loading_dialog_img).startAnimation(mLoadAnimation);
                findViewById(R.id.pps_next).startAnimation(mLoadAnimation);
                break;
            case 2:
                findViewById(R.id.loading_dialog_img).setVisibility(View.GONE);
                findViewById(R.id.pps_next).setVisibility(View.GONE);
                findViewById(R.id.loading_failed_img).setVisibility(View.GONE);
                findViewById(R.id.loading_ok_img).setVisibility(View.VISIBLE);
                break;
            case 3:
                findViewById(R.id.loading_dialog_img).setVisibility(View.GONE);
                findViewById(R.id.pps_next).setVisibility(View.GONE);
                findViewById(R.id.loading_ok_img).setVisibility(View.VISIBLE);
                findViewById(R.id.loading_failed_img).setVisibility(View.VISIBLE);
                break;
        }
    }

    private void setApConnect() {
        if (NetUtil.isWifiConnect(this)) {
            WifiInfo info = mWifiHelper.getWifiManager().getConnectionInfo();
            showLoadView(1);
            if (info != null) {
                String sid = info.getSSID();
                sid = sid.substring(1, sid.length() - 1);
                if (sid.startsWith("STRN_")) {
                    CameraPlayer apPlayer = new CameraPlayer();
                    apPlayer.updatetoken(Preference.getPreference().getToken());
                    apPlayer.setAP(this.mServiceSetIdentifier, this.mPwd, new CameraPlayerListener() {
                                @Override
                                public void PPSuccessHandler(String successMsg) {

                                    if (mEventHandle != null) {
                                        mEventHandle.sendEmptyMessage(0);
                                    }
                                }

                                @Override
                                public void PPFailureError(String errorMsg) {
                                    mEventHandle.sendEmptyMessage(1);
                                }
                            }
                    );


                } else
                    showLoadView(0);
            }
        }
    }

    private CustomDialog mCustomDialog;
    private int mDeviceTypeID;
    @SuppressLint("HandlerLeak")
    public Handler mEventHandle = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case 0:
                    if (mApModelTask != null)
                        mApModelTask.cancel(true);
                    mApModelTask = null;
                    mApModelTask = new APModelDistrbutionTask();
                    mApModelTask.execute();

                    break;
                case 1:
                    if (mCustomDialog == null) {
                        mCustomDialog = showDlg(ApConnectActivity.this, getString(R.string.no_device_dlg), getString(R.string.no_device_message), getString(R.string.cancel), mPositiveClick
                                , getString(R.string.redo), mNegtiveClick, true);
                    } else {
                        mCustomDialog.show();
                    }
                    break;
            }
        }
    };
    private DialogInterface.OnClickListener mNegtiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            WifiInfo info = mWifiHelper.getWifiManager().getConnectionInfo();
            if (info != null) {
                String sid = info.getSSID();
                sid = sid.substring(1, sid.length() - 1);
                showLoadView(1);
                if (sid.startsWith("STRN_")) {
                    CameraPlayer apPlayer = new CameraPlayer();
                    apPlayer.updatetoken(Preference.getPreference().getToken());
                    apPlayer.setAP(mServiceSetIdentifier, mPwd, new CameraPlayerListener() {
                                @Override
                                public void PPSuccessHandler(String successMsg) {

                                    if (mEventHandle != null) {
                                        mEventHandle.sendEmptyMessage(0);
                                    }
                                }

                                @Override
                                public void PPFailureError(String errorMsg) {
                                    mEventHandle.sendEmptyMessage(3);
                                }
                            }
                    );
                }
            }
        }
    };

    private DialogInterface.OnClickListener mPositiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };

    public CustomDialog showDlg(Context context, String title, String message, String positiveBtnName,
                                DialogInterface.OnClickListener positiveListener, String NegativeBtnName,
                                DialogInterface.OnClickListener negativeListener, boolean bCance) {
        try {
            CustomDialog.Builder localBuilder = new CustomDialog.Builder(context);
            localBuilder.setTitle(title).setMessage(message);
            if (positiveBtnName != null)
                localBuilder.setPositiveButton(positiveBtnName, positiveListener);
            if (NegativeBtnName != null)
                localBuilder.setNegativeButton(NegativeBtnName, negativeListener);
            CustomDialog dlg = localBuilder.create();
            dlg.setCancelable(bCance);
            dlg.setCanceledOnTouchOutside(bCance);
            localBuilder.setMessageTips(getString(R.string.found_tips));
            localBuilder.setMessageClick(messageClickListener);
            return dlg;
        } catch (Exception e) {
            return null;
        }
    }

    private View.OnClickListener messageClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View param) {
            Intent helpIntent = new Intent(ApConnectActivity.this, DeviceStatusHelpActivity.class);
            startActivity(helpIntent);
        }
    };

    @Override
    public void finish() {
        super.finish();
        mEventHandle = null;
    }

    public class APModelDistrbutionTask extends AsyncTask<Void, Void, Boolean> {

        @Override
        protected Boolean doInBackground(Void... params) {

            mWifiHelper.addNetwork(mWifiHelper.CreateWifiInfo(mServiceSetIdentifier, mPwd, 3));
            for (int i = 0; i < 10; i++) {
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                WifiInfo info = mWifiHelper.getWifiManager().getConnectionInfo();
                String wifiName = "\"" + mServiceSetIdentifier + "\"";
                if (NetUtil.isWifiConnect(ApConnectActivity.this) && info != null && info.getSSID().equals(wifiName)) {
                    CommonUtils.getSdkUtil().updatetoken(Preference.getPreference().getToken());
                    CommonUtils.getSdkUtil().setApwifi(mServiceSetIdentifier, mPwd);
                    break;
                }
            }
            return null;
        }

        @Override
        protected void onPostExecute(Boolean result) {
            super.onPostExecute(result);
            stopProgressDialog();
            showLoadView(0);
            Intent intent = new Intent(ApConnectActivity.this, SearchCameraResultActivity.class);
            Bundle bundle = new Bundle();
            bundle.putString(StringConstants.WIFI_NAME, mServiceSetIdentifier);
            bundle.putString(StringConstants.WIFI_PWD, mPwd);
            bundle.putBoolean(StringConstants.SMART_CONFIG, false);
            bundle.putInt(StringConstants.DEVICE_TYPE_ID, mDeviceTypeID);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_SEARCHCANERARESLUT);
        }

    }
}
