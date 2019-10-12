package com.meari.test.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import com.meari.sdk.bean.ArmingInfo;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.MotionViewHolder;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/5
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MotionAdapter extends BaseQuickAdapter<ArmingInfo, MotionViewHolder> {
    private ArmingInfo mArmingInfo;


    public MotionAdapter(Context context, ArmingInfo bitRate) {
        super(R.layout.item_comom_setting);
        mContext = context;
        this.mArmingInfo = bitRate;

    }

    @Override
    protected void convert(MotionViewHolder viewHold, ArmingInfo armingInfo) {
        viewHold.bitRateText.setText(armingInfo.desc);
        if (armingInfo.cfg.enable == mArmingInfo.cfg.enable && armingInfo.cfg.sensitivity == mArmingInfo.cfg.sensitivity) {
            viewHold.bitRateText.setTextColor(Color.parseColor("#333333"));
            viewHold.bitRateImg.setVisibility(View.VISIBLE);
        } else {
            viewHold.bitRateText.setTextColor(Color.parseColor("#ff919191"));
            viewHold.bitRateImg.setVisibility(View.GONE);
        }
        if (viewHold.getLayoutPosition() == 0)
            viewHold.getConvertView().findViewById(R.id.top_line).setVisibility(View.VISIBLE);
        else
            viewHold.getConvertView().findViewById(R.id.top_line).setVisibility(View.GONE);
    }
    public  void setArmingInfo( ArmingInfo armingInfo)
    {
        this.mArmingInfo = armingInfo;
    }
}

