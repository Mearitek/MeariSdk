package com.meari.test.adapter;

import android.net.Uri;
import android.view.View;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.NvrDeviceStatusInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.NVRCameraMangerFragment;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.NvrCameraHolder;

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

public class NVRCameraMangerAdapter extends BaseQuickAdapter<NvrDeviceStatusInfo,NvrCameraHolder> {


    private NVRCameraMangerFragment mFragment;
    private boolean bEditStatus;
    private UserInfo mUserInfo;
    public NVRCameraMangerAdapter( NVRCameraMangerFragment fragment) {
        super(R.layout.item_nvr_camera);
        this.mFragment = fragment;
        mUserInfo = MeariUser.getInstance().getUserInfo();
    }

    @Override
    public NvrDeviceStatusInfo getItem(int position) {
        return getData().get(position);
    }

    @Override
    protected void convert(NvrCameraHolder holder, NvrDeviceStatusInfo item) {
        int position = holder.getLayoutPosition();
        NvrDeviceStatusInfo info = getData().get(position);
        holder.txtViewCameraName.setText(info.getSnNum());
        if (info.getUserAccount().equals(MeariUser.getInstance().getUserInfo().getUserAccount())) {
            holder.txtViewCameraType.setText(mContext.getString(R.string.my_camera));
        } else {
            holder.txtViewCameraType.setText(info.getUserAccount());
            if (info.getUserAccount().equals("null"))
                holder.txtViewCameraType.setText("--");
        }

        holder.imgViewAddCamera.setVisibility(View.GONE);
        if (position == 0) {
            holder.getConvertView().findViewById(R.id.top_line).setVisibility(View.VISIBLE);
        } else
            holder.getConvertView().findViewById(R.id.top_line).setVisibility(View.GONE);

        holder.device_img.setImageURI(Uri.parse(info.getDeviceIcon()));
        holder.imgViewAddCamera.setTag(info);
        if (bEditStatus) {
            holder.device_img.setVisibility(View.GONE);
            holder.select_img.setVisibility(View.VISIBLE);
            if (info.getDelMsgFlag() == 1) {
                holder.select_img.setImageResource(R.mipmap.ic_select_n);
            } else {
                holder.select_img.setImageResource(R.mipmap.ic_img_slect_all);
            }
        } else {
            holder.device_img.setVisibility(View.VISIBLE);
            holder.select_img.setVisibility(View.GONE);
        }
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    public void setEditStatus(boolean bEditStatus) {
        this.bEditStatus = bEditStatus;
    }

    public boolean getEditStatus() {
        return this.bEditStatus;
    }

    // 1 代表 删除 0 选择
    public void changAddDataDeviceMsg(int flag) {
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                getData().get(i).setDelMsgFlag(flag);
            }
        }
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

    public ArrayList<String> getSelectId() {
        ArrayList<String> deviceList = new ArrayList<>();
        for (int i = 0; i < getDataCount(); i++) {
            if (getData().get(i).getDelMsgFlag() == 2) {
                deviceList.add(getData().get(i).getDeviceID());
            }
        }
        return deviceList;
    }

    public void changStatusByIds(String[] ids) {
        for (String id: ids)
        {
            for (NvrDeviceStatusInfo info :getData())
            {
                if (info.getDeviceID() .equals(id) )
                {
                    mFragment.addUnbindInfo(info);
                    getData().remove(info);
                    break;
                }
            }
        }
    }
}

