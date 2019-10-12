package com.meari.test;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Distribution;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Author: ljh
 * Created on 2017-12-19
 */
public class DistributionActivity extends BaseActivity {
    private int mDeviceTypeID = 0;
    private boolean mIsApMode = false;
    @BindView(R.id.wifi_add_img)
    SimpleDraweeView wifi_add_img;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_distribution);
        initData();
        initView();
    }

    private void initData() {
        mDeviceTypeID = getIntent().getExtras().getInt(StringConstants.DEVICE_TYPE_ID, 2);
        mIsApMode = getIntent().getExtras().getBoolean("ApMode", false);
    }

    /*
     *初始化view
     */
    private void initView() {
        this.mCenter.setText(getString(R.string.distribution));
        AbstractDraweeController mController = Fresco.newDraweeControllerBuilder()
                .setAutoPlayAnimations(true)
                .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.img_camera))//设置uri
                .build();
        wifi_add_img.setController(mController);

    }

    @OnClick(R.id.wire_add_btn)
    public void onWireClic() {
        Intent intent = new Intent(this, AddCameraMethodActivity.class);
        Bundle bundle = new Bundle();
        bundle.putBoolean("ApMode", mIsApMode);
        bundle.putInt(StringConstants.DEVICE_TYPE_ID, this.mDeviceTypeID);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_ADDMETHOD);
    }

    @OnClick(R.id.scan_add_btn)
    public void onScanAddClick() {
        Intent intent = new Intent(this, QRCodeHelpActivity.class);
        Bundle bundle = new Bundle();
        bundle.putBoolean(StringConstants.AP_MODE, mIsApMode);
        bundle.putInt(StringConstants.DEVICE_TYPE_ID, this.mDeviceTypeID);
        bundle.putInt(StringConstants.DISTRIBUTION_TYPE, Distribution.DISTRIBUTION_QR);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_WIFILIST);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_WIFILIST:
                dealWiFiData(resultCode, data);
                break;
            case ActivityType.ACTIVITY_ADDMETHOD:
                dealWiFiData(resultCode, data);
                break;


        }

    }

    /*
     *根据WIFI页面返回处理是否返回列表
     */
    private void dealWiFiData(int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            if (data != null) {
                Bundle bundle = data.getExtras();
                if (bundle != null && bundle.getInt(StringConstants.BACK_HOME, 1) != 2){
                    setResult(Activity.RESULT_OK, data);
                    finish();
                }
            }
        }
    }
}
