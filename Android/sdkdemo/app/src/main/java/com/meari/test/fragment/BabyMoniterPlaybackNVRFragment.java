package com.meari.test.fragment;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.AlarmMessageTime;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.R;
import com.meari.test.SingleVideoActivity;
import com.meari.test.adapter.AlarmRecyclerAdapter;
import com.meari.test.common.Constant;
import com.meari.test.common.VideoPlayCallback;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.Logger;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.CalendarDialog;
import com.meari.test.widget.CalendarView;
import com.meari.test.widget.LoadingView;
import com.meari.test.widget.ScaleView;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;
import com.ppstrong.ppsplayer.CameraPlayerVideoSeekListener;
import com.ppstrong.ppsplayer.CameraPlayerVideoStopListener;
import com.ppstrong.ppsplayer.PPSGLSurfaceView;

import org.json.JSONException;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Queue;
import java.util.TimeZone;
import java.util.concurrent.LinkedBlockingQueue;

import static android.view.View.GONE;

/**
 * 单路视频播放
 * Created by chengjianjia on 2015/12/22.
 */
public class BabyMoniterPlaybackNVRFragment extends VideoFragment implements CalendarDialog.CalendarDayInterface, AlarmRecyclerAdapter.VideoEventImplement {

    private String TAG = "SingleVideoPlaybackSDFragment";
    private final int MESSAGE_CONNECT_SUCCESS = 998;
    private final int MESSAGE_LOGIN_FAILED = 999;
    private final int MESSAGE_PLAY_SUCCESS = 1001;
    private final int MESSAGE_PLAY_FAILED = 1002;
    private final int MESSAGE_PLAY_STOP = 1003;
    private final int MESSAGE_GET_RECORD_LIST_SUCCESS = 1004;
    private final int MESSAGE_GET_RECORD_LIST_FAILED = 1005;
    private final int MESSAGE_RECORD_SAVE_SUCCESS = 1006;
    private final int MESSAGE_RECORD_SAVE_FAILED = 1007;
    private final int MESSAGE_RECORD_FAILED = 1008;
    private final int MESSAGE_RECORD_VIDEO_START = 1009;
    private final int MESSAGE_SNAP_SUCCESS = 1010;
    private final int HANDLER_MSG_SEARCH_DAY = 1011;
    private final int MESSAGE_GET_DAYS_MONTH = 1012;
    private final int MESSAGE_SEEK_SUCCESS = 1013;
    private final int MESSAGE_SEEK_FAILED = 1014;
    private final int MESSAGE_GET_DAYS_MONTH_FAILED = 1015;
    private final int HANDLER_MSG_EVENT_SCALE = 1016;
    private final int MESSAGE_CHANGE_RECORD_LIST_SUCCESS = 1017;
    private final int MESSAGE_SLEEP = 1018;
    private final int MESSAGE_SLEEP_STOP = 1023;
    private final int MESSAGE_PAUSE_SUCCESS = 1019;
    private final int MESSAGE_PAUSE_FAILED = 1020;
    private final int MESSAGE_ONRESUME_SUCCESS = 1021;
    private final int MESSAGE_ONRESUME_FAILED = 1022;
    private final int MESSAGE_SNAP_FAILED = 1024;
    private final int MESSAGE_PLAYING = 1025;
    private CameraInfo mCameraInfo;
    private String mTime;
    private int mYear;
    private int mMonth;
    private int mDay;
    private int mHour;
    private int mMinute;
    private int mSecond;
    private boolean mIsNeedInitProgress = false;
    private View mView;
    private LoadingView mLoadingView;
    private boolean mBMsgPlay;
    private ImageView mRecordVideoImg;
    private ImageView mVoiceImg;
    private ImageView mRecordVideoImg_L;
    private ImageView mVoiceImg_L;
    private ImageView mPauseImg;
    private ImageView mPauseImg_L;
    private View mFreshBtn;
    private View mVideoViewLayout;
    private View mView_REC;
    private PPSGLSurfaceView mVideoView;
    private List<AlarmMessageTime> mVideoRecordList;
    private ScaleView mScaleView;
    private boolean bFirstPlay = true;
    private boolean isNotFirstCome;
    private View mHorToolsBar;
    private Animation mAnimation;
    private CalendarDialog mCalendarDialog;
    private CameraPlayer mCurplayer;
    private boolean mIsBackground;
    private AlarmRecyclerAdapter mAdapter;
    private RecyclerView mEventRecyclerView;
    private LinearLayoutManager mLinearLayoutManager;
    private boolean move;
    private int mIndex;
    private int ADVANCE_SECOND = 10;
    /**
     * 0 preview, 1 SD or NVR playback 2Cloud playback
     */
    private int mConnectStatus = -1;
    private int mChangeYear;
    private int mChangeMonth;
    private int mChangeDay;
    private int mChangeHour;
    private int mChangeMin;
    private int mChangeSec;
    private boolean mCanChangeProgress = false;
    private Queue<String> mSeekQueue = new LinkedBlockingQueue<>();
    private boolean isSeeking = false;
    private boolean mIsPause;

    //From puLan:门铃添加
    RelativeLayout rl_tool;//竖屏状态下的操作条
    ImageView iv_full;//竖屏状态下的全屏按钮
    ImageView iv_full_L;//横屏状态下的全屏按钮
    private boolean isStop;

    public static BabyMoniterPlaybackNVRFragment newInstance(String time, CameraInfo cameraInfo, VideoPlayCallback videoPlayCallback) {
        BabyMoniterPlaybackNVRFragment fragment = new BabyMoniterPlaybackNVRFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", cameraInfo);
        bundle.putString("time", time);
        fragment.setVideoPlayCallback(videoPlayCallback);
        fragment.setArguments(bundle);
        return fragment;
    }

    public void setVideoPlayCallback(VideoPlayCallback videoPlayCallback) {
        this.mVideoPlayCallback = videoPlayCallback;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View fragmentView = inflater.inflate(R.layout.fragment_baby_sd, container, false);
        initData();
        initView(fragmentView);
        return fragmentView;
    }

    public void setCameraInfo(CameraInfo info) {
        this.mCameraInfo = info;
    }
    /**
     * connect ipc
     * params: cameraInfo.uuid ,camerainfo.name("admin"),mCameraInfo.hostkry ,callback
     */
    private void connectCamera() {
        this.mConnectStatus = 0;
        if (mCurplayer == null) {
            mCurplayer = new CameraPlayer();
            mCurplayer.setCameraInfo(mCameraInfo);
        }
        this.mCurplayer.connectIPC2(CommonUtils.getCameraString(mCameraInfo) , new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (getActivity() == null || getActivity().isFinishing())
                    return;
                mConnectStatus = 1;
                mEventHandler.sendEmptyMessage(MESSAGE_CONNECT_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (getActivity() == null || getActivity().isFinishing())
                    return;
                mConnectStatus = -2;
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
        });
    }

    /**
     * init data
     */
    private void initData() {
        if (mVideoPlayCallback == null) {
            getActivity().finish();
            return;
        }
        mCameraInfo = (CameraInfo) getArguments().getSerializable("cameraInfo");
        this.mTime = getArguments().getString("time");
        if (this.mTime == null || this.mTime.length() == 0) {
            Calendar calendar = Calendar.getInstance();
            this.mYear = calendar.get(Calendar.YEAR);
            this.mMonth = calendar.get(Calendar.MONTH) + 1;
            this.mDay = calendar.get(Calendar.DAY_OF_MONTH);
            this.mHour = calendar.get(Calendar.HOUR);
            this.mMinute = calendar.get(Calendar.MINUTE);
            this.mSecond = calendar.get(Calendar.SECOND);
            this.mIsNeedInitProgress = false;
        } else {
            initTime(mTime);
            this.mBMsgPlay = true;
        }
        // 创建手势检测器
    }

    private void initCameraInfo() {
        mCameraInfo = (CameraInfo) getArguments().getSerializable("cameraInfo");
    }

    /*
        *初始化时间
         */
    public void initTime(String time) {
        //20160202121212
        String newTimeStr = time.replace(" ", "");
        newTimeStr = newTimeStr.replace("-", "");
        newTimeStr = newTimeStr.replace(":", "");
        this.mYear = Integer.valueOf(newTimeStr.substring(0, 4));
        this.mMonth = Integer.valueOf(newTimeStr.substring(4, 6));
        this.mDay = Integer.valueOf(newTimeStr.substring(6, 8));
        this.mHour = Integer.valueOf(newTimeStr.substring(8, 10));
        this.mMinute = Integer.valueOf(newTimeStr.substring(10, 12));
        this.mSecond = Integer.valueOf(newTimeStr.substring(12, 14));
    }

    /**
     * init UI
     */
    private void initView(View fragmentView) {
        this.mLoadingView = (LoadingView) fragmentView.findViewById(R.id.single_playback_waite_dialog);
        this.mLoadingView.init(true);
        this.mLoadingView.setVisibility(View.VISIBLE);
        this.mRecordVideoImg = (ImageView) fragmentView.findViewById(R.id.single_playback_video);
        this.mHorToolsBar = fragmentView.findViewById(R.id.single_playback_tool_bottom);
        this.mRecordVideoImg_L = (ImageView) fragmentView.findViewById(R.id.single_playback_video_L);
        this.mPauseImg = (ImageView) fragmentView.findViewById(R.id.single_playback_pause);
        this.mPauseImg_L = (ImageView) fragmentView.findViewById(R.id.single_playback_pause_L);
        this.mVoiceImg = (ImageView) fragmentView.findViewById(R.id.single_playback_voice);
        this.mVoiceImg_L = (ImageView) fragmentView.findViewById(R.id.single_playback_voice_L);
        this.mFreshBtn = (ImageView) fragmentView.findViewById(R.id.single_playback_imgBtn_refresh);
        this.mView_REC = fragmentView.findViewById(R.id.single_playback_ll_REC);
        this.mVideoViewLayout = fragmentView.findViewById(R.id.view_single_playback);
        initConfiguration(getResources().getConfiguration().orientation);
        mRecordVideoImg.setOnClickListener(this);
        mRecordVideoImg_L.setOnClickListener(this);
        mPauseImg.setOnClickListener(this);
        mPauseImg_L.setOnClickListener(this);
        mVoiceImg.setOnClickListener(this);
        mVoiceImg_L.setOnClickListener(this);
        fragmentView.findViewById(R.id.single_playback_camera).setOnClickListener(this);
        fragmentView.findViewById(R.id.single_playback_camera_L).setOnClickListener(this);
        mFreshBtn.setOnClickListener(this);
        fragmentView.findViewById(R.id.single_playback_calendar).setOnClickListener(this);
        fragmentView.findViewById(R.id.single_playback_calendar_L).setOnClickListener(this);
        initAnimation();
        setRecodeVideoview(false);
        setPauseView(true);
        if (mCurplayer == null)
            setEnabledVoice(false);
        else {
            if (mCurplayer != null)
                setEnabledVoice(mCurplayer.IsPlaybackMuted());
        }
        setPauseView(false);
        initVideoView(fragmentView);
        initScaleView(fragmentView);
        initRecyclerView(fragmentView);
        this.mView = fragmentView;

        //门铃添加
        //全屏的布局
        this.rl_tool = (RelativeLayout) fragmentView.findViewById(R.id.rl_tool);
        this.iv_full = (ImageView) fragmentView.findViewById(R.id.iv_full);
        this.iv_full.setOnClickListener(this);
        this.iv_full_L = (ImageView) fragmentView.findViewById(R.id.iv_full_L);
        this.iv_full_L.setOnClickListener(this);
    }

    private void initRecyclerView(View fragmentView) {
        this.mEventRecyclerView = (RecyclerView) fragmentView.findViewById(R.id.time_event_recycler);
        mLinearLayoutManager = new LinearLayoutManager(getActivity());
        mLinearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mEventRecyclerView.setLayoutManager(mLinearLayoutManager);
        mAdapter = new AlarmRecyclerAdapter(getActivity(), this);
        mEventRecyclerView.setAdapter(mAdapter);
        mEventRecyclerView.addOnScrollListener(new RecyclerViewListener());
        if (mBMsgPlay) {
            AlarmMessageTime info = new AlarmMessageTime();
            info.StartHour = mHour;
            info.StartMinute = mMinute;
            info.StartSecond = mSecond;
            mAdapter.setSelectVideoRec(info);
        }
    }

    /**
     * the animation of recview
     */
    private void initAnimation() {
        this.mAnimation = new AlphaAnimation(1.0f, 0.0f);
        mAnimation.setDuration(300);
        mAnimation.setRepeatCount(Animation.INFINITE);
        mAnimation.setRepeatMode(Animation.REVERSE);
    }

    /**
     * 初始化刻度尺
     */
    private void initScaleView(View fragmentView) {
        this.mVideoRecordList = new ArrayList<>();
        this.mScaleView = (ScaleView) fragmentView.findViewById(R.id.single_playback_scale);
        mScaleView.init();
        TextView txTime = (TextView) fragmentView.findViewById(R.id.scale_time);
        txTime.setVisibility(View.INVISIBLE);
        mScaleView.setTextView(txTime);
        mScaleView.setPaintColor(R.color.com_yellow);
        mScaleView.setOnScaleTouchListener(onScaleTouchListener);
        if (mIsNeedInitProgress) {
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    mScaleView.setTimeProgrogress(mHour, mMinute, mSecond);
                }
            }, 500);
        }

    }

    private void initConfiguration(int orientation) {
        initVideoViewSize(orientation);
    }

    private void initVideoViewSize(int orientation) {
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) mVideoViewLayout.getLayoutParams();
        if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            params.width = Constant.height;
            params.height = Constant.width;
        } else {
            params.width = Constant.width;
            params.height = Constant.width * 9 / 16;
        }
        mVideoViewLayout.setLayoutParams(params);
    }

    /**
     * init videoView
     */
    private void initVideoView(View fragmentView) {
        LinearLayout videoViewContainer = (LinearLayout) fragmentView.findViewById(R.id.single_playback_videoView);
        mVideoView = new PPSGLSurfaceView(getActivity(), Constant.width, Constant.height);
        videoViewContainer.addView(mVideoView);
        LinearLayout.LayoutParams videoViewParams = (LinearLayout.LayoutParams) mVideoView.getLayoutParams();
        videoViewParams.height = LinearLayout.LayoutParams.MATCH_PARENT;
        videoViewParams.width = LinearLayout.LayoutParams.MATCH_PARENT;
        mVideoView.setLayoutParams(videoViewParams);
        mVideoView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
                    boolean isShow = mHorToolsBar.getVisibility() == View.VISIBLE ? true : false;
                    if (isShow) {
                        mHorToolsBar.setVisibility(View.GONE);
                    } else {
                        mHorToolsBar.setVisibility(View.VISIBLE);
                    }
                } else {
                    //竖屏状态下点击事件
                    //显示全屏按钮
                    boolean flag = rl_tool.getVisibility() == View.VISIBLE ? true : false;
                    if (flag) {
                        rl_tool.setVisibility(View.GONE);
                    } else {
                        rl_tool.setVisibility(View.VISIBLE);
                    }
                }
            }
        });
    }

    private boolean mPullScaleView;
    /**
     * 刻度尺事件监听
     */
    private ScaleView.OnScaleTouchListener onScaleTouchListener = new ScaleView.OnScaleTouchListener() {
        @Override
        public void onChange() {
            mPullScaleView = true;
        }

        @Override
        public void onFinish(int hour, int minute, int second) {
            mPullScaleView = false;
            if (isExistFormVideoRecordList(hour, minute, second)) {
                if (mCurplayer == null) {
                    return;
                }
                mHour = hour;
                mMinute = minute;
                mSecond = second;
                seekVideo(false);
            } else {
                boolean bpasue = (boolean) mPauseImg.getTag();
                if (bpasue) {
                    CommonUtils.showToast(R.string.no_records_exists);
                } else {
                    setPauseView(true);
                    if (mCurplayer != null)
                        mCurplayer.ppspausePlayback();
                    getPlayTimeHandler.removeCallbacks(getPlayTimeRunnable);
                    mCanChangeProgress = false;

                }
            }
        }
    };

    private void seekVideo(boolean changeDate) {
        mFreshBtn.setVisibility(View.GONE);
        mLoadingView.setVisibility(View.VISIBLE);
        String seekTime = "";
        if (changeDate) {
            seekTime = String.format("%04d%02d%02d%02d%02d%02d", mChangeYear, mChangeMonth, mChangeDay, mChangeHour, mChangeHour, mSecond);
        } else {
            seekTime = String.format("%04d%02d%02d%02d%02d%02d", mYear, mMonth, mDay, mHour, mMinute, mSecond);
        }
        postSeekData(seekTime);
        stopVideoRecord();
    }

    private void postSeekData(String seektime) {
        if (mEventHandler == null)
            return;
        if (isSeeking == false) {
            isSeeking = true;
            mCurplayer.sendPlaybackCmd(CameraPlayer.SD_PLAYBACK_SEEK, seektime, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    if (mEventHandler == null)
                        return;
                    isSeeking = false;
                    getPlayTimeHandler.removeCallbacks(getPlayTimeRunnable);
                    getPlayTimeHandler.postDelayed(getPlayTimeRunnable, 5000);
                    getPlayTimeHandler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            if (getActivity() == null || getActivity().isFinishing())
                                return;
                            mCanChangeProgress = true;
                        }
                    }, 4000);
                    mEventHandler.sendEmptyMessage(MESSAGE_SEEK_SUCCESS);
                    String seektime = mSeekQueue.poll();
                    if (seektime != null)
                        postSeekData(seektime);

                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (mEventHandler == null)
                        return;
                    mEventHandler.sendEmptyMessage(MESSAGE_SEEK_FAILED);
                    isSeeking = false;
                    String seektime = mSeekQueue.poll();
                    if (seektime != null)
                        postSeekData(seektime);
                }
            }, new CameraPlayerVideoSeekListener() {
                @Override
                public void onCameraPlayerVideoSeek() {
                }
            }, true);
        } else {
            mSeekQueue.clear();
            mSeekQueue.add(seektime);
        }
    }

    /**
     * 判断某个时间点在多个时间段里是否存在视频
     *
     * @param hour
     * @param minute
     * @param second
     */
    private boolean isExistFormVideoRecordList(int hour, int minute, int second) {
        for (int i = 0; i < this.mVideoRecordList.size(); i++) {
            if (mVideoRecordList.get(i).StartHour > hour && mVideoRecordList.get(i).EndHour < hour) {
                // 简单判断，一定有视频
                return true;
            } else {
                if (isExistForAlarmMessageTime(mVideoRecordList.get(i), hour, minute, second)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 判断某个时间点在某个时间段里是否存在视频
     *
     * @param AlarmMessageTime
     * @param hour
     * @param minute
     * @param second
     */
    private boolean isExistForAlarmMessageTime(AlarmMessageTime AlarmMessageTime, int hour, int minute, int second) {
        int startTime = getSecond(AlarmMessageTime.StartHour, AlarmMessageTime.StartMinute, AlarmMessageTime.StartSecond);
        int endTime = getSecond(AlarmMessageTime.EndHour, AlarmMessageTime.EndMinute, AlarmMessageTime.EndSecond);
        int currentTime = getSecond(hour, minute, second);
        if (currentTime >= startTime && currentTime <= endTime) {
            return true;
        }
        return false;
    }

    @Override
    public void SearchVideoByMonth(int year, int month) {
        getDayOfMonth(year, month);
    }

    @Override
    public ArrayList<Integer> getDaysOfMonth(int year, int month) {
        ArrayList<Integer> days = mVideoDays.get(String.format(("%04d%02d"), year, month));
        return days;
    }

    public void closeFragment() {
        mView.findViewById(R.id.single_playback_videoView).setVisibility(View.GONE);
//        if (mCurplayer != null)
//            mCurplayer.stopRecordPlay();
        if (mCurplayer != null && mCurplayer.getCameraInfo() != null) {
            mCurplayer.disconnectIPC(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                }

                @Override
                public void PPFailureError(String errorMsg) {
                }
            });
        }
        mCurplayer = null;
    }

    /**
     * 获取秒数
     *
     * @param hour
     * @param minute
     * @param second
     */
    private int getSecond(int hour, int minute, int second) {
        return hour * 3600 + minute * 60 + second;
    }

    /**
     * 回放视频
     *
     * @param changeDate
     */
    public void playVideo(boolean changeDate) {
        if (NetUtil.checkNet(getActivity())) {
            bFirstPlay = false;
            videoViewStatus(SingleVideoActivity.STATUS_LOADING);
            if (changeDate) {
                String playtime = String.format("%04d%02d%02d%02d%02d%02d", mChangeYear, mChangeMonth, mChangeDay, mChangeHour, mChangeMin, mChangeSec);
                mCurplayer.startPlaybackSd(mVideoView, playtime, mPlayListener, mStopPlayListener, Integer.valueOf(mCameraInfo.getSnNum()));
                stopVideoRecord();
            } else {
                String playtime = String.format("%04d%02d%02d%02d%02d%02d", mYear, mMonth, mDay, mHour, mMinute, mSecond);
                mCurplayer.startPlaybackSd(mVideoView, playtime, mPlayListener, mStopPlayListener, Integer.valueOf(mCameraInfo.getSnNum()));
                stopVideoRecord();
            }
        } else {
            videoViewStatus(SingleVideoActivity.STATUS_REFRESH);
            CommonUtils.showToast(getString(R.string.network_unavailable));
        }
    }

    @Override
    public void videoViewStatus(int index) {
        super.videoViewStatus(index);
        switch (index) {
            case SingleVideoActivity.STATUS_LOADING:// 加载
                if (mView != null) {
                    mView.findViewById(R.id.single_playback_imgBtn_refresh).setVisibility(View.GONE);
                    mLoadingView.setVisibility(View.VISIBLE);
                }
                break;
            case SingleVideoActivity.STATUS_REFRESH: // 刷新
                if (mView != null) {
                    mView.findViewById(R.id.single_playback_imgBtn_refresh).setVisibility(View.VISIBLE);
                    mLoadingView.setVisibility(View.GONE);
                }
                break;
            case SingleVideoActivity.STATUS_PLAY: // ready to play
                if (mView == null) {
                    return;
                }
                getDayOfMonth(mYear, mMonth);
                getVideoRecordByDay(mYear, mMonth, mDay);
                break;
            case SingleVideoActivity.STATUS_PLAYING: // playing
                mFreshBtn.setVisibility(View.GONE);
                mLoadingView.setVisibility(View.GONE);
                setPauseView(false);
                break;
            case SingleVideoActivity.STATUS_NONE: // playing
                mFreshBtn.setVisibility(View.GONE);
                mLoadingView.setVisibility(View.GONE);
                break;
            default:
                break;
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
    }

    private CameraPlayerVideoStopListener mStopPlayListener = new CameraPlayerVideoStopListener() {

        @Override
        public void onCameraPlayerVideoClosed(int errorcode) {
            if (mEventHandler == null)
                return;
            else {
                if (errorcode == 6 || errorcode == 7 || errorcode == 8)
                    mEventHandler.sendEmptyMessage(MESSAGE_SLEEP);
                else if (errorcode == 9) {
                    mEventHandler.sendEmptyMessage(MESSAGE_SLEEP_STOP);
                } else if (errorcode == 3) {
                    mEventHandler.sendEmptyMessage(MESSAGE_PLAY_STOP);
                } else if (errorcode == 10) {
                    mEventHandler.sendEmptyMessage(MESSAGE_PLAYING);
                }
            }
        }

    };
    private CameraPlayerListener mPlayListener = new CameraPlayerListener() {
        @Override
        public void PPSuccessHandler(String successMsg) {
            if (mEventHandler == null)
                return;
            mEventHandler.sendEmptyMessage(MESSAGE_PLAY_SUCCESS);

        }

        @Override
        public void PPFailureError(String errorMsg) {
            if (mEventHandler != null) {
                Message msg = new Message();
                msg.what = MESSAGE_PLAY_FAILED;
                msg.obj = errorMsg;
                mEventHandler.sendMessage(msg);
            }
        }
    };

    private void initVoiceStatus() {
        boolean enable = (boolean) this.mVoiceImg.getTag();
        if (mCurplayer != null)
            mCurplayer.enableMute(enable, CameraPlayer.PLAYBACK_MODE);
    }

    public void setPlayViewSuccessViwe(boolean playViewSuccessViwe) {
        if (mView == null)
            return;
        this.mLoadingView
                .setVisibility(View.GONE);
        if (playViewSuccessViwe)
            this.mFreshBtn.setVisibility(View.GONE);
        else
            this.mFreshBtn.setVisibility(View.VISIBLE);
    }

    private String mReordPath;
    private Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            if (getActivity() == null || getActivity().isFinishing())
                return;
            switch (msg.what) {
                case MESSAGE_CONNECT_SUCCESS:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    videoViewStatus(SingleVideoActivity.STATUS_PLAY);
                    break;
                case MESSAGE_LOGIN_FAILED: {
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    videoViewStatus(SingleVideoActivity.STATUS_LOGIN_FAILED);
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
                }
                break;
                case MESSAGE_PLAY_SUCCESS:
                    mVideoView.setBackgroundColor(getResources().getColor(R.color.transparent));
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    setPauseView(false);
                    initVoiceStatus();
                    refreshPlayTime();
                    break;
                case MESSAGE_PLAYING:
                    setPlayViewSuccessViwe(true);
                    break;
                case MESSAGE_PLAY_FAILED:
                    videoViewStatus(SingleVideoActivity.STATUS_REFRESH);
                    String errorMessage = (String) msg.obj;
                    try {
                        BaseJSONObject object = new BaseJSONObject(errorMessage);
                        int errorCode = object.optInt("errorcode", -1);
                        if (errorCode == -14) {
                            CommonUtils.showToast(getString(R.string.watch_failed));
                        } else {
                            CommonUtils.showToast(getString(R.string.fail));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    break;
                case MESSAGE_GET_RECORD_LIST_SUCCESS:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    String recordList = (String) msg.obj;
                    dealMessageVideoListDate(recordList, false);
                    if (mVideoRecordList.size() > 0)
                        postEventTime(mYear, mMonth, mDay);
                    else {
                        CommonUtils.showToast(getString(R.string.no_records_exists));
                        videoViewStatus(SingleVideoActivity.STATUS_NONE);
                    }
                    break;
                case MESSAGE_CHANGE_RECORD_LIST_SUCCESS:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    String recordVideoList = (String) msg.obj;
                    dealMessageVideoListDate(recordVideoList, true);
                    postEventTime(mChangeYear, mChangeMonth, mChangeDay);
                    break;
                case MESSAGE_GET_RECORD_LIST_FAILED:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    videoViewStatus(SingleVideoActivity.STATUS_REFRESH);
                    if (mVideoRecordList == null || mVideoRecordList.size() <= 0)
                        CommonUtils.showToast(getString(R.string.no_records_exists));
                    break;
                case MESSAGE_RECORD_SAVE_SUCCESS:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    setRecodeVideoview(false);
                    mView_REC.clearAnimation();
                    mView_REC.setVisibility(View.GONE);
                    CommonUtils.showToast(getString(R.string.record_save) + mReordPath);
                    break;
                case MESSAGE_RECORD_SAVE_FAILED:
                    if (getActivity() == null || getActivity().isFinishing()) {
                        return;
                    }
                    //删除本地录制的文件
                    File saveFailedFile = new File(mReordPath);
                    if (saveFailedFile.exists()) {
                        //删除本地无效文件
                        Logger.i(TAG, "录制视频太短，删除之!");
                        saveFailedFile.delete();
                    }
                    setRecodeVideoview(false);
                    mView_REC.clearAnimation();
                    mView_REC.setVisibility(View.GONE);
                    CommonUtils.showToast(getString(R.string.record_fail));
                    break;
                case MESSAGE_RECORD_FAILED:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    setRecodeVideoview(false);
                    mView_REC.clearAnimation();
                    mView_REC.setVisibility(View.GONE);
                    //删除本地录制的文件
                    File shortFile = new File(mReordPath);
                    if (shortFile.exists()) {
                        //删除本地无效文件
                        Logger.i(TAG, "录制视频太短，删除之!");
                        shortFile.delete();
                    }
                    int type = (int) msg.obj;
                    if (type == 0)
                        CommonUtils.showToast(getString(R.string.record_fail));
                    break;
                case MESSAGE_RECORD_VIDEO_START:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    showRecordView();
                    break;
                case R.id.single_playback_voice:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    onVoiceStatusClick();
                    break;
                case R.id.single_playback_voice_L:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    onVoiceStatusClick();
                    break;
                case MESSAGE_SNAP_SUCCESS:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
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
                case HANDLER_MSG_SEARCH_DAY:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    if (mCalendarDialog != null) {
                        mCalendarDialog.hide();
                    }
                    searchVideo((Date) msg.obj);
                    break;
                case MESSAGE_SEEK_SUCCESS:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    videoViewStatus(SingleVideoActivity.STATUS_PLAYING);
                    break;
                case MESSAGE_GET_DAYS_MONTH_FAILED:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    CommonUtils.showToast(R.string.no_sd_records_exists);
                    break;
                case HANDLER_MSG_EVENT_SCALE:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    if (!mPullScaleView)
                        mScaleView.setTimeProgrogress(mHour, mMinute, mSecond);
                    Log.v("mScaleView", String.format("%04d-%02d-%02d %02d:%02d:%02d", mYear, mMonth, mDay, mHour, mMinute, mSecond));
                    mLoadingView.setVisibility(View.GONE);
                    break;
                case MESSAGE_SEEK_FAILED:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    videoViewStatus(SingleVideoActivity.STATUS_PLAYING);
                    break;
                case MESSAGE_SLEEP:
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    if (mView.findViewById(R.id.text_sleep) != null)
                        mView.findViewById(R.id.text_sleep).setVisibility(View.VISIBLE);
                    videoViewStatus(SingleVideoActivity.STATUS_NONE);
                    break;
                case MESSAGE_SLEEP_STOP:
                    if (mView.findViewById(R.id.text_sleep) != null)
                        mView.findViewById(R.id.text_sleep).setVisibility(View.GONE);
                    break;
                case MESSAGE_PAUSE_FAILED:
                    break;
                case MESSAGE_PAUSE_SUCCESS:
                    setPauseView(true);
                    break;
                case MESSAGE_ONRESUME_SUCCESS:
                    setPauseView(false);
                    if (getPlayTimeHandler != null) {
                        getPlayTimeHandler.removeCallbacks(getPlayTimeRunnable);
                        getPlayTimeHandler.postDelayed(getPlayTimeRunnable, 1000);
                    }
                    break;
                case MESSAGE_ONRESUME_FAILED:
                    videoViewStatus(SingleVideoActivity.STATUS_REFRESH);
                    break;
                default:
                    break;
            }
        }


        private void refreshPlayTime() {
            if (getPlayTimeHandler == null)
                return;
            getPlayTimeHandler.removeCallbacks(getPlayTimeRunnable); // 每分钟设置一下刻度尺时间
            getPlayTimeHandler.removeCallbacks(videoDataRunnable); // 每分钟设置一下刻度尺时间
            getPlayTimeHandler.postDelayed(getPlayTimeRunnable, 1000); // 每分钟设置一下刻度尺时间
            getPlayTimeHandler.postDelayed(videoDataRunnable, 60000); // 每分钟设置一下刻度尺时间
            getPlayTimeHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    if (getActivity() == null || getActivity().isFinishing())
                        return;
                    mCanChangeProgress = true;
                }
            }, 900);
        }
    };
    /**
     * 搜索视频，是否存在视频的时间段
     */
    private Runnable videoDataRunnable = new Runnable() {
        @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public void run() {
            if (getActivity() == null || getActivity().isDestroyed() || getActivity().isFinishing()) {
                return;
            }
            if (mCurplayer != null)
                mCurplayer.searchPlaybackListOnday(mYear, mMonth, mDay, new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        if (mEventHandler == null)
                            return;
                        if (successMsg == null)
                            mEventHandler.sendEmptyMessage(MESSAGE_GET_RECORD_LIST_FAILED);
                        else {
                            Message msg = new Message();
                            msg.what = MESSAGE_GET_RECORD_LIST_SUCCESS;
                            msg.obj = successMsg;
                            mEventHandler.sendMessage(msg);
                        }
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                    }
                }, Integer.valueOf(mCameraInfo.getSnNum()));
            if (getPlayTimeHandler != null)
                getPlayTimeHandler.postDelayed(this, 60000);//每分间视频数据钟更新时

        }
    };
    /**
     * 获取播放时间
     */
    private Handler getPlayTimeHandler = new Handler();
    private Runnable getPlayTimeRunnable = new Runnable() {
        @Override
        public void run() {
            if (mCurplayer != null && mCurplayer.IsPlaybacking()) {
                int time = mCurplayer.getPlaybackTime();

                if (mCanChangeProgress) {
                    setCurrentTime(time);
                    AlarmMessageTime videoinfo = getVideoMinByTime();
                    mScaleView.setTimeProgrogress(videoinfo.StartHour, videoinfo.StartMinute, videoinfo.StartSecond);
                    mAdapter.refreshSelectVideoRec(videoinfo);
                    if (mEventHandler != null)
                        mEventHandler.sendEmptyMessage(HANDLER_MSG_EVENT_SCALE);
                }
            }
            if (getPlayTimeHandler != null)
                getPlayTimeHandler.postDelayed(getPlayTimeRunnable, 10000);
        }

    };

    public AlarmMessageTime getVideoMinByTime() {
        AlarmMessageTime timeInfo = new AlarmMessageTime();

        timeInfo.StartHour = mHour;
        timeInfo.StartMinute = mMinute;
        timeInfo.StartSecond = mSecond;
        return timeInfo;
    }

    /**
     * 设置当前时间，（临时）
     *
     * @param time
     */
    private void setCurrentTime(long time) {
        Date date;
        Calendar calendar;
        date = new Date(time * 1000);
        calendar = Calendar.getInstance();
        calendar.setTimeZone(TimeZone.getTimeZone("GMT"));
        calendar.setTime(date);
        if (calendar.get(Calendar.YEAR) < 2000) {   // 有时获取播放时间会返回0，时间回到1970年
            return;
        }
        mYear = calendar.get(Calendar.YEAR);
        mMonth = calendar.get(Calendar.MONTH) + 1;
        mDay = calendar.get(Calendar.DAY_OF_MONTH);
        mHour = calendar.get(Calendar.HOUR_OF_DAY);
        mMinute = calendar.get(Calendar.MINUTE);
        mSecond = calendar.get(Calendar.SECOND);
    }

    private void searchVideo(Date date) {
        bFirstPlay = true;
        if (date == null || mCurplayer == null) {
            return;
        }
        getPlayTimeHandler.removeCallbacks(getPlayTimeRunnable);
        mCanChangeProgress = false;
        mCurplayer.stopPlaybackSd(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
            }

            @Override
            public void PPFailureError(String errorMsg) {

            }
        });
        videoViewStatus(SingleVideoActivity.STATUS_LOADING);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        mChangeDay = day;
        mChangeMonth = month;
        mChangeYear = year;
        mDay = day;
        mMonth = month;
        mYear = year;
        mScaleView.onChangeRoughRule();
        mScaleView.cleanEventTime();
        mScaleView.cleanVideoTime();
        mAdapter.clearDaxta();
        mAdapter.notifyDataSetChanged();
        getChangeVideoRecordByDay(mChangeYear, mChangeMonth, mChangeDay);
    }

    public void getChangeVideoRecordByDay(int year, int month, int day) {
        if (mCurplayer != null)
            mCurplayer.searchPlaybackListOnday(year, month, day, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    if (mEventHandler == null)
                        return;
                    if (successMsg == null)
                        mEventHandler.sendEmptyMessage(MESSAGE_GET_RECORD_LIST_FAILED);
                    else {
                        Message msg = new Message();
                        msg.what = MESSAGE_CHANGE_RECORD_LIST_SUCCESS;
                        msg.obj = successMsg;
                        mEventHandler.sendMessage(msg);
                    }
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (mEventHandler == null)
                        return;
                    mEventHandler.sendEmptyMessage(MESSAGE_GET_RECORD_LIST_FAILED);
                }
            }, Integer.valueOf(mCameraInfo.getSnNum()));
    }

    private void onVoiceStatusClick() {
        boolean enable = (boolean) this.mVoiceImg.getTag();
        setEnabledVoice(!enable);
        if (mCurplayer != null) {
            mCurplayer.enableMute(!enable, CameraPlayer.PLAYBACK_MODE);
        }
    }

    private void showRecordView() {
        this.mView_REC.setVisibility(View.VISIBLE);
        this.mView_REC.startAnimation(mAnimation);
    }

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

    private void dealMessageVideoListDate(String recordList, final boolean changeDate) {
        ArrayList<AlarmMessageTime> videoList = getVideoRecords(recordList);
        addAlarmMessageTime(videoList, changeDate);
        if (bFirstPlay && mVideoRecordList != null && mVideoRecordList.size() > 0) {
            if (changeDate) {
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        playVideo(changeDate);
                    }
                }, 1000);
            } else {
                playVideo(changeDate);

            }

        }
    }

    private void addAlarmMessageTime(List<AlarmMessageTime> list, boolean changeDate) {
        mVideoRecordList.clear();
        mScaleView.cleanVideoTime();
        if (list == null || list.size() <= 0) {
            return;
        }
        String str = "{ ";
        for (int i = 0; i < list.size(); ++i) {
            str += "(" + list.get(i).StartHour + ":" + list.get(i).StartMinute + " " + list.get(i).EndHour + ":" + list.get(i).EndMinute + "),";
            mVideoRecordList.add(list.get(i));
        }
        Log.e("ppsdk-debuginfo", "search min" + str + "}");
        mScaleView.setVideoTime(mVideoRecordList);
        if (changeDate) {
            mChangeHour = list.get(0).StartHour;
            mChangeMin = list.get(0).StartMinute;
            mChangeSec = list.get(0).StartSecond;
            mHour = list.get(0).StartHour;
            mMinute = list.get(0).StartMinute;
            mSecond = list.get(0).StartSecond;
            mYear = mChangeYear;
            mMonth = mChangeMonth;
            mDay = mChangeDay;
            mScaleView.setTimeProgrogress(mChangeHour, mChangeMin, mChangeSec);
        }
        if (!isNotFirstCome && !this.mBMsgPlay) {
            mHour = list.get(0).StartHour;
            mMinute = list.get(0).StartMinute;
            mSecond = list.get(0).StartSecond;
            mScaleView.setTimeProgrogress(mHour, mMinute, mSecond);
            isNotFirstCome = true;
        } else {
            if (!isNotFirstCome && this.mBMsgPlay) {
                long totalsec = mHour * 3600 + mMinute * 60 + mSecond - 10;
                int hour = (int) (totalsec / 3600);
                int min = (int) ((totalsec - mHour * 3600) / 60);
                int sec = (int) (totalsec % 60);
                if (isExistFormVideoRecordList(hour, min, sec)) {
                    mHour = hour;
                    mMinute = min;
                    mSecond = sec;
                }
                if (changeDate) {
                    mChangeHour = list.get(0).StartHour;
                    mChangeMin = list.get(0).StartMinute;
                    mChangeSec = list.get(0).StartSecond;
                }
                if (changeDate) {
                    mScaleView.setTimeProgrogress(mChangeHour, mChangeMin, mChangeSec);
                } else
                    mScaleView.setTimeProgrogress(mHour, mMinute, mSecond);
            }
            isNotFirstCome = true;
        }

    }

    public ArrayList<AlarmMessageTime> getVideoRecords(String record) {
        ArrayList<AlarmMessageTime> records = new ArrayList<AlarmMessageTime>();
        try {
            BaseJSONArray jsonArry = new BaseJSONArray(record);
            for (int i = 0; i < jsonArry.length(); i++) {
                AlarmMessageTime vtr = new AlarmMessageTime();
                String str = jsonArry.get(i).toString();
                String subStr[] = str.split("-");
                if (subStr.length != 2) {
                    continue;
                }
                vtr.StartHour = Integer.parseInt(subStr[0].substring(0, 2));
                vtr.StartMinute = Integer.parseInt(subStr[0].substring(2, 4));
                vtr.StartSecond = Integer.parseInt(subStr[0].substring(4, 6));
                vtr.EndHour = Integer.parseInt(subStr[1].substring(0, 2));
                vtr.EndMinute = Integer.parseInt(subStr[1].substring(2, 4));
                vtr.EndSecond = Integer.parseInt(subStr[1].substring(4, 6));
                int startTime = vtr.StartHour * 3600 + vtr.StartMinute * 60 + vtr.StartSecond;
                int endTime = vtr.EndHour * 3600 + vtr.EndMinute * 60 + vtr.EndSecond;
                if (startTime > endTime) {
                    vtr.StartHour = 0;
                    vtr.StartMinute = 0;
                    vtr.StartSecond = 0;
                }
                records.add(vtr);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return records;
    }

    public void getVideoRecordByDay(int year, int month, int day) {
        if (mCurplayer != null)
            mCurplayer.searchPlaybackListOnday(year, month, day, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    if (mEventHandler == null)
                        return;
                    if (successMsg == null)
                        mEventHandler.sendEmptyMessage(MESSAGE_GET_RECORD_LIST_FAILED);
                    else {
                        Message msg = new Message();
                        msg.what = MESSAGE_GET_RECORD_LIST_SUCCESS;
                        msg.obj = successMsg;
                        mEventHandler.sendMessage(msg);
                    }
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (mEventHandler == null)
                        return;
                    mEventHandler.sendEmptyMessage(MESSAGE_GET_RECORD_LIST_FAILED);
                }
            }, Integer.valueOf(mCameraInfo.getSnNum()));
    }

    public void getDayOfMonth(final int year, final int month) {
        if (mCurplayer != null) {
            mCurplayer.searchPlaybackListOnMonth(year, month, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    try {
                        if (mEventHandler == null || successMsg == null)
                            return;
                        ArrayList<Integer> days = new ArrayList<>();
                        BaseJSONArray jsonArray = new BaseJSONArray(successMsg);
                        for (int i = 0; i < jsonArray.length(); i++) {
                            days.add(Integer.valueOf(jsonArray.get(i).toString()));
                        }
                        String moth = String.format("%04d%02d", year, month);
                        mVideoDays.put(moth, days);
                        if (mCalendarDialog != null)
                            mCalendarDialog.refreshVideoDay();


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    mEventHandler.sendEmptyMessage(MESSAGE_GET_DAYS_MONTH_FAILED);
                }
            }, Integer.valueOf(mCameraInfo.getSnNum()));
        }
    }

    /**
     * 搜索视频，是否存在视频的时间段
     */
    private Handler mVideoDataHandler = new Handler();
    HashMap<String, ArrayList<Integer>> mVideoDays = new HashMap<>();

    /**
     * @param newConfig Cross screen vertical screen switch
     */
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        initVideoViewSize(newConfig.orientation);
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {

        } else {
            this.mHorToolsBar.setVisibility(View.GONE);
        }
    }

    @Override
    public void onClick(View param) {
        switch (param.getId()) {
            case R.id.iv_full:
                //切换成横屏全屏状态
                getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                //隐藏自身
                this.rl_tool.setVisibility(GONE);
                break;
            case R.id.iv_full_L:
                //切换成竖屏状态
                getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                break;
            case R.id.single_playback_video:
                onRecordVideoClick();
                break;
            case R.id.single_playback_video_L:
                onRecordVideoClick();
                break;
            case R.id.single_playback_voice:
                onVoiceStatusClick();
                break;
            case R.id.single_playback_voice_L:
                onVoiceStatusClick();
                break;
            case R.id.single_playback_camera:
                onSnapshot();
                break;
            case R.id.single_playback_camera_L:
                onSnapshot();
                break;
            case R.id.single_playback_calendar:
                onalendarClick();
                break;
            case R.id.single_playback_calendar_L:
                onalendarClick();
                break;
            case R.id.single_playback_pause:
                onPauseClick();
                break;
            case R.id.single_playback_pause_L:
                onPauseClick();
                break;
            case R.id.single_playback_imgBtn_refresh:
                if (!NetUtil.checkNet(getActivity())) {
                    CommonUtils.showToast(getString(R.string.network_unavailable));
                    return;
                }
                videoViewStatus(SingleVideoActivity.STATUS_LOADING);
                connectCamera();
                break;


            default:
                break;
        }
    }

    public void onPauseClick() {
        if (mCurplayer == null) {
            return;
        }

        boolean enable = (boolean) this.mRecordVideoImg.getTag();
        if (enable) {
            onRecordVideoClick();
        }
        boolean tag = (boolean) mPauseImg.getTag();
        if (tag) {
            onResumeVideo();
        } else
            onPauseVideo();
    }

    public void onPauseVideo() {
        if (mCurplayer != null && (mCurplayer.mstatus & mCurplayer.Playbacking) == mCurplayer.Playbacking) {
            mCurplayer.sendPlaybackCmd(CameraPlayer.SD_PLAYBACK_PASUE, null, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {

                    mEventHandler.sendEmptyMessage(MESSAGE_PAUSE_SUCCESS);
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (mEventHandler == null)
                        return;
                    mEventHandler.sendEmptyMessage(MESSAGE_PAUSE_FAILED);
                }
            }, new CameraPlayerVideoSeekListener() {
                @Override
                public void onCameraPlayerVideoSeek() {
                }
            }, true);
        }
    }

    public void onResumeVideo() {
        if (mCurplayer != null && (mCurplayer.mstatus & mCurplayer.Playbacking) == mCurplayer.Playbacking) {
            mCurplayer.sendPlaybackCmd(CameraPlayer.SD_PLAYBACK_RESUME, null, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {

                    mEventHandler.sendEmptyMessage(MESSAGE_ONRESUME_SUCCESS);
                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (mEventHandler == null)
                        return;
                    mEventHandler.sendEmptyMessage(MESSAGE_ONRESUME_FAILED);
                }
            }, new CameraPlayerVideoSeekListener() {
                @Override
                public void onCameraPlayerVideoSeek() {
                }
            }, true);
        }
    }

    private void onalendarClick() {
        ArrayList<Integer> days = getDaysOfMonth(mYear, mMonth);
        if (days == null || days.size() == 0) {
            SearchVideoByMonth(mYear, mMonth);
        }
        try {
            if (mCalendarDialog != null)
                mCalendarDialog.dismiss();
            this.mCalendarDialog = new CalendarDialog(getActivity(), this, onItemClickListener, true);
            int screenWidth;
            int screenHight;
            if (getResources().getConfiguration().orientation != Configuration.ORIENTATION_LANDSCAPE) {
                screenWidth = getResources().getDisplayMetrics().widthPixels;
                screenHight = getResources().getDisplayMetrics().heightPixels;
            } else {
                screenWidth = getResources().getDisplayMetrics().heightPixels;
                screenHight = getResources().getDisplayMetrics().widthPixels;
            }
            mCalendarDialog.getWindow().setLayout((int) ((screenWidth * 465) / 540), (int) ((screenHight * 464) / 960));
            mCalendarDialog.setCanceledOnTouchOutside(true);
            this.mCalendarDialog.initCustomDialog(mYear, mMonth, mDay);
            mCalendarDialog.show();
        } catch (Exception e) {

        }
    }

    /**
     * 日历监听，可以监听到点击的有视频的每一天
     */
    private CalendarView.OnItemClickListener onItemClickListener = new CalendarView.OnItemClickListener() {
        @Override
        public void OnItemClick(Date date) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            if (calendar.get(Calendar.YEAR) == mYear && calendar.get(Calendar.MONTH) + 1 == mMonth && calendar.get(Calendar.DAY_OF_MONTH) == mDay) {
                mCalendarDialog.hide();
                return;
            }
            addAlarmMessageTime(null, false);//清空刻度尺时间
            Message message = new Message();
            message.what = HANDLER_MSG_SEARCH_DAY;
            message.obj = date;
            mEventHandler.sendMessage(message);
        }
    };


    private void onRecordVideoClick() {
        boolean enable = (boolean) this.mRecordVideoImg.getTag();
        this.mRecordVideoImg.setTag(!enable);
        this.mRecordVideoImg_L.setTag(!enable);
        if (enable) {
            this.mRecordVideoImg.setImageResource(R.mipmap.ic_rec_video_n);
            this.mRecordVideoImg_L.setImageResource(R.mipmap.ic_rec_video_n);
            mCurplayer.stopPlaybackRecordMp4(new CameraPlayerListener() {
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
                    mEventHandler.sendEmptyMessage(MESSAGE_RECORD_SAVE_FAILED);
                }
            });
        } else {
            this.mRecordVideoImg.setImageResource(R.mipmap.ic_rec_video_y);
            this.mRecordVideoImg_L.setImageResource(R.mipmap.ic_rec_video_y);
            isExist(Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount());
            isExist(Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount() + "/media");
            mReordPath = Constant.DOCUMENT_ROOT_PATH + MeariUser.getInstance().getUserInfo().getUserAccount() + "/media/" + Constant.VIDEO_PRE + getDateTime(System.currentTimeMillis()) + ".mp4";
            try {
                File file = new File(mReordPath);
                if (!file.exists()) {
                    file.mkdirs();
                    file.delete();
                }
            } catch (Exception e) {
                if (mEventHandler != null) {
                    Message msg = new Message();
                    msg.what = MESSAGE_RECORD_FAILED;
                    msg.obj = 1;
                    mEventHandler.sendMessage(msg);
                    CommonUtils.showToast(getString(R.string.tip_permission_storage));
                }
            }
//            mCurplayer.startPlaybackrecordmp4(this.mReordPath, new CameraPlayerListener() {
//                @Override
//                public void PPSuccessHandler(String successMsg) {
//                    if (mEventHandler != null)
//                        mEventHandler.sendEmptyMessage(MESSAGE_RECORD_VIDEO_START);
//                }
//
//                @Override
//                public void PPFailureError(String errorMsg) {
//                    if (mEventHandler != null) {
//                        Message msg = new Message();
//                        msg.what = MESSAGE_RECORD_FAILED;
//                        msg.obj = 0;
//                        mEventHandler.sendMessage(msg);
//                    }
//                }
//            });
        }
    }

    private void onSnapshot() {
        if (mCurplayer == null)
            return;
        mCurplayer.Playbacksnapshot(pictureIsPath(), new CameraPlayerListener() {
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

    public void removeVideo() {
        mVideoView.setVisibility(View.GONE);
    }

    private void isExist(String path) {
        File file = new File(path);
        if (!file.exists()) {
            file.mkdir();
        }
    }

    public void setPauseView(boolean bpause) {
        this.mPauseImg.setTag(bpause);
        this.mPauseImg_L.setTag(bpause);
        if (bpause) {
            this.mPauseImg.setImageResource(R.mipmap.btn_pause_p);
            this.mPauseImg_L.setImageResource(R.mipmap.btn_pause_p);
        } else {
            this.mPauseImg.setImageResource(R.mipmap.btn_pause_y);
            this.mPauseImg_L.setImageResource(R.mipmap.btn_pause_y);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        mIsBackground = false;
        if (mVideoPlayCallback.getCurVideoType() == 1) {
            if (mCurplayer != null) {
                videoViewStatus(SingleVideoActivity.STATUS_LOADING);
                if (mConnectStatus == -1 || mConnectStatus == -2) {
                    connectCamera();
                } else if (mConnectStatus == 1)
                    if (this.mIsPause) {
                        if (!isStop)
                            onResumeVideo();
                        else {
                            playVideo(false);
                        }
                        this.mIsPause = false;
                    } else
                        videoViewStatus(SingleVideoActivity.STATUS_PLAY);
            } else if (mCurplayer == null) {
                connectCamera();
            }
        }
        isStop = false;
    }

    @Override
    public void setFragmentStatus(boolean isVisibleToUser) {
        if (isVisibleToUser) {
            if (mView == null)
                return;
            if (mCurplayer != null) {
                videoViewStatus(SingleVideoActivity.STATUS_LOADING);
                if (mConnectStatus == -1 || mConnectStatus == -2) {
                    connectCamera();
                } else if (mConnectStatus == 1) {
                    if (mVideoRecordList.size() > 0)
                        playVideo(false);
                    else
                        videoViewStatus(SingleVideoActivity.STATUS_PLAY);
                }

            } else if (mCurplayer == null) {
                connectCamera();
            }
        } else {
            if (mView == null)
                return;
            mCurplayer.stopPlaybackSd(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                }

                @Override
                public void PPFailureError(String errorMsg) {

                }
            });
        }
    }
    public void postEventTime(int year, int month, int day) {
        if (getContext() == null || getActivity() == null || getActivity().isFinishing())
            return;
        String format = "%d%02d%02d";
//        MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(mCameraInfo.getDeviceID(), String.format(format, year, month, day),this , new IDeviceAlarmMessageTimeCallback() {
//
//            @Override
//            public void onSuccess(List<AlarmMessageTime> events) {
//                if (getActivity() == null || getActivity().isFinishing())
//                    addEventRecord(events);
//            }
//
//            @Override
//            public void onError(int code, String error) {
//
//            }
//        });
    }


    private void addEventRecord(List<AlarmMessageTime> list) {
        if (list == null || list.size() <= 0) {
            return;
        }
        EventTimeTask eventTimeTask = new EventTimeTask();
        eventTimeTask.execute(list);


    }

    public ArrayList<AlarmMessageTime> getAddEventTimeRecordList
            (List<AlarmMessageTime> events) {
        ArrayList<AlarmMessageTime> infos = new ArrayList<>();
        for (AlarmMessageTime record : events) {
            if (!mScaleView.enventVideoEventExisted(record)) {
                infos.add(record);
            }
        }
        return infos;
    }

    @Override
    public void seekVideo(AlarmMessageTime record, boolean arm) {
        if (mScaleView.getScorollStatus() != 0) {
            return;
        }
        mAdapter.setSelectVideoRec(record);
        mAdapter.notifyDataSetChanged();
        mCurplayer.ppspausePlayback();
        videoViewStatus(SingleVideoActivity.STATUS_LOADING);
        int hour = record.StartHour;
        int minute = record.StartMinute;
        int second = record.StartSecond;
        int totalsec = hour * 3600 + minute * 60 + second - ADVANCE_SECOND;//提前5s播放
        int hourAd = totalsec / 3600;
        int minad = (totalsec - hourAd * 3600) / 60;
        int secAd = totalsec % 60;

        if (isExistFormVideoRecordList(hourAd, minad, secAd)) {
            mHour = hourAd;
            mMinute = minad;
            mSecond = secAd;
        } else {
            mHour = hour;
            mMinute = minute;
            mSecond = second;
        }
        mScaleView.setTimeProgrogress(mHour, mMinute, mSecond);
        seekVideo(false);
    }

    class EventTimeTask extends AsyncTask<List<AlarmMessageTime>, Void, Boolean> {
        private ArrayList<AlarmMessageTime> mEventList = new ArrayList<>();

        @Override
        protected Boolean doInBackground(List<AlarmMessageTime>... params) {
            try {
                if (getActivity() == null && getActivity().isFinishing()) {
                    return true;
                }
                for (List<AlarmMessageTime> records : params) {
                    for (AlarmMessageTime record : records) {

                        if (isExistFormVideoRecordList(record.StartHour, record.StartMinute, record.StartSecond)) {
                            mEventList.add(record);
                        }
                    }
                }
                return true;
            } catch (Exception e) {
                return true;
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            super.onPostExecute(result);
            if (getActivity() == null || getActivity().isFinishing())
                return;
            if (mEventList.size() > 0)
                mScaleView.cleanEventTime();
            mScaleView.setEventTimeSD(mEventList);
            mAdapter.clearDaxta();
            mAdapter.addData(mEventList);
            mAdapter.notifyDataSetChanged();
            if (mScaleView.mEventTimeRecordList.size() > 0) {
                mView.findViewById(R.id.arm_time_layout).setVisibility(View.VISIBLE);
                smoothMoveToPosition(mAdapter.getCurPosition());
            } else
                mView.findViewById(R.id.arm_time_layout).setVisibility(View.GONE);

        }

        @Override
        protected void onCancelled(Boolean result) {
            super.onCancelled(result);
        }
    }

    private void smoothMoveToPosition(int n) {

        int firstItem = mLinearLayoutManager.findFirstVisibleItemPosition();
        int lastItem = mLinearLayoutManager.findLastVisibleItemPosition();
        if (n <= firstItem) {
            mEventRecyclerView.smoothScrollToPosition(n);
        } else if (n <= lastItem) {
            int top = mEventRecyclerView.getChildAt(n - firstItem).getTop();
            mEventRecyclerView.scrollBy(0, top);
        } else {
            mEventRecyclerView.scrollToPosition(n);
            move = true;
        }
    }

    class RecyclerViewListener extends RecyclerView.OnScrollListener {
        @Override
        public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
            super.onScrollStateChanged(recyclerView, newState);
            if (move && newState == RecyclerView.SCROLL_STATE_IDLE) {
                move = false;
                int n = mIndex - mLinearLayoutManager.findFirstVisibleItemPosition();
                if (0 <= n && n < mEventRecyclerView.getChildCount()) {
                    int top = mEventRecyclerView.getChildAt(n).getTop();
                    mEventRecyclerView.smoothScrollBy(0, top);
                }

            }
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        getPlayTimeHandler.removeCallbacks(getPlayTimeRunnable);
        getPlayTimeHandler.removeCallbacks(videoDataRunnable);
        getPlayTimeHandler = null;
        if (mCurplayer != null && mCurplayer.getCameraInfo() != null) {
            mCurplayer.disconnectIPC(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                }

                @Override
                public void PPFailureError(String errorMsg) {
                }
            });
        }
    }


    public void stopVideoRecord() {
        if (mView == null)
            return;
        else {
            if (mCurplayer != null && (mCurplayer.getPlayStatus() & CameraPlayer.PlaybackRecord) == CameraPlayer.PlaybackRecord) {
                this.mRecordVideoImg.setTag(false);
                this.mRecordVideoImg_L.setTag(false);
                try {
                    mView_REC.clearAnimation();

                } catch (Exception e) {

                }
                mView_REC.setVisibility(View.GONE);
                this.mRecordVideoImg.setImageResource(R.mipmap.ic_rec_video_n);
                this.mRecordVideoImg_L.setImageResource(R.mipmap.ic_rec_video_n);
                mCurplayer.stopPlaybackRecordMp4(new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {

                    }

                    @Override
                    public void PPFailureError(String errorMsg) {

                    }
                });
            }
        }
    }

    public void onPause() {
        super.onPause();
        if (mCurplayer != null && (mCurplayer.mstatus & mCurplayer.Playbacking) == mCurplayer.Playbacking) {
            mCurplayer.ppspausePlayback();
        }
        if (!mVideoPlayCallback.getFinshStatus()) {
            onPauseVideo();
            this.mIsPause = true;
        }
    }

    public void pauseViPlaydeo() {
        if (mCurplayer != null && (mCurplayer.mstatus & mCurplayer.Playbacking) == mCurplayer.Playbacking) {
            mCurplayer.ppspausePlayback();
        }
    }

    public void networkClose() {
        if (mView == null)
            return;
        videoViewStatus(SingleVideoActivity.STATUS_REFRESH);
    }

    @Override
    public void onStop() {
        super.onStop();
        boolean enable = (boolean) this.mRecordVideoImg.getTag();
        if (enable) {
            onRecordVideoClick();
        }
        if (mCurplayer != null) {
            mCurplayer.stopPlaybackSd(new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    isStop = true;
                }

                @Override
                public void PPFailureError(String errorMsg) {
                }
            });
        }
    }
    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof VideoPlayCallback)
            mVideoPlayCallback = (VideoPlayCallback) context;
    }
}
