package com.meari.test.adapter;

import android.content.Context;

import com.meari.test.R;
import com.meari.test.bean.RegionInfo;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.RegionViewHolder;


/**
 * Author: ljh
 * Created on 17-12-1
 */


public class SearchRegionAdapter extends BaseQuickAdapter<RegionInfo, RegionViewHolder> {


    public SearchRegionAdapter(Context context) {
        super(R.layout.layout_city);
        mContext = context;
    }

    @Override
    protected void convert(RegionViewHolder viewHold, RegionInfo armingInfo) {
        viewHold.textCity.setText(armingInfo.getRegionName());
    }

}

