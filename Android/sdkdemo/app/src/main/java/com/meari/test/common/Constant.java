package com.meari.test.common;

import android.content.Context;
import android.os.Environment;
import android.util.DisplayMetrics;

import java.io.File;

/**
 * 常量
 * Update by chengjianjia on 2015/12/28.
 */
public class Constant {
    /**
     * 文档根目录
     **/
    public static final String DOCUMENT_ROOT_PATH = Environment.getExternalStorageDirectory().getAbsolutePath() +
            "/" + StringConstants.MEARI_SDK + "/";

    /**
     * 缓存目录
     */
    public static String DOCUMENT_CACHE_URL_PATH = DOCUMENT_ROOT_PATH + "cache/videourl/";
    /**
     * 缓存目录
     */
    public static String DOCUMENT_CACHE_PATH = DOCUMENT_ROOT_PATH + "cache/";
    /**
     * 视频前缀
     **/
    public static final String VIDEO_PRE = "pp_";
    /**
     * 图片前缀
     **/
    public static final String PICTURE_PRE = "pp_";
    public static  int statusHeight = 0 ;


    public static boolean isNetworkAvailable;

    static {
        new File(DOCUMENT_ROOT_PATH).mkdirs();
        new File(DOCUMENT_CACHE_PATH).mkdirs();
        new File(DOCUMENT_CACHE_URL_PATH).mkdirs();
    }

    public static   int width;
    public static int height;
    public static float density;

    // 初始化配置信息
    public static void init(Context context) {
        DisplayMetrics localDisplayMetrics = context.getResources()
                .getDisplayMetrics();
        int widthDisplay = localDisplayMetrics.widthPixels;
        int heightDisplay = localDisplayMetrics.heightPixels;
        density = localDisplayMetrics.density;
        width = widthDisplay < heightDisplay ? widthDisplay : heightDisplay;
        height = heightDisplay > widthDisplay ? heightDisplay : widthDisplay;
        try {
            Class<?> clazz = Class.forName("com.android.internal.R$dimen");
            Object object = clazz.newInstance();
            int height = Integer.parseInt(clazz.getField("status_bar_height")
                    .get(object).toString());
            statusHeight = context.getResources().getDimensionPixelSize(height);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public float getDensity() {
        return density;
    }

    public void setDensity(float density) {
        this.density = density;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }
}
