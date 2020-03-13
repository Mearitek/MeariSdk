package com.meari.test;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.meari.sdk.MeariSmartSdk;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.callback.ICreateQRCodeCallback;
import com.meari.sdk.callback.IDeviceStatusCallback;
import com.meari.sdk.callback.IGetTokenCallback;
import com.meari.sdk.listener.CameraSearchListener;
import com.meari.sdk.utils.MangerCameraScanUtils;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Constant;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.NetUtil;
import com.ppstrong.ppsplayer.BaseDeviceInfo;
import com.ppstrong.ppsplayer.CameraPlayer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/7/19
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class QRCodeActivity extends BaseActivity implements CameraSearchListener {
    private String mWifiName;
    private String mPwd;
    private int mWifiMode = 2;
    @BindView(R.id.qrcode_image)
    public ImageView mQrImage;
    private String mToken;
    private TimeCount mTimeCount;
    private MangerCameraScanUtils mMangerCameraScan;
    private final int HANDLER_MSG_ADD = 100;
    private HashMap<String, BaseDeviceInfo> mHasMap = new HashMap<>();
    public ArrayList<CameraInfo> mList = new ArrayList<>();
    public boolean IsFinishByNext = false;
    public int mDeviceTypeID = 2;
    private ArrayList<CameraInfo> mQrCameras = new ArrayList<>();//传入的Cameras

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_qrcode);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        initData();
        initView();
        startProgressDialog();
        mMangerCameraScan = new MangerCameraScanUtils(this.mWifiName, this.mPwd, 0, this, false);
        CameraPlayer.mSearchUrl = MeariSmartSdk.apiServer + "/ppstrongs/";
    }

    private void initView() {
        this.mCenter.setText(getString(R.string.my_qr));
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) mQrImage.getLayoutParams();
        params.height = Constant.width - DisplayUtil.dip2px(this, 56);
        this.mRightText.setText(getString(R.string.wifi_distribution));
        if (mDeviceTypeID == 4)
            this.action_bar_rl.setVisibility(View.VISIBLE);
        mQrImage.setLayoutParams(params);
        postTokenChange();
    }

    private void initData() {
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            this.mWifiName = bundle.getString(StringConstants.WIFI_NAME, "");
            this.mPwd = bundle.getString(StringConstants.WIFI_PWD, "");
            this.mWifiMode = bundle.getInt(StringConstants.WIFI_MODE, 2);
            this.mDeviceTypeID = bundle.getInt(StringConstants.DEVICE_TYPE_ID, 2);
            mQrCameras = (ArrayList<CameraInfo>) bundle.getSerializable(StringConstants.CAMERAS);
        }
    }

    private void CreateQrImage() {
        MeariUser.getInstance().createQRCode(mWifiName, mPwd, mToken, new ICreateQRCodeCallback() {
            @Override
            public void onSuccess(Bitmap bitmap) {
                mQrImage.setImageBitmap(bitmap);
                stopProgressDialog();
            }
        });
    }

    @OnClick(R.id.next)
    public void onNextClick() {
        this.IsFinishByNext = true;
        Intent intent = new Intent(this, SearchCameraResultActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString(StringConstants.WIFI_NAME, mWifiName);
        bundle.putString(StringConstants.WIFI_PWD, mPwd);
        bundle.putInt(StringConstants.WIFI_MODE, 0);
        bundle.putBoolean("smartConfig", false);
        bundle.putInt("deviceTypeID", mDeviceTypeID);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_SEARCHCANERARESLUT);
    }

    private void postTokenChange() {
        MeariUser.getInstance().getToken(new IGetTokenCallback() {
            @Override
            public void onSuccess(String s, int i, int i1) {
                mToken = s;
                startTimeCount(i);
                CreateQrImage();
                stopProgressDialog();
            }

            @Override
            public void onError(int i, String s) {
                CommonUtils.showToast(s);
                stopProgressDialog();
            }
        });
    }

    public void startTimeCount(int leftTime) {
        if (mTimeCount != null) {
            mTimeCount.cancel();
        }
        mTimeCount = new TimeCount(leftTime * 1000, 1000);
        CameraPlayer.mSearchUrl = MeariSmartSdk.apiServer + "/ppstrongs/";
        mMangerCameraScan.startSearchDevice(false, 0, leftTime * 1000, ActivityType.ACTIVITY_QR_CODE, mToken);
        mTimeCount.start();
    }

    @Override
    public void onCameraSearchDetected(CameraInfo uuid) {
        if (mHasMap != null && mHasMap.get(uuid.getSnNum()) != null) {
            return;
        }
        if (mHasMap == null) {
            mHasMap = new HashMap<>();
        }
        mHasMap.put(uuid.getSnNum(), uuid);
        Message msg = new Message();
        msg.what = HANDLER_MSG_ADD;
        msg.obj = uuid;
        searchHandler.sendMessage(msg);
    }

    @Override
    public void onCameraSearchFinished() {

    }

    @Override
    public void onRefreshProgress(int time) {

    }

    /**
     * 添加设备Handler
     */
    @SuppressLint("HandlerLeak")
    private Handler searchHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case HANDLER_MSG_ADD:
                    if (!NetUtil.checkNet(QRCodeActivity.this)) {
                        CommonUtils.showToast(getString(R.string.network_unavailable));
                        return;
                    }

                    CameraInfo infos = (CameraInfo) msg.obj;
                    List<CameraInfo> cameraInfos = new ArrayList<>();
                    cameraInfos.add(infos);
                    checkDeviceStatus(cameraInfos, mDeviceTypeID);
                    break;
                case 101:
                    mMangerCameraScan.stopDevieceSearch();
                    break;
            }
        }
    };

    private void checkDeviceStatus(List<CameraInfo> cameraInfos, int deviceTypeID) {
        MeariUser.getInstance().checkDeviceStatus(cameraInfos, deviceTypeID, new IDeviceStatusCallback() {
            @Override
            public void onSuccess(ArrayList<CameraInfo> deviceList) {

                for (int i = 0; i < deviceList.size(); i++) {
                    CameraInfo info = deviceList.get(i);
                    BaseDeviceInfo searchInfo = mHasMap.get(info.getSnNum());
                    if (searchInfo != null) {
                        String UUID = mHasMap.get(info.getSnNum()).getDeviceUUID();
                        info.setDeviceUUID(UUID);
                        if (info.getTp() == null || info.getTp().isEmpty()) {
                            info.setTp(searchInfo.getTp());
                        }
                    }
                    mList.add(0, info);
                    if (i == deviceList.size() - 1) {
                        String content = String.format(getString(R.string.cloud_search_format), info.getSnNum());
                        CommonUtils.showToast(content);
                    }
                }

                if (deviceList != null && deviceList.size() > 0) {
                    Intent intent = new Intent(QRCodeActivity.this, SearchCameraResultActivity.class);
                    Bundle bundle = new Bundle();
                    bundle.putString(StringConstants.WIFI_NAME, mWifiName);
                    bundle.putString(StringConstants.WIFI_PWD, mPwd);
                    bundle.putInt(StringConstants.WIFI_MODE, mWifiMode);
                    bundle.putInt(StringConstants.DEVICE_TYPE_ID, mDeviceTypeID);
                    bundle.putSerializable(StringConstants.CAMERAS, mList);
                    bundle.putBoolean(StringConstants.SMART_CONFIG, true);
                    intent.putExtras(bundle);
                    startActivityForResult(intent, ActivityType.ACTIVITY_SEARCHCANERARESLUT);
                }


            }

            @Override
            public void onError(int code, String error) {
                CommonUtils.showToast(error);
            }
        });
    }

    /* 定义一个倒计时的内部类 */
    class TimeCount extends CountDownTimer {

        public TimeCount(long millisInFuture, long countDownInterval) {
            // 参数依次为总时长,和计时的时间间隔
            super(millisInFuture, countDownInterval);
        }

        @Override
        public void onFinish() {// 计时完毕时触发
            postTokenChange();
            mMangerCameraScan.stopSearch();
        }

        @Override
        public void onTick(long millisUntilFinished) {
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mTimeCount != null)
            mTimeCount.cancel();
        mMangerCameraScan.finish();
    }


    @Override
    public void finish() {
        if (mList.size() > 0 || IsFinishByNext) {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable("cameraInfos", mList);
            intent.putExtras(bundle);
            setResult(RESULT_OK, intent);
        }
        super.finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_SEARCHCANERARESLUT:
                dealSearchCameraData(resultCode, data);
                break;
            case ActivityType.ACTIVITY_ADDMETHOD:
                dealSearchCameraData(resultCode, data);
                break;
            default:
                break;
        }
    }

    /*
     *根据添加页面返回处理是否返回列表
     */
    private void dealSearchCameraData(int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            if (data != null) {
                Bundle bundle = data.getExtras();
                if (bundle != null && bundle.getInt(StringConstants.BACK_HOME, 1) != 2) {
                    setResult(Activity.RESULT_OK, data);
                    finish();
                }
            }
        }
    }

    @OnClick(R.id.right_text)
    public void onWifiDistributionClick() {
        Intent intent = new Intent(this, AddCameraMethodActivity.class);
        Bundle bundle = new Bundle();
        bundle.putBoolean(StringConstants.AP_MODE, false);
        bundle.putInt(StringConstants.DEVICE_TYPE_ID, this.mDeviceTypeID);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_ADDMETHOD);
    }
}
