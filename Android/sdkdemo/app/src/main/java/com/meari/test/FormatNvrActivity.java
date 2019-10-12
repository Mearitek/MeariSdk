package com.meari.test;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.TextView;

import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.widget.RoundProgressBar;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import java.text.DecimalFormat;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class FormatNvrActivity extends BaseActivity implements CameraPlayerListener {
    private Dialog mPop;
    @BindView(R.id.format_pr)
    RoundProgressBar mProgressbar;
    @BindView(R.id.format_sdcard_tv)
    TextView format_sdcard_tv;
    private boolean mIsFirst = false;
    private NVRInfo mInfo;
    private int mStatus;
    private CameraPlayer mCurPlayer;
    private final int MESSAGE_LOGIN_SUCCESS = 1001;
    private final int MESSAGE_LOGIN_FAILED = 1002;
    private final int MESSAGE_GET_SD_SUCCESS = 1003;
    private final int MESSAGE_GET_SD_FAILED = 1004;
    private final int MESSAGE_FORMAT_SUCCESS = 1005;
    private final int MESSAGE_FORMAT_FAILED = 1006;
    private int mFailedCount = 0;
    private int mCapacity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_format_nvr);
        mInfo = (NVRInfo) getIntent().getExtras().getSerializable("NVRInfo");
        initView();
        startProgressDialog();
        getProgressDialog().setOnCancelListener(cancelListener);
        connectCamera();
    }

    private void connectCamera() {
        if (mCurPlayer == null)
            mCurPlayer = new CameraPlayer();
        mCurPlayer.connectIPC2(CommonUtils.getCameraString(mInfo), this);
    }

    private void initView() {
        getTopTitleView();
        this.mProgressbar.setTextSize(DisplayUtil.sp2px(this, 15));
        this.mProgressbar.setProgress(0);
        this.mCenter.setText(R.string.title_rormat_hard);

    }

    @OnClick(R.id.format_sdcard_tv)
    public void onFormatSdClick() {
        String content = format_sdcard_tv.getText().toString();
        if (content != null && content.equals(getString(R.string.format_done))) {
            finish();
            return;
        }
        if (this.mPop == null) {
            this.mPop = CommonUtils.showDlg(this, getString(R.string.app_meari_name), this.getString(R.string.format_NVR),
                    getString(R.string.ok), positiveClick,
                    getString(R.string.cancel), negativeClick, false);
        }
        this.mPop.show();
    }

    DialogInterface.OnClickListener positiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            mFailedCount = 0;
            mCurPlayer.setdeviceparams(CameraPlayer.SET_PPS_DEVICE_FORAMT, "",
                    new CameraPlayerListener() {
                        @Override
                        public void PPSuccessHandler(String successMsg) {
                            if (mEventHandler != null) {
                                mEventHandler.sendEmptyMessage(MESSAGE_FORMAT_SUCCESS);
                            }
                        }

                        @Override
                        public void PPFailureError(String errorMsg) {
                            if (mEventHandler != null) {
                                mEventHandler.sendEmptyMessage(MESSAGE_FORMAT_FAILED);
                            }
                        }
                    });
        }
    };

    DialogInterface.OnClickListener negativeClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };

    @Override
    public void PPSuccessHandler(String successMsg) {
        if (successMsg == null || mEventHandler == null)
            return;
        mEventHandler.sendEmptyMessage(MESSAGE_LOGIN_SUCCESS);
    }


    @Override
    public void PPFailureError(String errorMsg) {
        if (mEventHandler != null) {
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
    }

    public void getSdCardInfo() {
        mCurPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_SD_INFO, new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null || successMsg == null)
                    return;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                    mStatus = jsonObject.optInt("status");
                    mCapacity = jsonObject.optInt("sd_storage");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                mEventHandler.sendEmptyMessage(MESSAGE_GET_SD_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_GET_SD_FAILED);
            }
        });
    }

    private Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_LOGIN_SUCCESS:
                    getSdCardInfo();
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
                    CommonUtils.showDlg(FormatNvrActivity.this, getString(R.string.app_meari_name),
                            getString(R.string.status_failure_try_again), getString(R.string.ok), mPositiveListener,
                            getString(R.string.cancel), mNegativeListener, false);
                    break;
                case MESSAGE_GET_SD_SUCCESS:
                    initCapacityView(mCapacity);
                    if (mStatus == 3) {
                        format_sdcard_tv.setVisibility(View.GONE);
                        mProgressbar.setVisibility(View.VISIBLE);
                        format_sdcard_tv.setVisibility(View.GONE);
                        updateHandler.postDelayed(updateThread, 0);
                        format_sdcard_tv.setEnabled(false);
                    }
                    break;
                case MESSAGE_GET_SD_FAILED:
                    initCapacityViewFailed();
                    break;
                case MESSAGE_FORMAT_SUCCESS:
                    format_sdcard_tv.setEnabled(false);
                    format_sdcard_tv.setVisibility(View.GONE);
                    mProgressbar.setVisibility(View.VISIBLE);
                    mCurPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_FORMAT_PERCENT, mUpdatePercent);
                    break;
                case MESSAGE_FORMAT_FAILED:
                    break;
                default:
                    break;
            }
        }
    };

    private void initCapacityViewFailed() {
        stopProgressDialog();
        format_sdcard_tv.setVisibility(View.GONE);
        TextView capacity_tv = (TextView) findViewById(R.id.capacity_tv);
        capacity_tv.setText(getString(R.string.fail));
        findViewById(R.id.text_warning).setVisibility(View.GONE);
        findViewById(R.id.format_sdcard_tv).setVisibility(View.GONE);
    }


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
            int MAX_FAILED = 3;
            if (mFailedCount > MAX_FAILED) {
                dealPercent(-1);
                mFailedCount++;
            } else {
                if (updateHandler != null)
                    updateHandler.postDelayed(updateThread, 1000);
            }
        }
    };

    private void dealPercent(int status) {
        Message msg = Message.obtain();
        if (status < 0) {
            if (mProgress != 0) {
                mProgress = 100;
                msg.what = 0;
                msg.obj = mProgress;
                mProgressHandler.sendMessage(msg);
            } else {
                msg.what = 0;
                msg.obj = status;
                mProgressHandler.sendMessage(msg);
            }

        } else if (status == 0) {
            if (mProgress != 0) {
                mProgress = 100;
            } else {
                updateHandler.postDelayed(updateThread, 1000);
                mProgress = 0;
            }
            msg.what = 0;
            msg.obj = mProgress;
            mProgressHandler.sendMessage(msg);
        } else {
            mProgress = status;
            msg.what = 0;
            msg.obj = mProgress;
            mProgressHandler.sendMessage(msg);
            if (mProgress != 100)
                updateHandler.postDelayed(updateThread, 1000);
        }
    }

    Handler updateHandler = new Handler();
    private int mProgress;
    Runnable updateThread = new Runnable() {
        public void run() {
            mCurPlayer.getdeviceparams(CameraPlayer.GET_PPS_DEVICE_FORMAT_PERCENT, mUpdatePercent);
        }
    };
    private Handler mProgressHandler = new Handler() {
        public void handleMessage(Message msg) {
            int what = msg.what;
            if (what == 0) {
                int desc = (int) msg.obj;
                if (desc == -1) {
                    mProgressbar.setEnabled(true);
                    if (mIsFirst) {
                        mIsFirst = false;
                        return;
                    }
                    mProgressbar.setProgress(0);
                    mProgressbar.setVisibility(View.GONE);
                    format_sdcard_tv.setVisibility(View.VISIBLE);
                    format_sdcard_tv.setEnabled(true);
                    CommonUtils.showToast(getString(R.string.fail));
                    return;
                } else if (desc == 100) {
                    format_sdcard_tv.setEnabled(true);
                    format_sdcard_tv.setVisibility(View.VISIBLE);
                    mProgressbar.setVisibility(View.GONE);
                    format_sdcard_tv.setText(getString(R.string.format_done));
                    CommonUtils.showToast(getString(R.string.format_done));
                    return;
                }
                mProgressbar.setProgress(desc);
                format_sdcard_tv.setEnabled(false);
            }
        }
    };


    @Override
    public void finish() {
        super.finish();
        mEventHandler = null;
        mProgressHandler.removeMessages(0);
        if (mCurPlayer != null) {
            mCurPlayer.disconnectIPC(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {

                }

                @Override
                public void PPFailureError(String errorMsg) {

                }
            });
        }
    }

    private void initCapacityView(int status) {
        stopProgressDialog();
        format_sdcard_tv.setVisibility(View.VISIBLE);
        TextView capacity_tv = (TextView) findViewById(R.id.capacity_tv);
        if (status >= 1024) {
            float capacity = status;
            capacity = capacity / 1024;
            DecimalFormat df = new DecimalFormat("0.0");
            String capacityString = df.format(capacity);
            capacityString += "G";
            capacity_tv.setText(capacityString);
        } else {
            String capacityString = status + "M";
            capacity_tv.setText(capacityString);
        }
        if (status == 0 || status == -1) {
            capacity_tv.setText(getString(R.string.no_hard_disk));
            findViewById(R.id.text_warning).setVisibility(View.GONE);
            findViewById(R.id.format_sdcard_tv).setVisibility(View.GONE);
        }
    }

    public DialogInterface.OnClickListener mPositiveListener = new DialogInterface.OnClickListener() {

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
}

