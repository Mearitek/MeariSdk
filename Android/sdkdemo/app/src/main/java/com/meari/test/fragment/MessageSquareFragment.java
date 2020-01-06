package com.meari.test.fragment;

import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.meari.test.R;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/18
 * ================================================
 */

public class MessageSquareFragment extends BaseFragment {
    private View mFragmentView;

    public View onCreateView(LayoutInflater inflater, ViewGroup paramViewGroup, Bundle paramBundle) {
        super.onCreateView(inflater, paramViewGroup, paramBundle);
        getActivity().findViewById(R.id.top_view).setVisibility(View.VISIBLE);
        mFragmentView = inflater.inflate(R.layout.fragment_message, null);
        ButterKnife.bind(this, mFragmentView);
        boolean bSysMessage = getArguments().getBoolean("sysMessage", false);
        initView(bSysMessage);
        return mFragmentView;
    }

    private void initView(boolean bSysMessage) {
        if (bSysMessage)
            intTab(1);
        else
            intTab(0);
    }

    private void initFragment(int position) {
        Fragment fragment;
        if (position == 0) {
            fragment = MessageAlarmFragment.newInstance();
        } else
            fragment = SystemMessageFragment.newInstance();

        FragmentManager fm = getChildFragmentManager();
        FragmentTransaction transaction = fm.beginTransaction();
        transaction.replace(R.id.content_view, fragment);
        transaction.commitAllowingStateLoss();
    }

    private void intTab(int position) {
        if (position == 0) {
            mFragmentView.findViewById(R.id.tab_alarm).setEnabled(false);
            mFragmentView.findViewById(R.id.tab_alarm_sys).setEnabled(true);
        } else {
            mFragmentView.findViewById(R.id.tab_alarm).setEnabled(true);
            mFragmentView.findViewById(R.id.tab_alarm_sys).setEnabled(false);
        }
        initFragment(position);
    }

    @OnClick(R.id.tab_alarm)
    public void onAlarmClick() {
        intTab(0);
    }

    @OnClick(R.id.tab_alarm_sys)
    public void onSystemClick() {
        intTab(1);
    }

    public static MessageSquareFragment newInstance( boolean b) {
        MessageSquareFragment fragment = new MessageSquareFragment();
        Bundle bundle = new Bundle();
        bundle.putBoolean("sysMessage", b);
        fragment.setArguments(bundle);
        return fragment;
    }
}

