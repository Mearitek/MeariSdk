package com.meari.test.common;


import com.meari.sdk.bean.CameraInfo;

public interface CameraSearchListener {
    void onCameraSearchDetected(CameraInfo uuid);

    void onCameraSearchFinished();

    void onRefreshProgress(int time);
}
