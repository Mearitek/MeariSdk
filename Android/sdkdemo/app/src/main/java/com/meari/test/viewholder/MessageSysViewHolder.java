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
 * 创建日期：2017/5/18
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MessageSysViewHolder extends BaseViewHolder{
    @BindView(R.id.user_text) public TextView user_text;
    @BindView(R.id.content_text) public TextView content_text;
    @BindView(R.id.arrow_img) public ImageView arrow_img;
    @BindView(R.id.select_img)  public ImageView select_img;
    @BindView(R.id.head_img) public SimpleDraweeView head_img;
     public MessageSysViewHolder(View view) {
        super(view);

        RoundingParams params = new RoundingParams();
        params.setRoundAsCircle(true);
        this.head_img.getHierarchy().setRoundingParams(params);
         this.head_img.getHierarchy().setFailureImage(R.mipmap.personalhead, ScalingUtils.ScaleType.CENTER_INSIDE);
    }
}
