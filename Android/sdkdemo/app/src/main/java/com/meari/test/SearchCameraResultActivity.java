package com.meari.test;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.interfaces.DraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.callback.IAddDeviceCallback;
import com.meari.sdk.callback.IDeviceStatusCallback;
import com.meari.sdk.callback.IRequestDeviceShareCallback;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.sdk.listener.CameraSearchListener;
import com.meari.sdk.utils.MangerCameraScanUtils;
import com.meari.test.adapter.ScanningResultAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Preference;
import com.meari.test.common.StringConstants;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.animation.FadeInDownAnimator;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.RoundProgressBar;
import com.ppstrong.ppsplayer.BaseDeviceInfo;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;


/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/2
 * 描    述：IPC搜索添加
 * 修订历史：
 * ================================================
 */

public class SearchCameraResultActivity extends BaseActivity implements CameraSearchListener {
    private ScanningResultAdapter scanningResultAdapter;
    private ArrayList<CameraInfo> mCameraInfoList;
    private MangerCameraScanUtils mMangerCameraScan;
    private final int HANDLER_MSG_ADD = 100;                    // 添加设备
    private final int HANDLER_MSG_FINISH = 101;                    // 搜索完成
    private boolean mBSearch;
    private HashMap<String, BaseDeviceInfo> mHasMap;
    private View mBottomView;
    private boolean mIsMonitor;
    private int mDeviceTypeID;
    @BindView(R.id.search_progress)
    public RoundProgressBar mProgressBar;
    @BindView(R.id.listview_layout)
    public PullToRefreshRecyclerView mPullToRefreshListView;
    private ArrayList<CameraInfo> mQrCameras;//传入的Cameras
    String device = "{\n" +
            "                                                               \t\"model\":\t\"Bell 1C\",\n" +
            "                                                               \t\"tp\":\t\"627060101\",\n" +
            "                                                               \t\"ip\":\t\"192.168.31.81\",\n" +
            "                                                               \t\"mask\":\t\"255.255.255.0\",\n" +
            "                                                               \t\"gw\":\t\"192.168.31.1\",\n" +
            "                                                               \t\"mac\":\t\"d0:6f:4a:5e:cc:1d\",\n" +
            "                                                               \t\"interface\":\t\"wlan0\",\n" +
            "                                                               \t\"version\":\t\"2.2.0\",\n" +
            "                                                               \t\"platform\":\t\"b2-coolkit\",\n" +
            "                                                               \t\"server_type\":\t\"https://apis-cn-hangzhou.meari.com.cn\",\n" +
            "                                                               \t\"p2p_type\":\t9,\n" +
            "                                                               \t\"licence_type\":\t0,\n" +
            "                                                               \t\"deviceName\":\t\"056703977\",\n" +
            "                                                               \t\"serialno\":\t\"056703977\",\n" +
            "                                                               \t\"sn\":\t\"pps1753ed1075dce438e\",\n" +
            "                                                               \t\"licenseUsed\":\t1,\n" +
            "                                                               \t\"licenseId\":\t\"pps1753ed1075dce438e\",\n" +
            "                                                               \t\"p2p_uuid\":\t\"v2-0567039770000111A\",\n" +
            "                                                               \t\"capability\":\t\"{\\n\\t\\\"ver\\\":\\t1,\\n\\t\\\"cat\\\":\\t\\\"bell\\\",\\n\\t\\\"caps\\\":\\t{\\n\\t\\t\\\"vtk\\\":\\t4,\\n\\t\\t\\\"fcr\\\":\\t0,\\n\\t\\t\\\"dcb\\\":\\t0,\\n\\t\\t\\\"md\\\":\\t0,\\n\\t\\t\\\"ptz\\\":\\t0,\\n\\t\\t\\\"tmpr\\\":\\t0,\\n\\t\\t\\\"hmd\\\":\\t0,\\n\\t\\t\\\"pir\\\":\\t1,\\n\\t\\t\\\"nst\\\":\\t1,\\n\\t\\t\\\"cst\\\":\\t0,\\n\\t\\t\\\"vst\\\":\\t0,\\n\\t\\t\\\"btl\\\":\\t1\\n\\t}\\n}\"\n" +
            "                                                               }";
    public SearchCameraResultActivity() {
        mHasMap = new HashMap<>();
        mQrCameras = new ArrayList<>();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scanning_camera);
        initData();
        initView();
        setSearchView(true);
    }

    private void initData() {
        this.mCameraInfoList = new ArrayList<>();
        Bundle bundle = getIntent().getExtras();
        /**
         * 获取多列表选择界面传值过来的CameraInfo列表
         */
        if (bundle != null) {
            String mSid = bundle.getString(StringConstants.WIFI_NAME, "");
            String mPwd = bundle.getString(StringConstants.WIFI_PWD, "");
            mIsMonitor = bundle.getBoolean(StringConstants.SMART_CONFIG, false);
            this.mDeviceTypeID = bundle.getInt(StringConstants.DEVICE_TYPE_ID, 2);
            this.mQrCameras = (ArrayList<CameraInfo>) bundle.getSerializable(StringConstants.CAMERA_INFOS);
            mMangerCameraScan = new MangerCameraScanUtils(mSid, mPwd, 0,this, false);
            mMangerCameraScan.startSearchDevice(mIsMonitor, -1, ActivityType.ACTIVITY_SEARCHCANERARESLUT);
        } else {
            finish();
        }
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
        getTopTitleView();
        this.mCenter.setText(R.string.choice_camera);
        mProgressBar.setProgress(0);
        mProgressBar.setVisibility(View.VISIBLE);
        this.mRightText.setText(R.string.redo);
        scanningResultAdapter = new ScanningResultAdapter(this, this);
        addHeadView();
        mPullToRefreshListView.setPullToRefreshOverScrollEnabled(false);
        mPullToRefreshListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
        mPullToRefreshListView.setLastUpdatedLabel(CommonDateUtils.getRefreshDate());
        mPullToRefreshListView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener2<RecyclerView>() {
            @Override
            public void onPullDownToRefresh(PullToRefreshBase<RecyclerView> refreshView) {
                onRefresh();
            }

            @Override
            public void onPullUpToRefresh(PullToRefreshBase<RecyclerView> refreshView) {
            }
        });
        mPullToRefreshListView.getRefreshableView().setLayoutManager(new LinearLayoutManager(this));
        mPullToRefreshListView.setShowDividers(LinearLayout.SHOW_DIVIDER_NONE);
        mPullToRefreshListView.getRefreshableView().setItemAnimator(new FadeInDownAnimator());
        mPullToRefreshListView.getRefreshableView().getItemAnimator().setAddDuration(500);
        mPullToRefreshListView.getRefreshableView().getItemAnimator().setRemoveDuration(500);
        mBottomView = LayoutInflater.from(this).inflate(R.layout.layout_add_bottom, null);
        SimpleDraweeView simpleDraweeView = mBottomView.findViewById(R.id.bg_loading);
        DraweeController controller = Fresco.newDraweeControllerBuilder()
                .setAutoPlayAnimations(true)
                .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.ic_loading))//设置uri
                .build();
        simpleDraweeView.setController(controller);
        scanningResultAdapter.addFooterView(mBottomView);

        mPullToRefreshListView.getRefreshableView().setAdapter(scanningResultAdapter);
        if (mQrCameras != null && mQrCameras.size() > 0) {
            mCameraInfoList.addAll(mQrCameras);
            scanningResultAdapter.setNewData(mCameraInfoList);
        }
        TextView textView = findViewById(R.id.ap_desc);
        if (mDeviceTypeID == 4) {
            textView.setText(getString(R.string.add_help));
            textView.setTextColor(getResources().getColor(R.color.com_blue));
        } else {
            textView.setText(getString(R.string.ap_desc));
        }
        BaseJSONObject baseJSONObject = null;
//        try {
//            baseJSONObject = new BaseJSONObject(device);
//            CameraInfo info = getBaseDeviceInfo(baseJSONObject);
//            onCameraSearchDetected(info);
//        } catch (JSONException e) {
//            e.printStackTrace();
//        }
    }
    public CameraInfo getBaseDeviceInfo(JSONObject jsonObject) {
        CameraInfo info = new CameraInfo();
        String licenseId = jsonObject.optString("licenseId", "");
        if (!licenseId.isEmpty()) {
            info.setLicenseId(licenseId);
            info.setVersion(jsonObject.optString("version", ""));
//            info.setSn(jsonObject.optString("serialno", ""));
            info.setDeviceUUID(jsonObject.optString("p2p_uuid", ""));
            info.setTp(jsonObject.optString("tp", "0"));
            info.setDeviceName(jsonObject.optString("serialno", ""));
            info.setCapability(jsonObject.optString("capability", ""));
            info.setSnNum(licenseId);
        } else {
            info.setLicenseId("");
            info.setVersion(jsonObject.optString("version", ""));
            info.setSnNum(jsonObject.optString("sn", ""));
            info.setDeviceUUID(jsonObject.optString("p2p_uuid", ""));
            info.setTp(jsonObject.optString("tp", "0"));
            info.setDeviceName(jsonObject.optString("sn", ""));
        }
        info.setProduceAuth(jsonObject.optString("produceAuth", ""));
        info.setMac(jsonObject.optString("mac", ""));
        return info;
    }
    public void addHeadView() {
        ImageView imageView = new ImageView(this);
        scanningResultAdapter.addHeaderView(imageView);
        imageView.setVisibility(View.GONE);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_APSETTING:
                if (requestCode == RESULT_OK) {
                    finish();
                }
                break;
            case ActivityType.ACTIVITY_QR_CODE:
                if (resultCode == RESULT_OK) {
                    if (mDeviceTypeID != 4) {
                        TextView textView = findViewById(R.id.ap_desc);
                        textView.setText(getString(R.string.qr_add_warning));
                    }
                    onRefreshClick();
                    if (data != null) {
                        Bundle bundle = data.getExtras();
                        if (bundle == null)
                            return;
                        ArrayList<CameraInfo> infos = (ArrayList<CameraInfo>) bundle.getSerializable(StringConstants.CAMERA_INFOS);
                        if (infos == null || infos.size() == 0)
                            return;
                        for (int i = infos.size(); i > 0; i--) {
                            CameraInfo info = infos.get(i - 1);
                            if (!IsExists(info)) {
                                this.mCameraInfoList.add(info);
                                scanningResultAdapter.addCameraData(0, info);
                            }
                        }
                    }
                }
                break;
        }
    }

    private boolean IsExists(CameraInfo cameraInfo) {
        for (int i = 0; i < this.mCameraInfoList.size(); i++) {
            if (cameraInfo.getDeviceUUID().equals(this.mCameraInfoList.get(i).getDeviceUUID())) {
                this.mCameraInfoList.get(i).setAddStatus(cameraInfo.getAddStatus());
                return true;
            }
        }
        return false;
    }

    @Override
    public void onBackClick(View view) {
        Bundle bundle = new Bundle();
        Intent intent = new Intent();
        bundle.putInt("back_home", 2);
        intent.putExtras(bundle);
        setResult(RESULT_OK, intent);
        finish();
    }

    @OnClick(R.id.pps_back_home)
    public void goBackHome() {
        Bundle bundle = new Bundle();
        Intent intent = new Intent();
        bundle.putInt("back_home", 1);
        intent.putExtras(bundle);
        setResult(RESULT_OK, intent);
        finish();
    }


    public void checkDev() {
        if (!this.mBSearch) {
            if (mMangerCameraScan != null) {
                mMangerCameraScan.startSearchDevice(false, -1,100, ActivityType.ACTIVITY_SEARCHCANERARESLUT, Preference.getPreference().getToken());
                setSearchView(true);
                mRightBtn.setVisibility(View.GONE);
                mProgressBar.setProgress(0);
                mProgressBar.setVisibility(View.VISIBLE);
            }
        }
    }


    private void onRefresh() {
        checkDev();
        if (this.mCameraInfoList == null || this.mCameraInfoList.size() == 0) {
            mPullToRefreshListView.onRefreshComplete();
            return;
        }
        checkDeviceStatus(mCameraInfoList, mDeviceTypeID);

    }

    @OnClick(R.id.right_text)
    public void onRefreshClick() {
        mPullToRefreshListView.onRefreshComplete();
        if (!this.mBSearch) {
            if (mMangerCameraScan != null) {
                mMangerCameraScan.startSearchDevice(mIsMonitor, -1, ActivityType.ACTIVITY_SEARCHCANERARESLUT);
                setSearchView(true);
                mRightBtn.setVisibility(View.GONE);
                mProgressBar.setProgress(0);
                mProgressBar.setVisibility(View.VISIBLE);
            }
        }
    }

    public void dealDevice(CameraInfo info) {

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

    private void requestShareDevice(CameraInfo info) {
        startProgressDialog();
        MeariUser.getInstance().requestDeviceShare(info, new IRequestDeviceShareCallback() {

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }

            @Override
            public void onSuccess(String sn) {
                stopProgressDialog();
                CommonUtils.showToast(getString(R.string.waiting_deal_share));
                scanningResultAdapter.setStatusBySn(sn, 5);
                if (scanningResultAdapter.getDataCount() == 1 && !mBSearch) {
                    goBackHome();
                }
            }
        });
    }


    public void addDevice(CameraInfo info) {
        startProgressDialog();
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }

        MeariUser.getInstance().addDevice(info, this.mDeviceTypeID,  new IAddDeviceCallback() {
            @Override
            public void onSuccess(int code, String sn, String deviceID) {
                stopProgressDialog();
                CommonUtils.showToast(getString(R.string.add_suc));
                scanningResultAdapter.setStatus(sn, 1);
                if (scanningResultAdapter.getDataCount() == 1 && !mBSearch) {
                    goBackHome();
                }
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }
        });

    }

    @Override
    public void finish() {
        super.finish();
        mCameraInfoList.clear();
        mMangerCameraScan.finish();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
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
        mProgressBar.setProgress(100 - time );
        if (time == 0) {
            this.mProgressBar.setVisibility(View.GONE);
            this.mProgressBar.setProgress(0);
            this.mProgressBar.setContent(String.valueOf(90));
            this.action_bar_rl.setVisibility(View.VISIBLE);
        }
        this.mProgressBar.setContent(String.valueOf(time));
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
                    if (!NetUtil.checkNet(SearchCameraResultActivity.this)) {
                        CommonUtils.showToast(getString(R.string.network_unavailable));
                    }
                    CameraInfo infos = (CameraInfo) msg.obj;
                    List<CameraInfo> cameraInfos = new ArrayList<>();
                    cameraInfos.add(infos);
                    checkDeviceStatus(cameraInfos, mDeviceTypeID);
                    break;

                case HANDLER_MSG_FINISH:

                    setSearchView(false);
                    mMangerCameraScan.stopDevieceSearch();
            }
        }
    };

    private void checkDeviceStatus(List<CameraInfo> cameraInfos, int deviceTypeID) {
        Log.i("tag","add-checkDeviceStatus:"+cameraInfos.size());
        if (cameraInfos.size()>0) {
            Log.i("tag","add-checkDeviceStatus:"+cameraInfos.get(0).getDeviceName());
            Log.i("tag","add-checkDeviceStatus:"+cameraInfos.get(0).getDeviceID());
        }
        MeariUser.getInstance().checkDeviceStatus(cameraInfos, deviceTypeID,  new IDeviceStatusCallback() {
            @Override
            public void onSuccess(ArrayList<CameraInfo> deviceList) {
//                Log.i("tag","add-checkDeviceStatus:"+deviceList.get(0).getDeviceName());
//                Log.i("tag","add-checkDeviceStatus:"+deviceList.get(0).getDeviceID());
                mPullToRefreshListView.onRefreshComplete();
                for (int i = 0; i < deviceList.size(); i++) {
                    CameraInfo info = deviceList.get(i);
                    if (!IsExists(info)) {
                        mCameraInfoList.add(info);
                        scanningResultAdapter.addCameraData(0, info);
                    }
                }
                scanningResultAdapter.notifyDataSetChanged();
            }

            @Override
            public void onError(int code, String error) {
                CommonUtils.showToast(error);
            }
        });
    }

    // 时间次数
    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_BACK:
                onBackClick(null);
                break;
            default:
                return super.onKeyUp(keyCode, event);
        }

        return true;
    }

    @OnClick(R.id.ap_desc)
    public void onHelpClick() {
        if (mDeviceTypeID == 4) {
            Intent intent = new Intent(this, DeviceStatusHelpActivity.class);
            startActivity(intent);
        }
    }

}

