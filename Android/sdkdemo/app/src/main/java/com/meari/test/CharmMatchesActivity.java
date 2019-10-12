package com.meari.test;

import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.widget.RoundProgressBar;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by pupu on 17/11/6.
 */
public class CharmMatchesActivity extends BaseActivity {

    final static String TAG = "CharmMatchesActivity";

    @BindView(R.id.rpb_matches)
    RoundProgressBar rpb_matches;
    @BindView(R.id.tv_startMatches)
    TextView tv_startMatches;
    @BindView(R.id.tv_cancelMatches)
    TextView tv_cancelMatches;
    //倒计时
    CountDownTimer downTimer;
    boolean isMatched = false;//是否已配对标识

    CameraPlayer cameraPlayer;
    CameraInfo cameraInfo;//门铃信息
    boolean isSamePlayer = true;//是否是通用的CameraPlayer，如果不是，关闭页面时要关洞

    Dialog cancelDialog;//是否解除绑定对话框

    final static int MSG_TIME_OVER = 0x1001;//倒计时结束
    final static int MSG_TIME_TICK = 0x1002;//倒计时走秒
    final static int MSG_CONNECT_IPC_SUCCESS = 0x1003;//连接设备成功
    final static int MSG_CONNECT_IPC_FAILED = 0x1004;//连接设备失败
    final static int MSG_CMD_MATCHES_SUCCESS = 0x1005;//发送指令成功
    final static int MSG_CMD_MATCHES_FAILED = 0x1006;//发送指令失败
    final static int MSG_MATCHES_SUCCESS = 0x1007;//配对成功
    final static int MSG_REMOVE_MATCHES_SUCCESS = 0x1008;//解除配对成功
    final static int MSG_REMOVE_MATCHES_FAILED = 0x1009;//解除配对失败
    final static int MSG_REMOVE_MATCHES = 0x1010;//发送解除配对指令
    Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {

            switch (msg.what) {
                case MSG_REMOVE_MATCHES:
                    //开启加载框
                    startProgressDialog();
                    //发送解除配对指令
                    removeMatches();
                    break;
                case MSG_REMOVE_MATCHES_FAILED:
                    stopProgressDialog();
                    //提示失败
                    CommonUtils.showToast(R.string.connectFail);
                    break;
                case MSG_REMOVE_MATCHES_SUCCESS:
                    stopProgressDialog();
                    //提示解除配对成功
                    CommonUtils.showToast(R.string.setting_successfully);
                    //关闭页面
                    finish();
                    break;
                case MSG_MATCHES_SUCCESS:
                    //取消倒计时
                    if (downTimer != null) {
                        downTimer.cancel();
                    }
                    //按钮变为可用
                    rpb_matches.setProgress(0);
                    rpb_matches.setContent("0");
                    rpb_matches.setVisibility(View.GONE);
                    isMatched = true;
                    tv_startMatches.setEnabled(true);
                    tv_startMatches.setText(R.string.finish);
                    break;
                case MSG_CMD_MATCHES_SUCCESS:
                    stopProgressDialog();
                    //显示进度条
                    rpb_matches.setVisibility(View.VISIBLE);
                    if (downTimer != null) {
                        downTimer.cancel();
                    }
                    //开始倒计时，等30s
                    downTimer = new CountDownTimer(30 * 1000, 1000) {
                        @Override
                        public void onTick(long millisUntilFinished) {
                            int remainTime = (int) (millisUntilFinished / 1000);
                            Message msg = Message.obtain();
                            msg.what = MSG_TIME_TICK;
                            msg.obj = remainTime;
                            //改变进度条 & 轮询门铃标志位
                            handler.sendMessage(msg);
                        }

                        @Override
                        public void onFinish() {
                            //提示时间已到，提示点击完成
                            handler.sendEmptyMessage(MSG_TIME_OVER);
                        }
                    };
                    downTimer.start();
                    break;
                case MSG_CMD_MATCHES_FAILED:
                    stopProgressDialog();
                    //提示发送配对指令失败
                    CommonUtils.showToast(R.string.connectFail);
                    //提示重试
                    tv_startMatches.setEnabled(true);
                    tv_startMatches.setText(R.string.retry);
                    break;
                case MSG_CONNECT_IPC_FAILED:
                    stopProgressDialog();
                    //提示连接失败
                    CommonUtils.showToast(R.string.connectFail);
                    //关闭页面
                    finish();
                    break;
                case MSG_CONNECT_IPC_SUCCESS:
                    isSamePlayer = false;//说明不是通用的CameraPlayer
                    stopProgressDialog();
                    break;
                case MSG_TIME_TICK:
                    //改变文字，显示正在配对
                    tv_startMatches.setText(R.string.str_matching);
                    //隐藏 解除绑定 按钮
                    tv_cancelMatches.setVisibility(View.GONE);
                    //改变进度条
                    int remainTime = (int) msg.obj;
                    rpb_matches.setProgress(remainTime);
                    rpb_matches.setContent(remainTime + "");
                    //轮询门铃状态
                    getMatchesStatus();
                    break;
                case MSG_TIME_OVER:
                    //按钮变为可用
                    rpb_matches.setProgress(0);
                    rpb_matches.setContent("0");
                    rpb_matches.setVisibility(View.GONE);
                    isMatched = false;
                    tv_startMatches.setEnabled(true);
                    tv_startMatches.setText(R.string.retry);
                    break;
                default:
                    break;
            }
            return false;
        }
    }) ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_charm_matches);
        initData(savedInstanceState);
        initView();
    }

    /**
     * 初始化topbar
     */
    private void initTopBar() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.str_charmMatches));
        this.mRightBtn.setVisibility(View.GONE);
    }

    private void initData(Bundle savedInstanceState) {

        if (savedInstanceState != null) {
            cameraInfo = (CameraInfo) savedInstanceState.getSerializable("cameraInfo");
        } else {
            cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        }
        //获取设备信息


        //获取通用cameraplayer
        cameraPlayer = CommonUtils.getSdkUtil();
        //判断是否已经登录设备
        if (cameraPlayer.IsLogined()) {

        } else {
            //重新打洞连接设备，弹菊花加载框
            connectIPC();
        }
    }

    /**
     * 获取配对状态
     */
    private void getMatchesStatus() {
        BaseJSONObject json = new BaseJSONObject();
        json.put("action", "GET");
        json.put("deviceurl", "http://127.0.0.1/devices/charm/status");
        cameraPlayer.commondeviceparams2(json.toString(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                Log.i(TAG, "getMatchesStatus===>successMsg:" + successMsg);
                //解析字符串
                int status = 0;
                try {
                    BaseJSONObject json = new BaseJSONObject(successMsg);
                    status = json.optInt("status");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (status == 1) {
                    //配对成功
                    handler.sendEmptyMessage(MSG_MATCHES_SUCCESS);
                }
            }

            @Override
            public void PPFailureError(String errorMsg) {
                Log.i(TAG, "getMatchesStatus===>errorMsg:" + errorMsg);
            }
        });
    }

    /**
     * 发送配对门铃铃铛指令
     */
    private void matchesCharm() {
        BaseJSONObject json = new BaseJSONObject();
        json.put("action", "POST");
        json.put("deviceurl", "http://127.0.0.1/devices/charm/pair");
        cameraPlayer.commondeviceparams2(json.toString(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                Log.i(TAG, "matchesCharmCmd===>successMsg" + successMsg);
                //发送成功,开始倒计时
                handler.sendEmptyMessage(MSG_CMD_MATCHES_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                Log.i(TAG, "matchesCharmCmd===>errorMsg" + errorMsg);
                //发送失败
                handler.sendEmptyMessage(MSG_CMD_MATCHES_FAILED);
            }
        });
    }

    /**
     * 当通用cameraplayer未连接设备时，重新打洞连接设备
     */
    private void connectIPC() {
        startProgressDialog();
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
                        handler.sendEmptyMessage(MSG_CONNECT_IPC_FAILED);
                    }
                });
    }

    DialogInterface.OnClickListener positiveListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            if (cancelDialog != null) {
                cancelDialog.dismiss();
            }
            handler.sendEmptyMessageDelayed(MSG_REMOVE_MATCHES, 500);
        }
    };

    DialogInterface.OnClickListener negativeListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            //取消对话框
            if (cancelDialog != null) {
                cancelDialog.dismiss();
            }
        }
    };

    private void initView() {
        initTopBar();
        //进度条置30,初始状态为30s
        rpb_matches.setProgress(30);
        rpb_matches.setContent("30");
        rpb_matches.setMax(30);
    }

    @OnClick({R.id.tv_cancelMatches, R.id.tv_startMatches})
    public void onViewClicked(View v) {
        switch (v.getId()) {
            case R.id.tv_startMatches:
                if (isMatched == false) {
                    //按钮变为不可点击
                    tv_startMatches.setEnabled(false);
                    //开启加载框
                    startProgressDialog();
                    matchesCharm();
                } else {
                    //这里说明配对已经完成，点击后关闭本页面
                    finish();
                }

                break;
            case R.id.tv_cancelMatches:
                cancelDialog = CommonUtils.showDlg(this,
                        getString(R.string.app_meari_name), getString(R.string.str_confirmCancelMatches),
                        getString(R.string.ok), positiveListener,
                        getString(R.string.cancel), negativeListener, true);
                break;
        }
    }

    /**
     * 解除所有的铃铛配对
     */
    private void removeMatches() {
        BaseJSONObject json = new BaseJSONObject();
        json.put("action", "POST");
        json.put("deviceurl", "http://127.0.0.1/devices/charm/unpair");
        cameraPlayer.commondeviceparams2(json.toString(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                //发送成功
                handler.sendEmptyMessage(MSG_REMOVE_MATCHES_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                //发送失败
                handler.sendEmptyMessage(MSG_REMOVE_MATCHES_FAILED);
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //清空定时器
        if (downTimer != null) {
            downTimer.cancel();
        }
        //如果不是通用的cameraplayer，则需要关洞
        if (isSamePlayer == false && cameraPlayer != null) {
            cameraPlayer.disconnectIPC(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {

                }

                @Override
                public void PPFailureError(String errorMsg) {

                }
            });
        }
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", cameraInfo);
        super.onSaveInstanceState(bundle);
    }
}