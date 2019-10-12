package com.meari.test.viewholder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.RoundingParams;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;

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

public class ShareDeviceHolder extends BaseViewHolder {
    @BindView(R.id.head_img)
    public SimpleDraweeView headIcon;
    @BindView(R.id.nickname_text)
    public TextView userNickname;
    @BindView(R.id.rightArrowsImgId)
    public ImageView shareCheck;
    @BindView(R.id.account_text)
    public TextView account_text;

    public ShareDeviceHolder(View view) {
        super(view);
        RoundingParams roundingParams = new RoundingParams();
        roundingParams.setRoundAsCircle(true);
        this.headIcon.getHierarchy().setRoundingParams(roundingParams);
        this.headIcon.getHierarchy().setFailureImage(R.mipmap.personalhead, ScalingUtils.ScaleType.FIT_XY);
    }
}
