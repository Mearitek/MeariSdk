package com.meari.test.widget;

import android.content.Context;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.common.Constant;
import com.meari.test.utils.DisplayUtil;


/**
 * 温度计
 * Created by ljh on 2015/12/29.
 */
public class ScaleHumidityView extends RelativeLayout {
    private float MAX_VALUE = 0;
    private float MAX_LENGTH = 0;
    private final float MAX_Humidity = 100;
    private final float MIN_Humidity = 0;
    private float WIDTH_INDICATOR = 0;
    private final float SCALE_BG_WIDTH = 319.0f;//背景图片宽度
    private final float SCALE_BG_HEIGHT = 67.0f;//背景尺图片高度
    private ImageView mIndicator;
    private final float TEM_TOTAL = 100.0f;//总共显示45个摄氏度温度
    private final float BLAN_TOTAL = 51.0f;//图片显示两边空白位置
    private final float BLANK_LEFT = 25.0f;//图片显示左边空白位置
    private final float SCALE_WIDTH = 690.0f;//刻度尺图片宽度
    private final float SCALE_HEIGHT = 62.0f;//刻度尺图片高度
    private final float INDICAT_WIDTH = 13.0f;//指示图片宽度
    private final float INDICAT_HEIGHT = 60.0f;//指示尺图片高度
    private final float WIDTH_BLANK = 48.0f;//刻度尺图片宽度
    private final float PADDING_TOTAL = 48.0f;//刻度尺图片宽度

    public ScaleHumidityView(Context context) {
        super(context);
    }

    public ScaleHumidityView(Context context, AttributeSet attrs) {
        super(context, attrs);

    }

    public ScaleHumidityView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    public void init() {
        LayoutInflater.from(getContext()).inflate(R.layout.layout_thumidity, this);
        mIndicator =  findViewById(R.id.img_ter_indicator);
        View scrollView = findViewById(R.id.rought_rule_layout);
        LayoutParams scrollViewParams = (LayoutParams) scrollView.getLayoutParams();
        scrollViewParams.height = (int) ((Constant.width - DisplayUtil.dpToPx(getContext(), (int) WIDTH_BLANK)) * SCALE_BG_HEIGHT / (2 * SCALE_BG_WIDTH));
        scrollView.setLayoutParams(scrollViewParams);
        ImageView img_termp =  findViewById(R.id.img_termp);
        FrameLayout.LayoutParams params = (FrameLayout.LayoutParams) img_termp.getLayoutParams();
        params.width = (int) (1.2 * (Constant.width - DisplayUtil.dpToPx(getContext(), (int) WIDTH_BLANK) - DisplayUtil.dpToPx(getContext(), (int) (2 * PADDING_TOTAL))));
        params.height = (int) (params.width * SCALE_HEIGHT / SCALE_WIDTH);
        img_termp.setLayoutParams(params);
        MAX_LENGTH = params.width;
        MAX_VALUE = params.width - BLAN_TOTAL * MAX_LENGTH / SCALE_WIDTH;
        FrameLayout.LayoutParams indicatorParam;
        indicatorParam = (FrameLayout.LayoutParams) mIndicator.getLayoutParams();
        indicatorParam.height = (int) (scrollViewParams.height * INDICAT_HEIGHT / SCALE_HEIGHT);
        indicatorParam.width = (int) (indicatorParam.height * INDICAT_WIDTH / INDICAT_HEIGHT);
        WIDTH_INDICATOR = indicatorParam.width;
    }

    public void setHumidity(float humidity) {
        if (humidity < MIN_Humidity)
            humidity = MIN_Humidity;
        else if (humidity > MAX_Humidity)
            humidity = MAX_Humidity;
        this.mIndicator.setVisibility(View.VISIBLE);
        FrameLayout.LayoutParams param = (FrameLayout.LayoutParams) mIndicator.getLayoutParams();
        float leftMargin = (humidity - MIN_Humidity) * MAX_VALUE / TEM_TOTAL + BLANK_LEFT * MAX_LENGTH / SCALE_WIDTH;
        param.leftMargin = (int) (leftMargin - WIDTH_INDICATOR / 2);
        mIndicator.setLayoutParams(param);
        TextView text_tem =  findViewById(R.id.text_tem);
        text_tem.setText(String.format("%d",  (int)humidity) + "%RH");
        TextView temp_desc =  findViewById(R.id.temp_desc);
        if (humidity < MIN_Humidity)
            humidity = MIN_Humidity;
        else if (humidity > MAX_Humidity)
            humidity = MAX_Humidity;
        if (humidity < 30) {
            temp_desc.setText(getContext().getString(R.string.dry));
        } else if (humidity > 70) {
            temp_desc.setText(getContext().getString(R.string.wet));
        } else {
            temp_desc.setText(getContext().getString(R.string.suitable));
        }
        scollToHumidity(humidity);
    }

    public void scollToHumidity(final float humidity) {
        new Handler().post(new Runnable() {
            @Override
            public void run() {
                float leftMargin = (humidity  - MIN_Humidity -25) * MAX_VALUE / TEM_TOTAL + BLANK_LEFT * MAX_LENGTH / SCALE_WIDTH;
                RuleHorizontalScrollView scrollview = findViewById(R.id.scoll_termp);
                scrollview.scrollTo((int) leftMargin,0);
            }
        });
    }
}

