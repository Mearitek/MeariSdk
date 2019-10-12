package com.meari.test;


import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.CompoundButton;

import com.meari.sdk.bean.ArmingInfo;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.adapter.MotionAdapter;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.widget.SwitchButton;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;
import com.ppstrong.ppsplayer.PpsdevAlarmCfg;

import java.util.ArrayList;

import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/5
 * 描    述：设置移动侦测等级
 * 修订历史：
 * ================================================
 */
public class MotionActivity extends BaseActivity {
    @BindView(R.id.frameRateList)
    public RecyclerView mRecyclerView;
    @BindView(R.id.mirror_switchchk)
    public SwitchButton mSwitchChk;
    private ArmingInfo mMotion;
    private MotionAdapter mMotionRateAdapter;
    private ArrayList<ArmingInfo> mDevAlarmList;
    private final int MESSAGE_SETTING_ARMING_SUCCESS = 1001;
    private final int MESSAGE_SETTING_ARMING_FAILED = 1002;
    private final int MESSAGE_SETTING_SENSITIVITY_SUCCESS = 1003;
    private final int MESSAGE_SETTING_SENSITIVITY_FAILED = 1004;
    private Animation mShowSleepModeViewAnimation;
    private Animation mHideSleepModeViewAnimation;
    private CameraInfo mCameraInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_motion);
        Intent intent = getIntent();
        Bundle bundle = intent.getExtras();
        mMotion = (ArmingInfo) bundle.getSerializable("motion");
        mCameraInfo = (CameraInfo) bundle.getSerializable("cameraInfo");
        if (mShowSleepModeViewAnimation == null) {
            mShowSleepModeViewAnimation = AnimationUtils.loadAnimation(this, R.anim.push_up_in);
        }
        if (mHideSleepModeViewAnimation == null) {
            mHideSleepModeViewAnimation = AnimationUtils.loadAnimation(this, R.anim.push_up_out);
            //开启动画
            mHideSleepModeViewAnimation.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {

                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    findViewById(R.id.layout_action_list).setVisibility(View.GONE);
                }

                @Override
                public void onAnimationRepeat(Animation animation) {

                }
            });

        }
        getTopTitleView();
        initArmList();
        this.mCenter.setText(getString(R.string.motion_etection));
        initView();
    }

    private void initView() {
        mMotionRateAdapter = new MotionAdapter(this, mMotion);
        mRecyclerView.setAdapter(mMotionRateAdapter);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        mMotionRateAdapter.setNewData(mDevAlarmList);
        mMotionRateAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<ArmingInfo>() {
            @Override
            public void onItemClick(BaseQuickAdapter<ArmingInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                ArmingInfo info = mMotionRateAdapter.getItem(position);
                setArmingSensitivity(info);
            }
        });
        mRecyclerView.getItemAnimator().setChangeDuration(300);
        mRecyclerView.getItemAnimator().setMoveDuration(300);
        mRecyclerView.getItemAnimator().setRemoveDuration(300);
        mSwitchChk.setEnabled(false);
        if (mMotion.cfg.enable == 0) {
            mSwitchChk.setChecked(false);
            showMotionView(false);
        } else {
            mSwitchChk.setChecked(true);
            showMotionView(true);
        }
        mSwitchChk.setEnabled(true);
        mSwitchChk.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!buttonView.isEnabled()) {
                    return;
                }
                startProgressDialog();
                setArming(isChecked);
            }
        });
    }

    private void initArmList() {
        int[] mMotionListValue = getResources().getIntArray(R.array.miror_action_value);
        String[] mMotionList = getResources().getStringArray(R.array.miror_action);
        mDevAlarmList = new ArrayList<>();
        for (int i = 0; i < mMotionListValue.length; i++) {
            ArmingInfo info = new ArmingInfo();
            PpsdevAlarmCfg cfg = new PpsdevAlarmCfg();
            cfg.sensitivity = mMotionListValue[i];
            cfg.enable = 1;
            cfg.alarmtype = 1;
            info.cfg = cfg;
            info.desc = mMotionList[i];
            mDevAlarmList.add(info);
        }
    }



    public void showMotionView(boolean bshow) {
        if (bshow) {
            findViewById(R.id.layout_action_list).setVisibility(View.VISIBLE);
            findViewById(R.id.layout_action_list).startAnimation(mShowSleepModeViewAnimation);

        } else {
            findViewById(R.id.layout_action_list).startAnimation(mHideSleepModeViewAnimation);
        }
    }

    public void setArmingSensitivity(final ArmingInfo armingInfo) {
        startProgressDialog();
        BaseJSONObject json = new BaseJSONObject();
        json.put("enable", armingInfo.cfg.enable);
        json.put("alarmtype", armingInfo.cfg.alarmtype);
        json.put("sensitivity", armingInfo.cfg.sensitivity);
        CommonUtils.getSdkUtil().setdeviceparams(CameraPlayer.SET_PPS_DEVICE_ALARM, json.toString(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null)
                    return;
                Message msg = new Message();
                msg.what = MESSAGE_SETTING_SENSITIVITY_SUCCESS;
                msg.obj = armingInfo;
                mEventHandler.sendMessage(msg);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_SETTING_SENSITIVITY_FAILED);
            }
        });
    }

    public void setArming(final boolean bEnable) {
        startProgressDialog();
        BaseJSONObject json = new BaseJSONObject();
        json.put("enable", bEnable ? 1 : 0);
        json.put("alarmtype", mMotion.cfg.alarmtype);
        json.put("sensitivity", mMotion.cfg.sensitivity);
        CommonUtils.getSdkUtil().setdeviceparams(CameraPlayer.SET_PPS_DEVICE_ALARM, json.toString(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null)
                    return;
                Message msg = new Message();
                msg.what = MESSAGE_SETTING_ARMING_SUCCESS;
                msg.obj = bEnable;
                mEventHandler.sendMessage(msg);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_SETTING_ARMING_FAILED);
            }
        });
    }

    private Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_SETTING_ARMING_SUCCESS:
                    stopProgressDialog();
                    boolean bEnable = (boolean) msg.obj;
                    mSwitchChk.setEnabled(false);
                    CommonUtils.showToast(R.string.setting_successfully);
                    mSwitchChk.setChecked(bEnable);
                    mMotion.cfg.enable = bEnable ? 1 : 0;
                    mSwitchChk.setEnabled(true);
                    mMotionRateAdapter.setArmingInfo(mMotion);
                    mMotionRateAdapter.notifyDataSetChanged();
                    showMotionView(bEnable);
                    break;
                case MESSAGE_SETTING_ARMING_FAILED:
                    stopProgressDialog();
                    CommonUtils.showToast(R.string.setting_failded);
                    mSwitchChk.setEnabled(false);
                    mSwitchChk.setChecked(mMotion.cfg.enable == 0 ? false : true);
                    mSwitchChk.setEnabled(true);
                    break;
                case MESSAGE_SETTING_SENSITIVITY_SUCCESS:
                    stopProgressDialog();
                    ArmingInfo armingInfo = (ArmingInfo) msg.obj;
                    mMotion.cfg.sensitivity = armingInfo.cfg.sensitivity;
                    CommonUtils.showToast(R.string.setting_successfully);
                    mMotionRateAdapter.setArmingInfo(mMotion);
                    mMotionRateAdapter.notifyDataSetChanged();
                    break;
                case MESSAGE_SETTING_SENSITIVITY_FAILED:
                    stopProgressDialog();
                    CommonUtils.showToast(R.string.setting_failded);
                    mMotionRateAdapter.setArmingInfo(mMotion);
                    mMotionRateAdapter.notifyDataSetChanged();
                    break;
                default:
                    return;

            }
        }
    };

    @Override
    public void finish() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putSerializable("motion", mMotion);
        intent.putExtras(bundle);
        setResult(RESULT_OK, intent);
        super.finish();
    }

}
