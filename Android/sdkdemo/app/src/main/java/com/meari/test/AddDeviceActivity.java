package com.meari.test;

import android.content.Intent;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.meari.test.adapter.DeviceTypeAdapter;
import com.meari.test.bean.DeviceTypeInfo;
import com.meari.test.common.ActivityType;
import com.meari.test.common.StringConstants;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.BaseActivity;

import java.util.ArrayList;

import butterknife.BindView;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/7/19
 * 描    述：
 * 修订历史：
 * ================================================
 */
public class AddDeviceActivity extends BaseActivity {
    @BindView(R.id.frameRateList)
    public RecyclerView mRecyclerView;
    private ArrayList<DeviceTypeInfo> mDeviceList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_common);
        getTopTitleView();
        initArmList();
        this.mCenter.setText(getString(R.string.select_device_title));
        initView();
    }

    private void initView() {
        DeviceTypeAdapter deviceTypeAdapter = new DeviceTypeAdapter(this);
        mRecyclerView.setAdapter(deviceTypeAdapter);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        deviceTypeAdapter.setNewData(mDeviceList);
        deviceTypeAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<DeviceTypeInfo>() {
            @Override
            public void onItemClick(BaseQuickAdapter<DeviceTypeInfo, ? extends BaseViewHolder> adapter, View view, int position) {
                DeviceTypeInfo info = adapter.getItem(position);
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                if (info.getDeviceTypeId() == 2) {
                    intent.setClass(AddDeviceActivity.this, NvrAddMethodActivity.class);
                } else {
                        bundle.putInt(StringConstants.DEVICE_TYPE_ID, info.getDeviceTypeId());
                        bundle.putBoolean("ApMode", false);
                        intent.setClass(AddDeviceActivity.this, DistributionActivity.class);
                }
                intent.putExtras(bundle);
                startActivityForResult(intent, ActivityType.ACTIVITY_ADD_NVR_CAMERA);
            }
        });
    }

    private void initArmList() {
        String[] deviceList = getResources().getStringArray(R.array.add_device_list);
        mDeviceList = new ArrayList<>();
        for (int i = 0; i < deviceList.length; i++) {
            DeviceTypeInfo info = new DeviceTypeInfo();
            info.setDeviceName(deviceList[i]);
            info.setDeviceTypeId(i);
            switch (i) {
                case 0:
                    info.setDeviceImageId(R.mipmap.ic_camera);
                    break;
                case 1:
                    //门铃
                    info.setDeviceImageId(R.mipmap.ic_bell);
                    break;
                case 2:
                    //nvr
                    info.setDeviceImageId(R.mipmap.ic_square_nvr);
                    break;
                default:
                    info.setDeviceImageId(R.mipmap.ic_camera);
                    break;
            }
            mDeviceList.add(info);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_ADD_NVR_CAMERA:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK, data);
                    finish();
                }
                break;
        }
    }
}