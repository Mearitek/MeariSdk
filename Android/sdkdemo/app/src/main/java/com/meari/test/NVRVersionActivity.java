package com.meari.test;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.RequiresApi;
import android.view.View;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.DeviceUpgradeInfo;
import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.callback.ICheckNewFirmwareForDevCallback;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
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
 * 创建日期：2017/5/15
 * 描    述：NVR版本升级
 * 修订历史：
 * ================================================
 */

public class NVRVersionActivity extends BaseActivity implements CameraPlayerListener {
    private Dialog mDialog;
    private NVRInfo mInfo;
    private int mProgress;
    @BindView(R.id.update_progress)
    public RoundProgressBar mProgressBar;
    @BindView(R.id.device_text)
    public TextView mDeviceText;
    @BindView(R.id.ser_version_text)
    public TextView mSerText;
    @BindView(R.id.update_text)
    public TextView mUpdateBtn;
    private final int MESSAGE_LOGIN_SUCCESS = 1001;
    private final int MESSAGE_LOGIN_FAILED = 1002;
    private final int MESSAGE_UPGRADE_SUCCESS = 1003;
    private final int MESSAGE_UPGRADE_FALDED = 1004;
    private final int MESSAGE_INIT_LOGIN_SUCCESS = 1005;
    private final int MESSAGE_INIT_LOGIN_FAILED = 1006;
    private final int MESSAGE_VERSION_SUCCESS = 1007;
    private final int MESSAGE_VERSION_FAILED = 1008;
    private boolean bConnect = false;
    private int mFailedCount = 0;
    private final int MAX_FAILED = 3;
    private DeviceUpgradeInfo mDeviceUpgradeInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_updata);
        mInfo = (NVRInfo) getIntent().getExtras().getSerializable("NVRInfo");
        TextView infoText = (TextView) findViewById(R.id.pps_device_info);
        infoText.setText(mInfo.getDeviceName() + " (" + mInfo.getSnNum() + ")");
        mCurPlayer = new CameraPlayer();
        getTopTitleView();
        initView();
        startProgressDialog();
        getProgressDialog().setOnCancelListener(cancelListener);
        if (mInfo.getNvrVersionID() == null || mInfo.getNvrVersionID().isEmpty()) {
            initVersion();
        } else {
            postUpdateDevice();
        }
    }

    public void initVersion() {
        mCurPlayer.connectIPC2(CommonUtils.getCameraString(mInfo), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (successMsg == null || mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_INIT_LOGIN_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_INIT_LOGIN_FAILED);
            }
        });
    }

    private void initView() {
        float textsize = DisplayUtil.sp2px(this, 15);
        this.mProgressBar.setTextSize(textsize);
        this.mProgressBar.setProgress(0);
        this.mProgressBar.setVisibility(View.GONE);
        if (mInfo.getNvrVersionID() != null && !mInfo.getNvrVersionID().isEmpty()) {
            String[] versionList = mInfo.getNvrVersionID().split("-");
            if (versionList.length == 0) {
                mDeviceText.setText(getString(R.string.fail));
            } else
                mDeviceText.setText(versionList[versionList.length - 1]);
        }
        this.mCenter.setText(R.string.title_version);
    }

    public void setVerionView() {
        if (mInfo.getNvrVersionID() != null) {
            String[] versionList = mInfo.getNvrVersionID().split("-");
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
        MeariUser.getInstance().checkNewFirmwareForDev(mInfo.getNvrVersionID(), CommonUtils.getLangType(this), new ICheckNewFirmwareForDevCallback() {
            @Override
            public void onSuccess(DeviceUpgradeInfo info) {
                mDeviceUpgradeInfo = info;
                findViewById(R.id.ser_version_layout).setVisibility(View.VISIBLE);
                mSerText.setText(getSerVersionName());
                if (info.getUpgradeDescription() == null || info.getUpgradeDescription().length() == 0) {
                    findViewById(R.id.updata_text).setVisibility(View.GONE);
                } else {
                    findViewById(R.id.updata_text).setVisibility(View.VISIBLE);
                    ((TextView) findViewById(R.id.updata_text)).setText(info.getUpgradeDescription());
                }
                if (info.getUpgradeStatus() != 0) {
                    mUpdateBtn.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onError(int code, String error) {

            }
        });
    }



    public String getSerVersionName() {
        if (mDeviceUpgradeInfo != null) {
            String[] versionList =mDeviceUpgradeInfo.getNewVersion().split("-");
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
        if (mDeviceUpgradeInfo.getUpgradeStatus() == 0) {
            return;
        }
        if (mDialog == null)
            mDialog = CommonUtils.showDlg(this, this.getString(R.string.app_meari_name), getString(R.string.updata_warning),
                    getString(R.string.ok), positiveclick,
                    getString(R.string.cancel), negetiveClick, true);
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
            if (!bConnect)
                connectCamera();
            else {
                BaseJSONObject json = new BaseJSONObject();
                json.put("upgradeurl", mDeviceUpgradeInfo.getUpgradeUrl());
                json.put("firmwareversion", mDeviceUpgradeInfo.getNewVersion());
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
                                mEventHandler.sendEmptyMessage(MESSAGE_UPGRADE_FALDED);
                            }
                        });
            }
        }
    };

    private void connectCamera() {
        mCurPlayer.connectIPC2(CommonUtils.getCameraString(mInfo) , this);
    }

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
            if (mDeviceUpgradeInfo == null)
                return;
            if (what == 0) {
                int desc = (int) msg.obj;
                if (desc < 0) {
                    mProgressBar.setProgress(0);
                    mProgressBar.setVisibility(View.GONE);
                    mUpdateBtn.setEnabled(true);
                    mUpdateBtn.setVisibility(View.VISIBLE);
                    return;
                } else if (desc == 100) {
                    if (mDeviceUpgradeInfo.getNewVersion() != null) {
                        String[] versionList = mDeviceUpgradeInfo.getNewVersion().split("-");
                        if (versionList.length == 0) {
//                            mDeviceText.setText(getString(R.string.fail));
                        } else
                            mDeviceText.setText(versionList[versionList.length - 1]);
                    }
                    mUpdateBtn.setEnabled(false);
                    mUpdateBtn.setVisibility(View.VISIBLE);
                    mUpdateBtn.setText(getString(R.string.format_done));
                    mProgressBar.setVisibility(View.GONE);
                    CommonUtils.showToast(getString(R.string.format_done));
                    return;
                }
                mProgressBar.setProgress(desc);
                mUpdateBtn.setVisibility(View.GONE);
                return;
            } else
                return;
        }
    };


    @Override
    public void finish() {
        super.finish();
        if (mCurPlayer != null)
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

            if (mDeviceUpgradeInfo == null)
                return;
            switch (msg.what) {
                case MESSAGE_LOGIN_SUCCESS:
                    bConnect = true;
                    BaseJSONObject json = new BaseJSONObject();
                    json.put("upgradeurl", mDeviceUpgradeInfo.getUpgradeUrl());
                    json.put("firmwareversion", mDeviceUpgradeInfo.getNewVersion());
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
                                    if (mEventHandler == null || errorMsg == null)
                                        return;
                                    Message msg = new Message();
                                    msg.what = MESSAGE_UPGRADE_FALDED;
                                    msg.obj = errorMsg;
                                    mEventHandler.sendMessage(msg);
                                }
                            });
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
                    CommonUtils.showDlg(NVRVersionActivity.this, getString(R.string.app_meari_name),
                            getString(R.string.status_failure_try_again), getString(R.string.ok), mPospositiveListener,
                            getString(R.string.cancel), mNegativeListener, false);
                    break;
                case MESSAGE_UPGRADE_SUCCESS:
                    stopProgressDialog();
                    mUpdateBtn.setEnabled(true);
                    mUpdateBtn.setVisibility(View.GONE);
                    mProgressBar.setVisibility(View.VISIBLE);
                    mCurPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_UPGRADE_PERCENT, mUpdatePercent);
                    break;
                case MESSAGE_UPGRADE_FALDED:
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
                case MESSAGE_INIT_LOGIN_SUCCESS:
                    bConnect = true;
                    getNvrVersionByNvr();
                    break;
                case MESSAGE_INIT_LOGIN_FAILED:
                    stopProgressDialog();
                    CommonUtils.showDlg(NVRVersionActivity.this, getString(R.string.app_meari_name),
                            getString(R.string.status_failure_try_again), getString(R.string.ok), mInitPospositiveListener,
                            getString(R.string.cancel), mNegativeListener, false);
                    break;
                case MESSAGE_VERSION_SUCCESS:
                    setVerionView();
                    postUpdateDevice();
                    break;
                case MESSAGE_VERSION_FAILED:
                    mDeviceText.setText(getString(R.string.fail));
                    stopProgressDialog();
                    CommonUtils.showDlg(NVRVersionActivity.this, getString(R.string.app_meari_name),
                            getString(R.string.status_failure_try_again), getString(R.string.ok), mVersionPospositiveListener,
                            getString(R.string.cancel), mNegativeListener, false);
                    break;
                default:
                    break;
            }
        }
    };
    public DialogInterface.OnClickListener mInitPospositiveListener = new DialogInterface.OnClickListener() {

        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            startProgressDialog(getString(R.string.pps_waite));
            initVersion();
        }
    };
    public DialogInterface.OnClickListener mVersionPospositiveListener = new DialogInterface.OnClickListener() {

        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            startProgressDialog(getString(R.string.pps_waite));
            getNvrVersionByNvr();
        }
    };

    private CameraPlayerListener mUpdatePercent = new CameraPlayerListener() {
        @Override
        public void PPSuccessHandler(String successMsg) {
            if (mEventHandler == null || successMsg == null)
                return;
            try {
                BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                int precent = jsonObject.optInt("percent", 0);
                dealPercent(precent);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public void PPFailureError(String errorMsg) {
            if (isFinishing() || isDestroyed())
                return;
            if (mFailedCount > MAX_FAILED) {
                dealPercent(-1);
                mFailedCount++;
            } else {
                if (mEventHandler != null)
                    mEventHandler.postDelayed(updateThread, 1000);
            }
        }
    };

    private void dealPercent(int procent) {
        if (mProgressHandler == null)
            return;
        Message msg = Message.obtain();
        if (procent == -1) {
            if (mProgress != 0) {
                mProgress = 100;
                msg.what = 0;
                msg.obj = mProgress;
                mProgressHandler.sendMessage(msg);
            } else {
                msg.what = 0;
                msg.obj = procent;
                mProgressHandler.sendMessage(msg);
            }

        } else if (procent == 0) {
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
            mProgress = procent;
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


    public void getNvrVersionByNvr() {
        mCurPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_INFO, new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isFinishing() || isDestroyed() || mEventHandler == null || successMsg == null)
                    return;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                    String version = jsonObject.optString("firmwareversion", "");
                    mInfo.setNvrVersionID(version);
                    if (mEventHandler != null)
                        mEventHandler.sendEmptyMessage(MESSAGE_VERSION_SUCCESS);
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

