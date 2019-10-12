package com.meari.test;

import android.os.Bundle;

import com.meari.test.utils.BaseActivity;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/2
 * 描    述：AP模式帮助页面
 * 修订历史：
 * ================================================
 */

public class APHelpActivity extends BaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_apsetting);
        initView();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.help_title));
    }
}

