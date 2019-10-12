package com.meari.test;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.utils.CommonUtils;

import cn.jpush.android.api.JPushInterface;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/13
 * ================================================
 */

public class SplashActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //监测appkey是否存在
        JPushInterface.init(this);
        setContentView(R.layout.activity_splash);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (isInitAppkey()) {
                    gotoLogin();
                } else {
                    showTipDialog();
                }
            }
        }, 3000);

    }

    public void gotoLogin() {
        if (MeariUser.getInstance().isLogin()) {//已登录，跳主页

            UserInfo info = MeariUser.getInstance().getUserInfo();
            Intent it = new Intent(SplashActivity.this, MainActivity.class);
            SplashActivity.this.startActivity(it);
            finish();
        } else {
            gotoLoginActivity();
        }
    }

    private void gotoLoginActivity() {
        Intent intent = new Intent(SplashActivity.this, LoginActivity.class);
        Bundle bundle = new Bundle();
        bundle.putInt("activityType", 1);
        intent.putExtras(bundle);
        startActivity(intent);
        finish();
    }


    private void showTipDialog() {
//        DialogUtil.simpleConfirmDialog(this, "appkey or appsecret is empty. \nPlease check your configuration", new DialogInterface.OnClickListener() {
//            @Override
//            public void onClick(DialogInterface dialog, int which) {
//                finish();
//            }
//        });
    }

    private boolean isInitAppkey() {
        String appkey = CommonUtils.getMataData("TUYA_SMART_APPKEY", this);
        String appSecret = CommonUtils.getMataData("TUYA_SMART_SECRET", this);
        if (TextUtils.isEmpty(appkey) || TextUtils.isEmpty(appSecret)) {
            return false;
        }
        return true;
    }
}

