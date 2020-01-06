package com.meari.test;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;

import com.meari.sdk.json.BaseJSONArray;
import com.meari.test.adapter.RegionAdapter;
import com.meari.test.adapter.SearchRegionAdapter;
import com.meari.test.bean.RegionBean;
import com.meari.test.bean.RegionGroup;
import com.meari.test.bean.RegionInfo;
import com.meari.test.common.StringConstants;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.TextPinyinUtil;
import com.meari.test.widget.SelectRegionView;

import org.json.JSONException;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/14
 * ================================================
 */

public class RegionActivity extends BaseActivity implements RegionAdapter.SelectRegionCallback {

    @BindView(R.id.region_rv)
    RecyclerView region_rv;
    @BindView(R.id.region_search_et)
    EditText region_search_et;
    /**
     *
     */
    @BindView(R.id.quick_select_view)
    SelectRegionView quick_select_view;
    private RegionAdapter mAdapter;
    private RegionBean mRegionBean;
    private ArrayList<RegionInfo> mRegions;
    private String mCurLanguage;
    private HashMap<String, String> mRegionCodeHas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_region);
        try {
            initData();
        } catch (JSONException e) {
            e.printStackTrace();
        }
        initView();
    }

    /**
     * @throws JSONException
     */
    private void initData() throws JSONException {
        mRegionBean = new RegionBean();
        mRegionCodeHas = new HashMap();
        Locale locale = new Locale(StringConstants.ENGLISH_LANGUAGE, "US");
        mCurLanguage = Locale.getDefault().getLanguage();
        ArrayList<RegionInfo> regionInfos = new ArrayList<>();
        ArrayList<String> regionCode = new ArrayList<>();
        String regionCodeData = CommonUtils.getStringDataByResourceId(RegionActivity.this, R.raw.country);
        BaseJSONArray jsonArray = new BaseJSONArray(regionCodeData);
        mRegionCodeHas = CommonUtils.getPhoneCode(jsonArray);
        Locale[] list = Locale.getAvailableLocales();
        for (Locale locale1 : list) {
            String str = locale1.getDisplayCountry();
            if (str != null && !str.isEmpty()) {
                String code = mRegionCodeHas.get(locale1.getCountry());
                String language = locale1.getLanguage();
                String country = locale1.getCountry();
                String displayCountry = locale1.getDisplayCountry();
                if (code == null || code.isEmpty())
                    continue;
                else {
                    if (regionCode.contains(country))
                        continue;
                    else {
                        RegionInfo info = new RegionInfo();
                        info.setPhoneCode(code);
                        //支持中英日韩显示
                        if (mCurLanguage.equals(StringConstants.CHINESE_LANGUAGE) || mCurLanguage.equals(StringConstants.CHINESE_LANGUAGE)
                                || mCurLanguage.equals(StringConstants.JAPAN_LANGUAGE) || mCurLanguage.equals(StringConstants.KOREAN_LANGUAGE))
                            info.setRegionName(displayCountry);
                        else
                            info.setRegionName(locale1.getDisplayCountry(locale));
                        info.setCountryCode(country);
                        info.setLanguage(language);
                        if (mCurLanguage == StringConstants.CHINESE_LANGUAGE) {
                            String sortString = TextPinyinUtil.getPinYin(info.getRegionName()).toLowerCase();
                            info.setRegionDisplayName(sortString);
                        } else {
                            info.setRegionDisplayName(info.getRegionName());
                        }
                        regionInfos.add(info);
                        regionCode.add(country);
                    }
                }

            }
        }
        dealData(regionInfos, mCurLanguage);
    }


    private void dealData(ArrayList<RegionInfo> regionInfos, String language) {
        Collections.sort(regionInfos, new SortRegionDisplayName());
        mRegions = regionInfos;
        for (RegionInfo regionInfo : regionInfos) {
            {
                if (language .equals(StringConstants.CHINESE_LANGUAGE)  || language .equals(StringConstants.ENGLISH_LANGUAGE) ) {
                    String sortString = regionInfo.getRegionDisplayName().substring(0, 1).toUpperCase();
                    if (sortString.matches("[A-Z]")) {
                        mRegionBean.addRegion(sortString, regionInfo);
                    } else {
                        mRegionBean.addRegion("#", regionInfo);
                    }
                } else {
                    mRegionBean.addRegion("#", regionInfo);
                }
            }
        }


    }


    private void initView() {
        this.mCenter.setText(getString(R.string.region));
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        region_rv.setLayoutManager(layoutManager);
        mAdapter = new RegionAdapter(this, mRegionBean.getDatas(), RegionActivity.this);
        if (mCurLanguage.equals(StringConstants.CHINESE_LANGUAGE) || mCurLanguage.equals(StringConstants.CHINESE_LANGUAGE)
                || mCurLanguage.equals(StringConstants.JAPAN_LANGUAGE) || mCurLanguage.equals(StringConstants.KOREAN_LANGUAGE)) {
            region_rv.setAdapter(mAdapter);
            initEvent();
            region_search_et.setVisibility(View.VISIBLE);
            region_search_et.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

                }

                @Override
                public void onTextChanged(CharSequence charSequence, int i, int i1, int count) {
                    if (count == 0) {
                        if (mCurLanguage .equals( StringConstants.ENGLISH_LANGUAGE) || mCurLanguage .equals(StringConstants.CHINESE_LANGUAGE)) {
                            region_rv.setAdapter(mAdapter);
                            quick_select_view.setVisibility(View.VISIBLE);
                        } else {
                            SearchRegionAdapter adapter = new SearchRegionAdapter(RegionActivity.this);
                            adapter.setNewData(mRegions);
                            adapter.setOnItemClickListener(new SearchRegionAdapter.OnItemClickListener<RegionInfo>() {
                                @Override
                                public void onItemClick(BaseQuickAdapter<RegionInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                                    RegionInfo regionInfo = adapter.getItem(position);
                                    selectRegionCallback(regionInfo);
                                }
                            });
                            region_rv.setAdapter(adapter);
                            quick_select_view.setVisibility(View.GONE);
                        }
                    } else {
                        SearchRegionAdapter adapter = new SearchRegionAdapter(RegionActivity.this);
                        adapter.setNewData(getSearchData());
                        adapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<RegionInfo>() {
                            @Override
                            public void onItemClick(BaseQuickAdapter<RegionInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                                RegionInfo regionInfo = adapter.getItem(position);
                                selectRegionCallback(regionInfo);
                            }
                        });
                        region_rv.setAdapter(adapter);
                        quick_select_view.setVisibility(View.GONE);
                    }
                }

                @Override
                public void afterTextChanged(Editable editable) {

                }
            });

        } else {
            SearchRegionAdapter adapter = new SearchRegionAdapter(RegionActivity.this);
            adapter.setNewData(mRegions);
            region_rv.setAdapter(adapter);
            quick_select_view.setVisibility(View.GONE);
            adapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<RegionInfo>() {
                @Override
                public void onItemClick(BaseQuickAdapter<RegionInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                    RegionInfo regionInfo = adapter.getItem(position);
                    selectRegionCallback(regionInfo);
                }
            });

        }
    }

    private void onItemClick(SearchRegionAdapter adapter, int position) {
        RegionInfo regionInfo = adapter.getItem(position);
        selectRegionCallback(regionInfo);
    }

    private ArrayList<RegionInfo> getSearchData()

    {
        String searchTxt = region_search_et.getText().toString().trim().toLowerCase();
        ArrayList<RegionInfo> regionInfos = new ArrayList();
        for (RegionInfo regionInfo : regionInfos) {
            if (regionInfo.getRegionName().contains(searchTxt) || regionInfo.getRegionDisplayName().contains(searchTxt))
                regionInfos.add(regionInfo);
        }
        return regionInfos;

    }


    private void initEvent() {
        quick_select_view.setWORDS(mRegionBean.getAlifNames());
        quick_select_view.setOnIndexChangeListener(new SelectRegionView.OnIndexChangeListener() {

            @Override
            public void onIndexChange(String words) {
                List<RegionGroup> data = mAdapter.getData();
                if (data != null && data.size() > 0) {
                    int count = 0;
                    for (RegionGroup regionGroup : data) {
                        if (regionGroup.getFirstLetter() == words) {
                            RecyclerView.LayoutManager llm = region_rv.getLayoutManager();
                            llm.scrollToPosition(count);
                        }
                        count += regionGroup.getRegions().size() + 1;
                    }

                }
            }
        });

    }

    @Override
    public void selectRegionCallback(RegionInfo addressListBean) {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putSerializable(StringConstants.REGION_INFO, addressListBean);
        intent.putExtras(bundle);
        setResult(Activity.RESULT_OK, intent);
        finish();
    }

    class SortRegionDisplayName implements Comparator<RegionInfo> {
        @Override
        public int compare(RegionInfo regionInfo, RegionInfo t1) {
            return regionInfo.getRegionDisplayName().compareTo(t1.getRegionDisplayName());
        }
    }
}






