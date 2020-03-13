package com.meari.test;

import android.annotation.SuppressLint;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;

import com.meari.sdk.MeariDeviceController;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.ArmingInfo;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.DeviceParams;
import com.meari.sdk.callback.IGetDeviceParamsCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.sdk.callback.ISetDeviceParamsCallback;
import com.meari.sdk.common.DeviceType;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.EmojiFilter;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.SwitchButton;

import java.text.BreakIterator;
import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/27
 * 描    述：IPC设置页面
 * 修订历史：
 * ================================================
 */
@SuppressLint("HandlerLeak")
public class CameraSettingActivity extends BaseActivity {
    private static final String TAG = "CameraSettingActivity";
    private final int MESSAGE_LOGIN_SUCCESS = 1001;
    private final int MESSAGE_LOGIN_FAILED = 1002;
    private final int MESSAGE_MIRROR = 1003;
    private final int MESSAGE_ALARM = 1004;
    private final int MESSAGE_VERSION = 1005;
    private final int MESSAGE_SETTING_MIRROR_SUCCESS = 1008;
    private final int MESSAGE_SETTING_MIRROR_FAILED = 1009;

    private final int MSG_GET_DEVICE_PARAMS_SUCCESS = 2000;
    private final int MSG_GET_DEVICE_PARAMS_FAILED = 2001;
    private final int MSG_SETTING_SUCCESS = 2002;
    private final int MSG_SETTING_FAILED = 2003;
    private CameraInfo mInfo;
    private MeariDeviceController deviceController;
    private DeviceParams mDeviceParams;
    public static String mVersion = "";
    public static boolean mBUpdate = false;
    private ArmingInfo mAlarm = new ArmingInfo();
    private String[] mMotionList;
    private int[] mMotionListValue;
    private boolean mIsReady = false;//获取参数成功
    private ArrayList<ArmingInfo> mDevAlarmList;
    private ArrayList<ArmingInfo> mDecibelAlarmList;
    private boolean bInitSwitch = false;
    @BindView(R.id.layout_mirror)
    View layoutMirror;
    @BindView(R.id.layout_led)
    View layoutLed;
    @BindView(R.id.switch_mirror)
    public SwitchButton switchMirror;
    @BindView(R.id.switch_led)
    public SwitchButton switchLed;
    @BindView(R.id.setting_aliasText)
    public EditText mAliasEdit;
    @BindView(R.id.arm_text)
    public TextView textMotion;
    @BindView(R.id.version_text)
    public TextView mVersionText;

    // 是否支持iot设置
    private boolean isIothub = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_camera_setting);
        initData();
        initView();
    }

    private void initData() {
        mInfo = MeariUser.getInstance().getCameraInfo();
        deviceController = MeariUser.getInstance().getController();
        this.mMotionList = getResources().getStringArray(R.array.miror_action);
        this.mMotionListValue = getResources().getIntArray(R.array.sensitivity_com_value);

    }

    private void initView() {
        TextView uuid = findViewById(R.id.uuid_text);
        uuid.setText(mInfo.getSnNum());
        getTopTitleView();
        this.mCenter.setText(getString(R.string.settings_title));
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        this.mRightBtn.setVisibility(View.VISIBLE);
        TextView account = findViewById(R.id.useraccount_text);
        account.setText(mInfo.getUserAccount());

        mAliasEdit.setText(mInfo.getDeviceName());
        mAliasEdit.requestFocus();
        if (!this.mInfo.isAsFriend()) {
            mAliasEdit.addTextChangedListener(new TextWatcher() {
                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    if (s.length() > 0) {
                        if (s.equals(mInfo.getDeviceName())) {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
                        } else {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.VISIBLE);
                        }
                    }
                }

                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void afterTextChanged(Editable s) {
                }
            });
            mAliasEdit.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (mAliasEdit.getText().toString().trim().length() > 0) {
                        if (mAliasEdit.getText().toString().trim().equals(mInfo.getDeviceName())) {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
                        } else {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.VISIBLE);
                        }
                    }
                }
            });
        }

        if (mInfo.isUpdateVersion()) {
            findViewById(R.id.update_hot).setVisibility(View.VISIBLE);
        }

        switchMirror.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (buttonView.isEnabled()) {
                    setMirror(isChecked ? 1 : 0);
                }
            }
        });

        switchLed.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (buttonView.isEnabled()) {
                    setLed(isChecked ? 1 : 0);
                }
            }
        });

        getDeviceParams();
    }

    private Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            stopProgressDialog();
            switch (msg.what) {
                case MSG_GET_DEVICE_PARAMS_SUCCESS:
                    showToast("Get device params success!");
                    initStatus();
                    break;
                case MSG_GET_DEVICE_PARAMS_FAILED:
                    showToast("Get device params failed!");
                    break;
                case MSG_SETTING_SUCCESS:
                    showToast("set success!");
                    break;
                case MSG_SETTING_FAILED:
                    showToast("set failed!");
                    break;
            }
            return false;
        }
    });

    /**
     * get device params
     * 获取设备参数
     */
    private void getDeviceParams() {
        startProgressDialog();
        MeariUser.getInstance().getDeviceParams(new IGetDeviceParamsCallback() {
            @Override
            public void onSuccess(DeviceParams deviceParams) {
                mIsReady = true;
                mDeviceParams = deviceParams;
                handler.sendEmptyMessage(MSG_GET_DEVICE_PARAMS_SUCCESS);
            }

            @Override
            public void onFailed(int i, String s) {
                handler.sendEmptyMessage(MSG_GET_DEVICE_PARAMS_FAILED);
            }
        });
    }

    private void initStatus() {
        DeviceParams deviceParams = MeariUser.getInstance().getCachedDeviceParams();
        if (deviceParams == null) {
            return;
        }
        switchLed.setEnabled(false);
        switchLed.setChecked(deviceParams.getLedEnable() == 1);
        switchLed.setEnabled(true);

        switchMirror.setEnabled(false);
        switchMirror.setChecked(deviceParams.getMirrorEnable() == 1);
        switchMirror.setEnabled(true);

        int sen = deviceParams.getMotionDetSensitivity();
        String text = "";
        for (int i = 0; i <mMotionListValue.length ; i++) {
            if (sen == mMotionListValue[i]) {
                text = mMotionList[i];
            }
        }
        textMotion.setText(text);

        setDeviceVersion(deviceParams.getFirmwareCode());
    }

    private void setDeviceVersion(String mVersion) {
        if (mVersion != null) {
            String[] versionList = mVersion.split("-");
            if (versionList.length == 0) {
                mVersionText.setText(getString(R.string.fail));
            } else {
                mVersionText.setText(versionList[versionList.length - 1]);
            }
        } else {
            mVersionText.setText(getString(R.string.fail));
        }
    }

    private void setMirror(int enable) {
        startProgressDialog();
        MeariUser.getInstance().setMirror(enable, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                handler.sendEmptyMessage(MSG_SETTING_SUCCESS);
            }

            @Override
            public void onFailed(int i, String s) {
                handler.sendEmptyMessage(MSG_SETTING_FAILED);
            }
        });
    }

    private void setLed(int enable) {
        startProgressDialog();
        MeariUser.getInstance().setLED(enable, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                handler.sendEmptyMessage(MSG_SETTING_SUCCESS);
            }

            @Override
            public void onFailed(int i, String s) {
                handler.sendEmptyMessage(MSG_SETTING_FAILED);
            }
        });
    }

    @OnClick({R.id.update_device_layout, R.id.alarmContent,R.id.sd_layout,R.id.layout_nvr,R.id.home_device_layout,
            R.id.share_layout,R.id.submitRegisterBtn,R.id.setting_alias_ok})
    public void onViewClicked(View view) {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        switch (view.getId()) {
            case R.id.update_device_layout:
                if (!mIsReady)
                    return;
                if (this.mInfo.isAsFriend()) {
                    CommonUtils.showToast(R.string.cant_noset);
                    return;
                }
                intent.setClass(CameraSettingActivity.this, UpdateDeviceActivity.class);
                bundle.putString("version", mVersion);
                bundle.putSerializable("cameraInfo", mInfo);
                intent.putExtras(bundle);
                startActivityForResult(intent, ActivityType.ACTIVITY_UPDATEDEVICE);
                break;
            case R.id.alarmContent:
                if (!mIsReady)
                    return;
                if (this.mInfo.isAsFriend()) {
                    CommonUtils.showToast(R.string.pps_cant_noset);
                    return;
                }
                intent.setClass(CameraSettingActivity.this, MotionActivity.class);
                bundle.putSerializable("motion", mAlarm);
                bundle.putSerializable("cameraInfo", mInfo);
                intent.putExtras(bundle);
                startActivityForResult(intent, ActivityType.ACTIVITY_MOTION);
                break;
            case R.id.sd_layout:
                if (!mIsReady)
                    return;
                if (this.mInfo.isAsFriend()) {
                    CommonUtils.showToast(R.string.pps_cant_noset);
                    return;
                }
                intent.setClass(CameraSettingActivity.this, FormatSDActivity.class);
                startActivityForResult(intent, ActivityType.ACTIVITY_FORMATSD);
                break;
            case R.id.layout_nvr:
                intent.setClass(this, NvrRemoveCameraActivity.class);
                bundle.putSerializable("cameraInfo", mInfo);
                bundle.putInt("nvrID", mInfo.getNvrID());
                intent.putExtras(bundle);
                startActivityForResult(intent, ActivityType.ACTIVITY_REMOVE_CAMERA);
                break;
            case R.id.home_device_layout:
                if (!mIsReady)
                    return;
                if (this.mInfo.isAsFriend()) {
                    CommonUtils.showToast(R.string.pps_cant_noset);
                    return;
                }
                if (mInfo.getProtocolVersion() < 2) {
                    CommonUtils.showToast(getString(R.string.version_warning));
                    return;
                }

                intent.setClass(this, SleepModeMethodActivity.class);
                bundle.putSerializable("cameraInfo", mInfo);
                intent.putExtras(bundle);
                startActivityForResult(intent, ActivityType.ACTIVITY_SLEEPMODE);
                break;
            case R.id.share_layout:
                intent.setClass(this, ShareDeviceActivity.class);
                bundle.putSerializable("cameraInfo", mInfo);
                intent.putExtras(bundle);
                startActivity(intent);
                break;
            case R.id.submitRegisterBtn:
                CommonUtils.showDlg(this, getString(R.string.app_meari_name), getString(R.string.sure_delete),
                        getString(R.string.ok), positiveClick,
                        getString(R.string.cancel), negativeClick, true);
                break;
            case R.id.setting_alias_ok:
                if (this.mInfo.isAsFriend()) {
                    CommonUtils.showToast(R.string.pps_cant_noset);
                    return;
                }
                String deviceName = mAliasEdit.getText().toString().trim();
                if (deviceName == null || deviceName.length() == 0) {
                    CommonUtils.showToast(getString(R.string.deviceisnull));
                    return;
                }
                if (!EmojiFilter.isNormalString(deviceName)) {
                    CommonUtils.showToast(getString(R.string.name_format_error));
                    return;
                }
                mAliasEdit.setText(deviceName);
                startProgressDialog(getString(R.string.pps_waite));
                MeariUser.getInstance().renameDevice(this.mInfo.getDeviceID(), DeviceType.IPC, deviceName, new IResultCallback() {
                    @Override
                    public void onSuccess() {
                        stopProgressDialog();
                        showToast(getString(R.string.update_device_suc));
                        mInfo.setDeviceName(mAliasEdit.getText().toString());
                    }

                    @Override
                    public void onError(int code, String error) {
                        stopProgressDialog();
                        showToast(error);
                        mInfo.setDeviceName(mAliasEdit.getText().toString());
                    }
                });
                break;
        }
    }

    private DialogInterface.OnClickListener positiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            postDeleteDevice();
        }
    };
    private DialogInterface.OnClickListener negativeClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };

    private void postDeleteDevice() {
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        startProgressDialog();
        MeariUser.getInstance().deleteDevice(mInfo.getDeviceID(), DeviceType.IPC, new IResultCallback() {
            @Override
            public void onSuccess() {
                stopProgressDialog();
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putInt("type", 1);
                bundle.putSerializable(StringConstants.CAMERA_INFO, mInfo);
                intent.putExtras(bundle);
                setResult(RESULT_OK, intent);
                Preference.getPreference().removeDeviceBySn(mInfo.getSnNum());
                finish();
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }
        });

    }


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putInt("type", 0);
            bundle.putSerializable(StringConstants.CAMERA_INFO, this.mInfo);
            intent.putExtras(bundle);
            setResult(RESULT_OK, intent);
            finish();
            return super.onKeyDown(keyCode, event);
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case ActivityType.ACTIVITY_MOTION:
                if (resultCode == RESULT_OK) {
                    mAlarm = (ArmingInfo) data.getSerializableExtra("motion");

                }
                break;
            case ActivityType.ACTIVITY_UPDATEDEVICE:
                if (mVersionText != null) {
                    if (mVersion != null) {
                        String[] versionList = mVersion.split("-");
                        if (versionList.length == 0) {
                            mVersionText.setText(getString(R.string.fail));
                        } else
                            mVersionText.setText(versionList[versionList.length - 1]);
                    }
                }
                if (mBUpdate) {
                    if (findViewById(R.id.update_hot) != null)
                        findViewById(R.id.update_hot).setVisibility(View.GONE);
                }
                break;
            case ActivityType.ACTIVITY_REMOVE_CAMERA:
                if (resultCode == RESULT_OK) {
                    findViewById(R.id.layout_nvr).setVisibility(View.GONE);
                }
                break;
            case ActivityType.ACTIVITY_SLEEPMODE:
                Bundle bundle = data.getExtras();
                if (bundle != null) {
                    mInfo = (CameraInfo) bundle.getSerializable("cameraInfo");
                }
                break;
            default:
                break;
        }
    }

    @Override
    public void finish() {
        setResult(RESULT_OK);
        super.finish();
    }
}
