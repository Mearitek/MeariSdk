package com.meari.test;

import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;

import com.meari.sdk.bean.NVRInfo;
import com.meari.test.utils.BaseActivity;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：NVR摄像机列表
 * 修订历史：
 * ================================================
 */

public class CameraListActivity extends BaseActivity {
    private NVRInfo mInfo;
    private NVRCameraMangerFragment mFragment;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_camera_list);
        mInfo = (NVRInfo) getIntent().getExtras().getSerializable("NVRInfo");
        initView();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.camera_manger_title));
        createFragment();
    }

    public void createFragment() {
        FragmentManager fm = getSupportFragmentManager();
        FragmentTransaction transaction = fm.beginTransaction();
        this.mFragment = NVRCameraMangerFragment.newInstance(mInfo);
        transaction.replace(R.id.pps_fragment_layout, mFragment);
        transaction.commit();
    }
}
