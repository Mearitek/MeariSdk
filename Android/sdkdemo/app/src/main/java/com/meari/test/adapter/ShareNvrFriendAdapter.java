package com.meari.test.adapter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.ShareFriendInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.R;
import com.meari.test.fragment.ShareNvrFragment;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.NvrShareViewHolder;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/17
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ShareNvrFriendAdapter extends BaseQuickAdapter<ShareFriendInfo,NvrShareViewHolder> {
    private ShareNvrFragment mShareFragment;
    private UserInfo mUserInfo;

    public ShareNvrFriendAdapter(Context context, ShareNvrFragment shareFragment) {
        super(R.layout.item_sharefriend);
        this.mShareFragment = shareFragment;
        mUserInfo = MeariUser.getInstance().getUserInfo();
    }
    public void changeDateByUserId(String users, boolean bshare) {
        if (getData() == null || getData().size() == 0) {
            return;
        }
        for (ShareFriendInfo info : getData()) {
            if (info.getUserId() != null && !info.getUserId().isEmpty()) {
                info.setShare(bshare);
            }
        }
    }

    @Override
    protected void convert(NvrShareViewHolder viewHoler, ShareFriendInfo item) {
        int position = viewHoler.getLayoutPosition();
        ShareFriendInfo info = getData().get(position);
        viewHoler.headIcon.setImageURI(Uri.parse(info.getImageUrl()));
        viewHoler.userNickname.setText(info.getNickName());
        viewHoler.account_text.setText(info.getUserAccount());
        if (info.isShare())
            viewHoler.shareCheck.setImageResource(R.mipmap.ic_message_select_n);
        else
            viewHoler.shareCheck.setImageResource(R.mipmap.ic_message_select_p);
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


