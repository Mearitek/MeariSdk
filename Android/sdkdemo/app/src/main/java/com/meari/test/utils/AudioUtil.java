package com.meari.test.utils;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.media.MediaPlayer;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Created by pupu on 2017/7/25.
 * pcm文件播放工具类
 */

public class AudioUtil {

    static AudioUtil audioUtil;
    byte[] mData;
    private int mPrimePlaySize = 0;
    private int mPlayOffset = 0;
    private Thread playThread = null;
    private boolean mThreadExitFlag = false;
    AudioTrack track;
    boolean isPlaying = false;

    public static AudioUtil getInstance() {
        if (audioUtil == null) {
            audioUtil = new AudioUtil();
        }
        return audioUtil;
    }

    public interface OnPlayListener {
        //true：播放结束
        void isOver(boolean flag);
    }

    private OnPlayListener onPlayListener;

    public void setOnPlayListener(OnPlayListener onPlayListener) {
        this.onPlayListener = onPlayListener;
    }

    /**
     * 播放PCM文件,自带控制
     *
     * @param path
     */
    public void playPCM(final String path) {
        if (isPlaying) {
            //如果正在播，则什么都不用做
            return;
        }
        isPlaying = true;
        mThreadExitFlag = false;
        if (track == null) {
            int bufferSize = AudioTrack.getMinBufferSize(8000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
            mPrimePlaySize = bufferSize * 2;
            track = new AudioTrack(AudioManager.STREAM_MUSIC,
                    8000,
                    AudioFormat.CHANNEL_OUT_MONO,
                    AudioFormat.ENCODING_PCM_16BIT,
                    bufferSize,
                    AudioTrack.MODE_STREAM);
        }
        playThread = new Thread(new Runnable() {
            @Override
            public void run() {
                int length = 0;
                try {
                    FileInputStream fin = new FileInputStream(path);
                    InputStream in = new BufferedInputStream(fin);
                    length = in.available();
                    mData = new byte[length];
                    in.read(mData);
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                    isPlaying = false;
                    mPlayOffset = 0;
                    mData = null;
                    return;
                }
                track.play();
                while (mThreadExitFlag == false) {
                    try {
                        int size = track.write(mData, mPlayOffset, mPrimePlaySize);
                        mPlayOffset += mPrimePlaySize;
                    } catch (Exception e) {
                        e.printStackTrace();
                        break;
                    }
                    if (mPlayOffset >= mData.length) {
                        break;
                    }
                }
                if (track != null) {
                    track.stop();
                }
                if (onPlayListener != null) {
                    //发送播放结束标志
                    onPlayListener.isOver(true);
                }
                isPlaying = false;
                mPlayOffset = 0;
                mData = null;
            }
        });
        playThread.start();
    }

    /**
     * 停止播放
     */
    public void stopPlayPCM() {
        if (audioUtil == null || track == null) {
            return;
        }
        //停止播放线程
        playThread.interrupt();
        track = null;
    }

    public void playWAV(String path) {
        /* 获得MeidaPlayer对象 */
        MediaPlayer mediaPlayer = new MediaPlayer();
        try {
            /* 为MediaPlayer 设置数据源 */
            mediaPlayer.setDataSource(path);

            /* 准备 */
            mediaPlayer.prepare();

            Thread.sleep(1000);

            /*播放*/
            mediaPlayer.start();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
