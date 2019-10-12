package com.meari.test;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/5
 * 描    述：
 * 修订历史：
 * ================================================
 */

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.SleepMethmodInfo;
import com.meari.sdk.common.CameraSleepType;
import com.meari.sdk.utils.JsonUtil;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.adapter.SleepModeAdapter;
import com.meari.sdk.bean.SleepTimeInfo;
import com.meari.test.common.ActivityType;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by Administrator on 2017/3/16.
 */

public class SleepModeMethodActivity extends BaseActivity implements SleepModeAdapter.ActionCallback {
    private static final int MESSAGE_SUCCESS = 10001;
    private static final int MESSAGE_FAILED = 10002;
    private static final int MESSAGE_SETTING_SUCCESS = 10003;
    private static final int MESSAGE_SETTING_FAILED = 10004;
    private CameraInfo mCameraInfo;
    private CameraPlayer mCameraPlayer;
    private String sleep_mode;
    private ArrayList<SleepTimeInfo> mTimeInfos;
    @BindView(R.id.sleep_mode_recycler)
    public RecyclerView mRecyclerView;
    private SleepModeAdapter mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sleep_methmod);
        initData();
        initView();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.home_title));
        this.mRightText.setText(getString(R.string.edit_status));
        this.mRightText.setTag(0);
        this.action_bar_rl.setVisibility(View.VISIBLE);
        initRecyclerView();
        startProgressDialog();
    }

    public void initRecyclerView() {
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mRecyclerView.setLayoutManager(linearLayoutManager);
    }

    private void initData() {
        mCameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        mAdapter = new SleepModeAdapter(this, this);
        mCameraPlayer = CommonUtils.getSdkUtil();
        getSleepModeData();
        startProgressDialog();
    }

    @OnClick(R.id.right_text)
    public void onRightClick() {
        int tag = (int) this.mRightText.getTag();
        if (tag == 0) {
            this.mRightText.setTag(1);
            this.mRightText.setText(getString(R.string.done));
            this.mAdapter.setEditStatus(true);
            this.mAdapter.notifyDataSetChanged();
        } else {
            this.mRightText.setTag(0);
            this.mRightText.setText(getString(R.string.edit_status));
            this.mAdapter.setEditStatus(false);
            this.mAdapter.notifyDataSetChanged();
        }
    }

    public void getSleepModeData() {
        if (mCameraPlayer != null) {

            mCameraPlayer.getDeviceSettingParams( new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    stopProgressDialog();
                    try {
                        BaseJSONObject jsonobject = new BaseJSONObject(successMsg);
                        sleep_mode = jsonobject.optString("sleep", "off");
                        initSleepModeView();
                        if (jsonobject.has("sleep_time")) {
                            BaseJSONArray jsonArray = jsonobject.optBaseJSONArray("sleep_time");
                            mTimeInfos = JsonUtil.getSleepTimeInfos(jsonArray);
                        }
                        mEventHandler.sendEmptyMessage(MESSAGE_SUCCESS);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        mEventHandler.sendEmptyMessage(MESSAGE_FAILED);
                    }

                }

                @Override
                public void PPFailureError(String errorMsg) {
                    stopProgressDialog();
                    mEventHandler.sendEmptyMessage(MESSAGE_FAILED);
                }
            });
        }
    }

    private void initSleepModeView() {
        ArrayList<SleepMethmodInfo> infos = new ArrayList<>();
        for (int i = 0; i < 3; i++) {
            SleepMethmodInfo info = new SleepMethmodInfo();
            switch (i) {
                case 0:
                    info.setName(getString(R.string.alway_on));
                    info.setType("off");
                    break;
                case 1:
                    info.setName(getString(R.string.alway_off));
                    info.setType("on");
                    break;
                case 2:
                    info.setName(getString(R.string.alway_time));
                    info.setType(CameraSleepType.SLEEP_TIME);
                    info.setDesc(getString(R.string.warning_slot));
                    break;
            }
            infos.add(info);
        }
        mAdapter.setSleepMode(sleep_mode);
        mAdapter.setSleepMethmodInfos(infos);
        return;
    }

    public Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_SUCCESS:
                    mRightText.setVisibility(View.VISIBLE);
                    mRecyclerView.setAdapter(mAdapter);
                    break;
                case MESSAGE_FAILED:
                    showDialog();
                    break;
                case MESSAGE_SETTING_SUCCESS:
                    mAdapter.notifyDataSetChanged();
                    break;
                default:
                    break;
            }
        }
    };

    public void showDialog() {
        CommonUtils.showDialog(this, getString(R.string.get_data_failed), positiveClick, false);
    }

    public DialogInterface.OnClickListener positiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            finish();
        }
    };

    /**
     * @param position
     * @param isEditStatus
     */
    @Override
    public void onChangeType(int position, boolean isEditStatus) {
        final SleepMethmodInfo info = mAdapter.getSleepMethmodInfos().get(position);
        if (isEditStatus) {
            if (info.getType().equals(CameraSleepType.SLEEP_TIME)) {
                Intent intent = new Intent();
                intent.setClass(this, HomeModelActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable("cameraInfo", mCameraInfo);
                if (this.mTimeInfos != null && mTimeInfos.size() > 0) {
                    bundle.putInt("type", 0);
                }
                intent.putExtras(bundle);
                startActivityForResult(intent, ActivityType.ACTIVITY_HOMEMODE);
            }
        } else {
            if (info.getType().equals(CameraSleepType.SLEEP_TIME) && (mTimeInfos == null || mTimeInfos.size() == 0)) {
                CommonUtils.showDlg(this, getString(R.string.time_close), getString(R.string.no_timw_setiting),
                        getString(R.string.go_setting), mTimePositive,
                        getString(R.string.cancel), negativeClick, false);
                return;
            }
            if (mCameraPlayer != null) {
                startProgressDialog();
                mCameraPlayer.setCameraSleepType(info.getType(), new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        stopProgressDialog();
                        mAdapter.setSleepMode(info.getType());
                        mEventHandler.sendEmptyMessage(MESSAGE_SETTING_SUCCESS);
                        mCameraInfo.setSleep(info.getType());
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        stopProgressDialog();
                        mEventHandler.sendEmptyMessage(MESSAGE_SETTING_FAILED);
                    }
                });
            }
        }
    }

    public DialogInterface.OnClickListener negativeClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };
    public DialogInterface.OnClickListener mTimePositive = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            Intent intent = new Intent();
            intent.setClass(SleepModeMethodActivity.this, HomeModelActivity.class);
            Bundle bundle = new Bundle();
            bundle.putSerializable("cameraInfo", mCameraInfo);
            bundle.putInt("type", 1);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_HOMEMODE);
            dialog.dismiss();
        }
    };
    public DialogInterface.OnClickListener mGeographyPositive = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
//            Intent sleepIntent = new Intent();
//            sleepIntent.setClass(SleepModeMethodActivity.this, SleepLocationActivity.class);
//            Bundle sleepBundle = new Bundle();
//            sleepBundle.putSerializable("cameraInfo", mCameraInfo);
//            sleepBundle.putInt("type",1);
//            sleepIntent.putExtras(sleepBundle);
//            startActivityForResult(sleepIntent, ActivityType.ACTICITY_LOCARION);
//            dialog.dismiss();
        }
    };

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_HOMEMODE:
                if (data == null)
                    return;
                Bundle HomeBundle = data.getExtras();
                if (HomeBundle != null) {
                    mTimeInfos = (ArrayList<SleepTimeInfo>) HomeBundle.getSerializable("HomeTimeInfos");
                    CameraInfo cameraInfo = (CameraInfo) HomeBundle.getSerializable("cameraInfo");
                    sleep_mode = cameraInfo.getSleep();
                    mCameraInfo.setSleep(sleep_mode);
                    mAdapter.setSleepMode(sleep_mode);
                    mAdapter.notifyDataSetChanged();
                }
                break;
            default:
                break;
        }
    }

    @Override
    public void finish() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", mCameraInfo);
        bundle.putString("sleepMethmod", mAdapter.getType());
        intent.putExtras(bundle);
        setResult(RESULT_OK, intent);
        super.finish();
    }
}
