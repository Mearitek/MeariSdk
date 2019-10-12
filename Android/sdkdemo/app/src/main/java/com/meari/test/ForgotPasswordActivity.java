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
import com.meari.sdk.callback.IResetPasswordCallback;
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
import com.meari.test.widget.ClearEditText;

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
 * 创建日期：2017/9/19
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ForgotPasswordActivity extends BaseActivity {
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
    @BindView(R.id.text_time_left)
    TextView mTimeLeftText;
    @BindView(R.id.region_tv)
    public TextView region_tv;
    @BindView(R.id.region_code_tv)
    public TextView region_code_tv;
    public int mType = 0;// 0表示找回密码 1表示修改密码
    private TimeCount time;
    private SharedPreferences mAccountPreferences;
    private ArrayList<String> mAccountLists;
    private RegionInfo mRegionInfo;
    private HashMap<String, String> mRegionCodeHashmap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_forget_password);
        this.mType = 1;
        mAccountLists = new ArrayList<>();
        mAccountPreferences = getSharedPreferences("pps_account", Context.MODE_PRIVATE);
        initData();
        initAccountList();
        initView();
    }

    private void initView() {
        getTopTitleView();
        String account = "";
        this.mCenter.setText(R.string.password_title);
        if (getIntent() != null) {
            Bundle bundle = getIntent().getExtras();
            if (bundle != null)
                account = bundle.getString("nickname");
        }
        EditText accountNum = this.findViewById(R.id.account_tv);
        accountNum.setText(account);
        initRegion();
    }


    @OnClick(R.id.submit_tv)
    public void onSubmitRegisterClick() {
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        CommonUtils.hideKeyBoard(this);
        // 账号不能为空
        EditText accountNum = this.findViewById(R.id.account_tv);
        String accountNumFriendText = accountNum.getText().toString().trim();
        if (!accountNumFriendText.isEmpty()) {
            if (accountNumFriendText.contains("@")) {
                if (!LoginFormatUtils.isEmail(accountNumFriendText)) {
                    CommonUtils.showToast(R.string.friend_wrong);
                    return;
                }
            } else {
                if (!LoginFormatUtils.isMobileNOs(accountNumFriendText)) {
                    CommonUtils.showToast(R.string.friend_wrong);
                    return;
                }
            }

        }
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

        if (rePwdTxt == null || rePwdTxt.isEmpty()) {
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
        MeariUser.getInstance().resetAccountPassword(mRegionInfo.getCountryCode(), mRegionInfo.getPhoneCode(), accountNumFriendText, verificationCode, pwdTxt, this ,new IResetPasswordCallback() {
            @Override
            public void onSuccess(UserInfo user) {
                stopProgressDialog();
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
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        EditText accountNum = this.findViewById(R.id.account_tv);
        String accountNumFriendText = accountNum.getText().toString().trim();
        if (!accountNumFriendText.isEmpty()) {
            if (accountNumFriendText.contains("@")) {
                if (!LoginFormatUtils.isEmail(accountNumFriendText)) {
                    CommonUtils.showToast(R.string.friend_wrong);
                    return;
                }
            } else {
                if (!LoginFormatUtils.isMobileNOs(accountNumFriendText)) {
                    CommonUtils.showToast(R.string.friend_wrong);
                    return;
                }
            }

        }
        startProgressDialog();
        MeariUser.getInstance().getValidateCode(mRegionInfo.getCountryCode(), mRegionInfo.getPhoneCode(), accountNumFriendText,this , new IValidateCallback() {
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
        time = new ForgotPasswordActivity.TimeCount(leftTime * 1000, 1000);
        time.start();
        this.mVerificationBtn.setEnabled(false);
        this.mVerificationBtn.setVisibility(View.GONE);
        mTimeLeftText.setText(String.valueOf(leftTime));
        findViewById(R.id.text_time_layout).setVisibility(View.VISIBLE);
    }


    public SharedPreferences getAccountPreferences() {
        return mAccountPreferences;
    }

    private void initAccountList() {
        String accounts = getAccountPreferences().getString("account", "");
        String[] list = accounts.split(";");
        for (String account : list) {
            if (!account.isEmpty())
                mAccountLists.add(account);
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

    private void initRegion() {
        this.mRegionInfo = new RegionInfo();
        this.mRegionInfo.setPhoneCode(mRegionCodeHashmap.get(Locale.getDefault().getCountry()));
        if (this.mRegionInfo.getPhoneCode() == null || this.mRegionInfo.getPhoneCode().isEmpty()) {
            this.mRegionInfo.setPhoneCode("+86");
            this.mRegionInfo.setCountryCode(StringConstants.COUNTRY_CODE_CHINA);
            this.mRegionInfo.setLanguage(StringConstants.CHINESE_LANGUAGE);
            Locale locale = new Locale(mRegionInfo.getLanguage(), mRegionInfo.getCountryCode());
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

    @OnClick(R.id.region_rl)
    public void onRegionClick() {
        Intent intent = new Intent(this, RegionActivity.class);
        startActivityForResult(intent, ActivityType.ACTIVITY_REGION);
    }
}
