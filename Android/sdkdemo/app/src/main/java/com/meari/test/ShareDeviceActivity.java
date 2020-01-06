package com.meari.test;

import android.content.Intent;
import android.os.Bundle;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import android.view.View;

import com.meari.sdk.bean.CameraInfo;
import com.meari.test.common.ActivityType;
import com.meari.test.utils.BaseActivity;

import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/5
 * 描    述：
 * 修订历史：
 * ================================================
 */
public class ShareDeviceActivity extends BaseActivity {
    private CameraInfo mInfo;
    private ShareDeviceFragment mFragment;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mInfo = (CameraInfo) getIntent().getExtras().get("cameraInfo");
        initView();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.share_title));
        createFragment();
        this.mRightBtn.setVisibility(View.VISIBLE);
        this.mRightBtn.setImageResource(R.mipmap.ic_add);
    }

    public void createFragment() {
        FragmentManager fm = getSupportFragmentManager();
        FragmentTransaction transaction = fm.beginTransaction();
        this.mFragment = ShareDeviceFragment.newInstance(mInfo);
        transaction.replace(R.id.pps_fragment_layout, mFragment);
        transaction.commit();
    }
    @OnClick(R.id.submitRegisterBtn)
    public void onFriendClick()
    {
        mFragment.startActivityForResult(new Intent(ShareDeviceActivity.this,FriendActivity.class), ActivityType.ACTIVITY_FRIEND);
    }


}

