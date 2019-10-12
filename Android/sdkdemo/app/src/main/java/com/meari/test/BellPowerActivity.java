package com.meari.test;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.widget.SwitchButton;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import java.text.DecimalFormat;

import butterknife.BindView;

/**
 * 门铃功耗管理页面
 */
public class BellPowerActivity extends BaseActivity {

    private static final String TAG = "BellPowerActivity";
    @BindView(R.id.switch_lowPowerMode)
    SwitchButton switch_lowPowerMode;
    @BindView(R.id.tv_powerFrom)
    TextView tv_powerFrom;
    @BindView(R.id.tv_powerOverpluse)
    TextView tv_powerOverpluse;
    @BindView(R.id.tv_dayOverplus)
    TextView tv_dayOverplus;

    Dialog confirmDialog;//低功耗模式确定对话框

    //通用cameraplayer
    CameraPlayer cameraPlayer;
    //门铃设备信息
    CameraInfo cameraInfo;

    //消息统一处理
    final static int MSG_SHOW_DLG = 0x1001;//显示低功耗模式确定对话框
    final static int MSG_CLOSE_DLG = 0x1002;//关闭对话框
    final static int MSG_CHANGE_SWITCH = 0x1003;//改变switch状态
    final static int MSG_GET_POWER_SUCCESS = 0x1004;//获取设备功耗相关信息成功
    final static int MSG_SET_PWM = 0x1005;//设置设备低功耗
    final static int MSG_SET_PWM_SUCCESS = 0x1006;//设置设备低功耗成功
    final static int MSG_CONNECT_IPC_SUCCESS = 0x1007;//连接设备成功
    final static int MSG_GET_POWER_FAILED = 0x1008;//获取功耗信息失败
    final static int MSG_SET_PWM_FAILED = 0x1009;//设置低功耗模式失败
    @SuppressLint("HandlerLeak")
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MSG_GET_POWER_FAILED:
                    CommonUtils.showToast(R.string.connectFail);
                    break;
                case MSG_SHOW_DLG:
                    boolean flag = msg.getData().getBoolean("flag");
                    //确认对话框消息文字
                    String dlgMsg = flag ? getString(R.string.confirm_close_low_power) : getString(R.string.confirm_open_low_power);
                    confirmDialog = CommonUtils.showDlg(BellPowerActivity.this,
                            getString(R.string.bell_lowpower_mode), dlgMsg,
                            getString(R.string.ok), positiveListener, getString(R.string.cancel), negativeListener,
                            true);
                    break;
                case MSG_CLOSE_DLG:
                    confirmDialog.dismiss();
                    break;
                case MSG_CHANGE_SWITCH:
                    boolean checked = switch_lowPowerMode.isChecked();
                    switch_lowPowerMode.setChecked(!checked);
                    break;
                case MSG_SET_PWM:
                    //开启加载对话框
                    startProgressDialog();
                    break;
                case MSG_SET_PWM_SUCCESS:
                    //关闭对话框
                    stopProgressDialog();
                    //提示设置成功
                    CommonUtils.showToast(R.string.setting_successfully);
                    //关闭页面
                    finish();
                    break;
                case MSG_SET_PWM_FAILED:
                    //关闭对话框
                    stopProgressDialog();
                    //提示设置成功
                    CommonUtils.showToast(R.string.setting_failded);
                    //关闭页面
                    finish();
                    break;
                case MSG_GET_POWER_SUCCESS:
                    //关闭加载对话框
                    stopProgressDialog();
                    //设置功耗信息内容
                    int percent = msg.getData().getInt("percent");
                    //这里是分钟
                    float remain = msg.getData().getFloat("remain");
                    float remainDay = remain / 24f;
                    String tmp = getString(R.string.bell_expect_day);
                    if (remainDay != 0) {
                        DecimalFormat decimalFormat = new DecimalFormat(".0");
                        String strDay = decimalFormat.format(remainDay);
                        tv_dayOverplus.setText(String.format(tmp, strDay));
                        tv_powerOverpluse.setText(percent + "％");
                    } else {
                        tv_dayOverplus.setText(String.format(tmp, "0"));
                    }
                    String powerFrom = msg.getData().getString("power");
                    int pwm = msg.getData().getInt("pwm");
                    if (powerFrom.equals("battery")) {
                        tv_powerFrom.setText(R.string.battery_power);
                    } else if (powerFrom.equals("wire") || powerFrom.equals("both")) {
                        tv_powerFrom.setText(R.string.wire_power);
                    }
                    if (pwm == 0) {
                        //低功耗关闭
                        switch_lowPowerMode.setChecked(false);
                    } else {
                        //低功耗模式开启
                        switch_lowPowerMode.setChecked(true);
                    }

                    break;
                case MSG_CONNECT_IPC_SUCCESS:
                    //去获取电源管理相关信息
                    getBellPowerSetting();
                    break;
            }
        }
    };

    /**
     * 对话框确定点击事件
     */
    DialogInterface.OnClickListener positiveListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            //判断当前状态
            boolean flag = switch_lowPowerMode.isChecked();
            sendBellPwm(!flag);
            //改变switch
            handler.sendEmptyMessage(MSG_CHANGE_SWITCH);
            //关闭对话框
            handler.sendEmptyMessage(MSG_CLOSE_DLG);
        }
    };

    /**
     * 发送低功耗设置请求
     *
     * @param flag true：开；false：关
     */
    private void sendBellPwm(boolean flag) {
        startProgressDialog();
        cameraPlayer.setBellPowerManagement(flag == true ? 1 : 0, new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                //设置成功
                handler.sendEmptyMessage(MSG_SET_PWM_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                //提示设置失败
                handler.sendEmptyMessage(MSG_SET_PWM_FAILED);
            }
        });


    }

    /**
     * 对话框取消点击事件
     */
    DialogInterface.OnClickListener negativeListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            //关闭对话框
            handler.sendEmptyMessage(MSG_CLOSE_DLG);
        }
    };


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bell_power);

        //默认开启加载对话框
        startProgressDialog();

        initData();

        //初始化topbar
        initTopBar();

        initView();

    }

    private void initData() {
        //获取设备信息
        cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        //获取通用cameraplayer
        cameraPlayer = CommonUtils.getSdkUtil();
        if (cameraPlayer.IsLogined()) {
            //获取电源信息
            getBellPowerSetting();
        } else {
            //重新打洞连接设备
            connectIPC();
        }
    }

    /**
     * 当通用cameraplayer未连接设备时，重新打洞连接设备
     */
    private void connectIPC() {
        cameraPlayer.connectIPC2(CommonUtils.getCameraString(cameraInfo),
                new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        //连接成功
                        handler.sendEmptyMessage(MSG_CONNECT_IPC_SUCCESS);
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        //提示失败

                    }
                });
    }

    /**
     * 获取门铃电源管理相关设置
     */
    private void getBellPowerSetting() {
        cameraPlayer.getDeviceSettingParams(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                try {
                    BaseJSONObject json = new BaseJSONObject(successMsg);
                    BaseJSONObject bellJson = json.optBaseJSONObject("bell");
                    BaseJSONObject batteryJson = bellJson.optBaseJSONObject("battery");
                    //剩余电量百分比
                    int percent = batteryJson.optInt("percent");
                    //剩余使用时间
                    float remain = (float) batteryJson.optDouble("remain");
                    //充电状态
                    String batteryStatus = batteryJson.optString("status");
                    //电源输入
                    String powerFrom = bellJson.optString("power");
                    //低功耗
                    int pwm = bellJson.optInt("pwm");
                    Bundle batteryBundle = new Bundle();
                    batteryBundle.putInt("percent", percent);
                    batteryBundle.putFloat("remain", remain);
                    batteryBundle.putString("status", batteryStatus);
                    batteryBundle.putString("power", powerFrom);
                    batteryBundle.putInt("pwm", pwm);
                    Message msg = new Message();
                    msg.setData(batteryBundle);
                    msg.what = MSG_GET_POWER_SUCCESS;
                    handler.sendMessage(msg);

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void PPFailureError(String errorMsg) {
                //提示失败
                handler.sendEmptyMessage(MSG_GET_POWER_FAILED);
            }
        });
    }

    private void initView() {
        //屏蔽调本身的ontouch事件
        switch_lowPowerMode.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        break;
                    case MotionEvent.ACTION_MOVE:
                        break;
                    case MotionEvent.ACTION_UP:
                        //只要抬起就算点击事件
                        //弹出对话框
                        boolean flag = switch_lowPowerMode.isChecked();
                        Message msg = new Message();
                        Bundle bundle = new Bundle();
                        bundle.putBoolean("flag", flag);
                        msg.setData(bundle);
                        msg.what = MSG_SHOW_DLG;
                        handler.sendMessage(msg);
                        break;
                }
                return true;
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
        this.mCenter.setText(getString(R.string.bell_power_manager));
        this.mRightBtn.setVisibility(View.GONE);
    }
}
