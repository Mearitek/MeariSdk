package com.meari.test.fragment;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.RequiresApi;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.ArmingInfo;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.CameraSdCardInfo;
import com.meari.sdk.bean.SleepMethmodInfo;
import com.meari.sdk.bean.SleepTimeInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.common.CameraSleepType;
import com.meari.sdk.utils.JsonUtil;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.HomeModelActivity;
import com.meari.test.MusicPlayActivity;
import com.meari.test.R;
import com.meari.test.ShareDeviceActivity;
import com.meari.test.SingleVideoActivity;
import com.meari.test.adapter.PreviewSleepModeAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Constant;
import com.meari.test.common.VideoPlayCallback;
import com.meari.test.permission_utils.Func;
import com.meari.test.permission_utils.PermissionUtil;
import com.meari.test.photoview.gestures.OnGestureListener;
import com.meari.test.runnable.MoveHandler;
import com.meari.test.runnable.MoveRunnable;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.FileUtil;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.CustomDialog;
import com.meari.test.widget.LoadingView;
import com.meari.test.widget.ScaleHumidityView;
import com.meari.test.widget.ScaleTemperatureView;
import com.meari.test.widget.SpeechDialog;
import com.ppstrong.listener.StorageStatusListener;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;
import com.ppstrong.ppsplayer.CameraPlayerRecordMp4Listener;
import com.ppstrong.ppsplayer.CameraPlayerRecordVolumeListener;
import com.ppstrong.ppsplayer.CameraPlayerVideoStopListener;
import com.ppstrong.ppsplayer.PPSGLSurfaceView;
import com.ppstrong.ppsplayer.PpsdevAlarmCfg;
import com.ppstrong.ppsplayer.UtilRecord;

import org.json.JSONException;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import static android.view.MotionEvent.ACTION_CANCEL;
import static android.view.MotionEvent.ACTION_DOWN;
import static android.view.MotionEvent.ACTION_UP;
import static android.view.View.GONE;
import static android.view.View.OnClickListener;
import static android.view.View.OnTouchListener;
import static android.view.View.VISIBLE;

/*
* 文件名：BabyMonitorPreviewFragment
* 描    述：实现预览婴儿监护器
* 作    者：廖金华
* 时    间：2017-3-3
* 版    权：杭州卓壮科技有限公司
*/
public class BabyMonitorPreviewFragment extends VideoFragment implements PreviewSleepModeAdapter.SleepTypeInterface, OnClickListener {
    private static final int MESSAGE_NO_FIND_MIC = 1016;
    private final int MESSAGE_PLAY_SUCCESS = 1001;
    private final int MESSAGE_PLAY_FAILED = 1002;
    private final int MESSAGE_PLAY_STOP = 1003;
    private final int MESSAGE_SNAP_SUCCESS = 1004;
    private final int MESSAGE_TALK_SUCCESS = 1005;
    private final int MESSAGE_TALK_FAILED = 1006;
    private final int MESSAGE_RECORD_SAVE_SUCCESS = 1007;
    private final int MESSAGE_RECORD_SAVE_FAILED = 1008;
    private final int MESSAGE_RECORD_FAILED = 1009;
    private final int MESSAGE_RECORD_VIDEO_START = 1010;
    private final int MESSAGE_MODE_INIT = 1011;
    private final int MESSAGE_ARAM_INIT = 1012;
    private final int MESSAGE_SET_VOLUME = 1013;
    private final int MESSAGE_CHAGE_PLAY_SUCCESS = 1014;
    private final int MESSAGE_CHAGE_PLAY_FAILED = 1015;
    private final int MESSAGE_SLEEP = 1018;
    private final int MESSAGE_SLEEP_STOP = 1021;
    private final int MESSAGE_TEM_HUMI_REFRSH = 1019;
    private final int MESSAGE_SETTING_SLEEP_FAILED = 1020;
    private final int MESSAGE_SETTING_SLEEP_SUCCESS = 1022;
    private final int MESSAGE_SNAP_FAILED = 1023;
    private final int MESSAGE_PLAYING = 1024;
    private final int MESSAGE_STOP_SUCCESS = 1027;
    private float downX;                                    // 按下时的x 坐标
    private float downY;                                    // 按下时的y 坐标
    private View mView;//fragment 视图
    private PPSGLSurfaceView mVideoView;
    private boolean mIsBackground;
    /**
     * set model
     */
    private LoadingView mLoadingView;
    private View mFreshBtn;
    private View mVideoViewLayout;
    private SharedPreferences mVideoTypePreferences;
    private String mVideoType;
    private CameraInfo mCameraInfo;
    private ImageView mRecordVoiceImg;
    private ImageView mRecordVideoImg;
    private ImageView mVoiceImg;
    private ImageView mRecordVoiceImg_L;
    private ImageView mRecordVideoImg_L;
    private ImageView mVoiceImg_L;
    private ImageView mPlayBtn;
    private ImageView mPlayBtn_L;
    private SpeechDialog mSpeechDialog;
    private String mRecordPath;
    private AlphaAnimation mAnimation;
    private View mView_REC;
    private ScaleGestureDetector mScaleGestureDetector;
    private GestureDetector mMoveGestureDetector;
    private UtilRecord mRecord;
    private MoveHandler moveHandler;
    private View mHorToolsBar;
    private View mVideoTypeTools;
    private TextView mVideoType_L;
    private boolean mBsnop = false;
    private boolean mfinish = false;
    private int[] mMotionListValue;
    private String[] mMotionList;
    private float mScale = 1.0f;                                 // 缩放倍数
    private LinearLayout mVideoLayout;
    final private int REQUEST_CODE_ASK_PERMISSIONS = 121;//权限请求码
    public static final String RECORD_AUDIO = android.Manifest.permission.RECORD_AUDIO;
    private PermissionUtil.PermissionRequestObject mRecordPermissionRequest;
    private int MODE = -1;
    public ScaleTemperatureView mScaleTemperatureView;
    public ScaleHumidityView mScaleHumidityView;
    public Animation mShowPlayViewAnimation;
    public Animation mHidePlayViewAnimation;
    private RecyclerView mRecyclerView;
    private ArrayList<SleepTimeInfo> mTimeInfos;
    private ArrayList<SleepMethmodInfo> mSleepModes = new ArrayList<>();
    private PreviewSleepModeAdapter mSleepAdapter;
    private CustomDialog mTimeDlg;
    private CustomDialog mGeographyDlg;
    private UserInfo mUserInfo;
    private PopupWindow mPopupWindow;

    //from PuLan:UI整改添加
    TextView tv_mode_land;//横屏时切换清晰度
    RelativeLayout rl_mode;//三种码流模式选择
    Button btn_auto, btn_sd, btn_hd;//三种码流模式按钮
    RelativeLayout rl_tool;//竖屏状态下的操作条
    TextView tv_mode;//竖屏状态下的切换清晰度
    ImageView iv_full;//竖屏状态下的全屏按钮
    ImageView iv_full_L;//横屏状态下的全屏按钮
    TextView btn_share;//分享按钮

    /**
     * @param cameraInfo
     * @return
     */
    public static BabyMonitorPreviewFragment newInstance(CameraInfo cameraInfo) {
        BabyMonitorPreviewFragment fragment = new BabyMonitorPreviewFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", cameraInfo);
        fragment.setArguments(bundle);
        return fragment;
    }

    /**
     * @param videoViewCallback
     */
    public void setVideoViewCallback(VideoPlayCallback videoViewCallback) {
        this.mVideoPlayCallback = videoViewCallback;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        mView = inflater.inflate(R.layout.fragment_baby_moniter, container, false);
        initData();
        initView(mView);
        return mView;
    }

    /**
     * init data
     * init video type(sd or hd)
     */
    private void initData() {
        if (getActivity() != null) {
            this.mVideoTypePreferences = getActivity().getSharedPreferences("videoType_Preference", Context.MODE_PRIVATE);
        }
        if (mVideoPlayCallback == null) {
            getActivity().finish();
            return;
        }
        if (mVideoType == null) {
            initControlGestures();
            if (mVideoTypePreferences != null)
                mVideoType = mVideoTypePreferences.getString("videoType", "HD");
            else
                mVideoType = "HD";
        }
        initArmList();
        int w = Constant.width;
        this.mCameraInfo = (CameraInfo) getArguments().getSerializable("cameraInfo");
        if (mShowPlayViewAnimation == null) {
            mShowPlayViewAnimation = AnimationUtils.loadAnimation(getActivity(), R.anim.play_top_in);
        }
        if (mHidePlayViewAnimation == null) {
            mHidePlayViewAnimation = AnimationUtils.loadAnimation(getActivity(), R.anim.play_top_out);
            //开启动画
            mHidePlayViewAnimation.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {

                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    mView.findViewById(R.id.layout_play).setVisibility(GONE);
                }

                @Override
                public void onAnimationRepeat(Animation animation) {

                }
            });

        }
        this.mUserInfo = MeariUser.getInstance().getUserInfo();
        initSleepModeData();
        initControlGestures();
    }

    public void initRecyclerView() {
        this.mRecyclerView = new RecyclerView(getActivity());
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mRecyclerView.setLayoutManager(linearLayoutManager);
        this.mSleepAdapter = new PreviewSleepModeAdapter(getActivity(), this);
        mRecyclerView.setAdapter(mSleepAdapter);
        mRecyclerView.setBackgroundResource(R.drawable.shape_big_common_white_n);
        mPopupWindow = new PopupWindow(mRecyclerView, Constant.width / 3, ViewGroup.LayoutParams.WRAP_CONTENT);
        mPopupWindow.setFocusable(true); //这里很重要，设置该popupWindow可以获取焦点，不然无法响应点击事件
        mPopupWindow.setBackgroundDrawable(new BitmapDrawable());
        mPopupWindow.setOutsideTouchable(true);
    }

    private void initSleepModeData() {

        for (int i = 0; i < 4; i++) {
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
                    info.setType("time");
                    info.setDesc(getString(R.string.warning_slot));
                    break;
                case 3:
                    info.setName("--");
                    info.setDesc(getString(R.string.warning_location));
                    info.setType(CameraSleepType.SLEEP_GEOGRAPHIC);
                    break;
            }
            mSleepModes.add(info);
        }
        return;
    }

    /**
     * @param fragmentView
     */
    private void initView(View fragmentView) {
        this.mVideoViewLayout = fragmentView.findViewById(R.id.view_single_preview);
        this.mHorToolsBar = fragmentView.findViewById(R.id.single_preview_tool_bottom);
        this.mVideoTypeTools = fragmentView.findViewById(R.id.single_preview_title_bar);
        this.mVideoType_L = fragmentView.findViewById(R.id.video_type_l);
        this.mPlayBtn = fragmentView.findViewById(R.id.single_play_song);
        this.mPlayBtn_L = fragmentView.findViewById(R.id.single_play_song_L);
        if (mCameraInfo.isAsFriend()) {
            fragmentView.findViewById(R.id.layout_play_song).setVisibility(GONE);
            fragmentView.findViewById(R.id.layout_single_play_song_L).setVisibility(GONE);
        }
        RelativeLayout btn_sleep = fragmentView.findViewById(R.id.btn_sleep);
        RelativeLayout btn_armler = fragmentView.findViewById(R.id.btn_arm);
        fragmentView.findViewById(R.id.btn_sleep).setEnabled(false);
        fragmentView.findViewById(R.id.btn_arm).setEnabled(false);
        SleepMethmodInfo info = getSleepByMode("off");
        setSleepView(info);
        btn_sleep.setEnabled(false);
        btn_sleep.setTag(info);
        btn_armler.setTag(false);
        btn_armler.setEnabled(false);
        fragmentView.findViewById(R.id.btn_arm).setOnClickListener(this);
        fragmentView.findViewById(R.id.btn_sleep).setOnClickListener(this);
        this.mPlayBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                changePlayStatus();
            }
        });
        this.mPlayBtn_L.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                changePlayStatus();
            }
        });
        mVideoLayout = fragmentView.findViewById(R.id.video_view);
        initOpenGL2();
        mView_REC = fragmentView.findViewById(R.id.single_preview_ll_REC);
        if (mVideoView == null) {
            getActivity().finish();
        }
        this.mLoadingView = fragmentView.findViewById(R.id.loading_view);
        this.mLoadingView.init(true);
        this.mLoadingView.setVisibility(VISIBLE);
        this.mFreshBtn = fragmentView.findViewById(R.id.btn_refresh);
        this.mRecordVoiceImg = fragmentView.findViewById(R.id.single_preview_record);
        this.mRecordVideoImg = fragmentView.findViewById(R.id.single_preview_video);
        this.mVoiceImg = fragmentView.findViewById(R.id.single_preview_voice);
        this.mRecordVoiceImg_L = fragmentView.findViewById(R.id.single_preview_record_L);
        this.mRecordVideoImg_L = fragmentView.findViewById(R.id.single_preview_video_L);
        this.mVoiceImg_L = fragmentView.findViewById(R.id.single_preview_voice_L);
        this.tv_mode_land = fragmentView.findViewById(R.id.tv_mode_land);
        this.tv_mode_land.setOnClickListener(this);
        this.rl_mode = fragmentView.findViewById(R.id.rl_mode);
        this.rl_mode.setOnClickListener(this);
        this.btn_auto = fragmentView.findViewById(R.id.btn_auto);
        this.btn_auto.setOnClickListener(this);
        this.btn_sd = fragmentView.findViewById(R.id.btn_sd);
        this.btn_sd.setOnClickListener(this);
        this.btn_hd = fragmentView.findViewById(R.id.btn_hd);
        this.btn_hd.setOnClickListener(this);
        this.rl_tool = fragmentView.findViewById(R.id.rl_tool);
        this.rl_tool.setOnClickListener(this);
        this.tv_mode = fragmentView.findViewById(R.id.tv_mode);
        this.tv_mode.setOnClickListener(this);
        this.iv_full = fragmentView.findViewById(R.id.iv_full);
        this.iv_full.setOnClickListener(this);
        this.iv_full_L = fragmentView.findViewById(R.id.iv_full_L);
        this.iv_full_L.setOnClickListener(this);
        this.btn_share = fragmentView.findViewById(R.id.btn_share);
        this.btn_share.setOnClickListener(this);
        //获取当前预览模式：高清、标清、自动,HD、SD、AT自动
        if (mVideoType.equals("HD")) {
            //改变背景
            this.btn_hd.setBackgroundResource(R.drawable.shape_ovil_stroke_pressed);
            this.btn_hd.setTextColor(getResources().getColor(R.color.btn_gree_light));
        } else if (mVideoType.equals("SD")) {
            this.btn_sd.setBackgroundResource(R.drawable.shape_ovil_stroke_pressed);
            this.btn_sd.setTextColor(getResources().getColor(R.color.btn_gree_light));
        } else {
            this.btn_auto.setBackgroundResource(R.drawable.shape_ovil_stroke_pressed);
            this.btn_auto.setTextColor(getResources().getColor(R.color.btn_gree_light));
        }

        fragmentView.findViewById(R.id.single_preview_tool_bottom).setOnTouchListener(new OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return true;
            }
        });
        initVideoViewDetector();
        if (mVideoPlayCallback != null)
            setEnabledVoice(mVideoPlayCallback.iSSoundStatus());
        else
            setEnabledVoice(false);
        setRecodeVideoview(false);
        setRecodeVoice(false);
        fragmentView.findViewById(R.id.single_preview_record).setOnTouchListener(onRecordTouchListener);
        fragmentView.findViewById(R.id.single_preview_record).setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                if (!onCheckAudioPermissionClick()) {
                    CommonUtils.showDialog(getActivity(), getString(R.string.audio_warning), new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            requeestStroagePermissionClick();
                            dialog.dismiss();
                        }
                    }, true);
                    return false;
                }
                onRecodeAufio();
                return false;
            }
        });
        fragmentView.findViewById(R.id.single_preview_camera).setOnClickListener(this);
        fragmentView.findViewById(R.id.single_preview_video).setOnClickListener(this);
        fragmentView.findViewById(R.id.single_preview_voice).setOnClickListener(this);
        fragmentView.findViewById(R.id.single_preview_record_L).setOnTouchListener(onRecordTouchListener);
        fragmentView.findViewById(R.id.single_preview_record_L).setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                if (!onCheckAudioPermissionClick()) {
                    CommonUtils.showDialog(getActivity(), getString(R.string.audio_warning), new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            requeestStroagePermissionClick();
                            dialog.dismiss();
                        }
                    }, true);
                    return false;
                }
                onRecodeAufio();
                return false;
            }
        });
        fragmentView.findViewById(R.id.single_preview_camera_L).setOnClickListener(this);
        fragmentView.findViewById(R.id.single_preview_video_L).setOnClickListener(this);
        fragmentView.findViewById(R.id.btn_share).setOnClickListener(this);
        fragmentView.findViewById(R.id.single_preview_voice_L).setOnClickListener(this);
        this.mFreshBtn.setOnClickListener(this);
        mVideoType_L.setOnClickListener(this);
//        if (mVideoPlayCallback != null && mVideoPlayCallback.getRightView() != null)
//            mVideoPlayCallback.getRightView().setOnClickListener(this);
        SimpleDraweeView deivceType = fragmentView.findViewById(R.id.device_img);
        deivceType.getHierarchy().setFailureImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
        deivceType.setImageURI(Uri.parse(mCameraInfo.getDeviceIcon()));
        initConfiguration(getResources().getConfiguration().orientation);
        //初始化设置按钮
        initSettingBtn(mVideoType);
        initVideoType(mVideoType);
        initAnimation();
        if (mCameraInfo.isAsFriend()) {
            fragmentView.findViewById(R.id.layout_setting).setVisibility(GONE);
        }
        mScaleTemperatureView = (ScaleTemperatureView) fragmentView.findViewById(R.id.scale_thermometer);

        mScaleTemperatureView.init();
        mScaleHumidityView = (ScaleHumidityView) fragmentView.findViewById(R.id.scale_humidity);
        mScaleHumidityView.init();
        mSpeechDialog = new SpeechDialog(getActivity());
        initRecyclerView();
        checkRoi();
    }

    /**
     * 门铃修改，初始化设置按钮
     *
     * @param videotype
     */
    private void initSettingBtn(String videotype) {
        if (mVideoPlayCallback == null || mVideoPlayCallback.getRightView() == null)
            return;
        if (videotype == null) {
            videotype = "HD";
        }
        //设置tv_mode为当前预览模式
        if (videotype.equals("HD")) {
            tv_mode.setText(R.string.hd);
            tv_mode_land.setText(R.string.hd);
        } else if (videotype.equals("SD")) {
            tv_mode.setText(R.string.sd);
            tv_mode_land.setText(R.string.sd);
        } else if (videotype.equals("AT")) {
            tv_mode.setText(R.string.auto);
            tv_mode_land.setText(R.string.auto);
        }
        if (videotype.equals("HD")) {
            //换成设置按钮
            mVideoPlayCallback.getRightView().setText("");
            //设置宽高,20dp
            int w = DisplayUtil.dpToPx(getActivity(), 20);
            int h = w;
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) mVideoPlayCallback.getRightView().getLayoutParams();
            params.width = w;
            params.height = h;
            mVideoPlayCallback.getRightView().setLayoutParams(params);
            if (mCameraInfo.isUpdateVersion() == true) {
                mVideoPlayCallback.getRightView().setBackgroundResource(R.mipmap.img_setting_dot);
            } else {
                mVideoPlayCallback.getRightView().setBackgroundResource(R.mipmap.img_setting);
            }

            mVideoPlayCallback.getRightView().setTag("HD");
            mVideoType_L.setText(getActivity().getString(R.string.hd));
            mVideoType_L.setTag("HD");
        } else if (videotype.equals("SD")) {
            //换成设置按钮
            //设置宽高
            int w = DisplayUtil.dpToPx(getActivity(), 20);
            int h = w;
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) mVideoPlayCallback.getRightView().getLayoutParams();
            params.width = w;
            params.height = h;
            mVideoPlayCallback.getRightView().setLayoutParams(params);
            mVideoPlayCallback.getRightView().setText("");
            if (mCameraInfo.isUpdateVersion() == true) {
                mVideoPlayCallback.getRightView().setBackgroundResource(R.mipmap.img_setting_dot);
            } else {
                mVideoPlayCallback.getRightView().setBackgroundResource(R.mipmap.img_setting);
            }

            mVideoPlayCallback.getRightView().setTag("SD");
            mVideoType_L.setText(getActivity().getString(R.string.sd));
            mVideoType_L.setTag("SD");
        }
    }

    public void checkRoi() {
//        CheckBox roiChk = (CheckBox) mView.findViewById(R.id.btn_share);
//        roiChk.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
//            @Override
//            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
//                if (buttonView.isEnabled()) {
//                    if (mRegions.size() == 0) {
//                        CommonUtils.showDlg(getActivity(), getString(R.string.app_meari_name), getString(R.string.region_setting), getString(R.string.go_setting), mRegionClick,
//                                getString(R.string.cancel), mRegionCancelClick, true);
//                        buttonView.setEnabled(false);
//                        buttonView.setChecked(!isChecked);
//                        buttonView.setEnabled(true);
//                        return;
//                    }
//                    setEnableRoi(isChecked);
//                }
//
//            }
//        });
    }


    private void changePlayStatus_L(boolean isChecked) {
        if (isChecked) {
            if (mPopupWindow != null)
                mPopupWindow.dismiss();
        } else {
        }
    }

    private void changePlayStatus() {
        if (mVideoPlayCallback == null || mVideoPlayCallback.getConnectStatus() != 1)
            return;
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", mCameraInfo);
        Intent intent = new Intent();
        intent.setClass(getActivity(), MusicPlayActivity.class);
        intent.putExtras(bundle);
        CommonUtils.setSdkUtil(mVideoPlayCallback.getCameraPlayer());
        if (CommonUtils.getSdkUtil() != null) {
            CommonUtils.getSdkUtil().setCameraInfo(mCameraInfo);
            startActivity(intent);
        }
        getActivity().overridePendingTransition(R.anim.slide_up_in,R.anim.slide_down_out);
    }

    public boolean onCheckAudioPermissionClick() {
        boolean hasStoragePermission = PermissionUtil.with(this).has(RECORD_AUDIO);
        return hasStoragePermission;
    }

    public void requeestStroagePermissionClick() {
        boolean hasStoragePermission = PermissionUtil.with(this).has(RECORD_AUDIO);
        if (!hasStoragePermission) {
            mRecordPermissionRequest = PermissionUtil.with(this).request(RECORD_AUDIO).onAllGranted(
                    new Func() {
                        @Override
                        protected void call() {

                        }
                    }).onAnyDenied(
                    new Func() {
                        @Override
                        protected void call() {
                        }
                    }).ask(REQUEST_CODE_ASK_PERMISSIONS);
        }
    }

    private void initOpenGL2() {
        mVideoView = new PPSGLSurfaceView(getActivity(), Constant.width, Constant.height);
        mVideoView.setKeepScreenOn(true);
        mVideoLayout.addView(mVideoView);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) mVideoView.getLayoutParams();
        params.width = LinearLayout.LayoutParams.MATCH_PARENT;
        params.height = LinearLayout.LayoutParams.MATCH_PARENT;
        mVideoView.setLayoutParams(params);
    }

    private void initControlGestures() {
        mScaleGestureDetector = new ScaleGestureDetector(getActivity(), scaleGestureListener);
        mRecord = new UtilRecord();
        mRecord.setOnRecordListener(onRecordListener);
        moveHandler = MoveHandler.newMoveHandler();
        // /云端控制，移动&停止
        mMoveGestureDetector = new GestureDetector(getActivity(), new MoveGestureListener());
    }


    private void setRecodeVoice(boolean enable) {
        this.mRecordVoiceImg.setTag(enable);
        this.mRecordVoiceImg_L.setTag(enable);
        if (!enable) {
            this.mRecordVoiceImg.setImageResource(R.mipmap.ic_pronunciation_n);
            this.mRecordVoiceImg_L.setImageResource(R.mipmap.ic_pronunciation_n);
            if (mSpeechDialog != null)
                this.mSpeechDialog.dismiss();
        } else {
            this.mRecordVoiceImg.setImageResource(R.mipmap.ic_pronunciation_y);
            this.mRecordVoiceImg_L.setImageResource(R.mipmap.ic_pronunciation_y);
            if (mSpeechDialog != null)
                this.mSpeechDialog.show();
        }
    }

    /**
     * @param enable false means has voice
     *               ture means no voice
     */
    private void setEnabledVoice(boolean enable) {
        this.mVoiceImg.setTag(enable);
        this.mVoiceImg_L.setTag(enable);
        if (!enable) {
            this.mVoiceImg.setImageResource(R.drawable.btn_voice_baby_enable);
            this.mVoiceImg_L.setImageResource(R.drawable.btn_voice_baby_enable);
        } else {
            this.mVoiceImg.setImageResource(R.drawable.btn_voice_baby_disenale);
            this.mVoiceImg_L.setImageResource(R.drawable.btn_voice_baby_disenale);
        }
        if (mVideoPlayCallback != null)
            mVideoPlayCallback.changeSoundStatus(enable);
    }

    private void initVideoType(String videotype) {
        if (mVideoPlayCallback == null || mVideoPlayCallback.getRightView() == null)
            return;
        if (videotype == null)
            videotype = "HD";
        if (videotype.equals("HD")) {
            mVideoPlayCallback.getRightView().setText(getActivity().getString(R.string.hd));
            mVideoPlayCallback.getRightView().setTag("HD");
            mVideoType_L.setText(getActivity().getString(R.string.hd));
            mVideoType_L.setTag("HD");
        } else {
            mVideoPlayCallback.getRightView().setText(getActivity().getString(R.string.sd));
            mVideoPlayCallback.getRightView().setTag("SD");
            mVideoType_L.setText(getActivity().getString(R.string.sd));
            mVideoType_L.setTag("SD");
        }
    }

    private void initConfiguration(int orientation) {
        initVideoViewSize(orientation);
        if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            mView.findViewById(R.id.ll_single_preview_bottom).setVisibility(GONE);
        } else {
            this.mHorToolsBar.setVisibility(GONE);
            mView.findViewById(R.id.ll_single_preview_bottom).setVisibility(VISIBLE);
            mView.findViewById(R.id.single_preview_title_bar).setVisibility(GONE);
        }
    }

    private void initVideoViewSize(int orientation) {
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) mVideoViewLayout.getLayoutParams();
        if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            params.width = Constant.height;
            params.height = Constant.width;
        } else {
            params.width = Constant.width;
            params.height = Constant.width * 9 / 16;
        }
        mVideoViewLayout.setLayoutParams(params);
    }

    @Override
    public void closeFragment() {
        this.mfinish = true;
        mView.findViewById(R.id.video_view).setVisibility(View.GONE);
        mVideoPlayCallback.getCameraPlayer().stopPreview(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
            }

            @Override
            public void PPFailureError(String errorMsg) {
            }
        });
    }

    public boolean isChangeTabPlay() {
        return this.mIsChangeTabPlay;
    }

    /**
     * start preview
     *
     * @param changeDate
     */
    @Override
    public void playVideo(boolean changeDate) {
        if (this.mView == null || mIsBackground || mVideoPlayCallback.getCameraPlayer() == null) {
            return;
        }
        boolean bHd = mVideoType.equals("HD") ? true : false;

        mVideoPlayCallback.getCameraPlayer().startPreview
                (mVideoView, 0, new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        mEventHandler.sendEmptyMessage(MESSAGE_PLAY_SUCCESS);
                        initVoiceStatus();
                        getBitRateHandler.removeCallbacks(getBitRateRunnable);
                        getBitRateHandler.postDelayed(getBitRateRunnable, 1000);
                    }


                    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
                    @Override
                    public void PPFailureError(String errorMsg) {
                        if (getActivity() == null || getActivity().isFinishing() || getActivity().isDestroyed() || mEventHandler == null)
                            return;
                        try {
                            BaseJSONObject baseJSONObject = new BaseJSONObject(errorMsg);
                            if (baseJSONObject.has("code")) {
                                int code = baseJSONObject.optInt("code");
                                {
                                    if (code == -10) {
                                        videoViewStatus(SingleVideoActivity.STATUS_PLAYING);
                                        return;
                                    }
                                }
                            }
                            if (mEventHandler != null)
                                mEventHandler.sendEmptyMessage(MESSAGE_PLAY_FAILED);
                        } catch (JSONException e) {
                            e.printStackTrace();
                            if (mEventHandler != null)
                                mEventHandler.sendEmptyMessage(MESSAGE_PLAY_FAILED);
                        }
                    }
                }, mStopListener);
    }

    /**
     * 获取码率
     */
    private Runnable snopRunnable = new Runnable() {

        @Override
        public void run() {
            if (mfinish)
                return;
            if (mVideoPlayCallback != null && mVideoPlayCallback.getSleepMode())
                return;
            String path = Constant.DOCUMENT_CACHE_PATH + mCameraInfo.getSnNum() + ".jpg";
            if (FileUtil.fileIsExists(path))
                new File(path).delete();
            mVideoPlayCallback.getCameraPlayer().Playsnapshot(path, new CameraPlayerListener() {
                @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
                @Override
                public void PPSuccessHandler(String successMsg) {
                    if (getActivity() == null || getActivity().isFinishing() || getActivity().isDestroyed() || mEventHandler == null)
                        return;
                    mBsnop = true;
                }

                @Override
                public void PPFailureError(String errorMsg) {
                }
            });
        }
    };

    private void initVoiceStatus() {
        boolean enable = (boolean) this.mVoiceImg.getTag();
        if (mVideoPlayCallback.getCameraPlayer() != null)
            mVideoPlayCallback.getCameraPlayer().enableMute(enable, CameraPlayer.PLAY_MODE);
    }

    /**
     * @param index means status
     *              0 means loading
     *              1 means refresh
     *              2 means play
     */
    @Override
    public void videoViewStatus(int index) {
        super.videoViewStatus(index);
        switch (index) {
            case SingleVideoActivity.STATUS_LOGIN_FAILED:
                if (mView != null) {
                    mView.findViewById(R.id.btn_refresh).setVisibility(View.VISIBLE);
                    mView.findViewById(R.id.loading_view).setVisibility(View.GONE);
                    CommonUtils.showToast(R.string.open_fail);
                }
                break;
            case SingleVideoActivity.STATUS_LOADING:
                if (mView != null) {
                    mView.findViewById(R.id.btn_refresh).setVisibility(View.GONE);
                    mView.findViewById(R.id.loading_view).setVisibility(View.VISIBLE);
                }
                break;
            case SingleVideoActivity.STATUS_REFRESH:
                if (mView != null) {
                    mView.findViewById(R.id.btn_refresh).setVisibility(View.VISIBLE);
                    mView.findViewById(R.id.loading_view).setVisibility(View.GONE);
                }
                break;
            case SingleVideoActivity.STATUS_PLAY:
                if (!mIsBackground)
                    playVideo(false);
                break;
            case SingleVideoActivity.STATUS_PLAYING:
                if (mView != null) {
                    mView.findViewById(R.id.btn_refresh).setVisibility(View.GONE);
                    mView.findViewById(R.id.loading_view).setVisibility(View.GONE);
                    mView.findViewById(R.id.black_image).setVisibility(View.GONE);
                }
                break;
        }
    }

    /**
     * 语音对讲数据采集回调
     */
    private UtilRecord.OnRecordListener onRecordListener = new UtilRecord.OnRecordListener() {
        @Override
        public void volume(int volume) {
            {
                if (mSpeechDialog != null)
                    try {
                        if (mEventHandler != null) {
                            Message msg = new Message();
                            msg.what = MESSAGE_SET_VOLUME;
                            msg.obj = volume;
                            mEventHandler.sendMessage(msg);
                        }

                    } catch (Exception e) {

                    }

            }
        }

        @Override
        public void sound(short[] audioData, int len) {

        }

        @Override
        public void error(String error) {
            CommonUtils.showToast(getString(R.string.no_mic));
        }

        @Override
        public void showWarning() {

        }
    };

    /**
     * the animation of recview
     */
    private void initAnimation() {
        this.mAnimation = new AlphaAnimation(1.0f, 0.0f);
        mAnimation.setDuration(300);
        mAnimation.setRepeatCount(Animation.INFINITE);
        mAnimation.setRepeatMode(Animation.REVERSE);
    }

    private Handler mTemperHumidityHandler = new Handler();

    private void getTemperHumidity() {
        if (mTemperHumidityHandler == null)
            return;
        mTemperHumidityHandler.removeCallbacks(mTemperatureHumidityRunnable);
        mTemperHumidityHandler.postDelayed(mTemperatureHumidityRunnable, 1000);
    }

    private Runnable mTemperatureHumidityRunnable = new Runnable() {
        @Override
        public void run() {
            if (mVideoPlayCallback.getCameraPlayer() != null) {
                BaseJSONObject json = new BaseJSONObject();
                json.put("action", "GET");
                json.put("deviceurl", "http://127.0.0.1/devices/temp_humidity/value");
                mVideoPlayCallback.getCameraPlayer().getTemperatureHumidity(new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        if (mEventHandler == null)
                            return;
                        Message msg = new Message();
                        msg.what = MESSAGE_TEM_HUMI_REFRSH;
                        msg.obj = successMsg;
                        mEventHandler.sendMessage(msg);
                        if (mTemperatureHumidityRunnable != null) {
                            mTemperHumidityHandler.postDelayed(mTemperatureHumidityRunnable, 10000);
                        }
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        if (mTemperatureHumidityRunnable != null) {
                            mTemperHumidityHandler.postDelayed(mTemperatureHumidityRunnable, 10000);
                        }
                    }
                });
            }
        }

    };

    @SuppressLint("HandlerLeak")
    private Handler mEventHandler = new Handler() {
        @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public void handleMessage(Message msg) {
            if (mEventHandler == null || getActivity() == null || getActivity() == null || getActivity().isFinishing() || getActivity().isDestroyed())
                return;

            switch (msg.what) {
                case MESSAGE_PLAY_SUCCESS:
                    setPlayViewSuccessViwe(true);
                    postSettingData();
                    getSdStatus();
                    getTemperHumidity();

                    break;
                case MESSAGE_PLAY_FAILED:
                    setPlayViewSuccessViwe(false);
                    break;
                case MESSAGE_PLAY_STOP:
//                    setPlayViewSuccessViwe(false);
                    break;
                case MESSAGE_PLAYING:
                    videoViewStatus(SingleVideoActivity.STATUS_PLAYING);
                    setPlayViewSuccessViwe(true);
                    break;
                case MESSAGE_SNAP_SUCCESS:
                    String path = (String) msg.obj;
                    CommonUtils.showToast(getString(R.string.photo_save) + path);
                    break;
                case MESSAGE_SNAP_FAILED:
                    String errorCode = (String) msg.obj;
                    if (errorCode.equals(CameraPlayer.STORAGE_PERMISSION_DENIED)) {
                        CommonUtils.showToast(getString(R.string.tip_permission_storage));
                    } else {
                        CommonUtils.showToast(getString(R.string.fail));
                    }
                    break;
                case MESSAGE_TALK_SUCCESS:
                    break;
                case MESSAGE_TALK_FAILED:
                    setRecodeVoice(false);
                    break;
                case MESSAGE_RECORD_SAVE_SUCCESS:
                    setRecodeVideoview(false);
                    mView_REC.clearAnimation();
                    mView_REC.setVisibility(GONE);
                    CommonUtils.showToast(getString(R.string.record_save) + mRecordPath);
                    break;
                case MESSAGE_RECORD_SAVE_FAILED:
                    setRecodeVideoview(false);
                    mView_REC.clearAnimation();
                    mView_REC.setVisibility(GONE);
                    if (mRecordPath != null) {
                        File file = new File(mRecordPath);
                        if (file.exists()) {
                            file.delete();
                        }
                    }
                    String errorCodeRecord = (String) msg.obj;
                    if (errorCodeRecord != null && errorCodeRecord.equals("-1")) {
                        CommonUtils.showToast(getString(R.string.tip_permission_storage));
                    } else {
                        CommonUtils.showToast(getString(R.string.fail));
                    }
                    break;
                case MESSAGE_RECORD_FAILED:
                    setRecodeVideoview(false);
                    mView_REC.clearAnimation();
                    mView_REC.setVisibility(GONE);
                    String errorRecodeVideoCode = (String) msg.obj;
                    if (errorRecodeVideoCode != null && errorRecodeVideoCode.equals("-1"))
                        CommonUtils.showToast(getString(R.string.tip_permission_storage));
                    else
                        CommonUtils.showToast(getString(R.string.record_fail));
                    break;
                case MESSAGE_RECORD_VIDEO_START:
                    showRecordView();
                    break;
                case MESSAGE_MODE_INIT:
                    String sleepMode = (String) msg.obj;
                    SleepMethmodInfo info = getSleepByMode(sleepMode);
                    mView.findViewById(R.id.btn_sleep).setEnabled(true);
                    if (info.getType() != null)
                        setSleepView(info);
                    break;
                case MESSAGE_ARAM_INIT:
                    ArmingInfo mAlarm = (ArmingInfo) msg.obj;
                    setArmingSwiftImgStatus(mAlarm.cfg);
                    break;
                case MESSAGE_SET_VOLUME:
                    int value = (int) msg.obj;
                    mSpeechDialog.setVolume(value);
                    break;
                case MESSAGE_CHAGE_PLAY_FAILED:
                    videoViewStatus(SingleVideoActivity.STATUS_REFRESH);
                    break;
                case MESSAGE_CHAGE_PLAY_SUCCESS:
                    videoViewStatus(SingleVideoActivity.STATUS_PLAYING);
                    mVideoView.setBackgroundColor(getResources().getColor(R.color.transparent));
                    break;
                case MESSAGE_NO_FIND_MIC:
                    CommonUtils.showToast(getString(R.string.no_mic));
                    break;
                case MESSAGE_SLEEP:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    if (mView.findViewById(R.id.text_sleep) != null)
                        mView.findViewById(R.id.text_sleep).setVisibility(VISIBLE);
                    mVideoView.clearblack();
                    videoViewStatus(SingleVideoActivity.STATUS_PLAYING);
                    mView.findViewById(R.id.black_image).setVisibility(View.VISIBLE);
                    mVideoPlayCallback.setSleepMode(true);
                    setSleepViewStatus(false);
                    break;
                case MESSAGE_SLEEP_STOP:
                    if (mView.findViewById(R.id.text_sleep) != null)
                        mView.findViewById(R.id.text_sleep).setVisibility(GONE);
                    mView.findViewById(R.id.black_image).setVisibility(View.GONE);
                    setSleepViewStatus(true);
                    break;
                case MESSAGE_TEM_HUMI_REFRSH:
                    String successMsg = (String) msg.obj;
                    BaseJSONObject baseJSONObject;
                    try {
                        baseJSONObject = new BaseJSONObject(successMsg);
                        float temperature = (float) baseJSONObject.optDouble("temperature_c", -10);
                        float hunidity = (float) baseJSONObject.optDouble("humidity", 0);
                        mScaleHumidityView.setHumidity((int) hunidity);
                        mScaleTemperatureView.setTemperature((int) temperature);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    break;
                case MESSAGE_SETTING_SLEEP_FAILED:
                    SleepMethmodInfo methmodInfo = (SleepMethmodInfo) msg.obj;
                    setSleepView(methmodInfo);
                    CommonUtils.showToast(R.string.setting_failded);
                    break;
                case MESSAGE_SETTING_SLEEP_SUCCESS:
                    CommonUtils.showToast(R.string.setting_successfully);
                    break;
                case MESSAGE_STOP_SUCCESS:
                    mView.findViewById(R.id.black_image).setVisibility(View.VISIBLE);
                    break;
                default:
                    break;
            }
        }


    };

    private SleepMethmodInfo getSleepByMode(String sleepMode) {
        for (SleepMethmodInfo info : mSleepModes) {
            if (info.getType().equals(sleepMode))
                return info;
        }
        if (mSleepModes != null && mSleepModes.size() > 0)
            return mSleepModes.get(0);
        return null;
    }

    private void postSettingData() {
        mVideoPlayCallback.getCameraPlayer().getDeviceSettingParams(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null)
                    return;
                String sleepMode = "off";
                try {
                    BaseJSONObject successMsgJson = new BaseJSONObject(successMsg);
                    sleepMode = successMsgJson.optString("sleep", "off");
                    BaseJSONArray jsonArray = successMsgJson.optBaseJSONArray("sleep_time");
                    mTimeInfos = JsonUtil.getSleepTimeInfos(jsonArray);
                    BaseJSONObject jsonObject = successMsgJson.optBaseJSONObject("motion_detect");
                    ArmingInfo mAlarm = new ArmingInfo();
                    mAlarm.cfg.enable = jsonObject.optInt("enable", -1);
                    mAlarm.cfg.alarmtype = jsonObject.optInt("alarmtype", -1);
                    mAlarm.cfg.sensitivity = jsonObject.optInt("sensitivity", -1);
                    Message msg = new Message();
                    msg.what = MESSAGE_ARAM_INIT;
                    msg.obj = mAlarm;
                    mEventHandler.sendMessage(msg);
                    if (successMsgJson.has("device")) {
                        BaseJSONObject deviceJson = successMsgJson.optBaseJSONObject("device");
                        String firmware_version = deviceJson.optString("firmware_version");
                        mVideoPlayCallback.postUpDataDevice(firmware_version);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                if (mEventHandler != null) {
                    Message msgSleep = new Message();
                    msgSleep.what = MESSAGE_MODE_INIT;
                    msgSleep.obj = sleepMode;
                    mEventHandler.sendMessage(msgSleep);
                }

            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler != null) {
                    Message msgSleep = new Message();
                    msgSleep.what = MESSAGE_MODE_INIT;
                    msgSleep.obj = "off";
                    mEventHandler.sendMessage(msgSleep);
                }
                if (getActivity() == null || getActivity().isFinishing() || mEventHandler == null)
                    return;
                ArmingInfo mAlarm = new ArmingInfo();
                mAlarm.cfg.enable = 0;
                Message msg = new Message();
                msg.what = MESSAGE_ARAM_INIT;
                msg.obj = mAlarm;
                mEventHandler.sendMessage(msg);
            }
        });
        if (mCameraInfo.getProtocolVersion() < 2) {
            mVideoPlayCallback.getCameraPlayer().getdeviceparams(CameraPlayer.GET_PPS_DEVICE_ALARM, new CameraPlayerListener() {
                @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
                @Override
                public void PPSuccessHandler(String successMsg) {
                    if (getActivity() == null || getActivity().isFinishing() || mEventHandler == null || successMsg == null)
                        return;
                    try {
                        BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                        ArmingInfo mAlarm = new ArmingInfo();
                        mAlarm.cfg.enable = jsonObject.optInt("enable", -1);
                        mAlarm.cfg.alarmtype = jsonObject.optInt("alarmtype", -1);
                        mAlarm.cfg.sensitivity = jsonObject.optInt("sensitivity", -1);
                        Message msg = new Message();
                        msg.what = MESSAGE_ARAM_INIT;
                        msg.obj = mAlarm;
                        mEventHandler.sendMessage(msg);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
                @Override
                public void PPFailureError(String errorMsg) {
                    if (getActivity() == null || getActivity().isFinishing() || mEventHandler == null)
                        return;
                    ArmingInfo mAlarm = new ArmingInfo();
                    mAlarm.cfg.enable = 0;
                    Message msg = new Message();
                    msg.what = MESSAGE_ARAM_INIT;
                    msg.obj = mAlarm;
                    mEventHandler.sendMessage(msg);
                }
            });
        }
    }

    public void getSdStatus() {
        mVideoPlayCallback.getCameraPlayer().queryDeviceStorageStatus(new StorageStatusListener() {
            @Override
            public void PPSuccessHandler(CameraSdCardInfo info) {
                mVideoPlayCallback.setSdcardStatus(info.getTotal_space());
            }

            @Override
            public void PPFailureError(String errorMsg) {
                mVideoPlayCallback.setSdcardStatus(0);
            }
        });
    }

    private void showRecordView() {
        this.mView_REC.setVisibility(VISIBLE);
        this.mView_REC.startAnimation(mAnimation);
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mView == null)
            return;
        if (!getUserVisibleHint()) {
            return;
        }
        mIsBackground = false;
        if (mVideoPlayCallback != null && mVideoPlayCallback.getCameraPlayer() != null || isChangeTabPlay()) {
            videoViewStatus(SingleVideoActivity.STATUS_LOADING);
            this.mView.findViewById(R.id.text_sleep).setVisibility(View.GONE);
            if (mVideoPlayCallback.getConnectStatus() == -1 || mVideoPlayCallback.getConnectStatus() == -2) {
                mVideoPlayCallback.onRefresh();
            } else if (mVideoPlayCallback.getConnectStatus() == 1)
                playVideo(false);
        } else if (mVideoPlayCallback.getCameraPlayer() == null) {
            videoViewStatus(0);
            if (mVideoPlayCallback.getCurVideoType() == 0) {
                mVideoPlayCallback.onRefresh();
            }
        }
    }

    public void setPlayViewSuccessViwe(boolean playViewSuccessViwe) {
        if (mView == null)
            return;
        this.mLoadingView.setVisibility(GONE);
        if (playViewSuccessViwe)
            this.mFreshBtn.setVisibility(GONE);
        else
            this.mFreshBtn.setVisibility(VISIBLE);
    }

    private void isExist(String path) {
        File file = new File(path);
        if (!file.exists()) {
            file.mkdir();
        }
    }

    /**
     * Gets the time date, string format
     *
     * @param time 时间戳
     * @return
     */
    private String getDateTime(long time) {
        if (time < 0) {
            time = System.currentTimeMillis();
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String date = sdf.format(new Date(time));
        return date;
    }

    /**
     * the path of picture
     *
     * @return
     */
    private String pictureIsPath() {
        isExist(Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount());
        isExist(Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount() + "/media/");
        return Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount() + "/media/" + Constant.PICTURE_PRE + getDateTime(-1) + ".jpg";
    }

    /**
     * @param newConfig Cross screen vertical screen switch
     */
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        initVideoViewSize(newConfig.orientation);
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            mView.findViewById(R.id.ll_single_preview_bottom).setVisibility(GONE);
        } else {
            this.mHorToolsBar.setVisibility(GONE);
            mView.findViewById(R.id.ll_single_preview_bottom).setVisibility(VISIBLE);
            mView.findViewById(R.id.single_preview_title_bar).setVisibility(GONE);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            //UI整改添加
            case R.id.tv_mode:
                //切换显示码流选择布局
                boolean isShow = this.rl_mode.getVisibility() == View.VISIBLE ? true : false;
                if (isShow) {
                    this.rl_mode.setVisibility(GONE);
                } else {
                    this.rl_mode.setVisibility(View.VISIBLE);
                }
                //隐藏自身
                this.rl_tool.setVisibility(GONE);
                break;
            case R.id.iv_full:
                //切换成横屏全屏状态
                getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                //隐藏自身
                this.rl_tool.setVisibility(GONE);
                break;
            case R.id.rl_tool:
                //隐藏自身
                this.rl_tool.setVisibility(GONE);
                break;
            case R.id.btn_auto:
                //切换成自动模式
                onChangeVideoTypeClick("AT");
                //隐藏所在布局
                rl_mode.setVisibility(GONE);
                break;
            case R.id.btn_hd:
                //切换成高清预览
                onChangeVideoTypeClick("HD");
                //隐藏所在布局
                rl_mode.setVisibility(GONE);
                break;
            case R.id.btn_sd:
                //切换成标清预览模式
                onChangeVideoTypeClick("SD");
                //隐藏所在布局
                rl_mode.setVisibility(GONE);
                break;
            case R.id.rl_mode:
                //隐藏自身
                this.rl_mode.setVisibility(GONE);
                break;
            case R.id.tv_mode_land:
                //显示预览码流模式
                this.rl_mode.setVisibility(View.VISIBLE);
                //隐藏操作条，顶部返回条
                this.mHorToolsBar.setVisibility(GONE);
                this.mVideoTypeTools.setVisibility(GONE);
                break;
            case R.id.iv_full_L:
                //切换成竖屏状态
                getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                break;
            case R.id.single_preview_voice:
                onVoiceStatusClick();
                break;
            case R.id.single_preview_voice_L:
                onVoiceStatusClick();
                break;
            case R.id.single_preview_camera:
                onSnapshot();
                break;
            case R.id.single_preview_camera_L:
                onSnapshot();
                break;
            case R.id.video_type_l:
                break;
            case R.id.single_preview_video:
                onRecordVideoClick();
                break;
            case R.id.single_preview_video_L:
                onRecordVideoClick();
                break;
            case R.id.btn_arm:
                onArmClick();
                break;
            case R.id.btn_sleep:
                onMirrorClick();
                break;
            case R.id.btn_refresh:
                onFreshClick();
                break;
            case R.id.text_sleep:
                onSleepClick();
                break;
            case R.id.btn_share:
                onShareClick();
                break;
            default:
                break;
        }
    }

    private void onSleepClick() {
        if (this.mCameraInfo.isAsFriend()) {
            CommonUtils.showToast(R.string.pps_cant_noset);
            return;
        }
        Intent intent = new Intent();
        CommonUtils.setSdkUtil(mVideoPlayCallback.getCameraPlayer());
        CommonUtils.getSdkUtil().setCameraInfo(mCameraInfo);
        intent.setClass(getActivity(), HomeModelActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", mCameraInfo);
        bundle.putInt("type", 1);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_HOMEMODE);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case ActivityType.ACTIVITY_HOMEMODE:
                if (data == null)
                    return;
                Bundle bundle = data.getExtras();
                CameraInfo cameraInfo = null;
                if (bundle != null) {
                    mTimeInfos = (ArrayList<SleepTimeInfo>) bundle.getSerializable("HomeTimeInfos");
                    cameraInfo = (CameraInfo) bundle.getSerializable("cameraInfo");
                }
                videoViewStatus(SingleVideoActivity.STATUS_LOADING);
                setSleepViewStatus(true);
                if (mView.findViewById(R.id.text_sleep) != null)
                    mView.findViewById(R.id.text_sleep).setVisibility(GONE);
                mView.findViewById(R.id.black_image).setVisibility(View.GONE);
                mVideoPlayCallback.setSleepMode(false);
                if (cameraInfo != null) {
                    mCameraInfo.setSleep(cameraInfo.getSleep());
                    SleepMethmodInfo info = getSleepByMode(cameraInfo.getSleep());
                    setSleepView(info);
                }

                break;
            default:
                break;
        }
    }

    private void onFreshClick() {
        if (!NetUtil.checkNet(getActivity())) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        videoViewStatus(SingleVideoActivity.STATUS_LOADING);
        mVideoPlayCallback.onRefresh();
    }

    private void onMirrorClick() {
        if (mCameraInfo.getProtocolVersion() < 2) {
            CommonUtils.showToast(getString(R.string.version_warning));
            return;
        }
        if (mPopupWindow != null) {
            showSleepModeView(mPopupWindow.isShowing() ? false : true);
        }
    }

    private void showSleepModeView(boolean bshow) {
        SleepMethmodInfo info = (SleepMethmodInfo) mView.findViewById(R.id.btn_sleep).getTag();
        if (bshow) {
            mSleepAdapter.setDatas(getListByMode(info));
            mSleepAdapter.notifyDataSetChanged();
            mPopupWindow.showAsDropDown(mView.findViewById(R.id.sleep_rv), 0, 0);
        } else {
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) mView.findViewById(R.id.btn_sleep).getLayoutParams();
            params.addRule(RelativeLayout.CENTER_IN_PARENT);
            mPopupWindow.dismiss();
        }
    }

    private ArrayList<SleepMethmodInfo> getListByMode(SleepMethmodInfo info) {
        ArrayList<SleepMethmodInfo> infos = new ArrayList<>();
        for (SleepMethmodInfo methmod : mSleepModes) {
            if (methmod.getType().equals(info.getType()) || methmod.getType().equals(CameraSleepType.SLEEP_GEOGRAPHIC)) {
                continue;
            } else
                infos.add(methmod);
        }
        return infos;
    }

    private void setSleepMode(SleepMethmodInfo info) {
        if (mVideoPlayCallback.getCameraPlayer() != null) {
            mVideoPlayCallback.getCameraPlayer().setCameraSleepType(info.getType(), new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {

                }

                @Override
                public void PPFailureError(String errorMsg) {

                }
            });
        }
    }

    private void onArmClick() {
        RelativeLayout arm = mView.findViewById(R.id.btn_arm);
        boolean tag = (boolean) arm.getTag();
        arm.setTag(!tag);
        setArmView(!tag);
        setArming(!tag);
    }

    public void setArmView(boolean arm) {
        ImageView arm_img = mView.findViewById(R.id.img_arm);
        TextView arm_text = mView.findViewById(R.id.text_arm);
        if (!arm) {
            arm_img.setImageResource(R.mipmap.ic_alarms_n);
            arm_text.setTextColor(Color.parseColor("#9a9a9a"));
            arm_text.setText(getString(R.string.off));
        } else {
            arm_img.setImageResource(R.mipmap.ic_alarms_y);
            arm_text.setTextColor(Color.parseColor("#ff9966"));
            arm_text.setText(getString(R.string.on));
        }
    }

    public void setSleepView(SleepMethmodInfo info) {
        RelativeLayout chekMiror = mView.findViewById(R.id.btn_sleep);
        chekMiror.setTag(info);
        ImageView img_mirror = mView.findViewById(R.id.img_mirror);
        TextView text_mirror = mView.findViewById(R.id.text_mirror);
        if (info.getType().equals("off")) {
            img_mirror.setImageResource(R.mipmap.ic_preview_camera_open_orange);
        } else if (info.getType().equals("on")) {
            img_mirror.setImageResource(R.mipmap.ic_preview_camera_close_orange);
        } else if (info.getType().equals(CameraSleepType.SLEEP_TIME)) {
            img_mirror.setImageResource(R.mipmap.ic_preview_time_orange);
        } else if (info.getType().equals(CameraSleepType.SLEEP_GEOGRAPHIC)) {
            img_mirror.setImageResource(R.mipmap.ic_preview_location_orange);
        }
        text_mirror.setText(info.getName());
        text_mirror.setTextColor(Color.parseColor("#ff9966"));
    }

    public void setArming(boolean check) {
        BaseJSONObject json = new BaseJSONObject();
        if (check) {
            json.put("enable", 1);
            json.put("alarmtype", 1);
            json.put("sensitivity", 4);
        } else {
            json.put("enable", 0);
            json.put("alarmtype", 1);
            json.put("sensitivity", 4);
        }


        mVideoPlayCallback.getCameraPlayer().setdeviceparams(CameraPlayer.SET_PPS_DEVICE_ALARM, json.toString(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
            }

            @Override
            public void PPFailureError(String errorMsg) {
            }
        });
    }

    private void onShareClick() {
        if (mCameraInfo.getUserAccount().equals(MeariUser.getInstance().getUserInfo().getUserAccount())) {
            Intent intent = new Intent();
            intent.setClass(getActivity(), ShareDeviceActivity.class);
            Bundle bundle = new Bundle();
            bundle.putSerializable("cameraInfo", mCameraInfo);
            intent.putExtras(bundle);
            startActivity(intent);
        } else {
            CommonUtils.showToast(R.string.pps_cant_noset);
        }
    }

    private void onRecordVideoClick() {
        boolean enable = (boolean) this.mRecordVideoImg.getTag();
        this.mRecordVideoImg.setTag(!enable);
        this.mRecordVideoImg_L.setTag(!enable);
        if (enable) {
            this.mRecordVideoImg.setImageResource(R.mipmap.ic_rec_video_n);
            this.mRecordVideoImg_L.setImageResource(R.mipmap.ic_rec_video_n);
            mVideoPlayCallback.getCameraPlayer().stopPlayRecordMp4(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    if (mEventHandler == null || successMsg == null)
                        return;
                    mEventHandler.sendEmptyMessage(MESSAGE_RECORD_SAVE_SUCCESS);
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (mEventHandler == null || errorMsg == null)
                        return;
                    Message msg = new Message();
                    msg.what = MESSAGE_RECORD_SAVE_FAILED;
                    msg.obj = errorMsg;
                    mEventHandler.sendMessage(msg);
                }
            });
        } else {
            this.mRecordVideoImg.setImageResource(R.mipmap.ic_rec_video_y);
            this.mRecordVideoImg_L.setImageResource(R.mipmap.ic_rec_video_y);
            isExist(Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount());
            isExist(Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount() + "/media");
            this.mRecordPath = Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount() + "/media/" + Constant.VIDEO_PRE + getDateTime(System.currentTimeMillis()) + ".mp4";
            mVideoPlayCallback.getCameraPlayer().startPlayRecordMp4(this.mRecordPath, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    if (mEventHandler != null)
                        mEventHandler.sendEmptyMessage(MESSAGE_RECORD_VIDEO_START);
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (getActivity() == null || getActivity().isFinishing() || mEventHandler == null)
                        return;
                    if (mEventHandler == null)
                        return;
                    Message msg = new Message();
                    msg.what = MESSAGE_RECORD_FAILED;
                    msg.obj = errorMsg;
                    mEventHandler.sendMessage(msg);
                }
            }, new CameraPlayerRecordMp4Listener() {
                @Override
                public void RecordMp4Interrupt(int saveSuccess) {

                }
            });
        }
    }

    /**
     * 切换预览模式。
     *
     * @param mode HD：高清；SD：标清；AT：自动；
     */
    private void onChangeVideoTypeClick(String mode) {
        if (mVideoPlayCallback == null || mVideoPlayCallback.getRightView() == null)
            return;
        //改变UI
        btn_hd.setBackgroundResource(R.drawable.bkg_btn_stroke);
        btn_sd.setBackgroundResource(R.drawable.bkg_btn_stroke);
        btn_auto.setBackgroundResource(R.drawable.bkg_btn_stroke);
        btn_hd.setTextColor(getResources().getColor(R.color.white));
        btn_sd.setTextColor(getResources().getColor(R.color.white));
        btn_auto.setTextColor(getResources().getColor(R.color.white));

        SharedPreferences.Editor editor = mVideoTypePreferences.edit();
        if (mode.equals("SD")) {
            //改变UI
            tv_mode.setText(R.string.sd);
            tv_mode_land.setText(R.string.sd);
            btn_sd.setBackgroundResource(R.drawable.shape_ovil_stroke_pressed);
            btn_sd.setTextColor(getResources().getColor(R.color.btn_gree_light));
            editor.putString("videoType", "SD");
            mVideoPlayCallback.getCameraPlayer().changePreview(mVideoView, 0, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    mEventHandler.sendEmptyMessage(MESSAGE_CHAGE_PLAY_SUCCESS);
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    mEventHandler.sendEmptyMessage(MESSAGE_CHAGE_PLAY_FAILED);
                }
            }, mStopListener);
        } else if (mode.equals("HD")) {
            //改变UI
            tv_mode.setText(R.string.hd);
            tv_mode_land.setText(R.string.hd);
            btn_hd.setBackgroundResource(R.drawable.shape_ovil_stroke_pressed);
            btn_hd.setTextColor(getResources().getColor(R.color.btn_gree_light));
            editor.putString("videoType", "HD");
            mVideoPlayCallback.getCameraPlayer().changePreview(mVideoView, 1, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    mEventHandler.sendEmptyMessage(MESSAGE_CHAGE_PLAY_SUCCESS);
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    mEventHandler.sendEmptyMessage(MESSAGE_CHAGE_PLAY_FAILED);
                }
            }, mStopListener);
        } else {
            //改变UI
            tv_mode.setText(R.string.auto);
            tv_mode_land.setText(R.string.auto);
            btn_auto.setBackgroundResource(R.drawable.shape_ovil_stroke_pressed);
            btn_auto.setTextColor(getResources().getColor(R.color.btn_gree_light));
            editor.putString("videoType", "AT");
            //自动模式，方法待定

        }
        editor.commit();
        //隐藏预览模式所在的布局
        rl_mode.setVisibility(GONE);
    }

    private void onSnapshot() {
        if (mVideoPlayCallback == null || mVideoPlayCallback.getCameraPlayer() == null)
            return;
        mVideoPlayCallback.getCameraPlayer().Playsnapshot(pictureIsPath(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null || successMsg == null)
                    return;
                Message msg = new Message();
                msg.what = MESSAGE_SNAP_SUCCESS;
                msg.obj = successMsg;
                mEventHandler.sendMessage(msg);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandler == null || errorMsg == null)
                    return;
                Message msg = new Message();
                msg.what = MESSAGE_SNAP_FAILED;
                msg.obj = errorMsg;
                mEventHandler.sendMessage(msg);
            }
        });
    }

    private void onVoiceStatusClick() {
        boolean enable = (boolean) this.mVoiceImg.getTag();
        setEnabledVoice(!enable);
        if (mVideoPlayCallback.getCameraPlayer() != null) {
            mVideoPlayCallback.getCameraPlayer().enableMute(!enable, CameraPlayer.PLAY_MODE);
        }
    }

    private CameraPlayerVideoStopListener mStopListener = new CameraPlayerVideoStopListener() {
        @Override
        public void onCameraPlayerVideoClosed(int errorcode) {
            if (mEventHandler == null)
                return;
            if (errorcode == 6 || errorcode == 7 || errorcode == 8) {
                Message msg = new Message();
                msg.what = MESSAGE_SLEEP;
                msg.arg1 = errorcode;
                mEventHandler.sendMessage(msg);
            } else if (errorcode == 3) {
                mEventHandler.sendEmptyMessage(MESSAGE_PLAY_STOP);
            } else if (errorcode == 9) {
                mEventHandler.sendEmptyMessage(MESSAGE_SLEEP_STOP);
                getBitRateHandler.removeCallbacks(getBitRateRunnable);
                getBitRateHandler.postDelayed(getBitRateRunnable, 1000);
            } else if (errorcode == 10) {
                mEventHandler.sendEmptyMessage(MESSAGE_PLAYING);
                if (!mBsnop && mEventHandler != null)
                    mEventHandler.postDelayed(snopRunnable, 1000);
            }
        }
    };

    public void setRecodeVideoview(boolean recodeVideoview) {
        this.mRecordVideoImg.setTag(recodeVideoview);
        this.mRecordVideoImg_L.setTag(recodeVideoview);
        if (recodeVideoview) {
            this.mRecordVideoImg.setImageResource(R.mipmap.ic_rec_video_y);
            this.mRecordVideoImg_L.setImageResource(R.mipmap.ic_rec_video_y);
        } else {
            this.mRecordVideoImg.setImageResource(R.mipmap.ic_rec_video_n);
            this.mRecordVideoImg_L.setImageResource(R.mipmap.ic_rec_video_n);
        }
    }

    private float mSpan;
    /**
     * Gesture detection
     */
    ScaleGestureDetector.OnScaleGestureListener scaleGestureListener = new ScaleGestureDetector.OnScaleGestureListener() {
        @Override
        public boolean onScale(ScaleGestureDetector detector) {
            if (MODE == 0)
                return false;
            // 两个触点的前一次距离
            mSpan = detector.getScaleFactor();
            if (mSpan > 1) {
                mSpan = (mSpan - 1) / 15 + 1;
            } else {
                mSpan = (mSpan - 1) / 10 + 1;
            }
            if (scaleThread != null) {
                scaleThread.interrupt();
            }
            scaleThread = new Thread(scaleRunnable);
            scaleThread.start();
            return false;
        }

        @Override
        public boolean onScaleBegin(ScaleGestureDetector detector) {
            return true;
        }

        @Override
        public void onScaleEnd(ScaleGestureDetector detector) {
        }
    };
    private int scaleX, scaleY;                             // 放大缩小的视口
    /**
     * 缩放
     */
    private Thread scaleThread;
    private Runnable scaleRunnable = new Runnable() {
        @Override
        public void run() {
            mScale = mScale * mSpan;
            if (mScale > 8) {
                mScale = 8;
                mVideoPlayCallback.getCameraPlayer().zoom2(8, CameraPlayer.PLAY_MODE);
            } else if (mScale >= 1)
                mVideoPlayCallback.getCameraPlayer().zoom2(mScale, CameraPlayer.PLAY_MODE);
            else {
                mScale = 1;
                mVideoPlayCallback.getCameraPlayer().zoom2(1, CameraPlayer.PLAY_MODE);
            }
        }
    };
    /**
     * 缩放
     */
    private Handler scaleHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            if (mScale >= 1)
                mVideoPlayCallback.getCameraPlayer().zoom2(mScale, CameraPlayer.PLAY_MODE);
            else
                mVideoPlayCallback.getCameraPlayer().zoom2(1, CameraPlayer.PLAY_MODE);
            Log.v("mScale", String.valueOf(mScale));
        }
    };
    /**
     * 视频画面 触摸事件
     */
    private OnTouchListener onTouchListener = new OnTouchListener() {
        @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            if (getActivity() == null || getActivity().isFinishing() || getActivity().isDestroyed())
                return false;
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    mVideoPlayCallback.getViewPage().requestDisallowInterceptTouchEvent(true);
                    break;
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL:
                    mVideoPlayCallback.getViewPage().requestDisallowInterceptTouchEvent(false);
                    break;
                default:
                    break;
            }
            int pCount = event.getPointerCount();
            if (pCount == 1) {
                if (mScale == 1) {
                    MODE = 0;
                    switch (event.getAction()) {
                        case MotionEvent.ACTION_CANCEL:
                        case MotionEvent.ACTION_UP:
                            stopCamera();
                            break;
                        case MotionEvent.ACTION_DOWN:
                            downX = event.getX();
                            downY = event.getY();

                            break;
                        case MotionEvent.ACTION_MOVE:
                            if (mScale == 1)
                                moveCamera(event.getX(), event.getY());
                            break;
                    }
                } else {
                    MODE = 0;
                    mMoveGestureDetector.onTouchEvent(event);
                }

            } else if (pCount > 1) {
                MODE = 1;
                stopCamera();
                mScaleGestureDetector.onTouchEvent(event);
            }
            return false;
        }

    };

    /**
     * stop move Camera
     */
    private void stopCamera() {
        moveHandler.addRunnable(stopMoveRunnable);
    }

    /**
     * v
     * 云端控制,停止
     */
    private MoveRunnable stopMoveRunnable = new MoveRunnable() {
        @Override
        public void run() {
            isMoveCamera = false;
            if (mVideoPlayCallback.getCameraPlayer() != null) {
                mVideoPlayCallback.getCameraPlayer().stopptz(mStopCameraLister);
            }
        }

        @Override
        public boolean isMove() {
            return false;
        }
    };
    /**
     * move Camera
     *
     * @param moveX
     * @param moveY
     */
    private float moveX;
    private float moveY;

    private void moveCamera(float moveX, float moveY) {
        this.moveX = moveX;
        this.moveY = moveY;
        if (mVideoPlayCallback.getCameraPlayer() != null && (Math.abs(moveY - downY) > 10 || Math.abs(moveX - downX) > 10)) {
            if (!this.isMoveCamera) {
                moveHandler.addRunnable(moveMoveRunnable);
                this.isMoveCamera = true;
            }

        }
    }

    /**
     * 云端控制,移动
     */
    /**
     * 云端控制,移动
     */
    private MoveRunnable moveMoveRunnable = new MoveRunnable() {
        @Override
        public void run() {
            if ((moveX - downX) > 10 && Math.abs(moveY - downY) < 30) {
                mVideoPlayCallback.getCameraPlayer().startptz(80, 0, 0, mMoveCameraLister);   // 右
            } else if ((moveX - downX) < -10 && Math.abs(moveY - downY) < 30) {
                mVideoPlayCallback.getCameraPlayer().startptz(-80, 0, 0, mMoveCameraLister);  // 左
            } else if ((moveY - downY) > 10 && Math.abs(moveX - downX) < 30) {
                mVideoPlayCallback.getCameraPlayer().startptz(0, -20, 0, mMoveCameraLister);  // 下
            } else if ((moveY - downY) < -10 && Math.abs(moveX - downX) < 30) {
                mVideoPlayCallback.getCameraPlayer().startptz(0, 20, 0, mMoveCameraLister);   // 上
            }
        }

        @Override
        public boolean isMove() {
            return true;
        }
    };

    /**
     * 获取码率平均值
     *
     * @param bts
     */
    private long[] btss = {0, 0, 0, 0, 0};
    private int index;

    private long getAVG(long bts) {
        btss[0] = bts;
        long btsSun = 0;
        for (int i = 0; i < btss.length; i++) {
            if (btss[i] == 0 || index == i) {
                btss[i] = bts;
            }
            btsSun += btss[i];
        }
        if (++index == btss.length) {
            index = 0;
        }
        return btsSun / btss.length;
    }

    private boolean mIsSnopt;
    /**
     * 获取码率
     */
    private Runnable getBitRateRunnable = new Runnable() {
        @Override
        public void run() {
            if (getActivity() == null || getActivity().isFinishing()) {
                return;
            }
            String kb = "KB";
            long bts = 0;
            if (!getUserVisibleHint() || getActivity() == null || getActivity().isFinishing())
                return;
            bts = mVideoPlayCallback.getCameraPlayer().getBts(CameraPlayer.PLAY_MODE);
            bts = getAVG(bts);
            float m1024 = 1024;
            bts /= m1024;
            float value = bts > 120 ? 120 : bts;
            mBitRate = (int) value + kb + "/s";
            getBitRateHandler.sendEmptyMessage(0);
            getBitRateHandler.postDelayed(this, 2000);
            if (value > 0 && !mIsSnopt) {
                mIsSnopt = true;
            }
        }
    };
    /**
     * 码率，每秒钟获取一次
     */
    private String mBitRate;
    private Handler getBitRateHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case 0:
                    if (mView != null) {
                        TextView v = mView.findViewById(R.id.single_preview_bit_rate);
                        v.setText(mBitRate);
                    }
                    break;
            }
        }
    };
    private CameraPlayerListener mMoveCameraLister = new CameraPlayerListener() {
        @Override
        public void PPSuccessHandler(String successMsg) {
            Log.v("云台控制", "设置成功");
        }

        @Override
        public void PPFailureError(String errorMsg) {
            Log.v("云台控制", "设置失败");
        }
    };
    private CameraPlayerListener mStopCameraLister = new CameraPlayerListener() {
        @Override
        public void PPSuccessHandler(String successMsg) {
            Log.v("云台控制", "关闭成功");
        }

        @Override
        public void PPFailureError(String errorMsg) {
            Log.v("云台控制", "关闭失败");
        }
    };


    private ArrayList<ArmingInfo> mDevAlarmList;

    private void initArmList() {
        this.mMotionList = getResources().getStringArray(R.array.miror_action);
        this.mMotionListValue = getResources().getIntArray(R.array.miror_action_value);
        mDevAlarmList = new ArrayList<>();
        for (int i = 0; i < mMotionListValue.length; i++) {
            ArmingInfo info = new ArmingInfo();
            PpsdevAlarmCfg cfg = new PpsdevAlarmCfg();
            cfg.sensitivity = mMotionListValue[i];
            if (i == 0) {
                cfg.enable = 0;
            } else
                cfg.enable = 1;
            cfg.alarmtype = 1;
            info.cfg = cfg;

            info.desc = mMotionList[i];
            mDevAlarmList.add(info);
        }
    }

    private void setArmingSwiftImgStatus(PpsdevAlarmCfg alarm) {
        RelativeLayout chekMiror = mView.findViewById(R.id.btn_arm);
        if (alarm.enable == 0) {
            setArmView(false);
            chekMiror.setTag(false);
        } else {
            setArmView(true);
            chekMiror.setTag(false);
        }
        chekMiror.setEnabled(true);
    }

    /**
     * 语音对讲事件
     */
    private OnTouchListener onRecordTouchListener = new OnTouchListener() {

        @Override
        public boolean onTouch(View v, MotionEvent event) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_CANCEL:
                case MotionEvent.ACTION_UP:
                    setRecodeVoice(false);
                    mSpeechDialog.dismiss();
                    mVideoPlayCallback.getCameraPlayer().stopvoicetalk(new CameraPlayerListener() {
                        @Override
                        public void PPSuccessHandler(String successMsg) {

                        }

                        @Override
                        public void PPFailureError(String errorMsg) {

                        }
                    });
            }
            return false;
        }
    };

    @Override
    public void onStop() {
        super.onStop();
        boolean enable = (boolean) this.mRecordVideoImg.getTag();
        if (enable && !mVideoPlayCallback.getFinshStatus()) {
            onRecordVideoClick();
        }
        if (mVideoPlayCallback.getCameraPlayer() != null && mfinish == false) {
            mVideoPlayCallback.getCameraPlayer().stopPreview(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                }

                @Override
                public void PPFailureError(String errorMsg) {
                }
            });
        }
    }


    public void onRecodeAufio() {
        setRecodeVoice(true);
        mVideoPlayCallback.getCameraPlayer().startvoicetalk(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler == null)
                    return;
                mEventHandler.sendEmptyMessage(MESSAGE_TALK_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                mEventHandler.sendEmptyMessage(MESSAGE_TALK_FAILED);
            }
        }, new CameraPlayerRecordVolumeListener() {
            @Override
            public void onCameraPlayerRecordvolume(int volume) {
                if (mSpeechDialog != null)
                    try {
                        if (mEventHandler != null) {
                            Message msg = new Message();
                            msg.what = MESSAGE_SET_VOLUME;
                            msg.obj = volume;
                            mEventHandler.sendMessage(msg);
                        }

                    } catch (Exception e) {

                    }
            }

            @Override
            public void error(String error) {
                if (getActivity() == null || getActivity().isFinishing())
                    return;
                if (mEventHandler != null)
                    mEventHandler.sendEmptyMessage(MESSAGE_NO_FIND_MIC);
            }
        });
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (mView == null)
            return;
        if (isVisibleToUser) {
            if (this.mVideoPlayCallback.getRightImageView() != null)
                this.mVideoPlayCallback.getRightImageView().setVisibility(GONE);
            if (this.mVideoPlayCallback.getRightView() != null)
                this.mVideoPlayCallback.getRightView().setVisibility(VISIBLE);
            if (mVideoPlayCallback.getCameraPlayer() != null) {
                videoViewStatus(SingleVideoActivity.STATUS_LOADING);
                if (mVideoPlayCallback.getConnectStatus() == -1 || mVideoPlayCallback.getConnectStatus() == -2) {
                    mVideoPlayCallback.onRefresh();
                } else if (mVideoPlayCallback.getConnectStatus() == 1)
                    playVideo(false);
            } else if (mVideoPlayCallback.getCameraPlayer() == null) {
                videoViewStatus(0);
                if (mVideoPlayCallback.getCurVideoType() == 0) {
                    mVideoPlayCallback.onRefresh();
                }
            }
        } else {
            if (this.mVideoPlayCallback.getRightImageView() != null)
                this.mVideoPlayCallback.getRightImageView().setVisibility(VISIBLE);
            if (this.mVideoPlayCallback.getRightView() != null)
                this.mVideoPlayCallback.getRightView().setVisibility(GONE);
            if ((this.mVideoPlayCallback.getCameraPlayer().getPlayStatus() & CameraPlayer.PlayRecord) == CameraPlayer.PlayRecord) {
                mView_REC.clearAnimation();
                mView_REC.setVisibility(GONE);
                this.mRecordVideoImg.setTag(false);
                this.mRecordVideoImg_L.setTag(false);
                this.mRecordVideoImg.setImageResource(R.mipmap.ic_rec_video_n);
                this.mRecordVideoImg_L.setImageResource(R.mipmap.ic_rec_video_n);
                mVideoPlayCallback.getCameraPlayer().stopPlayRecordMp4(new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {

                    }

                    @Override
                    public void PPFailureError(String errorMsg) {

                    }
                });
            }
            if (mVideoPlayCallback.getCameraPlayer() != null && mfinish == false) {
                mView.findViewById(R.id.black_image).setVisibility(View.VISIBLE);
                mVideoPlayCallback.getCameraPlayer().stopPreview(new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        if (mEventHandler == null)
                            return;
                        mEventHandler.sendEmptyMessage(MESSAGE_STOP_SUCCESS);
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        if (mEventHandler == null)
                            return;
                        mEventHandler.sendEmptyMessage(MESSAGE_STOP_SUCCESS);
                    }
                });
            }
        }
    }

    public void networkClose() {
        if (mView == null)
            return;
        videoViewStatus(SingleVideoActivity.STATUS_REFRESH);
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public void setSleepViewStatus(boolean sleepViewStatus) {
        if (getActivity() == null || getActivity().isDestroyed() || getActivity().isFinishing())
            return;
        this.mRecordVoiceImg.setEnabled(sleepViewStatus);
        this.mRecordVoiceImg_L.setEnabled(sleepViewStatus);
        ImageView single_preview_video = mView.findViewById(R.id.single_preview_video);
        ImageView single_preview_video_L = mView.findViewById(R.id.single_preview_video_L);
        ImageView single_preview_voice = mView.findViewById(R.id.single_preview_voice);
        ImageView single_preview_voice_L = mView.findViewById(R.id.single_preview_voice_L);
        single_preview_video.setEnabled(sleepViewStatus);
        single_preview_video_L.setEnabled(sleepViewStatus);
        single_preview_voice.setEnabled(sleepViewStatus);
        single_preview_voice_L.setEnabled(sleepViewStatus);
        mView.findViewById(R.id.single_preview_camera).setEnabled(sleepViewStatus);
        mView.findViewById(R.id.single_preview_camera_L).setEnabled(sleepViewStatus);
        mVideoPlayCallback.getRightView().setEnabled(sleepViewStatus);
        if (!sleepViewStatus) {
            this.mRecordVoiceImg.setImageResource(R.mipmap.ic_pronunciation_e);
            this.mRecordVoiceImg_L.setImageResource(R.mipmap.ic_pronunciation_e);
            single_preview_video.setImageResource(R.mipmap.ic_rec_video_e);
            single_preview_video_L.setImageResource(R.mipmap.ic_rec_video_e);
            single_preview_voice.setImageResource(R.mipmap.ic_voice_e);
            single_preview_voice_L.setImageResource(R.mipmap.ic_voice_e);
            mVideoView.setEnabled(false);
            mPlayBtn_L.setEnabled(false);
            mPlayBtn.setEnabled(false);
            changePlayStatus_L(false);
            mView.findViewById(R.id.single_play_song).setEnabled(false);
            mView.findViewById(R.id.layout_single_play_song_L).setEnabled(false);
        } else {
            this.mRecordVoiceImg.setImageResource(R.mipmap.ic_pronunciation_n);
            this.mRecordVoiceImg_L.setImageResource(R.mipmap.ic_pronunciation_n);
            single_preview_video.setImageResource(R.mipmap.ic_rec_video_n);
            single_preview_video_L.setImageResource(R.mipmap.ic_rec_video_n);
            single_preview_voice.setImageResource(R.mipmap.ic_voice_y);
            single_preview_voice_L.setImageResource(R.mipmap.ic_voice_y);
            mVideoView.setEnabled(true);
            mPlayBtn_L.setEnabled(true);
            mPlayBtn.setEnabled(true);
            mView.findViewById(R.id.single_play_song).setEnabled(true);
            mView.findViewById(R.id.layout_single_play_song_L).setEnabled(true);
        }
    }

    @Override
    public void changeSleepType(final SleepMethmodInfo info) {
        if (mPopupWindow != null) {
            mPopupWindow.dismiss();
        }
        if (info.getType().equals("time")) {
            if (this.mTimeInfos == null || this.mTimeInfos.size() == 0) {
                if (mTimeDlg == null) {
                    mTimeDlg = showDlg(getActivity(), getString(R.string.time_close), getString(R.string.no_timw_setiting),
                            getString(R.string.go_setting), mTimePositive,
                            getString(R.string.cancel), negetiveClick, false);
                }
                mTimeDlg.show();
                return;
            }
        } else if (info.getType().equals(CameraSleepType.SLEEP_GEOGRAPHIC)) {
            return;
        }
        if (mVideoPlayCallback.getCameraPlayer() != null) {
            final SleepMethmodInfo curInfo = (SleepMethmodInfo) mView.findViewById(R.id.btn_sleep).getTag();
            setSleepView(info);
            mVideoPlayCallback.getCameraPlayer().setCameraSleepType(info.getType(), new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    if (mEventHandler == null)
                        return;
                    mCameraInfo.setSleep(info.getType());
                    mEventHandler.sendEmptyMessage(MESSAGE_SETTING_SLEEP_SUCCESS);
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (mEventHandler != null) {
                        Message msg = new Message();
                        msg.what = MESSAGE_SETTING_SLEEP_FAILED;
                        msg.obj = curInfo;
                        mEventHandler.sendMessage(msg);
                    }
                }
            });
        }
    }

    public DialogInterface.OnClickListener negetiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            if (mPopupWindow != null)
                mPopupWindow.dismiss();
        }
    };
    public DialogInterface.OnClickListener mTimePositive = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            onSleepClick();
            dialog.dismiss();

        }
    };


    private class MoveGestureListener extends GestureDetector.SimpleOnGestureListener {
        @Override
        public boolean onSingleTapUp(MotionEvent ev) {
            return true;
        }

        @Override
        public void onShowPress(MotionEvent ev) {
            Log.d("onShowPress", ev.toString());
        }

        @Override
        public void onLongPress(MotionEvent ev) {
            Log.d("onLongPress", ev.toString());
        }

        @Override
        public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
            if (MODE != 0)
                return true;
            if (mVideoPlayCallback != null && mVideoPlayCallback.getCameraPlayer() != null) {
                mVideoPlayCallback.getCameraPlayer().move2(0 - distanceX, distanceY, CameraPlayer.PLAY_MODE);
            }
            return true;
        }

        @Override
        public boolean onDown(MotionEvent ev) {
            return true;
        }

        @Override
        public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
            return true;
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (getBitRateHandler != null && getBitRateRunnable != null)
            getBitRateHandler.removeCallbacks(getBitRateRunnable);
        if (mTemperHumidityHandler != null)
            mTemperHumidityHandler.removeCallbacks(mTemperatureHumidityRunnable);
        mfinish = true;
    }

    public CustomDialog showDlg(Context context, String title, String message, String positiveBtnName,
                                DialogInterface.OnClickListener positiveListener, String NegativeBtnName,
                                DialogInterface.OnClickListener negativeListener, boolean bCance) {
        try {
            CustomDialog.Builder localBuilder = new CustomDialog.Builder(context);
            localBuilder.setTitle(title).setMessage(message);
            localBuilder.setPositiveResouce(R.drawable.shape_big_common_yellow);
            localBuilder.setNegativeResouce(R.drawable.shape_yellow);
            if (positiveBtnName != null)
                localBuilder.setPositiveButton(positiveBtnName, positiveListener);
            if (NegativeBtnName != null)
                localBuilder.setNegativeButton(NegativeBtnName, negativeListener);
            CustomDialog dlg = localBuilder.create();
            dlg.setCancelable(bCance);
            dlg.setCanceledOnTouchOutside(bCance);

            return dlg;
        } catch (Exception e) {
            return null;
        }
    }


    private boolean isSinglePointer = false;
    private GestureDetector mGestureDetector;
    private boolean mIsChangeTabPlay;
    private boolean isMoveCamera;

    @SuppressLint("ClickableViewAccessibility")
    private void initVideoViewDetector() {
        mGestureDetector = new GestureDetector(mVideoView.getContext(), mSimpleOnGestureListener);
        mVideoView.setOnTouchListener(new OnTouchListener() {
            @Override
            @SuppressLint("ClickableViewAccessibility")
            public boolean onTouch(View v, MotionEvent ev) {
                mVideoPlayCallback.getViewPage().requestDisallowInterceptTouchEvent(true);
                boolean handled = true;
                {
                    ViewParent parent = v.getParent();
                    switch (ev.getAction()) {
                        case ACTION_DOWN:
                            isSinglePointer = ev.getPointerCount() == 1;
                            parent.requestDisallowInterceptTouchEvent(true);
                            mVideoPlayCallback.getViewPage().requestDisallowInterceptTouchEvent(true);
                            break;
                        case ACTION_CANCEL:
                        case ACTION_UP:
                            stopCamera();
                            isSinglePointer = false;
                            if (mScale <= 1) {
                                handled = true;
                            }
                            break;
                    }
                }
                mScaleGestureDetector.onTouchEvent(ev);
                mGestureDetector.onTouchEvent(ev);
                return handled;
            }
        });
    }

    private OnGestureListener mOnGestureListener = new OnGestureListener() {
        @Override
        public void onDrag(float dx, float dy) {

        }

        @Override
        public void onFling(float startX, float startY, float velocityX, float velocityY) {

        }

        @Override
        public void onScale(float scaleFactor, float focusX, float focusY) {

        }
    };
    private GestureDetector.SimpleOnGestureListener mSimpleOnGestureListener = new GestureDetector.SimpleOnGestureListener() {
        @Override
        public boolean onSingleTapConfirmed(MotionEvent e) {
            if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
                boolean isShow = mHorToolsBar.getVisibility() == View.VISIBLE ? true : false;
                if (isShow) {
                    mHorToolsBar.setVisibility(View.GONE);
                    mVideoTypeTools.setVisibility(View.GONE);
                } else {
                    mHorToolsBar.setVisibility(View.VISIBLE);
                    mVideoTypeTools.setVisibility(View.VISIBLE);
                }
            } else {
                //from puLan:竖屏状态下要显示操作条
                boolean isShow = rl_tool.getVisibility() == View.VISIBLE ? true : false;
                if (isShow) {
                    rl_tool.setVisibility(GONE);
                } else {
                    rl_tool.setVisibility(View.VISIBLE);
                }
            }
            return true;
        }

        /**
         * @param e1
         * @param e2
         * @param distanceX
         * @param distanceY
         * @return
         */
        @Override
        public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
            mHorToolsBar.setVisibility(View.GONE);
            mVideoTypeTools.setVisibility(View.GONE);
            if (!isSinglePointer)
                return true;
            int count = e2.getPointerCount();
            if (mScale == 1 && count == 1)
                moveCamera(e2.getX() - e1.getX(), e2.getY() - e1.getY());
            else {
                if (mVideoPlayCallback != null && mVideoPlayCallback.getCameraPlayer() != null) {
                    mVideoPlayCallback.getCameraPlayer().move2(0 - distanceX, distanceY, CameraPlayer.PLAY_MODE);
                }
                return true;
            }
            return super.onScroll(e1, e2, distanceX, distanceY);
        }
    };
    public void setCameraInfo(CameraInfo info) {
        this.mCameraInfo = info;
    }
    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof VideoPlayCallback)
            mVideoPlayCallback = (VideoPlayCallback) context;
    }
}
