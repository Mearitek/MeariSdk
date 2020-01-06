package com.meari.test.adapter;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import java.util.ArrayList;

/**
 * Created by Administrator on 2016/11/11.
 */
public class FragmentTabsAdapter extends FragmentPagerAdapter {
    private ArrayList<Fragment> fragmentsList;

    public FragmentTabsAdapter(FragmentManager fm) {
        super(fm);
    }

    public FragmentTabsAdapter(FragmentManager fm, ArrayList<Fragment> fragmentsList2) {
        super(fm);
        this.fragmentsList = fragmentsList2;
    }

    @Override
    public int getCount() {
        return fragmentsList.size();
    }

    @Override
    public int getItemPosition(Object object) {
        return super.getItemPosition(object);
    }

    @Override
    public Fragment getItem(int arg0) {

        return fragmentsList.get(arg0);
    }

}
