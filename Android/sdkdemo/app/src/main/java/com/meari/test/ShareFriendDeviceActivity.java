package com.meari.test;

import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;

import com.meari.sdk.bean.MeariFriend;
import com.meari.test.fragment.ShareFriendDeviceFragment;
import com.meari.test.utils.BaseActivity;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/9/14
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ShareFriendDeviceActivity extends BaseActivity {
    private MeariFriend mInfo;
    private ShareFriendDeviceFragment mFragment;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mInfo = (MeariFriend) getIntent().getExtras().get("friendInfo");
        initView();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.share_title));
        createFragment();
    }

    public void createFragment() {
        FragmentManager fm = getSupportFragmentManager();
        FragmentTransaction transaction = fm.beginTransaction();
        this.mFragment = ShareFriendDeviceFragment.newInstance(mInfo);
        transaction.replace(R.id.pps_fragment_layout, mFragment);
        transaction.commit();
    }
}
