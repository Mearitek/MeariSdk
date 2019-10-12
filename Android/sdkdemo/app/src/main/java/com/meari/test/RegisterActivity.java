package com.meari.test;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.IRegisterCallback;
import com.meari.sdk.callback.IValidateCallback;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.test.bean.RegionInfo;
import com.meari.test.common.ActivityType;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.LoginFormatUtils;
import com.meari.test.utils.NetUtil;
import com.meari.test.utils.TextPinyinUtil;

import org.json.JSONException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/14
 * ================================================
 */

public class RegisterActivity extends BaseActivity {
    @BindView(R.id.register_des_tv)
    TextView register_des_tv;
    @BindView(R.id.pwd_tv)
    EditText pwd_tv;
    @BindView(R.id.reenter_pwd_tv)
    EditText reenter_pwd_tv;
    @BindView(R.id.submit_tv)
    TextView submit_tv;
    @BindView(R.id.verification_et)
    EditText verification_et;
    @BindView(R.id.verification_tv)
    TextView mVerificationBtn;
    @BindView(R.id.left_time_tv)
    TextView mTimeLeftText;
    @BindView(R.id.account_et)
    public EditText account_et;
    @BindView(R.id.nickname_et)
    public EditText nickname_et;
    @BindView(R.id.region_tv)
    public TextView region_tv;
    @BindView(R.id.region_code_tv)
    public TextView region_code_tv;
    private TimeCount time;
    private SharedPreferences mAccountPreferences;
    private ArrayList<String> mAccountLists;
    private RegionInfo mRegionInfo;
    private HashMap<String, String> mRegionCodeHashmap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_register);
        initData();
        initView();
        mAccountLists = new ArrayList<>();
        mAccountPreferences = getSharedPreferences("pps_account", Context.MODE_PRIVATE);
        initAccountList();
        initAccountHint();
    }

    private void initData() {
        String regionCodeData = CommonUtils.getStringDataByResourceId(this, R.raw.country);
        BaseJSONArray jsonArray = null;
        try {
            jsonArray = new BaseJSONArray(regionCodeData);
            mRegionCodeHashmap = CommonUtils.getPhoneCode(jsonArray);
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    private void initAccountList() {
        String accounts = getAccountPreferences().getString("account", "");
        String[] list = accounts.split(";");
        for (String account : list) {
            if (!account.isEmpty())
                mAccountLists.add(account);
        }
        initRegion();
    }

    private void initRegion() {
        this.mRegionInfo = new RegionInfo();
        this.mRegionInfo.setPhoneCode(mRegionCodeHashmap.get(Locale.getDefault().getCountry()));
        if (this.mRegionInfo.getPhoneCode() == null || this.mRegionInfo.getPhoneCode().isEmpty()) {
            this.mRegionInfo.setPhoneCode("+86");
            this.mRegionInfo.setCountryCode(StringConstants.COUNTRY_CODE_CHINA);
            this.mRegionInfo.setLanguage(StringConstants.CHINESE_LANGUAGE);
            Locale locale = new Locale(mRegionInfo.getLanguage(), mRegionInfo.getPhoneCode());
            this.mRegionInfo.setRegionName(locale.getDisplayCountry());
            Locale englishLocale = new Locale("en", "US");
            String curLanguage = Locale.getDefault().getDisplayLanguage(englishLocale);
            if (curLanguage == StringConstants.CHINESE_LANGUAGE) {
                String sortString = TextPinyinUtil.getPinYin(mRegionInfo.getRegionName()).toLowerCase();
                mRegionInfo.setRegionDisplayName(sortString);
            } else {
                mRegionInfo.setRegionDisplayName(mRegionInfo.getRegionName());
            }
        } else {
            this.mRegionInfo.setCountryCode(Locale.getDefault().getCountry());
            this.mRegionInfo.setLanguage(Locale.getDefault().getLanguage());
            this.mRegionInfo.setRegionName(Locale.getDefault().getDisplayCountry());
            String curLanguage = Locale.getDefault().getLanguage();
            if (curLanguage == StringConstants.CHINESE_LANGUAGE) {
                String sortString = TextPinyinUtil.getPinYin(mRegionInfo.getRegionName()).toLowerCase();
                mRegionInfo.setRegionDisplayName(sortString);
            } else {
                mRegionInfo.setRegionDisplayName(mRegionInfo.getRegionName());
            }
        }
        this.region_tv.setText(this.mRegionInfo.getRegionName());
        this.region_code_tv.setText(this.mRegionInfo.getPhoneCode());
    }

    public SharedPreferences getAccountPreferences() {
        return mAccountPreferences;
    }

    private void initView() {
        getTopTitleView();
        this.mCenter.setText(R.string.register);
    }

    @OnClick(R.id.login_btn)
    public void onLoginClick() {
        finish();
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
        String passwordTwo = reenter_pwd_tv.getText().toString().trim();
        String verificationCode = verification_et.getText().toString().trim();
        String account_txt = account_et.getText().toString().trim();
        if (account_txt == null || account_txt.isEmpty()) {
            CommonUtils.showToast(R.string.accountIsNull);
            return;
        } else {
            String able = getResources().getConfiguration().locale.getCountry();
            if (!able.contains("CN")) {
                if (!LoginFormatUtils.isEmail(account_txt)) {
                    CommonUtils.showToast(getString(R.string.account_format_error));
                    return;
                }
            } else {
                if (!LoginFormatUtils.isEmail(account_txt) && !LoginFormatUtils.isMobileNO(account_txt)) {
                    CommonUtils.showToast(getString(R.string.account_format_error));
                    return;
                }
            }
        }


        if (pwdTxt == null || pwdTxt.isEmpty()) {
            CommonUtils.showToast(R.string.passIsNull);
            return;
        }
        if (pwdTxt.length() < 6) {
            CommonUtils.showToast(R.string.password_hint);
            return;
        }
        if (passwordTwo == null || passwordTwo.isEmpty()) {
            CommonUtils.showToast(R.string.passIsNull);
            return;
        }

        if (!pwdTxt.equals(passwordTwo)) {
            CommonUtils.showToast(R.string.passIsNotEqual);
            return;
        }
        if (pwdTxt.length() < 6 || pwdTxt.length() > 20) {
            CommonUtils.showToast(getString(R.string.password_hint));
            return;
        }
        String nickname = nickname_et.getText().toString().trim();
        startProgressDialog();
        MeariUser.getInstance().registerAccount(mRegionInfo.getCountryCode(), mRegionInfo.getPhoneCode(), account_txt, pwdTxt, nickname, verificationCode,this , new IRegisterCallback() {
            @Override
            public void onSuccess(UserInfo user) {
                setResult(RESULT_OK);
                finish();
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }
        });
    }


    @OnClick({R.id.verification_tv})
    public void onGetVerificationClick() {
        String userAccount = account_et.getText().toString().trim();
        if (userAccount == null || userAccount.isEmpty()) {
            CommonUtils.showToast(R.string.accountIsNull);
            return;
        }
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        startProgressDialog();
        MeariUser.getInstance().getValidateCode(this.mRegionInfo.getCountryCode(), this.mRegionInfo.getPhoneCode(), userAccount, this ,new IValidateCallback() {
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

    private class TimeCount extends CountDownTimer {
        TimeCount(long millisInFuture, long countDownInterval) {
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

    public void saveAccountData(UserInfo mUserInfo) {
        for (int i = 0; i < mAccountLists.size(); i++) {
            if (mAccountLists.get(i).equals(mUserInfo.getUserAccount())) {
                mAccountLists.remove(i);
            }
        }
        mAccountLists.add(0, mUserInfo.getUserAccount());
        String accounts = "";
        for (int i = 0; i < mAccountLists.size(); i++) {
            if (i == 0) {
                accounts += mAccountLists.get(0);
            } else
                accounts = accounts + ";" + mAccountLists.get(i);
        }
        SharedPreferences.Editor editor = mAccountPreferences.edit();
        editor.putString("account", accounts);
        editor.apply();
    }

    @Override
    public void onDestroy() {
        if (time != null) {
            time.cancel();
        }
        super.onDestroy();
    }

    public void startTimeCount(int leftTime) {

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

    private void initAccountHint() {
        if (account_et == null)
            return;
        String able = getResources().getConfiguration().locale.getLanguage();
        if (able.equals("zh")) {
            account_et.setHint(getString(R.string.AccountNumber));
        } else {
            account_et.setHint(getString(R.string.email));
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        initAccountHint();
    }

    @OnClick(R.id.region_rl)
    public void onRegionClick() {
        Intent intent = new Intent(this, RegionActivity.class);
        startActivityForResult(intent, ActivityType.ACTIVITY_REGION);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_REGION:
                if (resultCode == RESULT_OK) {
                    if (data != null) {
                        Bundle bundle = data.getExtras();
                        mRegionInfo = (RegionInfo) bundle.getSerializable(StringConstants.REGION_INFO);
                        TextView region_code_tv = findViewById(R.id.region_code_tv);
                        region_code_tv.setText(mRegionInfo.getPhoneCode());
                        this.region_tv.setText(mRegionInfo.getRegionName());
                    }
                }
        }
    }
}
