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

import com.meari.test.user.LoginActivity;

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        verifyStoragePermissions(this);
    }

    private static final int REQUEST_AUDIO = 1;

    private static final String[] PERMISSIONS = {Manifest.permission.RECORD_AUDIO};

    private void verifyStoragePermissions(Activity activity) {
        try {
            int RECORD_AUDIO = ActivityCompat.checkSelfPermission(activity, Manifest.permission.RECORD_AUDIO);
            if (RECORD_AUDIO != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(activity, PERMISSIONS, REQUEST_AUDIO);
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
        if (requestCode == REQUEST_AUDIO) {
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
