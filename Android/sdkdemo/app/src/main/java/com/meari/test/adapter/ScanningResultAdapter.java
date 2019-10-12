package com.meari.test.adapter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.facebook.drawee.drawable.ScalingUtils;
import com.meari.sdk.bean.CameraInfo;
import com.meari.test.R;
import com.meari.test.SearchCameraResultActivity;
import com.meari.test.common.UtilsSharedPreference;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.CameraAddHolder;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/3
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ScanningResultAdapter extends BaseQuickAdapter<CameraInfo, CameraAddHolder> {
    private Context context;
    private UtilsSharedPreference utilsSharedPreference;
    private SearchCameraResultActivity ScanningCameraResultActivity;

    public ScanningResultAdapter(Context context, SearchCameraResultActivity ScanningCameraResultActivity) {
        super(R.layout.itemn_scan_camera);
        this.context = context;
        this.utilsSharedPreference = new UtilsSharedPreference(context);
        this.ScanningCameraResultActivity = ScanningCameraResultActivity;
    }

    @Override
    protected void convert(CameraAddHolder holder, CameraInfo cameraInfo) {
        holder.name_text.setText(cameraInfo.getDeviceName());
        if (cameraInfo.getAddStatus() == 1 || !cameraInfo.getUserAccount().isEmpty()) {
            if (cameraInfo.getAddStatus() == 1)
                holder.account_txt.setText(context.getString(R.string.my_camera));
            else {
                holder.account_txt.setText(cameraInfo.getUserAccount());
                if (cameraInfo.getUserAccount().equals("null"))
                    holder.account_txt.setText("--");
            }
        } else
            holder.account_txt.setText("--");
        switch (cameraInfo.getAddStatus()) {
            case 2:
                holder.device_img.getHierarchy().setFailureImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
                holder.device_img.getHierarchy().setPlaceholderImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
                holder.device_img.setImageURI(Uri.parse(cameraInfo.getDeviceIcon()));
                break;
            case 3:
                holder.device_img.getHierarchy().setFailureImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
                holder.device_img.getHierarchy().setPlaceholderImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
                holder.device_img.setImageURI(Uri.parse(cameraInfo.getDeviceIcon()));
                break;
            default:
                holder.device_img.getHierarchy().setFailureImage(R.mipmap.ic_default_n, ScalingUtils.ScaleType.FIT_XY);
                holder.device_img.getHierarchy().setPlaceholderImage(R.mipmap.ic_default_n, ScalingUtils.ScaleType.FIT_XY);
                holder.device_img.setImageURI(Uri.parse(cameraInfo.getDeviceIconGray()));
                break;
        }
        if (cameraInfo.getAddStatus() == 1) {
            holder.btn_add.setBackgroundResource(R.drawable.shape_rectangle_gray);
            holder.btn_add.setText(context.getString(R.string.addad));
            holder.btn_add.setEnabled(false);
        } else if (cameraInfo.getAddStatus() == 4) {
            holder.btn_add.setBackgroundResource(R.drawable.shape_rectangle_gray);
            holder.btn_add.setText(context.getString(R.string.shared));
            holder.btn_add.setEnabled(false);
        } else if (cameraInfo.getAddStatus() == 5) {
            holder.btn_add.setBackgroundResource(R.drawable.shape_rectangle_gray);
            holder.btn_add.setText(context.getString(R.string.shareing));
            holder.btn_add.setEnabled(false);
        } else if (cameraInfo.getAddStatus() == 2 || cameraInfo.getAddStatus() == 3) {
            holder.btn_add.setBackgroundResource(R.drawable.btn_common_big);
            holder.btn_add.setVisibility(View.VISIBLE);
            holder.btn_add.setEnabled(true);
            if (cameraInfo.getAddStatus() == 2) {

                holder.btn_add.setText(context.getString(R.string.unshare));
            } else
                holder.btn_add.setText(context.getString(R.string.unAdd));
        }
        holder.btn_add.setTag(cameraInfo);
        holder.btn_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CameraInfo cameraInfo = (CameraInfo) v.getTag();
                ScanningCameraResultActivity.dealDevice(cameraInfo);
            }
        });
        if (holder.getLayoutPosition() == 0)
            holder.getConvertView().findViewById(R.id.item_top_line).setVisibility(View.VISIBLE);
        else
            holder.getConvertView().findViewById(R.id.item_top_line).setVisibility(View.GONE);
    }

    public void setCameraInfosList(ArrayList<CameraInfo> list) {
        setNewData(list);
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

    public void addCameraData(int position, CameraInfo data) {
        if (!IsExists(data)) {
            mData.add(position, data);
            notifyItemInserted(position + getHeaderLayoutCount());
        }

    }

    private boolean IsExists(CameraInfo cameraInfo) {
        if (getData() == null || getData().size() == 0) {
            return false;
        }
        for (int i = 0; i < this.getData().size(); i++) {
            if (cameraInfo.getDeviceUUID().equals(this.getData().get(i).getDeviceUUID())) {
                return true;
            }
        }
        return false;
    }
}
