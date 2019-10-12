package com.meari.test;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.Selection;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;

import com.meari.test.common.ActivityType;
import com.meari.test.common.Distribution;
import com.meari.test.common.StringConstants;
import com.meari.test.common.UtilsSharedPreference;
import com.meari.test.permission_utils.Func;
import com.meari.test.permission_utils.PermissionUtil;
import com.meari.test.receiver.ExitAppReceiver;
import com.meari.test.receiver.WifiReceiver;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.WifiConnectHelper;

import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/28
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class WifiListActivity extends BaseActivity implements WifiReceiver.WifiChangeListener {

    @BindView(R.id.wifi_name_et)
    public EditText wifi_name_et;               //用户 edits
    @BindView(R.id.pwd_et)
    public EditText pwd_et;
    @BindView(R.id.laogin_lookpwdbtn)
    public CheckBox mPwdCheck;
    @BindView(R.id.wifi_check)
    public CheckBox mWifi_check;
    private WifiManager mWifiManager;
    private boolean isCheck = true;              //是否是选中状态
    private UtilsSharedPreference sp;           //存储密码的sharedpreference
    private WifiConnectHelper mWifiHelper;
    private ExitAppReceiver quitReceiver = new ExitAppReceiver();
    private WifiReceiver mReceiver;

    final private int REQUEST_CODE_ASK_PERMISSIONS = 121;//权限请求码
    public static final String LOCATION = android.Manifest.permission.ACCESS_COARSE_LOCATION;
    private PermissionUtil.PermissionRequestObject mLocationPermissionRequest;
    private int mDistributionType ;
    private int mDeviceTypeID;
    private final int SECURITY_PSK = 2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wifi_list);
        getTopTitleView();
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            this.mDistributionType = bundle.getInt(StringConstants.DISTRIBUTION_TYPE, Distribution.DISTRIBUTION_SMART);
            mDeviceTypeID = bundle.getInt(StringConstants.DEVICE_TYPE_ID, 2);
        }
        this.mCenter.setText(R.string.routerWifi);
        mWifiHelper = new WifiConnectHelper(this);
        onCheckLocationPermissionClick();
        mWifiHelper.openWifi();
        init();
        registerQuitChangeReceiver();
        registerWiFiChangeReceiver();
    }

    public void onCheckLocationPermissionClick() {
        boolean hasStoragePermission = PermissionUtil.with(this).has(LOCATION);
        if (!hasStoragePermission) {
            mLocationPermissionRequest = PermissionUtil.with(this).request(android.Manifest.permission.ACCESS_COARSE_LOCATION).onAllGranted(
                    new Func() {
                        @Override
                        protected void call() {

                        }
                    }).onAnyDenied(
                    new Func() {
                        @Override
                        protected void call() {
                        }
                    }).ask(REQUEST_CODE_ASK_PERMISSIONS);
        }
    }

    @Override
    public void finish() {
        super.finish();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unRegisterReceiver();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (mLocationPermissionRequest != null)
            mLocationPermissionRequest.onRequestPermissionsResult(requestCode, permissions, grantResults);
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    /**
     * 设置edittext的ssid
     */
    private void setWifi() {
        if (isWifiConnected(this)) {
            WifiInfo info = mWifiHelper.getWifiManager().getConnectionInfo();
            if (info.getBSSID() != null && info.getBSSID().length() == 0) {
                CommonUtils.showDialog(WifiListActivity.this, getString(R.string.location_waring), positiveListener, false);
                return;
            }
            String ssid = mWifiManager.getConnectionInfo().getSSID();
            ssid = ssid.substring(1, ssid.length() - 1);
            String pwd = sp.getWifipwd(ssid);
            String ssidstr = wifi_name_et.getText().toString();
            if (ssidstr.equals(ssid)) {
                return;
            }
            setEditSSIDText(ssid);
            if (pwd != null && !pwd.isEmpty()) {
                pwd_et.setText(pwd);
                isCheck = true;
            } else {
                pwd_et.setText("");
            }
        }
    }

    /**
     * 初始化
     */
    private void init() {
        mWifiManager = mWifiHelper.getWifiManager();
        mWifi_check.setChecked(true);
        mWifi_check.setEnabled(true);
        mWifi_check.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    wifi_name_et.setEnabled(false);
                    setWifi();
                } else {
                    wifi_name_et.setEnabled(true);
                }
            }
        });
        wifi_name_et.addTextChangedListener(ssidChangedListener);
        findViewById(R.id.laogin_lookpwdbtn).setTag(true);
        pwd_et.addTextChangedListener(pwdChangedListener);
        isCheck = false;
        sp = new UtilsSharedPreference(this);
        mPwdCheck.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!isChecked) {
                    // 文本以密码形式显示
                    pwd_et.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                    // 下面两行代码实现: 输入框光标一直在输入文本后面
                    Editable editable = pwd_et.getText();
                    Selection.setSelection(editable, editable.length());
                } else {
                    // 文本正常显示
                    pwd_et.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                    Editable editable = pwd_et.getText();
                    Selection.setSelection(editable, editable.length());
                }
            }
        });
        pwd_et.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
        pwd_et.setImeOptions(EditorInfo.IME_ACTION_NEXT);
        pwd_et.setOnEditorActionListener(new TextView.OnEditorActionListener() {

            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_NEXT) {
                    btnNextClick(null);
                }
                return false;
            }
        });
        setWifi();
    }

    /**
     * 监听SSID的变化
     */
    private TextWatcher ssidChangedListener = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {

        }

        @Override
        public void afterTextChanged(Editable s) {
            String str = s.toString();
            if (str.length() > 0) {
                findViewById(R.id.wifilist_ssid_clear).setVisibility(View.GONE);
            } else {
                findViewById(R.id.wifilist_ssid_clear).setVisibility(View.GONE);
            }
        }
    };

    /**
     * 监听密码的变化
     */
    private TextWatcher pwdChangedListener = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {

        }

        @Override
        public void afterTextChanged(Editable s) {
            String str = s.toString();
            if (str.length() > 0) {
                findViewById(R.id.btn_pwd_clear).setVisibility(View.VISIBLE);
                if (isCheck) {    // 选中记住密码就保存密码
                    saveSSIDPassword(wifi_name_et.getText().toString(), pwd_et.getText().toString());
                }
            } else {
                findViewById(R.id.btn_pwd_clear).setVisibility(View.GONE);
            }
        }
    };


    /**
     * 下一步
     */
    @OnClick(R.id.btn_connect)
    public void btnNextClick(View view) {
        String wifiName = String.valueOf(wifi_name_et.getText());
        String pwd = String.valueOf(pwd_et.getText());
        if (wifiName == null || wifiName.isEmpty()) {
            CommonUtils.showToast(getResources().getString(R.string.ssid_pwd_null));
            return;
        }
        if (this.mDistributionType == Distribution.DISTRIBUTION_AP) {
            saveSSIDPassword(wifi_name_et.getText().toString(), pwd_et.getText().toString());
            //获取ssid pwd

            Intent intent = new Intent(this, ApConnectActivity.class);
            Bundle bundle = new Bundle();
            bundle.putString(StringConstants.WIFI_NAME, wifiName);
            bundle.putString(StringConstants.WIFI_PWD, pwd);
            bundle.putInt(StringConstants.DEVICE_TYPE_ID , this.mDeviceTypeID);
            intent.putExtras(bundle);
            startActivityForResult(intent, 0);
        } else if(this.mDistributionType == Distribution.DISTRIBUTION_SMART)  {
            saveSSIDPassword(wifi_name_et.getText().toString(), pwd_et.getText().toString());


            Intent intent = new Intent(this, SearchCameraResultActivity.class);
            Bundle bundle = new Bundle();
            bundle.putString(StringConstants.WIFI_NAME, wifiName);
            bundle.putString(StringConstants.WIFI_PWD, pwd);
            bundle.putInt(StringConstants.DEVICE_TYPE_ID, mDeviceTypeID);
            bundle.putBoolean(StringConstants.SMART_CONFIG, true);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_SEARCHCANERARESLUT);
        }else
        {
            Intent intent =new  Intent(this, QRCodeActivity.class);
            Bundle bundle = new Bundle();
            bundle.putString(StringConstants.WIFI_NAME, wifiName);
            bundle.putString(StringConstants.WIFI_PWD, pwd);
            bundle.putInt(StringConstants.WIFI_MODE, 2);
            bundle.putInt(StringConstants.DEVICE_TYPE_ID, mDeviceTypeID);
            bundle.putInt(StringConstants.DISTRIBUTION_TYPE, mDistributionType);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_QR_CODE);
        }

    }

    /**
     * 保存密码
     *
     * @param sid wifi name
     * @param pwd password
     */
    private void saveSSIDPassword(String sid, String pwd) {
        sp.savaWifiInfo(sid, pwd);
    }

    /**
     * 清空 editText的 pwd
     *
     * @param view
     */
    public void pwdClearClick(View view) {
        pwd_et.setText("");
    }

    /**
     * 清空  editText的 SSID
     *
     * @param view 控件
     */
    public void ssidClearClick(View view) {
        saveSSIDPassword(wifi_name_et.getText().toString().trim(), "");
        wifi_name_et.setText("");
    }


    //是否连接WIFI
    public boolean isWifiConnected(Context context) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(CONNECTIVITY_SERVICE);
        NetworkInfo wifiNetworkInfo = connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        return wifiNetworkInfo.isConnected();
    }

    /**
     * 设置SSID文本框 的文本
     *
     * @param ssid
     */
    private void setEditSSIDText(String ssid) {
        wifi_name_et.setText(ssid);
    }

    public void unRegisterReceiver() {
        unregisterReceiver(quitReceiver);
        unregisterReceiver(mReceiver);
    }

    public void registerQuitChangeReceiver() {
        IntentFilter exitFilter = new IntentFilter();
        registerReceiver(quitReceiver, exitFilter);
    }

    DialogInterface.OnClickListener positiveListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            finish();
        }
    };

    @Override
    public void changeWifi(WifiInfo wifiInfo) {
        if (wifiInfo == null)
            return;
        String ssid = wifiInfo.getSSID();
        ssid = ssid.substring(1, ssid.length() - 1);
        String pwd = sp.getWifipwd(ssid);
        String ssidstr = wifi_name_et.getText().toString();
        if (ssidstr.equals(ssid)) {
            return;
        }
        setEditSSIDText(ssid);
        if (pwd != null && !pwd.isEmpty()) {
            pwd_et.setText(pwd);
            isCheck = true;
        } else {
            pwd_et.setText("");
        }
    }

    @Override
    public void disConnected() {

    }

    @Override
    public void connectTraffic() {

    }

    public void registerWiFiChangeReceiver() {
        mReceiver = new WifiReceiver(this);
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction("android.net.conn.CONNECTIVITY_CHANGE");
        registerReceiver(this.mReceiver, exitFilter);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 0:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK, data);
                    finish();
                }
                break;
            case ActivityType.ACTIVITY_SEARCHCANERARESLUT:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK, data);
                    finish();
                }
                break;
        }
    }

    private int getSecurity(WifiConfiguration config) {
        if (config.allowedKeyManagement.get(WifiConfiguration.KeyMgmt.WPA_PSK)) {
            return SECURITY_PSK;
        }
        if (config.allowedKeyManagement.get(WifiConfiguration.KeyMgmt.WPA_EAP) || config.allowedKeyManagement.get(WifiConfiguration.KeyMgmt.IEEE8021X)) {
            int SECURITY_EAP = 3;
            return SECURITY_EAP;
        }
        int SECURITY_NONE = 0;
        int SECURITY_WEP = 1;
        return (config.wepKeys[0] != null) ? SECURITY_WEP : SECURITY_NONE;
    }

    public int getWifiMode(WifiInfo info) {
        List<WifiConfiguration> wifiConfigList = mWifiManager.getConfiguredNetworks();
        for (WifiConfiguration wifiConfiguration : wifiConfigList) {
            String configSSid = wifiConfiguration.SSID;
            configSSid = configSSid.replace("\"", "");
            String currentSSid = info.getSSID();
            currentSSid = currentSSid.replace("\"", "");

            if (currentSSid.equals(configSSid) && info.getNetworkId() == wifiConfiguration.networkId) {
                return getSecurity(wifiConfiguration);
            }
        }
        return SECURITY_PSK;
    }

}




