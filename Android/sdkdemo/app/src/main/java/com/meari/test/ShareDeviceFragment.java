package com.meari.test;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.ShareFriendInfo;
import com.meari.sdk.callback.IQueryFriendListForDeviceCallback;
import com.meari.sdk.callback.IShareForDevCallback;
import com.meari.sdk.common.DeviceType;
import com.meari.test.adapter.ShareDeviceFriendAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.fragment.BaseRecyclerFragment;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ShareDeviceFragment extends BaseRecyclerFragment<ShareFriendInfo> implements View.OnClickListener {
    private PullToRefreshRecyclerView mPullToRefreshRecyclerView;
    protected int mOffset = 0;
    protected int mIndexPage = 1;
    public ShareDeviceFriendAdapter mAdapter;
    public View mFragmentView;
    public CameraInfo mInfo;

    public static ShareDeviceFragment newInstance(CameraInfo info) {
        ShareDeviceFragment fragment = new ShareDeviceFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", info);
        fragment.setArguments(bundle);
        return fragment;
    }

    @SuppressLint("InflateParams")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        super.onCreateView(inflater, paramViewGroup, paramBundle);
        mFragmentView = inflater.inflate(R.layout.fragment_friend_detail, null);
        this.mInfo = (CameraInfo) getArguments().getSerializable("cameraInfo");
        mAdapter = new ShareDeviceFriendAdapter(getActivity(), this);
        initView(mFragmentView);
        return mFragmentView;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        netWorkRequest();
        bindLoading();
    }

    public void initView(View v) {
        mPullToRefreshRecyclerView = v.findViewById(R.id.friendDetailListView);
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
        bindLoading();
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onRefresh() {
        super.onRefresh();
        mOffset = 0;
        mIndexPage = 1;
        netWorkRequest();
    }

    @Override
    public void onEmptyClick(boolean addDev) {
        bindLoading();
        onRefresh();
    }

    @Override
    public void onNextPage() {
    }

    /**
     * 获取网络数据
     */
    public void netWorkRequest() {
        // 检查网络是否可用
        if (!NetUtil.checkNet(getActivity())) {
            bindError(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().queryFriendListForDevice(DeviceType.IPC, mInfo.getDeviceID(), this ,new IQueryFriendListForDeviceCallback() {
            @Override
            public void onSuccess(ArrayList<ShareFriendInfo> result) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                bindOrderList(result);
            }

            @Override
            public void onError(int code, String error) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                showToast(error);
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
        return getString(R.string.no_friends);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
//            case R.id.error_textview:
//                onRefresh();
//                break;
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mPullToRefreshRecyclerView = null;
        mListHelper = null;
    }

    @Override
    protected void setRefreshHint() {
        super.setRefreshHint();
        if (mPullToRefreshRecyclerView != null) {
            setRefreshHint(mPullToRefreshRecyclerView);
            setLoadHints(mPullToRefreshRecyclerView);
        }
    }

    private void bindOrderList(ArrayList<ShareFriendInfo> list) {
        if (list == null) {
            return;
        }
        this.getDataSource().clear();
        if (list != null && list.size() > 0) {
            mAdapter.getData().clear();
            mAdapter.getData().addAll(list);
        } else {
            bindEmpty();
            return;
        }
        mAdapter.notifyDataSetChanged();
    }


    public void shareDeviceToFriends(ShareFriendInfo friendDetailDTO) {
        if (!friendDetailDTO.isShare()) {
            startProgressDialog(getString(R.string.share_device));
            MeariUser.getInstance().addShareUserForDev(DeviceType.IPC, friendDetailDTO.getUserId(), mInfo.getDeviceUUID(), mInfo.getDeviceID(),this , new IShareForDevCallback() {
                @Override
                public void onSuccess(String userId, String devId) {
                    stopProgressDialog();
                    mAdapter.changeDateByUserId(userId, true);
                    mAdapter.notifyDataSetChanged();
                    CommonUtils.showToast(R.string.share_success);
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    showToast(error);
                }
            });
        } else {
            startProgressDialog(getString(R.string.share_device_cancel));
            MeariUser.getInstance().removeShareUserForDev(DeviceType.IPC, friendDetailDTO.getUserId(), mInfo.getDeviceUUID(), mInfo.getDeviceID(), this ,new IShareForDevCallback() {
                @Override
                public void onSuccess(String userId, String devId) {
                    stopProgressDialog();
                    mAdapter.changeDateByUserId(userId, false);
                    mAdapter.notifyDataSetChanged();
                    CommonUtils.showToast(R.string.cancel_share_success);
                }


                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    showToast(error);
                }
            });

        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case ActivityType.ACTIVITY_FRIEND:
                onRefresh();
                break;
            default:
                break;
        }
    }


}

