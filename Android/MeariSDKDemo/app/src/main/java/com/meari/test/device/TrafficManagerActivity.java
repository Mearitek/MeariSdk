package com.meari.test.device;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.ClipboardManager;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.callback.IStringResultCallback;
import com.meari.sdk.utils.GsonUtil;
import com.meari.test.R;
import com.meari.test.bean.TrafficNumberBean;
import com.meari.test.bean.TrafficPacketBean;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 *
 */
public class TrafficManagerActivity extends AppCompatActivity {
    private final int GET_4G_TRAFFIC_PACKET_SUCCESS=1001;
    private final int GET_4G_TRAFFIC_PACKET_FAIL=1002;
    private final int GET_4G_TRAFFIC_NUMBER_SUCCESS=1003;
    private final int GET_4G_TRAFFIC_NUMBER_FAIL=1004;
    private final int SET_TRAFFIC_TRIAL_SUCCESS=1005;
    private final int SET_TRAFFIC_TRIAL_FAIL=1006;

    private TrafficPacketBean response;
    private List<TrafficPacketBean.PackageListDTO> packagePayList=new ArrayList<>();
    public CameraInfo cameraInfo;
    private TrafficNumberBean trafficNumberBean;
    private boolean isNetWorkBad;
    private List<TrafficNumberBean.ResultDataDTO.PreActivePackageListDTO> preActivePackageList=new ArrayList<>();
    private List<TrafficNumberBean.ResultDataDTO.PreActivePackageListDTO> preActivePackageTotalList=new ArrayList<>();

    private String deviceID;
    private TextView tv_msg_trial;
    private TextView tv_msg_packet;
    private TextView tv_simId;
    private TextView tv_msg_used;
    private TextView tv_msg_no_used;
    private Button btn_trial;
    private String uuid="";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_traffic_manager);
        initView();
    }

    public void initView() {
        tv_msg_trial = (TextView)findViewById(R.id.tv_msg_trial);
        tv_msg_packet = (TextView)findViewById(R.id.tv_msg_packet);
        tv_simId = (TextView)findViewById(R.id.tv_simId);
        tv_msg_used = (TextView)findViewById(R.id.tv_msg_used);
        tv_msg_no_used = (TextView)findViewById(R.id.tv_msg_no_used);
        btn_trial = (Button) findViewById(R.id.btn_trial);
        initData();
    }

    public void initData() {
        cameraInfo = MeariUser.getInstance().getCameraInfo();
        deviceID = cameraInfo.getDeviceID();
        getTrafficPacket(null,deviceID);
        getTrafficNumber(null,deviceID);

    }
    //查询流量
    private void getTrafficNumber(String uuid,String deviceId){
        MeariUser.getInstance().getTrafficNumber(uuid,deviceId, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                if(!TextUtils.isEmpty(result)) {
                    trafficNumberBean = GsonUtil.fromJson(result, TrafficNumberBean.class);
                    if(trafficNumberBean!=null){
                        mHandler.sendEmptyMessage(GET_4G_TRAFFIC_NUMBER_SUCCESS);
                    }
                }

            }

            @Override
            public void onError(int errorCode, String errorMsg) {
                mHandler.sendEmptyMessage(GET_4G_TRAFFIC_NUMBER_FAIL);
            }
        });
    }

    private void getTrafficPacket(String uuid,String deviceId){
        if (MeariUser.getInstance().getUserInfo().getCountryCode().equals("CN")) {
            //alipay
            MeariUser.getInstance().get4GDeviceFlowV2(uuid,deviceId, "1",new IStringResultCallback() {
                @Override
                public void onSuccess(String result) {
                    if(!TextUtils.isEmpty(result)) {
                        response = GsonUtil.fromJson(result, TrafficPacketBean.class);
                        if(response!=null){
                            mHandler.sendEmptyMessage(GET_4G_TRAFFIC_PACKET_SUCCESS);
                        }
                    }
                }
                @Override
                public void onError(int errorCode, String errorMsg) {
                    mHandler.sendEmptyMessage(GET_4G_TRAFFIC_PACKET_FAIL);
                }
            });

        } else {
            //paypal
            MeariUser.getInstance().get4GDeviceFlow(uuid,deviceId, new IStringResultCallback() {
                @Override
                public void onSuccess(String result) {
                    if(!TextUtils.isEmpty(result)) {
                        response = GsonUtil.fromJson(result, TrafficPacketBean.class);
                        if(response!=null){
                            mHandler.sendEmptyMessage(GET_4G_TRAFFIC_PACKET_SUCCESS);
                        }
                    }
                }

                @Override
                public void onError(int errorCode, String errorMsg) {
                    mHandler.sendEmptyMessage(GET_4G_TRAFFIC_PACKET_FAIL);
                }
            });

        }
    }

    @SuppressLint("HandlerLeak")
    Handler mHandler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            switch (msg.what) {
                case GET_4G_TRAFFIC_PACKET_SUCCESS:
                    dealPacket();
                    break;
                case GET_4G_TRAFFIC_PACKET_FAIL:
                    break;
                case GET_4G_TRAFFIC_NUMBER_SUCCESS:
                    dealTrafficNumber();
                    break;
                case GET_4G_TRAFFIC_NUMBER_FAIL:
                    break;
                case SET_TRAFFIC_TRIAL_SUCCESS:
                    break;
                case SET_TRAFFIC_TRIAL_FAIL:
                    break;
                default:
                    break;
            }
            return false;
        }
    });
    //Data
    private void dealTrafficNumber() {
        if(!TextUtils.isEmpty(trafficNumberBean.getSimID())){
            tv_simId.setText("SIMID:"+trafficNumberBean.getSimID());
            tv_simId.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                        ClipboardManager cm = (ClipboardManager) TrafficManagerActivity.this.getSystemService(Context.CLIPBOARD_SERVICE);
                        // 将文本内容放到系统剪贴板里。
                        cm.setText(trafficNumberBean.getSimID());
                }
            });
        }
        //used
        if(trafficNumberBean.getResultData()!=null&&trafficNumberBean.getResultData().getSubscriberQuota()!=null){
            TrafficNumberBean.ResultDataDTO.SubscriberQuotaDTO subscriberQuota = trafficNumberBean.getResultData().getSubscriberQuota();
            tv_msg_used.setText("Data used:"+"-----Packet Name"+subscriberQuota.getMoney()+getDataToPacket(subscriberQuota.getMearlType())+
            "\n-------Expiration Time"+toNYR(Long.parseLong(subscriberQuota.getExpireTime()))+
            "\n-------Total Data"+subscriberQuota.getQtavalue()+"MB"+
            "\n-------Used Data"+subscriberQuota.getQtaconsumption()+"MB"+
            "\n-------Remain Data"+subscriberQuota.getQtabalance()+"MB");
        }

        //no use
        if(trafficNumberBean.getResultData().getPreActivePackageList()!=null&&trafficNumberBean.getResultData().getPreActivePackageList().size()>0){
            preActivePackageList.clear();
            preActivePackageTotalList.clear();
            preActivePackageList.addAll(trafficNumberBean.getResultData().getPreActivePackageList());
            preActivePackageTotalList.addAll(trafficNumberBean.getResultData().getPreActivePackageList());
            if(preActivePackageList.size()>0) {
                TrafficNumberBean.ResultDataDTO.PreActivePackageListDTO preActivePackageListDTO = preActivePackageList.get(0);
                tv_msg_no_used.setText("Data used:"+"-----Packet Name"+preActivePackageListDTO.getMoney()+getDataToPacket(preActivePackageListDTO.getMealType())+
                        "\n-------Expiration Time"+toNYR(Long.parseLong(preActivePackageListDTO.getExpireTime()))+
                                "\n-------Total Data"+preActivePackageListDTO.getQuantity()+getTrafficUnit(preActivePackageListDTO.getTrafficPackage()));
            }
        }
    }

    //处理套餐
    private void dealPacket() {
        packagePayList = response.getPackageList();
        //trial  Trial package
        setTrial();
        if(packagePayList!=null&&packagePayList.size()>0) {
            //remove trial packet
            List<TrafficPacketBean.PackageListDTO> packageList = response.getPackageList();
            for (TrafficPacketBean.PackageListDTO packages : packageList) {
                if (packages.getType().equals("0")) {

                    packagePayList.remove(packages);
                    break;
                }
            }
            TrafficPacketBean.PackageListDTO exPackets = null;
            if (packageList.size() > 0) {
                exPackets = packagePayList.get(0);
                if (exPackets != null) {
                    String Valid = "";
                    if (exPackets.getMealType().equalsIgnoreCase("s")) {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "90");
                    } else if (exPackets.getMealType().equalsIgnoreCase("x")) {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "180");
                    } else if (exPackets.getMealType().equalsIgnoreCase("y")) {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "365");
                    } else if (exPackets.getMealType().equalsIgnoreCase("w")) {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "7");
                    } else {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "30");
                    }

                    String quantity = "";
                    if (exPackets.getUnlimited() == 1) {
                        quantity = "Unlimited";
                    } else {
                        quantity = exPackets.getQuantity() + getTrafficUnit(exPackets.getTrafficPackage());
                    }
                    tv_msg_packet.setText(quantity + "------" + Valid);
                }
            }
        }
    }
    /**
     *
     */
    private void setTrial() {
        if (response.isTrialStatus()) {
            //Existence trial package
            List<TrafficPacketBean.PackageListDTO> packageList = response.getPackageList();
            TrafficPacketBean.PackageListDTO exPackets = null;
            if (packageList.size() > 0) {
                for (TrafficPacketBean.PackageListDTO packages : packageList) {
                    if (packages.getType().equals("0")) {
                        //0 is trial  ,other are paid package.
                        exPackets = packages;
                        break;
                    }
                }
                if (exPackets != null) {
                    String Valid = "";
                    if (exPackets.getMealType().equalsIgnoreCase("s")) {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "90");
                    } else if (exPackets.getMealType().equalsIgnoreCase("x")) {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "180");
                    } else if (exPackets.getMealType().equalsIgnoreCase("y")) {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "365");
                    } else if (exPackets.getMealType().equalsIgnoreCase("w")) {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "7");
                    } else {
                        Valid = String.format(Locale.CHINA, "Valid for %s days", "30");
                    }

                    String quantity = "";
                    if (exPackets.getUnlimited() == 1) {
                        quantity = "Unlimited";
                    } else {
                        quantity = exPackets.getQuantity() + getTrafficUnit(exPackets.getTrafficPackage());
                    }

                    tv_msg_trial.setText(quantity + "------" + Valid);

                    btn_trial.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            getTrafficTrial();
                        }
                    });
                }
            }
        }
    }
    //试用开通
    private void getTrafficTrial(){

        MeariUser.getInstance().getTrafficTrial(uuid,deviceID,  new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                mHandler.sendEmptyMessage(SET_TRAFFIC_TRIAL_SUCCESS);
            }

            @Override
            public void onError(int errorCode, String errorMsg) {
                mHandler.sendEmptyMessage(SET_TRAFFIC_TRIAL_FAIL);
            }
        });
    }

    private String getTrafficUnit(String trafficPackage){
        if(trafficPackage.equalsIgnoreCase("g")){
            return "GB";
        }else {
            return "MB";
        }
    }
    //Access packages are monthly, annual, semi-annual and seasonal
    private String getDataToPacket(String mealType){
        if(!TextUtils.isEmpty(mealType)) {
            if (mealType.equalsIgnoreCase("s")) {
                return "/season";
            } else if (mealType.equalsIgnoreCase("x")) {
                return "/Half A Year";
            } else if (mealType.equalsIgnoreCase("y")) {
                return "/year";
            } else if (mealType.equalsIgnoreCase("w")) {
                return "/week";
            } else {
                return "/month";
            }
        }else {
            return "/month";
        }
    }

    public static String toNYR(long millis) {
        Date nowTime = new Date(millis);
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String timeStr = df.format(nowTime);
        return timeStr;
    }
}