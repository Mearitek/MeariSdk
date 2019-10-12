package com.meari.test.viewholder;

import android.view.View;
import android.widget.TextView;

import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/3
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class CameraAddHolder extends BaseViewHolder {
    /**
     * camera名称
     */
    @BindView(R.id.scan_camera_name)
    public TextView name_text;
    /**
     * camera 类型
     */
    @BindView(R.id.scan_camera_type)
    public TextView account_txt;
    /**
     * 列表右侧图标
     */
    @BindView(R.id.add_cameraclick)
    public  TextView btn_add;
    @BindView(R.id.device_img)
    public SimpleDraweeView device_img;

    public CameraAddHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);
    }
}