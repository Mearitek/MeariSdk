package com.meari.test.fragment;

import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.SystemMessageInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.IDealSystemCallback;
import com.meari.sdk.callback.IGetSystemMessageCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.test.R;
import com.meari.test.adapter.MessageSysAdapter;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.NetUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/18
 * 描    述：系统消息
 * 修订历史：
 * ================================================
 */

public class SystemMessageFragment extends BaseRecyclerFragment<SystemMessageInfo> {

    protected int mOffset = 0;
    protected int pageNum = 0;
    protected boolean isPrepared = true;
    public MessageSysAdapter mAdapter;
    public View mFragmentView;
    public UserInfo mUserInfo;
    private Dialog mPop;
    private final int EDIT = 1;
    private final int UNEDIT = 0;
    private ImageView mRightBtn;
    @BindView(R.id.btn_delete)
    public View mMsgDelBtn;
    @BindView(R.id.select_all_layout)
    public View mSelectAllLayout;
    @BindView(R.id.select_all_img)
    public ImageView mSelectAllImg;
    @BindView(R.id.pull_to_refresh_view)
    public PullToRefreshRecyclerView mPullToRefreshListView;

    public static SystemMessageFragment newInstance() {
        SystemMessageFragment fragment = new SystemMessageFragment();
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        super.onCreateView(inflater, paramViewGroup, paramBundle);
        mFragmentView = inflater.inflate(R.layout.fragment_message_list, null);
        ButterKnife.bind(this, mFragmentView);
        this.mUserInfo = MeariUser.getInstance().getUserInfo();
        mAdapter = new MessageSysAdapter(getActivity());
        mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<SystemMessageInfo>() {
            @Override
            public void onItemClick(BaseQuickAdapter<SystemMessageInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                SystemMessageInfo info = adapter.getItem(position);
                onRecyclerItemClick(view, info, position);
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
        mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
        mFragmentView.findViewById(R.id.select_all_layout).setOnClickListener(this);
        this.mMsgDelBtn.setOnClickListener(this);
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        int margin = DisplayUtil.dpToPx(getContext(), 12);
        this.mRightBtn.setPadding(margin, margin, margin, margin);
        this.mRightBtn.setTag(UNEDIT);
        this.mRightBtn.setOnClickListener(this);
        this.mSelectAllLayout.setVisibility(View.GONE);
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

    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public void onRefresh() {
        super.onRefresh();
        mOffset = 0;
        pageNum = 0;
        netWorkRequest();
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
        netWorkRequest();
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
        if (getContext() == null || getActivity() == null || getActivity().isFinishing())
            return;

        MeariUser.getInstance().getSystemMessage(this ,new IGetSystemMessageCallback() {
            @Override
            public void onError(int code, String error) {
                mPullToRefreshListView.onRefreshComplete();
                bindError(error);
                CommonUtils.showToast(error);
            }

            @Override
            public void onSuccess(List<SystemMessageInfo> systemMessages) {
                bindList(systemMessages);
                mPullToRefreshListView.onRefreshComplete();
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
            case R.id.select_all_layout:
                onSelectAllClick();
                break;
            case R.id.btn_delete:
                onMessageDetailDelClick();
                break;
            default:
                break;
        }
    }

    private void onSelectAllClick() {
        int tag = (int) mFragmentView.findViewById(R.id.select_all_layout).getTag();
        if (tag == 0) {
            mFragmentView.findViewById(R.id.select_all_layout).setTag(1);
            mSelectAllImg.setImageResource(R.mipmap.ic_img_slect_all);
            mAdapter.changeStatus(2);
        } else {
            mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
            mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
            mAdapter.changeStatus(1);
        }
    }

    private void onEditClick() {
        int tag = (int) mRightBtn.getTag();
        if (tag == UNEDIT) {
            setDeleteStatus(EDIT);
            mAdapter.changeStatus(1);
            mRightBtn.setTag(1);
            mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.VISIBLE);
            getActivity().findViewById(R.id.tab_layout).setVisibility(View.GONE);
            mRightBtn.setImageResource(R.drawable.btn_cancel);
            mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
            mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
        } else {
            getActivity().findViewById(R.id.tab_layout).setVisibility(View.VISIBLE);
            mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.VISIBLE);
            mRightBtn.setTag(0);
            mRightBtn.setImageResource(R.drawable.btn_delete);
            onResumeDelStatus();
        }


    }

    public void onResumeDelStatus() {
        this.setDeleteStatus(0);
        mAdapter.changeStatus(0);
        mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.GONE);
        getActivity().findViewById(R.id.tab_layout).setVisibility(View.VISIBLE);
        this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
        if (mAdapter != null && mAdapter.getDataCount() > 0)
            this.mRightBtn.setVisibility(View.VISIBLE);
        else
            this.mRightBtn.setVisibility(View.GONE);
        mAdapter.notifyDataSetChanged();
    }


    public void clearDataRequest() {
        if (getContext() == null || getActivity() == null || getActivity().isFinishing())
            return;
        if (!NetUtil.checkNet(getContext())) {
            CommonUtils.showToast(R.string.network_unavailable);
        } else {
            ArrayList<Long> selectDeleteMsgIds = mAdapter.selectDeleteMsgIds();
            if (NetUtil.checkNet(getActivity())) {
                startProgressDialog();
                getProgressDialog().setOnCancelListener(this.mCancelListener);
                MeariUser.getInstance().deleteSystemMessage(selectDeleteMsgIds,this , new IResultCallback() {
                    @Override
                    public void onSuccess() {
                        stopProgressDialog();
                        mAdapter.clearDelData();
                        onResumeDelStatus();
                        if (getDataSource() == null || getDataSource().size() <= 0) {
                            mRightBtn.setVisibility(View.GONE);
                            bindLoading();
                            onRefresh();
                        }
                    }

                    @Override
                    public void onError(int code, String error) {
                        stopProgressDialog();
                        CommonUtils.showToast(error);
                    }
                });
            }
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

//    @Override
//    public void callback(ResponseData data, int tag) {
//        if (getActivity() == null || getActivity().isFinishing()) {
//            return;
//        }
//        stopProgressDialog();
//        super.callback(data, tag);
//        switch (tag) {
//            case 0:
//                if (data.isErrorCaught()) {
//                    isPrepared = true;
//                    bindError(data.getErrorMessage());
//                } else {
//                    isPrepared = false;
//                    bindOrderList(data.getJsonResult());
//                }
//                break;
//            case 1:
//                if (data.isErrorCaught()) {
//                    CommonUtils.showToast(data.getErrorMessage());
//                } else {
//                    mAdapter.clearDelData();
//                    onResumeDelStatus();
//                    if (getDataSource() == null || getDataSource().size() <= 0) {
//                        mRightBtn.setVisibility(View.GONE);
//                        bindLoading();
//                        onRefresh();
//                    }
//                }
//                break;
//            case 2:
//                if (data.isErrorCaught()) {
//                    CommonUtils.showToast(data.getErrorMessage());
//                }
//                if (!data.isErrorCaught()) {
//                    shareResult(data);
//                }
//                break;
//            case 3:
//                if (!data.isErrorCaught()) {
//                    shareResult(data);
//                } else {
//                    CommonUtils.showToast(data.getErrorMessage());
//                }
//                break;
//        }
//    }


    public void shareResult(Long msgId) {
        mAdapter.changeDelDate(msgId);
        if (getDataSource() == null || getDataSource().size() == 0) {
            bindEmpty();
            this.mRightBtn.setVisibility(View.GONE);
        } else
            this.mRightBtn.setVisibility(View.VISIBLE);
    }

    private void bindList(List<SystemMessageInfo> infos) {
        if (infos == null)
            return;
        mPullToRefreshListView.onRefreshComplete();
        if (pageNum <= 0) {
            mAdapter.getData().clear();
        }
        bindEmpty();
        mAdapter.getData().addAll(infos);
        if (mAdapter.getData() == null || mAdapter.getData().size() == 0) {
            bindEmpty();
            mRightBtn.setVisibility(View.GONE);
        } else
            mRightBtn.setVisibility(View.VISIBLE);
        mAdapter.notifyDataSetChanged();
    }


    public void onRecyclerItemClick(View view, SystemMessageInfo data, int position) {
        if (mAdapter.isEditStaus()) {
            seletItem(view, data, position);
        } else {
            postDealMessage(position);
        }
    }

    private void seletItem(View view, SystemMessageInfo data, int position) {
        ImageView img = view.findViewById(R.id.select_img);
        SystemMessageInfo messgeInfo = getDataSource().get(position);
        if (messgeInfo.getDelNum() == 1) {
            view.findViewById(R.id.arrow_img).setVisibility(View.GONE);
            img.setImageResource(R.mipmap.icon_select_p);
            messgeInfo.setDelNum(2);
        } else {
            messgeInfo.setDelNum(1);
            view.findViewById(R.id.arrow_img).setVisibility(View.GONE);
            img.setImageResource(R.mipmap.ic_select_n);
        }
        boolean bSelAll = mAdapter.isSelectAll();
        if (!bSelAll) {
            mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
            mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
        } else {
            mFragmentView.findViewById(R.id.select_all_layout).setTag(1);
            mSelectAllImg.setImageResource(R.mipmap.ic_img_slect_all);
        }
    }


    private void postDealMessage(int position) {
        final SystemMessageInfo msgInfo = getDataSource().get(position);
        if ((msgInfo.getMsgTypeID() != 1) && (msgInfo.getMsgTypeID() != 2)) {
            return;
        }
        DialogInterface.OnClickListener positiveClick;
        DialogInterface.OnClickListener negativeClick;
        String content = "";
        if (msgInfo.getMsgTypeID() == 1) {
            content = msgInfo.getNickName() + " " + getString(R.string.addFriendDes);
            positiveClick = new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                    startProgressDialog();
                    MeariUser.getInstance().agreeFriend(msgInfo.getMsgID(), msgInfo.getUserID(),this , new IDealSystemCallback() {
                        @Override
                        public void onSuccess(long msgId) {
                            stopProgressDialog();
                            shareResult(msgId);
                        }

                        @Override
                        public void onError(int code, String error) {
                            stopProgressDialog();
                            CommonUtils.showToast(error);
                        }
                    });
                }
            };
            negativeClick = new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                    startProgressDialog();
                    MeariUser.getInstance().refuseFriend(msgInfo.getMsgID(), msgInfo.getUserID(),this , new IDealSystemCallback() {
                        @Override
                        public void onSuccess(long msgId) {
                            stopProgressDialog();
                            shareResult(msgId);
                        }

                        @Override
                        public void onError(int code, String error) {
                            stopProgressDialog();
                            CommonUtils.showToast(error);
                        }
                    });
                }
            };

        } else {
            content = msgInfo.getNickName() + getString(R.string.addDeviceDes) + "(" + msgInfo.getDeviceName() + ").";
            positiveClick = new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.cancel();
                    // 同意分享设备
                    startProgressDialog();
                    MeariUser.getInstance().agreeShareDevice(msgInfo.getMsgID(), msgInfo.getUserID(), msgInfo.getDeviceID(),this , new IDealSystemCallback() {
                        @Override
                        public void onSuccess(long msgId) {
                            stopProgressDialog();
                            shareResult(msgId);
                        }

                        @Override
                        public void onError(int code, String error) {
                            stopProgressDialog();
                            CommonUtils.showToast(error);
                        }

                    });
                }
            };
            negativeClick = new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                    startProgressDialog();
                    startProgressDialog();
                    MeariUser.getInstance().refuseShareDevice(msgInfo.getMsgID(), msgInfo.getUserID(), msgInfo.getDeviceID(),this , new IDealSystemCallback() {
                        @Override
                        public void onSuccess(long msgId) {
                            stopProgressDialog();
                            shareResult(msgId);
                        }

                        @Override
                        public void onError(int code, String error) {
                            stopProgressDialog();
                            CommonUtils.showToast(error);
                        }

                    });
                }
            };
        }
        CommonUtils.showDlg(getActivity(), getString(R.string.app_meari_name), content, getString(R.string.ok), positiveClick, getString(R.string.pps_reject), negativeClick, true);
    }

    public void setSelectStatus(int i) {
        mAdapter.changeStatus(i);
    }

    private DialogInterface.OnCancelListener mCancelListener = new DialogInterface.OnCancelListener() {

        @Override
        public void onCancel(DialogInterface dialog) {
            getActivity().finish();
        }
    };

    private void onDelPop() {
        if (this.mPop == null) {
            this.mPop = CommonUtils.showDlg(getActivity(), getString(R.string.app_meari_name), this.getString(R.string.sure_delete_meg),
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

    // 0表示处于未编辑状态，支持下拉刷新和上拉加载更多，1表示处于未编辑状态，不支持下拉刷新和上拉加载更多
    public void setDeleteStatus(int status) {
        if (status == 0) {
            this.mAdapter.setEditStaus(false);
            mRightBtn.setTag(0);
            mRightBtn.setImageResource(R.drawable.btn_delete);
            this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
            this.mMsgDelBtn.setVisibility(View.GONE);
            if (mAdapter.getDataCount() > 0)
                this.mRightBtn.setVisibility(View.VISIBLE);
            else
                this.mRightBtn.setVisibility(View.GONE);
        } else {
            this.mAdapter.setEditStaus(true);
            this.mMsgDelBtn.setVisibility(View.VISIBLE);
            this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        }
    }

    private void onMessageDetailDelClick() {
        List<Long> alertMsgIDs = mAdapter.getSelectAllMsgDTOList();
        if (alertMsgIDs.size() > 0) {
            onDelPop();
        } else
            CommonUtils.showToast(R.string.nothing_select);

    }

    public class DeleteMessageClick implements DialogInterface.OnClickListener {

        @Override
        public void onClick(DialogInterface dialog, int which) {

        }
    }

}

