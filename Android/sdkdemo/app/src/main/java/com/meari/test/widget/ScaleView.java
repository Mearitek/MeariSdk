package com.meari.test.widget;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.meari.sdk.bean.TimeInfo;
import com.meari.test.R;
import com.meari.test.common.Constant;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.widget.RuleHorizontalScrollView.ScrollViewListener;
import com.meari.sdk.bean.AlarmMessageTime;

import java.util.ArrayList;
import java.util.List;


/**
 * 刻度尺控件
 * Created by ljh on 2015/12/29.
 */
public class ScaleView extends RelativeLayout implements ScrollViewListener {
    private int FINE_VALUE_MAX;
    private TextView mTextView;
    private RuleHorizontalScrollView mRoughView;
    private RuleHorizontalScrollView mFineView;
    private final int MSG_CHANGE_TIME = 100;
    private OnScaleTouchListener onScaleTouchListener;
    public List<AlarmMessageTime> mEventTimeRecordList;
    public List<AlarmMessageTime> mAlarmMessageTimeList;
    private List<AlarmMessageTime> mVideoEventCloudRecordList;//发生在蓝条里面的报警事件列表

    private final int STATUS_ROUGH_RULE = 0;
    private final int STATUS_FINE_RULE = 1;
    private int mRuleStatus = 0;
    private int[] mRuleIds = {R.id.precise_scale_ruler0, R.id.precise_scale_ruler1, R.id.precise_scale_ruler2, R.id.precise_scale_ruler3,
            R.id.precise_scale_ruler4, R.id.precise_scale_ruler5, R.id.precise_scale_ruler6, R.id.precise_scale_ruler7,
            R.id.precise_scale_ruler8, R.id.precise_scale_ruler9, R.id.precise_scale_ruler10, R.id.precise_scale_ruler11,
            R.id.precise_scale_ruler12, R.id.precise_scale_ruler13, R.id.precise_scale_ruler14, R.id.precise_scale_ruler15,
            R.id.precise_scale_ruler16, R.id.precise_scale_ruler17, R.id.precise_scale_ruler18, R.id.precise_scale_ruler19,
            R.id.precise_scale_ruler20, R.id.precise_scale_ruler21, R.id.precise_scale_ruler22, R.id.precise_scale_ruler23};

    /**
     * 最大值，即24时的位置
     */
    private int VALUE_MAX = 0;
    /**
     * 屏幕宽度
     */
    private int SCREEN_WIDTH;

    private int TEXT_BLUE_WIDTH = 1200;//蓝线最大长度
    /**
     * 一天的秒数
     */
    private final int SECONDS_OF_DAY = 86400;
    /**
     * 一小时的秒数
     */
    private final int SECONDS_OF_HOUR = 3600;
    /**
     * 一分钟的秒数
     */
    private final int SECONDS_OF_MINUTE = 60;
    private RelativeLayout mRoughVideoTimeLayout;
    private RelativeLayout mRoughMaskLayout;
    private int[] mViedeoTimes;
    private RelativeLayout mFineVideoTimeLayout;
    private RelativeLayout mFineMaskLayout;
    private int count = 0;
    private long firClick;
    private long secClick;
    private int mHour;
    private int mMin;
    private int mSec;
    private TimeInfo mTimeInfo;
    private ScaleTimeViewmplement mScaleTimeViewmplement;
    private int mPaintColor = R.color.com_blue;
    public ScaleView(Context context) {
        super(context);
    }

    public ScaleView(Context context, AttributeSet attrs) {
        super(context, attrs);

    }

    public ScaleView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);

    }

    public void init() {
        mVideoEventCloudRecordList = new ArrayList<>();
        mEventTimeRecordList = new ArrayList<>();
        LayoutInflater.from(getContext()).inflate(R.layout.layout_scale, this);
        this.mRoughView = (RuleHorizontalScrollView) findViewById(R.id.rought_rule_layout);
        this.mFineView = (RuleHorizontalScrollView) findViewById(R.id.fine_rule_layout);
        mRoughView.init();
        mFineView.init();
        initFineRuleView();
        initRoughRuleView();
        this.mRoughView.setOnScrollStateChangedListener(this);
        this.mRoughView.setHandler(mScaleHander);
        this.mFineView.setOnScrollStateChangedListener(this);
        this.mFineView.setHandler(mScaleHander);
        findViewById(R.id.video_time_precise_layout).setVisibility(View.GONE);
        findViewById(R.id.precise_evnet_layout).setVisibility(View.GONE);
        findViewById(R.id.video_time_layout).setVisibility(View.GONE);
        findViewById(R.id.evnet_layout).setVisibility(View.GONE);
        findViewById(R.id.line_event).setVisibility(View.GONE);
        findViewById(R.id.point_image).setVisibility(View.GONE);
    }

    private void initFineRuleView() {
        mFineView.setVisibility(View.GONE);
        LinearLayout rulerImg = (LinearLayout) findViewById(R.id.scale_precise_ruler);
        SCREEN_WIDTH = Constant.width;
        for (int id : mRuleIds) {
            ImageView img = (ImageView) findViewById(id);
            LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) img.getLayoutParams();
            if (id == R.id.precise_scale_ruler0) {
                lp.width = 1948 * SCREEN_WIDTH / 640;
            } else if (id == R.id.precise_scale_ruler23) {
                lp.width = 2003 * SCREEN_WIDTH / 640;
            } else {
                lp.width = 1656 * SCREEN_WIDTH / 640;
            }
            img.setLayoutParams(lp);
        }
        int width = (SCREEN_WIDTH * 1656 / 640) * 22 + (SCREEN_WIDTH * 1948 / 640 ) + (SCREEN_WIDTH * 2003 / 640);
        FINE_VALUE_MAX = (SCREEN_WIDTH * 1656 / 640) * 22 + (SCREEN_WIDTH * 1628 / 640) + (SCREEN_WIDTH * 1683 / 640);
        rulerImg.getLayoutParams().width = width;
        rulerImg.getLayoutParams().height = SCREEN_WIDTH * 56 / 640;
        RelativeLayout eventLinearlayout = (RelativeLayout) findViewById(R.id.precise_evnet_layout);
        eventLinearlayout.getLayoutParams().width = width;
        eventLinearlayout.getLayoutParams().height = SCREEN_WIDTH * 56 / 640;
        this.mFineVideoTimeLayout = (RelativeLayout) findViewById(R.id.video_time_precise_layout);
        this.mFineVideoTimeLayout.getLayoutParams().width = width;
        this.mFineVideoTimeLayout.getLayoutParams().height = SCREEN_WIDTH * 56 / 640;
        this.mFineVideoTimeLayout.setBackgroundResource(0);
        this.mFineMaskLayout = (RelativeLayout) findViewById(R.id.video_mask_precise_layout);
        this.mFineMaskLayout.getLayoutParams().width = width;
        this.mFineMaskLayout.getLayoutParams().height = SCREEN_WIDTH * 56 / 640;
        this.mFineMaskLayout.setBackgroundResource(0);
    }

    private void initRoughRuleView() {
        mRoughView.setVisibility(VISIBLE);
        LinearLayout rulerImg = (LinearLayout) findViewById(R.id.scale_ruler);
        SCREEN_WIDTH = Constant.width;
        int width = SCREEN_WIDTH * 3815 / 640;
        VALUE_MAX = SCREEN_WIDTH * 3175 / 640;
        rulerImg.getLayoutParams().width = width;
        rulerImg.getLayoutParams().height = SCREEN_WIDTH * 56 / 640;
        RelativeLayout eventLinearlayout = (RelativeLayout) findViewById(R.id.evnet_layout);
        eventLinearlayout.getLayoutParams().width = width;
        eventLinearlayout.getLayoutParams().height = SCREEN_WIDTH * 56 / 640;
        this.mRoughVideoTimeLayout = (RelativeLayout) findViewById(R.id.video_time_layout);
        this.mRoughVideoTimeLayout.getLayoutParams().width = width;
        this.mRoughVideoTimeLayout.getLayoutParams().height = SCREEN_WIDTH * 56 / 640;
        this.mRoughVideoTimeLayout.setBackgroundResource(0);
        this.mRoughMaskLayout = (RelativeLayout) findViewById(R.id.mask_layout);
        this.mRoughMaskLayout.getLayoutParams().width = width;
        this.mRoughMaskLayout.getLayoutParams().height = SCREEN_WIDTH * 56 / 640;
        this.mRoughMaskLayout.setBackgroundResource(0);
    }


    public void setTextView(TextView textView) {
        this.mTextView = textView;
        this.mTextView.setVisibility(View.INVISIBLE);
    }

    public void setVideoTime(List<AlarmMessageTime> videoTime) {
        mAlarmMessageTimeList = videoTime;
        setRoughVideoTimeView(videoTime);
        setFineVideoTimeView(videoTime);
        findViewById(R.id.video_time_precise_layout).setVisibility(View.VISIBLE);
        findViewById(R.id.precise_evnet_layout).setVisibility(View.VISIBLE);
        findViewById(R.id.video_time_layout).setVisibility(View.VISIBLE);
        findViewById(R.id.evnet_layout).setVisibility(View.VISIBLE);
        findViewById(R.id.line_event).setVisibility(View.VISIBLE);
        findViewById(R.id.point_image).setVisibility(View.VISIBLE);
        findViewById(R.id.bg_time).setVisibility(View.VISIBLE);
    }

    public void setOnScaleTouchListener(OnScaleTouchListener onScaleTouchListener) {
        this.onScaleTouchListener = onScaleTouchListener;
    }

    public void setTimeProgrogress(int hour, int minute, int second) {
        int valueMax = VALUE_MAX;
        RuleHorizontalScrollView ruleView = mRoughView;
        if (mRuleStatus == STATUS_FINE_RULE) {
            ruleView = mFineView;
            valueMax = FINE_VALUE_MAX;
        }
        int seconds = hour * SECONDS_OF_HOUR + minute * SECONDS_OF_MINUTE + second;
        long position = Long.valueOf(valueMax) * Long.valueOf(seconds);
        int value = (int) (position / SECONDS_OF_DAY);
        ruleView.scrollTo(value, 0);
        mTextView.setText(String.valueOf(String.format("%02d:%02d:%02d",hour,minute,second)));
    }

    public void cleanVideoTime() {
        if (mAlarmMessageTimeList != null)
            mAlarmMessageTimeList.clear();
        mRoughVideoTimeLayout.removeAllViews();
        mRoughMaskLayout.removeAllViews();
        mFineVideoTimeLayout.removeAllViews();
        mFineMaskLayout.removeAllViews();
    }

    public void cleanEventTime() {
        mEventTimeRecordList.clear();
        mVideoEventCloudRecordList.clear();
        RelativeLayout eventLinearlayout = (RelativeLayout) findViewById(R.id.evnet_layout);
        eventLinearlayout.removeAllViews();
        RelativeLayout preciseevEntLinearlayout = (RelativeLayout) findViewById(R.id.precise_evnet_layout);
        preciseevEntLinearlayout.removeAllViews();
    }

    public void setViedeoTimes(int[] viedeoTimes) {
        this.mViedeoTimes = viedeoTimes;
    }

    public void setEventTime(List<AlarmMessageTime> eventTime) {
        if (mViedeoTimes == null || mViedeoTimes.length == 0) {
            return;
        }
        this.mEventTimeRecordList.addAll(eventTime);
        setRoughEventTime(eventTime);
        setFineEventTime(eventTime);

    }

    public void setEventTimeSD(List<AlarmMessageTime> eventTime) {
        this.mEventTimeRecordList.clear();
        this.mEventTimeRecordList.addAll(eventTime);
        setRoughEventTimeSD(eventTime);
        setFineEventTimeSD(eventTime);

    }
    private void setRoughEventTimeSD(List<AlarmMessageTime> eventTime) {
        for (AlarmMessageTime time : eventTime) {
            mVideoEventCloudRecordList.add(time);
            TextView v = new TextView(getContext());
            v.setBackgroundResource(R.mipmap.icon_event);
            int start = getSecondsToPx(time.StartHour, time.StartMinute, time.StartSecond, VALUE_MAX);
            int height = DisplayUtil.dip2px(getContext(), 20);
            LayoutParams lp = new LayoutParams(LayoutParams.WRAP_CONTENT, height);
            lp.setMargins(start + Constant.width / 2, DisplayUtil.dip2px(getContext(), 4), 0, 0);
            v.setLayoutParams(lp);
            RelativeLayout eventLinearlayout = (RelativeLayout) findViewById(R.id.evnet_layout);
            eventLinearlayout.addView(v);
        }
    }
    private void setRoughEventTime(List<AlarmMessageTime> eventTime) {
        for (AlarmMessageTime time : eventTime) {
            int sec = time.StartHour * 3600 + time.StartMinute * 60 + time.StartSecond;
            boolean isFirstDay = IsFirstVideoDay();
            if (sec < mViedeoTimes.length) {
                if (mViedeoTimes[sec] == 0) {
                    continue;
                } else if (mTimeInfo != null && isFirstDay) {
                    int total = mTimeInfo.getHour() * 3600 + mTimeInfo.getMinute() * 60 + mTimeInfo.getSecond();
                    if (total > sec)
                        continue;
                }
            }
            mVideoEventCloudRecordList.add(time);
            TextView v = new TextView(getContext());
            v.setBackgroundResource(R.mipmap.icon_event);
            int start = getSecondsToPx(time.StartHour, time.StartMinute, time.StartSecond, VALUE_MAX);
            int height = DisplayUtil.dip2px(getContext(), 20);
            LayoutParams lp = new LayoutParams(LayoutParams.WRAP_CONTENT, height);
            lp.setMargins(start + Constant.width / 2, DisplayUtil.dip2px(getContext(), 4), 0, 0);
            v.setLayoutParams(lp);
            RelativeLayout eventLinearlayout = (RelativeLayout) findViewById(R.id.evnet_layout);
            eventLinearlayout.addView(v);
        }
    }

    public boolean IsFirstVideoDay() {
        if (mScaleTimeViewmplement == null) {
            return false;
        }
        TimeInfo info = mScaleTimeViewmplement.getCurTimeInfo();
        if (mTimeInfo != null && info != null && mTimeInfo.getDay() == info.getDay()
                && mTimeInfo.getYear() == info.getYear() && mTimeInfo.getMonth() == info.getMonth())
            return true;
        return false;
    }
    private void setFineEventTimeSD(List<AlarmMessageTime> eventTime) {
        for (AlarmMessageTime time : eventTime) {
            TextView v = new TextView(getContext());
            v.setBackgroundResource(R.mipmap.icon_event);
            int start = getSecondsToPx(time.StartHour, time.StartMinute, time.StartSecond, FINE_VALUE_MAX);
            int height = DisplayUtil.dip2px(getContext(), 20);
            LayoutParams lp = new LayoutParams(LayoutParams.WRAP_CONTENT, height);
            lp.setMargins(start + Constant.width / 2, DisplayUtil.dip2px(getContext(), 4), 0, 0);
            v.setLayoutParams(lp);
            RelativeLayout eventLinearlayout = (RelativeLayout) findViewById(R.id.precise_evnet_layout);
            eventLinearlayout.addView(v);
        }
    }
    private void setFineEventTime(List<AlarmMessageTime> eventTime) {
        for (AlarmMessageTime time : eventTime) {
            int sec = time.StartHour * 3600 + time.StartMinute * 60 + time.StartSecond;
            boolean isFirstDay = IsFirstVideoDay();
            if (sec < mViedeoTimes.length) {
                if (mViedeoTimes[sec] == 0) {
                    continue;
                } else if (mTimeInfo != null && isFirstDay) {
                    int total = mTimeInfo.getHour() * 3600 + mTimeInfo.getMinute() * 60 + mTimeInfo.getSecond();
                    if (total > sec)
                        continue;
                }
            }
            TextView v = new TextView(getContext());
            v.setBackgroundResource(R.mipmap.icon_event);
            int start = getSecondsToPx(time.StartHour, time.StartMinute, time.StartSecond, FINE_VALUE_MAX);
            int height = DisplayUtil.dip2px(getContext(), 20);
            LayoutParams lp = new LayoutParams(LayoutParams.WRAP_CONTENT, height);
            lp.setMargins(start + Constant.width / 2, DisplayUtil.dip2px(getContext(), 4), 0, 0);
            v.setLayoutParams(lp);
            RelativeLayout eventLinearlayout = (RelativeLayout) findViewById(R.id.precise_evnet_layout);
            eventLinearlayout.addView(v);
        }
    }

    private Handler mScaleHander = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MSG_CHANGE_TIME:
                    int time = (int) msg.obj;
                    int scrollType = msg.arg1;
                    setTextView(time);
                    if (scrollType == 0)
                        mTextView.setVisibility(View.INVISIBLE);
                    else
                        mTextView.setVisibility(View.VISIBLE);
                    break;
                default:
                    break;
            }
        }
    };

    @Override
    public void onScrollChanged(int scrollType) {
        RuleHorizontalScrollView mRuleView = mRoughView;
        if (mRuleStatus == STATUS_FINE_RULE)
            mRuleView = mFineView;
        int position = mRuleView.getScrollX();
        onScaleTouchListener.onChange();
        Message msg = new Message();
        msg.what = MSG_CHANGE_TIME;
        msg.obj = position;
        msg.arg1 = scrollType;
        mScaleHander.sendMessage(msg);
    }

    @Override
    public void onScrollFinish(int scrollType) {
        int valueMax = VALUE_MAX;
        RuleHorizontalScrollView mRuleView = mRoughView;
        if (mRuleStatus == STATUS_FINE_RULE) {
            mRuleView = mFineView;
            valueMax = FINE_VALUE_MAX;
        }
        long totalSeconds = getPxToSeconds(mRuleView.getScrollX(), valueMax);
        int hour = getHour(totalSeconds);
        int minute = getMinute(totalSeconds);
        int second = getSecond(totalSeconds);
        onScaleTouchListener.onFinish(hour, minute, second);
    }

    @Override
    public void onChangeRule() {
        changeFineRule(mRuleStatus == STATUS_FINE_RULE ? false : true);
    }

    public void onChangeRoughRule() {
        if (mRuleStatus == STATUS_FINE_RULE ? true : false)
            onChangeRule();
    }

    private void changeFineRule(boolean bshow) {
        RuleHorizontalScrollView ruleView = mRoughView;
        if (mRuleStatus == STATUS_FINE_RULE) {
            ruleView = mFineView;
        }
        int progress = ruleView.getScrollX();
        long totalSeconds;
        if (bshow) {
            totalSeconds = getPxToSeconds(progress, VALUE_MAX);
            this.mFineView.setVisibility(View.VISIBLE);
            this.mRoughView.setVisibility(View.GONE);
            mRuleStatus = STATUS_FINE_RULE;
        } else {
            totalSeconds = getPxToSeconds(progress, FINE_VALUE_MAX);
            this.mRoughView.setVisibility(View.VISIBLE);
            this.mFineView.setVisibility(View.GONE);
            mRuleStatus = STATUS_ROUGH_RULE;
        }
        mHour = getHour(totalSeconds);
        mMin = getMinute(totalSeconds);
        mSec = getSecond(totalSeconds);
        changeRuleHandler.postDelayed(videoDataRunnable, 50);
    }

    public void setTextView(int time) {
        int valueMax = VALUE_MAX;
        if (mRuleStatus == STATUS_FINE_RULE)
            valueMax = FINE_VALUE_MAX;
        if (time < 0) {        // 滑动小于0时
            time = 0;
        } else if (time > valueMax) { // 超过24时
            time = valueMax;
        }
        long totalSeconds = getPxToSeconds(time, valueMax);
        int hour = getHour(totalSeconds);
        int minute = getMinute(totalSeconds);
        int second = getSecond(totalSeconds);
        mTextView.setText(String.format("%02d:%02d:%02d", hour, minute, second));
    }

    /**
     * 像素转换成时间工具
     *
     * @param value 像素
     * @return 时间
     */
    public long getPxToSeconds(int value, int valueMax) {
        long seconds = Long.valueOf(value) * SECONDS_OF_DAY / valueMax;
        return seconds;
    }

    /**
     * 总的秒数获取时
     *
     * @param totalSeconds 秒
     * @return 时
     */
    private int getHour(long totalSeconds) {
        int hour = (int) (totalSeconds / SECONDS_OF_HOUR);
        return hour;
    }

    /**
     * 总的秒数获取分
     *
     * @param totalSeconds 秒
     * @return 时
     */
    private int getMinute(long totalSeconds) {
        int minute = (int) ((totalSeconds % SECONDS_OF_HOUR) / SECONDS_OF_MINUTE);
        return minute;
    }

    /**
     * 总的秒数获取秒
     *
     * @param totalSeconds 总秒数
     * @return 秒
     */
    private int getSecond(long totalSeconds) {
        int second = (int) (totalSeconds % SECONDS_OF_MINUTE);
        return second;
    }

    /**
     * 时间转换成像素工具
     *
     * @param hour   时
     * @param minute 分
     * @param second 秒
     * @return 像素
     */
    private int getSecondsToPx(int hour, int minute, int second, int valueMax) {
        int seconds = hour * SECONDS_OF_HOUR + minute * SECONDS_OF_MINUTE + second;
        long value = (long) valueMax * seconds / SECONDS_OF_DAY;
        return (int) value;
    }

    public void setRoughVideoTimeView(List<AlarmMessageTime> videoTime) {
        int imageStartMin = -1;
        int imageStartMax = -1;
        for (AlarmMessageTime time : videoTime) {
            int end = getSecondsToPx(time.EndHour, time.EndMinute, time.EndSecond, VALUE_MAX);
            int start = getSecondsToPx(time.StartHour, time.StartMinute, time.StartSecond, VALUE_MAX);
            int length = end - start;
            if (imageStartMin != -1) {
                imageStartMin = (imageStartMin > start ? start : imageStartMin);
            } else {
                imageStartMin = start;
            }
            if (imageStartMax != -1) {
                imageStartMax = (imageStartMax < end ? end : imageStartMax);
            } else {
                imageStartMax = end;
            }
            int index = (length + 1199) / 1200;
            {
                if (length <= 1200) {
                    TextView v = new TextView(getContext());
                    v.setBackgroundResource(mPaintColor);
                    mRoughVideoTimeLayout.addView(v);
                    LayoutParams lp = (LayoutParams) v.getLayoutParams();
                    lp.width = length;
                    lp.height = DisplayUtil.dip2px(getContext(), 20);
                    lp.setMargins(start + SCREEN_WIDTH / 2, 0, 0, 0);
                    v.setLayoutParams(lp);

                } else {
                    for (int i = 0; i < index; i++) {
                        TextView v = new TextView(getContext());
                        v.setBackgroundResource(mPaintColor);
                        int width;
                        if (i == index - 1)
                            width = length - i * TEXT_BLUE_WIDTH;
                        else
                            width = TEXT_BLUE_WIDTH;
                        mRoughVideoTimeLayout.addView(v);
                        LayoutParams lp = (LayoutParams) v.getLayoutParams();
                        lp.width = width;
                        lp.height = DisplayUtil.dip2px(getContext(), 20);
                        lp.setMargins(start + i * TEXT_BLUE_WIDTH + SCREEN_WIDTH / 2, 0, 0, 0);
                        v.setLayoutParams(lp);
                    }
                }

            }
        }
        if (videoTime != null && videoTime.size() > 0) {
            ImageView vStart = new ImageView(getContext());
            vStart.setImageResource(R.mipmap.ic_shape_left);
            mRoughVideoTimeLayout.addView(vStart);
            LayoutParams lp = (LayoutParams) vStart.getLayoutParams();
            lp.width = DisplayUtil.dip2px(getContext(), 10);
            lp.height = DisplayUtil.dip2px(getContext(), 20);
            lp.setMargins(imageStartMin + SCREEN_WIDTH / 2, 0, 0, 0);
            vStart.setLayoutParams(lp);
            AlarmMessageTime timeEnd = videoTime.get(videoTime.size() - 1);
            ImageView vEnd = new ImageView(getContext());
            vEnd.setImageResource(R.mipmap.ic_shape_right);
            mRoughVideoTimeLayout.addView(vEnd);
            LayoutParams lp1 = (LayoutParams) vEnd.getLayoutParams();
            lp1.width = DisplayUtil.dip2px(getContext(), 10);
            lp1.height = DisplayUtil.dip2px(getContext(), 20);
            lp1.setMargins(imageStartMax - lp1.width + SCREEN_WIDTH / 2, 0, 0, 0);
            vEnd.setLayoutParams(lp1);

        }
    }
    public void setFineVideoTimeView(List<AlarmMessageTime> videoTime) {
        for (AlarmMessageTime time : videoTime) {
            int end = getSecondsToPx(time.EndHour, time.EndMinute, time.EndSecond, FINE_VALUE_MAX);
            int start = getSecondsToPx(time.StartHour, time.StartMinute, time.StartSecond, FINE_VALUE_MAX);
            int length = end - start;
            int index = (length + 1199) / 1200;
            {
                if (length <= 1200) {
                    TextView v = new TextView(getContext());
                    v.setBackgroundResource(mPaintColor);
                    mFineVideoTimeLayout.addView(v);
                    LayoutParams lp = (LayoutParams) v.getLayoutParams();
                    lp.width = length;
                    lp.setMargins(start + SCREEN_WIDTH / 2, 0, 0, 0);
                    lp.height = DisplayUtil.dip2px(getContext(), 20);
                    v.setLayoutParams(lp);

                } else {
                    for (int i = 0; i < index; i++) {
                        TextView v = new TextView(getContext());
                        v.setBackgroundResource(mPaintColor);
                        int width;
                        if (i == index - 1)
                            width = length - i * TEXT_BLUE_WIDTH;
                        else
                            width = TEXT_BLUE_WIDTH;
                        mFineVideoTimeLayout.addView(v);
                        LayoutParams lp = (LayoutParams) v.getLayoutParams();
                        int marginLeft = start + i * TEXT_BLUE_WIDTH + SCREEN_WIDTH / 2;
                        lp.width = width;
                        lp.height = DisplayUtil.dip2px(getContext(), 20);
                        lp.setMargins(marginLeft, 0, 0, 0);
                        v.setLayoutParams(lp);

                    }
                }

            }
        }

        if (videoTime != null && videoTime.size() > 0) {
            AlarmMessageTime timeStart = videoTime.get(0);
            int imageStart = getSecondsToPx(timeStart.StartHour, timeStart.StartMinute, timeStart.StartSecond, FINE_VALUE_MAX);
            ImageView vStart = new ImageView(getContext());
            vStart.setImageResource(R.mipmap.ic_shape_left);
            mFineMaskLayout.addView(vStart);
            LayoutParams lp = (LayoutParams) vStart.getLayoutParams();
            lp.width = DisplayUtil.dip2px(getContext(), 10);
            lp.height = DisplayUtil.dip2px(getContext(), 20);
            lp.setMargins(imageStart + SCREEN_WIDTH / 2, 0, 0, 0);
            vStart.setLayoutParams(lp);
            AlarmMessageTime timeEnd = videoTime.get(videoTime.size() - 1);
            int imageEnd = getSecondsToPx(timeEnd.EndHour, timeEnd.EndMinute, timeEnd.EndSecond, FINE_VALUE_MAX);
            ImageView vEnd = new ImageView(getContext());
            vEnd.setImageResource(R.mipmap.ic_shape_right);
            mFineMaskLayout.addView(vEnd);
            LayoutParams lp1 = (LayoutParams) vEnd.getLayoutParams();
            lp1.width = DisplayUtil.dip2px(getContext(), 10);
            lp1.height = DisplayUtil.dip2px(getContext(), 20);
            lp1.setMargins(imageEnd - lp1.width + SCREEN_WIDTH / 2, 0, 0, 0);
            vEnd.setLayoutParams(lp1);
        }
    }

    public boolean isExisted(int i) {
        if (mViedeoTimes == null || mViedeoTimes.length <= i)
            return false;
        else
            return mViedeoTimes[i] == 1 ? true : false;
    }

    public void stopScroll() {
        if (mRuleStatus == STATUS_FINE_RULE) {
            mFineView.removeScorllCallbacks();

        } else
            mRoughView.removeScorllCallbacks();
    }

    public void setTimeInfo(TimeInfo timeInfo) {
        this.mTimeInfo = timeInfo;
    }

    public void setScaleTimeViewmplement(ScaleTimeViewmplement scaleTimeViewmplement) {
        this.mScaleTimeViewmplement = scaleTimeViewmplement;
    }

    public void setPaintColor(int yellow) {
        this.mPaintColor = yellow;
    }


    public interface OnScaleTouchListener {
        void onChange();

        void onFinish(int hour, int minute, int second);
    }

    class onDoubleClick implements OnTouchListener {

        @Override
        public boolean onTouch(View v, MotionEvent event) {
            if (MotionEvent.ACTION_DOWN == event.getAction()) {
                count++;
                if (count == 1) {
                    firClick = System.currentTimeMillis();
                } else if (count == 2) {
                    secClick = System.currentTimeMillis();
                    if (secClick - firClick < 1000) {
                        //双击事件

                    }
                    count = 0;
                    firClick = 0;
                    secClick = 0;

                }
            }
            return true;
        }
    }

    public List<AlarmMessageTime> getVideoEventCloudRecordList() {
        return mVideoEventCloudRecordList;
    }

    public boolean enventVideoEventExisted(AlarmMessageTime timeRecord) {
        if (mVideoEventCloudRecordList == null) {
            mVideoEventCloudRecordList = new ArrayList<>();
        }
        for (AlarmMessageTime record : mVideoEventCloudRecordList) {
            if (record.StartMinute == timeRecord.StartMinute && record.StartHour == timeRecord.StartHour && record.StartSecond == timeRecord.StartSecond) {
                return true;
            }
        }
        return false;
    }

    public int getRecyclerViewScrollPosition(int hour, int min, int sec) {
        int totalSec = hour * 3600 + min * 60 + sec;
        for (int i = 0; i < mVideoEventCloudRecordList.size(); i++) {
            AlarmMessageTime record = mVideoEventCloudRecordList.get(i);
            if ((record.StartHour * 3600 + record.StartMinute * 60 + record.StartSecond) >= totalSec)
                return i;
        }
        return mVideoEventCloudRecordList.size();
    }
//    videoDataHandler.postDelayed(this, 120000);

    /**
     * 搜索视频，是否存在视频的时间段
     */
    private Handler changeRuleHandler = new Handler();
    private Runnable videoDataRunnable = new Runnable() {
        @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public void run() {
            setTimeProgrogress(mHour, mMin, mSec);

        }
    };

    public int getScorollStatus() {
        if (mRuleStatus == STATUS_FINE_RULE) {
            return mFineView.getSorollType();
        } else
            return mRoughView.getSorollType();
    }

    public interface ScaleTimeViewmplement {
        public TimeInfo getCurTimeInfo();
    }

}

