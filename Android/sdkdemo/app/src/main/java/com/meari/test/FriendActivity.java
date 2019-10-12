package com.meari.test;

import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.View;

import com.meari.test.fragment.FriendSquareFragment;
import com.meari.test.utils.BaseActivity;

/*

 * -----------------------------------------------------------------

 * Copyright (C) 2017-2050, by meari, All rights reserved.

 * -----------------------------------------------------------------

 * File: FriendActivity.java

 * Author: ljh

 * Create: 17-11-9 下午8:28

 * Description: 好友界面

 */
public class FriendActivity extends BaseActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initView();
        switchFragment();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.friends_title));
        this.mBackBtn.setVisibility(View.VISIBLE);
        this.mBackText.setVisibility(View.GONE);
    }

    public void switchFragment() {
        FragmentManager fm = getSupportFragmentManager();
        FragmentTransaction transaction = fm.beginTransaction();
        FriendSquareFragment fragment = FriendSquareFragment.newInstance( );
        transaction.replace(R.id.pps_fragment_layout, fragment);
        transaction.commit();
    }
}
