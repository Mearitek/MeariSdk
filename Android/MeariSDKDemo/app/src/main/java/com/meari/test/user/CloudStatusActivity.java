package com.meari.test.user;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.CloudServiceInfo;
import com.meari.sdk.bean.OrderInfo;
import com.meari.sdk.callback.ICloudServiceCallback;
import com.meari.sdk.callback.IOrderInfoCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.test.R;

import java.util.ArrayList;

public class CloudStatusActivity extends AppCompatActivity {

    private TextView tv_status;
    private Button btn_buy;
    private CameraInfo mCameraInfo;
    private int cloudStatus;
    private CloudServiceInfo mCloudServiceInfo;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cloud_status);
        initData();
        initView();
    }

    private void initData() {
        if (getIntent().getExtras() != null) {
            mCameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        }
        if (mCameraInfo == null) {
            return;
        }

        cloudStatus = mCameraInfo.getCloudStatus();
    }

    private void initView() {
        tv_status = findViewById(R.id.tv_status);
        btn_buy = findViewById(R.id.btn_buy);
        switch (cloudStatus) {
            case 1:
                tv_status.setText("Try cloud services for free");
                btn_buy.setText("Free trial");
                break;
            case 2:
                tv_status.setText("nonactivated");
                btn_buy.setText("Buy");
                break;
            case 3:
                tv_status.setText("activated");
                btn_buy.setText("Renew");
                break;
            case 4:
                tv_status.setText("Cloud storage service expired");
                btn_buy.setText("Renew");
                break;
            default:
        }

        btn_buy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (cloudStatus == 1) {
                    // Free trial
                    freeTrialCloudService();
                } else {
                    // buy or renew
                    Intent intent = new Intent(CloudStatusActivity.this, BuyCloudServiceActivity.class);
                    Bundle bundle = new Bundle();
                    bundle.putSerializable("CameraInfo", mCameraInfo);
                    bundle.putSerializable("storageEvent", mCloudServiceInfo.getEventCloudPriceInfo());
                    bundle.putSerializable("storageContinue", mCloudServiceInfo.getContinueCloudPriceInfo());
//                    bundle.putInt("buyType", buyType);
//                    bundle.putInt("recordType", recordType);
//                    bundle.putInt("recordTimeType", recordTimeType);
//                    bundle.putInt("amount", amount);
//                    bundle.putString("money", price.toString());
                    intent.putExtras(bundle);
                    startActivity(intent);
                }
            }
        });

        getCloudServiceInfo();
    }

    private void freeTrialCloudService() {
        MeariUser.getInstance().freeTrialCloudService(mCameraInfo.getDeviceID(), new IResultCallback() {
            @Override
            public void onSuccess() {
                cloudStatus = 3;
                mCameraInfo.setCloudStatus(3);
                new Handler().postDelayed(() -> {
                    getCloudServiceInfo();
                }, 5000);
            }

            @Override
            public void onError(int code, String error) {

            }
        });
    }

    private void getCloudServiceInfo() {
        MeariUser.getInstance().getCloudServiceInfo(mCameraInfo.getDeviceID(), new ICloudServiceCallback() {
            @Override
            public void onSuccess(CloudServiceInfo serviceInfo) {
                mCloudServiceInfo = serviceInfo;
            }

            @Override
            public void onError(int code, String error) {

            }
        });
    }

    private void getOrderInfo() {
        MeariUser.getInstance().getOrderInfo(mCameraInfo.getDeviceID(), new IOrderInfoCallback() {
            @Override
            public void onSuccess(ArrayList<OrderInfo> arrayList) {

            }

            @Override
            public void onError(int i, String s) {

            }
        });
    }


}