package com.meari.test;


import android.annotation.SuppressLint;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.RequiresApi;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.ArmingInfo;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.callback.IPushStatusCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.sdk.callback.IStringResultCallback;
import com.meari.sdk.common.DeviceType;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.EmojiFilter;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.SwitchButton;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;
import com.ppstrong.ppsplayer.PpsdevAlarmCfg;

import org.json.JSONException;

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
public class CameraSettingActivity extends BaseActivity implements CameraPlayerListener {
    private static final String TAG = "CameraSettingActivity";
    private final int MESSAGE_LOGIN_SUCCESS = 1001;
    private final int MESSAGE_LOGIN_FAILED = 1002;
    private final int MESSAGE_MIRROR = 1003;
    private final int MESSAGE_ALARM = 1004;
    private final int MESSAGE_VERSION = 1005;
    private final int MESSAGE_SETTING_MIRROR_SUCCESS = 1008;
    private final int MESSAGE_SETTING_MIRROR_FAILED = 1009;
    private CameraInfo mInfo;
    public static String mVersion = "";
    public static boolean mBUpdate = false;
    private ArmingInfo mAlarm = new ArmingInfo();
    private String[] mMotionList;
    private int[] mMotionListValue;
    private boolean mIsReady = false;
    private ArrayList<ArmingInfo> mDevAlarmList;
    private ArrayList<ArmingInfo> mDecibelAlarmList;
    private int[] mArrowIds = {R.id.alarmArrow, R.id.version_arrow, R.id.id_arrow};
    private boolean bInitSwitch = false;
    @BindView(R.id.mirror_switchchk)
    public SwitchButton mSwitchBtn;
    @BindView(R.id.disturb_switchchk)
    public SwitchButton mDisturbSwitchBtn;
    @BindView(R.id.setting_aliasText)
    public EditText mAliasEdit;
    @BindView(R.id.version_text)
    public TextView mVersionText;
    CameraPlayer cameraPlayer;
    // 是否支持iot设置
    private boolean isIothub = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_camera_setting);
        initData();
        initView();
        connectCamera();
    }

    private void connectCamera() {
        CommonUtils.getSdkUtil().setCameraInfo(mInfo);
        //获取上一个页面已经打洞成功的cameraplayer
        cameraPlayer = CommonUtils.getSdkUtil();
        //判断cameraPlayer是否已连接设备
        if (cameraPlayer != null && cameraPlayer.IsLogined()) {
            //已经连接设备，直接拿设备信息
            mEventHandler.sendEmptyMessage(MESSAGE_LOGIN_SUCCESS);
        } else {
            //新建cameraplayer去重新connect
            cameraPlayer.connectIPC2(CommonUtils.getCameraString(mInfo), this);
        }
    }

    private void initView() {
        TextView uuid = findViewById(R.id.uuid_text);
        uuid.setText(mInfo.getSnNum());
        getTopTitleView();
        this.mCenter.setText(getString(R.string.settings_title));
//        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        int pad = DisplayUtil.dip2px(this, 13);
//        this.mRightBtn.setPadding(pad, pad, pad, pad);
//        this.mRightBtn.setVisibility(View.VISIBLE);
        this.mRightText.setText(getString(R.string.delete_camera));
        this.action_bar_rl.setVisibility(View.VISIBLE);
        TextView account = findViewById(R.id.useraccount_text);
        account.setText(mInfo.getUserAccount());
        findById();
        initArmList();
        startAnimation();
    }

    private void initData() {
        Intent intent = getIntent();
        mInfo = (CameraInfo) intent.getSerializableExtra("cameraInfo");
        //判断设备是否支持iot设置
        if (mInfo.getProtocolVersion() >= 4) {
            isIothub = true;
        }
        this.mMotionList = getResources().getStringArray(R.array.miror_action);
        this.mMotionListValue = getResources().getIntArray(R.array.miror_action_value);
    }

    private void initArmList() {
        mDevAlarmList = new ArrayList<>();
        for (int i = 0; i < mMotionListValue.length; i++) {
            ArmingInfo info = new ArmingInfo();
            PpsdevAlarmCfg cfg = new PpsdevAlarmCfg();
            cfg.sensitivity = mMotionListValue[i];
            cfg.enable = 1;
            cfg.alarmtype = 1;
            info.cfg = cfg;

            info.desc = mMotionList[i];
            mDevAlarmList.add(info);
        }
        mDecibelAlarmList = new ArrayList<>();
        int[] mDecibelMotionListValue = getResources().getIntArray(R.array.decibel_action_value);
        for (int i = 0; i < mDecibelMotionListValue.length; i++) {
            ArmingInfo info = new ArmingInfo();
            PpsdevAlarmCfg cfg = new PpsdevAlarmCfg();
            cfg.sensitivity = mDecibelMotionListValue[i];
            cfg.enable = 1;
            cfg.alarmtype = 1;
            info.cfg = cfg;
            info.desc = mMotionList[i];
            mDecibelAlarmList.add(info);
        }
    }


    private void startAnimation() {

        ImageView mirror_loading = findViewById(R.id.mirror_loading);
        this.mirrorAnimationDrawable = (AnimationDrawable) mirror_loading.getDrawable();
        mirror_loading.setVisibility(View.VISIBLE);
        mirrorAnimationDrawable.start();

        ImageView alarm_loading = findViewById(R.id.alarm_loading);
        this.alarmAnimationDrawable = (AnimationDrawable) alarm_loading.getDrawable();
        alarm_loading.setVisibility(View.VISIBLE);
        alarmAnimationDrawable.start();

        ImageView version_loading = findViewById(R.id.version_loading);
        this.versionAnimationDrawable = (AnimationDrawable) version_loading.getDrawable();
        version_loading.setVisibility(View.VISIBLE);
        versionAnimationDrawable.start();


    }

    private AnimationDrawable mirrorAnimationDrawable;
    private AnimationDrawable alarmAnimationDrawable;
    private AnimationDrawable versionAnimationDrawable;

    /**
     * @param message
     */
    private void stopAnimation(int message) {
        switch (message) {
            case MESSAGE_ALARM:

                findViewById(R.id.alarm_loading).setVisibility(View.GONE);
                if (alarmAnimationDrawable != null)
                    alarmAnimationDrawable.stop();
                break;
            case MESSAGE_VERSION:
                findViewById(R.id.version_loading).setVisibility(View.GONE);
                if (versionAnimationDrawable != null)
                    versionAnimationDrawable.stop();
                break;
            case MESSAGE_MIRROR:
                findViewById(R.id.mirror_loading).setVisibility(View.GONE);
                if (mirrorAnimationDrawable != null)
                    mirrorAnimationDrawable.stop();
                break;

        }
    }

    private void findById() {
        mSwitchBtn = findViewById(R.id.mirror_switchchk);
        mSwitchBtn.setEnabled(false);
        mSwitchBtn.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                //判断是否支持iot，然后调用不用方法设置
                if (isIothub) {
                    setRotateEnableIot(isChecked ? 1 : 0);
                } else {
                    if (isChecked) {
                        if (mSwitchBtn.isEnabled())
                            setMirror(3);
                    } else {
                        if (mSwitchBtn.isEnabled())
                            setMirror(0);
                    }
                }

            }
        });
        mDisturbSwitchBtn.setChecked(mInfo.getClosePush() == 0);
        mDisturbSwitchBtn.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    if (mDisturbSwitchBtn.isEnabled()) {
                        postClosePush(0);
                    }

                } else {
                    if (mDisturbSwitchBtn.isEnabled()) {
                        postClosePush(1);
                    }
                }
            }
        });
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
        if (mInfo.getNvrID() > 0) {
            findViewById(R.id.layout_nvr).setVisibility(View.VISIBLE);
        } else {
            findViewById(R.id.layout_nvr).setVisibility(View.GONE);
        }
        if (mInfo.isUpdateVersion()) {
            findViewById(R.id.update_hot).setVisibility(View.VISIBLE);
        }
        if (!this.mInfo.isAsFriend()) {
            this.mAliasEdit.setEnabled(false);
            for (int id : mArrowIds) {
                findViewById(id).setVisibility(View.GONE);
            }
            findViewById(R.id.mirrorContent).setEnabled(false);
            findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
            findViewById(R.id.mirror_right_layout).setEnabled(false);
            findViewById(R.id.mirror_right_layout).setEnabled(false);
            findViewById(R.id.layout_nvr).setEnabled(false);
            findViewById(R.id.home_device_layout).setEnabled(false);
            findViewById(R.id.home_arrow).setVisibility(View.GONE);
        }
    }

    private void setMirror(final int mirror) {
        BaseJSONObject json = new BaseJSONObject();
        json.put("mirror", String.valueOf(mirror));
        CommonUtils.getSdkUtil().setdeviceparams(CameraPlayer.SET_PPS_DEVICE_MIRROR,
                json.toString(), new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        if (successMsg == null || mEventHandler == null) {
                            return;
                        }
                        Message msg = new Message();
                        msg.what = MESSAGE_SETTING_MIRROR_SUCCESS;
                        msg.obj = mirror;
                        mEventHandler.sendMessage(msg);

                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        if (errorMsg == null || mEventHandler == null) {
                            return;
                        }
                        mEventHandler.sendEmptyMessage(MESSAGE_SETTING_MIRROR_FAILED);
                    }
                });
    }

    private void setRotateEnableIot(int status) {
        MeariUser.getInstance().setRotateEnable(mInfo.getSnNum(), status, this, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                showToast("设置成功");
            }

            @Override
            public void onError(int code, String error) {
                showToast("设置成功");
            }
        });
    }

    @OnClick(R.id.update_device_layout)
    public void onUpdateClick() {
        if (!mIsReady)
            return;
        if (this.mInfo.isAsFriend()) {
            CommonUtils.showToast(R.string.cant_noset);
            return;
        }
        Intent intent = new Intent(CameraSettingActivity.this, UpdateDeviceActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString("version", mVersion);
        bundle.putSerializable("cameraInfo", mInfo);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_UPDATEDEVICE);
    }

    @OnClick(R.id.alarmContent)
    public void onArmingSwiftClick() {
        if (!mIsReady)
            return;
        if (this.mInfo.isAsFriend()) {
            CommonUtils.showToast(R.string.pps_cant_noset);
            return;
        }
        Intent intent = new Intent(CameraSettingActivity.this, MotionActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("motion", mAlarm);
        bundle.putSerializable("cameraInfo", mInfo);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_MOTION);
    }

    @OnClick(R.id.layout_iot)
    public void onIotSettingClick() {
        if (this.mInfo.isAsFriend()) {
            CommonUtils.showToast(R.string.pps_cant_noset);
            return;
        }
        Intent intent = new Intent(CameraSettingActivity.this, CameraSettingIotActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", mInfo);
        intent.putExtras(bundle);
        startActivityForResult(intent, 100);
    }

    @OnClick(R.id.sd_layout)
    public void onSdCardSwiftClick() {
        if (!mIsReady)
            return;
        if (this.mInfo.isAsFriend()) {
            CommonUtils.showToast(R.string.pps_cant_noset);
            return;
        }
        Intent intent = new Intent(CameraSettingActivity.this, FormatSDActivity.class);
        startActivityForResult(intent, ActivityType.ACTIVITY_FORMATSD);
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

    @OnClick(R.id.layout_nvr)
    public void onNvrClick() {
        Intent intent = new Intent();
        intent.setClass(this, NvrRemoveCameraActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", mInfo);
        bundle.putInt("nvrID", mInfo.getNvrID());
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_REMOVE_CAMERA);
    }

    @OnClick(R.id.home_device_layout)
    public void onHomeClick() {
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
        Intent intent = new Intent();
        intent.setClass(this, SleepModeMethodActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", mInfo);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_SLEEPMODE);

    }

    @OnClick(R.id.share_layout)
    public void onShareClick() {
        Intent intent = new Intent();
        intent.setClass(this, ShareDeviceActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", mInfo);
        intent.putExtras(bundle);
        startActivity(intent);
    }


    @OnClick(R.id.right_text)
    public void showDialog() {
        CommonUtils.showDlg(this, getString(R.string.app_meari_name), getString(R.string.sure_delete),
                getString(R.string.ok), positiveClick,
                getString(R.string.cancel), negativeClick, true);
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

    @OnClick(R.id.setting_alias_ok)
    public void postEditName() {
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
        MeariUser.getInstance().renameDeviceNickname(this.mInfo.getDeviceID(), DeviceType.IPC, deviceName, this, new IResultCallback() {
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
    }

    private void postDeleteDevice() {
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        startProgressDialog();
        MeariUser.getInstance().removeDevice(mInfo.getDeviceID(), DeviceType.IPC, this, new IResultCallback() {
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


    public void setStatus() {
        setMirrorSwiftImgStatus(-1);
        setArmingSwiftImgStatus(null);
        setDeviceVersion();
    }

    @Override
    public void PPSuccessHandler(String successMsg) {
        if (successMsg == null || mEventHandler == null)
            return;
        mEventHandler.sendEmptyMessage(MESSAGE_LOGIN_SUCCESS);

    }


    @Override
    public void PPFailureError(String errorMsg) {
        if (mEventHandler == null)
            return;
        try {
            BaseJSONObject jsonObject = new BaseJSONObject(errorMsg);
            int errorCode = jsonObject.optInt("code", 0);
            Message msg = new Message();
            msg.what = MESSAGE_LOGIN_FAILED;
            msg.obj = errorCode;
            mEventHandler.sendMessage(msg);

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    private Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_LOGIN_SUCCESS:
                    getCameraStatus();
                    mIsReady = true;
                    break;
                case MESSAGE_MIRROR:
                    int mMirror = (int) msg.obj;
                    setMirrorSwiftImgStatus(mMirror);
                    break;
                case MESSAGE_ALARM:
                    setArmingSwiftImgStatus(mAlarm.cfg);
                case MESSAGE_VERSION:
                    setDeviceVersion();
                    break;
                case MESSAGE_LOGIN_FAILED:
                    setStatus();
                    int errorCode = (int) msg.obj;
                    if (errorCode == CameraPlayer.PPSPLAYER_DEVICE_OFFLINE) {
                        CommonUtils.showToast(R.string.offline_warning);
                    } else if (errorCode == CameraPlayer.PPSPLAYER_REQUEST_FAILED) {
                        CommonUtils.showToast(R.string.connect_camera_failed);
                    } else if (errorCode == CameraPlayer.PPSPLAYER_ERROR_PASSWORD) {
                        CommonUtils.showToast(R.string.device_abnormal);
                    } else {
                        CommonUtils.showToast(R.string.connect_camera_failed);
                    }
                    break;
                case MESSAGE_SETTING_MIRROR_SUCCESS:
                    stopProgressDialog();
                    mMirror = (int) msg.obj;
                    setMirrorSwiftImgStatus(mMirror);
                    break;
                case MESSAGE_SETTING_MIRROR_FAILED:
                    CommonUtils.showToast(R.string.setting_failded);
                    break;
                default:
                    break;
            }
        }
    };

    private void setDeviceVersion() {
        stopAnimation(MESSAGE_VERSION);
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

    private void getCameraStatus() {
        CommonUtils.getSdkUtil().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_MIRROR, new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isFinishing() || isDestroyed() || mEventHandler == null || successMsg == null)
                    return;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                    int mirror = jsonObject.optInt("mirror", -1);
                    Message msg = new Message();
                    msg.what = MESSAGE_MIRROR;
                    msg.obj = mirror;
                    mEventHandler.sendMessage(msg);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }

            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPFailureError(String errorMsg) {
            }
        });
        CommonUtils.getSdkUtil().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_ALARM, new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isFinishing() || isDestroyed() || mEventHandler == null || successMsg == null)
                    return;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                    mAlarm.cfg.enable = jsonObject.optInt("enable", -1);
                    mAlarm.cfg.alarmtype = jsonObject.optInt("alarmtype", -1);
                    mAlarm.cfg.sensitivity = jsonObject.optInt("sensitivity", -1);
                    mEventHandler.sendEmptyMessage(MESSAGE_ALARM);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPFailureError(String errorMsg) {
                if (isFinishing() || isDestroyed() || mEventHandler == null || errorMsg == null)
                    return;
                Message msg = new Message();
                msg.what = MESSAGE_MIRROR;
                msg.obj = -1;
                mEventHandler.sendMessage(msg);
            }
        });
        CommonUtils.getSdkUtil().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_INFO, new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isFinishing() || isDestroyed() || mEventHandler == null || successMsg == null)
                    return;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                    mVersion = jsonObject.optString("firmwareversion", "");
                    mEventHandler.sendEmptyMessage(MESSAGE_VERSION);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_VERSION);
            }
        });
    }

    private void setArmingSwiftImgStatus(PpsdevAlarmCfg alarm) {
        stopAnimation(MESSAGE_ALARM);
        TextView textView = findViewById(R.id.arm_text);
        if (alarm == null) {
            textView.setText(getString(R.string.fail));
            return;
        }
        for (int i = 0; i < mDevAlarmList.size(); i++) {
            ArmingInfo cfg = mDevAlarmList.get(i);
            if (alarm.enable == 0) {
                textView.setText(getString(R.string.alarm_close));
                return;
            } else if (cfg.cfg.sensitivity == alarm.sensitivity && cfg.cfg.enable == alarm.enable) {
                textView.setText(cfg.desc);
                return;
            }
        }
        textView.setText(getString(R.string.fail));
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case ActivityType.ACTIVITY_MOTION:
                if (resultCode == RESULT_OK) {
                    mAlarm = (ArmingInfo) data.getSerializableExtra("motion");
                    setArmingSwiftImgStatus(mAlarm.cfg);
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

    public void setMirrorSwiftImgStatus(int status) {
        stopAnimation(MESSAGE_MIRROR);
        TextView textView = findViewById(R.id.mirror_text);
        if (status < 0) {
            textView.setText(getString(R.string.fail));
            mSwitchBtn.setVisibility(View.GONE);
        } else {
            mSwitchBtn.setVisibility(View.VISIBLE);
            if (bInitSwitch)
                return;
            if (status != 3) {
                mSwitchBtn.setChecked(false);
            } else
                mSwitchBtn.setChecked(true);
        }
        bInitSwitch = true;
        if (!this.mInfo.isAsFriend())
            mSwitchBtn.setEnabled(true);
    }

    @Override
    public void finish() {
        super.finish();
        mEventHandler = null;
        if (CommonUtils.getSdkUtil() == null || CommonUtils.getSdkUtil().getCameraInfo() == null) {
            return;
        }
    }


    private void postClosePush(int status) {
        startProgressDialog();
        MeariUser.getInstance().closeDeviceAlarmPush(mInfo.getDeviceID(), status, this, new IPushStatusCallback() {
            @Override
            public void onSuccess(int status) {
                stopProgressDialog();
                mDisturbSwitchBtn.setEnabled(false);
                mDisturbSwitchBtn.setChecked(status == 0);
                mDisturbSwitchBtn.setEnabled(true);
                mInfo.setClosePush(status);
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                showToast(error);
            }
        });
    }


}
