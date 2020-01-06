package com.meari.test.common;

import androidx.viewpager.widget.ViewPager;
import android.widget.ImageView;
import android.widget.TextView;

import com.ppstrong.ppsplayer.CameraPlayer;

/**
 * Created by Administrator on 2016/11/28.
 */

public interface VideoPlayCallback {
    CameraPlayer getCameraPlayer();

    /**
     * sd or hd
     *
     * @return
     */
    TextView getRightView();

    /**
     * cloud , sd ,nvr
     *
     * @return
     */
    ImageView getRightImageView();

    /**
     * @return connect status
     */
    int getConnectStatus();

    void setConnectStatus(int i);

    void onRefresh();

    void chagePlayType(boolean b);

    int getCurVideoType();

    ViewPager getViewPage();

    boolean getSleepMode();

    void setSleepMode(boolean b);

    boolean getFinshStatus();

    void setSdcardStatus(int status);

    boolean iSSoundStatus();
    void changeSoundStatus(boolean enable);

    boolean getSDCardStatus();
    void postUpDataDevice(String firmware_version);
}
