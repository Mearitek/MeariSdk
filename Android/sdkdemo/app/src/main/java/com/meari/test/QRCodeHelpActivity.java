package com.meari.test;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.common.ActivityType;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;

import butterknife.BindView;
import butterknife.OnClick;

import static com.facebook.drawee.backends.pipeline.Fresco.newDraweeControllerBuilder;

/**
 * Author: ljh
 * Created on 2017-12-19
 */
public class QRCodeHelpActivity extends BaseActivity {
    @BindView(R.id.device_status_img)
    SimpleDraweeView device_status_img;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scan_help);
        initData();
        initView();
    }

    private int mDeviceTypeID;
    private boolean mIsApMode;
    private int mDistributionType;

    private void initData() {
        this.mIsApMode = getIntent().getExtras().getBoolean(StringConstants.AP_MODE, false);
        this.mDeviceTypeID = getIntent().getExtras().getInt(StringConstants.DEVICE_TYPE_ID, 2);
        this.mDistributionType = getIntent().getExtras().getInt(StringConstants.DISTRIBUTION_TYPE, 0);
    }

    private void initView() {
        this.mCenter.setText(getString(R.string.scan_distribution));
        AbstractDraweeController controller = newDraweeControllerBuilder()
                .setAutoPlayAnimations(true)
                .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.img_scan))//设置uri
                .build();
        device_status_img.setController(controller);
    }

    @OnClick(R.id.scan_add_btn)
    public void goQrActivity() {
        Intent intent = new Intent(this, WifiListActivity.class);
        Bundle bundle = new Bundle();
        bundle.putInt(StringConstants.DISTRIBUTION_TYPE, mDistributionType);
        bundle.putInt(StringConstants.DEVICE_TYPE_ID, mDeviceTypeID);
        bundle.putBoolean(StringConstants.AP_MODE, mIsApMode);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_QR_CODE);
    }


    /*
     *跳转帮助页面
     */
    @OnClick(R.id.help_text)
    public void goHelpActivity() {
        Intent helpIntent = new Intent(this, DeviceStatusHelpActivity.class);
        startActivity(helpIntent);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_QR_CODE:
                dealQrCodeData(resultCode, data);
                break;
            default:
                break;
        }

    }

    /*
     *根据二维码页面返回处理是否返回列表
     */
    private void dealQrCodeData(int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            if (data != null) {
                Bundle bundle = data.getExtras();
                if (bundle != null && bundle .getInt(StringConstants.BACK_HOME, 1) != 2){
                    setResult(Activity.RESULT_OK, data);
                    finish();
                }
            }
        }
    }
}