package com.meari.test.device;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.meari.sdk.MeariUser;
import com.meari.sdk.callback.ICreateQRCodeCallback;
import com.meari.sdk.callback.IGetTokenCallback;
import com.meari.test.R;

public class AddDeviceActivity extends AppCompatActivity {

    private EditText edtWifiName, edtWifiPwd;
    private Button btnComplete;
    private ImageView imgQRCode;

    private String mToken;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_device);
        getToken();
        initView();
    }

    private void initView() {
        edtWifiName = findViewById(R.id.edt_wifi_name);
        edtWifiPwd = findViewById(R.id.edt_wifi_pwd);
        btnComplete = findViewById(R.id.btn_complete);
        imgQRCode = findViewById(R.id.img_qr_code);

        btnComplete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                createQRCode();
            }
        });
    }

    private void getToken() {
        MeariUser.getInstance().getToken(new IGetTokenCallback() {
            @Override
            public void onSuccess(String s, int i, int i1) {
                mToken = s;
            }

            @Override
            public void onError(int i, String s) {

            }
        });
    }

    public void createQRCode() {
        String wifiName = edtWifiName.getEditableText().toString().trim();
        String wifiPwd = edtWifiPwd.getEditableText().toString().trim();
        if (TextUtils.isEmpty(wifiName) || TextUtils.isEmpty(wifiName) || TextUtils.isEmpty(wifiName)) {
            Toast.makeText(AddDeviceActivity.this, R.string.toast_fail, Toast.LENGTH_LONG).show();
        }
        MeariUser.getInstance().createQRCode(wifiName, wifiPwd, mToken, new ICreateQRCodeCallback() {
            @Override
            public void onSuccess(Bitmap bitmap) {
                imgQRCode.setImageBitmap(bitmap);
            }
        }, false);
    }
}
