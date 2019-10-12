package com.meari.test;

import android.os.Bundle;

import com.meari.test.utils.BaseActivity;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/28
 * 描    述：设备状态值帮助页面
 * 修订历史：
 * ================================================
 */

public class DeviceStatusHelpActivity extends BaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_devicehelp);
        getTopTitleView();
        initView();
    }

    private void initView() {
        this.mCenter.setText(getString(R.string.help_title));
    }
}
