package com.meari.test.viewholder;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.recyclerview.BaseViewHolder;

import butterknife.BindView;
import butterknife.ButterKnife;


public class AccountViewHolder extends BaseViewHolder {
    @BindView(R.id.accountNum_input)
    public TextView account;
    @BindView(R.id.accountNum_delete)
    public ImageView accountDel;

    public AccountViewHolder(View view) {
        super(view);
        ButterKnife.bind(this, view);
    }
}
