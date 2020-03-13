package com.meari.test.fragment;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.DeviceAlarmMessage;
import com.meari.sdk.bean.DeviceMessageStatus;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.IDeviceAlarmMessagesCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.test.R;
import com.meari.test.SingleVideoActivity;
import com.meari.test.adapter.MsgDeviceAdapter;
import com.meari.test.db.AlertMsgDb;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.NetUtil;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MessageDeviceFragment extends BaseRecyclerFragment<DeviceAlarmMessage>
        implements BaseQuickAdapter.RequestLoadMoreListener, View.OnClickListener {
    private static final String TAG = "MessageDeviceFragment";
    @BindView(R.id.pull_to_refresh_view)
    public PullToRefreshRecyclerView mPullToRefreshListView;
    protected int mOffset = 0;
    protected int pageNum = 1;
    protected boolean isPrepared = true;
    public MsgDeviceAdapter mAdapter;
    public View mFragmentView;
    public UserInfo mUserInfo;
    private DeviceMessageStatus mMsgInfo;
    private AlertMsgDb mAlertMsgDb;
    private Dialog mPop;
    private ImageView mRightBtn;
    private final int EDIT = 1;
    private final int UNEDIT = 0;
    @BindView(R.id.btn_delete)
    public View mMsgDelBtn;
    @BindView(R.id.select_all_layout)
    public View mSelectAllLayout;
    @BindView(R.id.select_all_img)
    public ImageView mSelectAllImg;
    private boolean deviceStatus = false;
    public CameraInfo mCameraInfo;

    public static MessageDeviceFragment newInstance(DeviceMessageStatus info) {
        MessageDeviceFragment fragment = new MessageDeviceFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("msgInfo", info);
        fragment.setArguments(bundle);
        return fragment;
    }


    @SuppressLint("InflateParams")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        mFragmentView = inflater.inflate(R.layout.fragment_alram_message_list, null);
        this.mUserInfo = MeariUser.getInstance().getUserInfo();
        this.mMsgInfo = (DeviceMessageStatus) getArguments().getSerializable("msgInfo");
        mAdapter = new MsgDeviceAdapter(getActivity(), this);
        mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<DeviceAlarmMessage>() {
            @Override
            public void onItemClick(BaseQuickAdapter<DeviceAlarmMessage, ? extends BaseViewHolder> adapter, View view, int position) {
                if (mAdapter.isEditStatus()) {
                    seletItem(view, position);
                }
            }
        });
        ButterKnife.bind(this, mFragmentView);
        initView();
        return mFragmentView;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        onRefresh();
    }

    public void initView() {
        this.mRightBtn = getActivity().findViewById(R.id.submitRegisterBtn);
        mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
        mFragmentView.findViewById(R.id.select_all_layout).setOnClickListener(this);
        mFragmentView.findViewById(R.id.pps_message_mark_btn).setOnClickListener(this);
        this.mMsgDelBtn.setOnClickListener(this);
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        this.mRightBtn.setTag(UNEDIT);
        this.mRightBtn.setOnClickListener(this);
        this.mSelectAllLayout.setVisibility(View.GONE);
        this.mRightBtn.setVisibility(View.GONE);
        int margin = DisplayUtil.dpToPx(getContext(), 12);
        this.mRightBtn.setPadding(margin, margin, margin, margin);
        mPullToRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        mPullToRefreshListView.setLastUpdatedLabel(CommonDateUtils.getRefreshDate());
        mPullToRefreshListView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener2<RecyclerView>() {
            @Override
            public void onPullDownToRefresh(PullToRefreshBase<RecyclerView> refreshView) {
                onRefresh();
            }

            @Override
            public void onPullUpToRefresh(PullToRefreshBase<RecyclerView> refreshView) {
                onNextPage();
            }
        });
    }

    @Override
    public void onRefresh() {
        super.onRefresh();
        mOffset = 0;
        pageNum = 1;
        mPullToRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        requestMessageData();
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
        requestMessageData();
    }

    /**
     * 获取网络数据
     */
    public void requestMessageData() {
        // 检查网络是否可用
        if (!NetUtil.isNetworkAvailable()) {
            bindError(getString(R.string.network_unavailable));
            return;
        }
        if (this.mMsgInfo.getDeviceID() > 0) {
            MeariUser.getInstance().getAlarmMessagesForDev(this.mMsgInfo.getDeviceID(), new IDeviceAlarmMessagesCallback() {
                @Override
                public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo) {
                    mPullToRefreshListView.onRefreshComplete();
                    bindList(deviceAlarmMessages);
                    mCameraInfo = cameraInfo;
//                    deviceStatus = isDelete;
                }

                @Override
                public void onError(int code, String error) {
                    CommonUtils.showToast(error);
                    bindError(error);
                }
            });
        } else {
            bindError(getString(R.string.init_failed));
        }
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
                int tag = (int) v.getTag();
                if (tag == 0) {
                    mFragmentView.findViewById(R.id.select_all_layout).setTag(1);
                    mSelectAllImg.setImageResource(R.mipmap.icon_select_p);
                    setSelectStatus(2);
                } else {
                    mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
                    mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
                    setSelectStatus(1);
                }
                break;
            case R.id.btn_delete:
                onMessageDetailDelClick();
                break;
            case R.id.pps_message_mark_btn:
                onMessageMarkClick();
                break;
            default:
                break;
        }
    }

    private void onMessageMarkClick() {
        if (!NetUtil.checkNet(getActivity())) {
            CommonUtils.showToast(R.string.network_unavailable);
            return;
        }
        mAdapter.setMarkRead("Y");
        onResumeDelStatus();
        changeDbReadStaus();
        onPostMarkAlertMsg();
    }

    private void onPostMarkAlertMsg() {
        MeariUser.getInstance().markDevicesAlarmMessage(mMsgInfo.getDeviceID(), new IResultCallback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onError(int code, String error) {

            }
        });
//        OKHttpRequestParams params = new OKHttpRequestParams();
//        params.put("deviceID", String.valueOf());
//        OkGo
//                .post(Preference.BASE_URL_DEFAULT + API_METHOD_MARKALARMSG)
//                .headers(CommonUtils.getOKHttpHeader(getActivity(), API_METHOD_MARKALARMSG))
//                .params(params.getParams())
//                .id(3)
//                .tag(this)
//                .execute(new StringCallback(this));
    }

    private void changeDbReadStaus() {
        if (this.mAlertMsgDb == null) {
            this.mAlertMsgDb = new AlertMsgDb(getActivity());
        }
        this.mAlertMsgDb.updateAlertMsgIsReadByDeviceId(this.mMsgInfo.getDeviceID());
    }

    private void onEditClick() {
        int tag = (int) mRightBtn.getTag();
        if (tag == UNEDIT) {
            setDeleteStatus(EDIT);
            mAdapter.changeStatus(1);
            mRightBtn.setTag(1);
            mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.VISIBLE);
            mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
            mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
            mRightBtn.setImageResource(R.drawable.btn_cancel);
        } else {
            mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.VISIBLE);
            mRightBtn.setTag(0);
            mRightBtn.setImageResource(R.drawable.btn_delete);
            onResumeDelStatus();
        }
    }

    //pps_message_del_btn tag为0表示不是编辑状态
    private void onMessageDetailDelClick() {
        List<Long> alertMsgIDs = mAdapter.getselect_imgDTOList();
        if (alertMsgIDs.size() == 0) {
            CommonUtils.showToast(R.string.nothing_select);
        } else {
            onDelPop();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void setRefreshHint() {
        super.setRefreshHint();
        if (mPullToRefreshListView != null) {
            setRefreshHint(mPullToRefreshListView);
            setLoadHints(mPullToRefreshListView);
        }
    }

    private void bindList(List<DeviceAlarmMessage> infos) {

        if (infos != null && infos.size() > 0)
            new PPSDealDataTask(infos).execute();
        else {
            if (mAdapter.getDataCount() == 0)
                bindEmpty();
        }
    }


    // 0表示处于未编辑状态，支持下拉刷新和上拉加载更多，1表示处于编辑状态，不支持下拉刷新和上拉加载更多
    public void setDeleteStatus(int status) {
        if (status == 0) {
            mFragmentView.findViewById(R.id.bottom_tools).setVisibility(View.GONE);
            this.mRightBtn.setTag(0);
            this.mRightBtn.setImageResource(R.drawable.btn_delete);
            this.mAdapter.setEditStatus(false);
            this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        } else {
            this.mAdapter.setEditStatus(true);
            mFragmentView.findViewById(R.id.bottom_tools).setVisibility(View.VISIBLE);
            this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        }
    }

    public void setSelectStatus(int i) {
        mAdapter.changeStatus(i);
    }

    public ArrayList<DeviceAlarmMessage> dealDbData(List<DeviceAlarmMessage> infos) {
        ArrayList<DeviceAlarmMessage> messageDTOlist = new ArrayList<>();
        if (this.mAlertMsgDb == null) {
            this.mAlertMsgDb = new AlertMsgDb(getActivity());
        }
        if (infos != null && infos.size() > 0) {
            this.mAlertMsgDb.addAlertMsg(infos);
        }
        if (mUserInfo.getUserID() != 0)
            messageDTOlist = this.mAlertMsgDb.findAlertMsg(this.mMsgInfo.getDeviceID(), MeariUser.getInstance().getUserInfo().getUserID(), pageNum);
        return messageDTOlist;
    }

    public void changeDbStatus(DeviceAlarmMessage info) {
        if (this.mAlertMsgDb == null) {
            this.mAlertMsgDb = new AlertMsgDb(getActivity());
        }
        this.mAlertMsgDb.updateAlertMsgIsRead(info.getMsgID());
    }


    public void startPlay(int position) {
        getDataSource().get(position).setIsRead("Y");
        DeviceAlarmMessage data = getDataSource().get(position);
        this.mAdapter.notifyDataSetChanged();
        changeDbStatus(data);
        if (SingleVideoActivity.getInstance() != null)
            SingleVideoActivity.getInstance().finish();
        if (this.deviceStatus) {
            CommonUtils.showToast(R.string.delete_device);
            return;
        }
        Intent intent = new Intent();
        CameraInfo info = new CameraInfo();
        info.setDeviceName(mMsgInfo.getDeviceName());
        info.setDeviceID(String.valueOf(this.mMsgInfo.getDeviceID()));
        info.setUserAccount(mMsgInfo.getUserAccount());
        info.setDeviceName(mMsgInfo.getDeviceName());
        Bundle bundle = new Bundle();
        if (info.getBindingTy().equals("ND"))
            bundle.putInt("type", 2);
        else
            bundle.putInt("type", 1);
        bundle.putString("time", data.getCreateDate());
        bundle.putSerializable("cameraInfo", info);
        intent.putExtras(bundle);
        startActivity(intent);
    }

    private void seletItem(View view, int position) {
        ImageView img = view.findViewById(R.id.select_img);
        DeviceAlarmMessage messgeInfo = getDataSource().get(position);
        if (messgeInfo.getDelMsgFlag() == 1) {
            img.setImageResource(R.mipmap.icon_select_p);
            messgeInfo.setDelMsgFlag(2);
        } else {
            messgeInfo.setDelMsgFlag(1);
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

    public void onOkClick() {
        List<Long> alertMsgIDs = mAdapter.getselect_imgDTOList();
        startProgressDialog(getString(R.string.delete_msg));
        getProgressDialog().setCanceledOnTouchOutside(false);
        if (mAlertMsgDb == null) {
            mAlertMsgDb = new AlertMsgDb(getActivity());
        }
        if (mAdapter.isSelectAll()) {
            new DeleteMessageTask(this.mMsgInfo).execute();
            mAdapter.clearDelData();
            ArrayList<Long> devices = new ArrayList<>();
            devices.add(mMsgInfo.getDeviceID());
            MeariUser.getInstance().deleteDevicesAlarmMessage(devices, new IResultCallback() {
                @Override
                public void onSuccess() {
                    stopProgressDialog();
                    finish();
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(error);
                }
            });

        } else {
            mAlertMsgDb.deleteAlertMsgIsRead(alertMsgIDs);
            mAdapter.clearDelData();
            stopProgressDialog();
            onResumeDelStatus();
            if (getDataSource() == null || getDataSource().size() <= 0) {
                bindLoading();
                onRefresh();
                mRightBtn.setVisibility(View.GONE);
            }
            CommonUtils.showToast(R.string.delete_success);
        }
    }

    private JSONArray selectDeviceDeleteMsgDTOs() {
        JSONArray listDTO;
        listDTO = new JSONArray();
        listDTO.put(this.mMsgInfo.getDeviceID());
        return listDTO;
    }

    @Override
    public void onLoadMoreRequested() {
        if (!mPullToRefreshListView.getCurrentMode().equals(PullToRefreshBase.Mode.PULL_FROM_START)) {
            onNextPage();
        }
    }

    class PPSDealDataTask extends AsyncTask {

        private List<DeviceAlarmMessage> mInfos;

        private PPSDealDataTask(List<DeviceAlarmMessage> infos) {
            this.mInfos = infos;
        }

        @Override
        protected Objects doInBackground(Object[] params) {
            this.mInfos = dealDbData(mInfos);
            return null;
        }

        @Override
        protected void onPostExecute(Object o) {
            super.onPostExecute(o);
            if (mInfos.size() < 10 * pageNum) {
                mPullToRefreshListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);

            } else {
                mPullToRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
            }
            mAdapter.getData().clear();
            mAdapter.getData().addAll(mInfos);
            if (mAdapter.getData() == null || mAdapter.getData().size() == 0) {
                bindEmpty(getString(R.string.no_message));
                mRightBtn.setVisibility(View.GONE);
                setDeleteStatus(0);
                mRightBtn.setVisibility(View.GONE);
            } else {
                mRightBtn.setVisibility(View.VISIBLE);
            }
            mAdapter.notifyDataSetChanged();
        }
    }

    public void onResumeDelStatus() {
        this.setDeleteStatus(0);
        mAdapter.changeStatus(0);
        mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.GONE);
        this.mPullToRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        if (mAdapter != null && mAdapter.getItemCount() > 0)
            this.mRightBtn.setVisibility(View.VISIBLE);
        else
            this.mRightBtn.setVisibility(View.GONE);
        mAdapter.notifyDataSetChanged();
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

    class DeleteMessageTask extends AsyncTask<Void, Integer, Void> {

        private DeviceMessageStatus msgInfo;

        private DeleteMessageTask(DeviceMessageStatus msgInfo) {
            this.msgInfo = msgInfo;
        }

        @Override
        protected Void doInBackground(Void... params) {
            AlertMsgDb AlertMsgDb = new AlertMsgDb(getActivity());
            try {
                AlertMsgDb.deleteAlertMsgByDevice(this.msgInfo.getDeviceID(), MeariUser.getInstance().getUserInfo().getUserID());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return null;
        }

    }


}
