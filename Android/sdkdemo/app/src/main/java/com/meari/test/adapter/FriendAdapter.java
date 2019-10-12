package com.meari.test.adapter;

import android.net.Uri;
import android.view.View;

import com.meari.test.R;
import com.meari.test.bean.FriendInfo;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.utils.StringUtil;
import com.meari.test.viewholder.FriendHolder;

import org.json.JSONArray;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/9/14
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class FriendAdapter extends BaseQuickAdapter<FriendInfo, FriendHolder> {
    private boolean isEditStatus = false;

    public FriendAdapter() {
        super(R.layout.item_friend);
    }

    public void changAddData(int flag) {
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                getData().get(i).setFlag(flag);
            }
        }
    }

    public void cleaDelData() {
        ArrayList<FriendInfo> MeariFriends = new ArrayList<>();
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getFlag() != 1) {
                    MeariFriends.add(getData().get(i));
                }
            }
        }
        setNewData(MeariFriends);
    }

    @Override
    protected void convert(FriendHolder viewHolder, FriendInfo FriendInfo) {
        if (StringUtil.isNotNull(FriendInfo.getNickName())) {
            String nickName = FriendInfo.getNickName();
            viewHolder.nickNameFriend.setText(nickName);
        }
        if (StringUtil.isNotNull(FriendInfo.getAccountName())) {
            String accountNum = FriendInfo.getAccountName();
            viewHolder.accountNumFriend.setText(accountNum);
        }
        if (!isEditStatus) {
            viewHolder.selectImg.setVisibility(View.GONE);
            viewHolder.getConvertView().findViewById(R.id.rightArrowsImgId).setVisibility(View.VISIBLE);
        } else {
            viewHolder.getConvertView().findViewById(R.id.rightArrowsImgId).setVisibility(View.GONE);
            if (FriendInfo.getFlag() == 0) {
                viewHolder.selectImg.setVisibility(View.VISIBLE);
                viewHolder.selectImg.setImageResource(R.mipmap.ic_message_select_n);
            } else {
                viewHolder.selectImg.setVisibility(View.VISIBLE);
                viewHolder.selectImg.setImageResource(R.mipmap.ic_message_select_p);
            }
        }
        viewHolder.headIcon.setImageURI(Uri.parse(FriendInfo.getImageUrl()));
    }

    public boolean isEditStatus() {
        return isEditStatus;
    }

    public void setEditStaus(boolean editStaus) {
        isEditStatus = editStaus;
    }


    public String getSelectAllMeariFriends() {
        JSONArray listDTO = null;
        if (getData() != null && getData().size() > 0) {
            listDTO = new JSONArray();
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getFlag() == 1) {
                    listDTO.put(getData().get(i).getUserFriendID());
                }
            }
        }
        return listDTO.toString();
    }
}
