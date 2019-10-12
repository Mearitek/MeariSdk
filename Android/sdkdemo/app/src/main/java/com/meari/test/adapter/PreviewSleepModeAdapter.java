package com.meari.test.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.sdk.bean.SleepMethmodInfo;
import com.meari.sdk.common.CameraSleepType;
import com.meari.test.R;

import java.util.ArrayList;

/**
 * Created by Administrator on 2017/3/20.
 */
public class PreviewSleepModeAdapter extends RecyclerView.Adapter<PreviewSleepModeAdapter.ViewHolder> {
    private final SleepTypeInterface mCallback;
    private LayoutInflater mInflater;
    private ArrayList<SleepMethmodInfo> mDatas;

    public PreviewSleepModeAdapter(Context context, SleepTypeInterface callback) {
        mInflater = LayoutInflater.from(context);
        mDatas = new ArrayList<>();
        this.mCallback = callback;

    }

    public void setDatas(ArrayList<SleepMethmodInfo> infos) {
        this.mDatas = infos;
    }
    public class ViewHolder extends RecyclerView.ViewHolder {
        public View btn_item_sleep;

        public ViewHolder(View arg0) {
            super(arg0);
        }

        ImageView img_sleep;
        TextView text_sleep;
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    /**
     * 创建ViewHolder
     */
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = mInflater.inflate(R.layout.item_sleep_mode,viewGroup, false);
        ViewHolder viewHolder = new ViewHolder(view);
        viewHolder.img_sleep = view.findViewById(R.id.img_sleep);
        viewHolder.text_sleep = view.findViewById(R.id.text_sleep);
        viewHolder.btn_item_sleep = view.findViewById(R.id.btn_item_sleep);
        return viewHolder;
    }

    /**
     * 设置值
     */
    @Override
    public void onBindViewHolder(final ViewHolder viewHolder, int position) {
        SleepMethmodInfo info = mDatas.get(position);
        viewHolder.text_sleep.setText(info.getName());
        if (info.getType().equals(CameraSleepType.SLEEP_OFF)) {
            viewHolder.img_sleep.setImageResource(R.mipmap.ic_preview_camera_open_dark_grey);
        } else if (info.getType().equals(CameraSleepType.SLEEP_ON)) {
            viewHolder.img_sleep.setImageResource(R.mipmap.ic_preview_camera_close_dark_grey);
        } else if (info.getType().equals( CameraSleepType.SLEEP_TIME)) {
            viewHolder.img_sleep.setImageResource(R.mipmap.ic_preview_time_dark_grey);
        } else if (info.getType().equals(CameraSleepType.SLEEP_GEOGRAPHIC)) {
            viewHolder.img_sleep.setImageResource(R.mipmap.ic_preview_location_dark_grey);
        }
        viewHolder.btn_item_sleep.setTag(info);
        viewHolder.btn_item_sleep.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SleepMethmodInfo info = (SleepMethmodInfo) v.getTag();
                mCallback.changeSleepType(info);
            }
        });
    }

    public interface SleepTypeInterface {
        void changeSleepType(SleepMethmodInfo info);
    }
}