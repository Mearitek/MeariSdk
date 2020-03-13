package com.meari.test;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import androidx.annotation.Nullable;

import com.meari.sdk.MeariDeviceController;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.listener.MeariDeviceListener;
import com.meari.sdk.listener.MeariDeviceVideoStopListener;
import com.meari.test.common.Constant;
import com.meari.test.utils.BaseActivity;
import com.ppstrong.ppsplayer.PPSGLSurfaceView;

public class PreviewActivity extends BaseActivity {
    private boolean isReady = false;
    private PPSGLSurfaceView videoSurfaceView;
    private CameraInfo cameraInfo;
    private MeariDeviceController deviceController;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_preview);
        initData();
        initView();
    }

    private void initData() {
        cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        deviceController = new MeariDeviceController();
        deviceController.setCameraInfo(cameraInfo);

        MeariUser.getInstance().setCameraInfo(cameraInfo);
        MeariUser.getInstance().setController(deviceController);
    }

    private void initView() {
        this.mCenter.setText(getString(R.string.Preview));
        this.mRightBtn.setVisibility(View.VISIBLE);
        this.mRightBtn.setImageResource(R.mipmap.img_setting);
        this.mRightBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!isReady) {
                    return;
                }
                Intent intent  = new Intent(PreviewActivity.this, CameraSettingActivity.class);
                startActivityForResult(intent,100);
            }
        });

        LinearLayout ll_video_view = findViewById(R.id.ll_video);
        videoSurfaceView = new PPSGLSurfaceView(this, Constant.width, Constant.height);
        videoSurfaceView.setKeepScreenOn(true);
        ll_video_view.addView(videoSurfaceView);

        startProgressDialog();
        connect();
    }

    private void connect() {
        deviceController.startConnect(new MeariDeviceListener() {
            @Override
            public void onSuccess(String successMsg) {
                isReady = true;
                preview();
                // 保存设备信息和控制器
                MeariUser.getInstance().setCameraInfo(cameraInfo);
                MeariUser.getInstance().setController(deviceController);
            }

            @Override
            public void onFailed(String errorMsg) {

            }
        });
    }

    private void preview() {
        deviceController.startPreview(videoSurfaceView, 0, new MeariDeviceListener() {
            @Override
            public void onSuccess(String successMsg) {
                stopProgressDialog();
            }

            @Override
            public void onFailed(String errorMsg) {

            }
        }, new MeariDeviceVideoStopListener() {
            @Override
            public void onVideoClosed(int code) {

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (deviceController != null && deviceController.isConnected()) {
                preview();
            } else {
                connect();
            }
        }
    }

    @Override
    protected void onStop() {
        deviceController.stopPreview(new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {

            }

            @Override
            public void onFailed(String s) {

            }
        });
        super.onStop();
    }

    @Override
    public void finish() {
        deviceController.stopConnect(new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {

            }

            @Override
            public void onFailed(String s) {

            }
        });
        super.finish();
    }
}
