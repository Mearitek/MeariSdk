package com.meari.test.adapter;

import android.content.Context;
import android.graphics.Color;
import android.net.Uri;
import android.view.View;
import android.widget.RelativeLayout;

import com.meari.sdk.bean.DeviceMessageStatus;
import com.meari.test.R;
import com.meari.test.common.Constant;
import com.meari.test.fragment.MessageSquareFragment;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.viewholder.DeviceAlarmViewHolder;

import java.util.ArrayList;
import java.util.List;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/18
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MessageAdapter extends BaseQuickAdapter<DeviceMessageStatus, DeviceAlarmViewHolder> {
    private boolean bEditStatus;
    private MessageSquareFragment mfragment;

    public MessageAdapter(Context context) {
        super(R.layout.item_square_message);
    }


    public void setFragment(MessageSquareFragment fragment) {
        this.mfragment = fragment;
    }

    @Override
    protected void convert(DeviceAlarmViewHolder holder, DeviceMessageStatus item) {
        int position = holder.getLayoutPosition();
        DeviceMessageStatus info = getData().get(position);
        holder.txtName.setText(info.getDeviceName());
        if (info.getHasMessageFlag().equals("N")) {
            holder.txtName.setTextColor(Color.parseColor("#333333"));
        } else
            holder.txtName.setTextColor(Color.parseColor("#f44336"));
        holder.deviceTypeImg.setImageURI(Uri.parse(info.getDeviceIcon()));
        String snPathString = Constant.DOCUMENT_CACHE_PATH + info.getSnNum() + ".jpg";
        holder.preView.setImageURI(Uri.parse("file://" + snPathString));
        RelativeLayout.LayoutParams textparams = (RelativeLayout.LayoutParams) holder.txtName.getLayoutParams();
        if (isEditStatus()) {
            holder.getConvertView().findViewById(R.id.select_layout).setVisibility(View.VISIBLE);
            holder.deviceTypeImg.setVisibility(View.GONE);
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) holder.deviceLayout.getLayoutParams();
            params.height = ((DisplayUtil.getDisplayPxWidth(mContext) - DisplayUtil.dpToPx(mContext, 102)) * 9 / 16);
            params.leftMargin = 0;
            params.rightMargin = DisplayUtil.dpToPx(mContext, 28);
            holder.deviceLayout.setLayoutParams(params);
            textparams.leftMargin = DisplayUtil.dpToPx(mContext, 70);
            if (info.getDelMsgFlag() == 1) {
                holder.select_img.setImageResource(R.mipmap.ic_select_n);
            } else {
                holder.select_img.setImageResource(R.mipmap.icon_select_p);
            }
            holder.select_img.setVisibility(View.VISIBLE);
        } else {
            textparams.leftMargin = DisplayUtil.dpToPx(mContext, 5);
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) holder.deviceLayout.getLayoutParams();
            params.height = ((DisplayUtil.getDisplayPxWidth(mContext) - DisplayUtil.dpToPx(mContext, 24)) * 9 / 16);
            params.leftMargin = DisplayUtil.dpToPx(mContext, 12);
            params.rightMargin = DisplayUtil.dpToPx(mContext, 12);
            holder.deviceLayout.setLayoutParams(params);
            holder.getConvertView().findViewById(R.id.select_layout).setVisibility(View.GONE);
            holder.deviceTypeImg.setVisibility(View.VISIBLE);
            holder.select_img.setVisibility(View.GONE);
        }
        holder.txtName.setLayoutParams(textparams);
    }

    private boolean isSelectAll() {
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getDelMsgFlag() != 2) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * all select
     **/
    public boolean isAllSelect() {
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getDelMsgFlag() == 1) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * nothing select
     **/
    public boolean isNothingSelect() {
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getDelMsgFlag() == 2) {
                    return false;
                }
            }
        }
        return true;
    }

    // 1 代表 删除 0 选择
    public void changAddDataDeviceMsg(int flag) {
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                getData().get(i).setDelMsgFlag(flag);
            }
        }
    }

    public void changeFriendData() {
        if (getData() != null && getData().size() > 0) {
            List<DeviceMessageStatus> friendDTOs = new ArrayList<>();
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getDelMsgFlag() != 2) {
                    friendDTOs.add(getData().get(i));
                }
            }
            getData().clear();
            getData().addAll(friendDTOs);
        }
    }

    public boolean isEditStatus() {
        return bEditStatus;
    }

    public void setEditStatus(boolean bEditStatus) {
        this.bEditStatus = bEditStatus;
    }
}

