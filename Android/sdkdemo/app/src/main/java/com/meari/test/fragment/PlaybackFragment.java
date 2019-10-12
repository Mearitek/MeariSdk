package com.meari.test.fragment;

import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.meari.sdk.bean.CameraInfo;
import com.meari.test.R;
import com.meari.test.SingleVideoActivity;
import com.meari.test.common.VideoPlayCallback;

/**
 * Created by Administrator on 2016/12/17.
 */

public class PlaybackFragment extends VideoFragment {
    private VideoFragment mCurrentFrgment;
    private int mPlaybackType;
    private CameraInfo mCameraInfo;
    private String mSeekTime;
    /**
     * connect device status
     */
    private boolean mIsFirstCreateViedoPlay = true;
    private boolean IsFirstCreadCloud = true;
    private final int TYPE_SD = 0;
    private View mView;

    public static PlaybackFragment newInstance(String time, CameraInfo cameraInfo) {
        PlaybackFragment fragment = new PlaybackFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("cameraInfo", cameraInfo);
        bundle.putString("time", time);
        fragment.setArguments(bundle);
        return fragment;
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        if (getContext() instanceof VideoPlayCallback) {
            setVideoPlayCallback((VideoPlayCallback) getContext());
        }
        View fragmentView = inflater.inflate(R.layout.fragment_playback, container, false);
        mCameraInfo = (CameraInfo) getArguments().getSerializable("cameraInfo");
        this.mSeekTime = getArguments().getString("time");
        initPlaybackType();
        if (getUserVisibleHint())
            changeTab(mPlaybackType);
        mView = fragmentView;
        return fragmentView;

    }

    private void initPlaybackType() {
        mPlaybackType = TYPE_SD;
    }

    public void setVideoPlayCallback(VideoPlayCallback videoPlayCallback) {
        this.mVideoPlayCallback = videoPlayCallback;
    }

    /**
     * 切换预览及回放
     *
     * @param index
     */
    public void changeTab(int index) {
        if (mCurrentFrgment != null)
            mCurrentFrgment.closeFragment();
        mPlaybackType = TYPE_SD;
        setChangePlaybackSd();
        FragmentManager fm = getFragmentManager();
        FragmentTransaction transaction = fm.beginTransaction();
        transaction.replace(R.id.fragment_play_back, mCurrentFrgment);
        transaction.commitAllowingStateLoss();
    }

    /**
     * change sdcard playback
     */
    public void setChangePlaybackSd() {
        if (mVideoPlayCallback != null && mVideoPlayCallback.getRightImageView() != null)
            this.mVideoPlayCallback.getRightImageView().setTag(0);
        if (mCameraInfo.getNvrPort() < 0) {
            if (mCameraInfo.getDevTypeID() == 3)
                this.mVideoPlayCallback.getRightImageView().setImageResource(R.mipmap.ic_gree_sd_y);
            else
                this.mVideoPlayCallback.getRightImageView().setImageResource(R.mipmap.ic_gree_sd);

        } else {
            if (mCameraInfo.getDevTypeID() == 3)
                this.mVideoPlayCallback.getRightImageView().setImageResource(R.mipmap.ic_square_nvr_y);
            else
                this.mVideoPlayCallback.getRightImageView().setImageResource(R.mipmap.ic_square_nvr);
        }
        mCurrentFrgment = onCreatVideoFragment();
    }

    public VideoFragment onCreatVideoFragment() {
        VideoFragment fragment;
        if (mIsFirstCreateViedoPlay && mPlaybackType == TYPE_SD) {
            if (mCameraInfo.getNvrPort() == -1) {
                if (mCameraInfo.getDevTypeID() == 2) {
                    fragment = SingleVideoPlaybackSDFragment.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
                } else if (mCameraInfo.getDevTypeID() == 4) {
                    //门铃设备
                    fragment = SingleVideoPlaybackSDFragment.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
                } else {
                    fragment = BabyMoniterSDPlayback.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
                }
            } else {
                if (mCameraInfo.getDevTypeID() == 2)
                    fragment = SingleVideoPlaybackNVRFragment.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
                else
                    fragment = BabyMoniterPlaybackNVRFragment.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
            }
            mIsFirstCreateViedoPlay = false;
        } else {
            if (mCameraInfo.getNvrPort() == -1) {
                if (mCameraInfo.getDevTypeID() == 2)
                    fragment = SingleVideoPlaybackSDFragment.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
                else
                    fragment = BabyMoniterSDPlayback.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
            } else {
                if (mCameraInfo.getDevTypeID() == 2)
                    fragment = SingleVideoPlaybackNVRFragment.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
                else
                    fragment = BabyMoniterPlaybackNVRFragment.newInstance(this.mSeekTime, mCameraInfo, mVideoPlayCallback);
            }
        }
        return fragment;
    }


    @Override
    public void videoViewStatus(int status) {
        super.videoViewStatus(status);
        if (mCurrentFrgment != null)
            mCurrentFrgment.videoViewStatus(status);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (mView == null)
            return;
        if (isVisibleToUser) {
            if (mCurrentFrgment == null)
                changeTab(mPlaybackType);
        }
        if (mCurrentFrgment != null)
            mCurrentFrgment.setFragmentStatus(isVisibleToUser);
        if (isVisibleToUser) {
            if (this.mVideoPlayCallback.getRightImageView() != null)
                this.mVideoPlayCallback.getRightImageView().setVisibility(View.VISIBLE);
            if (this.mVideoPlayCallback.getRightView() != null)
                this.mVideoPlayCallback.getRightView().setVisibility(View.GONE);

        } else {
            if (this.mVideoPlayCallback.getRightImageView() != null)
                this.mVideoPlayCallback.getRightImageView().setVisibility(View.GONE);
            if (this.mVideoPlayCallback.getRightView() != null)
                this.mVideoPlayCallback.getRightView().setVisibility(View.VISIBLE);
            if (mCurrentFrgment != null) {
                mCurrentFrgment.stopVideoRecord();
                mCurrentFrgment.pauseViPlaydeo();
            }
        }
    }

    public void networkClose() {
        if (mView == null)
            return;
        if (mCurrentFrgment != null)
            mCurrentFrgment.videoViewStatus(SingleVideoActivity.STATUS_PLAY);
    }
}
