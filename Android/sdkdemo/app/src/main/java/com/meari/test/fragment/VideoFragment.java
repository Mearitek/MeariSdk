package com.meari.test.fragment;

import android.support.v4.app.Fragment;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.meari.sdk.bean.CameraInfo;
import com.meari.test.common.VideoPlayCallback;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/22
 * 描    述：
 * 修订历史：
 * ================================================
 */
public class VideoFragment extends Fragment implements View.OnClickListener {
    public VideoPlayCallback mVideoPlayCallback;
    public RecyclerView mRecyclerView;

    public void closeFragment() {
    }

    public void videoViewStatus(int status) {
    }

    public void playVideo(boolean changeDate) {
    }

    @Override
    public void onClick(View v) {

    }

    public void setFragmentStatus(boolean visiable) {
    }

    public void stopVideoRecord() {
    }

    public void networkClose() {
    }

    public void pauseViPlaydeo() {
    }

    public void removeVideo() {
    }

    public void setCameraInfo(CameraInfo info) {
    }
}
