package com.meari.test;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.bean.NvrDeviceStatusInfo;
import com.meari.sdk.callback.IRemoveBindDeviceCallback;
import com.meari.sdk.callback.IGetBindDeviceList;
import com.meari.test.adapter.NVRCameraMangerAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.fragment.BaseRecyclerFragment;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.NetUtil;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/17
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class NVRCameraMangerFragment extends BaseRecyclerFragment<NvrDeviceStatusInfo>
        implements View.OnClickListener {
    private PullToRefreshRecyclerView mPullToRefreshRecyclerView;
    protected int mOffset = 0;
    protected int mIndexPage = 1;
    protected boolean isPrepared = true;
    public NVRCameraMangerAdapter mAdapter;
    public View mFragmentView;
    public NVRInfo mInfo;
    private ArrayList<NvrDeviceStatusInfo> mBindCameras;
    private ArrayList<NvrDeviceStatusInfo> mUnBindCameras;
    private ImageView mRightBtn;
    private final int EDIT = 1;
    private final int UN_EDIT = 0;
    private View mMsgDelBtn;
    private ImageView mSelectAllImg;
    private boolean bEditStatus;
    private View mSelectAllLayout;
    private Dialog mPop;
    private View mBottomView;

    public static NVRCameraMangerFragment newInstance(NVRInfo info) {
        NVRCameraMangerFragment fragment = new NVRCameraMangerFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("NVRInfo", info);
        fragment.setArguments(bundle);
        return fragment;
    }

    @SuppressLint("InflateParams")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        super.onCreateView(inflater, paramViewGroup, paramBundle);
        mFragmentView = inflater.inflate(R.layout.fragment_message_list, null);
        this.mInfo = (NVRInfo) getArguments().getSerializable("NVRInfo");
        mAdapter = new NVRCameraMangerAdapter(this);
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
        this.mMsgDelBtn = mFragmentView.findViewById(R.id.btn_delete);
        this.mRightBtn = getActivity().findViewById(R.id.submitRegisterBtn);
        this.mSelectAllImg = mFragmentView.findViewById(R.id.select_all_img);
        this.mSelectAllLayout = mFragmentView.findViewById(R.id.select_all_layout);
        this.mSelectAllLayout.setVisibility(View.GONE);
        mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
        mFragmentView.findViewById(R.id.select_all_layout).setOnClickListener(this);
        this.mMsgDelBtn.setOnClickListener(this);
        setRightStatus(UN_EDIT);
        mRightBtn.setVisibility(View.VISIBLE);
        int pad = DisplayUtil.dip2px(getActivity(), 13);
        this.mRightBtn.setPadding(pad, pad, pad, pad);
        this.mRightBtn.setOnClickListener(this);
        mPullToRefreshRecyclerView = v.findViewById(R.id.pull_to_refresh_view);
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
        mBottomView = LayoutInflater.from(getActivity()).inflate(R.layout.layout_camera_bottom, null);
        mBottomView.findViewById(R.id.bg_add).setOnClickListener(this);
        mBottomView.setVisibility(View.GONE);
        mAdapter.addFooterView(mBottomView);
        mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<NvrDeviceStatusInfo>() {
            @Override
            public void onItemClick(BaseQuickAdapter<NvrDeviceStatusInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                if (mAdapter.getEditStatus()) {
                    seletItem(view, position);
                } else {
                    return;
                }
            }
        });
        bindLoading();
    }

    private void setRightStatus(int status) {
        switch (status) {
            case UN_EDIT:
                this.mRightBtn.setImageResource(R.drawable.btn_delete);
                this.mRightBtn.setTag(UN_EDIT);
                break;
            case EDIT:
                this.mRightBtn.setImageResource(R.drawable.btn_cancel);
                this.mRightBtn.setTag(EDIT);
                break;
            default:
                break;
        }

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
        if (addDev) {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            intent.setClass(getActivity(), NVRWifiActivity.class);
            bundle.putSerializable("unBindCameras", mUnBindCameras);
            bundle.putSerializable("nvrInfo", mInfo);
            intent.putExtras(bundle);
            startActivityForResult(intent, ActivityType.ACTIVITY_NVRWIFI);
        } else {
            bindLoading();
            onRefresh();
        }
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
        MeariUser.getInstance().getBindDeviceList(mInfo.getDeviceID(),this , new IGetBindDeviceList() {
            @Override
            public void onSuccess(ArrayList<NvrDeviceStatusInfo> bindDevices, ArrayList<NvrDeviceStatusInfo> unBindDevices) {
                mBindCameras = bindDevices;
                mUnBindCameras = unBindDevices;
                bindDeviceList();
                mPullToRefreshRecyclerView.onRefreshComplete();
            }

            @Override
            public void onError(int code, String error) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                bindError(error);
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
                onEditClick();
                break;
            case R.id.select_all_layout:
                onSelectAllClick();
                break;
            case R.id.btn_delete:
                onDeviceDelclick();
                break;
            case R.id.bg_add:
                onAddClick();
                break;
            default:
                break;
        }
    }

    private void onAddClick() {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        intent.setClass(getActivity(), NVRWifiActivity.class);
        bundle.putSerializable("unBindCameras", mUnBindCameras);
        bundle.putSerializable("nvrInfo", mInfo);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_NVRWIFI);

    }

    public boolean isWifiConnect() {
        ConnectivityManager connManager = (ConnectivityManager) getActivity().getSystemService(Activity.CONNECTIVITY_SERVICE);
        NetworkInfo wifiInfo = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (wifiInfo == null) {
            return false;
        } else
            return wifiInfo.isConnected();
    }

    private void onDeviceDelclick() {
        if (mAdapter.isNothingSelect())
            CommonUtils.showToast(R.string.nothing_select);
        else
            showDeviceDelDialg();
    }

    private void showDeviceDelDialg() {
        onDelPop();
    }

    private void onDelPop() {
        if (this.mPop == null) {
            this.mPop = CommonUtils.showDlg(getActivity(), getString(R.string.app_meari_name), this.getString(R.string.sure_delete),
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
        postDelData();
    }

    public void postDelData() {
        // 检查网络是否可用
        if (!NetUtil.isNetworkAvailable()) {
            bindError(getString(R.string.network_unavailable));
            return;
        }
        startProgressDialog();
        ArrayList<String> deviceList = mAdapter.getSelectId();
        MeariUser.getInstance().unBindDevice(mInfo.getDeviceID(), deviceList, this ,new IRemoveBindDeviceCallback() {
            @Override
            public void onSuccess(String[] deviceIds) {
                stopProgressDialog();
                mAdapter.changStatusByIds(deviceIds);
                onResumeStatus();
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                showToast(error);
            }
        });
        startProgressDialog();
    }

    private void onSelectAllClick() {
        int tag = (int) mFragmentView.findViewById(R.id.select_all_layout).getTag();
        if (tag == 0) {
            mFragmentView.findViewById(R.id.select_all_layout).setTag(1);
            mSelectAllImg.setImageResource(R.mipmap.ic_img_slect_all);
            mAdapter.changAddDataDeviceMsg(2);
            mAdapter.notifyDataSetChanged();
        } else {
            mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
            mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
            mAdapter.changAddDataDeviceMsg(1);
            mAdapter.notifyDataSetChanged();
        }
    }

    private void onEditClick() {
        int tag = (int) mRightBtn.getTag();
        if (tag == UN_EDIT) {
            setDeleteStatus(EDIT);
            mAdapter.changAddDataDeviceMsg(1);
            mRightBtn.setTag(1);
            mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.VISIBLE);
            mRightBtn.setImageResource(R.drawable.btn_cancel);
            mBottomView.setVisibility(View.GONE);
            mAdapter.notifyDataSetChanged();
        } else {
            mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.VISIBLE);
            mRightBtn.setTag(0);
            mRightBtn.setImageResource(R.drawable.btn_delete);
            onResumeStatus();

        }
    }

    @Override
    public void onItemClick(View viewParam, NvrDeviceStatusInfo data, int position) {
        if (mAdapter.getEditStatus()) {
            seletItem(viewParam, position);
        } else {
            return;
        }
    }

    private void seletItem(View view, int position) {
        ImageView img = view.findViewById(R.id.select_img);
        NvrDeviceStatusInfo messgeInfo = getDataSource().get(position);
        if (messgeInfo.getDelMsgFlag() == 1) {
            img.setImageResource(R.mipmap.icon_select_p);
            messgeInfo.setDelMsgFlag(2);
        } else {
            messgeInfo.setDelMsgFlag(1);
            img.setImageResource(R.mipmap.ic_select_n);
        }
        boolean bSelAll = mAdapter.isAllSelect();
        if (!bSelAll) {
            mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
            mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
        } else {
            mFragmentView.findViewById(R.id.select_all_layout).setTag(1);
            mSelectAllImg.setImageResource(R.mipmap.ic_img_slect_all);
        }
    }

    public void onResumeStatus() {
        this.setDeleteStatus(0);
        mAdapter.changAddDataDeviceMsg(0);
        mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.GONE);
        this.mPullToRefreshRecyclerView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
        if (mAdapter != null && mAdapter.getItemCount() > 0)
            this.mRightBtn.setVisibility(View.VISIBLE);
        else
            this.mRightBtn.setVisibility(View.GONE);
        mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
        mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
        mAdapter.notifyDataSetChanged();
        if ((getDataSource() != null && getDataSource().size() < 8)) {
            mBottomView.setVisibility(View.VISIBLE);
        }
        if (getDataSource().size() == 0) {
            bindAddEmpty();
        }
    }

    // 0表示处于未编辑状态，支持下拉刷新和上拉加载更多，1表示处于未编辑状态，不支持下拉刷新和上拉加载更多
    public void setDeleteStatus(int status) {
        if (status == 0) {
            this.mAdapter.setEditStatus(false);
            this.mRightBtn.setTag(0);
            this.mRightBtn.setImageResource(R.drawable.btn_delete);
            this.mPullToRefreshRecyclerView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
            this.mMsgDelBtn.setVisibility(View.GONE);
            if (mAdapter.getDataCount() > 0)
                this.mRightBtn.setVisibility(View.VISIBLE);
            else
                this.mRightBtn.setVisibility(View.GONE);
        } else {
            this.mAdapter.setEditStatus(true);
            this.mMsgDelBtn.setVisibility(View.VISIBLE);
            this.mPullToRefreshRecyclerView.setMode(PullToRefreshBase.Mode.DISABLED);
        }
    }

    public void setEditStatus(boolean bEditStatus) {
        this.bEditStatus = bEditStatus;
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

    private void bindDeviceList() {
        this.getDataSource().clear();
        if (mBindCameras != null && mBindCameras.size() > 0) {
            mAdapter.getData().clear();
            mAdapter.getData().addAll(mBindCameras);
        } else {
            bindAddEmpty();
            return;
        }
        mAdapter.notifyDataSetChanged();
        if (mBindCameras.size() < 8)
            mBottomView.setVisibility(View.VISIBLE);
        else {
            mBottomView.setVisibility(View.GONE);
        }
        if (mAdapter != null && mAdapter.getItemCount() > 0)
            this.mRightBtn.setVisibility(View.VISIBLE);
        else
            this.mRightBtn.setVisibility(View.GONE);
    }

    public void addUnbindInfo(NvrDeviceStatusInfo info) {
        if (this.mUnBindCameras == null)
            this.mUnBindCameras = new ArrayList<>();
        if (info.getUserAccount().equals(MeariUser.getInstance().getUserInfo().getUserAccount()))
            this.mUnBindCameras.add(info);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_NVRWIFI:
                if (resultCode == Activity.RESULT_OK) {
                    Bundle bundle = data.getExtras();
                    ArrayList<NvrDeviceStatusInfo> Bindinfos = (ArrayList<NvrDeviceStatusInfo>) bundle.getSerializable("bindNvrCameraInfos");
                    mUnBindCameras = (ArrayList<NvrDeviceStatusInfo>) bundle.getSerializable("unBindNvrCameraInfos");
                    getDataSource().addAll(Bindinfos);
                    mAdapter.notifyDataSetChanged();
                    if (mAdapter != null && mAdapter.getDataCount() > 0)
                        this.mRightBtn.setVisibility(View.VISIBLE);
                    else
                        this.mRightBtn.setVisibility(View.GONE);
                }
                break;
            default:
                break;
        }
    }


}

