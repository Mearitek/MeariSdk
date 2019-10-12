package com.meari.test.adapter;

import android.content.Context;

import com.meari.test.R;
import com.meari.test.bean.DeviceTypeInfo;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.DeviceTypeViewHolder;


/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/7/19
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class DeviceTypeAdapter extends BaseQuickAdapter<DeviceTypeInfo, DeviceTypeViewHolder> {
    public DeviceTypeAdapter(Context context) {
        super(R.layout.item_comom_device);
        mContext = context;

    }

    @Override
    protected void convert(DeviceTypeViewHolder viewHold, DeviceTypeInfo armingInfo) {
        viewHold.nameText.setText(armingInfo.getDeviceName());
        viewHold.device_img.setImageResource(armingInfo.getDeviceImageId());
    }
}


