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
 * 创建日期：2017/9/14
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class FriendHolder extends BaseViewHolder {
    @BindView(R.id.nickNameFriend)
    public TextView nickNameFriend;
    @BindView(R.id.accountNumFriend)
    public TextView accountNumFriend;
    @BindView(R.id.ivIsStar)
    public TextView ivIsStar;
    @BindView(R.id.friends_layout)
    public View friends_layout;
    @BindView(R.id.selectAllImgId)
    public ImageView selectImg;
    @BindView(R.id.head_cion)
    public SimpleDraweeView headIcon;

    public FriendHolder(View view) {
        super(view);
        RoundingParams params = new RoundingParams();
        params.setRoundAsCircle(true);
        this.headIcon.getHierarchy().setRoundingParams(params);
        this.headIcon.getHierarchy().setFailureImage(R.mipmap.personalhead, ScalingUtils.ScaleType.FIT_XY);
    }
}
