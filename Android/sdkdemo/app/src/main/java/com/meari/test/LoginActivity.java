package com.meari.test;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.core.view.ViewCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.InputType;
import android.text.Selection;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.ILoginCallback;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.test.adapter.AccountAdapter;
import com.meari.test.bean.RegionInfo;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Constant;
import com.meari.test.common.Preference;
import com.meari.test.common.StringConstants;
import com.meari.test.receiver.ExitAppReceiver;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.NetUtil;
import com.meari.test.utils.TagAliasOperatorHelper;
import com.meari.test.utils.TextPinyinUtil;

import org.json.JSONException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import butterknife.BindView;
import butterknife.OnClick;

import static com.meari.test.utils.TagAliasOperatorHelper.sequence;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/13
 * ================================================
 */
public class LoginActivity extends BaseActivity {
    @BindView(R.id.account_edit)
    public EditText account_edit;
    @BindView(R.id.password_edit)
    public EditText password_edit;
    @BindView(R.id.login_btn)
    public TextView login_btn;
    @BindView(R.id.register_text)
    public TextView register_text;
    @BindView(R.id.password_text)
    public TextView mPasswordText;
    @BindView(R.id.region_tv)
    public TextView region_tv;
    @BindView(R.id.region_code_tv)
    public TextView region_code_tv;
    @BindView(R.id.account_arrow)
    public ImageView mArrowImage;
    private boolean isExit;
    private AccountAdapter mAdapter;
    private SharedPreferences mAccountPreferences;
    private ArrayList<String> mAccountList;
    private PopupWindow mPopupWindow;
    private RegionInfo mRegionInfo;
    private HashMap<String, String> mRegionCodeHashmap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mAccountList = new ArrayList<>();
        mAccountPreferences = getSharedPreferences(StringConstants.MEARI_LOGIN_ACCOUNT, Context.MODE_PRIVATE);
        initAccountList();
        this.setContentView(R.layout.activity_login);
        initData();
        initView();
        deletePushAlias();
        initAccountHint();
        if (Preference.getPreference().getUpdateMarkArray() != null) {
            Preference.getPreference().getUpdateMarkArray().clear();
        }
        initJPushAlias("");
    }

    private void initAccountHint() {
        if (account_edit == null)
            return;
        String able = Locale.getDefault().getCountry();
        if (able.contains("CN")) {
            account_edit.setHint(getString(R.string.AccountNumber));
        } else {
            account_edit.setHint(getString(R.string.email));
        }
    }

    private void deletePushAlias() {
        TagAliasOperatorHelper.TagAliasBean tagAliasBean = new TagAliasOperatorHelper.TagAliasBean();
        tagAliasBean.action = TagAliasOperatorHelper.ACTION_DELETE;
        sequence++;
        tagAliasBean.alias = null;
        tagAliasBean.isAliasAction = true;
        TagAliasOperatorHelper.getInstance().handleAction(getApplicationContext(), sequence, tagAliasBean);
    }

    private void initAccountList() {
        String accounts = getAccountPreferences().getString("account", "");
        String[] list = accounts.split(";");
        for (String account : list) {
            if (!account.isEmpty())
                mAccountList.add(account);
        }
    }


    // 得到所有的控件
    private void initView() {
        View imageView = findViewById(R.id.logo_lv);
        ViewCompat.setTransitionName(imageView, "image");
        this.mArrowImage.setTag(0);
        if (mAccountList != null && mAccountList.size() > 0) {
            this.password_edit.requestFocus();
            this.password_edit.setFocusable(true);
            CommonUtils.showKeyBoard(this, password_edit);
            this.mArrowImage.setVisibility(View.VISIBLE);
            account_edit.setText(this.mAccountList.get(0));
            mAdapter = new AccountAdapter(this);
            mAdapter.setNewData(this.mAccountList);
            mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<String>() {
                @Override
                public void onItemClick(BaseQuickAdapter<String, ? extends BaseViewHolder> adapter, View view, int position) {
                    account_edit.setText(mAdapter.getItem(position));
                    showAccount(false);
                    mPopupWindow.dismiss();
                }
            });

        } else
            this.mArrowImage.setVisibility(View.GONE);
        CheckBox mPwdCheck = findViewById(R.id.laogin_lookpwdbtn);
        mPwdCheck.setChecked(false);
        mPwdCheck.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!isChecked) {
                    // 文本以密码形式显示
                    password_edit.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                    // 下面两行代码实现: 输入框光标一直在输入文本后面
                    Editable editable = password_edit.getText();
                    Selection.setSelection(editable, editable.length());
                } else {
                    // 文本正常显示
                    password_edit.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                    Editable editable = password_edit.getText();
                    Selection.setSelection(editable, editable.length());
                }
            }
        });
        initPopView();
        password_edit.setOnEditorActionListener(new TextView.OnEditorActionListener() {

            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                onLoginBtnClick();
                return false;
            }
        });

        initRegion();
    }


    private void initPopView() {
        LayoutInflater layoutInflater = LayoutInflater.from(this);
        View mPopView = layoutInflater.inflate(R.layout.pop_account, null);
        int w = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        int h = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        RecyclerView recyclerview = mPopView.findViewById(R.id.account_recyclerview);
        recyclerview.setLayoutManager(new LinearLayoutManager(this));
        recyclerview.setAdapter(mAdapter);
        recyclerview.measure(w, h);
        mPopupWindow = new PopupWindow(mPopView, Constant.width - DisplayUtil.dip2px(this, 96), ViewGroup.LayoutParams.WRAP_CONTENT);
        mPopupWindow.setFocusable(true); //这里很重要，设置该popupWindow可以获取焦点，不然无法响应点击事件
        mPopupWindow.setBackgroundDrawable(new BitmapDrawable());
        mPopupWindow.setOutsideTouchable(true);
        mPopupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                showAccount(false);
            }
        });
    }

    @OnClick(R.id.register_text)
    public void onRegisterBtnClick() {
        Intent intent = new Intent(LoginActivity.this, RegisterActivity.class);
        startActivityForResult(intent, 0);
    }

    @OnClick(R.id.password_text)
    public void onGetPasswordBtnClick() {
        Intent intent = new Intent(LoginActivity.this, ForgotPasswordActivity.class);
        Bundle bundle = new Bundle();
        bundle.putInt("type", 0);
        bundle.putString("nickname", account_edit.getText().toString());
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_PWD);
    }

    @OnClick(R.id.login_btn)
    public void onLoginBtnClick() {
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        CommonUtils.hideKeyBoard(this);
        String account_edits = account_edit.getText().toString().trim();
        String password_edits = password_edit.getText().toString().trim();
        if (account_edits == null || account_edits.isEmpty())
            CommonUtils.showToast(getString(R.string.accountIsNull));
        else if (password_edits == null || password_edits.isEmpty())
            CommonUtils.showToast(getString(R.string.passIsNull));
        else {
            startProgressDialog();
            //账号登入
            MeariUser.getInstance().loginWithAccount(this.mRegionInfo.getCountryCode(), this.mRegionInfo.getPhoneCode(), account_edits, password_edits, new ILoginCallback() {
                @Override
                public void onSuccess(UserInfo user) {
                    initJPushAlias(user.getJpushAlias());
                    stopProgressDialog();
                    if (mAdapter != null) {
                        saveAccountData(mAdapter.getData(), user);
                    } else
                        saveAccountData(new ArrayList<String>(), user);
                    Intent it = new Intent(LoginActivity.this, MainActivity.class);
                    LoginActivity.this.startActivity(it);
                    finish();
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(error);
                }
            });
            // 如果有自己的用户体系，可以通过UID登录，无需注册。
//            MeariUser.getInstance().loginWithUid(this.mRegionInfo.getCountryCode(), this.mRegionInfo.getPhoneCode(), account_edits, new ILoginCallback() {
//                @Override
//                public void onSuccess(UserInfo userInfo) {
//                    initJPushAlias(userInfo.getJpushAlias());
//                    stopProgressDialog();
//                    if (mAdapter != null) {
//                        saveAccountData(mAdapter.getData(), userInfo);
//                    } else
//                        saveAccountData(new ArrayList<String>(), userInfo);
//                    Intent it = new Intent(LoginActivity.this, MainActivity.class);
//                    LoginActivity.this.startActivity(it);
//                    finish();
//                }
//
//                @Override
//                public void onError(int i, String s) {
//                    stopProgressDialog();
//                    CommonUtils.showToast(s);
//                }
//            });
        }

    }

    private void initJPushAlias(String alias) {
        boolean isAliasAction = true;
        int action = TagAliasOperatorHelper.ACTION_SET;
        TagAliasOperatorHelper.TagAliasBean tagAliasBean = new TagAliasOperatorHelper.TagAliasBean();
        tagAliasBean.action = action;
        sequence++;
        tagAliasBean.alias = alias;
        tagAliasBean.isAliasAction = isAliasAction;
        TagAliasOperatorHelper.getInstance().handleAction(getApplicationContext(), sequence, tagAliasBean);

    }

    public void onLoginMain() {
        String account_edits = account_edit.getText().toString().trim();
        String password_edits = password_edit.getText().toString().trim();
        if (account_edits == null || account_edits.isEmpty())
            CommonUtils.showToast(getString(R.string.accountIsNull));
        else if (password_edits == null || password_edits.isEmpty())
            CommonUtils.showToast(getString(R.string.accountIsNull));
        else {
        }

    }


    @OnClick(R.id.account_arrow)
    public void onArrowClick(View v) {
        int tag = (int) v.getTag();
        if (tag == 0)
            showAccount(true);
        else
            showAccount(false);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case 0:
                if (resultCode == RESULT_OK) {

                    Intent it = new Intent(this, MainActivity.class);
                    this.startActivity(it);
                    finish();
                }
                break;
            case ActivityType.ACTIVITY_PWD:
                if (resultCode == RESULT_OK) {
                    Intent it = new Intent(this, MainActivity.class);
                    this.startActivity(it);
                    finish();
                }
                break;
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
            default:
                break;

        }
    }

    // 时间次数
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            exit();
            return false;
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    public void exit() {
        if (!isExit) {
            isExit = true;
            CommonUtils.showToast(getString(R.string.exit_app));
            mHandler.sendEmptyMessageDelayed(0, 2000);
        } else {
//            MeariSmartApp.getInstance().exitApp(0);
        }
    }

    @SuppressLint("HandlerLeak")
    Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            isExit = false;
        }
    };

    private void showAccount(boolean bShow) {
        if (bShow) {
            this.mArrowImage.setImageResource(R.mipmap.ic_arrow_up);
            this.mArrowImage.setTag(1);
            CommonUtils.hideKeyBoard(this);
            int width = DisplayUtil.dip2px(this, 24);
            mPopupWindow.showAsDropDown(findViewById(R.id.loginFirstInputId), width, 0);
        } else {
            this.mArrowImage.setTag(0);
            this.mArrowImage.setImageResource(R.mipmap.ic_arrow_down_n);
            mPopupWindow.dismiss();
        }
    }

    public SharedPreferences getAccountPreferences() {
        return mAccountPreferences;
    }

    public void setAccountPreferences(SharedPreferences mAccountPreferences) {
        this.mAccountPreferences = mAccountPreferences;
    }

    @Override
    protected void onDestroy() {
        // TODO Auto-generated method stub
        super.onDestroy();
    }

    public void saveAccountData(List<String> strings, UserInfo mUserInfo) {
        for (int i = 0; i < strings.size(); i++) {
            if (strings.get(i).equals(mUserInfo.getUserAccount())) {
                strings.remove(i);
            }
        }
        strings.add(0, mUserInfo.getUserAccount());
        String accounts = "";
        for (int i = 0; i < strings.size(); i++) {
            if (i == 0) {
                accounts += strings.get(0);
            } else
                accounts = accounts + ";" + strings.get(i);
        }
        SharedPreferences.Editor editor = mAccountPreferences.edit();
        editor.putString("account", accounts);
        editor.apply();
    }

    public void showHideStatus() {
        findViewById(R.id.account_arrow).setVisibility(View.GONE);
    }

    public void saveAccountData(List<String> mAccountList) {
        if (mAccountList == null) {
            return;
        }
        String accounts = "";
        for (int i = 0; i < mAccountList.size(); i++) {
            if (i == 0) {
                accounts += mAccountList.get(0);
            } else
                accounts = accounts + ";" + mAccountList.get(i);
            SharedPreferences.Editor editor = mAccountPreferences.edit();
            editor.putString("account", accounts);
            editor.apply();
        }
    }

    @Override
    public void registerExitAppReceiver() {
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction(StringConstants.MESSAGE_EXIT_APP);
        registerReceiver(mExitReceiver, exitFilter);
    }

    @Override
    public void unRegisterTokenReceiver() {
        unregisterReceiver(mExitReceiver);
    }

    private ExitAppReceiver mExitReceiver = new ExitAppReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            // TODO Auto-generated method stub
            if (context != null) {
                if (context instanceof Activity) {
                    if (intent != null) {
                        int code = intent.getIntExtra("msgId", StringConstants.MESSAGE_ID_TOKEN_CHANGE);
                        if (code == StringConstants.MESSAGE_ID_EXIT_APP) {
                            ((Activity) context).finish();
                        }
                    } else
                        LoginActivity.this.finish();
                }
            }
        }
    };


    @Override
    protected void onResume() {
        super.onResume();
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