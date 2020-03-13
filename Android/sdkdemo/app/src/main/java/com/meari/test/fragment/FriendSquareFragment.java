package com.meari.test.fragment;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.MeariFriend;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.IGetFriendCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.test.R;
import com.meari.test.ShareFriendDeviceActivity;
import com.meari.test.adapter.FriendAdapter;
import com.meari.test.bean.FriendInfo;
import com.meari.test.common.ActivityType;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.LoginFormatUtils;
import com.meari.test.utils.NetUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class FriendSquareFragment extends BaseRecyclerFragment<FriendInfo> {

    protected int mOffset = 0;
    protected int pageNum = 0;
    protected boolean isPrepared = true;
    public FriendAdapter mAdapter;
    public View mFragmentView;
    public UserInfo mUserInfo;
    private Dialog mPop;
    private final int EDIT = 1;
    private final int UN_EDIT = 0;
    private ImageView mRightBtn;
    @BindView(R.id.deleteFriend)
    public View mFriendDelBtn;
    @BindView(R.id.friendListView)
    public PullToRefreshRecyclerView mPullToRefreshListView;

    public static FriendSquareFragment newInstance() {
        com.meari.test.fragment.FriendSquareFragment fragment = new com.meari.test.fragment.FriendSquareFragment();
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        super.onCreateView(inflater, paramViewGroup, paramBundle);
        mFragmentView = inflater.inflate(R.layout.fragment_friend, null);
        ButterKnife.bind(this, mFragmentView);
        this.mUserInfo = MeariUser.getInstance().getUserInfo();
        mAdapter = new FriendAdapter();
        mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<FriendInfo>() {
            @Override
            public void onItemClick(BaseQuickAdapter<FriendInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                FriendInfo info = adapter.getItem(position);
                onRecyclerItemClick(view, info);
            }
        });
        initView(mFragmentView);
        return mFragmentView;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        bindLoading();
        onRefresh();
    }

    public void initView(View v) {
        this.mRightBtn = getActivity().findViewById(R.id.submitRegisterBtn);
        this.mFriendDelBtn.setOnClickListener(this);
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        int margin = DisplayUtil.dpToPx(getContext(), 12);
        this.mRightBtn.setPadding(margin, margin, margin, margin);
        this.mRightBtn.setTag(UN_EDIT);
        this.mRightBtn.setOnClickListener(this);
        this.mRightBtn.setVisibility(View.GONE);
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

    }

    @OnClick(R.id.friend_add)
    public void onFriendAddClick() {
        EditText accountNum_Friend = (EditText) mFragmentView.findViewById(R.id.accountNum_Friend);
        CommonUtils.hideKeyBoard(getActivity());
        String accountNumFriendText = accountNum_Friend.getText().toString().trim();
        if (!accountNumFriendText.isEmpty()) {
            if (accountNumFriendText.indexOf("@") != -1) {
                if (!LoginFormatUtils.isEmail(accountNumFriendText)) {
                    CommonUtils.showToast(R.string.friend_wrong);
                    return;
                }
            } else {
                if (!LoginFormatUtils.isMobileNOs(accountNumFriendText)) {
                    CommonUtils.showToast(R.string.friend_wrong);
                    return;
                }
            }

        } else {
            accountNum_Friend.setFocusable(true);
            accountNum_Friend.requestFocus();
            CommonUtils.showToast(R.string.accountIsNull);
            return;
        }
        if (this.mUserInfo.getUserAccount().equals(accountNumFriendText)) {
            CommonUtils.showToast(R.string.add_no_yourself);
            return;
        }
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        startProgressDialog(getString(R.string.pps_waite));
        MeariUser.getInstance().addFriend(accountNumFriendText, new IResultCallback() {
            @Override
            public void onSuccess() {
                stopProgressDialog();
                CommonUtils.showToast(getString(R.string.waiting_deal_share));
            }


            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }
        });

    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onRefresh() {
        super.onRefresh();
        mOffset = 0;
        pageNum = 0;
        requestFriendData();
    }

    @Override
    public void onEmptyClick(boolean addDev) {
        bindLoading();
        onRefresh();
    }

    @Override
    public void onNextPage() {
        super.onNextPage();
        mOffset += 10;
        pageNum++;
        requestFriendData();
    }

    /**
     * 获取网络数据
     */
    public void requestFriendData() {
        // 检查网络是否可用
        if (!NetUtil.isNetworkAvailable()) {
            bindError(getString(R.string.network_unavailable));
            return;
        }
        if (getContext() == null || getActivity() == null || getActivity().isFinishing())
            return;
        MeariUser.getInstance().getFriendList(new IGetFriendCallback() {
            @Override
            public void onSuccess(List<MeariFriend> friends) {
                if (isDetached())
                    return;
                mPullToRefreshListView.onRefreshComplete();
                bindFriendList(friends);
            }

            @Override
            public void onError(int code, String error) {
                mPullToRefreshListView.onRefreshComplete();
                CommonUtils.showToast(error);
            }
        });
    }

    @Override
    protected RecyclerView getListView() {
        RecyclerView listView = mPullToRefreshListView.getRefreshableView();
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
        return getString(R.string.no_message);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.submitRegisterBtn:
                onEditClick();
                break;
            case R.id.deleteFriend:
                onFriendDeleteClick();
                break;
            default:
                break;
        }
    }


    private void onEditClick() {
        int tag = (int) mRightBtn.getTag();
        if (tag == UN_EDIT) {
            setDeleteStatus(EDIT);
            mAdapter.setEditStaus(true);
            mAdapter.changAddData(0);
            mRightBtn.setTag(1);
            mRightBtn.setImageResource(R.drawable.btn_cancel);
            mAdapter.notifyDataSetChanged();
        } else {
            mAdapter.setEditStaus(false);
            mRightBtn.setTag(0);
            mRightBtn.setImageResource(R.drawable.btn_delete);
            onResumeDelStatus();
        }


    }

    public void onResumeDelStatus() {
        this.setDeleteStatus(0);
        mAdapter.changAddData(0);
        this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
        if (mAdapter != null && mAdapter.getDataCount() > 0)
            this.mRightBtn.setVisibility(View.VISIBLE);
        else
            this.mRightBtn.setVisibility(View.GONE);
        mAdapter.notifyDataSetChanged();
    }


    public void clearDataRequest() {
        String friendMoreDel = mAdapter.getSelectAllMeariFriends();
        if (friendMoreDel != null && friendMoreDel.length() > 0) {
            MeariUser.getInstance().deleteFriend(friendMoreDel,new IResultCallback() {
                @Override
                public void onSuccess() {
                    stopProgressDialog();
                    mAdapter.cleaDelData();
                    if (mAdapter.getData() == null || mAdapter.getData().size() <= 0) {
                        onResumeDelStatus();
                        bindEmpty(getString(R.string.no_friends));
                        mRightBtn.setVisibility(View.GONE);
                        if (mFriendDelBtn.getVisibility() != View.GONE) {
                            mFriendDelBtn.setVisibility(View.GONE);
                        }
                    }
                    mAdapter.notifyDataSetChanged();
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(error);
                }
            });
        }
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        mPullToRefreshListView = null;
        mListHelper = null;
    }

    @Override
    protected void setRefreshHint() {
        super.setRefreshHint();
        if (mPullToRefreshListView != null) {
            setRefreshHint(mPullToRefreshListView);
            setLoadHints(mPullToRefreshListView);
        }
    }

    private void bindFriendList(List<MeariFriend> infos) {
        mPullToRefreshListView.onRefreshComplete();
        if (pageNum <= 0) {
            mAdapter.getData().clear();
        }
        bindEmpty(getString(R.string.no_friends));
        mAdapter.getData().addAll(dealFriends(infos));
        if (mAdapter.getData() == null || mAdapter.getData().size() == 0) {
            bindEmpty(getString(R.string.no_friends));
            mRightBtn.setVisibility(View.GONE);
        } else
            mRightBtn.setVisibility(View.VISIBLE);
        mAdapter.notifyDataSetChanged();
    }

    private List<FriendInfo> dealFriends(List<MeariFriend> infos) {
        List<FriendInfo> friendInfos = new ArrayList<>();
        for (MeariFriend info : infos) {
            friendInfos.add(getFriendInfo(info));
        }
        return friendInfos;
    }

    private FriendInfo getFriendInfo(MeariFriend info) {
        FriendInfo friendInfo = new FriendInfo();
        friendInfo.setAccountName(info.getAccountName());
        friendInfo.setImageUrl(info.getImageUrl());
        friendInfo.setIsDeal(info.getIsDeal());
        friendInfo.setNickName(info.getNickName());
        friendInfo.setUserFriendID(info.getUserFriendID());
        friendInfo.setFlag(0);
        return friendInfo;
    }


    public void onRecyclerItemClick(View view, FriendInfo data) {
        ImageView img = view.findViewById(R.id.selectAllImgId);
        if (mAdapter.isEditStatus()) {
            if (data.getFlag() == 0) {
                data.setFlag(1);
                img.setImageResource(R.mipmap.ic_message_select_p);
            } else {
                data.setFlag(0);
                img.setImageResource(R.mipmap.ic_message_select_n);
            }
        } else {
            Intent intent = new Intent(getActivity(), ShareFriendDeviceActivity.class);
            Bundle bundle = new Bundle();
            bundle.putSerializable("friendInfo", data);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_SHAREDEVICE);
        }
    }


    private DialogInterface.OnCancelListener mCancelListener = new DialogInterface.OnCancelListener() {

        @Override
        public void onCancel(DialogInterface dialog) {
            getActivity().finish();
        }
    };

    private void onDelPop() {
        if (this.mPop == null) {
            this.mPop = CommonUtils.showDlg(getActivity(), getString(R.string.app_meari_name), this.getString(R.string.delete_friends),
                    getString(R.string.ok), positiveClick,
                    getString(R.string.cancel), negtiveClick, false);
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
    DialogInterface.OnClickListener negtiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };


    public void onOkClick() {
        startProgressDialog(getString(R.string.delete_msg));
        getProgressDialog().setCanceledOnTouchOutside(false);
        clearDataRequest();
    }

    // 0表示处于未编辑状态，支持下拉刷新和上拉加载更多，1表示处于编辑状态，不支持下拉刷新和上拉加载更多
    public void setDeleteStatus(int status) {
        if (status == 0) {
            mRightBtn.setTag(0);
            mRightBtn.setImageResource(R.drawable.btn_delete);
            this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
            this.mFriendDelBtn.setVisibility(View.GONE);
            if (mAdapter.getDataCount() > 0)
                this.mRightBtn.setVisibility(View.VISIBLE);
            else
                this.mRightBtn.setVisibility(View.GONE);
        } else {
            this.mFriendDelBtn.setVisibility(View.VISIBLE);
            this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        }
    }

    private void onFriendDeleteClick() {
        String alertMsgIDs = mAdapter.getSelectAllMeariFriends();
        if (alertMsgIDs != null && alertMsgIDs.length() > 0) {
            onDelPop();
        } else
            CommonUtils.showToast(R.string.nothing_select);

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case ActivityType.ACTIVITY_SHAREDEVICE:
                onRefresh();
                break;
        }
    }
}
