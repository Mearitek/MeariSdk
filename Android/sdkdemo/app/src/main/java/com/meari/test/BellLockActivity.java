package com.meari.test;

import android.animation.ObjectAnimator;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.sdk.bean.CameraInfo;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.widget.SwitchButton;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 门铃电池锁页面
 *
 * @author pupu
 * @time 2017年7月26日10:56:31
 */
public class BellLockActivity extends BaseActivity {
    final static String TAG = "BellLockActivity";

    @BindView(R.id.switch_lock)
    SwitchButton switch_lock;
    Dialog confirmDlg;
    @BindView(R.id.iv_bellLock)
    ImageView iv_bellLock;
    ObjectAnimator animator;//电池锁翻转动画
    @BindView(R.id.tv_bellLock)
    TextView tv_bellLock;

    //通用cameraplayer
    CameraPlayer cameraPlayer;
    CameraInfo cameraInfo;

    //统一消息处理
    final static int MSG_SHOW_DLG = 0x1001;//弹确认对话框
    final static int MSG_CLOSE_DLG = 0x1002;//关闭对话框
    final static int MSG_CHANGE_SWITCH_LOCK = 0x1003;//改变switchlock状态
    final static int MSG_GET_LOCK_SUCCESS = 0x1004;//获取电源
    final static int MSG_CONNECT_IPC_SUCCESS = 0x1005;//连接IPC成功
    final static int MSG_CONNECT_IPC_FAILED = 0x1006;//连接IPC失败
    final static int MSG_SET_LOCK_SUCCESS = 0x1007;//设置电池锁成功
    final static int MSG_SET_LOCK_FAILED = 0x1008;//设置电池锁失败
    final static int MSG_SET_LOCK = 0x1009;//发送解锁电池锁的指令，UI上开启旋转动画
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MSG_SET_LOCK:
                    //开启炫酷旋转动画
                    animator = ObjectAnimator.ofFloat(iv_bellLock, "scaleX", 1f, 0f, 1f);
                    animator.setInterpolator(new AccelerateDecelerateInterpolator());
                    animator.setDuration(500);
                    animator.setRepeatCount(-1);
                    animator.start();
                    tv_bellLock.setText(R.string.str_bell_locking);
                    iv_bellLock.setClickable(false);
                    break;
                case MSG_SET_LOCK_SUCCESS:
                    if (animator != null) {
                        animator.cancel();
                    }
                    iv_bellLock.setScaleX(1f);
                    iv_bellLock.setImageResource(R.mipmap.img_bell_unlock);
                    tv_bellLock.setText(R.string.str_bellLockSuccess);
                    CommonUtils.showToast(R.string.setting_successfully);
                    //关闭页面
//                    finish();
                    break;
                case MSG_SET_LOCK_FAILED:
                    //提示解锁失败
                    CommonUtils.showToast(R.string.setting_failded);
                    if (animator != null) {
                        animator.cancel();
                    }
                    iv_bellLock.setScaleX(1f);
                    iv_bellLock.setClickable(true);
                    tv_bellLock.setText(R.string.str_bellLock);
                    break;
                case MSG_CONNECT_IPC_FAILED:
                    //提示失败
                    CommonUtils.showToast(R.string.connectFail);
                    break;
                case MSG_CONNECT_IPC_SUCCESS:
                    //关闭加载框
                    stopProgressDialog();
                    break;
                case MSG_SHOW_DLG:
                    confirmDlg = CommonUtils.showDlg(BellLockActivity.this,
                            getString(R.string.battery_lock), getString(R.string.desc_dlg_lock),
                            getString(R.string.ok), positiveListener, getString(R.string.cancel),
                            negativeListener, true);
                    break;
                case MSG_CLOSE_DLG:
                    if (confirmDlg != null) {
                        confirmDlg.dismiss();
                    }
                    break;
                case MSG_CHANGE_SWITCH_LOCK:
                    boolean isChecked = switch_lock.isChecked();
                    switch_lock.setChecked(!isChecked);
                    break;
                case MSG_GET_LOCK_SUCCESS:
                    stopProgressDialog();
                    //根据信息改变switch状态,默认是开启状态

                    break;
            }
        }
    };

    //对话框确定
    private DialogInterface.OnClickListener positiveListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            //改变switch状态
//            handler.sendEmptyMessage(MSG_CHANGE_SWITCH_LOCK);
            //关闭对话框
//            handler.sendEmptyMessage(MSG_CLOSE_DLG);
            if (confirmDlg != null) {
                //关闭确认对话框
                confirmDlg.dismiss();
            }
            //开启旋转动画
            handler.sendEmptyMessage(MSG_SET_LOCK);
            //发送关闭电池锁请求
            sendCloseLock();
        }
    };

    /**
     * 关闭电池锁请求
     */
    private void sendCloseLock() {
        cameraPlayer.setBatteryUnlock(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                //提示成功,延时2s可以播放动画
                handler.sendEmptyMessageDelayed(MSG_SET_LOCK_SUCCESS, 2000);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                //提示失败,延时2s可以播放动画
                handler.sendEmptyMessageDelayed(MSG_SET_LOCK_FAILED, 2000);
            }
        });

    }

    //对话框取消
    private DialogInterface.OnClickListener negativeListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            //关闭对话框
            handler.sendEmptyMessage(MSG_CLOSE_DLG);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bell_lock);

        startProgressDialog();

        initData();

        initTopBar();

        initView();
    }

    private void initData() {
        cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        //获取通用cameraplayer
        cameraPlayer = CommonUtils.getSdkUtil();
        if (cameraPlayer.IsLogined()) {
            //电池锁一定是锁上的，只管关闭对话框
            stopProgressDialog();
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
                        handler.sendEmptyMessage(MSG_CONNECT_IPC_FAILED);
                    }
                });
    }

    private void initView() {
        //默认打开电池锁
        switch_lock.setChecked(true);
        //屏蔽ontouch，弹对话框
        switch_lock.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:

                        break;
                    case MotionEvent.ACTION_MOVE:

                        break;
                    case MotionEvent.ACTION_UP:
                        //关闭的话要弹确认对话框
                        if (switch_lock.isChecked() == true) {
                            handler.sendEmptyMessage(MSG_SHOW_DLG);
                        } else {
                            //改变状态
                            handler.sendEmptyMessage(MSG_CHANGE_SWITCH_LOCK);
                        }
                        break;
                }
                return true;
            }
        });
    }

    @OnClick({R.id.iv_bellLock})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_bellLock:
                //弹出是否解锁对话框
                handler.sendEmptyMessage(MSG_SHOW_DLG);
                break;
        }
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
        this.mCenter.setText(getString(R.string.battery_lock));
        this.mRightBtn.setVisibility(View.GONE);
    }
}
