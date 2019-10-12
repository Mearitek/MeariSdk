package com.meari.test.widget;

/**
 * Created by ljh on 2017/3/31.
 */


import android.app.Dialog;
import android.content.Context;
import android.view.Gravity;
import android.widget.TextView;

import com.meari.test.R;


/**
 * @date 2014-8-19上午11:04:04
 * @description
 */
public class ProgressLoadingDialog extends Dialog {
    private static ProgressLoadingDialog mProgressDialog = null;

    public ProgressLoadingDialog(Context context) {
        super(context);
    }

    public ProgressLoadingDialog(Context context, int theme) {
        super(context, theme);
    }

    public static ProgressLoadingDialog createDialog(Context context) {
        mProgressDialog = new ProgressLoadingDialog(context, R.style.ProgressDialog);
        mProgressDialog.setContentView(R.layout.dialog_loading);
        mProgressDialog.getWindow().getAttributes().gravity = Gravity.CENTER;
        mProgressDialog.setCanceledOnTouchOutside(false);
        return mProgressDialog;
    }

    public static ProgressLoadingDialog createDialog(Context context, OnCancelListener listener) {
        mProgressDialog = new ProgressLoadingDialog(context, R.style.ProgressDialog);
        mProgressDialog.setContentView(R.layout.dialog_loading);
        mProgressDialog.getWindow().getAttributes().gravity = Gravity.CENTER;
        mProgressDialog.setCanceledOnTouchOutside(false);
        mProgressDialog.setOnCancelListener(listener);
        return mProgressDialog;
    }

    public void onWindowFocusChanged(boolean hasFocus) {
        if (mProgressDialog == null) {
            return;
        }
    }


    /**
     * [Summary] setTitile 标题
     *
     * @param strTitle
     * @return
     */
    public ProgressLoadingDialog setTitile(String strTitle) {
        return mProgressDialog;
    }

    /**
     * [Summary] setMessage 提示内容
     *
     * @param strMessage
     * @return
     */
    public ProgressLoadingDialog setMessage(String strMessage) {
        TextView tvMsg = (TextView) mProgressDialog.findViewById(R.id.prodlg_loading_msg);
        if (tvMsg != null) {
            tvMsg.setText(strMessage);
        }
        return mProgressDialog;
    }

}

