package com.meari.test.adapter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.AddNvrResultActivity;
import com.meari.test.R;
import com.meari.test.common.UtilsSharedPreference;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.ScanNvrViewHolder;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/19
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ScanningNVRResultAdapter extends BaseQuickAdapter<NVRInfo,ScanNvrViewHolder> {
    private Context context;
    private UtilsSharedPreference utilsShaedPreference;
    private AddNvrResultActivity mAddNvrResultActivity;
    private UserInfo mUserInfo;

    public ScanningNVRResultAdapter(Context context, AddNvrResultActivity AddNvrResultActivity) {
        super(R.layout.item_scan_nvr);
        this.context = context;
        this.utilsShaedPreference = new UtilsSharedPreference(context);
        this.mAddNvrResultActivity = AddNvrResultActivity;
        mUserInfo = MeariUser.getInstance().getUserInfo();
    }


    @Override
    public NVRInfo getItem(int position) {
        return getData().get(position);
    }

    @Override
    protected void convert(ScanNvrViewHolder holder, NVRInfo info) {
        int position = holder.getLayoutPosition();
        holder.txtViewCameraName.setText(info.getSnNum());
        if (info.getAddStatus() == 1 || !info.getUserAccount().isEmpty()) {
            if (info.getAddStatus() == 1) {
                holder.txtViewCameraType.setText(context.getString(R.string.my_nvr));
            } else {
                holder.txtViewCameraType.setText(info.getUserAccount());
                if (info.getUserAccount().equals("null"))
                    holder.txtViewCameraType.setText("--");
            }
        } else
            holder.txtViewCameraType.setText("--");

        if (info.getAddStatus() == 1) {
            holder.imgViewAddCamera.setBackgroundResource(R.drawable.shape_rectangle_gray);
            holder.imgViewAddCamera.setText(context.getString(R.string.addad));
            holder.imgViewAddCamera.setEnabled(false);
        } else if (info.getAddStatus() == 4) {
            holder.imgViewAddCamera.setBackgroundResource(R.drawable.shape_rectangle_gray);
            holder.imgViewAddCamera.setText(context.getString(R.string.shared));
            holder.imgViewAddCamera.setEnabled(false);
        } else if (info.getAddStatus() == 5) {
            holder.imgViewAddCamera.setBackgroundResource(R.drawable.shape_rectangle_gray);
            holder.imgViewAddCamera.setText(context.getString(R.string.shareing));
            holder.imgViewAddCamera.setEnabled(false);
        } else if (info.getAddStatus() == 2 || info.getAddStatus() == 3) {
            holder.imgViewAddCamera.setBackgroundResource(R.drawable.btn_common_big);
            holder.imgViewAddCamera.setVisibility(View.VISIBLE);
            if (info.getAddStatus() == 2) {

                holder.imgViewAddCamera.setText(context.getString(R.string.unshare));
            } else
                holder.imgViewAddCamera.setText(context.getString(R.string.unAdd));

        }
        if (info.getAddStatus() == 3 || info.getAddStatus() == 1) {
            holder.imgViewAddCamera.setVisibility(View.VISIBLE);
        } else {
            holder.imgViewAddCamera.setVisibility(View.GONE);
        }
        if (position == 0) {
            holder.getConvertView().findViewById(R.id.top_line).setVisibility(View.VISIBLE);
        } else
            holder.getConvertView().findViewById(R.id.top_line).setVisibility(View.GONE);
        if (info.getAddStatus() == 3) {
            holder.device_img.setImageURI(Uri.parse(info.getNvrTypeName()));
        } else
            holder.device_img.setImageURI(Uri.parse(info.getNvrTypeNameGray()));
        holder.imgViewAddCamera.setTag(info);
        holder.imgViewAddCamera.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NVRInfo info = (NVRInfo) v.getTag();
                mAddNvrResultActivity.dealDevice(info);
            }
        });
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    public void setNVRInfosList(ArrayList<NVRInfo> list) {
        this.getData().clear();
        this.getData().addAll(list);
    }

    public void setStatus(String uuid, int status) {
        if (getData() == null)
            return;
        for (int i = 0; i < getData().size(); i++) {
            if (getData().get(i).getSnNum().equals(uuid)) {
                getData().get(i).setAddStatus(status);
                notifyDataSetChanged();
                return;
            }
        }

    }

    public void setStatusBySn(String sn, int status) {
        if (getData() == null)
            return;
        for (int i = 0; i < getData().size(); i++) {
            if (getData().get(i).getSnNum().equals(sn)) {
                getData().get(i).setAddStatus(status);
                notifyDataSetChanged();
                return;
            }
        }

    }

    class ScanningResultHolder {

    }

    /**
     * 设置列表项中 事件 的接口()
     */
    public interface OnImgViewAddCameraClick {
        void onItemClick(NVRInfo NVRInfo);
    }

    private OnImgViewAddCameraClick onImgViewAddCameraClick;

    public void setOnWifiInfoItemClick(OnImgViewAddCameraClick onImgViewAddCameraClick) {
        this.onImgViewAddCameraClick = onImgViewAddCameraClick;
    }
}
