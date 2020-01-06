package com.meari.test.fragment;

import android.annotation.SuppressLint;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.bean.ShareFriendInfo;
import com.meari.sdk.callback.IQueryFriendListForDeviceCallback;
import com.meari.sdk.callback.IShareForDevCallback;
import com.meari.sdk.common.DeviceType;
import com.meari.test.R;
import com.meari.test.adapter.ShareNvrFriendAdapter;
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
 * 创建日期：2017/5/17
 * 描    述：分享NVR的frgment
 * 修订历史：
 * ================================================
 */

public class ShareNvrFragment extends BaseRecyclerFragment<ShareFriendInfo>
        implements View.OnClickListener {
    private PullToRefreshRecyclerView mPullToRefreshRecyclerView;
    protected int mOffset = 0;
    protected int mIndexPage = 1;
    public ShareNvrFriendAdapter mAdapter;
    public View mFragmentView;
    public NVRInfo mInfo;

    public static ShareNvrFragment newInstance(NVRInfo info) {
        ShareNvrFragment fragment = new ShareNvrFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("NVRInfo", info);
        fragment.setArguments(bundle);
        return fragment;
    }

    @SuppressLint("InflateParams")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        super.onCreateView(inflater, paramViewGroup, paramBundle);
        mFragmentView = inflater.inflate(R.layout.fragment_friend_detail, null);
        this.mInfo = (NVRInfo) getArguments().getSerializable("NVRInfo");
        mAdapter = new ShareNvrFriendAdapter(getActivity(), this);
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

        TextView view = (TextView) mFragmentView.findViewById(R.id.add_text);
        view.setText(getString(R.string.share_nvr_desc));
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
        if (!NetUtil.isNetworkAvailable()) {
            bindError(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().queryFriendListForDevice(DeviceType.NVR, mInfo.getDeviceID(),this , new IQueryFriendListForDeviceCallback() {
            @Override
            public void onSuccess(ArrayList<ShareFriendInfo> shareFriendInfos) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                bindOrderList(shareFriendInfos);
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
        getDataSource().clear();
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
            MeariUser.getInstance().addShareUserForDev(DeviceType.NVR, friendDetailDTO.getUserId(), mInfo.getDeviceID(), mInfo.getDeviceUUID(),this , new IShareForDevCallback() {
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
                    CommonUtils.showToast(R.string.fail);
                }
            });
        } else {
            startProgressDialog(getString(R.string.share_device_cancel));
            MeariUser.getInstance().removeShareUserForDev(DeviceType.NVR, friendDetailDTO.getUserId(), mInfo.getDeviceID(), mInfo.getDeviceUUID(),this , new IShareForDevCallback() {
                @Override
                public void onSuccess(String userId, String devId) {
                    stopProgressDialog();
                    mAdapter.changeDateByUserId(userId, false);
                    mAdapter.notifyDataSetChanged();
                    CommonUtils.showToast(R.string.share_success);
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(R.string.fail);
                }
            });
        }
    }
}
