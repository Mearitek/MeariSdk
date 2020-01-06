package com.meari.test;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.RequiresApi;
import android.view.View;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.DeviceUpgradeInfo;
import com.meari.sdk.callback.ICheckNewFirmwareForDevCallback;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.RoundProgressBar;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import butterknife.OnClick;


/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 修订历史：
 * ================================================
 */

public class DeviceForceVersionActivity extends BaseActivity implements CameraPlayerListener {
    private int updateStatus;
    private String mDevUrl;
    private String mSerVersion;
    private Dialog mDialog;
    private CameraInfo mInfo;
    private int mProgress;
    public RoundProgressBar mProgressBar;
    public TextView mDeviceText;
    public TextView mSerText;
    public TextView mUpdateBtn;
    private final int MESSAGE_LOGIN_SUCCESS = 1001;
    private final int MESSAGE_LOGIN_FAILED = 1002;
    private final int MESSAGE_UPGRADE_SUCCESS = 1003;
    private final int MESSAGE_UPGRADE_FAILED = 1004;
    private boolean bConnect = false;
    private int mFailedCount = 0;
    private String mVersion;
    private final int MESSAGE_VERSION = 1005;
    private final int MESSAGE_VERSION_FAILED = 1006;
    private int mType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_force_updata);
        Bundle bundle = getIntent().getExtras();
        getTopTitleView();
        if (bundle != null)
        {
            mInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
            updateStatus = bundle.getInt("isUpgrade",0);
            TextView infoText = findViewById(R.id.pps_device_info);
            String infoContent = mInfo.getDeviceName() + " (" + mInfo.getSnNum() + ")";
            infoText.setText(infoContent);
            initView();
            mType = bundle.getInt("type",0);
            if (mType ==ActivityType.ACTIVITY_SIGPLAY ) {
                mSerVersion = bundle.getString("devVersionID","" );
                String versionDesc =  bundle.getString("versionDesc","" );
                mDevUrl = bundle.getString("devUrl", "");
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
                mCurPlayer = Preference.getPreference().getSdkNativeUtil();
                mVersion = mInfo.getDeviceVersionID();
                mEventHandler.sendEmptyMessage(MESSAGE_VERSION);

            }
            else
            {
                mCurPlayer = new CameraPlayer();
                startProgressDialog();
                getProgressDialog().setOnCancelListener(cancelListener);
                connectCamera();
            }
        }
    }


    private void initView() {
        SimpleDraweeView simpleDraweeView = findViewById(R.id.device_type_img);
        simpleDraweeView.setImageURI(Uri.parse(mInfo.getDeviceIcon()));
        simpleDraweeView.getHierarchy().setFailureImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
        this.mCenter.setText(R.string.title_version);
        mProgressBar = findViewById(R.id.update_progress);
        mDeviceText = findViewById(R.id.device_text);
        mSerText = findViewById(R.id.ser_version_text);
        mUpdateBtn = findViewById(R.id.update_text);
        float textSize = DisplayUtil.sp2px(this, 15);
        this.mProgressBar.setTextSize(textSize);
        this.mProgressBar.setProgress(0);
        this.mProgressBar.setVisibility(View.GONE);
    }

    private void initVersionView() {
        if (mInfo.getDeviceVersionID() != null) {
            String[] versionList = mInfo.getDeviceVersionID().split("-");
            if (versionList.length == 0) {
                mDeviceText.setText(getString(R.string.fail));
            } else
                mDeviceText.setText(versionList[versionList.length - 1]);
        } else {
            mDeviceText.setText(getString(R.string.fail));
        }

    }

    private void postUpdateDevice() {
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().checkNewFirmwareForDev(mInfo.getDeviceVersionID(), CommonUtils.getLangType(this), this ,new ICheckNewFirmwareForDevCallback() {
            @Override
            public void onSuccess(DeviceUpgradeInfo info) {
                stopProgressDialog();
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
                    getString(R.string.ok), positiveclick,
                    getString(R.string.cancel), negativeClick, true);
        else {
            mDialog.show();
        }
    }

    private DialogInterface.OnClickListener positiveclick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            mFailedCount = 0;
            startProgressDialog();
            BaseJSONObject json = new BaseJSONObject();
            json.put("upgradeurl", mDevUrl);
            json.put("firmwareversion", mSerVersion);
            mCurPlayer.setdeviceparams(CameraPlayer.SET_PPS_DEVICE_UPGRADE,
                    json.toString(),
                    new CameraPlayerListener() {
                        @Override
                        public void PPSuccessHandler(String successMsg) {
                            if (mEventHandler == null)
                                return;
                            mEventHandler.sendEmptyMessage(MESSAGE_UPGRADE_SUCCESS);
                        }

                        @Override
                        public void PPFailureError(String errorMsg) {
                            if (mEventHandler == null)
                                return;
                            Message msg = new Message();
                            msg.what = MESSAGE_UPGRADE_FAILED;
                            msg.obj = errorMsg;
                            mEventHandler.sendMessage(msg);
                        }
                    });
        }
    };

    private void connectCamera() {
        mCurPlayer.connectIPC2(CommonUtils.getCameraString(mInfo), this);
    }

    private DialogInterface.OnClickListener negativeClick = new DialogInterface.OnClickListener() {
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
                if (desc < 0) {
                    mProgressBar.setProgress(0);
                    mProgressBar.setVisibility(View.GONE);
                    mUpdateBtn.setEnabled(true);
                    mUpdateBtn.setVisibility(View.VISIBLE);
                    return;
                } else if (desc == 100) {
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
                    return;
                }
                mProgressBar.setProgress(desc);
                mUpdateBtn.setVisibility(View.GONE);
            }
            else if (what == 1)
            {
                int desc = (int) msg.obj;
                if (desc == 100) {
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
                    return;
                }
            }
        }
    };


    @Override
    public void finish() {
        String content = mUpdateBtn.getText().toString();
        if (content != null && content.equals(getString(R.string.format_done))) {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable("cameraInfo", mInfo);
            intent.putExtras(bundle);
            setResult(RESULT_OK, intent);
        }
        super.finish();

        if (mCurPlayer != null && mType != ActivityType.ACTIVITY_SIGPLAY)
            if (mCurPlayer.getCameraInfo() != null) {
                mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {

                    }

                    @Override
                    public void PPFailureError(String errorMsg) {

                    }
                });
            }
        mProgressHandler.removeMessages(0);
        mEventHandler = null;
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

    private CameraPlayer mCurPlayer;
    @SuppressLint("HandlerLeak")
    private Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_LOGIN_SUCCESS:
                    bConnect = true;
                    getCameraStatus();
                    break;
                case MESSAGE_LOGIN_FAILED:
                    stopProgressDialog();
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
                    CommonUtils.showDlg(DeviceForceVersionActivity.this, getString(R.string.app_meari_name),
                            getString(R.string.status_failure_try_again), getString(R.string.ok), mPospositiveListener,
                            getString(R.string.cancel), mNegativeListener, false);
                    break;
                case MESSAGE_UPGRADE_SUCCESS:
                    if (mVersion.contains("1.8.4"))
                    {
                        Message updateMsg = new Message();
                        mProgress = 100;
                        updateMsg.what = 1;
                        updateMsg.obj = mProgress;
                        mProgressHandler.sendMessage(updateMsg);
                        CommonUtils.showToast(getString(R.string.updata_already));
                    }else {
                        stopProgressDialog();
                        mUpdateBtn.setEnabled(false);
                        mUpdateBtn.setVisibility(View.GONE);
                        mProgressBar.setVisibility(View.VISIBLE);
                        mCurPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_UPGRADE_PERCENT, mUpdatePercent);
                    }
                    break;
                case MESSAGE_UPGRADE_FAILED:
                    String result = (String) msg.obj;
                    stopProgressDialog();
                    int error = -1001;
                    try {
                        BaseJSONObject jsonObject = new BaseJSONObject(result);
                        error = jsonObject.optInt("errcode");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    if (error == -15) {
                        findViewById(R.id.updata_text).setVisibility(View.GONE);
                        mProgressBar.setVisibility(View.VISIBLE);
                        if (mEventHandler != null)
                            mEventHandler.postDelayed(updateThread, 0);
                        findViewById(R.id.updata_text).setEnabled(false);
                    } else
                        CommonUtils.showToast(R.string.update_failed);
                    break;
                case MESSAGE_VERSION:
                    initVersionView();
                    postUpdateDevice();
                    findViewById(R.id.pps_device_info).setEnabled(false);
                    break;
                case MESSAGE_VERSION_FAILED:
                    findViewById(R.id.pps_device_info).setEnabled(true);
                    stopProgressDialog();
                    CommonUtils.showToast(R.string.fail);
                    findViewById(R.id.pps_device_info).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            if (getProgressDialog().isShowing()) {
                                return;
                            }
                            if (bConnect) {
                                startProgressDialog();
                                getCameraStatus();
                            } else {
                                startProgressDialog();
                                connectCamera();
                            }
                        }
                    });
                    break;
                default:
                    break;
            }
        }
    };
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

    private void dealPercent(int percent) {
        if (mProgressHandler == null)
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
                if (mEventHandler == null)
                    return;
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
            if (mEventHandler == null)
                return;
            if (mProgress != 100)
                mEventHandler.postDelayed(updateThread, 1000);
        }
    }

    Runnable updateThread = new Runnable() {
        public void run() {
            mCurPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_UPGRADE_PERCENT, mUpdatePercent);
        }

    };
    public DialogInterface.OnClickListener mPospositiveListener = new DialogInterface.OnClickListener() {

        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            startProgressDialog(getString(R.string.pps_waite));
            connectCamera();
        }
    };
    public DialogInterface.OnClickListener mNegativeListener = new DialogInterface.OnClickListener() {

        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            finish();
        }
    };
    private DialogInterface.OnCancelListener cancelListener = new DialogInterface.OnCancelListener() {

        @Override
        public void onCancel(DialogInterface dialog) {
            dialog.dismiss();
            finish();
        }
    };

    private void getCameraStatus() {
        mCurPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_INFO, new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isFinishing() || isDestroyed() || mEventHandler == null || successMsg == null)
                    return;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                    mVersion = jsonObject.optString("firmwareversion", "");
                    mInfo.setDeviceVersionID(mVersion);
                    mEventHandler.sendEmptyMessage(MESSAGE_VERSION);
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_VERSION_FAILED);
            }
        });
    }
}


