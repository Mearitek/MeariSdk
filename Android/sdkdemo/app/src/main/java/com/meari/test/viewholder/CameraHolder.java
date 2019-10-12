package com.meari.test.viewholder;

import android.content.Context;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.RoundingParams;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.DisplayUtil;

import butterknife.BindView;
import butterknife.ButterKnife;


/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/27
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class CameraHolder extends BaseViewHolder {
    /**
     * 设备名称
     */
    @Nullable
    @BindView(R.id.txtName)
    public TextView txtName;

    /**
     * 点击进入视频播放按钮
     */
    @BindView(R.id.btn_setting)
    public ImageView btn_setting;
    /**
     * 点击播放或加载视频的按钮
     */
    @BindView(R.id.img_Btn_state)
    public ImageView imgViewState;

    /**
     * 预览图
     */
    @BindView(R.id.preView)
    public SimpleDraweeView preView;

    /**
     * ItemView索引
     */
    @BindView(R.id.img_rotate_state)
    public ImageView img_rotate_state;
    @BindView(R.id.loading_dialog_img)
    public ProgressBar loadImage;
    @BindView(R.id.status_layout)
    public View status_layout;
    @BindView(R.id.image_message)
    public ImageView btn_message;
    @BindView(R.id.device_type_img)
    public SimpleDraweeView deviceTypeImg;
    @BindView(R.id.pps_device_layout)
    public View deviceLayout;
    @BindView(R.id.nvr_nickname)
    public TextView nvr_name_text;
    @BindView(R.id.layout_nvr_info)
    public View layout_nvr;
    @BindView(R.id.nvr_img)
    public SimpleDraweeView nvrImg;

    public CameraHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);
        Context context = view.getContext();
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) this.deviceLayout.getLayoutParams();
        params.height = ((DisplayUtil.getDisplayPxWidth(context) - DisplayUtil.dpToPx(context, 24)) * 9 / 16);
        RoundingParams roundingParams = RoundingParams.fromCornersRadius(DisplayUtil.dip2px(context, 5));
        this.preView.getHierarchy().setRoundingParams(roundingParams);
        this.preView.getHierarchy(). setPlaceholderImage(R.mipmap.home_slt_gray, ScalingUtils.ScaleType.FIT_XY);
        this.deviceLayout.setLayoutParams(params);
        this.deviceTypeImg.getHierarchy().setFailureImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
        this.deviceTypeImg.getHierarchy().setPlaceholderImage(R.mipmap.ic_default_ipc, ScalingUtils.ScaleType.FIT_XY);
        this.nvrImg.getHierarchy().setFailureImage(R.mipmap.ic_nvr_version, ScalingUtils.ScaleType.FIT_XY);
        this.nvrImg.getHierarchy().setPlaceholderImage(R.mipmap.ic_nvr_version, ScalingUtils.ScaleType.FIT_XY);
    }

}
