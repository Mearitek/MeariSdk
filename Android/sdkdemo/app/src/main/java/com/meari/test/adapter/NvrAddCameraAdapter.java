package com.meari.test.adapter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.NvrDeviceStatusInfo;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.AddNvrCameraActivity;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.NvrCameraViewHolder;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/17
 * 描    述：NVR添加Cameras适配器
 * 修订历史：
 * ================================================
 */

public class NvrAddCameraAdapter extends BaseQuickAdapter<NvrDeviceStatusInfo,NvrCameraViewHolder> {
    private UserInfo mUserInfo;
    public NvrAddCameraAdapter(Context context) {
        super(R.layout.item_add_camera);
        mUserInfo = MeariUser.getInstance().getUserInfo();
    }
    public void changeStatusById(String deviceID) {
        List<NvrDeviceStatusInfo> list = getData();
        for (NvrDeviceStatusInfo info : list) {
            if (info.getDeviceID() == deviceID) {
                info.setAddStatus(1);
                break;
            }
        }
        Collections.sort(list, new PPSComparator());
        notifyDataSetChanged();
    }

    public class PPSComparator implements Comparator<NvrDeviceStatusInfo> {

        @Override
        public int compare(NvrDeviceStatusInfo o1, NvrDeviceStatusInfo o2) {
            return o1.getAddStatus() - o2.getAddStatus();
        }

    }

    @Override
    public NvrDeviceStatusInfo getItem(int position) {
        return (getData() != null && getData().size() > position) ? getData().get(position) : null;
    }

    @Override
    protected void convert(NvrCameraViewHolder viewHolder, NvrDeviceStatusInfo info) {
        int position = viewHolder.getLayoutPosition();
        viewHolder.textView.setText(info.getDeviceName() + "(" + info.getSnNum() + ")");
        if (info.getAddStatus() == 0) {
            viewHolder.imageView.setImageURI(Uri.parse(info.getDeviceIcon()));
            viewHolder.add_cameraclick.setText(mContext.getString(R.string.unAdd));
            viewHolder.add_cameraclick.setBackgroundResource(R.drawable.btn_common_big);
        } else {
            viewHolder.imageView.setImageURI(Uri.parse(info.getDeviceIcon()));
            viewHolder.add_cameraclick.setText(mContext.getString(R.string.addad));
            viewHolder.add_cameraclick.setBackgroundResource(R.drawable.btn_add_device);
        }
        viewHolder.add_cameraclick.setTag(position);
        viewHolder.add_cameraclick.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int postion = (int) v.getTag();
                NvrDeviceStatusInfo info = getData().get(postion);
                if (info.getAddStatus() != 0)
                    return;
                if (mContext instanceof AddNvrCameraActivity) {
                    ((AddNvrCameraActivity) mContext).postDealCamera(info);
                }

            }
        });
    }
}
