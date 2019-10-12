package com.meari.test;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.NVRInfo;
import com.meari.sdk.callback.IResultCallback;
import com.meari.sdk.common.DeviceType;
import com.meari.test.common.ActivityType;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.EmojiFilter;
import com.meari.test.utils.NetUtil;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class NVRSettingActivity extends BaseActivity {
    private EditText mAliasEdit;
    private NVRInfo mInfo;
    private TextView mVersionText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_nvr_setting);
        initData();
        initView();
    }

    private void initView() {
        TextView uuid = findViewById(R.id.uuid_text);
        uuid.setText(mInfo.getSnNum());
        this.mCenter.setText(getString(R.string.settings_title));
        this.mRightBtn.setImageResource(R.drawable.btn_delete);
        this.mRightBtn.setVisibility(View.VISIBLE);
        int pad = DisplayUtil.dip2px(this, 13);
        this.mRightBtn.setPadding(pad, pad, pad, pad);
        TextView account =  findViewById(R.id.useraccount_text);
        account.setText(mInfo.getUserAccount());
        findById();
    }

    private void initData() {
        Intent intent = getIntent();
        mInfo = (NVRInfo) intent.getExtras().getSerializable("NVRInfo");
    }

    private void findById() {
        mAliasEdit =findViewById(R.id.setting_aliasText);
        mVersionText =  findViewById(R.id.version_text);
        mAliasEdit.setText(mInfo.getDeviceName());
        mAliasEdit.requestFocus();
        if (this.mInfo.getUserID() == MeariUser.getInstance().getUserInfo().getUserID()) {
            mAliasEdit.addTextChangedListener(new TextWatcher() {
                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    if (s.length() > 0) {
                        if (s.equals(mInfo.getDeviceName())) {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
                        } else {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.VISIBLE);
                        }
                    }
                }

                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void afterTextChanged(Editable s) {
                }
            });
            mAliasEdit.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (mAliasEdit.getText().toString().trim().length() > 0) {
                        if (mAliasEdit.getText().toString().trim().equals(mInfo.getDeviceName())) {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
                        } else {
                            findViewById(R.id.setting_alias_ok).setVisibility(View.VISIBLE);
                        }
                    }
                }
            });
        }
        if (this.mInfo.getUserID() != MeariUser.getInstance().getUserInfo().getUserID()) {
            this.mAliasEdit.setEnabled(false);
            findViewById(R.id.setting_alias_ok).setVisibility(View.GONE);
            findViewById(R.id.share_layout).setVisibility(View.GONE);
        }
        setDviceVersion();
    }

    @OnClick(R.id.update_device_layout)
    public void onUpdateClick() {
        if (this.mInfo.getUserID() != MeariUser.getInstance().getUserInfo().getUserID()) {
            CommonUtils.showToast(R.string.pps_cant_noset);
            return;
        }
        Intent intent = new Intent();
        intent.setClass(this, NVRVersionActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("NVRInfo", mInfo);
        intent.putExtras(bundle);
        startActivity(intent);
    }

    @OnClick(R.id.sd_layout)
    public void onSdCardSwiftClick() {

        if (this.mInfo.getUserID() != MeariUser.getInstance().getUserInfo().getUserID()) {
            CommonUtils.showToast(R.string.pps_cant_noset);
            return;
        }
        Intent intent = new Intent();
        intent.setClass(this, FormatNvrActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("NVRInfo", mInfo);
        intent.putExtras(bundle);
        startActivityForResult(intent, ActivityType.ACTIVITY_FORMATSD);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putInt("type", 0);
            bundle.putSerializable("Camera", this.mInfo);
            intent.putExtras(bundle);
            setResult(RESULT_OK, intent);
            finish();
            return super.onKeyDown(keyCode, event);
        }
        return super.onKeyDown(keyCode, event);
    }


    @OnClick(R.id.camera_layout)
    public void onCameraListClick() {

        Intent intent = new Intent();
        intent.setClass(this, CameraListActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("NVRInfo", mInfo);
        intent.putExtras(bundle);
        startActivity(intent);
    }

    @OnClick(R.id.share_layout)
    public void onShareClick() {
        Intent intent = new Intent();
        intent.setClass(this, ShareNvrActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable("nvrInfo", mInfo);
        intent.putExtras(bundle);
        startActivity(intent);
    }

    @OnClick(R.id.submitRegisterBtn)
    public void showDilog() {
        CommonUtils.showDlg(this, getString(R.string.app_meari_name), getString(R.string.sure_delete),
                getString(R.string.ok), positiveClick,
                getString(R.string.cancel), negeclick, true);
    }

    private DialogInterface.OnClickListener positiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            postDelteDevice();
        }
    };
    private DialogInterface.OnClickListener negeclick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };

    @OnClick(R.id.setting_alias_ok)
    public void postEditname() {
        if (this.mInfo.getUserID() != MeariUser.getInstance().getUserInfo().getUserID()) {
            CommonUtils.showToast(R.string.pps_cant_noset);
            return;
        }
        String deviceName = mAliasEdit.getText().toString().trim();
        if (deviceName == null || deviceName.length() == 0) {
            CommonUtils.showToast(getString(R.string.deviceIsNull));
            return;
        }
        if (!EmojiFilter.isNormalString(deviceName)) {
            CommonUtils.showToast(getString(R.string.name_format_error));
            return;
        }

        mAliasEdit.setText(deviceName);
        startProgressDialog(getString(R.string.pps_waite));
        MeariUser.getInstance().renameDeviceNickname(this.mInfo.getDeviceID(), DeviceType.NVR,deviceName, this ,new IResultCallback() {
            @Override
            public void onSuccess() {
                stopProgressDialog();
                showToast(getString(R.string.update_device_suc));
                mInfo.setDeviceName(mAliasEdit.getText().toString());
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                showToast(error);
            }
        });

    }

    private void postDelteDevice() {
        if (!NetUtil.isNetworkAvailable()) {
            CommonUtils.showToast(getString(R.string.network_unavailable));
            return;
        }
        startProgressDialog(getString(R.string.pps_waite));
        MeariUser.getInstance().removeDevice(mInfo.getDeviceID(), DeviceType.NVR,this , new IResultCallback() {
            @Override
            public void onSuccess() {
                stopProgressDialog();
                Intent intent = new Intent();
                Bundle bundle = new Bundle();
                bundle.putInt("type", 1);
                bundle.putSerializable(StringConstants.NVR_INFO, mInfo);
                intent.putExtras(bundle);
                setResult(RESULT_OK, intent);
                finish();
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                showToast(error);
            }
        });

    }
    public void setStatus(String status) {
        setDviceVersion();
    }


    private void setDviceVersion() {
        findViewById(R.id.version_loading).setVisibility(View.GONE);
        if (mInfo.getNvrVersionID() != null) {
            String[] versionList = mInfo.getNvrVersionID().split("-");
            if (versionList.length == 0) {
                mVersionText.setText(getString(R.string.fail));
            } else {
                mVersionText.setText(versionList[versionList.length - 1]);
            }
        } else {
            mVersionText.setText(getString(R.string.fail));
        }

        if (mInfo.isUpdateVersion()) {
            findViewById(R.id.update_hot).setVisibility(View.VISIBLE);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            default:
                break;
        }
    }

    @Override
    public void finish() {
        super.finish();
        if (CommonUtils.getSdkNVRNativeUtil() == null || CommonUtils.getSdkNVRNativeUtil().getCameraInfo() == null) {
            return;
        }
        CommonUtils.getSdkNVRNativeUtil().disconnectIPC(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {

            }

            @Override
            public void PPFailureError(String errorMsg) {

            }
        });
        CommonUtils.setSdkUtil(null);
    }

}

