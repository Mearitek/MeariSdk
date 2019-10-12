package com.meari.test.adapter;

import android.content.Context;
import android.content.DialogInterface;
import android.view.View;

import com.meari.test.LoginActivity;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.utils.CommonUtils;
import com.meari.test.viewholder.AccountViewHolder;


/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/9/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class AccountAdapter extends BaseQuickAdapter<String, AccountViewHolder> {
    private Context mContext;

    public AccountAdapter(LoginActivity LoginActivity) {
        super(R.layout.item_account);
        this.mContext = LoginActivity;
    }

    @Override
    protected void convert(AccountViewHolder helper, String item) {
        helper.accountDel.setVisibility(View.VISIBLE);
        helper.account.setText(item);
        helper.accountDel.setTag(helper.getLayoutPosition());
        helper.accountDel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int position = (int) v.getTag();
                String account = getItem(position);
                CommonUtils.showDlg(mContext, mContext.getString(R.string.app_meari_name), mContext.getString(R.string.sure_delete) + " " + account + " " + "?",
                        mContext.getString(R.string.ok), new AccountDelClick(position, false),
                        mContext.getString(R.string.cancel), new AccountDelClick(position, true), false);

            }
        });
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    class ViewHolder {

    }

    private class AccountDelClick implements DialogInterface.OnClickListener {
        private boolean isCancel = true;
        private int mPosition;

        AccountDelClick(int position, boolean bCancel) {
            this.mPosition = position;
            this.isCancel = bCancel;
        }

        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            if (!isCancel) {
                remove(mPosition);
//                mContext.saveAccountData(getData());
                notifyDataSetChanged();
                if (getData().size() == 0) {
//                    mContext.showHideStatus();
                }
            }
        }
    }
}
