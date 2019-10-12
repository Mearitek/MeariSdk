package com.meari.test.viewholder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;

import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/5
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MotionViewHolder extends BaseViewHolder {
    @BindView(R.id.frameRateText)
    public TextView bitRateText;
    @BindView(R.id.frameRateImg)
    public ImageView bitRateImg;

    public MotionViewHolder(View view) {
        super(view);
    }
}