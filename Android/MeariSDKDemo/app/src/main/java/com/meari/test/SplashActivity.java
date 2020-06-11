package com.meari.test;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;

import com.meari.sdk.MeariUser;
import com.meari.test.device.DeviceListActivity;
import com.meari.test.user.LoginActivity;

import java.lang.annotation.ElementType;

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        verifyStoragePermissions(this);
    }

    private static final int REQUEST_EXTERNAL_STORAGE = 1;

    private static String[] PERMISSIONS_STORAGE = {Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.RECORD_AUDIO};

    private void verifyStoragePermissions(Activity activity) {
        try {
            int EXTERNAL_STORAGE = ActivityCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE);
            int RECORD_AUDIO = ActivityCompat.checkSelfPermission(activity, Manifest.permission.RECORD_AUDIO);
            if (EXTERNAL_STORAGE != PackageManager.PERMISSION_GRANTED || RECORD_AUDIO != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(activity, PERMISSIONS_STORAGE,REQUEST_EXTERNAL_STORAGE);
            } else {
                goHome();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                goHome();
            }
        }
    }

    private void goHome() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                Intent intent;
//                if (MeariUser.getInstance().isLogin()) {
//                    intent = new Intent(SplashActivity.this, DeviceListActivity.class);
//                } else {
                    intent = new Intent(SplashActivity.this, LoginActivity.class);
//                }
                startActivity(intent);
                finish();
            }
        },2000);
    }
}
