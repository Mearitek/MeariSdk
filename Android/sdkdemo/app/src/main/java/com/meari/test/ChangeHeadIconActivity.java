package com.meari.test;

import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.drawee.drawable.ScalingUtils;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.UserInfo;
import com.meari.sdk.callback.IAvatarCallback;
import com.meari.test.common.ActivityType;
import com.meari.test.common.Constant;
import com.meari.test.utils.CommonUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by ljh on 2016/11/17.
 * 改用户头像
 * Changed by pupu on 2017-04-27 13:06:45
 * 更改了：
 * 1、全部改为butterknife注解
 */

public class ChangeHeadIconActivity extends BaseUpIconActivity {
    /**
     * 相机拍摄时存储的头像名
     */
    @BindView(R.id.title)
    TextView mCenter;
    @BindView(R.id.back_img)
    ImageView mBackBtn;
    @BindView(R.id.camera)
    Button btnCamera;
    @BindView(R.id.gallery)
    Button btnGallery;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_change_icon);
        ButterKnife.bind(this);
        getTopTitleView();
        initView();
    }

    public void getTopTitleView() {
        this.mBackBtn.setImageResource(R.drawable.btn_back);
    }

    private void initView() {
        this.mCenter.setText(R.string.change_pic);
        this.mIcon.getHierarchy().setFailureImage(R.mipmap.personalhead, ScalingUtils.ScaleType.FIT_XY);
        UserInfo info = MeariUser.getInstance().getUserInfo();
        String format = getString(R.string.image_url_format);
        String headUrl = String.format(format, info.getImageUrl(), info.getUserID(), info.getUserToken());
        this.mIcon.setImageURI(Uri.parse(headUrl));
        RelativeLayout layout_head = findViewById(R.id.layout_head);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) layout_head.getLayoutParams();
        params.width = Constant.width > Constant.height ? Constant.height : Constant.width;
        params.height = params.width;
    }


    @OnClick(R.id.camera)
    void goOpenCamera() {
        super.openCamera();
    }


    @OnClick(R.id.gallery)
    void goOpenAlbum() {
        Intent intent = new Intent();
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("image/*");
        if (Build.VERSION.SDK_INT < 19) {
            intent.setAction(Intent.ACTION_GET_CONTENT);
        } else {
            intent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
            intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*");
        }
        startActivityForResult(intent, ActivityType.ACTIVITY_CHANGE_ICON);
    }


    @OnClick(R.id.back_img)
    void imgBackClick() {
        finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (requestCode == ActivityType.ACTIVITY_CHANGE_ICON) {
                Uri originalUri = data.getData();        //获得图片的uri
                String[] proj = {MediaStore.Images.Media.DATA};
                Cursor cursor = managedQuery(originalUri, proj, null, null, null);
                int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                cursor.moveToFirst();
                String path = cursor.getString(column_index);
                postHeadIconRequest(path);
            }
        }
    }

    public void postHeadIconRequest(String path) {
        startProgressDialog();
        File file = new File(path);
        List<File> fileList = new ArrayList<>();
        fileList.add(file);
        MeariUser.getInstance().uploadUserAvatar(fileList,new IAvatarCallback() {
            @Override
            public void onSuccess(String path) {
                stopProgressDialog();
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(code);
            }
        });

    }
}
