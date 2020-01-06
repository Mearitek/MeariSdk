package com.meari.test;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.view.KeyEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.RoundingParams;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.IGetTokenCallback;
import com.meari.test.adapter.MainMenuAdapter;
import com.meari.test.application.MeariSmartApp;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Distribution;
import com.meari.test.common.HomeCallback;
import com.meari.test.common.Preference;
import com.meari.test.common.StringConstants;
import com.meari.test.fragment.CameraSquareFragment;
import com.meari.test.fragment.FriendSquareFragment;
import com.meari.test.fragment.MessageSquareFragment;
import com.meari.test.permission_utils.Func;
import com.meari.test.permission_utils.PermissionUtil;
import com.meari.test.receiver.ExitAppReceiver;
import com.meari.test.receiver.WifiReceiver;
import com.meari.test.slidmenu.SlidingFragmentActivity;
import com.meari.test.slidmenu.SlidingMenu;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.TagAliasOperatorHelper;
import com.meari.test.utils.TagAliasOperatorHelper.TagAliasBean;
import com.meari.test.widget.ProgressLoadingDialog;

import butterknife.OnClick;
import cn.jpush.android.api.JPushInterface;

import static com.meari.test.utils.TagAliasOperatorHelper.sequence;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/24
 * 描    述：首页
 * 修订历史：
 * ================================================
 */

public class MainActivity extends SlidingFragmentActivity implements MainMenuAdapter.onMainMenuItemClickListener, WifiReceiver.WifiChangeListener, HomeCallback {
    private final String WRITE_CAMERA = android.Manifest.permission.CAMERA;
    private static MainActivity instance;
    private SlidingMenu menu;
    public MainMenuAdapter mAdapter;
    private PermissionUtil.PermissionRequestObject mStoragePermissionRequest;
    public static final String WRITE_EXTERNAL_LOCATION = android.Manifest.permission.ACCESS_FINE_LOCATION;
    public static final String WRITE_EXTERNAL_STORAGE = android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
    private PermissionUtil.PermissionRequestObject mCameraPermissionRequest;
    private ProgressLoadingDialog mProgressDialog;
    private WifiReceiver mReceiver;
    public TextView mNicknameText;
    public RecyclerView mMenuRecyclerView;
    private UserInfo mUserInfo;
    final private int REQUEST_CODE_ASK_PERMISSIONS = 120;//权限请求码
    private final int SDK_PERMISSION_REQUEST = 121;
    final private int REQUEST_CODE_ASK_CAMERA_PERMISSIONS = 122;//权限请求码
    private PermissionUtil.PermissionRequestObject mLocationPermissionRequest;

    public static MainActivity getInstance() {
        return instance;
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_IMMERSIVE);
        setBehindContentView(R.layout.layout_menu_fragment);
        setContentView(R.layout.activity_main);
        Bundle bundle = getIntent().getExtras();
        boolean bMsg = false;
        int deviceTypeID = 2;
        if (bundle != null) {
            bMsg = bundle.getBoolean("sysMessage", false);
            deviceTypeID = bundle.getInt(StringConstants.DEVICE_TYPE_ID, 2);
        }
        mUserInfo = MeariUser.getInstance().getUserInfo();
        postTokenChange();
        instance = this;
        this.menu = getSlidingMenu();
        initMenu();
        initView();
        initMenuFragment(bMsg, deviceTypeID);
        onCheckStoragePermissionClick();
        registerWiFiChangeReceiver();

        // 初始化极光
        initJPushAlias();
        // 连接mqtt服务
        MeariUser.getInstance().connectMqttServer(getApplication());
//        MqttInfo mqttInfo = MeariUser.getInstance().getMqttInfo();
//        if (mUserInfo.getUserID() != 0 && !mqttInfo.getHostname().equals("")) {
//            if (MqttMangerUtils.getInstance().getConnection() == null) {
//                //重新拉起MQTT服务
//                MqttMangerUtils.getInstance().addConnect(MeariUser.getInstance().getUserInfo(),mqttInfo, MeariSmartApp.getInstance());
//            } else if (!MqttMangerUtils.getInstance().getConnection().isConnected()) {
//                //重新拉起MQTT服务
//                MqttMangerUtils.getInstance().addConnect(MeariUser.getInstance().getUserInfo(),mqttInfo, MeariSmartApp.getInstance());
//            }
//        }

//        MqttIotInfo mqttIotInfo = MeariUser.getInstance().getMqttIotInfo();
//        //拉起MQTT服务
//        if (MeariUser.getInstance().getUserInfo().getUserID() != 0 && !mqttIotInfo.getHost().equals("")) {
//            if (MqttMangerUtils.getInstance().getConnection() == null) {
//                Log.i("tag", "主页MQTT connection is null,so reboot MQTT service connection!");
//                //重新拉起MQTT服务
//                MqttMangerUtils.getInstance().addConnectIot(MeariUser.getInstance().getUserInfo(), mqttIotInfo, getApplication());
//            } else if (!MqttMangerUtils.getInstance().getConnection().isConnected()) {
//                Log.i("tag", "主页MQTT connection is not online,so reboot MQTT service connection!");
//                //重新拉起MQTT服务
//                MqttMangerUtils.getInstance().addConnectIot(MeariUser.getInstance().getUserInfo(), mqttIotInfo, getApplication());
//            }
//        }

    }

    public void onCheckStoragePermissionClick() {
        boolean hasStoragePermission = PermissionUtil.with(this).has(WRITE_EXTERNAL_STORAGE);
        if (!hasStoragePermission) {
            mStoragePermissionRequest = PermissionUtil.with(this).request(WRITE_EXTERNAL_STORAGE).onAllGranted(
                    new Func() {
                        @Override
                        protected void call() {

                        }
                    }).onAnyDenied(
                    new Func() {
                        @Override
                        protected void call() {
                        }
                    }).ask(REQUEST_CODE_ASK_PERMISSIONS);
        } else {
            checkLocationPermission();
        }

    }

    public void checkLocationPermission() {
        boolean hasLocationPermission = PermissionUtil.with(this).has(WRITE_EXTERNAL_LOCATION);
        if (!hasLocationPermission) {
            mLocationPermissionRequest = PermissionUtil.with(this).request(WRITE_EXTERNAL_LOCATION).onAllGranted(
                    new Func() {
                        @Override
                        protected void call() {

                        }
                    }).onAnyDenied(
                    new Func() {
                        @Override
                        protected void call() {
                        }
                    }).ask(SDK_PERMISSION_REQUEST);
        } else {
            checkCameraInfoPermission();
        }
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @Nullable String[] permissions, @Nullable int[] grantResults) {
        if (requestCode == REQUEST_CODE_ASK_PERMISSIONS) {
            if (mStoragePermissionRequest != null)
                mStoragePermissionRequest.onRequestPermissionsResult(requestCode, permissions, grantResults);
            checkLocationPermission();
        } else if (requestCode == SDK_PERMISSION_REQUEST) {
            if (mLocationPermissionRequest != null)
                mLocationPermissionRequest.onRequestPermissionsResult(requestCode, permissions, grantResults);
            checkCameraInfoPermission();
        } else if (requestCode == REQUEST_CODE_ASK_CAMERA_PERMISSIONS) {
            if (mCameraPermissionRequest != null)
                mCameraPermissionRequest.onRequestPermissionsResult(requestCode, permissions, grantResults);

        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }


    private void initJPushAlias() {
        String alias = mUserInfo.getJpushAlias();
        boolean isAliasAction = true;
        int action = TagAliasOperatorHelper.ACTION_SET;
        TagAliasBean tagAliasBean = new TagAliasBean();
        tagAliasBean.action = action;
        sequence++;
        tagAliasBean.alias = alias;
        tagAliasBean.isAliasAction = isAliasAction;
        TagAliasOperatorHelper.getInstance().handleAction(getApplicationContext(), sequence, tagAliasBean);
        if (this.mUserInfo.getSoundFlag().equals("0")) {
            JPushInterface.setSilenceTime(getApplicationContext(), 0, 0, 0, 0);

        } else {
            JPushInterface.setSilenceTime(getApplicationContext(), 0, 0, 23, 59);
        }
    }

    private void initMenuFragment(boolean message, int deviceType) {
        int position = 0;
        this.mAdapter = new MainMenuAdapter(this, this);
        if (message) {
            position = mAdapter.getMessageSelect();
        } else {
            if (deviceType == 3) {
                position = 2;
            }
        }
        mAdapter.setSelect(position);
        this.mMenuRecyclerView = (RecyclerView) findViewById(R.id.lv);
        this.mMenuRecyclerView.setAdapter(mAdapter);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mMenuRecyclerView.setLayoutManager(linearLayoutManager);
        switchFragment(position, message);
    }

    private void initMenu() {
        menu.setMode(SlidingMenu.LEFT);
        menu.setFadeEnabled(false);
        menu.setBehindScrollScale(0.5f);
        menu.setBehindWidth((DisplayUtil.getDisplayPxWidth(this) * 4 / 5));
        menu.setBackgroundColor(Color.parseColor("#ffffff"));

    }

    private void initView() {
        getTopTitleView();
        this.mBackBtn.setVisibility(View.VISIBLE);
        this.mBackBtn.setImageResource(R.drawable.btn_menu);
        this.mBackText.setVisibility(View.GONE);
        this.mNicknameText = (TextView) findViewById(R.id.nickname_text);
        this.mNicknameText.setText(this.mUserInfo.getNickName());
        SimpleDraweeView headImageView = (SimpleDraweeView) findViewById(R.id.head_cion);
        RoundingParams roundingParams = new RoundingParams();
        roundingParams.setRoundAsCircle(true);
        headImageView.getHierarchy().setRoundingParams(roundingParams);
        headImageView.getHierarchy().setFailureImage(R.mipmap.ic_person, ScalingUtils.ScaleType.FIT_XY);
        headImageView.getHierarchy().setPlaceholderImage(R.mipmap.ic_person, ScalingUtils.ScaleType.FIT_XY);
        String headUrl = String.format(getString(R.string.image_url_format), mUserInfo.getImageUrl(), mUserInfo.getUserID(), mUserInfo.getUserToken());
        headImageView.setImageURI(Uri.parse(headUrl));
        findViewById(R.id.user_layout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onUserClick();
            }
        });
    }

    private void postTokenChange() {
        MeariUser.getInstance().getToken(Distribution.DISTRIBUTION_QR, this, new IGetTokenCallback() {
            @Override
            public void onError(int code, String error) {
                CommonUtils.showToast(error);
                stopProgressDialog();
            }

            @Override
            public void onSuccess(String token, int leftTime) {
                Preference.getPreference().setToken(token);
            }
        });
    }

    public void getTopTitleView() {
        this.mBackBtn = (ImageView) findViewById(R.id.back_img);
        this.mCenter = (TextView) findViewById(R.id.title);
        this.mBackText = (TextView) findViewById(R.id.cancel_btn);
        this.mRightBtn = (ImageView) findViewById(R.id.submitRegisterBtn);
        this.mRightText = (TextView) findViewById(R.id.right_text);
        this.mBackBtn.setImageResource(R.drawable.btn_back);
    }

    public void switchFragment(int position, boolean message) {
        FragmentManager fm = getSupportFragmentManager();
        FragmentTransaction transaction = fm.beginTransaction();
        Fragment fragment = null;
        mCenter.setText(mAdapter.getTitle(position));
        if (mAdapter.getTitle(position).equals(getString(R.string.device_title))) {
            fragment = CameraSquareFragment.newInstance(mUserInfo);
        } else if (mAdapter.getTitle(position).equals(getString(R.string.friends_title))) {
            fragment = FriendSquareFragment.newInstance();
        } else if (mAdapter.getTitle(position).equals(getString(R.string.message_title))) {
            fragment = MessageSquareFragment.newInstance(message);
        } else if (mAdapter.getTitle(position).equals(getString(R.string.more_title))) {
//            fragment = MoreSquareFragment.newInstance(this);
        } else {
            fragment = CameraSquareFragment.newInstance(mUserInfo);
        }
        transaction.replace(R.id.pps_fragment_layout, fragment);
        transaction.commit();
    }


    // 时间次数
    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_BACK:
                int curItem = getSlidingMenu().getViewAbove().getCurrentItem();
                if (curItem == 1) {
                    getSlidingMenu().showMenu(true);
                    return true;
                }
                exit();
                break;
            default:
                return super.onKeyUp(keyCode, event);

        }

        return true;
    }

    public void exit() {
        if (!isExit) {
            isExit = true;
            CommonUtils.showToast(getString(R.string.exit_app));
            mHandler.sendEmptyMessageDelayed(0, 2000);
        } else {
            MeariSmartApp.getInstance().exitApp(0);
        }
    }

    private boolean isExit;
    @SuppressLint("HandlerLeak")
    Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            isExit = false;
        }
    };


    @Override
    public void onMainMenuItemClick(int position) {
        if (mAdapter.getSelect() == position) {
            menu.showContent();
            View contentView = findViewById(R.id.main_view);
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) contentView.getLayoutParams();
            params.setMargins(0, 0, 0, 0);
            contentView.setLayoutParams(params);

            if (mAdapter.getTitle(position).equals(getString(R.string.message_title))) {
                mAdapter.setbHasMeg(false);
                mAdapter.notifyDataSetChanged();
            } else if (mAdapter.getTitle(position).equals(getString(R.string.more_title))) {
                mAdapter.setIsLastVersion(false);
                mAdapter.notifyDataSetChanged();
            }
        } else {
            showContent();
            View contentView = findViewById(R.id.main_view);
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) contentView.getLayoutParams();
            params.setMargins(0, 0, 0, 0);
            contentView.setLayoutParams(params);
            switchFragment(position, false);
            mAdapter.setSelect(position);
            if (mAdapter.getTitle(position).equals(getString(R.string.message_title))) {
                mAdapter.setbHasMeg(false);
            }
            if (mAdapter.getTitle(position).equals(getString(R.string.more_title))) {
                mAdapter.setIsLastVersion(false);
            }
            mAdapter.notifyDataSetChanged();
        }
    }

    @OnClick(R.id.back_img)
    public void onBackClick(View view) {
        showMenu();
        CommonUtils.hideKeyBoard(this);
    }

//    /**
//     * @param data 返回的数据
//     * @param tag  biaoji
//     */
//    @Override
//    public void callback(ResponseData data, int tag) {
//        stopProgressDialog();
//        if (!data.isErrorCaught()) {
//            switch (tag) {
//                case 2:
//                    CommonUtils.clearAutoLoginData();
//                    MeariApplication.getInstance().tokenChange();
//                    break;
//                case 6:
//                    this.mToken = data.getJsonResult().optString("token", "");
//                    break;
//                case 7:
//                    BaseJSONArray jsonArray = data.getJsonResult().optBaseJSONArray("result");
//                default:
//                    break;
//            }
//        }
//    }


    public void onUserClick() {
        Intent intent = new Intent(this, AccountActivity.class);
        startActivityForResult(intent, ActivityType.ACTIVITY_USERACCOUNT);
    }


    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public void finish() {
        super.finish();
        try {
            unregisterReceiver(this.mReceiver);
            instance = null;
        } catch (IllegalArgumentException e) {

        }

    }


    public void checkCameraInfoPermission() {
        boolean hasLocationPermission = PermissionUtil.with(this).has(WRITE_CAMERA);
        if (!hasLocationPermission) {
            mCameraPermissionRequest = PermissionUtil.with(this).request(WRITE_CAMERA).onAllGranted(
                    new Func() {
                        @Override
                        protected void call() {
                        }
                    }).onAnyDenied(
                    new Func() {
                        @Override
                        protected void call() {
                        }
                    }).ask(REQUEST_CODE_ASK_CAMERA_PERMISSIONS);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ActivityType.ACTIVITY_USERACCOUNT:
                mUserInfo = MeariUser.getInstance().getUserInfo();
                SimpleDraweeView headImageView = (SimpleDraweeView) findViewById(R.id.head_cion);
                String format = getString(R.string.image_url_format);
                String headUrl = String.format(format, mUserInfo.getImageUrl(), mUserInfo.getUserID(), mUserInfo.getUserToken());
                headImageView.setImageURI(Uri.parse(headUrl));
                this.mNicknameText.setText(mUserInfo.getNickName());
                break;
            default:
                break;
        }
    }

    private ExitAppReceiver mExitReciver = new ExitAppReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            int msgId = intent.getIntExtra("msgId", 0);
            if (msgId == StringConstants.MESSAGE_ID_EXIT_APP) {
                finish();
            }
        }
    };

    @Override
    public void registerExitAppReceiver() {
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction(StringConstants.MESSAGE_EXIT_APP);
        registerReceiver(mExitReciver, exitFilter);
    }

    @Override
    public void unRegisterTokenReceiver() {
        unregisterReceiver(mExitReciver);
    }


    /**
     * 显示进度条
     */
    public void startProgressDialog() {
        if (isFinishing()) {
            return;
        }
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(this));
        }
        if (!getProgressDialog().isShowing()) {
            getProgressDialog().show();
        }
    }

    /**
     * 显示进度条
     */
    public void startProgressDialog(String content) {
        if (isFinishing()) {
            return;
        }
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(this));
        }
        if (!getProgressDialog().isShowing()) {
            getProgressDialog().setMessage(content);
            getProgressDialog().show();
        }
    }

    /**
     * 显示进度条
     */
    public void startProgressDialog(String content, DialogInterface.OnCancelListener listener) {
        if (isFinishing()) {
            return;
        }
        if (getProgressDialog() == null) {
            setProgressDialog(ProgressLoadingDialog.createDialog(this, listener));
        }
        if (!getProgressDialog().isShowing()) {
            getProgressDialog().setMessage(content);
            getProgressDialog().show();
        }
    }

    /**
     * 关闭进度条
     */

    public void stopProgressDialog() {
        if (getProgressDialog() != null && getProgressDialog().isShowing()) {
            getProgressDialog().dismiss();
        }
    }

    public ProgressLoadingDialog getProgressDialog() {
        return mProgressDialog;
    }

    public void setProgressDialog(ProgressLoadingDialog mProgressDialog) {
        this.mProgressDialog = mProgressDialog;
    }

    /**
     * 注册网络变化发送广播
     */
    public void registerWiFiChangeReceiver() {
        this.mReceiver = new WifiReceiver(this);
        IntentFilter exitFilter = new IntentFilter();
        exitFilter.addAction("android.net.conn.CONNECTIVITY_CHANGE");
        registerReceiver(this.mReceiver, exitFilter);
    }

    @Override
    public void changeWifi(WifiInfo wifiInfo) {
    }

    @Override
    public void disConnected() {

    }

    @Override
    public void connectTraffic() {

    }

    /**
     * 显示toast
     */
    public void showToast(String text) {
        CommonUtils.showToast(text);
    }
}
