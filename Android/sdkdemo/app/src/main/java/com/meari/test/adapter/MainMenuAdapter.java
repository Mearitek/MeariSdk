package com.meari.test.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.test.R;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/24
 * 描    述：菜单栏adpter
 * 修订历史：
 * ================================================
 */

public class MainMenuAdapter extends RecyclerView.Adapter<MainMenuAdapter.ViewHolder> {
    private onMainMenuItemClickListener mItemClickListener;
    private int mSelect = 0;
    private Context mContext;
    private String[] menus;
    private int[] mDrawables = { R.mipmap.ic_device_n, R.mipmap.ic_message_n, R.mipmap.ic_friend_n,
            R.mipmap.ic_more_n};
    private int[] mSelDrawables = {  R.mipmap.ic_device_p, R.mipmap.ic_message_p,
            R.mipmap.ic_friend_p, R.mipmap.ic_more_p};
    private boolean mIsLastVersion = false;
    private boolean bHasMeg = false;

    public MainMenuAdapter(Context context, onMainMenuItemClickListener itemClickListener) {
        this.mContext = context;
        this.menus = mContext.getResources().getStringArray(R.array.menu_list);
        this.mItemClickListener = itemClickListener;
    }
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View convertView = LayoutInflater.from(mContext).inflate(R.layout.item_menu, null);
        ViewHolder viewHolder = new ViewHolder(convertView);
        viewHolder.imageView = (ImageView) convertView.findViewById(R.id.menu_image);
        viewHolder.textView = (TextView) convertView.findViewById(R.id.menu_text);
        viewHolder.layout = convertView.findViewById(R.id.menu_layout);
        viewHolder.hotImage = convertView.findViewById(R.id.msgIsReadFlag);
        convertView.setTag(viewHolder);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        viewHolder.textView.setText(menus[position]);
        if (position == getSelect()) {
            viewHolder.imageView.setImageResource(mSelDrawables[position]);
            viewHolder.textView.setTextColor(Color.parseColor("#ffffff"));
            viewHolder.itemView.setBackgroundResource(R.mipmap.bg_item_menu);

        } else {
            viewHolder.itemView.setBackgroundResource(0);
            viewHolder.imageView.setImageResource(mDrawables[position]);
            viewHolder.textView.setTextColor(Color.parseColor("#9a9a9a"));
        }
        if (this.mIsLastVersion && menus[position].equals(mContext.getString(R.string.more_title))) {
            viewHolder.hotImage.setVisibility(View.VISIBLE);
        } else if (this.bHasMeg && menus[position].equals(mContext.getString(R.string.message_title))) {
            viewHolder.hotImage.setVisibility(View.VISIBLE);
        } else
            viewHolder.hotImage.setVisibility(View.GONE);
        viewHolder.layout.setTag(position);
        viewHolder.layout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int tag = (int) v.getTag();
                mItemClickListener.onMainMenuItemClick(tag);
            }
        });

    }

    @Override
    public int getItemCount() {
        return this.menus == null ? 0 : this.menus.length;
    }

    public int getSelect() {
        return mSelect;
    }

    public void setSelect(int mSelect) {
        this.mSelect = mSelect;
    }

    public boolean isIsLastVersion() {
        return mIsLastVersion;
    }

    public void setIsLastVersion(boolean mIsLastVersion) {
        this.mIsLastVersion = mIsLastVersion;
    }

    public String getTitle(int position) {
        return menus[position];
    }

    public void setbHasMeg(boolean bHasMeg) {
        this.bHasMeg = bHasMeg;
    }

    public int getMessageSelect() {
        for (int i = 0 ; i < menus.length ;i++)
        {
            if (getTitle(i).equals(mContext.getString(R.string.message_title)))
                return i;
        }
        return 0;
    }
    public int getDeviceSelect() {
        for (int i = 0 ; i < menus.length ;i++)
        {
            if (getTitle(i).equals(mContext.getString(R.string.message_title)))
                return i;
        }
        return 0;
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        ImageView imageView;
        TextView textView;
        View layout;
        View hotImage;

        public ViewHolder(View itemView) {
            super(itemView);
        }
    }

    /**
     * Created by Administrator on 2016/10/29.
     */

    public interface onMainMenuItemClickListener {
        void onMainMenuItemClick(int position);
    }
}

