package com.meari.test;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.RequiresApi;
import android.view.Gravity;
import android.view.View;
import android.widget.CheckBox;
import android.widget.TextView;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.common.CameraSleepType;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.sdk.bean.SleepTimeInfo;
import com.meari.test.pop.TimeSetPop;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONArray;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/19
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class HomeTimeSetActivity extends BaseActivity implements View.OnClickListener {
    private int[] mWeekTexts = {R.id.text_mon_time, R.id.text_tue_time,
            R.id.text_wen_time, R.id.text_thu_time,
            R.id.text_fri_time, R.id.text_sat_time, R.id.text_sun_time,};
    private int[] mWeekCheck = {R.id.text_mon_check, R.id.text_tue_check,
            R.id.text_wen_check, R.id.text_thu_check,
            R.id.text_fri_check, R.id.text_sat_check, R.id.text_sun_check,};
    private int[] mWeekCheckLayout = {R.id.layout_mon, R.id.layout_tue,
            R.id.layout_wen, R.id.layout_thu,
            R.id.layout_fri, R.id.layout_sta, R.id.layout_sun,};
    private SleepTimeInfo mInfo;
    private String[] mWeekString;
    @BindView(R.id.text_start_time)
    public TextView mStartTime;
    @BindView(R.id.text_end_time)
    public TextView mEndTime;
    private TimeSetPop mStartTimePop;
    private TimeSetPop mEndTimePop;
    private ArrayList<Integer> mDays = new ArrayList<>();
    private ArrayList<SleepTimeInfo> mTimeInfos;
    private boolean mIsAddMode = false;
    private int mPosition = 0;
    private final int MESSAGE_SETTING_FAILED = 1006;
    private ArrayList<String> mHourItems = new ArrayList<>();
    private ArrayList<ArrayList<String>> mMinItems = new ArrayList<>();
    private int mType;
    private CameraInfo mCameraInfo;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_time_home_set);
        initData();
        initView();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.time_period_title));
        if (mWeekCheck != null) {
            for (int i = 0; i < mWeekString.length; i++) {
                TextView view = findViewById(mWeekTexts[i]);
                view.setText(mWeekString[i]);
            }
        }
        for (int id : mWeekCheckLayout) {
            findViewById(id).setOnClickListener(this);
        }
        initCheckBox();
        mStartTime.setText(mInfo.getStartTime());
        mEndTime.setText(mInfo.getEndTime());
        mStartTimePop = new TimeSetPop(this);
        mStartTimePop.setPicker(mHourItems, mMinItems, true);
        mStartTimePop.setOnoptionsSelectListener(new TimeSetPop.OnOptionsSelectListener() {

            @Override
            public void onOptionsSelect(int options1, int option2) {
                String tx = mHourItems.get(options1) + ":" + mMinItems.get(options1).get(option2);
                mStartTime.setText(tx);
            }
        });
        mEndTimePop = new TimeSetPop(this);
        mEndTimePop.setPicker(mHourItems, mMinItems, true);
        mEndTimePop.setSelectOptions(0, 0);
        mEndTimePop.setOnoptionsSelectListener(new TimeSetPop.OnOptionsSelectListener() {

            @Override
            public void onOptionsSelect(int options1, int option2) {
                String tx = mHourItems.get(options1) + ":" + mMinItems.get(options1).get(option2);
                mEndTime.setText(tx);
            }
        });
        this.mRightBtn.setImageResource(R.drawable.btn_right_submit);
        this.mRightBtn.setVisibility(View.VISIBLE);
    }

    private void initCheckBox() {
        if (!mIsAddMode) {
            for (int i = 0; i < mInfo.getRepeat().size(); i++) {
                int day = mInfo.getRepeat().get(i);
                CheckBox checkbox = findViewById(mWeekCheck[day - 1]);
                checkbox.setChecked(true);
            }
        }
    }

    public static String getTime(Date date) {
        SimpleDateFormat format = new SimpleDateFormat("HH:mm");
        return format.format(date);
    }

    private void initData() {
        mInfo = (SleepTimeInfo) getIntent().getExtras().getSerializable("SleepTimeInfo");
        mCameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        mTimeInfos = (ArrayList<SleepTimeInfo>) getIntent().getExtras().getSerializable("HomeTimeInfos");
        mIsAddMode = getIntent().getExtras().getBoolean("add", false);
        mPosition = getIntent().getExtras().getInt("position", 0);
        mType = getIntent().getExtras().getInt("type", 0);
        mWeekString = getResources().getStringArray(R.array.WeekString);
        ArrayList<String> minItems = new ArrayList<>();
        for (int i = 0; i <= 59; i++) {
            minItems.add(String.format(getString(R.string.hour_format), i));
        }
        for (int i = 0; i <= 24; i++) {
            mHourItems.add(String.format(getString(R.string.hour_format), i));
            if (i != 24)
                mMinItems.add(minItems);
            else {
                ArrayList<String> items = new ArrayList<>();
                items.add("00");
                mMinItems.add(items);
            }
        }
    }

    @OnClick(R.id.start_layout)
    public void onStartClick() {
        String startTime = mStartTime.getText().toString();
        if (startTime == null || startTime.isEmpty()) {
            CommonUtils.showToast(R.string.time_error);
            return;
        }
        String[] stattTime = startTime.split(":");
        if (stattTime.length != 2) {
            CommonUtils.showToast(R.string.time_error_start);
            return;
        }
        if (!mStartTimePop.isShowing()) {
            mStartTimePop.showAtLocation(mStartTime, Gravity.BOTTOM, 0, 0);
            mStartTimePop.setSelectOptions(Integer.valueOf(stattTime[0]), Integer.valueOf(stattTime[1]));
        }
    }

    @OnClick(R.id.end_layout)
    public void onEndClick() {
        String endTime = mEndTime.getText().toString();
        if (endTime == null || endTime.isEmpty()) {
            CommonUtils.showToast(R.string.time_error_end);
            return;
        }
        String[] endTimes = endTime.split(":");
        if (endTimes.length != 2) {
            CommonUtils.showToast(R.string.time_error_end);
            return;
        }
        if (!mEndTimePop.isShowing()) {
            mEndTimePop.showAtLocation(mEndTime, Gravity.BOTTOM, 0, 0);
            mEndTimePop.setSelectOptions(Integer.valueOf(endTimes[0]), Integer.valueOf(endTimes[1]));
        }
    }

    @Override
    public void onClick(View params) {
        switch (params.getId()) {
            case R.id.layout_mon:
                onCheckLayoutClick(0);
                break;
            case R.id.layout_tue:
                onCheckLayoutClick(1);
                break;
            case R.id.layout_wen:
                onCheckLayoutClick(2);
                break;
            case R.id.layout_thu:
                onCheckLayoutClick(3);
                break;
            case R.id.layout_fri:
                onCheckLayoutClick(4);
                break;
            case R.id.layout_sta:
                onCheckLayoutClick(5);
                break;

            case R.id.layout_sun:
                onCheckLayoutClick(6);

                break;
            default:
                break;
        }
    }

    private void onCheckLayoutClick(int position) {
        if (position < 0 || position >= mWeekCheck.length) {
            return;
        }
        CheckBox daycheck = findViewById(mWeekCheck[position]);
        daycheck.setChecked(!daycheck.isChecked());
    }

    @OnClick(R.id.submitRegisterBtn)
    public void onPostSleepTime() {
        boolean available = isTimeAvailable();
        if (available) {
            startProgressDialog(getString(R.string.waiting));
            getProgressDialog().setOnCancelListener(new DialogInterface.OnCancelListener() {
                @Override
                public void onCancel(DialogInterface dialog) {
                    finish();
                }
            });
            ArrayList<SleepTimeInfo>sleepTimeInfos = getSleepTimes();
            boolean isNeedSetting = mType == 1 && sleepTimeInfos != null && sleepTimeInfos.size() == 0;
            CommonUtils.getSdkUtil().setCameraSleepTime(isNeedSetting ? CameraSleepType.SLEEP_TIME : null, sleepTimeInfos, new CameraPlayerListener() {
                @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
                @Override
                public void PPSuccessHandler(String successMsg) {
                    SleepTimeInfo info = new SleepTimeInfo();
                    info.setStartTime(mStartTime.getText().toString());
                    info.setEndTime(mEndTime.getText().toString());
                    if (mIsAddMode)
                        info.setEnable(true);
                    else {
                        info.setEnable(mInfo.isEnable());
                    }
                    info.setRepeat(getSleepDay());
                    if (mIsAddMode) {
                        mTimeInfos.add(0, info);
                    } else {
                        mTimeInfos.remove(mPosition);
                        mTimeInfos.add(mPosition, info);
                    }
                    if (mType == 1) {
                        if (mTimeInfos.size() > 0) {
                            mCameraInfo.setSleep( CameraSleepType.SLEEP_TIME);
                        }
                    }
                    Bundle bundle = new Bundle();
                    bundle.putSerializable("HomeTimeInfos", mTimeInfos);
                    Intent intent = new Intent();
                    intent.putExtras(bundle);
                    setResult(RESULT_OK, intent);
                    finish();
                    stopProgressDialog();
                }

                @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
                @Override
                public void PPFailureError(String errorMsg) {
                    stopProgressDialog();
                    if (mEventHandle != null)
                        mEventHandle.sendEmptyMessage(MESSAGE_SETTING_FAILED);
                }
            });

        }

    }

    @Override
    public void finish() {
        super.finish();
        mEventHandle = null;
    }

    private Handler mEventHandle = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_SETTING_FAILED:
                    CommonUtils.showToast(getString(R.string.setting_failded));
                    break;
                default:
                    break;
            }
        }
    };

    public boolean isTimeAvailable() {
        String startTime = mStartTime.getText().toString();
        if (startTime == null || startTime.isEmpty()) {
            CommonUtils.showToast(R.string.time_error);
            return false;
        }
        String[] startTimes = startTime.split(":");
        if (startTimes.length != 2) {
            CommonUtils.showToast(R.string.time_error_start);
            return false;
        }
        int startToIndex = Integer.valueOf(startTimes[0]) * 60 + Integer.valueOf(startTimes[1]);

        String endTime = mEndTime.getText().toString();
        if (endTime == null || endTime.isEmpty()) {
            CommonUtils.showToast(R.string.time_error);
            return false;
        }
        String[] endTimes = endTime.split(":");
        if (endTimes.length != 2) {
            CommonUtils.showToast(R.string.time_error_end);
            return false;
        }
        int endToIndex;
        endToIndex = Integer.valueOf(endTimes[0]) * 60 + Integer.valueOf(endTimes[1]);
        if (endToIndex <= startToIndex) {
            CommonUtils.showToast(R.string.time_error);
            return false;

        }
        ArrayList<Integer> days = getSleepDay();
        if (days.size() == 0) {
            CommonUtils.showToast(R.string.time_error_day);
            return false;
        }
        SleepTimeInfo info = new SleepTimeInfo();
        info.setStartTime(mStartTime.getText().toString());
        info.setEndTime(mEndTime.getText().toString());
        if (mIsAddMode)
            info.setEnable(true);
        else
            info.setEnable(mInfo.isEnable());
        info.setRepeat(getSleepDay());
        if (IsContain(info)) {
            CommonUtils.showToast(R.string.time_slot_exit);
            return false;
        }

        return true;
    }

    public boolean IsContain(SleepTimeInfo info) {
        if (mTimeInfos == null || mTimeInfos.size() == 0)
            return false;
        else {
            for (SleepTimeInfo SleepTimeInfo : mTimeInfos) {
                if (SleepTimeInfo.equals(info))
                    return true;
            }
        }
        return false;
    }

    private ArrayList<Integer> getSleepDay() {
        if (mDays == null)
            mDays = new ArrayList<>();
        mDays.clear();
        for (int i = 0; i < mWeekCheck.length; i++) {
            CheckBox checkBox = (CheckBox) findViewById(mWeekCheck[i]);
            if (checkBox.isChecked()) {
                mDays.add(i + 1);
            }
        }
        return mDays;
    }

    public JSONArray getHomeTimeString() {
        BaseJSONArray jsonArray = new BaseJSONArray();
        if (mIsAddMode) {
            BaseJSONObject json = new BaseJSONObject();
            json.put("enable", true);
            json.put("start_time", mStartTime.getText().toString());
            json.put("stop_time", mEndTime.getText().toString());
            json.put("repeat", getSleepDayTostring());
            jsonArray.put(json);
        }
        for (int i = 0; i < mTimeInfos.size(); i++) {
            SleepTimeInfo info = mTimeInfos.get(i);
            if (i == mPosition && !mIsAddMode) {
                BaseJSONObject json = new BaseJSONObject();
                json.put("enable", mInfo.isEnable());
                json.put("start_time", mStartTime.getText().toString());
                json.put("stop_time", mEndTime.getText().toString());
                json.put("repeat", getSleepDayTostring());
                jsonArray.put(json);
                continue;
            }
            BaseJSONObject json = new BaseJSONObject();
            json.put("enable", info.isEnable());
            json.put("start_time", info.getStartTime());
            json.put("stop_time", info.getEndTime());
            json.put("repeat", getSleepDayJsonArray(info.getRepeat()));
            jsonArray.put(json);
        }

        return jsonArray;
    }
    public ArrayList<SleepTimeInfo> getSleepTimes() {
        ArrayList<SleepTimeInfo>sleepTimeInfos = new ArrayList<>();
        if (mIsAddMode) {
            SleepTimeInfo info = new SleepTimeInfo();
            info.setEnable(true);
            info.setStartTime( mStartTime.getText().toString());
            info.setEndTime(mEndTime.getText().toString());
            info.setRepeat(getSleepDay());
            sleepTimeInfos.add(info);
        }
        for (int i = 0; i < mTimeInfos.size(); i++) {
            SleepTimeInfo info = mTimeInfos.get(i);
            if (i == mPosition && !mIsAddMode) {
                info.setEnable(mInfo.isEnable());
                info.setStartTime( mStartTime.getText().toString());
                info.setEndTime( mEndTime.getText().toString());
                info.setRepeat( getSleepDay());
            }
            sleepTimeInfos.add(info);
        }

        return sleepTimeInfos;
    }
    public JSONArray getSleepDayJsonArray(ArrayList<Integer> days) {
        if (days == null)
            return new JSONArray();
        JSONArray daysString = new JSONArray();
        for (int i = 0; i < days.size(); i++) {
            daysString.put(days.get(i));
        }
        return daysString;

    }
    public JSONArray getSleepDayTostring() {
        if (mDays == null)
            return new JSONArray();
        JSONArray daysString = new JSONArray();
        for (int i = 0; i < mDays.size(); i++) {
            daysString.put(mDays.get(i));
        }
        return daysString;

    }

}

