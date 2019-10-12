package com.meari.test.viewholder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;

import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/7/19
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class DeviceTypeViewHolder extends BaseViewHolder {
    /**
     * camera名称
     */
    @BindView(R.id.name)
    public TextView nameText;
    @BindView(R.id.device_img)
    public ImageView device_img;

    public DeviceTypeViewHolder(View view) {
        super(view);
    }
}
