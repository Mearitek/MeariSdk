package com.meari.test;

import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;

import com.meari.test.utils.BaseActivity;

import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */
public class NvrAddMethodActivity extends BaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_nvr_medthod);
        initView();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(R.string.add_nvr);
    }

    @OnClick(R.id.wifi_add_layout)
    public void onWifiAdd() {
        ConnectivityManager connManager = (ConnectivityManager) getSystemService(CONNECTIVITY_SERVICE);
        NetworkInfo mWifi = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (mWifi != null && mWifi.isConnected()) {
            Intent intent = new Intent(this, AddNvrResultActivity.class);
            startActivityForResult(intent, 0);
        } else
            showToast(getString(R.string.wifi_warnibg));
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 0:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK);
                    finish();
                }
                break;
        }
    }

}

