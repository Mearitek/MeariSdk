package com.meari.test;

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
import android.util.Log;
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
import com.meari.sdk.common.DeviceType;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.EmojiFilter;
import com.meari.test.utils.Logger;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.SwitchButton;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;

/**
 * 门铃设置页面
 *
 * @author pupu
 * @time 2017年7月19日15:18:11
 */
public class BellSettingActivity extends BaseActivity {

    private static final String TAG = "BellSettingActivity";
    CameraInfo cameraInfo;

    @BindView(R.id.setting_aliasText)
    EditText mAliasEdit;//设备别名编辑
    @BindView(R.id.version_text)
    TextView version_text;//版本号
    @BindView(R.id.version_loading)
    ImageView version_loading;
    @BindView(R.id.disturb_switchchk)
    SwitchButton disturb_switchchk;//接收报警消息开关

    //设备对象
    CameraPlayer cameraPlayer;
    //设备版本号
    String mVersion;
    //是否有电池
    boolean hasBattery;

    //统一消息传递处理
    final static int MSG_GET_DEVICE_VERSION = 0x1001;//获取设备版本
    final static int MSG_GET_DEVICE_VERSION_FAILED = 0x1002;//获取设备版本失败
    final static int MESSAGE_PIR_INIT = 0x1003;//初始化获取pir设置
    final static int MESSAGE_CONNECT_IPC_SUCCESS = 0x1004;//打洞成功
    final static int MESSAGE_CONNECT_IPC_FAILED = 0x1005;//打洞失败
    final static int MESSAGE_PIR_UPDATE = 0x1006;//更新pir设置
    final static int MESSAGE_POWER_INIT = 0x1007;//初始获取门铃的供电方式
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_POWER_INIT:
                    hasBattery = (boolean) msg.obj;
                    break;
                case MESSAGE_PIR_UPDATE:
                    int pirUpdateLevel = (int) msg.obj;
                    if (pirUpdateLevel == 0) {
                        setPirView(false, 0);
                    } else {
                        setPirView(true, pirUpdateLevel);
                    }
                    break;
                case MESSAGE_CONNECT_IPC_SUCCESS:
                    //去拿设备信息
                    getBellDeviceInfo();
                    break;
                case MESSAGE_CONNECT_IPC_FAILED:
                    //提示获取失败

                    break;
                case MESSAGE_PIR_INIT:
                    boolean pirEnable = msg.getData().getBoolean("enable");
                    int pirLevel = msg.getData().getInt("level");
                    //保存相应的设置
//                    cameraInfo.setPirEnable(pirEnable);
//                    cameraInfo.setPirLevel(pirLevel);
                    setPirView(pirEnable, pirLevel);
                    break;
                case MSG_GET_DEVICE_VERSION:
                    stopAnimation(MSG_GET_DEVICE_VERSION);
                    if (mVersion != null) {
                        String[] versionList = mVersion.split("-");
                        if (versionList.length == 0) {
                            version_text.setText(getString(R.string.fail));
                        } else {
                            version_text.setText(versionList[versionList.length - 1]);
                        }
                    } else {
                        version_text.setText(getString(R.string.fail));
                    }
                    break;
                case MSG_GET_DEVICE_VERSION_FAILED:
                    break;
            }
        }
    };
    private ArmingInfo mMotion;

    /**
     * 设置pir View
     *
     * @param enable
     * @param level
     */
    private void setPirView(boolean enable, int level) {
        stopAnimation(MESSAGE_PIR_INIT);
        TextView tv_arm = findViewById(R.id.arm_text);
        tv_arm.setVisibility(View.VISIBLE);
        if (enable == false) {
            tv_arm.setText(R.string.off);
            mMotion.cfg.enable = 0;
            mMotion.cfg.sensitivity = level;
        } else {
            if (level == 1) {
                //low
                tv_arm.setText(R.string.low);
            } else if (level == 2) {
                //mid
                tv_arm.setText(R.string.medium);
            } else {
                //high
                tv_arm.setText(R.string.high);
            }
            mMotion.cfg.enable = 1;
            mMotion.cfg.sensitivity = level;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bell_setting);


        //初始化相关数据
        initData();
        //初始化topbar
        initTopBar();
        //初始化内容view
        initView();
    }

    /**
     * 开启菊花加载动画
     */
    private void startAnimation() {


        ImageView alarm_loading = findViewById(R.id.alarm_loading);
        alarm_loading.setVisibility(View.VISIBLE);
        alarmAnimationDrawable = (AnimationDrawable) alarm_loading.getDrawable();
        alarmAnimationDrawable.start();

        ImageView version_loading = findViewById(R.id.version_loading);
        version_loading.setVisibility(View.VISIBLE);
        versionAnimationDrawable = (AnimationDrawable) alarm_loading.getDrawable();
        versionAnimationDrawable.start();
    }


    private AnimationDrawable alarmAnimationDrawable;
    private AnimationDrawable versionAnimationDrawable;

    /**
     * 停止菊花加载动画
     *
     * @param message 统一消息标识
     */
    private void stopAnimation(int message) {
        switch (message) {
            case MESSAGE_PIR_INIT:
                findViewById(R.id.alarm_loading).setVisibility(View.GONE);
                if (alarmAnimationDrawable != null)
                    alarmAnimationDrawable.stop();
                break;
            case MSG_GET_DEVICE_VERSION:
                findViewById(R.id.version_loading).setVisibility(View.GONE);
                if (versionAnimationDrawable != null)
                    versionAnimationDrawable.stop();
                break;
        }
    }

    /**
     * 初始化内容view
     */
    private void initView() {
        TextView account = findViewById(R.id.useraccount_text);
        account.setText(cameraInfo.getUserAccount());
        TextView uuid = findViewById(R.id.uuid_text);
        uuid.setText(cameraInfo.getSnNum());
        mAliasEdit.setText(cameraInfo.getDeviceName());
        mAliasEdit.requestFocus();
        if (this.cameraInfo.getUserID() == MeariUser.getInstance().getUserInfo().getUserID()) {
            mAliasEdit.addTextChangedListener(new TextWatcher() {
                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    if (s.length() > 0) {
                        if (s.equals(cameraInfo.getDeviceName())) {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
                        } else {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.VISIBLE);
                        }

                    } else {
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
                        if (mAliasEdit.getText().toString().trim().equals(cameraInfo.getDeviceName())) {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
                        } else {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.VISIBLE);
                        }
                    } else {
                    }
                }
            });
        }

        //如果设备需要升级,显示红点
        if (cameraInfo.isUpdateVersion() == true) {
            findViewById(R.id.update_hot).setVisibility(View.VISIBLE);
        }

        //如果设备不是该用户的，则隐藏
        if (cameraInfo.isAsFriend() == true) {
            //隐藏分享
            findViewById(R.id.share_layout).setVisibility(View.GONE);
            //隐藏主人留言
            findViewById(R.id.layout_voiceReminder).setVisibility(View.GONE);
            //隐藏对讲音量
            findViewById(R.id.layout_bellVolume).setVisibility(View.GONE);
            //隐藏功耗管理
            findViewById(R.id.layout_power).setVisibility(View.GONE);
            //隐藏铃铛设置
            findViewById(R.id.layout_charm).setVisibility(View.GONE);
            //隐藏电池锁
            findViewById(R.id.layout_batteryLock).setVisibility(View.GONE);
            //编辑框不可编辑
            mAliasEdit.setEnabled(false);
            //隐藏箭头
            findViewById(R.id.id_arrow).setVisibility(View.GONE);
            findViewById(R.id.alarmArrow).setVisibility(View.GONE);
            findViewById(R.id.version_arrow).setVisibility(View.GONE);
        }

        //开启菊花加载动画
        startAnimation();

        //初始化pir框
        disturb_switchchk.setEnabled(false);
        disturb_switchchk.setChecked(cameraInfo.getClosePush() == 0 ? true : false);
        disturb_switchchk.setEnabled(true);
    }

    /**
     * 初始化相关数据
     */
    private void initData() {
        cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        //获取上一个页面已经打洞成功的cameraplayer
        cameraPlayer = CommonUtils.getSdkUtil();
        //判断cameraPlayer是否已连接设备
        if (cameraPlayer != null && cameraPlayer.IsLogined()) {
            //已经连接设备，直接拿设备信息
            getBellDeviceInfo();
        } else {
            //新建cameraplayer去重新connect
            cameraPlayer.connectIPC2(CommonUtils.getCameraString(cameraInfo),  new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    Log.i(TAG, "connectIPC success==>" + successMsg);
                    handler.sendEmptyMessage(MESSAGE_CONNECT_IPC_SUCCESS);
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    Log.e(TAG, "connectIPC failed==>" + errorMsg);
                    handler.sendEmptyMessage(MESSAGE_CONNECT_IPC_FAILED);
                }
            });
        }
    }

    /**
     * 打洞获取门铃设备相关信息
     */
    private void getBellDeviceInfo() {
        //打洞拿设备信息
        cameraPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_INFO, new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isFinishing() || isDestroyed() || handler == null || successMsg == null)
                    return;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                    mVersion = jsonObject.optString("firmwareversion", "");
                    Logger.i(TAG, "从设备获取的版本号：" + mVersion);
                    //获取成功
                    handler.sendEmptyMessage(MSG_GET_DEVICE_VERSION);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (handler == null)
                    return;
                //获取版本失败
                handler.sendEmptyMessage(MSG_GET_DEVICE_VERSION_FAILED);
            }
        });
        cameraPlayer.getDeviceSettingParams(new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                try {
                    BaseJSONObject successMsgJson = new BaseJSONObject(successMsg);
                    //这里只拿门铃的json
                    BaseJSONObject bellJson = successMsgJson.optBaseJSONObject("bell");
                    //获取移动侦测
                    BaseJSONObject pirJson = bellJson.optBaseJSONObject("pir");
                    //获取pir开关
                    boolean pirEnable = pirJson.getInt("enable") == 1 ? true : false;
                    int pirLevel = 0;
                    if (pirEnable == true) {
                        //获取pir等级
                        pirLevel = pirJson.getInt("level");
                    }
                    //初始化pir View
                    Message pirMsg = new Message();
                    Bundle pirBundle = new Bundle();
                    pirBundle.putBoolean("enable", pirEnable);
                    pirBundle.putInt("level", pirLevel);
                    pirMsg.setData(pirBundle);
                    pirMsg.what = MESSAGE_PIR_INIT;
                    handler.sendMessage(pirMsg);

                    //获取门铃对讲音量
                    int bellVol = bellJson.getInt("volume");
                    //获取门铃的供电方式
                    String bellPower = bellJson.getString("power");
                    boolean isBattery = bellPower.equals("battery") ? true : false;
                    Message powerMsg = new Message();
                    powerMsg.obj = isBattery;
                    powerMsg.what = MESSAGE_POWER_INIT;
                    handler.sendMessage(powerMsg);

                    //获取门铃电池状态
                    BaseJSONObject batteryJson = bellJson.optBaseJSONObject("battery");
                    //百分比
                    int batteryPercent = batteryJson.getInt("percent");
                    //剩余电量
                    float batteryRemain = (float) batteryJson.getDouble("remain");
                    //电池状态
                    String bellStatus = batteryJson.getString("status");
                    //是否低功耗
                    boolean bellPwm = bellJson.getInt("pwm") == 1 ? true : false;
                    //铃铛设置信息
                    BaseJSONObject charmJson = bellJson.optBaseJSONObject("charm");
                    //铃铛音量

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPFailureError(String errorMsg) {
                //提示获取失败
                CommonUtils.showToast(errorMsg);
            }
        });
    }



    /**
     * 初始化topbar
     */
    private void initTopBar() {
        getTopTitleView();
        //后期记得修改，appcompat包冲突的bug（猜想）
        if (this.mCenter == null) {
            return;
        }
        this.mCenter.setText(getString(R.string.settings_title));
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        int pad = DisplayUtil.dip2px(this, 13);
        this.mRightBtn.setPadding(pad, pad, pad, pad);
        this.mRightBtn.setVisibility(View.VISIBLE);
        mMotion = new ArmingInfo();
    }

    /**
     * 删除该设备
     */
    private void postDelteDevice() {
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        startProgressDialog(getString(R.string.pps_waite));
        MeariUser.getInstance().deleteDevice(cameraInfo.getDeviceID(), DeviceType.DOORBELL, new IResultCallback() {
            @Override
            public void onSuccess() {
                stopProgressDialog();
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putInt("type", 1);
                bundle.putSerializable(StringConstants.CAMERA_INFO, cameraInfo);
                intent.putExtras(bundle);
                setResult(RESULT_OK, intent);
                //删除该设备
                Preference.getPreference().removeDeviceBySn(cameraInfo.getSnNum());
                finish();
                //跳转到首页
                start2Activity(MainActivity.class);
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                showToast(error);
            }
        });

    }

    private DialogInterface.OnClickListener positiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            postDelteDevice();
        }
    };

    private DialogInterface.OnClickListener negeclick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };

    /**
     * 重写返回按键事件，把cameraInfo传递出去
     *
     * @param keyCode
     * @param event
     * @return
     */
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            Intent it = new Intent();
            Bundle bundleBack = new Bundle();
            bundleBack.putSerializable("cameraInfo", cameraInfo);
            it.putExtras(bundleBack);
            setResult(RESULT_OK, it);
            finish();
            return false;
        }
        return super.onKeyDown(keyCode, event);
    }

    @OnClick({R.id.share_layout, R.id.sd_layout,
            R.id.layout_pir, R.id.layout_voiceReminder, R.id.layout_bellVolume,
            R.id.layout_power, R.id.layout_charm, R.id.layout_batteryLock,
            R.id.setting_alias_ok, R.id.updata_device_layout, R.id.submitRegisterBtn,
            R.id.back_img
    })
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.back_img:
                //把cameraInfo传递过去
                Intent it = new Intent();
                Bundle bundleBack = new Bundle();
                bundleBack.putSerializable("cameraInfo", cameraInfo);
                it.putExtras(bundleBack);
                setResult(RESULT_OK, it);
                finish();
                break;
            case R.id.submitRegisterBtn:
                //删除按钮
                CommonUtils.showDlg(this, getString(R.string.app_meari_name), getString(R.string.sure_delete),
                        getString(R.string.ok), positiveClick,
                        getString(R.string.cancel), negeclick, true);
                break;
            case R.id.updata_device_layout:
                //如果设备不是该用户的
                if (cameraInfo.isAsFriend() == true) {
                    CommonUtils.showToast(R.string.cant_noset);
                    return;
                }
                //跳至升级页面
                Bundle bundle_update = new Bundle();
                bundle_update.putString("version", mVersion);
                bundle_update.putSerializable("cameraInfo", cameraInfo);
                start2ActivityForResult(UpdateDeviceActivity.class, bundle_update, ActivityType.ACTIVITY_UPDATEDEVICE);
                break;
            case R.id.setting_alias_ok:
                //跟改设备名称按钮
                if (cameraInfo.getUserID() != MeariUser.getInstance().getUserInfo().getUserID()) {
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
                MeariUser.getInstance().renameDevice(cameraInfo.getDeviceID(), DeviceType.DOORBELL, deviceName, new IResultCallback() {
                    @Override
                    public void onSuccess() {
                        stopProgressDialog();
                        showToast(getString(R.string.update_device_suc));
                        cameraInfo.setDeviceName(mAliasEdit.getText().toString());
                    }

                    @Override
                    public void onError(int code, String error) {
                        stopProgressDialog();
                        showToast(error);
                    }
                });
                break;
            case R.id.share_layout:
                //跳转至分享页面
                if (cameraInfo.isAsFriend() == true) {
                    CommonUtils.showToast(R.string.cant_noset);
                } else {
                    Bundle bundle_share = new Bundle();
                    bundle_share.putSerializable("cameraInfo", cameraInfo);
                    start2Activity(ShareDeviceActivity.class, bundle_share);
                }
                break;
            case R.id.sd_layout:
                //跳转至SD卡设置页面
                if (this.cameraInfo.getUserID() != MeariUser.getInstance().getUserInfo().getUserID()) {
                    CommonUtils.showToast(R.string.pps_cant_noset);
                    return;
                }
                Bundle bundle_sd = new Bundle();
                bundle_sd.putInt("deviceHandle", 0);//这个参数的作用有待研究
                start2ActivityForResult(FormatSDActivity.class, bundle_sd, ActivityType.ACTIVITY_FORMATSD);
                break;
            case R.id.layout_pir:
                //设备不是该用户的，不能设置
                if (cameraInfo.isAsFriend() == true) {
                    CommonUtils.showToast(R.string.cant_noset);
                    return;
                }
                //PIR设置页面
                Bundle bundle_pir = new Bundle();
                bundle_pir.putSerializable("cameraInfo", cameraInfo);
                bundle_pir.putSerializable(StringConstants.MOTION, mMotion);
                start2ActivityForResult(PIRActivity.class, bundle_pir, ActivityType.ACTIVITY_PIR);
                break;
            case R.id.layout_voiceReminder:
                //设备不是该用户的，不能设置
                if (cameraInfo.isAsFriend() == true) {
                    CommonUtils.showToast(R.string.cant_noset);
                    return;
                }
                //语音提醒页面
                Bundle bundle_word = new Bundle();
                bundle_word.putSerializable("cameraInfo", cameraInfo);
                start2ActivityForResult(WordActivity.class, bundle_word, ActivityType.ACTIVITY_WORD);
                break;
            case R.id.layout_bellVolume:
                //门铃音量设置界面
                Bundle bundle_bellVol = new Bundle();
                bundle_bellVol.putSerializable("cameraInfo", cameraInfo);
                start2ActivityForResult(BellVolumeActivity.class, bundle_bellVol, ActivityType.ACTIVITY_BELL_VOLUME);
                break;
            case R.id.layout_power:
                //低功耗管理页面
                Bundle bundle_power = new Bundle();
                bundle_power.putSerializable("cameraInfo", cameraInfo);
                start2ActivityForResult(BellPowerActivity.class, bundle_power, ActivityType.ACTIVITY_BELL_POWER);
                break;
            case R.id.layout_charm:
//                //铃铛设置页面
                Bundle bundle_charm = new Bundle();
                bundle_charm.putSerializable("cameraInfo", cameraInfo);
                start2ActivityForResult(CharmSettingActivity.class, bundle_charm, ActivityType.ACTIVITY_CHARM_SETTING);
                break;
            case R.id.layout_batteryLock:
                //电池锁页面
                if (hasBattery == true) {
                    Bundle bundle_lock = new Bundle();
                    bundle_lock.putSerializable("cameraInfo", cameraInfo);
                    start2ActivityForResult(BellLockActivity.class, bundle_lock, ActivityType.ACTIVITY_BELL_LOCK);
                } else {
                    CommonUtils.showToast(R.string.toast_noBattery);
                }
                break;

        }
    }

    @OnCheckedChanged({R.id.disturb_switchchk})
    public void onViewCheckedChanged(CompoundButton buttonView, boolean flag) {
        switch (buttonView.getId()) {
            case R.id.disturb_switchchk:
                if (!buttonView.isEnabled())
                    return;
                if (flag == true) {
                    //开启报警推送
                    postClosePush(0);
                } else {
                    //关闭报警消息推送
                    postClosePush(1);
                }
                break;
        }
    }


    /**
     * 开启或关闭报警消息推送
     *
     * @param status 0：开启；1：关闭
     */
    private void postClosePush(int status) {
        startProgressDialog();
        MeariUser.getInstance().closeDeviceAlarmPush(cameraInfo.getDeviceID(), status, new IPushStatusCallback() {
            @Override
            public void onSuccess(int status) {
                stopProgressDialog();
                disturb_switchchk.setChecked(status == 0 ? true : false);
                cameraInfo.setClosePush(status);
                stopProgressDialog();
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                showToast(error);
            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_PIR:
                if (resultCode == RESULT_OK) {
                    //接收指令
                    ArmingInfo motion = (ArmingInfo) data.getExtras().getSerializable(StringConstants.MOTION);
                    setPirView(motion.cfg.enable == 1, motion.cfg.sensitivity);
                }
                break;
            case ActivityType.ACTIVITY_WORD:
                if (resultCode == RESULT_OK) {
                    cameraInfo.setBellVoiceURL(data.getExtras().getString("wordURL"));
                }
                break;
        }
    }
}
