package com.meari.test;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.wifi.WifiInfo;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.recyclerview.widget.LinearLayoutManager;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.bean.NvrDeviceStatusInfo;
import com.meari.sdk.callback.IBindDeviceCallback;
import com.meari.test.adapter.NvrAddCameraAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.receiver.WifiReceiver;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.RoundProgressBar;
import com.ppstrong.ppsplayer.BaseDeviceInfo;
import com.meari.test.common.CameraSearchListener;
import com.meari.test.utils.MangerCameraScanUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/17
 * 描    述：NVR添加摄像头
 * 修订历史：
 * ================================================
 */

public class AddNvrCameraActivity extends BaseActivity implements CameraSearchListener, WifiReceiver.WifiChangeListener {
    private ArrayList<NvrDeviceStatusInfo> mInfos;
    private NVRInfo mInfo;
    private NvrAddCameraAdapter mAdapter;
    private MangerCameraScanUtils mMangerCameraScan;
    @BindView(R.id.listview_layout)
    public PullToRefreshRecyclerView mPullToRefreshListView;
    private final int HANDLER_MSG_ADD = 100;                    // 添加设备
    private final int HANDLER_MSG_FINISH = 101;                    // 搜索完成
    public boolean mIsFindNvr = false;
    @BindView(R.id.search_progress)
    public RoundProgressBar mProgressBar;
    private WifiReceiver mReceiver;
    @BindView(R.id.text_none_device)
    public TextView mDeviceText;
    private boolean mIsSearching = false;
    private HashMap<String, ArrayList<NvrDeviceStatusInfo>> mSearchHasmap;
    private String mSid;
    private boolean mIsGoRemove = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_nvr_camera);
        initData();
        initView();
        registerWiFiChangeReceiver();
        mMangerCameraScan = new MangerCameraScanUtils(null, null, 0,this, false);
        if (mInfos.size() > 0) {
            mMangerCameraScan.startSearchDevice(false, -1, ActivityType.ACTIVITY_ADD_NVR_CAMERA);
            mIsSearching = true;
        } else {
            mDeviceText.setText(getString(R.string.no_device));
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterReceiver(mReceiver);
    }

    public void registerWiFiChangeReceiver() {
        mReceiver = new WifiReceiver(this);
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction("android.net.conn.CONNECTIVITY_CHANGE");
        registerReceiver(this.mReceiver, exitFilter);
    }

    private void initView() {
        getTopTitleView();
        this.mRightText.setText(R.string.redo);
        this.mCenter.setText(getString(R.string.add_camera_title));
        mPullToRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
//        mPullToRefreshListView.setLastUpdatedLabel(CommonDateUtils.getRefreshDate());
        mPullToRefreshListView.getRefreshableView().setAdapter(mAdapter);
        mPullToRefreshListView.getRefreshableView().setLayoutManager(new LinearLayoutManager(this));
        mPullToRefreshListView.setShowDividers(LinearLayout.SHOW_DIVIDER_NONE);
        mProgressBar.setProgress(0);
        mProgressBar.setVisibility(View.VISIBLE);
        if (mInfos.size() == 0) {
            mPullToRefreshListView.setVisibility(View.GONE);
            findViewById(R.id.loading).setVisibility(View.VISIBLE);
            findViewById(R.id.text_warning).setVisibility(View.GONE);
            mProgressBar.setVisibility(View.GONE);
        } else {
            mPullToRefreshListView.setVisibility(View.VISIBLE);
            findViewById(R.id.loading).setVisibility(View.GONE);
        }

    }

    private void initData() {
        mSearchHasmap = new HashMap<>();
        mInfos = (ArrayList<NvrDeviceStatusInfo>) getIntent().getExtras().getSerializable("unBindCameras");
        mInfo = (NVRInfo) getIntent().getExtras().getSerializable("nvrInfo");
        for (NvrDeviceStatusInfo info : mInfos) {
            info.setAddStatus(0);
        }
        mAdapter = new NvrAddCameraAdapter(this);
    }


    public void postDealCamera(NvrDeviceStatusInfo info) {
        // 检查网络是否可用
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().bindDevice(mInfo.getDeviceID(), info.getDeviceID(), this ,new IBindDeviceCallback() {
            @Override
            public void onSuccess(String deviceID) {
                mPullToRefreshListView.onRefreshComplete();
                mAdapter.changeStatusById(deviceID);
                changeStatusById(deviceID);
            }

            @Override
            public void onError(int code, String error) {
               CommonUtils.showToast(error);
               mPullToRefreshListView.onRefreshComplete();
            }
        });

        startProgressDialog();
    }

    @SuppressLint("HardwareIds")
    public String getWiFiSid() {
        WifiInfo wifi = NetUtil.getConnectWifiInfo(this);
        if (wifi != null) {
            String sid = wifi.getMacAddress();
            sid = sid.substring(1, sid.length() - 1);
            return sid;
        }
        return "";
    }



    public void changeStatusById(String deviceID) {
        for (NvrDeviceStatusInfo info : mInfos) {
            if (info.getDeviceID() == deviceID) {
                info.setAddStatus(1);
                break;
            }
        }
    }

    public void finish() {
        if (mIsSearching)
            mMangerCameraScan.stopSearch();
        ArrayList<NvrDeviceStatusInfo> cameraInfos = getBindCameraInfos();
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putSerializable("bindNvrCameraInfos", cameraInfos);
        bundle.putBoolean("isGoRemove", mIsGoRemove);
        intent.putExtras(bundle);
        setResult(RESULT_OK, intent);
        super.finish();
    }

    public ArrayList<NvrDeviceStatusInfo> getBindCameraInfos() {
        ArrayList<NvrDeviceStatusInfo> cameras = new ArrayList<>();
        List<NvrDeviceStatusInfo> list = mAdapter.getData();
        if (list == null)
            return cameras;
        for (NvrDeviceStatusInfo info : list) {
            if (info.getAddStatus() != 0) {
                cameras.add(info);
            }
        }
        return cameras;
    }

    @Override
    public void onCameraSearchFinished() {
        Message msg = new Message();
        msg.what = HANDLER_MSG_FINISH;
        searchHandler.sendMessage(msg);
    }

    @Override
    public void onRefreshProgress(int time) {
        this.mProgressBar.setProgress(100 - time );
        if (time == 0) {
            this.action_bar_rl.setVisibility(View.VISIBLE);
            this.mProgressBar.setVisibility(View.GONE);
            this.mProgressBar.setProgress(0);
            this.mProgressBar.setContent(String.valueOf(90));
        }
        this.mProgressBar.setContent(String.valueOf(time));
    }

    @Override
    public void onCameraSearchDetected(CameraInfo uuid) {
        Message msg = new Message();
        msg.what = HANDLER_MSG_ADD;
        msg.obj = uuid;
        searchHandler.sendMessage(msg);
    }

    @SuppressLint("HandlerLeak")
    private Handler searchHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case HANDLER_MSG_ADD:
                    BaseDeviceInfo info = (BaseDeviceInfo) msg.obj;
                    String wifiName = getWiFiSid();
                    if (wifiName == null)
                        return;
                    if (info.getSnNum() != null && info.getSnNum().equals(mInfo.getSnNum())) {
                        mIsFindNvr = true;
                        mSid = wifiName;
                        return;
                    }
                    NvrDeviceStatusInfo cameraInfo = getNvtCamera(info);
                    if (cameraInfo != null) {
                        if (mSid == null) {
                            if (wifiName != null)
                                if (mSearchHasmap.get(wifiName) != null) {
                                    if (!mSearchHasmap.get(wifiName).contains(cameraInfo)) {
                                        mSearchHasmap.get(wifiName).add(cameraInfo);
                                    }
                                } else {
                                    ArrayList<NvrDeviceStatusInfo> searchs = new ArrayList<>();
                                    searchs.add(cameraInfo);
                                    mSearchHasmap.put(wifiName, searchs);
                                }
                        } else {
                            if (mSid.equals(getWiFiSid())) {
                                if (mSearchHasmap.get(wifiName) != null) {
                                    if (!mSearchHasmap.get(wifiName).contains(cameraInfo)) {
                                        mSearchHasmap.get(wifiName).add(cameraInfo);
                                        findViewById(R.id.loading).setVisibility(View.GONE);
                                        mPullToRefreshListView.setVisibility(View.VISIBLE);
                                        mAdapter.setNewData(mSearchHasmap.get(wifiName));
                                        mAdapter.notifyDataSetChanged();
                                    }
                                } else {
                                    ArrayList<NvrDeviceStatusInfo> searchs = new ArrayList<>();
                                    searchs.add(cameraInfo);
                                    mSearchHasmap.put(wifiName, searchs);
                                    findViewById(R.id.loading).setVisibility(View.GONE);
                                    mPullToRefreshListView.setVisibility(View.VISIBLE);
                                    mAdapter.setNewData(mSearchHasmap.get(wifiName));
                                    mAdapter.notifyDataSetChanged();
                                }
                            }
                        }
                    }
                    break;
                case HANDLER_MSG_FINISH:
                    setSearchView(false);
                    mIsSearching = false;
                    mMangerCameraScan.stopDevieceSearch();
                    if (mSid == null || mSearchHasmap.get(mSid) == null || mSearchHasmap.get(mSid).size() == 0) {
                        findViewById(R.id.loading).setVisibility(View.VISIBLE);
                        mPullToRefreshListView.setVisibility(View.GONE);
                    }

                    break;
            }
        }
    };

    private NvrDeviceStatusInfo getNvtCamera(BaseDeviceInfo searinfo) {
        if (mInfos == null)
            return null;
        else
            for (NvrDeviceStatusInfo info : mInfos) {
                if (searinfo.getSnNum().equals(info.getSnNum()))
                    return info;
            }
        return null;
    }

    private void setSearchView(boolean bSearch) {
        if (bSearch) {
            this.action_bar_rl.setVisibility(View.GONE);
            this.mProgressBar.setVisibility(View.VISIBLE);
        } else {
            this.action_bar_rl.setVisibility(View.VISIBLE);
            this.mProgressBar.setVisibility(View.GONE);
        }
    }

    @Override
    public void changeWifi(WifiInfo wifiInfo) {
        if (mIsSearching && mMangerCameraScan != null) {
            mMangerCameraScan.stopSearch();
        }
        Message msg = new Message();
        msg.what = HANDLER_MSG_FINISH;
        searchHandler.sendMessage(msg);
        this.mIsSearching = false;
    }

    @Override
    public void disConnected() {

    }

    @Override
    public void connectTraffic() {

    }

    @OnClick(R.id.btn_connect)
    public void onFinishClick() {
        mIsGoRemove = true;
        finish();
    }

    @OnClick(R.id.right_text)
    public void onRefreshClick() {
        if (!this.mIsSearching) {
            if (mMangerCameraScan != null) {
                mMangerCameraScan.startSearchDevice(false, -1,100, ActivityType.ACTIVITY_ADD_NVR_CAMERA, Preference.getPreference().getToken());
                setSearchView(true);
                mRightBtn.setVisibility(View.GONE);
                mProgressBar.setProgress(0);
                mProgressBar.setVisibility(View.VISIBLE);
            }
        }
    }
}

