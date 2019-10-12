package com.meari.test.adapter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.ShareFriendInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.R;
import com.meari.test.ShareDeviceFragment;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.ShareDeviceHolder;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ShareDeviceFriendAdapter extends BaseQuickAdapter<ShareFriendInfo, ShareDeviceHolder> {
    private ShareDeviceFragment mShareFragment;
    private UserInfo mUserInfo;

    public ShareDeviceFriendAdapter(Context context, ShareDeviceFragment shareFragment) {
        super(R.layout.item_sharefriend);
        this.mShareFragment = shareFragment;
        mUserInfo = MeariUser.getInstance().getUserInfo();
    }


    public void changeDateByUserId(String users, boolean bshare) {
        if (getData() == null || getData().size() == 0) {
            return;
        }
        for (ShareFriendInfo info : getData()) {
            if (users.equals(info.getUserId())) {
                info.setShare(bshare);
            }
        }
    }

    @Override
    protected void convert(ShareDeviceHolder viewHoler, ShareFriendInfo item) {
        int position = viewHoler.getLayoutPosition();
        ShareFriendInfo info = getData().get(position);
        viewHoler.headIcon.setImageURI(Uri.parse(info.getImageUrl()));
        viewHoler.userNickname.setText(info.getNickName());
        viewHoler.account_text.setText(info.getUserAccount());
        if (info.isShare())
            viewHoler.shareCheck.setImageResource(R.mipmap.ic_message_select_p);
        else
            viewHoler.shareCheck.setImageResource(R.mipmap.ic_message_select_n);
        viewHoler.shareCheck.setTag(position);
        viewHoler.shareCheck.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int position = (int) v.getTag();
                ShareFriendInfo info = getData().get(position);
                mShareFragment.shareDeviceToFriends(info);
            }
        });
        if (position != 0) {
            viewHoler.getConvertView().findViewById(R.id.ivIsStar).setVisibility(View.GONE);
        } else
            viewHoler.getConvertView().findViewById(R.id.ivIsStar).setVisibility(View.VISIBLE);

    }
}

