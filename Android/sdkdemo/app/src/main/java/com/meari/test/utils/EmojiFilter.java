package com.meari.test.utils;


import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by pps on 2016/3/8.
 */
public class EmojiFilter {


    /** 匹配非表情符号的正则表达式 */
    public static final String reg = "^([a-z]|[A-Z]|[0-9]|[\u2E80-\u9FFF]){3,}|@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?|[wap.]{4}|[www.]{4}|[blog.]{5}|[bbs.]{4}|[.com]{4}|[.cn]{3}|[.net]{4}|[.org]{4}|[http://]{7}|[ftp://]{6}$";

    public static final Pattern pattern = Pattern.compile(reg);

    /**
     * 检测是否有emoji字符
     *
     * @param source
     * @return FALSE，包含图片
     */
    public static boolean containsEmoji(String source) {
        if (source.isEmpty()) {
            return false;
        }

        int len = source.length();

        for (int i = 0; i < len; i++) {
            char codePoint = source.charAt(i);

            if (isEmojiCharacter(codePoint)) {
                // do nothing，判断到了这里表明，确认有表情字符
                return true;
            }
        }

        return false;
    }

    private static boolean isEmojiCharacter(char codePoint) {
        return (codePoint == 0x0) || (codePoint == 0x9) || (codePoint == 0xA)
                || (codePoint == 0xD)
                || ((codePoint >= 0x20) && (codePoint <= 0xD7FF))
                || ((codePoint >= 0xE000) && (codePoint <= 0xFFFD))
                || ((codePoint >= 0x10000) && (codePoint <= 0x10FFFF));
    }

    /**
     * 过滤emoji 或者 其他非文字类型的字符
     *
     * @param source
     * @return
     */
    public static String filterEmoji(String source) {

        if (!containsEmoji(source)) {
            return source;// 如果不包含，直接返回
        }
        // 到这里铁定包含
        StringBuilder buf = null;

        int len = source.length();

        for (int i = 0; i < len; i++) {
            char codePoint = source.charAt(i);

            if (isEmojiCharacter(codePoint)) {
                if (buf == null) {
                    buf = new StringBuilder(source.length());
                }

                buf.append(codePoint);
            } else {
            }
        }

        if (buf == null) {
            return source;// 如果没有找到 emoji表情，则返回源字符串
        } else {
            if (buf.length() == len) {// 这里的意义在于尽可能少的toString，因为会重新生成字符串
                buf = null;
                return source;
            } else {
                return buf.toString();
            }
        }

    }
    public static boolean isNormalString(String email) {
        String str = "^[A-Za-z0-9 \\u4e00-\\u9fa5._%+-]{1,20}$";
        Pattern p = Pattern.compile(str);
        Matcher m = p.matcher(email);
        return m.matches();
    }


}
