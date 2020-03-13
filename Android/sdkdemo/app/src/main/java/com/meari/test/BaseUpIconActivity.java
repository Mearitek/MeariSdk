package com.meari.test;

import android.content.DialogInterface;
import android.net.Uri;

import com.facebook.drawee.view.SimpleDraweeView;
import com.jph.takephoto.app.TakePhoto;
import com.jph.takephoto.app.TakePhotoImpl;
import com.jph.takephoto.compress.CompressConfig;
import com.jph.takephoto.model.CropOptions;
import com.jph.takephoto.model.TResult;
import com.jph.takephoto.model.TakePhotoOptions;
import com.jph.takephoto.permission.TakePhotoInvocationHandler;
import com.meari.sdk.MeariUser;
import com.meari.sdk.callback.IAvatarCallback;
import com.meari.test.application.MeariSmartApp;
import com.meari.test.common.Constant;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.NetUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by LIAO on 2016/5/19.
 * Changed by pupu on 2017-04-27 13:05:50
 */
public abstract class BaseUpIconActivity extends TakePhotoActivity implements DialogInterface.OnCancelListener {
    @BindView(R.id.img_head)
    public SimpleDraweeView mIcon;
    /**
     * 相机拍摄时存储的头像名
     */
    private String cameraFileName = "yx_face_photo.jpg";

    private int MAX_WIDTH = 300;//宽度最大300px
    private int MAX_HEIGHT = 300;//长度最大300px
    private TakePhoto mTakePhoto;

    @Override
    public void onCancel(DialogInterface dialog) {

    }


    /**
     * 启动本地相册
     */
    public void openAlbum() {
        File file = new File(Constant.DOCUMENT_CACHE_PATH + cameraFileName);
        if (!file.getParentFile().exists()) file.getParentFile().mkdirs();
        Uri imageUri = Uri.fromFile(file);
        configCompress(getTakePhoto());
        configTakePhotoOpthion(getTakePhoto());
        getTakePhoto().onPickFromGalleryWithCrop(imageUri, getCropOptions());
    }

    /**
     * 启动相机
     */
    public void openCamera() {
        File file = new File(Constant.DOCUMENT_CACHE_PATH + cameraFileName);
        if (!file.getParentFile().exists()) file.getParentFile().mkdirs();
        Uri imageUri = Uri.fromFile(file);
        configCompress(getTakePhoto());
        configTakePhotoOpthion(getTakePhoto());
        mTakePhoto.onPickFromCaptureWithCrop(imageUri, getCropOptions());
    }

    private CropOptions getCropOptions() {
        int height = MAX_HEIGHT;
        int width = MAX_WIDTH;
        boolean withWonCrop = false;
        CropOptions.Builder builder = new CropOptions.Builder();
        builder.setOutputX(width).setOutputY(height);
        builder.setWithOwnCrop(withWonCrop);
        builder.setAspectX(200);
        builder.setAspectY(200);
        return builder.create();
    }

    /**
     * 获取TakePhoto实例
     */
    public TakePhoto getTakePhoto() {
        if (mTakePhoto == null) {
            mTakePhoto = (TakePhoto) TakePhotoInvocationHandler.of(this).bind(new TakePhotoImpl(this, this));
        }
        return mTakePhoto;
    }

    private void configTakePhotoOpthion(TakePhoto takePhoto) {
        takePhoto.setTakePhotoOptions(new TakePhotoOptions.Builder().setWithOwnGallery(true).create());
    }


    // 上传头像
    public void onRefresh(TResult result) {
        if (!NetUtil.checkNet(MeariSmartApp.getInstance())) { // 检查网络是否可用
            getTakePhoto().getProgressDialog().dismiss();
            CommonUtils.showToast(R.string.network_unavailable);
            return;
        }
        postHeadIconRequest(result);
    }

    private void configCompress(TakePhoto takePhoto) {
        boolean showProgressBar = true;
        CompressConfig config;
        int MAX_SIZE = 102400;
        config = new CompressConfig.Builder()
                .setMaxSize(MAX_SIZE)
                .setMaxPixel(MAX_WIDTH >= MAX_HEIGHT ? MAX_WIDTH : MAX_WIDTH)
                .create();
        takePhoto.onEnableCompress(config, showProgressBar);

    }

    public void postHeadIconRequest(TResult tResult) {
        File file = new File(tResult.getImage().getPath());
        List<File> fileList = new ArrayList<>();
        fileList.add(file);

//        startProgressDialog();
        MeariUser.getInstance().uploadUserAvatar(fileList,  new IAvatarCallback() {
            @Override
            public void onSuccess(String path) {
                getTakePhoto().getProgressDialog().dismiss();
                String imageUrl = path;
                mIcon.setImageURI(Uri.parse(imageUrl));
            }

            @Override
            public void onError(int code, String error) {
//                stopProgressDialog();
                CommonUtils.showToast(code);
            }
        });


    }

    @Override
    public void takeCancel() {
        super.takeCancel();
    }

    @Override
    public void takeFail(TResult result, String msg) {
        super.takeFail(result, msg);
    }

    @Override
    public void takeSuccess(TResult result) {
        super.takeSuccess(result);
        doHandlePhoto(result);
    }

    private void doHandlePhoto(TResult result) {
        onRefresh(result);
    }


}
