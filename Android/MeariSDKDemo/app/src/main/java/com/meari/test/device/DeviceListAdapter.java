package com.meari.test.device;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.meari.sdk.bean.CameraInfo;
import com.meari.test.R;

import java.util.List;

public class DeviceListAdapter extends RecyclerView.Adapter<DeviceListAdapter.DeviceHolder> {

    private Context context;
    private List<CameraInfo> deviceList;

    public DeviceListAdapter(Context context, List<CameraInfo> deviceList) {
        this.context = context;
        this.deviceList = deviceList;
    }

    @NonNull
    @Override
    public DeviceHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_device_list, parent, false);
        return new DeviceHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull DeviceHolder holder, int position) {
        CameraInfo cameraInfo = deviceList.get(position);
        Glide.with(context).load(cameraInfo.getDeviceIcon()).asBitmap().into(holder.imgDeviceIcon);
        holder.tvDeviceName.setText(cameraInfo.getDeviceName());
        holder.deviceView.setOnClickListener(v -> {
            Intent intent = new Intent(context, DeviceMonitorActivity.class);
            Bundle bundle = new Bundle();
            bundle.putSerializable("cameraInfo", deviceList.get(position));
            intent.putExtras(bundle);
            context.startActivity(intent);
        });
    }

    @Override
    public int getItemCount() {
        return deviceList.size();
    }

    class DeviceHolder extends RecyclerView.ViewHolder {
        View deviceView;
        ImageView imgDeviceIcon;
        TextView tvDeviceName;
        public DeviceHolder(@NonNull View itemView) {
            super(itemView);
            deviceView = itemView;
            imgDeviceIcon = itemView.findViewById(R.id.img_device_icon);
            tvDeviceName = itemView.findViewById(R.id.tv_device_name);
        }
    }
}
