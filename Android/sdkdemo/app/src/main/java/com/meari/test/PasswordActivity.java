package com.meari.test;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.IResetPasswordCallback;
import com.meari.sdk.callback.IValidateCallback;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.LoginFormatUtils;
import com.meari.test.utils.NetUtil;
import com.meari.test.widget.ClearEditText;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by Administrator on 2016/10/28.
 * 找回密码界面
 */
public class PasswordActivity extends BaseActivity {
    @BindView(R.id.register_des_tv)
    TextView register_des_tv;
    @BindView(R.id.pwd_tv)
    ClearEditText pwd_tv;
    @BindView(R.id.reenter_pwd_tv)
    ClearEditText reenter_pwd_tv;
    @BindView(R.id.submit_tv)
    TextView mSubmitBtn;
    @BindView(R.id.verification_et)
    EditText verification_et;
    @BindView(R.id.verification_tv)
    TextView mVerificationBtn;
    @BindView(R.id.time_left_tv)
    TextView mTimeLeftText;
    private int[] mEditIds = {R.id.pwd_tv, R.id.reenter_pwd_tv};
    private TimeCount time;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_password);
        initView();
        addListener();
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(R.string.password_title);
        TextView accountNum = this.findViewById(R.id.account_tv);
        accountNum.setText(MeariUser.getInstance().getUserInfo().getUserAccount());
    }

    private void addListener() {
        for (int i = 0; i < mEditIds.length; i++) {
            ClearEditText editText = findViewById(mEditIds[i]);
            editText.addTextChangedListener(new PPSTextWatcher(i));
        }
    }


    @OnClick(R.id.submit_tv)
    public void onSubmitRegisterClick() {
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        CommonUtils.hideKeyBoard(this);
        // 账号不能为空
        String pwdTxt = pwd_tv.getText().toString().trim();
        String rePwdTxt = reenter_pwd_tv.getText().toString().trim();
        String verificationCode = verification_et.getText().toString().trim();

        if (verificationCode == null || verificationCode.isEmpty()) {
            register_des_tv.setText(R.string.velidateIsNull);
            register_des_tv.setVisibility(View.VISIBLE);
            return;
        }

        if (pwdTxt == null || pwdTxt.isEmpty()) {
            register_des_tv.setText(R.string.passIsNull);
            register_des_tv.setVisibility(View.VISIBLE);
            return;
        }
        if (pwdTxt.length() < 6) {
            register_des_tv.setText(R.string.password_hint);
            register_des_tv.setVisibility(View.VISIBLE);
            return;
        }

        if (pwdTxt == null || rePwdTxt.isEmpty()) {
            register_des_tv.setText(R.string.passIsNull);
            register_des_tv.setVisibility(View.VISIBLE);
            return;
        }

        if (!pwdTxt.equals(rePwdTxt)) {
            register_des_tv.setText(R.string.passIsNotEqual);
            register_des_tv.setVisibility(View.VISIBLE);
            return;
        }
        if (pwdTxt.length() < 6 || pwdTxt.length() > 20) {
            CommonUtils.showToast(getString(R.string.password_hint));
            return;
        }
        startProgressDialog();
        String country = MeariUser.getInstance().getUserInfo().getClientID();
        String phoneCode = MeariUser.getInstance().getUserInfo().getClientID();
        MeariUser.getInstance().resetAccountPassword(country, phoneCode, MeariUser.getInstance().getUserInfo().getUserAccount(), verificationCode, rePwdTxt,this , new IResetPasswordCallback() {
            @Override
            public void onSuccess(UserInfo user) {
                stopProgressDialog();
                CommonUtils.showToast(getString(R.string.changepassword_suc));
                finish();
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
            }
        });
    }

    @OnClick({R.id.verification_tv})
    public void onGetVerificationClick() {
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
        } else {
            startProgressDialog();
            MeariUser.getInstance().getValidateCode(MeariUser.getInstance().getUserInfo().getUserAccount(), this ,new IValidateCallback() {
                @Override
                public void onSuccess(int leftTime) {
                    stopProgressDialog();
                    startTimeCount(leftTime);
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(error);
                }
            });
        }
    }

    /* 定义一个倒计时的内部类 */
    private class TimeCount extends CountDownTimer {

        TimeCount(long millisInFuture, long countDownInterval) {
            // 参数依次为总时长,和计时的时间间隔
            super(millisInFuture, countDownInterval);
        }

        @Override
        public void onFinish() {// 计时完毕时触发
            mVerificationBtn.setVisibility(View.VISIBLE);
            findViewById(R.id.text_time_layout).setVisibility(View.GONE);
            mVerificationBtn.setEnabled(true);
        }

        @Override
        public void onTick(long millisUntilFinished) {
            int leftTime = (int) (millisUntilFinished / 1000);
            mTimeLeftText.setText(String.valueOf(leftTime));
        }
    }

    private class PPSTextWatcher implements TextWatcher {
        private int mPosition;

        PPSTextWatcher(int position) {
            this.mPosition = position;
        }

        @Override
        public void afterTextChanged(Editable s) {

        }

        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
            showErrorView(s, mPosition);
        }
    }

    @Override
    public void onDestroy() {
        if (time != null) {
            time.cancel();
        }
        super.onDestroy();
    }

    private void startTimeCount(int leftTime) {

        if (time != null) {
            time.cancel();
        }
        time = new TimeCount(leftTime * 1000, 1000);
        time.start();
        this.mVerificationBtn.setEnabled(false);
        this.mVerificationBtn.setVisibility(View.GONE);
        mTimeLeftText.setText(String.valueOf(leftTime));
        findViewById(R.id.text_time_layout).setVisibility(View.VISIBLE);
    }

    public void setTextDesc(int content) {
        if (content == 0) {
            this.register_des_tv.setVisibility(View.GONE);
        } else {
            this.register_des_tv.setVisibility(View.VISIBLE);
            this.register_des_tv.setText(content);
        }
    }

    private void setTextDesc(String content) {
        if (content == null || content.length() <= 0) {
            this.register_des_tv.setVisibility(View.GONE);
        } else {
            this.register_des_tv.setVisibility(View.VISIBLE);
            this.register_des_tv.setText(content);
        }
    }

    private void showErrorView(CharSequence s, int position) {
        String valueString = s.toString();
        if (s.length() == 0) {
            this.register_des_tv.setVisibility(View.GONE);
        } else {
            switch (position) {
                case 0:
                    if (!valueString.isEmpty()) {
                        if (valueString.contains("@")) {
                            if (LoginFormatUtils.isEmail(valueString)) {
                                setTextDesc(0);
                            } else {
                                setTextDesc(R.string.accountInfoFail);
                            }
                        } else {
                            if (LoginFormatUtils.isMobileNOs(valueString)) {
                                setTextDesc(0);
                            } else {
                                setTextDesc(R.string.accountInfoFail);
                            }
                        }
                    }
                    break;
                case 1:
                    this.register_des_tv.setVisibility(View.GONE);
                    break;
                case 2:
                    this.register_des_tv.setVisibility(View.GONE);
                    break;
                case 3:
                    String password2 = reenter_pwd_tv.getText().toString().trim();
                    if (!valueString.isEmpty()) {
                        if (!password2.isEmpty()) {
                            if (!password2.equals(valueString) && valueString.length() >= password2.length()) {
                                setTextDesc(getString(R.string.passIsNotEqual));
                            } else {
                                this.register_des_tv.setVisibility(View.GONE);
                            }
                        }
                    } else {
                        this.register_des_tv.setVisibility(View.GONE);
                    }
                    break;
                case 4:
                    String password1 = pwd_tv.getText().toString().trim();
                    if (!valueString.isEmpty()) {
                        if (!password1.isEmpty()) {
                            if (!password1.equals(valueString) && valueString.length() >= password1.length()) {
                                setTextDesc(getString(R.string.passIsNotEqual));
                            } else {
                                this.register_des_tv.setVisibility(View.GONE);
                            }
                        }
                    } else {
                        this.register_des_tv.setVisibility(View.GONE);
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
