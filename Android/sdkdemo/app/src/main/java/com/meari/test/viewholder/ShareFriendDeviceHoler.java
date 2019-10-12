package com.meari.test.viewholder;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.RoundingParams;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.test.common.Constant;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.DisplayUtil;

import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/9/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ShareFriendDeviceHoler extends BaseViewHolder {
    @BindView(R.id.head_img)
    public SimpleDraweeView headIcon;
    @BindView(R.id.account_text)
    public TextView userNickname;
    @BindView(R.id.share_btn)
    public ImageView shareCheck;

    public ShareFriendDeviceHoler(View view) {
        super(view);
        Context context = view.getContext();
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) this.headIcon.getLayoutParams();
        params.height = (Constant.width - DisplayUtil.dip2px(context,48))*9/32;
        this.headIcon.setLayoutParams(params);
        RoundingParams roundingParams = RoundingParams.fromCornersRadius(DisplayUtil.dip2px(context, 5));
        this.headIcon.getHierarchy().setRoundingParams(roundingParams);
        this.headIcon.getHierarchy(). setPlaceholderImage(R.mipmap.home_slt_gray, ScalingUtils.ScaleType.FIT_XY);
    }
}
