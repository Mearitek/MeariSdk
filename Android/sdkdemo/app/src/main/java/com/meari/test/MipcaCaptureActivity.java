package com.meari.test;

import com.meari.test.utils.BaseActivity;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/27
 * 描    述：扫描二维码界面
 * 修订历史：
 * ================================================
 */

public class MipcaCaptureActivity extends BaseActivity {
//    private BaseDeviceInfo mInfo;
//    private CaptureFragment captureFragment;
//    private String mTp;
//
//    @Override
//    public void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_camera_capture);
//        getTopTitleView();
//        this.mInfo = new BaseDeviceInfo();
//        captureFragment = new CaptureFragment();
//        CodeUtils.setFragmentArgs(captureFragment, R.layout.my_camera);
//        captureFragment.setAnalyzeCallback(analyzeCallback);
//        getSupportFragmentManager().beginTransaction().replace(R.id.fl_my_container, captureFragment).commit();
//        this.mCenter.setText(R.string.code_scan);
//    }
//
//
//    /**
//     * 二维码解析回调函数
//     */
//    CodeUtils.AnalyzeCallback analyzeCallback = new CodeUtils.AnalyzeCallback() {
//        @Override
//        public void onAnalyzeSuccess(Bitmap mBitmap, String resultString) {
//            if (resultString == null || resultString.isEmpty()) {
//                CommonUtils.showToast(getString(R.string.scan_failed));
//                finish();
//            } else {
//                checkDev(resultString);
//            }
//        }
//
//        @Override
//        public void onAnalyzeFailed() {
//            Intent resultIntent = new Intent();
//            Bundle bundle = new Bundle();
//            bundle.putInt(CodeUtils.RESULT_TYPE, CodeUtils.RESULT_FAILED);
//            bundle.putString(CodeUtils.RESULT_STRING, "");
//            resultIntent.putExtras(bundle);
//            MipcaCaptureActivity.this.setResult(RESULT_OK, resultIntent);
//            MipcaCaptureActivity.this.finish();
//        }
//    };
//
//    public void checkDev(String uuid) {
//        BaseJSONObject jsonObject;
//        try {
//            jsonObject = new BaseJSONObject(uuid);
//            if (jsonObject.has("action")) {
//                dealCode(jsonObject);
//                return;
//            }
//            this.mInfo.setDeviceUUID(jsonObject.optString("id", ""));
//            this.mInfo.setSnNum(jsonObject.optString("serialno", ""));
//            this.mInfo.setTp(jsonObject.optString("tp", "0"));
//            this.mTp = jsonObject.optString("tp", "0");
//            if (mInfo.getSnNum().length() == 0) {
//                mInfo.setSnNum(this.mInfo.getDeviceUUID());
//            }
//            if (this.mInfo.getDeviceUUID() == null || this.mInfo.getDeviceUUID().length() == 0 || this.mInfo.getDeviceUUID().length() < 3) {
//                CommonUtils.showToast(getString(R.string.scan_failed));
//                finish();
//                return;
//            }
//            if (mTp == null || mTp.isEmpty()) {
//                CommonUtils.showToast(getString(R.string.scan_no_recognized));
//                finish();
//                return;
//            }
//            String[] UUIds = this.mInfo.getDeviceUUID().split("-");
//            if (UUIds == null || UUIds.length == 0) {
//                CommonUtils.showToast(getString(R.string.scan_failed));
//                finish();
//                return;
//            }
//            if (UUIds.length > 0) {
//                this.mInfo.setDeviceUUID(UUIds[UUIds.length - 1]);
//                if (this.mInfo.getDeviceUUID() == null || this.mInfo.getDeviceUUID().length() == 0) {
//                    CommonUtils.showToast(getString(R.string.scan_failed));
//                    finish();
//                } else {
//                    if (CameraPlayer.decodeQR(this.mInfo.getDeviceUUID()) != 0) {
//                        CommonUtils.showToast(getString(R.string.scan_failed));
//                        finish();
//                        return;
//                    }
//                    if (!NetUtil.isNetworkAvailable()) {
//                        CommonUtils.showToast(getString(R.string.network_unavailable));
//                        return;
//                    }
//                    startProgressDialog();
//                    MeariUser.getInstance().checkScanQrDeviceStatus(mInfo.getSnNum(),mInfo.getTp());
//                    OKHttpRequestParams params = new OKHttpRequestParams();
//                    params.put("tp", mInfo.getTp());
//                    params.put("sn", mInfo.getSnNum());
//                    OkGo.post(Preference.BASE_URL_DEFAULT + API_PPSTRONG_QRSTATUS)
//                            .headers(CommonUtils.getOKHttpHeader(MipcaCaptureActivity.this, API_PPSTRONG_QRSTATUS))
//                            .params(params.getParams())
//                            .id(0)
//                            .tag(this)
//                            .execute(new StringCallback(this));
//                }
//            }
//        } catch (JSONException e) {
//            e.printStackTrace();
//            CommonUtils.showToast(getString(R.string.scan_failed));
//            finish();
//        }
//    }
//
//    private void dealCode(BaseJSONObject jsonObject) {
//        String action = jsonObject.getString("action");
//        if (action.equals("tv_login")) {
//            String tmpToken = jsonObject.optString("tmpID", "");
//            String clientID = jsonObject.optString("clientID", "");
//            String topic = jsonObject.optString("topic", "");
//            Bundle bundle = new Bundle();
//            bundle.putString("tmpToken", tmpToken);
//            bundle.putString("clientID", clientID);
//            bundle.putString("topic", topic);
//            Intent intent = new Intent();
//            intent.setClass(this, LoginTVActivity.class);
//            intent.putExtras(bundle);
//            startActivity(intent);
//            finish();
//        }
//
//    }
//
//    @Override
//    public void callback(ResponseData data, int tag) {
//        stopProgressDialog();
//        super.callback(data, tag);
//        if (data.isErrorCaught()) {
//            if (tag != 0) {
//                CommonUtils.showToast(data.getErrorMessage());
//                finish();
//            }
//        } else {
//            switch (tag) {
//                case 0:
//                    BaseDeviceInfo info = new BaseDeviceInfo();
//                    if (!data.getJsonResult().has("type")) {
//                        CommonUtils.showToast(getString(R.string.scan_no_recognized));
//                        finish();
//                        return;
//                    }
//                    int type = data.getJsonResult().optInt("type");
//                    BaseJSONObject object = data.getJsonResult().optBaseJSONObject("state");
//                    if (type != 1) {
//                        info.setAddStatus(object.optInt("addStatus"));
//                        info.setDeviceID(object.optString("deviceID", ""));
//                        info.setDeviceIcon(object.optString("deviceTypeName", ""));
//                        info.setDeviceIconGray(object.optString("deviceTypeNameGray", ""));
//                        info.setDeviceUUID(object.optString("deviceUUID", ""));
//                        info.setHostKey(object.optString("hostKey", ""));
//                        info.setSnNum(object.optString("snNum", ""));
//                        info.setUserAccount(object.optString("userAccount"));
//                        info.setDevTypeID(type);
//                        info.setDeviceUUID(mInfo.getDeviceUUID());
//                        info.setTp(mTp);
//                    } else {
//                        info.setAddStatus(object.optInt("addStatus"));
//                        info.setDeviceID(object.optString("nvrID", ""));
//                        info.setDeviceIcon(object.optString("nvrTypeName", ""));
//                        info.setDeviceIconGray(object.optString("nvrTypeNameGray", ""));
//                        info.setDeviceUUID(object.optString("deviceUUID", ""));
//                        info.setHostKey(object.optString("nvrKey", ""));
//                        info.setSnNum(object.optString("nvrNum", ""));
//                        info.setUserAccount(object.optString("userAccount"));
//                        info.setDevTypeID(type);
//                        info.setDeviceUUID(mInfo.getDeviceUUID());
//                        info.setTp(mTp);
//                    }
//                    if (info.getSnNum() == null || info.getSnNum().isEmpty()) {
//                        CommonUtils.showToast(getString(R.string.scan_no_recognized));
//                        finish();
//                    }
//                    Intent intent = new Intent(MipcaCaptureActivity.this, ScanningResultActivity.class);
//                    Bundle bundle = new Bundle();
//                    bundle.putSerializable("result", info);
//                    bundle.putInt("type", 1);
//                    bundle.putString("tp", mTp);
//                    intent.putExtras(bundle);
//                    startActivity(intent);
//                    finish();
//            }
//        }
//    }
}
