package com.meari.test;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.SeekBar;
import android.widget.TextView;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.ppstrong.listener.BellVolumeListener;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import butterknife.BindView;

/**
 * 门铃对讲音量设置页面
 *
 * @author pupu
 * @time 2017年8月4日14:48:11
 */
public class BellVolumeActivity extends BaseActivity {


    private static final String TAG = "BellVolumeActivity";
    @BindView(R.id.sb_volume)
    SeekBar sb_volume;//音量进度条
    @BindView(R.id.tv_volume)
    TextView tv_volume;//音量大小

    //通用cameraplayer
    CameraPlayer cameraPlayer;
    //设备信息
    CameraInfo cameraInfo;
    //门铃对讲音量
    int bellVol;

    //消息传递处理
    final static int MSG_UPDATE_TV_VOL = 0x1001;//更新音量
    final static int MSG_INIT_VOL = 0x1002;//获取门铃对讲音量成功
    final static int MSG_SEND_VOL_CMD = 0x1003;//设置门铃对讲音量请求
    final static int MSG_SEND_VOL_CMD_SUCCESS = 0x1004;//设置门铃对讲音量请求成功
    final static int MSG_CONNECT_IPC_SUCCESS = 0x1005;//连接门铃设备成功
    final static int MSG_INIT_VOL_FAILED = 0x1006;//连接门铃设备失败
    final static int MSG_SET_VOL_FAILED = 0x1007;//连接门铃设备失败
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MSG_SET_VOL_FAILED:
                    //提示获取失败
                    CommonUtils.showToast(R.string.setting_failded);
                    break;
                case MSG_INIT_VOL_FAILED:
                    CommonUtils.showToast(R.string.connectFail);
                    break;
                case MSG_UPDATE_TV_VOL:
                    //设置文字音量大小
                    tv_volume.setText("" + msg.getData().getInt("progress"));
                    bellVol = msg.getData().getInt("progress");
                    break;
                case MSG_INIT_VOL:
                    //设置文字音量大小
                    tv_volume.setText("" + bellVol);
                    //设置进度条进度
                    sb_volume.setProgress(bellVol);
                    //关闭加载对话框
                    stopProgressDialog();
                    break;
                case MSG_SEND_VOL_CMD:
                    //弹出加载对话框
                    startProgressDialog();
                    //发送设置请求
                    sendBellVol(bellVol);
                    break;
                case MSG_SEND_VOL_CMD_SUCCESS:
                    //关闭加载对话框
                    stopProgressDialog();
                    CommonUtils.showToast(R.string.setting_successfully);
                    break;
                case MSG_CONNECT_IPC_SUCCESS:
                    //去拿音量设置
                    getBellVolSetting();
                    break;
            }
        }
    };

    /**
     * 发送设置对讲音量大小请求
     *
     * @param bellVol
     */
    private void sendBellVol(int bellVol) {
        startProgressDialog();
        cameraPlayer.setBellVolume(bellVol, new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                //设置成功
                handler.sendEmptyMessage(MSG_SEND_VOL_CMD_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                //提示设置失败
                handler.sendEmptyMessage(MSG_SET_VOL_FAILED);
            }
        });
    }

    /**
     * 获取设置门铃对讲音量的json
     *
     * @param bellVol 对讲音量大小
     * @return json
     */
    private BaseJSONObject getBellVolJson(int bellVol) {
        BaseJSONObject volJson = new BaseJSONObject();
        volJson.put("volume", bellVol);
        return volJson;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bell_volume);

        //默认开启加载对话框
        startProgressDialog();

        initData();

        //初始化topbars
        initTopBar();

        initView();
    }

    private void initData() {
        //获取设备信息
        cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        //获取通用cameraplayer
        cameraPlayer = CommonUtils.getSdkUtil();
        //初始化对讲音量
        if (cameraPlayer.IsLogined() == true) {
            //获取对讲音量设置
            getBellVolSetting();

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
     * 获取对讲音量设置
     */
    private void getBellVolSetting() {
        cameraPlayer.getBellVolSetting(new BellVolumeListener() {
            @Override
            public void PPSuccessHandler(int volume) {
                bellVol = volume;
                handler.sendEmptyMessage(MSG_INIT_VOL);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                handler.sendEmptyMessage(MSG_INIT_VOL_FAILED);
            }
        });
    }

    private void initView() {
        //进度条进度监听
        sb_volume.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                //更新进度条显示文字
                Message msg = new Message();
                msg.what = MSG_UPDATE_TV_VOL;
                Bundle bundle = new Bundle();
                bundle.putInt("progress", progress);
                msg.setData(bundle);
                handler.sendMessage(msg);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        //设置进度条拖动抬起事件
        sb_volume.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_UP:
                        Log.i(TAG, "手指抬起");
                        //发送请求，设置门铃对讲音量
                        sendBellVol(bellVol);
                        break;
                }
                return false;
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
        this.mCenter.setText(getString(R.string.bell_volume));
        this.mRightBtn.setVisibility(View.GONE);
    }

}
