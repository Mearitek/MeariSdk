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

import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
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
 * 创建日期：2017/5/5
 * 描    述：格式化IPC存储卡
 * 修订历史：
 * ================================================
 */

public class FormatSDActivity extends BaseActivity {
    private Dialog mPop;

    private final int MESSAGE_GET_SD_SUCCESS = 1000;
    private final int MESSAGE_FORMAT_SUCCESS = 1002;
    private final int MESSAGE_FORMAT_FAILED = 1003;
    private int mCapacity;
    @BindView(R.id.update_text)
    public TextView mFormatBtn;
    @BindView(R.id.update_progress)
    public RoundProgressBar mProgressBar;
    private int mFailedCount = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_formatsd);
        startProgressDialog();
        initView();
        getSdCardInfo();
    }

    private void initCapacityView(int status) {
        stopProgressDialog();
        TextView capacity_tv =  findViewById(R.id.capacity_tv);
        if (status >= 1024) {
            float capacity = status;
            capacity = capacity / 1024;
            DecimalFormat df = new DecimalFormat("0.00");
            String capacityString = df.format(capacity);
            capacityString += "G";
            capacity_tv.setText(capacityString);
        } else {
            String capacityString = status + "M";
            capacity_tv.setText(capacityString);
        }
        if (status == 0 || status == -1) {
            capacity_tv.setText(getString(R.string.no_sdcard));
            findViewById(R.id.text_warning).setVisibility(View.GONE);
            mFormatBtn.setVisibility(View.GONE);
        }
        if (status > 0) {
            mFormatBtn.setVisibility(View.VISIBLE);
        }
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(R.string.format_card_title);
    }


    @OnClick(R.id.update_text)
    public void onFormatSdClick() {
        String content = mFormatBtn.getText().toString();
        if (content != null && content.equals(getString(R.string.format_done))) {
            finish();
            return;
        }
        if (this.mPop == null) {
            this.mPop = CommonUtils.showDlg(this, getString(R.string.app_meari_name), this.getString(R.string.format_card),
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
            CommonUtils.getSdkUtil().setdeviceparams(CameraPlayer.SET_PPS_DEVICE_FORAMT, "",
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
    public Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_GET_SD_SUCCESS:
                    initCapacityView(mCapacity);
                    break;
                case MESSAGE_FORMAT_SUCCESS:
                    mFormatBtn.setEnabled(false);
                    mFormatBtn.setVisibility(View.GONE);
                    mProgressBar.setVisibility(View.VISIBLE);
                    CommonUtils.getSdkUtil().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_FORMAT_PERCENT, mUpdatePercent);
                    break;
                case MESSAGE_FORMAT_FAILED:
                    break;
            }
        }
    };

    public void getSdCardInfo() {
        CommonUtils.getSdkUtil().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_SD_INFO, new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null || successMsg == null)
                    return;
                try {
                    BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
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
                mEventHandler.sendEmptyMessage(MESSAGE_GET_SD_SUCCESS);
            }
        });
    }

    Handler updateHandler = new Handler();
    private int mProgress;
    Runnable updateThread = new Runnable() {
        public void run() {
            CommonUtils.getSdkUtil().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_FORMAT_PERCENT, mUpdatePercent);
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

    private Handler mProgressHandler = new Handler() {
        public void handleMessage(Message msg) {
            int what = msg.what;
            if (what == 0) {
                int desc = (int) msg.obj;
                if (desc < 0) {
                    mProgressBar.setProgress(0);
                    mProgressBar.setVisibility(View.GONE);
                    mFormatBtn.setEnabled(true);
                    mFormatBtn.setVisibility(View.VISIBLE);
                    CommonUtils.showToast(getString(R.string.format_card_failed));
                    return;
                } else if (desc == 100) {
                    mFormatBtn.setEnabled(true);
                    mFormatBtn.setVisibility(View.VISIBLE);
                    mFormatBtn.setText(getString(R.string.format_done));
                    mProgressBar.setVisibility(View.GONE);
                    CommonUtils.showToast(getString(R.string.format_done));
                } else
                    mProgressBar.setProgress(desc);
                mFormatBtn.setText(getString(R.string.format_done));
            }
        }
    };

    public void finish() {
        super.finish();
        mEventHandler = null;
    }
}

