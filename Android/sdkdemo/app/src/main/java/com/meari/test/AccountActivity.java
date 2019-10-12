package com.meari.test;

import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.RoundingParams;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.ILogoutCallback;
import com.meari.sdk.callback.IResultCallback;
import com.meari.test.common.ActivityType;
import com.meari.test.common.StringConstants;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by ljh on 2016/11/9.
 * Changed by pupu on 2017-04-26 16:32:24
 */
public class AccountActivity extends BaseActivity {
    private static final String TAG = "AccountActivity";
    @BindView(R.id.account_text)
    public TextView mAccount;
    @BindView(R.id.nickname_text)
    public TextView mNickname;
    @BindView(R.id.head_icon)
    public SimpleDraweeView mIcon;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_account);
        getTopTitleView();
        this.mCenter.setText(R.string.account_title);
        initView();
    }

    private void initView() {
        this.mRightText.setText(R.string.save);
        this.action_bar_rl.setVisibility(View.GONE);
        RoundingParams params = new RoundingParams();
        params.setRoundAsCircle(true);
        this.mIcon.getHierarchy().setRoundingParams(params);
        this.mIcon.getHierarchy().setFailureImage(R.mipmap.personalhead, ScalingUtils.ScaleType.FIT_XY);
        UserInfo info= MeariUser.getInstance().getUserInfo();
        String imageUrlFormat = getString(R.string.image_url_format);
        String headUrl = String.format(imageUrlFormat,info.getImageUrl(),info.getUserID(),info.getUserToken());
        this.mIcon.setImageURI(Uri.parse(headUrl));
        this.mAccount.setText(info.getUserAccount());
        this.mNickname.setText(info.getNickName());
    }

    @OnClick(R.id.nickmae_layout)
    public void goEditNicknameActivity() {
        Intent intent = new Intent();
        intent.setClass(this, EditNicknameActivity.class);
        startActivityForResult(intent, ActivityType.ACTIVITY_EDITNICKNAME);
    }

    @OnClick(R.id.head_icon)
    public void goChangeHeadIconActivity() {
        Intent intent = new Intent();
        intent.setClass(this, ChangeHeadIconActivity.class);
        startActivityForResult(intent, ActivityType.ACTIVITY_CHANGE_ICON);
    }
    @OnClick(R.id.logout_tv)
    public void onLogOutClick() {
        try {
            CommonUtils.showDlg(this, getString(R.string.app_meari_name), getString(R.string.pps_quit_content),
                    getString(R.string.ok), positiveListener, getString(R.string.cancel), negativeListener, true);

        } catch (Exception e) {
            showToast(e.getMessage());
        }
    }

    public DialogInterface.OnClickListener negativeListener = new DialogInterface.OnClickListener() {

        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };
    public DialogInterface.OnClickListener positiveListener = new DialogInterface.OnClickListener() {

        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
            startProgressDialog(getString(R.string.logout));
            startProgressDialog();
            MeariUser.getInstance().logout(this ,new ILogoutCallback() {
                @Override
                public void onSuccess(int resultCode) {
                    stopProgressDialog();
                    loginOut();
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(error);
                }
            });
        }
    };

    @OnClick(R.id.change_password_layout)
    public void onMoreChangePasswordClick() {
        Intent intent = new Intent(this, PasswordActivity.class);
        Bundle bundle = new Bundle();
        bundle.putInt("type", 1);
        intent.putExtras(bundle);
        startActivity(intent);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        UserInfo info= MeariUser.getInstance().getUserInfo();
        String format = getString(R.string.image_url_format);
        switch (requestCode) {
            case ActivityType.ACTIVITY_EDITNICKNAME:
                this.mNickname.setText(info.getNickName());
                String headUrl = String.format(format,info.getImageUrl(),info.getUserID(),info.getUserToken());
                this.mIcon.setImageURI(Uri.parse(headUrl));
                break;
            case ActivityType.ACTIVITY_CHANGE_ICON:
                String changeHeadUrl = String.format(format,info.getImageUrl(),info.getUserID(),info.getUserToken());
                this.mIcon.setImageURI(Uri.parse(changeHeadUrl));
                break;
            default:
                break;
        }
    }



    public void loginOut() {
        Intent intent = new Intent();
        intent.setClass(this, LoginActivity.class);
        Bundle bundle = new Bundle();
        bundle.putBoolean("token", false);
        bundle.putInt("loginType", 1);
        intent.putExtras(bundle);
        startActivity(intent);
        Intent intentBroad = new Intent();
        intentBroad.putExtra("msgId", StringConstants.MESSAGE_ID_TOKEN_CHANGE);
        intentBroad.setAction(StringConstants.MESSAGE_EXIT_APP);
        this.sendBroadcast(intentBroad);
        MeariUser.getInstance().removeUser();
        finish();
    }

}
