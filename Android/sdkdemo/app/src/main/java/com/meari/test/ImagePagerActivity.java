package com.meari.test;

import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.photoview.PhotoView;
import com.meari.test.utils.BaseActivity;

import java.util.ArrayList;

import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ImagePagerActivity extends BaseActivity {
    private static final String STATE_POSITION = "STATE_POSITION";
    public static final String EXTRA_IMAGE_INDEX = "image_index";
    public static final String EXTRA_IMAGE_URLS = "image_urls";
    public static final String EXTRA_DEVICEID = "deviceId";
    @BindView(R.id.view_pager)
    ViewPager mPager;
    int pagerPosition;
    @BindView(R.id.indicator)
    TextView indicator;
    private UserInfo mUserInfo;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pager_image);
        getTopTitleView();
        this.mUserInfo = MeariUser.getInstance().getUserInfo();
        pagerPosition = getIntent().getIntExtra(EXTRA_IMAGE_INDEX, 0);
        ArrayList<String> urls = getIntent().getStringArrayListExtra(EXTRA_IMAGE_URLS);

        if (urls != null && urls.size() > pagerPosition) {
            CharSequence text = getString(R.string.viewpager_indicator, 1, urls.size());
            mCenter.setText(text);
        }
        SamplePagerAdapter mAdapter = new SamplePagerAdapter(urls);
        mPager.setAdapter(mAdapter);
        indicator = findViewById(R.id.indicator);
        CharSequence text = getString(R.string.viewpager_indicator, 1, mPager.getAdapter().getCount());
        indicator.setText(text);
        mPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {

            @Override
            public void onPageScrollStateChanged(int arg0) {
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {
            }

            @Override
            public void onPageSelected(int arg0) {
                SamplePagerAdapter adapter = (SamplePagerAdapter) mPager.getAdapter();
                if (adapter == null)
                    return;
                CharSequence text = getString(R.string.viewpager_indicator, arg0 + 1, adapter.getCount());
                mCenter.setText(text);
                indicator.setText(text);
            }

        });
        if (savedInstanceState != null) {
            pagerPosition = savedInstanceState.getInt(STATE_POSITION);
        }
        mPager.setCurrentItem(pagerPosition);
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        outState.putInt(STATE_POSITION, mPager.getCurrentItem());
        super.onSaveInstanceState(outState);
    }

    public class SamplePagerAdapter extends PagerAdapter {

        private ArrayList<String> sDrawables = new ArrayList<>();

        public SamplePagerAdapter(ArrayList<String> urls) {
            this.sDrawables = urls;
        }

        @Override
        public int getCount() {
            return sDrawables.size();
        }

        @Override
        public View instantiateItem(ViewGroup container, int position) {
            String format = getString(R.string.image_url_format);
            String url = String.format(format, sDrawables.get(position), mUserInfo.getUserID(), mUserInfo.getUserToken());
            PhotoView photoView = new PhotoView(container.getContext());
            photoView.setImageUri(url);
            container.addView(photoView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            return photoView;
        }


        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view == object;
        }

    }

}
