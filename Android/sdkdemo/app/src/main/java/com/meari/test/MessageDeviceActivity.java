package com.meari.test;

import android.os.Bundle;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import android.view.View;

import com.meari.sdk.bean.DeviceMessageStatusInfo;
import com.meari.test.fragment.MessageDeviceFragment;
import com.meari.test.utils.BaseActivity;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/26
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MessageDeviceActivity extends BaseActivity {
    private DeviceMessageStatusInfo mMsgInfo;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            mMsgInfo = (DeviceMessageStatusInfo) bundle.getSerializable("msgInfo");
        } else
            finish();
        initView();
        switchFragment();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(mMsgInfo.getDeviceName());
        this.mBackBtn.setVisibility(View.VISIBLE);
        this.mBackText.setVisibility(View.GONE);
    }

    public void switchFragment() {
        FragmentManager fm = getSupportFragmentManager();
        FragmentTransaction transaction = fm.beginTransaction();
        MessageDeviceFragment fragment = MessageDeviceFragment.newInstance(mMsgInfo);
        transaction.replace(R.id.pps_fragment_layout, fragment);
        transaction.commit();
    }
}
