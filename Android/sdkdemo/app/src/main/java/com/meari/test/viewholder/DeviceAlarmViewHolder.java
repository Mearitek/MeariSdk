package com.meari.test.viewholder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.RoundingParams;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.DisplayUtil;

import butterknife.BindView;
import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/18
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class DeviceAlarmViewHolder extends BaseViewHolder {
    /**
     * 设备名称
     */
    @BindView(R.id.txtName)
    public TextView txtName;


    /**
     * 预览图
     */
    @BindView(R.id.preView)
    public SimpleDraweeView preView;

    /**
     * ItemView索引
     */
    @BindView(R.id.device_info_layout)
    public View device_info_layout;

    /**
     * 设备类型
     */
    @BindView(R.id.device_type_img)
    public SimpleDraweeView deviceTypeImg;
    /**
     * 显示图片区域
     */
    @BindView(R.id.device_layout)
    public View deviceLayout;
    /**
     * 勾选
     */
    @BindView(R.id.select_img)
    public ImageView select_img;

    public DeviceAlarmViewHolder(View view) {
        super(view);
        this.deviceTypeImg.getHierarchy().setFailureImage(R.mipmap.ic_preview_camrea, ScalingUtils.ScaleType.CENTER_INSIDE);
        this.preView.getHierarchy().setFailureImage(R.mipmap.home_slt_gray, ScalingUtils.ScaleType.FIT_XY);
        RoundingParams roundingParams = RoundingParams.fromCornersRadius(DisplayUtil.dip2px(view.getContext(), 10));
        this.preView.getHierarchy().setPlaceholderImage(R.mipmap.home_slt_gray, ScalingUtils.ScaleType.FIT_XY);
        this.preView.getHierarchy().setRoundingParams(roundingParams);
    }

}
