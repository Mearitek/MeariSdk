package com.meari.test.fragment;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.DeviceAlarmMessage;
import com.meari.sdk.bean.DeviceMessageStatusInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.IGetAlarmMessageStatusForDevCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.test.MainActivity;
import com.meari.test.MessageDeviceActivity;
import com.meari.test.R;
import com.meari.test.adapter.MessageAdapter;
import com.meari.test.common.ActivityType;
import com.meari.test.db.AlertMsgDb;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DevicePreUtil;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.NetUtil;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/18
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MessageAlarmFragment extends BaseRecyclerFragment<DeviceMessageStatusInfo> implements View.OnClickListener {
    private static final String TAG = "MessageAlarmFragment";
    protected int mOffset = 0;
    protected int mIndexPage = 1;
    private PullToRefreshRecyclerView mPullToRefreshRecyclerView;
    private ArrayList<DeviceMessageStatusInfo> mList = new ArrayList<>();
    public MessageAdapter mAdapter;
    public View mFragmentView;
    public UserInfo mUserInfo;
    private View mMsgDelBtn;//tag 0 表示未编辑状态 1 表示编辑状态
    private AlertMsgDb mAlertMsgDb;
    private List<Long> mDeviceIDNoReadList;
    private List<Long> mDeviceIDAllList;
    private Dialog mPop;
    private ImageView mRightBtn;
    private final int EDIT = 1;
    private final int UN_EDIT = 0;
    private View mSelectAllLayout;
    private ImageView mSelectAllImg;

    public static MessageAlarmFragment newInstance() {
        MessageAlarmFragment fragment = new MessageAlarmFragment();
        return fragment;
    }


    @SuppressLint("InflateParams")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        super.onCreateView(inflater, paramViewGroup, paramBundle);
        mFragmentView = inflater.inflate(R.layout.fragment_message_list, null);
        this.mUserInfo = MeariUser.getInstance().getUserInfo();
        mAdapter = new MessageAdapter(getActivity());
        mAlertMsgDb = new AlertMsgDb(getActivity());
        mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<DeviceMessageStatusInfo>() {
            @Override
            public void onItemClick(BaseQuickAdapter<DeviceMessageStatusInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                DeviceMessageStatusInfo info = adapter.getItem(position);
                onRecyclerItemClick(view, info, position);
            }
        });
        initView(mFragmentView);
        ButterKnife.bind(this, mFragmentView);
        return mFragmentView;
    }

    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        bindLoading();
        onRefresh();
    }

    public void initView(View v) {
        this.mRightBtn = getActivity().findViewById(R.id.submitRegisterBtn);
        this.mMsgDelBtn = mFragmentView.findViewById(R.id.btn_delete);
        this.mSelectAllLayout = mFragmentView.findViewById(R.id.select_all_layout);
        this.mSelectAllImg = mFragmentView.findViewById(R.id.select_all_img);
        mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
        this.mSelectAllLayout.setVisibility(View.GONE);
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        int margin = DisplayUtil.dpToPx(getContext(), 12);
        this.mRightBtn.setPadding(margin, margin, margin, margin);
        this.mRightBtn.setTag(UN_EDIT);
        this.mRightBtn.setVisibility(View.GONE);
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
    }

    @Override
    public void onRefresh() {
        super.onRefresh();
        mOffset = 0;
        mIndexPage = 1;
        postAlarmData();
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
        mIndexPage++;
        postAlarmData();
    }

    /**
     * 获取网络数据
     */
    public void postAlarmData() {
        if (!NetUtil.isNetworkAvailable()) {
            bindError(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().getAlarmMessageStatusForDev(this ,new IGetAlarmMessageStatusForDevCallback() {
            @Override
            public void onError(int code, String error) {
                if (isDetached())
                    mPullToRefreshRecyclerView.onRefreshComplete();
                CommonUtils.showToast(error);
            }

            @Override
            public void onSuccess(List<DeviceMessageStatusInfo> deviceMessageStatus) {
                if (isDetached())
                    return;
                bindOrderList(deviceMessageStatus);
            }
        });
    }

    @SuppressWarnings("unchecked")
    private void initData() {
        MessageTask task = new MessageTask();
        task.execute(new ArrayList<DeviceAlarmMessage>());
    }

    public void onOkClick() {
        postDelMessageData();
    }


    class MessageTask extends AsyncTask<ArrayList<DeviceAlarmMessage>, Void, Boolean> {
        @Override
        protected Boolean doInBackground(ArrayList<DeviceAlarmMessage>... params) {
            try {
                if (getActivity() == null && getActivity().isFinishing()) {
                    return true;
                }
                if (mAlertMsgDb == null) {
                    mAlertMsgDb = new AlertMsgDb(getActivity());
                }
                mDeviceIDNoReadList = mAlertMsgDb.findAlertMsgNoReadStatus(mUserInfo.getUserID());
                mDeviceIDAllList = mAlertMsgDb.findAlertMsgStatus(mUserInfo.getUserID());
                return true;
            } catch (Exception e) {
                return true;
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            super.onPostExecute(result);

        }

        @Override
        protected void onCancelled(Boolean result) {
            super.onCancelled(result);
        }
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
        return getString(R.string.no_message);
    }


    @OnClick(R.id.select_all_layout)
    public void onSelectAllClick() {
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


    public void onEditClick() {
        int tag = (int) mRightBtn.getTag();
        if (tag == UN_EDIT) {
            setDeleteStatus(EDIT);
            mAdapter.changAddDataDeviceMsg(1);
            mRightBtn.setTag(1);
            mPullToRefreshRecyclerView.setMode(PullToRefreshBase.Mode.DISABLED);
            mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.VISIBLE);
            getActivity().findViewById(R.id.tab_layout).setVisibility(View.GONE);
            mRightBtn.setImageResource(R.drawable.btn_cancel);
            mAdapter.notifyDataSetChanged();
        } else {
            getActivity().findViewById(R.id.tab_layout).setVisibility(View.VISIBLE);
            mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.VISIBLE);
            mRightBtn.setTag(0);
            mRightBtn.setImageResource(R.drawable.btn_delete);

            onResumeStatus();
        }

    }

    public void postDelMessageData() {
        ArrayList<Long> deviceInfos = selectDeleteDevices();
        if ((deviceInfos != null && deviceInfos.size() > 0)) {
            if (NetUtil.checkNet(getActivity())) {
                CommonUtils.showToast(getString(R.string.delete_file));
                PPSDeleteMessageTask deleteMessageTask = new PPSDeleteMessageTask(deviceInfos);
                deleteMessageTask.execute();
                MeariUser.getInstance().deleteDevicesAlarmMessage(deviceInfos, this ,new IResultCallback() {
                    @Override
                    public void onSuccess() {
                        stopProgressDialog();
                        deleteCallback();
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

    private void showonMessageDeviceDelDialg() {
        onDelPop();
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
        mPullToRefreshRecyclerView.onRefreshComplete();
        mPullToRefreshRecyclerView.setLastUpdatedLabel(CommonDateUtils.getRefreshDate());
    }

//    @Override
//    public void callback(ResponseData data, int tag) {
//        if (getActivity() == null || getActivity().isFinishing()) {
//            return;
//        }
//        super.callback(data, tag);
//        switch (tag) {
//            case 0:
//                if (data.isErrorCaught()) {
//                    bindError(data.getErrorMessage());
//                } else {
//                    Logger.i(TAG, "报警消息设备列表：" + data.getJsonResult().toString());
//                    bindOrderList(data);
//                }
//                break;
//            case 1:
//                stopProgressDialog();
//                if (data.isErrorCaught()) {
//                    CommonUtils.showToast(data.getErrorMessage());
//                    break;
//                }
//                deleteCallback();
//                break;
//            default:
//                break;
//
//        }
//    }

    private void bindOrderList(List<DeviceMessageStatusInfo> infos) {
        if (mIndexPage <= 1) {
            mList.clear();
        }
        dealCallBackData(infos);
        if (mList != null && mList.size() > 0) {
            this.mRightBtn.setVisibility(View.VISIBLE);
            mAdapter.setNewData(mList);
        } else {
            this.mRightBtn.setVisibility(View.GONE);
            mAdapter.getData().clear();
            mAdapter.notifyDataSetChanged();
            bindEmpty(getString(R.string.no_message));
        }
        mPullToRefreshRecyclerView.onRefreshComplete();
    }

    private void deleteCallback() {
        mAdapter.changeFriendData();
        onResumeStatus();
        mAdapter.notifyDataSetChanged();
        if (mAdapter.getData() == null || mAdapter.getData().size() == 0)
            bindEmpty();
    }

    public void onResumeStatus() {
        this.setDeleteStatus(0);
        mAdapter.changAddDataDeviceMsg(0);
        mFragmentView.findViewById(R.id.select_all_layout).setVisibility(View.GONE);
        getActivity().findViewById(R.id.tab_layout).setVisibility(View.VISIBLE);
        mPullToRefreshRecyclerView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
        if (mAdapter != null && mAdapter.getDataCount() > 0)
            this.mRightBtn.setVisibility(View.VISIBLE);
        else
            this.mRightBtn.setVisibility(View.GONE);
        mFragmentView.findViewById(R.id.select_all_layout).setTag(0);
        mSelectAllImg.setImageResource(R.mipmap.ic_select_n);
        mAdapter.notifyDataSetChanged();
    }

    @Override
    public void onClick(View param) {
        super.onClick(param);
        switch (param.getId()) {
            case R.id.submitRegisterBtn:
                onEditClick();
                break;
        }
    }

    @OnClick(R.id.btn_delete)
    public void onMessageDeviceDelClick() {
        if (mAdapter.isNothingSelect())
            CommonUtils.showToast(R.string.nothing_select);
        else
            showonMessageDeviceDelDialg();
    }

    public void onRecyclerItemClick(View viewParam, DeviceMessageStatusInfo data, int position) {
        if (mAdapter.isEditStatus()) {
            selectItem(viewParam, position);
        } else {
            goMessageActivity(position);
        }
    }

    private void goMessageActivity(int position) {
        if (getDataSource() == null || getDataSource().size() < position)
            return;
        DeviceMessageStatusInfo data = getDataSource().get(position);
        Bundle bundle = new Bundle();
        bundle.putSerializable("msgInfo", data);
        Intent intent = new Intent(getActivity(), MessageDeviceActivity.class);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_MESSAGEDEVICE);
    }

    private void selectItem(View view, int position) {
        ImageView img = view.findViewById(R.id.select_img);
        DeviceMessageStatusInfo messageInfo = getDataSource().get(position);
        if (messageInfo.getDelMsgFlag() == 1) {
            img.setImageResource(R.mipmap.icon_select_p);
            messageInfo.setDelMsgFlag(2);
        } else {
            messageInfo.setDelMsgFlag(1);
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

    private JSONArray selectDeviceDeleteMsgDTOs() {
        JSONArray listDTO = null;
        if (getDataSource() != null && getDataSource().size() > 0) {
            listDTO = new JSONArray();
            for (int i = 0; i < getDataSource().size(); i++) {
                if (getDataSource().get(i).getDelMsgFlag() == 2) {
                    if (getDataSource().get(i).getDeviceID() != 0) {
                        listDTO.put(getDataSource().get(i).getDeviceID());
                    }
                }
            }
        }
        return listDTO;
    }

    private ArrayList<Long> selectDeleteDevices() {
        ArrayList<Long> list = new ArrayList<>();
        if (getDataSource() != null && getDataSource().size() > 0) {

            for (int i = 0; i < getDataSource().size(); i++) {
                if (getDataSource().get(i).getDelMsgFlag() == 2) {
                    if (getDataSource().get(i).getDeviceID() != 0) {
                        list.add(getDataSource().get(i).getDeviceID());
                    }
                }
            }
        }
        return list;
    }

    public void dealCallBackData(List<DeviceMessageStatusInfo> infos) {
        if (infos == null || infos.size() == 0) {
            return;
        }
        if (this.mAlertMsgDb == null) {
            mAlertMsgDb = new AlertMsgDb(getActivity());
        }
        final List<Long> deviceIDList = new ArrayList<>();
        DevicePreUtil.initSharedPreference(getActivity());
        dealData();
        mList.clear();
        mList.addAll(infos);
        if (mList != null && mList.size() > 0) {
            for (int i = 0; i < mList.size(); i++) {
                deviceIDList.add(mList.get(i).getDeviceID());
            }
        }
        if (deviceIDList.size() > 0) {
            new Thread() {
                @Override
                public void run() {
                    List<Long> deviceIDListPast = DevicePreUtil.getInstance().getDeviceIDList();
                    Map<String, Object> map = judgeDate(deviceIDListPast, deviceIDListPast);
                    if (map.get("compareResult") != null && map.get("compareResult").equals("1001")) {
                        DevicePreUtil.getInstance().putDeviceIDList(deviceIDList);
                        ArrayList<Long> compareList = (ArrayList<Long>) map.get("deleteDate");
                        if (mAlertMsgDb == null) {
                            mAlertMsgDb = new AlertMsgDb(getActivity());
                        }
                        try {
                            mAlertMsgDb.deleteAlertMsgByDeviceID(compareList, mUserInfo.getUserID());
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                    } else if (map.get("compareResult") != null && map.get("compareResult").equals("1002")) {
                        DevicePreUtil.getInstance().putDeviceIDList(deviceIDList);
                    }
                }
            }.start();
        }
    }


    private void dealData() {
        mDeviceIDNoReadList = mAlertMsgDb.findAlertMsgNoReadStatus(mUserInfo.getUserID());
        mDeviceIDAllList = mAlertMsgDb.findAlertMsgStatus(mUserInfo.getUserID());
        for (DeviceMessageStatusInfo msgInfo : mList) {
            if (msgInfo.getHasMessgFlag().equals("N")) {
                if (this.mDeviceIDNoReadList.contains(msgInfo.getDeviceID())) {
                    msgInfo.setHasMessgFlag("Y");
                }
            } else {
                msgInfo.setHasMessgFlag("Y");
            }
            if (msgInfo.getHasMessgFlag().equals("N") && !this.mDeviceIDAllList.contains(msgInfo.getDeviceID())) {
                msgInfo.setbHasMsg(false);
            } else
                msgInfo.setbHasMsg(true);
        }
    }

    /*
     * ArrayList 需要删除的消息 true 需要将数据保存起来 false 无需任何操作
     */
    public static Map<String, Object> judgeDate(List<Long> pastList, List<Long> list) {
        Map<String, Object> map = new HashMap<>();
        if (pastList != null && pastList.size() > 0 && list != null && list.size() > 0) {
            ArrayList<Long> pastCompare = new ArrayList<>();
            ArrayList<Long> listCompare = new ArrayList<>();
            for (int i = 0; i < pastList.size(); i++) {
                boolean bool = false;
                for (int j = 0; j < list.size(); j++) {
                    if (pastList.get(i).equals(list.get(j))) {
                        bool = true;
                        break;
                    }
                }
                if (!bool) {
                    pastCompare.add(pastList.get(i));
                }
            }

            for (int i = 0; i < list.size(); i++) {
                boolean bool = false;
                for (int j = 0; j < pastList.size(); j++) {
                    if (list.get(i).equals(pastList.get(j))) {
                        bool = true;
                        break;
                    }
                }

                if (!bool) {
                    listCompare.add(list.get(i));
                }
            }

            if (pastCompare.size() > 0 && listCompare.size() > 0) {
                // 都要进行
                map.put("compareResult", "1001");
                map.put("deleteDate", pastCompare);
            }

            if (pastCompare.size() == 0 && listCompare.size() > 0) {
                // 过去没有，现在有 只需要保存
                map.put("compareResult", "1002");
            }

            if (pastCompare.size() > 0 && listCompare.size() == 0) {
                // 过去有，现在没有 只需要删除.保存
                map.put("compareResult", "1001");
                map.put("deleteDate", pastCompare);
            }

            if (pastCompare.size() == 0 && listCompare.size() == 0) {
                // 都保存
                map.put("compareResult", "1003");
            }

        } else {
            if (pastList == null && list != null && list.size() > 0) {
                // 过去没有 现在有
                map.put("compareResult", "1002");
            }
            if (pastList != null && pastList.size() > 0 && list == null) {
                map.put("compareResult", "1001");
                map.put("deleteDate", pastList);
            }
            if (pastList == null && list == null) {
                map.put("compareResult", "1003");
            }
        }
        return map;
    }

    public void setSelectAllStatus(int status) {
        if (status == 0) {
            this.mAdapter.changAddDataDeviceMsg(1);
        } else {
            this.mAdapter.changAddDataDeviceMsg(2);
        }
        mAdapter.notifyDataSetChanged();
    }

    class PPSDeleteMessageTask extends AsyncTask<Void, Integer, Void> {

        private ArrayList<Long> mDeviceIDList;

        public PPSDeleteMessageTask(ArrayList<Long> deviceMsgMoreDel) {
            this.mDeviceIDList = deviceMsgMoreDel;
        }

        @Override
        protected Void doInBackground(Void... params) {
            try {
                if (mDeviceIDList != null && mDeviceIDList.size() > 0) {
                    AlertMsgDb AlertMsgDb = new AlertMsgDb(getActivity());
                    AlertMsgDb.deleteAlertMsgByDeviceID(mDeviceIDList, mUserInfo.getUserID());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null;
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

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (MainActivity.getInstance() != null) {
            onRefresh();
        }
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
}
