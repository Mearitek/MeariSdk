package com.meari.test.user;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.ILoginCallback;
import com.meari.sdk.callback.IRegisterCallback;
import com.meari.test.R;

public class RegisterActivity extends AppCompatActivity {

    private EditText edtCode, edtAccount, edtNickname, edtPwd;
    private Button btnRegister;
    private TextView tvInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        initView();
    }

    private void initView() {
        edtCode = findViewById(R.id.edt_code);
        edtAccount = findViewById(R.id.edt_account);
        edtNickname = findViewById(R.id.edt_nickname);
        edtPwd = findViewById(R.id.edt_password);
        btnRegister = findViewById(R.id.btn_register);
        tvInfo = findViewById(R.id.tv_info);

        btnRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                register();
            }
        });
    }

    // email account
    private void register() {
        String account = edtAccount.getEditableText().toString().trim();
        String pwd = edtPwd.getEditableText().toString().trim();
        String nickname = edtNickname.getEditableText().toString().trim();
        String verificationCode = "";
        // Mobile phone number registration requires a verification code
        // getValidateCodeWithAccount(String countryCode, String phoneCode, String userAccount, IValidateCallback callback)
        MeariUser.getInstance().registerWithAccount("CN", "86", account, pwd, nickname, verificationCode, new IRegisterCallback() {
            @Override
            public void onSuccess(UserInfo userInfo) {
                Toast.makeText(RegisterActivity.this, R.string.toast_success, Toast.LENGTH_LONG).show();
            }

            @Override
            public void onError(int i, String s) {
                Toast.makeText(RegisterActivity.this, R.string.toast_fail, Toast.LENGTH_LONG).show();
                tvInfo.setText(i + s);
            }
        });
    }
}
