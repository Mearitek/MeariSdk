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

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MsgHolderView extends BaseViewHolder {
    @BindView(R.id.select_img)
    public ImageView select_img;
    @BindView(R.id.btn_message_play)
    public ImageView btn_paly;
    @BindView(R.id.txt_time)
    public TextView text_time;
    @BindView(R.id.text_motion_type)
    public TextView text_motion_type;
    @BindView(R.id.img_pre)
    public SimpleDraweeView img_pre;
    @BindView(R.id.time_info_h)
    public View info_h;
    @BindView(R.id.line1)
    public ImageView line1;
    @BindView(R.id.line2)
    public ImageView line2;
    @BindView(R.id.line3)
    public ImageView line3;
    @BindView(R.id.text_type_v)
    public TextView text_type_v;
    @BindView(R.id.txt_time_v)
    public TextView txt_time_v;

    public MsgHolderView(View view) {
        super(view);
        this.img_pre.getHierarchy().setFailureImage(R.mipmap.img_meassage_default, ScalingUtils.ScaleType.FIT_XY);
        this.img_pre.getHierarchy().setPlaceholderImage(R.mipmap.img_meassage_default, ScalingUtils.ScaleType.FIT_XY);
        RoundingParams roundingParams = RoundingParams.fromCornersRadius(DisplayUtil.dip2px(view.getContext(), 10));
        this.img_pre.getHierarchy().setRoundingParams(roundingParams);
    }
}
