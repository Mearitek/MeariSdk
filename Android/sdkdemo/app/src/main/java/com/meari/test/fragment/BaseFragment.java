package com.meari.test.fragment;

import android.app.Activity;
import android.content.DialogInterface;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.meari.sdk.MeariSdk;
import com.meari.test.application.MeariSmartApp;
import com.meari.test.common.StringConstants;
import com.meari.test.pulltorefresh.PullToRefreshBase;
import com.meari.test.utils.CommonDateUtils;
import com.meari.test.utils.CommonUtils;
import com.meari.test.widget.ProgressLoadingDialog;

import java.lang.reflect.Field;

public class BaseFragment extends Fragment
        implements OnClickListener, StringConstants {
    protected TextView mCenter;
    protected Activity mActivity;
    private ProgressLoadingDialog mProgressDialog;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        this.mActivity = activity;
    }

    protected void setRefreshHint(PullToRefreshBase<?> pullToRefresh) {
        pullToRefresh.onRefreshComplete();
        pullToRefresh.setLastUpdatedLabel(CommonDateUtils.getRefreshDate());
    }

    /**
     * 隐藏上拉的样式
     */
    protected void setLoadHints(PullToRefreshBase<?> pullToRefresh) {
        if (pullToRefresh == null)
            return;
        pullToRefresh.onRefreshComplete();
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        MeariSdk.getInstance().cancelRequestByTag(this);
        stopProgressDialog();
        setProgressDialog(null);
    }

    /**
     * 显示toast
     */
    public void showToast(String text) {
        CommonUtils.showToast(text);
    }

    public void showToast(int resId) {
        CommonUtils.showToast(resId);
    }

    public void showToast(String text, boolean timeLong) {
        CommonUtils.showToast(text);
    }

    public void showToast(int resId, boolean timeLong) {
        CommonUtils.showToast(resId);
    }

    protected void onRefresh() {
    }

    protected void netWorkRequest() {

    }


    /**
     * 显示进度条
     */
    public void startProgressDialog(String content) {
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(mActivity));
        }
        if (!getProgressDialog().isShowing()) {
            getProgressDialog().setMessage(content);
            getProgressDialog().show();
        }
    }

    /**
     * 显示进度条
     */
    public void startProgressDialog() {
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(mActivity));
        }
        if (!getProgressDialog().isShowing()) {
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
     * 关闭该宿主activity
     */
    protected void finish() {
        FragmentActivity hostActivity = getActivity();
        if (hostActivity != null) {
            mActivity.finish();
        }
    }

    @Override
    public void onClick(View v) {
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
            MeariSmartApp.getInstance().tokenChange();
        }
    };

    @Override
    public void onDetach() {
        super.onDetach();
        try {
            Field childFragmentManager = Fragment.class.getDeclaredField("mChildFragmentManager");
            childFragmentManager.setAccessible(true);
            childFragmentManager.set(this, null);

        } catch (NoSuchFieldException e) {
            throw new RuntimeException(e);
        } catch (IllegalAccessException e) {
            throw new RuntimeException(e);
        }

    }

}
