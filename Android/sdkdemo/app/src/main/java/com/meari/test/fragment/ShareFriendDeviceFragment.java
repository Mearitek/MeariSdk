package com.meari.test.fragment;

import android.annotation.SuppressLint;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.MeariFriend;
import com.meari.sdk.bean.MeariSharedDevice;
import com.meari.sdk.callback.IQueryDeviceListForFriendCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.sdk.callback.IShareForDevCallback;
import com.meari.sdk.common.DeviceType;
import com.meari.test.R;
import com.meari.test.adapter.ShareDeviceAdapter;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.pulltorefresh.PullToRefreshRecyclerView;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.EmojiFilter;
import com.meari.test.utils.NetUtil;

import java.util.List;


/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/9/14
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ShareFriendDeviceFragment extends BaseRecyclerFragment<MeariSharedDevice> {
    private PullToRefreshRecyclerView mPullToRefreshRecyclerView;
    protected int mOffset = 0;
    protected int mIndexPage = 1;
    public ShareDeviceAdapter mAdapter;
    public View mFragmentView;
    public MeariFriend mInfo;
    private EditText mAliasEdit;
    private View mHeadView;

    public static ShareFriendDeviceFragment newInstance(MeariFriend info) {
        ShareFriendDeviceFragment fragment = new ShareFriendDeviceFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("friendInfo", info);
        fragment.setArguments(bundle);
        return fragment;
    }

    @SuppressLint("InflateParams")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        mFragmentView = inflater.inflate(R.layout.fragment_friend_device, null);
        this.mInfo = (MeariFriend) getArguments().getSerializable("friendInfo");
        mAdapter = new ShareDeviceAdapter();
        initView(mFragmentView);
        return mFragmentView;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        requestFriendData();
        bindLoading();
    }

    public void initView(View v) {
        mHeadView = mFragmentView.findViewById(R.id.friends_info);
        this.mAliasEdit = mHeadView.findViewById(R.id.friendNickName_detail);
        mAliasEdit.clearFocus();
        mHeadView.findViewById(R.id.setting_alias_ok).setOnClickListener(this);
        TextView accountText = mHeadView.findViewById(R.id.useaccount_text);
        accountText.setText(this.mInfo.getAccountName());
        this.mAliasEdit.setText(this.mInfo.getNickName());
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
        mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<MeariSharedDevice>() {
            @Override
            public void onItemClick(BaseQuickAdapter<MeariSharedDevice, ? extends BaseViewHolder> adapter, View view, int position) {
                MeariSharedDevice info = mAdapter.getItem(position);
                shareDeviceToFriends(info);
            }
        });
        this.mAliasEdit.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() > 0) {
                    if (mAliasEdit.getText().toString().trim().equals(mInfo.getNickName())) {
                        mFragmentView.findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
                    } else {
                        mFragmentView.findViewById(R.id.setting_alias_ok).setVisibility(View.VISIBLE);
                    }
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        mAliasEdit.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    String nickNameText = mAliasEdit.getText().toString().trim();
                    mAliasEdit.setText(nickNameText);
                    changeNickname();
                }
                return false;
            }
        });
        mAliasEdit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mAliasEdit.requestFocus();
                mAliasEdit.setFocusable(true);
                String s = mAliasEdit.getText().toString();
                if (s.length() > 0) {
                    if (mAliasEdit.getText().toString().trim().equals(mInfo.getNickName())) {
                        mFragmentView.findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
                    } else {
                        mFragmentView.findViewById(R.id.setting_alias_ok).setVisibility(View.VISIBLE);
                    }
                }
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
        requestFriendData();
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
    public void requestFriendData() {
        // 检查网络是否可用
        if (!NetUtil.isNetworkAvailable()) {
            bindError(getString(R.string.network_unavailable));
            return;
        }
        MeariUser.getInstance().queryDeviceListForFriend(DeviceType.IPC, mInfo.getUserFriendID(), new IQueryDeviceListForFriendCallback() {
            @Override
            public void onError(int code, String error) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                CommonUtils.showToast(error);
            }

            @Override
            public void onSuccess(List<MeariSharedDevice> list) {
                mPullToRefreshRecyclerView.onRefreshComplete();
                bindOrderList(list);
            }

        });
//        params = new OKHttpRequestParams();
//        params.put("userIDS", String.valueOf(mInfo.getUserFriendID()));
//        OkGo.post(Preference.BASE_URL_DEFAULT + API_PPSTRONG_ININT_DETAILFRIENDS)
//                .params(params.getParams())
//                .headers(CommonUtils.getOKHttpHeader(getContext(), API_PPSTRONG_ININT_DETAILFRIENDS))
//                .id(0)
//                .execute(new StringCallback(this));
    }

    @Override
    protected RecyclerView getListView() {
        RecyclerView listView = mPullToRefreshRecyclerView.getRefreshableView();
        listView.setLayoutManager(new GridLayoutManager(getActivity(), 2));
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
            case R.id.setting_alias_ok:
                String nickNameText = mAliasEdit.getText().toString().trim();
                mAliasEdit.setText(nickNameText);
                changeNickname();
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
    }

    @Override
    protected void setRefreshHint() {
        super.setRefreshHint();
        if (mPullToRefreshRecyclerView != null) {
            setRefreshHint(mPullToRefreshRecyclerView);
            setLoadHints(mPullToRefreshRecyclerView);
        }
    }


    private void bindOrderList(List<MeariSharedDevice> list) {

        if (list != null && list.size() > 0) {
            mAdapter.getData().clear();
            mAdapter.setNewData(list);
        } else {
            bindEmpty();
            return;
        }
        mAdapter.notifyDataSetChanged();
    }

    public void changeNickname() {
        mFragmentView.findViewById(R.id.nickname_rv).requestFocus();
        String nickNameText = this.mAliasEdit.getText().toString().trim();
        if (!nickNameText.isEmpty() && !EmojiFilter.isNormalString(nickNameText)) {
            CommonUtils.showToast(R.string.name_format_error);
            return;
        }
        if (nickNameText.isEmpty()) {
            CommonUtils.showToast(getString(R.string.nicknameIsNull));
            return;
        }
        if (!nickNameText.isEmpty()) {
            if (!nickNameText.equals(mInfo.getNickName())) {
                CommonUtils.hideKeyBoard(getActivity());
                startProgressDialog(getString(R.string.pps_waite));
                MeariUser.getInstance().renameFriendMark(mInfo.getUserFriendID(), nickNameText, new IResultCallback() {
                    @Override
                    public void onSuccess() {
                        CommonUtils.showToast(R.string.setting_successfully);
                        mInfo.setNickName(mAliasEdit.getText().toString().trim());
                        stopProgressDialog();
                    }

                    @Override
                    public void onError(int code, String error) {
                        stopProgressDialog();
                        CommonUtils.showToast(error);
                    }
                });
            }
        } else {
            CommonUtils.showToast(R.string.niname_unchanged);
        }
    }


    public void shareDeviceToFriends(MeariSharedDevice friendDetailDTO) {
        boolean shareFlag = false;
        if (friendDetailDTO.isShared()) {
            shareFlag = false;
        } else {
            shareFlag = true;
        }
        if (shareFlag) {
            startProgressDialog(getString(R.string.share_device));
        } else {
            startProgressDialog(getString(R.string.share_device_cancel));
        }

        if (shareFlag)
            MeariUser.getInstance().addShareUserForDev(1, mInfo.getUserFriendID(), friendDetailDTO.getDeviceUUID(), friendDetailDTO.getDeviceID()+"", new IShareForDevCallback() {
                @Override
                public void onSuccess(String userId, String devId) {
                    stopProgressDialog();
                    mAdapter.changeDateFriendDetail(devId, true);
                    mAdapter.notifyDataSetChanged();
                    CommonUtils.showToast(R.string.share_success);
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                }



            });
        else {
            MeariUser.getInstance().removeShareUserForDev(1, mInfo.getUserFriendID(), friendDetailDTO.getDeviceUUID(), friendDetailDTO.getDeviceID()+"", new IShareForDevCallback() {
                @Override
                public void onSuccess(String userId, String devId) {
                    mAdapter.changeDateFriendDetail(devId, false);
                    mAdapter.notifyDataSetChanged();
                    CommonUtils.showToast(R.string.cancel_share_success);
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                }

            });
        }


    }
}

