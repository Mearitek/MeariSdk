package com.meari.test.utils;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.meari.sdk.MeariSdk;
import com.meari.test.R;
import com.meari.test.common.AppStatusManager;
import com.meari.test.common.StringConstants;
import com.meari.test.receiver.ExitAppReceiver;
import com.meari.test.widget.ProgressLoadingDialog;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;


public class BaseActivity extends FragmentActivity {
    private ProgressLoadingDialog mProgressDialog;
    @BindView(R.id.title)
    public TextView mCenter;
    @BindView(R.id.back_img)
    public ImageView mBackBtn;
    @BindView(R.id.submitRegisterBtn)
    public ImageView mRightBtn;
    @BindView(R.id.cancel_btn)
    public TextView mBackText;
    @BindView(R.id.right_text)
    public TextView mRightText;
    @BindView(R.id.action_bar_rl)
    public RelativeLayout action_bar_rl;


    /**
     * 显示进度条
     */
    public void startProgressDialog() {
        if (isFinishing()) {
            return;
        }
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(this));
        }
        if (!getProgressDialog().isShowing()) {
            getProgressDialog().show();
        }
    }

    /**
     * 显示进度条
     */
    public void startProgressDialog(String content) {
        if (isFinishing()) {
            return;
        }
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(this));
        }
        if (!getProgressDialog().isShowing()) {
            getProgressDialog().setMessage(content);
            getProgressDialog().show();
        }
    }

    /**
     * 显示进度条
     */
    public void startProgressDialog(String content, DialogInterface.OnCancelListener listener) {
        if (isFinishing()) {
            return;
        }
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(this, listener));
        }
        if (!getProgressDialog().isShowing()) {
            getProgressDialog().setMessage(content);
            getProgressDialog().show();
        }
    }

    /**
     * 关闭进度条
     */

    public void stopProgressDialog() {
        if (getProgressDialog() != null && getProgressDialog().isShowing()) {
            getProgressDialog().dismiss();
        }
    }

    /**
     * 显示toast
     */
    public void showToast(String text) {
        CommonUtils.showToast(text);
    }

    public void getTopTitleView() {
    }


    public ProgressLoadingDialog getProgressDialog() {
        return mProgressDialog;
    }

    public void setProgressDialog(ProgressLoadingDialog mProgressDialog) {
        this.mProgressDialog = mProgressDialog;
    }


    public DialogInterface.OnClickListener mCancelListener = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            CommonUtils.clearAutoLoginData();
            dialog.dismiss();
//            MeariSmartApp.getInstance().tokenChange();
        }
    };
    private ExitAppReceiver tokenChangeReceiver = new ExitAppReceiver();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppStatusManager.getInstance().setAppStatus(AppStatusManager.AppStatusConstant.APP_NORMAL);
        registerExitAppReceiver();
    }

    public void registerExitAppReceiver() {
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction(StringConstants.MESSAGE_EXIT_APP);
        registerReceiver(tokenChangeReceiver, exitFilter);
    }

    public void unRegisterTokenReceiver() {
        unregisterReceiver(tokenChangeReceiver);
    }

    @Override
    protected void onDestroy() {
        unRegisterTokenReceiver();
        super.onDestroy();

    }

    @Override
    public void finish() {
        MeariSdk.getInstance().cancelRequestByTag(this);
        super.finish();

    }

    @Override
    public void setContentView(@LayoutRes int layoutResID) {
        super.setContentView(layoutResID);
        ButterKnife.bind(this);
    }

    @Override
    public void setContentView(View view) {
        super.setContentView(view);
        ButterKnife.bind(this);
    }

    @Override
    public void setContentView(View view, ViewGroup.LayoutParams params) {
        super.setContentView(view, params);
        ButterKnife.bind(this);
    }

    @OnClick(R.id.back_img)
    public void onBackClick(View view) {
        finish();
    }

    protected void onResume() {
        super.onResume();

    }

    protected void onPause() {
        super.onPause();

    }


    private void checkAppStatus() {
//        if (AppStatusManager.getInstance().getAppStatus() == AppStatusManager.AppStatusConstant.APP_FORCE_KILLED) {
//            //应用启动入口SplashActivity，走重启流程
//            Intent intent = new Intent(this, SplashActivity.class);
//            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
//            startActivity(intent);
//        }
    }

    /**
     * 跳转页面
     */
    public void start2Activity(Class c) {
        Intent it = new Intent();
        it.setClass(this, c);
        startActivity(it);
    }

    /**
     * 跳转页面,带参数bundle
     */
    public void start2Activity(Class c, Bundle bundle) {
        Intent it = new Intent();
        it.setClass(this, c);
        it.putExtras(bundle);
        startActivity(it);
    }

    /**
     * 开启页面，带结果返回
     *
     * @param c
     * @param code
     */
    public void start2ActivityForResult(Class c, int code) {
        Intent it = new Intent();
        it.setClass(this, c);
        startActivityForResult(it, code);
    }

    /**
     * 开启页面，带参数，带结果返回
     *
     * @param c
     * @param bundle
     * @param code
     */
    public void start2ActivityForResult(Class c, @NonNull Bundle bundle, int code) {
        Intent it = new Intent();
        it.setClass(this, c);
        it.putExtras(bundle);
        startActivityForResult(it, code);
    }
}

