package com.meari.test.adapter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.SystemMessage;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.MessageSysViewHolder;

import org.json.JSONArray;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/18
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MessageSysAdapter extends BaseQuickAdapter<SystemMessage, MessageSysViewHolder> {
    private boolean isEditStaus;
    private UserInfo mUseInfo;

    public MessageSysAdapter(Context context) {
        super(R.layout.item_message_sys);
        this.mUseInfo = MeariUser.getInstance().getUserInfo();
    }

    @Override
    protected void convert(MessageSysViewHolder viewHolder, SystemMessage item) {
        int position = viewHolder.getLayoutPosition();
        SystemMessage messgeInfo = getData().get(position);
        if (!messgeInfo.getNickName().isEmpty() && !messgeInfo.getUserAccount().isEmpty()) {
            String userAccount = messgeInfo.getUserAccount();
            String nickName = messgeInfo.getNickName();
            viewHolder.user_text.setText(nickName + "(" + userAccount + ")");
        }
        if (messgeInfo.getMsgTypeID() == 1) {
            viewHolder.content_text.setText(R.string.addFriendDes);
        } else if (messgeInfo.getMsgTypeID() == 4) {
            viewHolder.content_text.setText(R.string.agreeFriendDes);
            viewHolder.arrow_img.setVisibility(View.GONE);
        } else if (messgeInfo.getMsgTypeID() == 5) {
            viewHolder.content_text.setText(R.string.cancelFriendDes);
            viewHolder.arrow_img.setVisibility(View.GONE);
        } else if (messgeInfo.getMsgTypeID() == 2) {
            if (!messgeInfo.getDeviceUUID().isEmpty()) {
                viewHolder.content_text.setText(mContext.getString(R.string.addDeviceDes) + "(" + messgeInfo.getDeviceName() + ").");
            }
        } else if (messgeInfo.getMsgTypeID() == 6) {
            if (!messgeInfo.getDeviceUUID().isEmpty()) {
                viewHolder.content_text
                        .setText(mContext.getString(R.string.agreeDeviceDes) + "(" + messgeInfo.getDeviceName() + ").");
            }
            viewHolder.arrow_img.setVisibility(View.GONE);
        } else if (messgeInfo.getMsgTypeID() == 11) {
            //低电量报警推送
            viewHolder.user_text.setText(messgeInfo.getDeviceName());
            if (!messgeInfo.getDeviceUUID().isEmpty()) {
                viewHolder.content_text
                        .setText(mContext.getString(R.string.str_lowPowerAlarm));
            }
            viewHolder.arrow_img.setVisibility(View.GONE);
        } else {
            if (!messgeInfo.getDeviceUUID().isEmpty()) {
                viewHolder.content_text
                        .setText(mContext.getString(R.string.cancelDeviceDes) + "(" + messgeInfo.getDeviceName() + ").");
            }
            viewHolder.arrow_img.setVisibility(View.GONE);
        }
        viewHolder.head_img.setImageURI(Uri.parse(messgeInfo.getImageUrl()));
        if (messgeInfo.getDelNum() == 0) {
            viewHolder.select_img.setVisibility(View.GONE);
            if (messgeInfo.getMsgTypeID() == 1 || messgeInfo.getMsgTypeID() == 2) {
                viewHolder.arrow_img.setVisibility(View.VISIBLE);
            } else {
                viewHolder.arrow_img.setVisibility(View.GONE);
            }
        } else {
            viewHolder.select_img.setVisibility(View.VISIBLE);
            if (messgeInfo.getDelNum() == 1) {
                viewHolder.arrow_img.setVisibility(View.GONE);
                viewHolder.select_img.setImageResource(R.mipmap.ic_select_n);
            } else {
                viewHolder.arrow_img.setVisibility(View.GONE);
                viewHolder.select_img.setImageResource(R.mipmap.icon_select_p);
            }

        }
        if (isEditStaus) {
            viewHolder.select_img.setVisibility(View.VISIBLE);
            viewHolder.arrow_img.setVisibility(View.GONE);
            viewHolder.head_img.setVisibility(View.GONE);
            viewHolder.select_img.setVisibility(View.VISIBLE);
        } else {
            viewHolder.select_img.setVisibility(View.VISIBLE);
            viewHolder.head_img.setVisibility(View.VISIBLE);
            viewHolder.select_img.setVisibility(View.GONE);
        }
        if (position == getDataCount() - 1) {
            viewHolder.getConvertView().findViewById(R.id.bottom_line).setVisibility(View.VISIBLE);
        } else {
            viewHolder.getConvertView().findViewById(R.id.bottom_line).setVisibility(View.GONE);
        }
    }

    class ViewHolder {

    }

    public boolean isSelectAll() {
        for (int i = 0; i < getDataCount(); i++) {
            if (getData().get(i).getDelNum() == 1 || getData().get(i).getDelNum() == 0) {
                return false;
            }
        }
        return true;
    }

    public ArrayList<Long> getSelectAllMsgDTOList() {
        ArrayList<Long> alertMsgIDDel = new ArrayList<Long>();
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getDelNum() == 2) {
                    alertMsgIDDel.add(getData().get(i).getMsgID());
                }
            }
        }
        return alertMsgIDDel;
    }

    public void changeStatus(int flag) {
        for (SystemMessage info : getData()) {
            info.setDelNum(flag);
        }
        notifyDataSetChanged();
    }

    public boolean isEditStaus() {
        return isEditStaus;
    }

    public void clearDelData() {
        ArrayList<SystemMessage> arrayList = new ArrayList<SystemMessage>();
        for (SystemMessage ppsAlarmMessageInfo : getData()) {
            if (ppsAlarmMessageInfo.getDelNum() != 2) {
                arrayList.add(ppsAlarmMessageInfo);
            }
        }
        getData().clear();
        setNewData(arrayList);
    }

    public void setEditStaus(boolean isEditStaus) {
        this.isEditStaus = isEditStaus;
    }

    /*
     * 获取选中的朋友消息id
     */
    public JSONArray selectDeleteMsg() {
        JSONArray listDTO = null;
        if (getData() != null && getData().size() > 0) {
            listDTO = new JSONArray();
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getDelNum() == 2) {
                    listDTO.put(getData().get(i).getMsgID());
                }
            }
        }
        return listDTO;
    }  /*
     * 获取选中的朋友消息id
     */
    public ArrayList<Long> selectDeleteMsgIds() {
        ArrayList<Long> list = new ArrayList<>();
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getDelNum() == 2) {
                    list.add(getData().get(i).getMsgID());
                }
            }
        }
        return list;
    }

    public void changeDelDate(long msgID) {
        ArrayList<SystemMessage> list = new ArrayList<>();
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getMsgID() != msgID) {
                    list.add(getData().get(i));
                }
            }
        }
        setNewData(list);
    }
}

