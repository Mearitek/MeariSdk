package com.meari.test.user;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.ILoginCallback;
import com.meari.test.R;
import com.meari.test.device.DeviceListActivity;

public class LoginActivity extends AppCompatActivity {

    private EditText edtCode, edtAccount, edtPwd;
    private Button btnLogin, btnRegister;
    private TextView tvInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        initView();
    }

    private void initView() {
        edtCode = findViewById(R.id.edt_code);
        edtAccount = findViewById(R.id.edt_account);
        edtPwd = findViewById(R.id.edt_password);
        btnLogin = findViewById(R.id.btn_login);
        btnRegister = findViewById(R.id.btn_register);
        tvInfo = findViewById(R.id.tv_info);

        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                login();
            }
        });
        btnRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(LoginActivity.this, RegisterActivity.class);
                startActivity(intent);
            }
        });
    }

    // (CN,86)，(US, 1)
    private void login() {

        // 云云对接登录
        String redirectionJson = "";//云云对接获取
        String loginJson = "";//云云对接获取
        MeariUser.getInstance().loginWithExternalData(redirectionJson, loginJson, new ILoginCallback() {
            @Override
            public void onSuccess(UserInfo userInfo) {

            }

            @Override
            public void onError(int i, String s) {

            }
        });

//        String account = edtAccount.getEditableText().toString().trim();
//        String pwd = edtPwd.getEditableText().toString().trim();
//        MeariUser.getInstance().loginWithAccount("CN", "86", account, pwd, new ILoginCallback() {
//            @Override
//            public void onSuccess(UserInfo userInfo) {
//                Toast.makeText(LoginActivity.this, R.string.toast_success, Toast.LENGTH_LONG).show();
//                goToMain();
//            }
//
//            @Override
//            public void onError(int i, String s) {
//                Toast.makeText(LoginActivity.this, R.string.toast_fail, Toast.LENGTH_LONG).show();
//                tvInfo.setText(i + s);
//            }
//        });

        // uid
//        MeariUser.getInstance().loginWithUid("CN", "86", account, new ILoginCallback() {
//            @Override
//            public void onSuccess(UserInfo userInfo) {
//                Toast.makeText(LoginActivity.this,"成功",Toast.LENGTH_LONG).show();
//                goToMain();
//            }
//
//            @Override
//            public void onError(int i, String s) {
//                Toast.makeText(LoginActivity.this,"失败",Toast.LENGTH_LONG).show();
//                tvInfo.setText(i + s);
//            }
//        });

    }

    private void goToMain() {
        Intent intent = new Intent(this, DeviceListActivity.class);
        startActivity(intent);
        finish();
    }
}
