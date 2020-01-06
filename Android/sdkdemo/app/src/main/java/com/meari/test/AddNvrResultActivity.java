package com.meari.test;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.interfaces.DraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.callback.IAddDeviceCallback;
import com.meari.sdk.callback.INVRStatusCallback;
import com.meari.sdk.callback.IRequestDeviceShareCallback;
import com.meari.test.adapter.ScanningNVRResultAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.ProgressLoadingDialog;
import com.meari.test.widget.RoundProgressBar;
import com.ppstrong.ppsplayer.BaseDeviceInfo;
import com.meari.test.common.CameraSearchListener;
import com.meari.test.utils.MangerCameraScanUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.TimeZone;

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

public class AddNvrResultActivity extends BaseActivity implements CameraSearchListener {
    private ScanningNVRResultAdapter mAdapter;
    private ArrayList<NVRInfo> mNVRInfoList;
    private Context mContext;
    private PullToRefreshRecyclerView mPullToRefreshRecyclerView;
    private String mSid;
    private String pwd = "";
    private MangerCameraScanUtils mMangerCameraScanUtils;
    private final int HANDLER_MSG_ADD = 100;                    // 添加设备
    private final int HANDLER_MSG_FINISH = 101;                    // 搜索完成
    private boolean mBSearch;
    private String mTimeZone;
    private RoundProgressBar mProgressBar;
    private HashMap<String, BaseDeviceInfo> mHasMap = new HashMap<>();
    private View mBottomView;
    private String mRegion;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scanning);
        getTopTitleView();
        initData();
        initView();
        if (this.getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(this));
        }
        mMangerCameraScanUtils = new MangerCameraScanUtils(this.mSid, this.pwd, 0,this, false);
        mMangerCameraScanUtils.startSearchDevice(false, -1,100, ActivityType.ACTIVITY_ADD_NVR_CAMERA, Preference.getPreference().getToken());
        setSearchView(true);
    }

    private void initData() {
        this.mContext = this;
        this.mNVRInfoList = new ArrayList<>();
        WifiInfo wifi = getWiFiInfo();
        if (wifi == null) {
            CommonUtils.showToast(getString(R.string.location_waring));
            finish();
            return;
        }
        mSid = wifi.getSSID();
        mSid = mSid.substring(1, mSid.length() - 1);
        TimeZone tz = TimeZone.getDefault();
        int offset = tz.getRawOffset();//时间偏移量
        int offsetSec = offset / 1000;
        String formatStr = getString(R.string.utc_format);
        this.mTimeZone = String.format(formatStr, offsetSec / 3600, offset % 60);
    }

    private WifiInfo getWiFiInfo() {
        WifiInfo wifi = NetUtil.getConnectWifiInfo(this);
        return wifi;
    }

    private void setSearchView(boolean bSearch) {
        this.mBSearch = bSearch;
        if (mBSearch) {
            this.action_bar_rl.setVisibility(View.GONE);
            this.mProgressBar.setVisibility(View.VISIBLE);
            this.mBottomView.setVisibility(View.VISIBLE);
        } else {
            this.action_bar_rl.setVisibility(View.VISIBLE);
            this.mProgressBar.setVisibility(View.GONE);
            this.mBottomView.setVisibility(View.GONE);
        }
    }

    private void initView() {
        this.mCenter.setText(R.string.add_nvr);
        this.mRightText.setText(R.string.redo);
        mProgressBar = findViewById(R.id.search_progress);
        mProgressBar.setProgress(0);
        mProgressBar.setVisibility(View.VISIBLE);
        mAdapter = new ScanningNVRResultAdapter(mContext, this);
        mAdapter.setOnWifiInfoItemClick(onImgViewAddCameraClick);
        mPullToRefreshRecyclerView = findViewById(R.id.listview_layout);
        mPullToRefreshRecyclerView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
        mPullToRefreshRecyclerView.setLastUpdatedLabel(CommonDateUtils.getRefreshDate());
        mPullToRefreshRecyclerView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener2<RecyclerView>() {
            @Override
            public void onPullDownToRefresh(PullToRefreshBase<RecyclerView> refreshView) {
                onRefresh();
            }

            @Override
            public void onPullUpToRefresh(PullToRefreshBase<RecyclerView> refreshView) {

            }
        });
        mPullToRefreshRecyclerView.getRefreshableView().setLayoutManager(new LinearLayoutManager(this));
        TextView textView = findViewById(R.id.pps_back_home);
        textView.setText(getString(R.string.back_nvr));
        mPullToRefreshRecyclerView.getRefreshableView().setAdapter(mAdapter);
        mBottomView = LayoutInflater.from(this).inflate(R.layout.layout_add_bottom, null);
        SimpleDraweeView drawView = mBottomView.findViewById(R.id.bg_loading);
        DraweeController mController = Fresco.newDraweeControllerBuilder()
                .setAutoPlayAnimations(true)
                .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.ic_loading))//设置uri
                .build();
        drawView.setController(mController);
        mAdapter.setFooterView(mBottomView);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_APSETTING:
                if (requestCode == RESULT_OK) {
                    finish();
                }
        }
    }

    private boolean IsExists(NVRInfo NVRInfo) {
        for (int i = 0; i < this.mNVRInfoList.size(); i++) {
            if (NVRInfo.getDeviceUUID().equals(this.mNVRInfoList.get(i).getDeviceUUID())) {
                this.mNVRInfoList.get(i).setAddStatus(NVRInfo.getAddStatus());
                return true;
            }
        }
        return false;
    }

    @OnClick(R.id.pps_back_home)
    public void goBackHome() {
        setResult(RESULT_OK);
        finish();
    }

    /**
     * 点击添加NVRInfo
     */
    private ScanningNVRResultAdapter.OnImgViewAddCameraClick onImgViewAddCameraClick = new ScanningNVRResultAdapter.OnImgViewAddCameraClick() {
        @Override
        public void onItemClick(NVRInfo NVRInfo) {
            mAdapter.notifyDataSetChanged();
        }
    };


    public void checkDev() {
        if (!this.mBSearch) {
            if (mMangerCameraScanUtils != null) {
                mMangerCameraScanUtils.startSearchDevice(false, -1,100, ActivityType.ACTIVITY_ADD_NVR_CAMERA,Preference.getPreference().getToken());
                setSearchView(true);
            }
        }
    }
//
//    @Override
//    public void callback(ResponseData data, int tag) {
//        stopProgressDialog();
//        String uuid;
//        super.callback(data, tag);
//        if (data.isErrorCaught()) {
//            if (tag != 0)
//                CommonUtils.showToast(data.getErrorMessage());
//        } else {
//            switch (tag) {
//                case 0:
//                    mPullToRefreshRecyclerView.onRefreshComplete();
//                    ArrayList<NVRInfo> deviceList = JsonUtil.getNvrLists(data.getJsonResult().optBaseJSONArray("result"));
//                    for (int i = 0; i < deviceList.size(); i++) {
//                        NVRInfo info = deviceList.get(i);
//                        SearchInfo searchInfo = mHasMap.get(info.getSnNum());
//                        if (searchInfo != null) {
//                            String UUID = mHasMap.get(info.getSnNum()).getUuid();
//                            info.setDeviceUUID(UUID);
//                            if (!IsExists(info)) {
//                                this.mNVRInfoList.add(info);
//                            }
//                        }
//                    }
//                    mAdapter.setNewData(this.mNVRInfoList);
//                    mAdapter.notifyDataSetChanged();
//                    break;
//                case 1:
//                    CommonUtils.showToast(getString(R.string.add_suc));
//                    uuid = data.getJsonResult().optString("nvrNum");
//                    mAdapter.setStatus(uuid, 1);
//                    if (mAdapter.getItemCount() == 1 && !mBSearch) {
//                        goBackHome();
//                    }
//                    break;
//                case 2:
//                    CommonUtils.showToast(getString(R.string.waiting_deal_share));
//                    String snNum = data.getJsonResult().optString("snNum");
//                    mAdapter.setStatusBySn(snNum, 5);
//                    if (mAdapter.getItemCount() == 1 && !mBSearch) {
//                        goBackHome();
//                    }
//                    break;
//                default:
//                    break;
//            }
//        }
//    }

    private void onRefresh() {
        checkDev();
        if (this.mNVRInfoList == null || this.mNVRInfoList.size() == 0) {
            mPullToRefreshRecyclerView.onRefreshComplete();
            return;
        }
        MeariUser.getInstance().checkNvrStatus(mNVRInfoList, this ,new INVRStatusCallback() {
            @Override
            public void onSuccess(ArrayList<NVRInfo> deviceList) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                for (int i = 0; i < deviceList.size(); i++) {
                    NVRInfo info = deviceList.get(i);
                    BaseDeviceInfo searchInfo = mHasMap.get(info.getSnNum());
                    if (searchInfo != null) {
                        String UUID = mHasMap.get(info.getSnNum()).getDeviceUUID();
                        info.setDeviceUUID(UUID);
                        if (!IsExists(info)) {
                            mNVRInfoList.add(info);
                        }
                    }
                }
                mAdapter.setNewData(mNVRInfoList);
                mAdapter.notifyDataSetChanged();
            }

            @Override
            public void onError(int code, String error) {

            }
        });

    }

    @OnClick(R.id.right_text)
    public void onRefreshClick() {
        mPullToRefreshRecyclerView.onRefreshComplete();
        if (this.mBSearch) {
            return;
        } else {
            if (mMangerCameraScanUtils != null) {
                mMangerCameraScanUtils.startSearchDevice(false, -1,100, ActivityType.ACTIVITY_ADD_NVR_CAMERA,Preference.getPreference().getToken());
                setSearchView(true);
            }
        }
    }


    public void dealDevice(NVRInfo info) {

        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        if (info.getAddStatus() == 3) {
            addDevice(info);
        } else if (info.getAddStatus() == 2) {
            requestShareDevice(info);
        }
    }


    public void addDevice(NVRInfo info) {
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().addNvrDevice(info,this , new IAddDeviceCallback() {
            @Override
            public void onSuccess(int code, String sn, String deviceID) {
                stopProgressDialog();
                CommonUtils.showToast(getString(R.string.add_suc));
                mAdapter.setStatus(sn, 1);
                if (mAdapter.getItemCount() == 1 && !mBSearch) {
                    goBackHome();
                }
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }
        });
        startProgressDialog();
    }

    private void requestShareDevice(BaseDeviceInfo info) {
        startProgressDialog();
        MeariUser.getInstance().requestDeviceShare(info,this , new IRequestDeviceShareCallback() {

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }

            @Override
            public void onSuccess(String sn) {
                stopProgressDialog();
                CommonUtils.showToast(getString(R.string.waiting_deal_share));
                mAdapter.setStatusBySn(sn, 5);
                if (mAdapter.getItemCount() == 1 && !mBSearch) {
                    goBackHome();
                }
            }
        });
    }


    @Override
    public void finish() {
        super.finish();
        mNVRInfoList.clear();
        mMangerCameraScanUtils.finish();
    }

    @Override
    public void onCameraSearchDetected(CameraInfo uuid) {
        mHasMap.put(uuid.getSnNum(), uuid);
        Message msg = new Message();
        msg.what = HANDLER_MSG_ADD;
        msg.obj = uuid;
        searchHandler.sendMessage(msg);
    }

    @Override
    public void onCameraSearchFinished() {
        Message msg = new Message();
        msg.what = HANDLER_MSG_FINISH;
        searchHandler.sendMessage(msg);
    }

    @Override
    public void onRefreshProgress(int time) {
        mProgressBar.setProgress(100 - time);
        if (time == 0) {
            this.action_bar_rl.setVisibility(View.VISIBLE);
            this.mProgressBar.setVisibility(View.GONE);
            this.mProgressBar.setProgress(0);
        }
        mProgressBar.setContent(String.valueOf(time));
    }


    /**
     * 添加设备Handler
     */
    @SuppressLint("HandlerLeak")
    private Handler searchHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case HANDLER_MSG_ADD:
                    if (!NetUtil.checkNet(AddNvrResultActivity.this)) {
                        CommonUtils.showToast(getString(R.string.network_unavailable));
                    }
                    BaseDeviceInfo infos = (BaseDeviceInfo) msg.obj;
//                    OKHttpRequestParams params = new OKHttpRequestParams();
//                    params.put("nvrNumList", selectCamera(infos).toString());
//                    OkGo
//                            .post(Preference.BASE_URL_DEFAULT + API_METHOD_GET_NVR)
//                            .headers(CommonUtils.getOKHttpHeader(AddNvrResultActivity.this, API_METHOD_GET_NVR))
//                            .params(params.getParams())
//                            .id(0)
//                            .execute(new StringCallback(AddNvrResultActivity.this));
                    break;
                case HANDLER_MSG_FINISH:
                    setSearchView(false);
                    mMangerCameraScanUtils.stopDevieceSearch();
                    break;
            }
        }
    };
}

