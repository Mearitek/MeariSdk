package com.meari.test.utils;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：String 工具类
 * 修订历史：
 * ================================================
 */

public class StringUtil {
    public static boolean isNotNull(String str){
        if(str!=null && !str.isEmpty()){
            return true;
        }
        return false;
    }

    public static boolean isNull(String str){
        if(str==null || str.isEmpty()){
            return true;
        }
        return false;
    }
}

