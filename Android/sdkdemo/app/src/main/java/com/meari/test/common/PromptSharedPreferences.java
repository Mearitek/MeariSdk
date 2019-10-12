package com.meari.test.common;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/7/7
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class PromptSharedPreferences {
    private SharedPreferences sp;

    // 保存
    public void saveSharedPreferences(Context context, String activity, String save) {
        sp = context.getSharedPreferences("prompt", context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(activity, save);
        editor.commit();// 保存新数据
    }

    // 取出
    public boolean takeSharedPreferences(Context context, String activity) {
        String str = "";
        sp = context.getSharedPreferences("prompt", context.MODE_PRIVATE);
        str = sp.getString(activity, "");
        if (str.isEmpty()) {
            return false;
        } else {
            return true;
        }
    }
}

