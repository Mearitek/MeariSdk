package com.meari.test;

import android.os.Bundle;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.callback.IResultCallback;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;

import java.util.ArrayList;
import java.util.List;

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

public class NvrRemoveCameraActivity extends BaseActivity {
    private CameraInfo mCameraInfo;
    private int nvrID;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_remove_camera);
        initData();
        initView();
    }

    private void initData() {
        this.mCameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        this.nvrID = (int) getIntent().getExtras().getSerializable("nvrID");
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.nvr_title));
        TextView sn = (TextView) findViewById(R.id.text_sn);
        sn.setText(mCameraInfo.getNvrNum());
    }

    @OnClick(R.id.btn_remove)
    public void postDelData() {
        // 检查网络是否可用
        if (!NetUtil.checkNet(this)) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        startProgressDialog();
        List<String> infos = new ArrayList<>();
        infos.add(mCameraInfo.getDeviceID());
        MeariUser.getInstance().unbindDevice(nvrID, infos, new IResultCallback() {
            @Override
            public void onSuccess() {
                CommonUtils.showToast(getString(R.string.remove_camera_success));
                setResult(RESULT_OK);
                finish();
            }

            @Override
            public void onError(int code, String error) {
                showToast(error);
            }
        });
    }
}

