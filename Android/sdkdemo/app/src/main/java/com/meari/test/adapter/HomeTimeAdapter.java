package com.meari.test.adapter;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.sdk.bean.SleepTimeInfo;
import com.meari.test.HomeModelActivity;
import com.meari.test.HomeTimeSetActivity;
import com.meari.test.R;
import com.meari.test.common.ActivityType;
import com.meari.test.widget.SwitchButton;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/18
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class HomeTimeAdapter extends RecyclerView.Adapter<HomeTimeAdapter.ViewHolder> {
    private final String[] mWeekString;
    private Context mContext;
    private ArrayList<SleepTimeInfo> mList;
    private boolean editStatus = false;
    private HomeModelActivity mActivity;

    public HomeTimeAdapter(Context context, HomeModelActivity activity) {
        this.mContext = context;
        this.mActivity = activity;
        mList = new ArrayList<>();
        mWeekString = context.getResources().getStringArray(R.array.WeekString);
    }

    public ArrayList<SleepTimeInfo> getHomeTimeInfos() {
        return mList;
    }

    public void setHomeTimeInfos(ArrayList<SleepTimeInfo> list) {
        mList = list;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View convertView = LayoutInflater.from(mContext).inflate(R.layout.item_home_time, null);
        ViewHolder viewHolder = new ViewHolder(convertView);
        viewHolder.text_time = convertView.findViewById(R.id.text_time);
        viewHolder.text_week = convertView.findViewById(R.id.text_week);
        viewHolder.layout_time = convertView.findViewById(R.id.layout_time);
        viewHolder.check_on = convertView.findViewById(R.id.time_switchchk);
        viewHolder.select_img = convertView.findViewById(R.id.select_img);
        convertView.setTag(viewHolder);
        return viewHolder;
    }

    /**
     * @param viewHolder
     * @param position
     */
    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        SleepTimeInfo info = mList.get(position);
        viewHolder.text_time.setText(info.getStartTime() + " ~ " + info.getEndTime());
        String week = getWeekdays(info.getRepeat());
        viewHolder.text_week.setText(week);
        viewHolder.layout_time.setTag(position);
        viewHolder.layout_time.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int position = (int) v.getTag();
                SleepTimeInfo info = mList.get(position);
                if (editStatus) {
                    ImageView img = (ImageView) v.findViewById(R.id.select_img);
                    SleepTimeInfo messgeInfo = (SleepTimeInfo) img.getTag();
                    if (messgeInfo.getDelMsgFlag() == 1) {
                        img.setImageResource(R.mipmap.ic_message_select_p);
                        messgeInfo.setDelMsgFlag(2);
                    } else {
                        messgeInfo.setDelMsgFlag(1);
                        img.setImageResource(R.mipmap.ic_message_select_n);
                    }
                    return;
                }
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                intent.setClass(mContext, HomeTimeSetActivity.class);
                bundle.putSerializable("SleepTimeInfo", info);
                bundle.putSerializable("HomeTimeInfos", mList);
                bundle.putBoolean("add", false);
                bundle.putInt("position", position);
                intent.putExtras(bundle);
                mActivity.startActivityForResult(intent, ActivityType.ACTIVITY_SETSLEEPTIME);
            }
        });
        viewHolder.check_on.setTag(info);
        viewHolder.check_on.setChecked(info.isEnable());
        viewHolder.check_on.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!editStatus) {
                    SleepTimeInfo info = (SleepTimeInfo) buttonView.getTag();
                    info.setEnable(isChecked);
                    mActivity.postChangeTime(info);
                    return;
                }
            }
        });
        if (editStatus) {
            if (info.getDelMsgFlag() == 1) {
                viewHolder.select_img.setImageResource(R.mipmap.ic_message_select_n);
            } else {
                viewHolder.select_img.setImageResource(R.mipmap.ic_message_select_p);
            }
            viewHolder.select_img.setVisibility(View.VISIBLE);
            viewHolder.check_on.setVisibility(View.GONE);
        } else {
            viewHolder.select_img.setVisibility(View.GONE);
            viewHolder.check_on.setVisibility(View.VISIBLE);
        }
        viewHolder.select_img.setTag(info);
        viewHolder.select_img.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ImageView img = (ImageView) v;
                SleepTimeInfo messgeInfo = (SleepTimeInfo) img.getTag();
                if (messgeInfo.getDelMsgFlag() == 1) {
                    img.setImageResource(R.mipmap.ic_message_select_p);
                    messgeInfo.setDelMsgFlag(2);
                } else {
                    messgeInfo.setDelMsgFlag(1);
                    img.setImageResource(R.mipmap.ic_message_select_n);
                }
            }
        });
    }

    private String getWeekdays(ArrayList<Integer> repeat) {
        String days = "";
        for (int i = 0; i < repeat.size(); i++) {
            int day = repeat.get(i);
            if (i == 0) {

                days += mWeekString[day - 1];
            } else {
                days += "," + (mWeekString[day - 1]);
            }
        }
        return days;
    }

    @Override
    public int getItemCount() {
        return this.mList == null ? 0 : this.mList.size();
    }

    public void changAddDataDeviceMsg(int flag) {
        if (mList != null && mList.size() > 0) {
            for (int i = 0; i < mList.size(); i++) {
                mList.get(i).setDelMsgFlag(flag);
            }
        }
    }

    public void setEditStatus(boolean editStatus) {
        this.editStatus = editStatus;
    }

    public boolean isEditStatus() {
        return this.editStatus;
    }

    /**
     * nothing select
     **/
    public boolean isNothingSelect() {
        if (mList != null && mList.size() > 0) {
            for (int i = 0; i < mList.size(); i++) {
                if (mList.get(i).getDelMsgFlag() == 2) {
                    return false;
                }
            }
        }
        return true;
    }

    public void changeHomeTimeEnable(SleepTimeInfo mChangeHomeInfo) {
        for (SleepTimeInfo info : mList) {
            if (mChangeHomeInfo.equals(info)) {
                info.setEnable(!info.isEnable());
            }
        }
        notifyDataSetChanged();
    }

    public void deleteTime() {
        ArrayList<SleepTimeInfo> infos = new ArrayList<>();
        for (SleepTimeInfo SleepTimeInfo : mList) {
            if (SleepTimeInfo.getDelMsgFlag() != 2)
                infos.add(SleepTimeInfo);
        }
        if (mList == null) {
            mList = new ArrayList<>();
        }
        mList.clear();
        mList.addAll(infos);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView text_week;
        TextView text_time;
        SwitchButton check_on;
        View layout_time;
        ImageView select_img;

        public ViewHolder(View itemView) {
            super(itemView);
        }
    }
}

