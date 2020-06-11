package com.meari.test.device;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.Toast;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.MeariDevice;
import com.meari.sdk.callback.IDevListCallback;
import com.meari.test.R;
import com.meari.test.user.LoginActivity;

import java.util.ArrayList;
import java.util.List;

public class DeviceListActivity extends AppCompatActivity {

    private RecyclerView recyclerView;
    private DeviceListAdapter adapter;
    private List<CameraInfo> deviceList;
    private ImageView imgAdd;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_list);

        initView();

        // Connect mqtt service
        if (MeariUser.getInstance().isMqttConnected()) {
            MeariUser.getInstance().connectMqttServer(getApplication());
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        getData();
    }

    private void initView() {
        recyclerView = findViewById(R.id.recyclerView);
        deviceList = new ArrayList<>();
        adapter = new DeviceListAdapter(this, deviceList);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(RecyclerView.VERTICAL);
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(layoutManager);

        imgAdd = findViewById(R.id.img_add);
        imgAdd.setOnClickListener(v -> {
            Intent intent = new Intent(DeviceListActivity.this, AddDeviceActivity.class);
            startActivity(intent);
        });
    }

    private void getData() {
        MeariUser.getInstance().getDeviceList(new IDevListCallback() {
            @Override
            public void onSuccess(MeariDevice meariDevice) {
                Log.i("tag","--->i: ssss" );
                initList(meariDevice);
            }

            @Override
            public void onError(int i, String s) {
                Log.i("tag","--->i: " + i + "; s: " +s);
                Toast.makeText(DeviceListActivity.this, R.string.toast_fail, Toast.LENGTH_LONG).show();
            }
        });
    }

    private void initList(MeariDevice meariDevice) {
        deviceList.clear();
        deviceList.addAll(meariDevice.getIpcs());
        deviceList.addAll(meariDevice.getDoorBells());
        // if need
        deviceList.addAll(meariDevice.getChimes());
        deviceList.addAll(meariDevice.getVoiceBells());
        deviceList.addAll(meariDevice.getFourthGenerations());
        deviceList.addAll(meariDevice.getBatteryCameras());
        deviceList.addAll(meariDevice.getFlightCameras());
        deviceList.addAll(meariDevice.getNvrs());

        adapter.notifyDataSetChanged();
    }
}
