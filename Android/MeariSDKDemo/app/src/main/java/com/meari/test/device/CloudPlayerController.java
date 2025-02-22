package com.meari.test.device;

import android.app.Activity;
import android.content.Context;
import android.net.Uri;
import android.util.SparseArray;
import android.view.View;

import androidx.annotation.NonNull;

import com.meari.sdk.callback.ICloudPlayerCallback;
import com.meari.sdk.utils.Logger;
import com.ppstrong.weeye.widget.media.IjkVideoView;

import java.util.Set;

public class CloudPlayerController implements IjkVideoView.MediaCallback {
    private Context mContext;
    private String mVideoPath;
    private Uri mVideoUri;
    private IjkVideoView mVideoView;
    private boolean mBackPressed = false;
    private ICloudPlayerCallback mCallback;

    public CloudPlayerController(Context context, View view, ICloudPlayerCallback callback) {
        this.mContext = context;
        this.mCallback = callback;
        this.mVideoView = (IjkVideoView) view;
    }

    public void play(String Url, String startTime) {
        mVideoPath = Url;
        mVideoView.setMediaCallback(this);
        mVideoView.setStartTime(startTime);
        if (mVideoPath != null) {
            mVideoView.setVideoPath(mVideoPath);
        } else if (mVideoUri != null) {
            mVideoView.setVideoURI(mVideoUri);
        } else {
            ((Activity) mContext).finish();

            return;
        }
        //暂停时候也可以开始
        mVideoView.setPasue(true);
        mVideoView.start();
    }

    public void setDecKey(Set<String> key) {
        mVideoView.setDecKey(key);
    }

    public void setExtraParams(SparseArray<Object> extra){
        mVideoView.setExtraParams(extra);
    }

    public int changeDecKeyAndReplay(String newKey) {
        return mVideoView.changeDecKeyAndReplay(newKey);
    }

    public void pause(boolean b) {
        if (mVideoView == null || mVideoView.getMediaPlayer() == null) {
            return;
        }
        this.mVideoView.setPasue(b);
        if (b) {
            this.mVideoView.getMediaPlayer().resume();
        } else {
            this.mVideoView.getMediaPlayer().pause();
        }
    }

    public void stop() {
        if (mVideoView != null) {
            if (mBackPressed || !mVideoView.isBackgroundPlayEnabled()) {
                Logger.i("CloudPlayerFragment", "cameraPlayer-停止云回放--释放资源");
                mVideoView.stopPlayback();
                mVideoView.release(true);
                mVideoView.stopBackgroundPlay();
            } else {
                Logger.i("CloudPlayerFragment", "cameraPlayer-停止云回放--enterBackground");
                mVideoView.enterBackground();
            }
        }
    }

    public IjkVideoView getVideoView() {
        return mVideoView;
    }

    public void release() {
        if (this.mVideoView != null && mVideoView.getMediaPlayer() != null) {
            mVideoView.getMediaPlayer().release();
        }
    }

    public void screenshot(String path) {
        if (this.mVideoView != null && mVideoView.getMediaPlayer() != null && mVideoView.getMediaPlayer().isPlaying()) {
            mVideoView.getMediaPlayer().snapShotJepg(path);
        }
    }

    public void startRecordMP4(String path) {
        if (mVideoView != null && mVideoView.getMediaPlayer() != null && mVideoView.getMediaPlayer().isPlaying()) {
            this.mVideoView.getMediaPlayer().recordMp4Start(path);
        }
    }

    public void stopRecordMP4() {
        if (mVideoView != null && mVideoView.getMediaPlayer() != null) {
            this.mVideoView.getMediaPlayer().recordMp4Stop();
        }
    }

    public void setMute(boolean mute) {
        if (this.mVideoView != null) {
            this.mVideoView.audioMute(mute);
            if (this.mVideoView.getMediaPlayer() != null) {
                this.mVideoView.getMediaPlayer().audioMute(mute);
            }
        }
    }

    public int setSpeed(double speed) {
        return mVideoView.setSpeed(speed);
    }

    public void setPlayOther(boolean playOther) {
        mVideoView.setPlayOther(playOther);
    }

    public void seekTo(int msec) {
        mVideoView.seekTo(msec);
    }

    @NonNull
    public String getStreamInfo(){
        return mVideoView.getStreamInfo();
    }

    public int setPlayNextOnError(boolean enable){
        if (mVideoView != null) {
            return mVideoView.setPlayNextOnError(enable);
        } else {
            return 0;
        }
    }

    @Override
    public void mediaPlayingCallback() {
        mCallback.mediaPlayingCallback();
    }

    @Override
    public void mediaPauseCallback() {
        mCallback.mediaPauseCallback();
    }

    @Override
    public void upDateProgress(long position) {
        mCallback.upDateProgress(position);
    }

    @Override
    public void mediaPlayFailedCallback(int code) {
        mCallback.mediaPlayFailedCallback();
    }

    @Override
    public void playNext() {
        mCallback.playNext();
    }

    @Override
    public void stopRecordVideo() {
        mCallback.stopRecordVideo();
    }

    @Override
    public void showStopRecordVideoView(String path) {
        mCallback.showStopRecordVideoView(path);
    }

    @Override
    public void screenshotSuccess(String path) {
        mCallback.screenshotSuccess(path);
    }
}


