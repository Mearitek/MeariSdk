package com.meari.test.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.bean.RegionGroup;
import com.meari.test.bean.RegionInfo;

import java.util.List;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/14
 * ================================================
 */

public class RegionAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private Context mContext;
    private List<RegionGroup> mRegions;
    private SelectRegionCallback mCallback;

    private final int WORD = 1;
    private final int CITY = 2;

    public RegionAdapter(Context context, List<RegionGroup> cities, SelectRegionCallback callback) {
        this.mContext = context;
        this.mRegions = cities;
        this.mCallback = callback;
    }

    public List<RegionGroup> getData() {
        return mRegions;
    }

    @Override
    public int getItemCount() {
        int count = 0;
        if (mRegions == null || mRegions.size() == 0) return count;
        count += mRegions.size();
        for (RegionGroup dataBean : mRegions) {
            count += dataBean.getRegions().size();
        }
        return count;
    }

    @Override
    public int getItemViewType(int position) {
        int count = -1;
        for (int i = 0; i < mRegions.size(); i++) {
            count++;
            if (position == count) {
                return WORD;
            }
            List<RegionInfo> addressList = mRegions.get(i).getRegions();
            for (int j = 0; j < addressList.size(); j++) {
                count++;
                if (position == count) {
                    return CITY;
                }
            }
        }
        return super.getItemViewType(position);
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        switch (viewType) {
            case WORD:
                View word = LayoutInflater.from(mContext).inflate(R.layout.layout_word, parent, false);
                return new WordViewHolder(word);
            case CITY:
                View city = LayoutInflater.from(mContext).inflate(R.layout.layout_city, parent, false);
                return new CityViewHolder(city);
        }
        return null;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        int count = -1;
        for (int i = 0; i < mRegions.size(); i++) {
            count++;
            if (position == count) {
                WordViewHolder wordViewHolder = (WordViewHolder) holder;
                RegionGroup dataBean = mRegions.get(i);
                wordViewHolder.textWord.setText(dataBean.getFirstLetter());
            }
            List<RegionInfo> addressList = mRegions.get(i).getRegions();
            for (int j = 0; j < addressList.size(); j++) {
                count++;
                if (position == count) {
                    CityViewHolder cityViewHolder = (CityViewHolder) holder;
                    RegionInfo addressListBean = addressList.get(j);
                    cityViewHolder.textCity.setTag(addressListBean);
                    cityViewHolder.textCity.setText(addressListBean.getRegionName());
                    cityViewHolder.textCity.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            RegionInfo info = (RegionInfo) view.getTag();
                            if (mCallback != null) {
                                mCallback.selectRegionCallback(info);
                            }
                        }
                    });
                }
            }
        }

    }

    public class WordViewHolder extends RecyclerView.ViewHolder {
        TextView textWord;

        public WordViewHolder(View view) {
            super(view);
            textWord = view.findViewById(R.id.textWord);
        }
    }

    public class CityViewHolder extends RecyclerView.ViewHolder {

        TextView textCity;

        public CityViewHolder(View view) {
            super(view);
            textCity = view.findViewById(R.id.textCity);
        }
    }

    public interface SelectRegionCallback {
        void selectRegionCallback(RegionInfo addressListBean);
    }
}

