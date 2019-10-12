package com.meari.test;

import android.content.DialogInterface;
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
import com.meari.test.common.StringConstants;
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

public class PIRActivity extends BaseActivity {
    private CameraInfo mCameraInfo;
    private CameraPlayer mCameraPlayer;
    private Animation mShowViewAnimation;//列表展开动画
    private Animation mHideAnimation;//列表收起动画
    private static final String TAG = "PIRActivity";
    private MotionAdapter mMotionRateAdapter;
    private ArrayList<ArmingInfo> mDevAlarmList;
    private ArmingInfo mMotion;
    @BindView(R.id.switch_pir)
    public SwitchButton mSwitch_pir;
    @BindView(R.id.pir_rl)
    public RecyclerView mRecyclerView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_pir);
        initData();
        if (mShowViewAnimation == null) {
            mShowViewAnimation = AnimationUtils.loadAnimation(this, R.anim.push_up_in);
        }
        if (mHideAnimation == null) {
            mHideAnimation = AnimationUtils.loadAnimation(this, R.anim.push_up_out);
            //开启动画
            mHideAnimation.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {

                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    findViewById(R.id.layout_pir_ll).setVisibility(View.GONE);
                }

                @Override
                public void onAnimationRepeat(Animation animation) {

                }
            });

        }
        initView();
    }

    private void initView() {
        this.mCenter.setText(getString(R.string.motion_etection));
        mBackBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent it = new Intent();
                if (mMotion.cfg.enable == 0)
                    it.putExtra("level", 0);
                else
                    it.putExtra("level", mMotion.cfg.sensitivity);
                setResult(RESULT_OK, it);
                finish();
            }
        });
        mMotionRateAdapter = new MotionAdapter(this, mMotion);
        mRecyclerView.setAdapter(mMotionRateAdapter);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        mMotionRateAdapter.setNewData(mDevAlarmList);
        mMotionRateAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<ArmingInfo>() {
            @Override
            public void onItemClick(BaseQuickAdapter<ArmingInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                ArmingInfo info = mMotionRateAdapter.getItem(position);
                setPirSensitivity(info);
            }
        });
        mRecyclerView.getItemAnimator().setChangeDuration(300);
        mRecyclerView.getItemAnimator().setMoveDuration(300);
        mRecyclerView.getItemAnimator().setRemoveDuration(300);
        //
        mSwitch_pir.setEnabled(false);
        if (mMotion.cfg.enable == 0) {
            mSwitch_pir.setChecked(false);
            showMotionView(false);
        } else {
            mSwitch_pir.setChecked(true);
            showMotionView(true);
        }
        mSwitch_pir.setEnabled(true);
        mSwitch_pir.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!buttonView.isEnabled()) {
                    return;
                }
                startProgressDialog();
                if (getProgressDialog() != null) {
                    getProgressDialog().setOnCancelListener(new DialogInterface.OnCancelListener() {
                        @Override
                        public void onCancel(DialogInterface dialog) {
                            finish();
                        }
                    });
                }
                setArming(isChecked);
            }
        });
    }

    public void setArming(final boolean bEnable) {
        startProgressDialog();
        if (getProgressDialog() != null) {
            getProgressDialog().setOnCancelListener(new DialogInterface.OnCancelListener() {
                @Override
                public void onCancel(DialogInterface dialog) {
                    finish();
                }
            });
        }
        BaseJSONObject json = new BaseJSONObject();
        BaseJSONObject pirJson = new BaseJSONObject();
        BaseJSONObject tmpJson = new BaseJSONObject();
        tmpJson.put("enable", bEnable ? 1 : 0);
        tmpJson.put("level", mMotion.cfg.sensitivity);
        pirJson.put("pir", tmpJson);
        json.put("action", "POST");
        json.put("deviceurl", "http://127.0.0.1/devices/settings");
        json.put("bell", pirJson);
        CommonUtils.getSdkUtil().commondeviceparams2(json.toString(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null)
                    return;
                Message msg = Message.obtain();
                msg.what = MESSAGE_SETTING_PIR_SUCCESS;
                msg.obj = bEnable;
                mEventHandler.sendMessage(msg);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_SETTING_PIR_FAILED);
            }
        });
    }

    private void initData() {
        //获取基本设备数据
        mCameraInfo = (CameraInfo) getIntent().getExtras().getSerializable(StringConstants.CAMERA_INFO);
        mMotion = (ArmingInfo) getIntent().getExtras().getSerializable(StringConstants.MOTION);
        //获取通用cameraplayer
        mCameraPlayer = CommonUtils.getSdkUtil();
        initArmList();

    }

    /**
     * @param bShow true shoe false hide
     */
    //显示或隐藏列表
    public void showMotionView(boolean bShow) {
        if (bShow) {
            findViewById(R.id.layout_pir_ll).setVisibility(View.VISIBLE);
            findViewById(R.id.layout_pir_ll).startAnimation(mShowViewAnimation);

        } else {
            findViewById(R.id.layout_pir_ll).startAnimation(mHideAnimation);
        }
    }

    //开启关闭PIR
    private void initArmList() {
        int[] pirValues = getResources().getIntArray(R.array.pir_value);
        String[] mMotionList = getResources().getStringArray(R.array.miror_action);
        mDevAlarmList = new ArrayList<>();
        for (int i = 0; i < pirValues.length; i++) {
            ArmingInfo info = new ArmingInfo();
            PpsdevAlarmCfg cfg = new PpsdevAlarmCfg();
            cfg.sensitivity = pirValues[i];
            cfg.enable = 1;
            cfg.alarmtype = 1;
            info.cfg = cfg;
            info.desc = mMotionList[i];
            mDevAlarmList.add(info);
        }
    }

    //设置PIR灵敏度
    public void setPirSensitivity(final ArmingInfo armingInfo) {
        startProgressDialog();
        BaseJSONObject json = new BaseJSONObject();
        BaseJSONObject pirJson = new BaseJSONObject();
        BaseJSONObject tmpJson = new BaseJSONObject();
        tmpJson.put("enable", armingInfo.cfg.enable);
        tmpJson.put("level", armingInfo.cfg.sensitivity);
        pirJson.put("pir", tmpJson);
        json.put("action", "POST");
        json.put("deviceurl", "http://127.0.0.1/devices/settings");
        json.put("bell", pirJson);
        mCameraPlayer.commondeviceparams2(json.toString(), new CameraPlayerListener() {
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null)
                    return;
                Message msg = Message.obtain();
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

    private final int MESSAGE_SETTING_PIR_SUCCESS = 1001; //
    private final int MESSAGE_SETTING_PIR_FAILED = 1002;
    private final int MESSAGE_SETTING_SENSITIVITY_SUCCESS = 1003;
    private final int MESSAGE_SETTING_SENSITIVITY_FAILED = 1004;
    private Handler mEventHandler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            switch (msg.what) {
                case MESSAGE_SETTING_PIR_SUCCESS:
                    stopProgressDialog();
                    boolean bEnable = (boolean) msg.obj;
                    mSwitch_pir.setEnabled(false);
                    CommonUtils.showToast(R.string.setting_successfully);
                    mSwitch_pir.setChecked(bEnable);
                    mMotion.cfg.enable = bEnable ? 1 : 0;
                    mSwitch_pir.setEnabled(true);
                    mMotionRateAdapter.setArmingInfo(mMotion);
                    mMotionRateAdapter.notifyDataSetChanged();
                    showMotionView(bEnable);
                    break;
                case MESSAGE_SETTING_PIR_FAILED:
                    stopProgressDialog();
                    CommonUtils.showToast(R.string.setting_failded);
                    mSwitch_pir.setEnabled(false);
                    mSwitch_pir.setChecked(mMotion.cfg.enable == 0 ? false : true);
                    mSwitch_pir.setEnabled(true);
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
                    return false;

            }
            return false;
        }
    });

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
