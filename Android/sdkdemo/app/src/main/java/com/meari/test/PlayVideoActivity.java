package com.meari.test;

import android.os.Bundle;

import com.meari.sdk.bean.CameraInfo;
import com.meari.test.utils.BaseActivity;


/**
 * Created by Administrator on 2017/3/8.
 */
public class PlayVideoActivity extends BaseActivity {
    private static PlayVideoActivity instance;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setInstance(this);
    }

    @Override
    public void finish() {
        super.finish();
        setInstance(null);
    }

    public static PlayVideoActivity getInstance() {
        return instance;
    }

    public static void setInstance(PlayVideoActivity instance) {
        PlayVideoActivity.instance = instance;
    }

    public void cancelShareDevice() {
    }


    public CameraInfo getCameraInfo() {
        return null;
    }
    public void setCameraInfo(CameraInfo cameraInfo) {

    }

    public boolean getSDCardStatus() {
        return false;
    }

}
