package com.meari.test.viewholder;

import android.view.View;
import android.widget.TextView;

import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;

import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/19
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ScanNvrViewHolder extends BaseViewHolder {
    /**
     * camera名称
     */
    @BindView(R.id.scan_camera_name)
    public TextView txtViewCameraName;
    /**
     * camera 类型
     */
    @BindView(R.id.scan_camera_type)
    public TextView txtViewCameraType;
    /**
     * 列表右侧图标
     */
    @BindView(R.id.add_cameraclick)
    public TextView imgViewAddCamera;
    @BindView(R.id.device_img)
    public SimpleDraweeView device_img;

    public ScanNvrViewHolder(View view) {
        super(view);
    }
}
