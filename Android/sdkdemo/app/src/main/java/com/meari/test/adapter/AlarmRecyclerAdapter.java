package com.meari.test.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.sdk.bean.AlarmMessageTime;

import java.util.ArrayList;
import java.util.List;

;

/**
 * Created by LIAO on 2016/8/15.
 */
public class AlarmRecyclerAdapter extends RecyclerView.Adapter<AlarmRecyclerAdapter.ViewHolder> {
    private LayoutInflater mInflater;
    private ArrayList<AlarmMessageTime> mDatas;
    private VideoEventImplement mCallback;
    private AlarmMessageTime mSelectInfo;
    private Context mContext;
    boolean isShowImg = false;//是否要显示报警图片

    public AlarmRecyclerAdapter(Context context, VideoEventImplement callback) {
        mContext = context;
        mInflater = LayoutInflater.from(context);
        mDatas = new ArrayList<>();
        this.mCallback = callback;
    }

    public AlarmRecyclerAdapter(Context context, VideoEventImplement callback, boolean isShowImg) {
        mContext = context;
        mInflater = LayoutInflater.from(context);
        mDatas = new ArrayList<>();
        this.mCallback = callback;
        this.isShowImg = isShowImg;
    }

    public void clearDaxta() {
        mDatas.clear();
    }

    public void addData(List<AlarmMessageTime> videoEventCloudRecordList) {
        mDatas.addAll(videoEventCloudRecordList);
    }

    public void setSelectVideoRec(AlarmMessageTime info) {
        this.mSelectInfo = info;
    }

    public void refreshSelectVideoRec(AlarmMessageTime record) {
        boolean bNeedRefresh = false;
        if (mDatas == null) {
            return;
        } else {
            if (mSelectInfo != null) {
                int totoalSec = getTotalSec(mSelectInfo);
                int curToTalsec = getTotalSec(record);
                if (Math.abs(totoalSec - curToTalsec) >= 19) {
                    mSelectInfo = null;
                    bNeedRefresh = true;
                }
            }
            AlarmMessageTime nearbyRec = findNearbyRecord(record);
            if (nearbyRec != null) {
                if (mSelectInfo == null) {
                    mSelectInfo = nearbyRec;
                    bNeedRefresh = true;
                } else {
                    if (!mSelectInfo.equals(nearbyRec)) {
                        mSelectInfo = nearbyRec;
                        bNeedRefresh = true;
                    }
                }
            }
            if (bNeedRefresh) {
                notifyDataSetChanged();
            }
        }
    }

    private AlarmMessageTime findNearbyRecord(AlarmMessageTime record) {
        if (mDatas == null)
            return null;
        for (int i = 0; i < mDatas.size(); i++) {
            AlarmMessageTime info = mDatas.get(i);
            if (Math.abs(getTotalSec(info) - getTotalSec(record)) < 19) {
                return info;
            } else if (getTotalSec(info) - getTotalSec(record) > 0) {
                return null;
            }
        }
        return null;
    }

    public int getTotalSec(AlarmMessageTime info) {
        return 3600 * info.StartHour + 60 * info.StartMinute + info.StartSecond;
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        public ViewHolder(View arg0) {
            super(arg0);
        }

        //添加包含图片的事件报警
        RelativeLayout rl_alarmImg;
        ImageView iv_border;
        SimpleDraweeView sdv_alarm;
        TextView timeText;
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
        View view = mInflater.inflate(R.layout.item_alarm,viewGroup, false);
        ViewHolder viewHolder = new ViewHolder(view);
        viewHolder.timeText = (TextView) view
                .findViewById(R.id.id_index_gallery_item_image);
        viewHolder.sdv_alarm = view.findViewById(R.id.sdv_alarm);
        viewHolder.rl_alarmImg = view.findViewById(R.id.rl_alarmImg);
        viewHolder.iv_border = view.findViewById(R.id.iv_border);
        viewHolder.iv_border.setVisibility(View.GONE);
        if (isShowImg == false) {
            viewHolder.sdv_alarm.setVisibility(View.GONE);
            viewHolder.rl_alarmImg.setVisibility(View.GONE);
            viewHolder.iv_border.setVisibility(View.GONE);
        }
        return viewHolder;
    }

    /**
     * 设置值
     */
    @Override
    public void onBindViewHolder(final ViewHolder viewHolder, int position) {
        AlarmMessageTime info = mDatas.get(position);
        String format = "%02d:%02d:%02d";
        String content = String.format(format, info.StartHour, info.StartMinute, info.StartSecond);
        viewHolder.timeText.setText(content);
        viewHolder.timeText.setTag(info);
        viewHolder.timeText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlarmMessageTime info = (AlarmMessageTime) v.getTag();
                mCallback.seekVideo(info, true);
            }
        });
        //根据报警类型显示不同的小标
        if (isShowImg == true) {
            if (info.recordType == AlarmMessageTime.TYPE_PIR || info.recordType == AlarmMessageTime.TYPE_MOVE) {
                Drawable drawable = mContext.getResources().getDrawable(R.drawable.btn_pir_status);
                drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
                viewHolder.timeText.setCompoundDrawables(drawable,
                        null, null, null);
                //设置颜色值为访客红色
                viewHolder.timeText.setTextColor(mContext.getResources().getColor(R.color.text_red));
                viewHolder.iv_border.setImageResource(R.drawable.shape_border_pir);
            } else if (info.recordType == AlarmMessageTime.TYPE_VISIT) {
                Drawable drawable = mContext.getResources().getDrawable(R.drawable.btn_visit_status);
                drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
                viewHolder.timeText.setCompoundDrawables(drawable,
                        null, null, null);
                //设置颜色值为访客黄色
                viewHolder.timeText.setTextColor(mContext.getResources().getColor(R.color.visit_yellow));
                viewHolder.iv_border.setImageResource(R.drawable.shape_border_visit);
            }
            //设置报警图片
            if (viewHolder.sdv_alarm.getTag() == null) {
                //暂时做这个处理，防止闪烁，后期填写真实的网络图片的URL
                viewHolder.sdv_alarm.setImageURI(Uri.parse(""));
            }
            //设置点击事件
            viewHolder.sdv_alarm.setTag(info);
            viewHolder.sdv_alarm.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    AlarmMessageTime info = (AlarmMessageTime) v.getTag();
                    mCallback.seekVideo(info, true);
                }
            });
        }
        if (mSelectInfo != null && mSelectInfo.StartHour == info.StartHour
                && mSelectInfo.StartMinute == info.StartMinute
                && mSelectInfo.StartSecond == info.StartSecond) {
            viewHolder.timeText.setEnabled(false);
            //边框显示
            viewHolder.iv_border.setVisibility(View.VISIBLE);
        } else {
            viewHolder.timeText.setEnabled(true);
            viewHolder.timeText.setTextColor(mContext.getResources().getColor(R.color.color_arm_status));
            //隐藏边框
            viewHolder.iv_border.setVisibility(View.GONE);
        }
    }

    public interface VideoEventImplement {
        void seekVideo(AlarmMessageTime record, boolean arm);

    }

    public int getCurPosition() {
        if (mDatas.size() == 0 || mSelectInfo == null) {
            return 0;
        }
        for (int i = 0; i < mDatas.size(); i++) {
            AlarmMessageTime info = mDatas.get(i);
            if (mSelectInfo != null && mSelectInfo.StartHour == info.StartHour
                    && mSelectInfo.StartMinute == info.StartMinute
                    && mSelectInfo.StartSecond == info.StartSecond) {
                return i;
            }
        }
        return 0;
    }
}
