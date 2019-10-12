package com.meari.test.utils;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.util.DisplayMetrics;
import android.util.TypedValue;

import java.lang.reflect.Field;

/**
 * Created by aaron on 16/8/3.
 */
public class DisplayUtil
{

    private DisplayUtil() {
    }

    /**
     * 将px值转换为dip或dp值，保证尺寸大小不变
     */
    public static final int px2dip(Context context, float pxValue) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    /**
     * 将px值转换为dip或dp值，保证尺寸大小不变
     */
    public static final int px2dip(Resources res, float pxValue) {
        float scale = res.getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    /**
     * 将dip或dp值转换为px值，保证尺寸大小不变
     */
    public static final int dpToPx(Context context, int dp) {
        Resources r = context.getResources();
        int px = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, r.getDisplayMetrics());
        return px;
    }

    /**
     * 将dimen中的值转换为px值，保证尺寸大小不变
     */
    public static final int dimenToPx(Context context, int rDimen) {
        Resources r = context.getResources();
        return r.getDimensionPixelSize(rDimen);
    }

    /**
     * 将px值转换为sp值，保证文字大小不变
     *
     * @param pxValue
     * @param fontScale （DisplayMetrics类中属性scaledDensity）
     * @return
     */
    public static final int px2sp(float pxValue, float fontScale) {
        return (int) (pxValue / fontScale + 0.5f);
    }

    /**
     * 将sp值转换为px值，保证文字大小不变
     *
     * @param spValue
     * @param fontScale （DisplayMetrics类中属性scaledDensity）
     * @return
     */
    public static final int sp2px(float spValue, float fontScale) {
        return (int) (spValue * fontScale + 0.5f);
    }

    /**
     * 获取屏幕宽、高；返回一个数组，[0] = width, [1] = height
     */
    public static final int[] getDisplayPxArray(Context context) {
        int displays[] = new int[2];
        DisplayMetrics dm = context.getResources().getDisplayMetrics();
        displays[0] = dm.widthPixels;
        displays[1] = dm.heightPixels;
        return displays;
    }
    /**
     * 获取屏幕宽；返回int
     */
    public static final int getDisplayPxHeight(Context context) {
        DisplayMetrics dm = context.getResources().getDisplayMetrics();
        return dm.heightPixels;
    }
    /**
     * 获取屏幕宽；返回int
     */
    public static final int getDisplayPxWidth(Context context) {
        DisplayMetrics dm = context.getResources().getDisplayMetrics();
        return dm.widthPixels;
    }
    /**
     * 获取状态栏高度px
     */
    public static final int getStatusBarHigh(Resources res) {
        int statusBar = 0;
        try {
            Class<?> c;
            c = Class.forName("com.android.internal.R$dimen");
            Object obj = c.newInstance();
            Field field = c.getField("status_bar_height");
            int x = Integer.parseInt(field.get(obj).toString());
            statusBar = res.getDimensionPixelSize(x);
        } catch (Exception e) {
            statusBar = 0;
        }
        return statusBar;
    }
    /**
     * 将dip或dp值转换为px值，保证尺寸大小不变
     *
     * @param dipValue
     * @param （DisplayMetrics类中属性density）
     * @return
     */
    public static int dip2px(Context context, float dipValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dipValue * scale + 0.5f);
    }

    /**
     * 将px值转换为sp值，保证文字大小不变
     *
     * @param pxValue
     * @param （DisplayMetrics类中属性scaledDensity）
     * @return
     */
    public static int px2sp(Context context, float pxValue) {
        final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
        return (int) (pxValue / fontScale + 0.5f);
    }

    /**
     * 将sp值转换为px值，保证文字大小不变
     *
     * @param spValue
     * @param （DisplayMetrics类中属性scaledDensity）
     * @return
     */
    public static int sp2px(Context context, float spValue) {
        final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
        return (int) (spValue * fontScale + 0.5f);
    }

    /**
     * 根据分辨率获取大小
     *
     * @param mActivity
     * @return 这个方法主要是给引导页用的
     */
    public static int getSize(Activity mActivity) {
        DisplayMetrics dm = getDm(mActivity);
        int height = 0;
        if (dm.widthPixels <= 480) {// 分辨率
            height = 16;
        } else if (dm.widthPixels <= 720) {// 分辨率
            height = 18;
        } else if (dm.widthPixels <= 1080) {// 分辨率
            height = 28;
        } else if (dm.widthPixels <= 1440) {// 分辨率
            height = 28;
        } else if (dm.widthPixels <= 1920) {
            height = 32;
        }
        return height;
    }


    /**
     * 根据分辨率获取大小
     *
     * @param mActivity
     * @return 这个方法主要是给页面中带广告用的viewpager
     */
    public static int getSize2(Activity mActivity) {
        DisplayMetrics dm = getDm(mActivity);
        int height = 0;
        if (dm.widthPixels <= 480) {// 分辨率
            height = 11;
        } else if (dm.widthPixels <= 720) {// 分辨率
            height = 13;
        } else if (dm.widthPixels <= 1080) {// 分辨率
            height = 16;
        } else if (dm.widthPixels <= 1440) {// 分辨率
            height = 18;
        } else if (dm.widthPixels <= 1920) {
            height = 18;
        }
        return height;
    }

    public static DisplayMetrics getDm(Activity mActivity){
        DisplayMetrics dm = new DisplayMetrics();
        mActivity.getWindowManager().getDefaultDisplay().getMetrics(dm);
        return dm;
    }

    public static float getDensity(Context mActivity){
        DisplayMetrics localDisplayMetrics = mActivity.getResources()
                .getDisplayMetrics();
        return localDisplayMetrics.density;
    }

}
