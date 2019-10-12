package com.meari.test;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.interfaces.DraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Distribution;
import com.meari.test.common.StringConstants;
import com.meari.test.receiver.ExitAppReceiver;
import com.meari.test.utils.BaseActivity;

import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/27
 * 描    述：添加设备方法
 * 修订历史：
 * ================================================
 */

public class AddCameraMethodActivity extends BaseActivity {
    public static final String EXIT_APP_ACTION_QUIT = "com.meari.test.quit";
    private ExitAppReceiver quitReceiver = new ExitAppReceiver();
    private int mDeviceTypeID = 2;

    @SuppressLint("WifiManagerLeak")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_camera_method);
        initData();
        initView();
        registerQuitChangeReceiver();
    }

    private void initData() {
        Bundle bundle = getIntent().getExtras();
        if (bundle != null)
            this.mDeviceTypeID = bundle.getInt(StringConstants.DEVICE_TYPE_ID, 2);
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(R.string.camera_setting);
        //判断是否是点击了门铃设备过来的，如果是，换门铃的gif图标
        if (mDeviceTypeID == 4) {
            //是门铃设备
            SimpleDraweeView drawview =  findViewById(R.id.imageView3);
            DraweeController mDraweeController = Fresco.newDraweeControllerBuilder()
                    .setAutoPlayAnimations(true)
                    .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.gif_bell))//设置uri
                    .build();
            drawview.setController(mDraweeController);
        } else {
            //不是门铃设备，普通摄像头gif图标
            SimpleDraweeView drawview =  findViewById(R.id.imageView3);
            DraweeController mDraweeController = Fresco.newDraweeControllerBuilder()
                    .setAutoPlayAnimations(true)
                    .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.img_camera))//设置uri
                    .build();
            drawview.setController(mDraweeController);
        }
        this.mRightText.setText(getString(R.string.manual));
        this.action_bar_rl.setVisibility(View.VISIBLE);
    }

    @OnClick(R.id.right_text)
    public void onRightClick() {
        Intent intent = new Intent(this, APModelActivity.class);
        startActivityForResult(intent, ActivityType.ACTIVITY_APMODE);
    }

    @OnClick(R.id.wifi_add_btn)
    public void onWifiClick() {
        Intent intent = new Intent(this, WifiListActivity.class);
        Bundle bundle = new Bundle();
        bundle.putInt(StringConstants.DEVICE_TYPE_ID, this.mDeviceTypeID);
        bundle.putInt(StringConstants.DISTRIBUTION_TYPE, Distribution.DISTRIBUTION_SMART);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_WIFILIST);
    }

    @OnClick(R.id.help_text)
    public void onHelpClick() {
        Intent helpIntent = new Intent(this, DeviceStatusHelpActivity.class);
        startActivity(helpIntent);
    }

    public void registerQuitChangeReceiver() {
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction(EXIT_APP_ACTION_QUIT);
        registerReceiver(quitReceiver, exitFilter);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unRegisterReceiver();
    }

    public void unRegisterReceiver() {
        unregisterReceiver(quitReceiver);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_WIFILIST:
                if (resultCode == RESULT_OK) {
                    if (data != null) {
                        Bundle bundle = data.getExtras();
                        if (bundle.getInt("back_home", 1) != 2) {
                            setResult(RESULT_OK, data);
                            finish();
                        }
                    }
                }
                break;
            case ActivityType.ACTIVITY_APMODE:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK, data);
                    finish();
                }
                break;
        }
    }
}

