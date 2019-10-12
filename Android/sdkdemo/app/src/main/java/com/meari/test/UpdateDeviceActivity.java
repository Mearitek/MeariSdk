package com.meari.test;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.RoundingParams;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.DeviceUpgradeInfo;
import com.meari.sdk.callback.ICheckNewFirmwareForDevCallback;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.Logger;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.RoundProgressBar;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/5
 * 描    述：升级版本IPC页面
 * 修订历史：
 * ================================================
 */
public class UpdateDeviceActivity extends BaseActivity {
    private static final String TAG = "UpdateDeviceActivity";
    @BindView(R.id.device_text)
    public TextView mDeviceText;
    @BindView(R.id.ser_version_text)
    public TextView mSerText;
    @BindView(R.id.update_progress)
    public RoundProgressBar mProgressBar;
    @BindView(R.id.update_text)
    public TextView mUpdateBtn;
    private String mDeviceVersion;
    private int updateStatus;
    private String mDevUrl;
    private String mSerVersion;
    private Dialog mDialog;
    private CameraInfo mInfo;
    private int mProgress;
    private final int MESSAGE_UPGRADE_SUCCESS = 1001;
    private final int MESSAGE_UPGRADE_FAILED = 1002;
    private int mFailedCount = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_camera_updata);
        initData();
        initView();
    }

    private void initData() {
        mProgressBar.setVisibility(View.GONE);
        mDeviceVersion = getIntent().getExtras().getString("version", "");
        mInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
    }

    private void initView() {
        getTopTitleView();
        if (mDeviceVersion != null) {
            String[] versionList = mDeviceVersion.split("-");
            if (versionList.length == 0) {
                mDeviceText.setText(getString(R.string.fail));
            } else
                mDeviceText.setText(versionList[versionList.length - 1]);
        } else {
            mDeviceText.setText(getString(R.string.fail));
        }
        this.mCenter.setText(R.string.version_title);
        if (this.mDeviceVersion != null) {
            postUpdateDevice();
        }
        RoundingParams params = new RoundingParams();
        params.setRoundAsCircle(true);
        SimpleDraweeView img_camera = findViewById(R.id.img_camera);
        img_camera.setImageURI(mInfo.getDeviceIcon());
        img_camera.getHierarchy().setRoundingParams(params);
        img_camera.getHierarchy().setFailureImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
        mProgressBar.setProgress(0);
        mProgressBar.setVisibility(View.GONE);
        TextView infoText = findViewById(R.id.pps_device_info);
        infoText.setText(mInfo.getDeviceName() + " (" + mInfo.getSnNum() + ")");
        startProgressDialog();
    }

    private void postUpdateDevice() {
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().checkNewFirmwareForDev(mDeviceVersion, CommonUtils.getLangType(this), this ,new ICheckNewFirmwareForDevCallback() {
            @Override
            public void onSuccess(DeviceUpgradeInfo info) {
                findViewById(R.id.ser_version_layout).setVisibility(View.VISIBLE);
                updateStatus = info.getUpdateStatus();
                mSerVersion = info.getSerVersion();
                String versionDesc = info.getVersionDesc();
                mDevUrl = info.getDevUrl();
                mSerText.setText(getSerVersionName());
                if (versionDesc == null || versionDesc.length() == 0) {
                    findViewById(R.id.updata_text).setVisibility(View.GONE);
                } else {
                    findViewById(R.id.updata_text).setVisibility(View.VISIBLE);
                    ((TextView) findViewById(R.id.updata_text)).setText(versionDesc);
                }
                if (updateStatus != 0) {
                    mUpdateBtn.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                showToast(error);
            }
        });


    }


    public String getSerVersionName() {
        if (mSerVersion != null) {
            String[] versionList = mSerVersion.split("-");
            if (versionList.length == 0) {
                return mDeviceText.getText().toString();
            } else
                return versionList[versionList.length - 1];
        } else {
            return mDeviceText.getText().toString();
        }
    }

    @OnClick(R.id.update_text)
    public void onUpdateClick() {
        String content = mUpdateBtn.getText().toString();
        if (content != null && content.equals(getString(R.string.format_done))) {
            finish();
            return;
        }
        if (this.updateStatus == 0) {
            return;
        }
        if (mDialog == null)
            mDialog = CommonUtils.showDlg(this, this.getString(R.string.app_meari_name), getString(R.string.updata_warning),
                    getString(R.string.ok), positiveClick,
                    getString(R.string.cancel), negetiveClick, true);
        else {
            mDialog.show();
        }
    }

    private DialogInterface.OnClickListener positiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            BaseJSONObject json = new BaseJSONObject();
            json.put("url", mDevUrl);
            Logger.i(TAG, "url:" + mDevUrl);
            json.put("firmwareversion", mSerVersion);
            json.put("action", "POST");
            json.put("deviceurl", "http://127.0.0.1/devices/firmware_upgrade");
            //换成commonDeviceParams2
            CommonUtils.getSdkUtil().commondeviceparams2(json.toString(), new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    Logger.i(TAG, "upgrade success:" + successMsg);
                    if (mEventHandler != null) {
                        mEventHandler.sendEmptyMessage(MESSAGE_UPGRADE_SUCCESS);
                    }
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    Logger.i(TAG, "upgrade error:" + errorMsg);
                    try {
                        BaseJSONObject errJson = new BaseJSONObject(errorMsg);
                        int http_errorcode = errJson.getInt("http_errorcode");
                        if (mEventHandler != null) {
                            if (http_errorcode == 403) {
                                Message msg = new Message();
                                msg.obj = http_errorcode;
                                msg.what = MESSAGE_UPGRADE_FAILED;
                                mEventHandler.sendMessage(msg);
                                return;
                            }
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    if (mEventHandler != null) {
                        mEventHandler.sendEmptyMessage(MESSAGE_UPGRADE_FAILED);
                    }
                }
            });
        }
    };
    private DialogInterface.OnClickListener negetiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };

    @SuppressLint("HandlerLeak")
    private Handler mProgressHandler = new Handler() {
        public void handleMessage(Message msg) {
            int what = msg.what;
            if (what == 0) {
                int desc = (int) msg.obj;
                if (desc == -1) {
                    mProgressBar.setProgress(0);
                    mProgressBar.setVisibility(View.GONE);
                    mUpdateBtn.setEnabled(true);
                    mUpdateBtn.setVisibility(View.VISIBLE);
                    return;
                } else if (desc == 100) {
                    CameraSettingActivity.mVersion = mSerVersion;
                    CameraSettingActivity.mBUpdate = true;
                    if (mSerVersion != null) {
                        String[] versionList = mSerVersion.split("-");
                        if (versionList.length == 0) {
                            mDeviceText.setText(getString(R.string.fail));
                        } else
                            mDeviceText.setText(versionList[versionList.length - 1]);
                    }
                    mUpdateBtn.setEnabled(true);
                    mUpdateBtn.setVisibility(View.VISIBLE);
                    mUpdateBtn.setText(getString(R.string.format_done));
                    mProgressBar.setVisibility(View.GONE);
                    CommonUtils.showToast(getString(R.string.format_done));
                } else
                    mProgressBar.setProgress(desc);
                mUpdateBtn.setText(getString(R.string.done));
            } else if (what == 1) {
                int desc = (int) msg.obj;
                if (desc == 100) {
                    CameraSettingActivity.mVersion = mSerVersion;
                    CameraSettingActivity.mBUpdate = true;
                    if (mSerVersion != null) {
                        String[] versionList = mSerVersion.split("-");
                        if (versionList.length == 0) {
                            mDeviceText.setText(getString(R.string.fail));
                        } else
                            mDeviceText.setText(versionList[versionList.length - 1]);
                    }
                    mUpdateBtn.setEnabled(true);
                    mUpdateBtn.setVisibility(View.VISIBLE);
                    mUpdateBtn.setText(getString(R.string.format_done));
                    mProgressBar.setVisibility(View.GONE);
                }
            }
        }
    };

    Runnable updateThread = new Runnable() {
        public void run() {
            CommonUtils.getSdkUtil().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_UPGRADE_PERCENT, mUpdatePercent);
        }

    };

    @Override
    public void finish() {
        super.finish();
        mEventHandler = null;
    }

    private void dealPercent(int percent) {
        if (mProgressHandler == null || mEventHandler == null)
            return;
        Message msg = Message.obtain();
        if (percent < 0) {
            if (mProgress != 0) {
                mProgress = 100;
                msg.what = 0;
                msg.obj = mProgress;
                mProgressHandler.sendMessage(msg);
            } else {
                msg.what = 0;
                msg.obj = percent;
                mProgressHandler.sendMessage(msg);
            }

        } else if (percent == 0) {
            if (mProgress != 0) {
                mProgress = 100;
            } else {
                mEventHandler.postDelayed(updateThread, 1000);
                mProgress = 0;
            }
            msg.what = 0;
            msg.obj = mProgress;
            mProgressHandler.sendMessage(msg);
        } else {
            mProgress = percent;
            msg.what = 0;
            msg.obj = mProgress;
            mProgressHandler.sendMessage(msg);
            if (mProgress != 100)
                mEventHandler.postDelayed(updateThread, 1000);
        }
    }

    private CameraPlayerListener mUpdatePercent = new CameraPlayerListener() {
        @Override
        public void PPSuccessHandler(String successMsg) {
            if (mEventHandler == null || successMsg == null)
                return;
            try {
                BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                int percent = jsonObject.optInt("percent", 0);
                dealPercent(percent);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public void PPFailureError(String errorMsg) {
            if (isFinishing() || isDestroyed())
                return;
            if (mFailedCount > 3) {
                dealPercent(-1);
                mFailedCount++;
            } else {
                if (mEventHandler != null)
                    mEventHandler.postDelayed(updateThread, 1000);
            }
        }
    };
    @SuppressLint("HandlerLeak")
    private Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_UPGRADE_SUCCESS:

                    if (mDeviceVersion.contains("1.8.4")) {
                        Message updateMsg = new Message();
                        mProgress = 100;
                        updateMsg.what = 1;
                        updateMsg.obj = mProgress;
                        mProgressHandler.sendMessage(updateMsg);
                        CommonUtils.showToast(getString(R.string.updata_already));
                    } else {
                        mUpdateBtn.setEnabled(true);
                        mUpdateBtn.setVisibility(View.GONE);
                        mProgressBar.setVisibility(View.VISIBLE);
                        CommonUtils.getSdkUtil().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_UPGRADE_PERCENT, mUpdatePercent);
                    }
                    break;
                case MESSAGE_UPGRADE_FAILED:
                    if (msg.obj != null) {
                        int http_errcode = (int) msg.obj;
                        if (http_errcode == 403) {
                            CommonUtils.showToast(R.string.toast_lowPowerNoUpgrade);
                        }
                    } else {
                        CommonUtils.showToast(R.string.update_failed);
                    }
                    break;
            }
        }
    };


}

