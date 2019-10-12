package com.meari.test.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.FrameLayout;
import android.widget.ProgressBar;

import com.meari.test.R;

/**
 * 加载动画视图
 * Created by ljh on 2016/1/8.
 */
public class LoadingView extends FrameLayout {

    public LoadingView(Context context) {
        super(context);
    }

    public LoadingView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public LoadingView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    /**
     * @param bBabyMoniter 初始化progress
     */
    public void init(boolean bBabyMoniter) {
        LayoutInflater.from(getContext()).inflate(R.layout.dlg_loading, this);
        ProgressBar progressBar = (ProgressBar) findViewById(R.id.prodlg_loading_iv);
        if (bBabyMoniter) {
            progressBar.setIndeterminateDrawable(getContext().getResources().getDrawable(R.drawable.progress_loading_yellow_style));
        } else {
            progressBar.setIndeterminateDrawable(getContext().getResources().getDrawable(R.drawable.progress_loading_style));
        }
    }
}
