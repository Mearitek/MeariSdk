package com.meari.test.adapter;

import android.content.Context;
import android.graphics.Color;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.sdk.bean.SleepMethmodInfo;
import com.meari.test.R;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/17
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class SleepModeAdapter extends RecyclerView.Adapter<SleepModeAdapter.ViewHolder> {
    private final String[] mWeekString;
    private Context mContext;
    private ArrayList<SleepMethmodInfo> mList;
    private ActionCallback mCallback;
    private String mType;
    private boolean IsEditStatus;

    public SleepModeAdapter(Context context, ActionCallback activity) {
        this.mContext = context;
        this.mCallback = activity;
        mList = new ArrayList<>();
        mWeekString = context.getResources().getStringArray(R.array.WeekString);
    }

    public ArrayList<SleepMethmodInfo> getSleepMethmodInfos() {
        return mList;
    }

    public void setSleepMethmodInfos(ArrayList<SleepMethmodInfo> list) {
        mList = list;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View convertView = LayoutInflater.from(mContext).inflate(R.layout.item_sleep_methmod, null);
        ViewHolder viewHolder = new ViewHolder(convertView);
        viewHolder.sleep_methmod =  convertView.findViewById(R.id.sleep_methmod);
        viewHolder.text_desc =  convertView.findViewById(R.id.sleep_loaction_layout);
        viewHolder.location_switch = convertView.findViewById(R.id.location_switch);
        viewHolder.layout_desc = convertView.findViewById(R.id.layout_desc);
        viewHolder.location_layout = convertView.findViewById(R.id.location_layout);
        viewHolder.arrow_img = convertView.findViewById(R.id.arrow_img);
        convertView.setTag(viewHolder);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        SleepMethmodInfo info = mList.get(position);
        if (info.getDesc() == null || info.getDesc().isEmpty()) {
            viewHolder.layout_desc.setVisibility(View.GONE);
        } else
            viewHolder.text_desc.setText(info.getDesc());
        viewHolder.sleep_methmod.setText(info.getName());
        viewHolder.location_layout.setTag(position);
        if (info.getType().equals(this.mType)) {
            viewHolder.sleep_methmod.setTextColor(mContext.getResources().getColorStateList(R.color.com_blue));
            viewHolder.location_switch.setVisibility(View.VISIBLE);
            if (IsEditStatus) {
                if (info.getType().equals("on") || info.getType().equals("off")) {
                    viewHolder.location_layout.setEnabled(false);
                } else {
                    viewHolder.location_layout.setEnabled(true);
                }
            } else {
                viewHolder.location_layout.setEnabled(false);
            }
            viewHolder.location_switch.setImageResource(R.mipmap.img_home_choice);
        } else {
            viewHolder.location_switch.setVisibility(View.GONE);
            viewHolder.sleep_methmod.setTextColor(Color.parseColor("#333333"));
            if (IsEditStatus) {
                if (info.getType().equals("on") || info.getType().equals("off")) {
                    viewHolder.location_layout.setEnabled(false);
                } else {
                    viewHolder.location_layout.setEnabled(true);
                }
            } else {
                viewHolder.location_layout.setEnabled(true);
            }
            viewHolder.location_switch.setImageResource(0);

        }
        viewHolder.location_layout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int position = (int) v.getTag();
                mCallback.onChangeType(position, IsEditStatus);
            }
        });
        if (IsEditStatus)
        {
            viewHolder.location_switch.setVisibility(View.GONE);
            if (info.getType().equals("on") || info.getType().equals("off")) {
                viewHolder.arrow_img.setVisibility(View.GONE);
            }
            else  viewHolder.arrow_img.setVisibility(View.VISIBLE);
            viewHolder.sleep_methmod.setTextColor(Color.parseColor("#333333"));
        }
        else {
            viewHolder.location_switch.setVisibility(View.VISIBLE);
            viewHolder.arrow_img.setVisibility(View.GONE);
        }
    }


    @Override
    public int getItemCount() {
        return this.mList == null ? 0 : this.mList.size();
    }

    public void setSleepMode(String sleepMode) {
        this.mType = sleepMode;
    }

    public void setEditStatus(boolean editStatus) {
        this.IsEditStatus = editStatus;
    }


    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView text_desc;
        TextView sleep_methmod;
        ImageView location_switch;
        View layout_desc;
        public View location_layout;
        public View arrow_img;

        public ViewHolder(View itemView) {
            super(itemView);
        }
    }

    public interface ActionCallback {
        public void onChangeType(int position, boolean isEditStatus);
    }
    public String getType()
    {
        return mType;
    }
}

