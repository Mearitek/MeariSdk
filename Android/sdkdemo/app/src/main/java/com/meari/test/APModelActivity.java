package com.meari.test;

import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Bundle;

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
 * 创建日期：2017/4/28
 * 描    述：AP模式
 * 修订历史：
 * ================================================
 */
public class APModelActivity extends BaseActivity {
    public static final String EXIT_APP_ACTION_QUIT = "com.meaeri.test.quit";
    private ExitAppReceiver quitReceiver = new ExitAppReceiver();
    private int mDeviceTypeID;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ap);
        initData();
        initView();
        registerQuitChangeReceiver();
    }

    private void initData() {
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            this.mDeviceTypeID = bundle.getInt(StringConstants.DEVICE_TYPE_ID, 2);
        }
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(R.string.manual);
        SimpleDraweeView drawView =  findViewById(R.id.imageView3);
        DraweeController mDraweeController = Fresco.newDraweeControllerBuilder()
                .setAutoPlayAnimations(true)
                .setUri(Uri.parse("res://" + getPackageName() + "/" + R.mipmap.ic_ap_status))//设置uri
                .build();
        //设置ControllerF
        drawView.setController(mDraweeController);
    }

    @OnClick(R.id.right_text)
    public void onRightClick() {
        Intent intent = new Intent(this, APHelpActivity.class);
        startActivity(intent);
    }

    @OnClick(R.id.wifi_add_btn)
    public void onWifiClick() {
        Intent intent = new Intent(this, WifiListActivity.class);
        Bundle bundle = new Bundle();
        bundle.putInt(StringConstants.DEVICE_TYPE_ID, this.mDeviceTypeID);
        bundle.putInt(StringConstants.DISTRIBUTION_TYPE, Distribution.DISTRIBUTION_AP);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_WIFILIST);
    }

    @OnClick(R.id.help_text)
    public void onHelpClick() {
        Intent helpIntent = new Intent(this, APHelpActivity.class);
        startActivity(helpIntent);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_WIFILIST:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK, data);
                    finish();
                }
                break;
            default:
                break;
        }
    }

    //是否连接WIFI
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
}

