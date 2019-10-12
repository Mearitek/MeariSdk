package com.meari.test.utils;

import android.text.TextPaint;
import android.text.style.ClickableSpan;
import android.view.View;

/**
 * Created by Administrator on 2016/10/31.
 */

public class ColorClickableSpan extends ClickableSpan {
    private int mColor;
    private OnClickListener mListener;

    public interface OnClickListener {
        public void onClick(View widget);
    }

    public ColorClickableSpan(int color, OnClickListener listener) {
        super();
        mColor = color;
        mListener = listener;
    }

    @Override
    public void updateDrawState(TextPaint ds) {
        ds.setColor(mColor);
        ds.setUnderlineText(false); //去掉下划线
    }

    @Override
    public void onClick(View widget) {
        if (mListener != null) {
            mListener.onClick(widget);
        }
    }
}
