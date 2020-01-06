package com.meari.test;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.RequiresApi;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.SleepTimeInfo;
import com.meari.sdk.common.CameraSleepType;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.adapter.HomeTimeAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.ppstrong.listener.SleepTimeListener;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONArray;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/18
 * 描    述：时间模式设置
 * 修订历史：
 * ================================================
 */

public class HomeModelActivity extends BaseActivity {

    private HomeTimeAdapter mAdapter;
    private ArrayList<SleepTimeInfo> mTimeInfos;
    private final int EDIT = 1;
    private final int UNEDIT = 0;
    private final int MESSAGE_SUCESS = 1000;
    private final int MESSAGE_FAILED = 1001;
    private final int MESSAGE_CHANGE_FAILED = 1002;
    private final int MESSAGE_DELETE_SUCCESS = 1003;
    private final int MESSAGE_DELETE_FIALED = 1004;
    private final int MESSAGE_SETTING_SUCCESS = 1005;
    private final int MESSAGE_SETTING_FAILED = 1006;
    private SleepTimeInfo mChangeHomeInfo;
    private Dialog mPop;
    @BindView(R.id.btn_delete)
    public View mMsgDelBtn;
    @BindView(R.id.text_desc)
    public TextView mDescText;
    @BindView(R.id.time_recyclerView)
    public RecyclerView mRecyclerView;
    public int mType;//1表示需要设置模式为实践模式
    private CameraInfo mCameraInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        initData();
        initView();
        getCameraSleepTimes();
    }

    private void initData() {
        mTimeInfos = new ArrayList<>();
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            this.mCameraInfo = (CameraInfo) bundle.getSerializable("cameraInfo");
            mType = bundle.getInt("type", 0);
        }
    }

    private void initView() {
        getTopTitleView();
        initRecyclerView();
        this.mCenter.setText(getString(R.string.home_title));
        this.mDescText.setText(getString(R.string.home_desc));
        if (mTimeInfos.size() < 7) {
            showAddView();
        } else {
            hideBottom();
        }
        findViewById(R.id.time_content_layout).setVisibility(View.GONE);
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        int margin = DisplayUtil.dpToPx(this, 12);
        this.mRightBtn.setPadding(margin, margin, margin, margin);
        this.mRightBtn.setTag(UNEDIT);
        if (mTimeInfos.size() > 0)
            this.mRightBtn.setVisibility(View.VISIBLE);
        startProgressDialog();
    }

    public void onResumeStatus() {
        mAdapter.changAddDataDeviceMsg(0);
        if (mAdapter != null && mAdapter.getItemCount() > 0)
            this.mRightBtn.setVisibility(View.VISIBLE);
        else {
            this.mRightBtn.setVisibility(View.GONE);
            showEmptyView();
        }
        if (mTimeInfos.size() < 7) {
            showAddView();
        } else {
            hideBottom();
        }
        this.mRightBtn.setTag(0);
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        this.mMsgDelBtn.setVisibility(View.GONE);
        this.mDescText.setText(getString(R.string.home_desc));
        mAdapter.setEditStatus(false);
        mAdapter.notifyDataSetChanged();
    }

    public void initRecyclerView() {
        mAdapter = new HomeTimeAdapter(this, this);
        this.mRecyclerView.setAdapter(mAdapter);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mRecyclerView.setLayoutManager(linearLayoutManager);
    }

    public void showErrorView() {
        TextView errorText = findViewById(R.id.text_error);
        errorText.setVisibility(View.VISIBLE);
        errorText.setText(getString(R.string.get_time_failed));
        findViewById(R.id.time_content_layout).setVisibility(View.GONE);
    }

    public void showEmptyView() {
        TextView errorText = findViewById(R.id.text_error);
        errorText.setVisibility(View.VISIBLE);
        errorText.setText(getString(R.string.get_time_empty));
        this.mRightBtn.setVisibility(View.GONE);
        this.mMsgDelBtn.setVisibility(View.GONE);
        findViewById(R.id.time_content_layout).setVisibility(View.GONE);
    }

    public void postChangeTime(SleepTimeInfo info) {
        this.mChangeHomeInfo = info;
        startProgressDialog();
        CommonUtils.getSdkUtil().setCameraSleepTime(null, getSleepTimes(), new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isFinishing() || isDestroyed())
                    return;
                stopProgressDialog();
                if (mEventHandle != null)
                    mEventHandle.sendEmptyMessage(MESSAGE_SETTING_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (isFinishing() || mEventHandle == null)
                    return;
                stopProgressDialog();
                if (mEventHandle != null)
                    mEventHandle.sendEmptyMessage(MESSAGE_SETTING_FAILED);
            }
        });
    }

    @OnClick(R.id.add_time)
    public void onAddTimeClick() {
        if (mAdapter.isEditStatus()) {
            return;
        }
        SleepTimeInfo info = new SleepTimeInfo();
        info.setStartTime("00:00");
        info.setEndTime("00:00");
        info.setEnable(false);
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        intent.setClass(this, HomeTimeSetActivity.class);
        bundle.putSerializable("SleepTimeInfo", info);
        bundle.putSerializable("cameraInfo", mCameraInfo);
        bundle.putSerializable("HomeTimeInfos", mTimeInfos);
        bundle.putInt("type", mType);
        bundle.putBoolean("add", true);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_SETSLEEPTIME);
    }

    @OnClick(R.id.submitRegisterBtn)
    public void onEditClick() {
        int tag = (int) mRightBtn.getTag();
        if (tag == UNEDIT) {
            setDeleteStatus(EDIT);
            mAdapter.changAddDataDeviceMsg(1);
            mRightBtn.setTag(1);
            mRightBtn.setImageResource(R.drawable.btn_cancel);
            mAdapter.notifyDataSetChanged();
            mDescText.setText(getString(R.string.home_desc_edit));
        } else {
            mRightBtn.setTag(0);
            mRightBtn.setImageResource(R.drawable.btn_delete);
            onResumeStatus();
        }

    }

    // 0表示处于未编辑状态，支持下拉刷新和上拉加载更多，1表示处于未编辑状态，不支持下拉刷新和上拉加载更多
    public void setDeleteStatus(int status) {
        if (status == 0) {
            this.mAdapter.setEditStatus(false);
            this.mRightBtn.setTag(0);
            this.mRightBtn.setImageResource(R.drawable.btn_delete);
            this.mMsgDelBtn.setVisibility(View.GONE);
            if (mAdapter.getItemCount() > 0)
                this.mRightBtn.setVisibility(View.VISIBLE);
            else
                this.mRightBtn.setVisibility(View.GONE);
            if (mTimeInfos.size() < 7) {
                showAddView();
            } else {
                hideBottom();
            }
        } else {
            this.mAdapter.setEditStatus(true);
            showDeleteView();
        }
    }

    @OnClick(R.id.btn_delete)
    public void onMessageDeviceDelclick() {
        if (mAdapter.isNothingSelect())
            CommonUtils.showToast(R.string.nothing_select);
        else
            showonMessageDeviceDelDialg();
    }

    private void showonMessageDeviceDelDialg() {
        if (this.mPop == null) {
            this.mPop = CommonUtils.showDlg(this, getString(R.string.app_meari_name), this.getString(R.string.sure_delete),
                    getString(R.string.ok), positiveClick,
                    getString(R.string.cancel), negativeClick, false);
        }
        this.mPop.show();
    }

    DialogInterface.OnClickListener positiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            onOkClick();
        }
    };

    private void onOkClick() {
        BaseJSONObject json = new BaseJSONObject();
        json.put("action", "POST");
        json.put("deviceurl", "http://127.0.0.1/devices/settings");
        ArrayList<SleepTimeInfo> sleepTimeInfos = getSleepTimes();
        JSONArray timeJsonArray = getHomeTimeString();
        json.put("sleep_time", timeJsonArray);
        if (mType == 1) {
            if (timeJsonArray.length() == 0) {
                json.put("sleep", mCameraInfo.getSleep());
            }
        }
        boolean isNeedSetting = mType == 1 && sleepTimeInfos != null && sleepTimeInfos.size() == 0;
        CommonUtils.getSdkUtil().setCameraSleepTime(isNeedSetting ? mCameraInfo.getSleep() : null, sleepTimeInfos, new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (isFinishing() || isDestroyed())
                    return;
                stopProgressDialog();
                if (mEventHandle != null)
                    mEventHandle.sendEmptyMessage(MESSAGE_DELETE_SUCCESS);
            }

            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPFailureError(String errorMsg) {
                if (isFinishing() || isDestroyed())
                    return;
                stopProgressDialog();
                if (mEventHandle != null) {
                    mEventHandle.sendEmptyMessage(MESSAGE_DELETE_FIALED);
                }
            }
        });
    }

    DialogInterface.OnClickListener negativeClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };

    public void getCameraSleepTimes() {
        startProgressDialog(getString(R.string.waiting));
        getProgressDialog().setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                finish();
            }
        });
        CommonUtils.getSdkUtil().queryCameraSleepTime(new SleepTimeListener() {
            @Override
            public void PPSuccessHandler(ArrayList<SleepTimeInfo> sleepTimeInfos) {
                if (mEventHandle == null)
                    return;
                mEventHandle.sendEmptyMessage(MESSAGE_SUCESS);
                stopProgressDialog();
                mTimeInfos = sleepTimeInfos;
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mEventHandle == null)
                    return;
                stopProgressDialog();
                mEventHandle.sendEmptyMessage(MESSAGE_FAILED);
            }
        });

    }

    @SuppressLint("HandlerLeak")
    private Handler mEventHandle = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_SUCESS:
                    showTimeList();
                    break;
                case MESSAGE_FAILED:
                    showErrorView();
                    hideBottom();
                    break;
                case MESSAGE_CHANGE_FAILED:
                    ChangeTimeFailed();
                    break;
                case MESSAGE_DELETE_SUCCESS:
                    CommonUtils.showToast(getString(R.string.delete_success));
                    mAdapter.deleteTime();
                    onResumeStatus();
                    break;
                case MESSAGE_DELETE_FIALED:
                    CommonUtils.showToast(getString(R.string.delete_file));
                    break;
                case MESSAGE_SETTING_FAILED:
                    CommonUtils.showToast(getString(R.string.setting_failded));
                    break;
                case MESSAGE_SETTING_SUCCESS:
                    CommonUtils.showToast(getString(R.string.setting_successfully));
                    break;
                default:
                    break;
            }
        }
    };

    private void ChangeTimeFailed() {
        if (this.mChangeHomeInfo == null)
            return;
        mAdapter.changeHomeTimeEnable(mChangeHomeInfo);
    }

    private void showTimeList() {
        mAdapter.setHomeTimeInfos(mTimeInfos);
        mAdapter.notifyDataSetChanged();
        if (mTimeInfos.size() == 0) {
            showEmptyView();
        } else {
            this.mRightBtn.setVisibility(View.VISIBLE);
            findViewById(R.id.text_error).setVisibility(View.GONE);
            findViewById(R.id.time_content_layout).setVisibility(View.VISIBLE);
        }
        if (mTimeInfos.size() < 7) {
            showAddView();
        } else
            hideBottom();

    }

    private void showAddView() {
        findViewById(R.id.bottom_view).setVisibility(View.VISIBLE);
        findViewById(R.id.add_time).setVisibility(View.VISIBLE);
        this.mMsgDelBtn.setVisibility(View.GONE);
    }

    public void showDeleteView() {
        findViewById(R.id.bottom_view).setVisibility(View.VISIBLE);
        findViewById(R.id.add_time).setVisibility(View.GONE);
        this.mMsgDelBtn.setVisibility(View.VISIBLE);
    }

    public void hideBottom() {
        findViewById(R.id.bottom_view).setVisibility(View.GONE);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case ActivityType.ACTIVITY_SETSLEEPTIME:
                if (resultCode == RESULT_OK) {
                    Bundle bundle = data.getExtras();
                    mTimeInfos.clear();
                    mTimeInfos = (ArrayList<SleepTimeInfo>) bundle.getSerializable("HomeTimeInfos");
                    showTimeList();
                }
                break;

            default:
                break;
        }
    }

    /**
     * @return get sleep time of setting
     */
    public ArrayList<SleepTimeInfo> getSleepTimes() {
        ArrayList<SleepTimeInfo> list = new ArrayList<>();
        for (int i = 0; i < mAdapter.getItemCount(); i++) {
            SleepTimeInfo info = mAdapter.getHomeTimeInfos().get(i);
            if (info.getDelMsgFlag() != 2) {
                list.add(info);
            }
        }
        return list;
    }

    public JSONArray getHomeTimeString() {
        BaseJSONArray jsonArray = new BaseJSONArray();
        for (int i = 0; i < mAdapter.getItemCount(); i++) {
            SleepTimeInfo info = mAdapter.getHomeTimeInfos().get(i);
            BaseJSONObject json = new BaseJSONObject();
            json.put("enable", info.isEnable());
            json.put("start_time", info.getStartTime());
            json.put("stop_time", info.getEndTime());
            json.put("repeat", getSleepDayTostring(info.getRepeat()));
            if (info.getDelMsgFlag() != 2) {
                jsonArray.put(json);
            }
        }
        return jsonArray;
    }

    public JSONArray getSleepDayTostring(ArrayList<Integer> days) {
        if (days == null)
            return new JSONArray();
        JSONArray daysString = new JSONArray();
        for (int i = 0; i < days.size(); i++) {
            daysString.put(days.get(i));
        }
        return daysString;
    }


    @Override
    public void finish() {
        mEventHandle = null;
        Bundle bundle = new Bundle();
        bundle.putSerializable("HomeTimeInfos", this.mTimeInfos);
        if (mType == 1) {
            if (mTimeInfos.size() > 0) {
                mCameraInfo.setSleep(CameraSleepType.SLEEP_TIME);
            }
        }
        bundle.putSerializable("cameraInfo", this.mCameraInfo);
        Intent intent = new Intent();
        intent.putExtras(bundle);
        setResult(RESULT_OK, intent);
        super.finish();

    }
}
