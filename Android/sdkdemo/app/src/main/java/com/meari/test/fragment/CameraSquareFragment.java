package com.meari.test.fragment;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.RequiresApi;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.imagepipeline.core.ImagePipeline;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.MeariDevice;
import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.ICheckDeviceOnlineCallback;
import com.meari.sdk.callback.IDevListCallback;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.AddDeviceActivity;
import com.meari.test.NVRSettingActivity;
import com.meari.test.PreviewActivity;
import com.meari.test.R;
import com.meari.test.SingleVideoActivity;
import com.meari.test.adapter.CameraSquareAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Constant;
import com.meari.test.common.StringConstants;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.service.DeviceStatusReceiver;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.NetUtil;
import com.ppstrong.ppsplayer.BaseDeviceInfo;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import java.util.ArrayList;
import java.util.List;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/27
 * 描    述：首页摄像机列表
 * 修订历史：
 * ================================================
 */

public class CameraSquareFragment extends BaseRecyclerFragment<BaseDeviceInfo>
        implements CameraSquareAdapter.CameraSquareCallback,
        CameraPlayerListener, DeviceStatusReceiver.DeviceStatusCallback {
    private final int MESSAGE_CHECK_ONLINE = 100;
    private PullToRefreshRecyclerView mPullToRefreshRecyclerView;
    public CameraSquareAdapter mAdapter;
    public View mFragmentView;
    public UserInfo mUserInfo;
    private ImageView mRightBtn;
    private LocalBroadcastManager mBroadcastManager;
    private ArrayList<BaseDeviceInfo> mDeviceList;

    public static CameraSquareFragment newInstance(UserInfo userInfo) {
        CameraSquareFragment fragment = new CameraSquareFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelable("userInfo", userInfo);
        fragment.setArguments(bundle);
        return fragment;
    }

    @SuppressLint("InflateParams")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        mFragmentView = inflater.inflate(R.layout.fragment_common_list, null);
        this.mUserInfo = (UserInfo) getArguments().getSerializable("userInfo");
        getActivity().findViewById(R.id.top_view).setVisibility(View.VISIBLE);
        mAdapter = new CameraSquareAdapter(this);
        initView(mFragmentView);
        registerDeviceStatusReceiver();
        return mFragmentView;
    }


    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        bindLoading();
        onRefresh();
    }

    public void initView(View paramView) {
        getActivity().findViewById(R.id.right_text).setVisibility(View.GONE);
        this.mRightBtn = getActivity().findViewById(R.id.submitRegisterBtn);
        this.mRightBtn.setImageResource(R.mipmap.ic_add);
        this.mRightBtn.clearAnimation();
        this.mRightBtn.setVisibility(View.VISIBLE);
        this.mRightBtn.setOnClickListener(this);
        int pad = DisplayUtil.dip2px(getContext(), 10);
        this.mRightBtn.setPadding(pad, pad, pad, pad);
        mPullToRefreshRecyclerView = paramView.findViewById(R.id.listview_layout);
        mPullToRefreshRecyclerView.setLastUpdatedLabel(CommonDateUtils.getRefreshDate());
        mPullToRefreshRecyclerView.setPullToRefreshOverScrollEnabled(false);
        mPullToRefreshRecyclerView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener2<RecyclerView>() {
            @Override
            public void onPullDownToRefresh(PullToRefreshBase<RecyclerView> refreshView) {
                onRefresh();
            }

            @Override
            public void onPullUpToRefresh(PullToRefreshBase<RecyclerView> refreshView) {

            }
        });
        mDeviceList = new ArrayList<>();
        bindLoading();
    }

    public void showAddPop(View v) {
        Intent intent = new Intent();
        intent.setClass(getActivity(), AddDeviceActivity.class);
        startActivityForResult(intent, ActivityType.ACTIVITY_NVR_ADDMEDTHOD);
    }


    @Override
    public void onRefresh() {
        super.onRefresh();
        requestDeviceData();
    }

    @Override
    public void onEmptyClick(boolean addDev) {
        if (addDev) {
            Intent intent = new Intent();
            intent.setClass(getActivity(), AddDeviceActivity.class);
            startActivityForResult(intent, ActivityType.ACTIVITY_NVR_ADDMEDTHOD);
        } else {
            bindLoading();
            onRefresh();
        }
    }

    @Override
    public void onNextPage() {
        super.onNextPage();
        requestDeviceData();
    }

    /**
     * 获取网络数据
     */
    public void requestDeviceData() {
        // 检查网络是否可用
        if (!NetUtil.checkNet(getActivity())) {
            bindError(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().getDeviceList(new IDevListCallback() {
            @Override
            public void onSuccess(MeariDevice dev) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                bindOrderList(dev);
            }

            @Override
            public void onError(int code, String error) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                bindError(error);
                CommonUtils.showToast(error);
            }
        });
    }

    @Override
    protected RecyclerView getListView() {
        RecyclerView listView = mPullToRefreshRecyclerView.getRefreshableView();
        listView.setLayoutManager(new LinearLayoutManager(getActivity()));
        return listView;
    }

    @Override
    protected BaseQuickAdapter getListAdapter() {
        return mAdapter;
    }

    @SuppressWarnings("deprecation")
    @Override
    protected Drawable getEmptyDrawable() {
        return getResources().getDrawable(R.mipmap.ic_error);
    }

    @Override
    protected String getEmptyText() {
        return getString(R.string.no_camera);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.submitRegisterBtn:
                showAddPop(v);
                break;
            default:
                break;
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mPullToRefreshRecyclerView = null;
        mListHelper = null;
        unRegisterDeviceReceiver();
    }

    @Override
    protected void setRefreshHint() {
        super.setRefreshHint();
        if (mPullToRefreshRecyclerView != null) {
            setRefreshHint(mPullToRefreshRecyclerView);
            setLoadHints(mPullToRefreshRecyclerView);
        }
    }

    public void unRegisterDeviceReceiver() {
        if (this.mBroadcastManager != null) {
            this.mBroadcastManager.unregisterReceiver(mReceive);
            this.mBroadcastManager.unregisterReceiver(mRefreshReceive);
        }
    }

    @SuppressLint("HandlerLeak")
    private Handler mCheckHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_CHECK_ONLINE:
                    mAdapter.notifyDataSetChanged();
                    break;
                default:
                    break;
            }
        }
    };

    private void bindOrderList(MeariDevice meariDevice) {
        List<CameraInfo> cameraInfos = meariDevice.getIpcs();
        List<CameraInfo> nvrInfos = meariDevice.getNvrs();
        List<CameraInfo> bellInfos = meariDevice.getDoorBells();
        cameraInfos = dealData(cameraInfos);
        mDeviceList.clear();
        mDeviceList.addAll(cameraInfos);
        //from puLan :add doorBell
        mDeviceList.addAll(bellInfos);
        mDeviceList.addAll(nvrInfos);
        resetList(mDeviceList);
        mAdapter.notifyDataSetChanged();
        mAdapter.setNvrNum(nvrInfos.size());
        if (mDeviceList != null && mDeviceList.size() > 0) {
            checkAllDeviceOnline();
        } else if (mDeviceList.size() == 0) {
            bindAddEmpty();
        }

    }

    private ArrayList<CameraInfo> getMyCameras(ArrayList<CameraInfo> cameraInfos) {
        ArrayList<CameraInfo> infos = new ArrayList<>();
        for (CameraInfo info : cameraInfos) {
            if (!info.isAsFriend()) {
                infos.add(info);
            }
        }
        return infos;
    }

    private void checkAllDeviceOnline() {
        for (BaseDeviceInfo cameraInfo : mDeviceList) {
            if (cameraInfo.getProtocolVersion() < 2 && cameraInfo instanceof CameraInfo) {
                CameraPlayer player = new CameraPlayer();
//                player.checkDevOnlineStatus(cameraInfo.getDeviceUUID(), this);
            }
        }
    }


    @Override
    public void PPSuccessHandler(String successMsg) {
        if (getActivity() == null || getActivity().isFinishing()) {
            return;
        }
        try {
            BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
            String uuid = jsonObject.optString("uid", "");
            String statusString = jsonObject.optString("msg", "offline");
            int status = statusString.equals("offline") ? -1 : 1;
            if (!uuid.isEmpty()) {
                mAdapter.changeStatusByUuid(uuid, status);
                mCheckHandler.sendEmptyMessage(MESSAGE_CHECK_ONLINE);
                mDeviceList.clear();
                mDeviceList.addAll(mAdapter.getData());
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void PPFailureError(String errorMsg) {
        if (getActivity() == null || getActivity().isFinishing() || getActivity().isDestroyed())
            return;
        try {
            BaseJSONObject jsonObject = new BaseJSONObject(errorMsg);
            String uuid = jsonObject.optString("uid", "");
            String statusString = jsonObject.optString("msg", "offline");
            int status = statusString.equals("offline") ? -1 : -27;
            if (!uuid.isEmpty()) {
                mAdapter.changeStatusByUuid(uuid, status);
                mCheckHandler.sendEmptyMessage(MESSAGE_CHECK_ONLINE);
                mDeviceList.clear();
                mDeviceList.addAll(mAdapter.getData());
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    @Override
    public void setDeviceStatus(String deviceId, boolean onLine) {
        mAdapter.changeDeviceStatus(deviceId, onLine);

    }

    private List<CameraInfo> dealData(List<CameraInfo> deviceInfoLists) {
        if (mDeviceList == null && deviceInfoLists == null)
            return deviceInfoLists;
        for (CameraInfo info : deviceInfoLists) {
            for (int i = 0; i < mDeviceList.size(); i++) {
                if (info.getDeviceUUID().equals(mDeviceList.get(i).getDeviceUUID()) && info.getProtocolVersion() < 2) {
                    info.setState(mDeviceList.get(i).isState());
                }
            }
        }
        return deviceInfoLists;
    }


    @Override
    public void onStop() {
        super.onStop();
    }


    /**
     * 开启单路视频预览
     *
     * @param cameraInfo
     */
    public void startSingleVideo(CameraInfo cameraInfo, View param) {
//        Intent intent = new Intent(getActivity(), SingleVideoActivity.class);
        Intent intent = new Intent(getActivity(), PreviewActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", cameraInfo);
        bundle.putInt("type", 0);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_SIGPLAY);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case ActivityType.ACTIVITY_SIGPLAY:
                if (data != null) {
                    final Bundle bundle = data.getExtras();
                    if (bundle != null) {
                        boolean isShot = bundle.getBoolean(StringConstants.SCREEN_SHOT, false);
                        if (isShot) {
                            new Handler().postDelayed(new Runnable() {
                                @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
                                @Override
                                public void run() {
                                    if (getActivity() == null || getActivity().isFinishing() || getActivity().isDestroyed())
                                        return;
                                    CameraInfo cameraInfo = (CameraInfo) bundle.getSerializable("cameraInfo");
                                    ImagePipeline imagePipeline = Fresco.getImagePipeline();
                                    String snPathString = Constant.DOCUMENT_CACHE_PATH + cameraInfo.getSnNum() + ".jpg";
                                    imagePipeline.evictFromMemoryCache(Uri.parse(snPathString));
                                    onRefresh();
                                }
                            }, 1000);
                        }
                    }
                }

                break;
            case ActivityType.ACTIVITY_CAMERSSETINT:
                if (data == null) {
                    onRefresh();
                    break;
                }
                Bundle bundle = data.getExtras();
                if (bundle != null) {
                    int type = bundle.getInt("type", 0);
                    if (type == 1)
                        mAdapter.setNewData(mDeviceList);
                }
                onRefresh();
            default:
                onRefresh();
                break;
        }
    }

    public void goSettingActivity(BaseDeviceInfo deviceInfo) {
        Intent intent;
        Bundle bundle = new Bundle();
        if (deviceInfo.getDevTypeID() == 1) {
            NVRInfo info = (NVRInfo) deviceInfo;
            intent = new Intent(getActivity(), NVRSettingActivity.class);
            bundle.putSerializable("NVRInfo", info);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_CAMERSSETINT);
        }
    }

    @Override
    public void goActivityForResult(Intent intent, int activitySigplay) {
        startActivityForResult(intent, activitySigplay);
    }

    public void startCheckStatus(final BaseDeviceInfo info) {
        MeariUser.getInstance().checkDeviceOnline(info.getDeviceID(), new ICheckDeviceOnlineCallback() {
            @Override
            public void onSuccess(String deviceId, boolean online) {
                if (isDetached())
                    return;
                mAdapter.changeDeviceStatus(deviceId, online);
            }

            @Override
            public void onError(int code, String error) {
                if (isDetached())
                    return;
                mAdapter.changeStatusByUuid(info.getDeviceID(), -27);
            }
        });

    }

    public void registerDeviceStatusReceiver() {
        this.mBroadcastManager = LocalBroadcastManager.getInstance(getActivity());
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction(StringConstants.DEVICE_ON_OFF_LINE);
        this.mBroadcastManager.registerReceiver(mReceive, exitFilter);
        IntentFilter refresh = new IntentFilter();
        refresh.addAction(StringConstants.DEVICE_REFRESH_STATUS);
        this.mBroadcastManager.registerReceiver(mRefreshReceive, refresh);

    }

    private BroadcastReceiver mRefreshReceive = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            onRefresh();
        }
    };
    private DeviceStatusReceiver mReceive = new DeviceStatusReceiver(this);

}


