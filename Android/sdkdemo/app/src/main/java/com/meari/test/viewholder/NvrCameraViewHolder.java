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
 * 创建日期：2017/5/17
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class NvrCameraViewHolder extends BaseViewHolder {
    @BindView(R.id.device_img)
    public SimpleDraweeView imageView;
    @BindView(R.id.scan_camera_name)
    public TextView textView;
    @BindView(R.id.add_cameraclick)
    public TextView add_cameraclick;

    public NvrCameraViewHolder(View view) {
        super(view);
    }
}
