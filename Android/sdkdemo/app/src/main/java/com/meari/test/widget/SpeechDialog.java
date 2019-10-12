package com.meari.test.widget;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;

import com.meari.test.R;


/**
 * 录音对话框
 * Created by linweihan on 2015/12/30.
 */
public class SpeechDialog extends Dialog {

    private ImageView imgVolume;    // 声音图片

    public SpeechDialog(Context context) {
        super(context, R.style.dialog_speech_theme);
        View view = LayoutInflater.from(context).inflate(R.layout.dlg_speech, null);
        imgVolume = (ImageView) view.findViewById(R.id.speech_volume);
        getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        setCanceledOnTouchOutside(false);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(view);
    }

    /**
     * 设置音量
     *
     * @param volume 音量
     */
    public void setVolume(int volume) {
        imgVolume.setVisibility(View.VISIBLE);
        switch (volume / 10) {
            case 0:
                imgVolume.setVisibility(View.INVISIBLE);
                break;
            case 1:
                imgVolume.setBackgroundResource(R.mipmap.speech_progress_1);
                break;
            case 2:
                imgVolume.setBackgroundResource(R.mipmap.speech_progress_2);
                break;
            case 3:
            case 4:
                imgVolume.setBackgroundResource(R.mipmap.speech_progress_3);
                break;
            case 5:
            case 6:
                imgVolume.setBackgroundResource(R.mipmap.speech_progress_4);
                break;
            case 7:
            case 8:
                imgVolume.setBackgroundResource(R.mipmap.speech_progress_5);
                break;
            default:
                imgVolume.setBackgroundResource(R.mipmap.speech_progress_6);
                break;
        }
    }
}