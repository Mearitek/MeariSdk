package com.meari.test.viewholder;

import android.view.View;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Author: ljh
 * Created on 2017-12-01
 */
public class RegionViewHolder extends BaseViewHolder {
    @BindView(R.id.textCity)
    public TextView textCity;

    public RegionViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);
    }
}