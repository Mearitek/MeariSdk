package com.meari.test.device;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.meari.sdk.MeariDeviceController;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.DeviceParams;
import com.meari.sdk.bean.DeviceUpgradeInfo;
import com.meari.sdk.bean.SDCardInfo;
import com.meari.sdk.callback.ICheckNewFirmwareForDevCallback;
import com.meari.sdk.callback.IDeviceUpgradeCallback;
import com.meari.sdk.callback.IDeviceUpgradePercentCallback;
import com.meari.sdk.callback.IGetDeviceParamsCallback;
import com.meari.sdk.callback.ISDCardFormatCallback;
import com.meari.sdk.callback.ISDCardFormatPercentCallback;
import com.meari.sdk.callback.ISDCardInfoCallback;
import com.meari.sdk.callback.ISetDeviceParamsCallback;
import com.meari.test.R;

public class DeviceSettingActivity extends AppCompatActivity {

    private Switch switchLed, switchMotion;
    private EditText edtMotionSensitivity;
    private TextView tvMotionSensitivity, tvFormatPercent, tvCapacity, tvRemainingCapacity, tvUpgradePercent;
    private Button btnMotionSensitivity, btnFormat, btnUpgrade;

    private CameraInfo cameraInfo;
    private DeviceParams mDeviceParams;
    private MeariDeviceController deviceController;
    private SDCardInfo mSdCardInfo;
    private DeviceUpgradeInfo mUpgradeInfo;
    private boolean canUpgrade;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_setting);
        initView();
        initData();
    }

    private void initView() {
        switchLed = findViewById(R.id.switch_led);
        switchMotion = findViewById(R.id.switch_motion);
        edtMotionSensitivity = findViewById(R.id.edt_motion_sensitivity);
        tvMotionSensitivity = findViewById(R.id.tv_motion_sensitivity);
        btnMotionSensitivity = findViewById(R.id.btn_motion_sensitivity);
        tvCapacity = findViewById(R.id.tv_capacity);
        tvRemainingCapacity = findViewById(R.id.tv_remaining_capacity);
        tvFormatPercent = findViewById(R.id.tv_format_percent);
        btnFormat = findViewById(R.id.btn_format);
        btnUpgrade = findViewById(R.id.btn_upgrade_firmware);
        tvUpgradePercent = findViewById(R.id.tv_upgrade_percent);


        switchLed.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (buttonView.isEnabled()) {
                setLedEnable(isChecked ? 1 : 0);
            }
        });

        switchMotion.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (buttonView.isEnabled()) {
                setMotionEnable(isChecked ? 1 : 0);
            }
        });

        btnMotionSensitivity.setOnClickListener(v -> {
            String s = edtMotionSensitivity.getEditableText().toString().trim();
            setMotionSensitivity(Integer.valueOf(s));
        });

        btnFormat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                formatSdCard();
            }
        });

        btnUpgrade.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mUpgradeInfo != null && mUpgradeInfo.getUpgradeStatus() > 0) {
                    startDeviceUpgrade();
                }
            }
        });
    }

    private void initData() {
        // get from cache
        cameraInfo = MeariUser.getInstance().getCameraInfo();
        deviceController = MeariUser.getInstance().getController();

        getDeviceParam();
        getSdCardData();
    }

    private void getDeviceParam() {
        MeariUser.getInstance().getDeviceParams(new IGetDeviceParamsCallback() {
            @Override
            public void onSuccess(DeviceParams deviceParams) {
                runOnUiThread(() -> {
                    mDeviceParams = deviceParams;
                    initDeviceParams();
                });
            }

            @Override
            public void onFailed(int i, String s) {

            }
        });
    }

    private void initDeviceParams() {
        if (mDeviceParams != null) {
            switchLed.setEnabled(false);
            switchLed.setChecked(mDeviceParams.getLedEnable() == 1);
            switchLed.setEnabled(true);

            switchMotion.setEnabled(false);
            switchMotion.setChecked(mDeviceParams.getMotionDetEnable() == 1);
            switchMotion.setEnabled(true);

            initMotionDetSensitivity();
        }

        checkNewFirmware();
    }

    private void initMotionDetSensitivity() {
        if (mDeviceParams != null) {
            int sen = mDeviceParams.getMotionDetSensitivity();
            edtMotionSensitivity.setText(String.valueOf(sen));
            if (sen == 0) {
                tvMotionSensitivity.setText("low");
            } else if (sen == 1) {
                tvMotionSensitivity.setText("mid");
            } else if (sen == 2) {
                tvMotionSensitivity.setText("high");
            }
        }
    }

    private void initSDCardInfo() {
        if (mSdCardInfo != null) {
            tvCapacity.setText(mSdCardInfo.getSdCapacity());
            tvRemainingCapacity.setText(mSdCardInfo.getSdRemainingCapacity());
        }
    }

    private Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(@NonNull Message msg) {
            return false;
        }
    });

    private void showFormatPercent(int percent) {
        if (percent >= 0 && percent < 100) {
            tvFormatPercent.setText(percent + "%");
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    getFormatPercent();
                }
            }, 1000);
        } else {
            tvFormatPercent.setText("100%");
        }
    }

    private void showUpgradePercent(int percent) {
        if (percent >= 0 && percent < 100) {
            tvUpgradePercent.setText(percent + "%");
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    getFormatPercent();
                }
            }, 1000);
        } else {
            tvUpgradePercent.setText("100%");
        }
    }

    private void toastSuccess() {
        runOnUiThread(() -> Toast.makeText(DeviceSettingActivity.this, R.string.toast_success, Toast.LENGTH_LONG).show());
    }

    private void toastFailed() {
        runOnUiThread(() -> Toast.makeText(DeviceSettingActivity.this, R.string.toast_fail, Toast.LENGTH_LONG).show());

    }

    private void setLedEnable(int enable) {
        // 0-close; 1-open;
        MeariUser.getInstance().setLED(enable, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                mDeviceParams.setLedEnable(enable);
                toastSuccess();
            }

            @Override
            public void onFailed(int i, String s) {
                toastFailed();
            }
        });
    }

    private void setMotionEnable(int enable) {
        // 0-close; 1-open;
        MeariUser.getInstance().setMotionDetection(enable, mDeviceParams.getMotionDetSensitivity(), new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                mDeviceParams.setMotionDetEnable(enable);
                toastSuccess();
            }

            @Override
            public void onFailed(int i, String s) {
                toastFailed();
            }
        });
    }

    private void setMotionSensitivity(int sensitivity) {
        // 0-low; 1-mid; 2-high
        MeariUser.getInstance().setMotionDetection(mDeviceParams.getMotionDetEnable(), sensitivity, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                toastSuccess();
                runOnUiThread(() -> {
                    mDeviceParams.setMotionDetSensitivity(sensitivity);
                    initMotionDetSensitivity();
                });
            }

            @Override
            public void onFailed(int i, String s) {
                toastFailed();
            }
        });
    }


    private void getSdCardData() {
        MeariUser.getInstance().getSDCardInfo(new ISDCardInfoCallback() {
            @Override
            public void onSuccess(SDCardInfo sdCardInfo) {
                toastSuccess();
                runOnUiThread(() -> {
                    mSdCardInfo = sdCardInfo;
                    initSDCardInfo();
                });
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                toastFailed();
            }
        });
    }

    private void formatSdCard() {
        MeariUser.getInstance().startSDCardFormat(new ISDCardFormatCallback() {
            @Override
            public void onSuccess() {
                getFormatPercent();
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                toastFailed();
            }
        });
    }

    private void getFormatPercent() {
        MeariUser.getInstance().getSDCardFormatPercent(new ISDCardFormatPercentCallback() {
            @Override
            public void onSuccess(int percent) {
                runOnUiThread(() -> showFormatPercent(percent));
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                toastFailed();
            }
        });
    }


    public void checkNewFirmware() {
        String firmwareVersion = mDeviceParams.getFirmwareCode();
        MeariUser.getInstance().checkNewFirmwareForDev(firmwareVersion, cameraInfo.getSnNum(), cameraInfo.getTp(),
                new ICheckNewFirmwareForDevCallback() {
                    @Override
                    public void onSuccess(DeviceUpgradeInfo info) {
                        mUpgradeInfo = info;
                    }

                    @Override
                    public void onError(int code, String error) {
                        toastFailed();
                    }
                });
    }

    public void startDeviceUpgrade() {
        MeariUser.getInstance().startDeviceUpgrade(mUpgradeInfo.getUpgradeUrl(), mUpgradeInfo.getNewVersion(),
                new IDeviceUpgradeCallback() {
                    @Override
                    public void onSuccess() {
                        getDeviceUpgradePercent();
                    }

                    @Override
                    public void onFailed(int errorCode, String errorMsg) {
                        toastFailed();
                    }
                });
    }

    public void getDeviceUpgradePercent() {
        MeariUser.getInstance().getDeviceUpgradePercent(new IDeviceUpgradePercentCallback() {
            @Override
            public void onSuccess(int percent) {
                runOnUiThread(() -> showUpgradePercent(percent));
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                toastFailed();
            }
        });
    }

    @Override
    public void finish() {
        setResult(RESULT_OK);
        super.finish();
    }
}
