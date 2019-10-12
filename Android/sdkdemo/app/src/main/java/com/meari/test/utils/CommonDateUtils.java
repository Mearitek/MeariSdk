package com.meari.test.utils;

import android.annotation.SuppressLint;
import android.text.TextUtils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by Administrator on 2016/10/31.
 */
public class CommonDateUtils {

    static Calendar calendar = null;

    /**
     * 时间戳转换成日期格式
     *
     * @param date
     * @return yyyy-MM-dd
     */
    public static String getDateTimeForTimeStamp(String date) {
        long ss = Long.parseLong(date);
        long l = ss * 1000L;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        String sds = sdf.format(new Date(l));
        return sds;
    }

    /**
     * 日期格式转换成时间戳
     *
     * @param date
     * @return
     * @throws ParseException
     */
    public static String getTimeStampForDateTime(String date) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
        Date dates = null;
        try {
            dates = format.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return String.valueOf(dates.getTime() / 1000);
    }

    /**
     * 时间戳转换成日期格式
     *
     * @param date
     * @return yyyy-MM-dd hh:mm:ss
     */
    public static String getTimeForTimeStamp(String date) {
        long ss = Long.parseLong(date);
        long l = ss * 1000L;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
        String sds = sdf.format(new Date(l));
        return sds;
    }

    /**
     * 获取系统最新时间
     *
     * @return
     */
    public static long getNowTimeStamp() {
        Date date = new Date();
        return date.getTime();
    }

    /**
     * 获取系统最新时间
     *
     * @return
     */
    public static String getDateTime() {
        return getDateTimeForTimeStamp(String.valueOf(getNowTimeStamp() / 1000));
    }

    /**
     * 判断两个日期是否相等
     *
     * @param td
     * @param dt
     * @return
     */
    public static boolean isSameDay(Date td, Date dt) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        String ds1 = sdf.format(td);
        String ds2 = sdf.format(dt);
        if (ds1.equals(ds2)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 将yyyy-mm-dd转换成yyyy年mm月dd日
     */
    public static String getDateToChinese(String dates) {
        String datetime = "";
        try {
            Date date = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).parse(dates);
            datetime = new SimpleDateFormat("yyyy年MM月dd日", Locale.getDefault()).format(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return datetime;
    }

    /**
     * 将yyyy-mm-dd转换成yyyy年mm月dd日
     */
    public static String getDateToChinese2(String dates) {
        String datetime = dates;
        try {
            Date date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).parse(dates);
            datetime = new SimpleDateFormat("yyyy.MM.dd", Locale.getDefault()).format(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return datetime;
    }

    /**
     * 将yyyy-mm-dd转换成yyyy年mm月dd日
     */
    public static String getDateToChinese3(String dates) {
        String datetime = dates;
        try {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            Date date = formatter.parse(dates);
            formatter = new SimpleDateFormat("yyyy.MM.dd");
            datetime = formatter.format(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return datetime;
    }

    /**
     * yyyy年mm月dd日 将转换成yyyy-mm-dd
     *
     * @throws ParseException
     */
    public static String getDateToEnglist(String dates) {
        String datetime = "";
        try {
            Date date = new SimpleDateFormat("yyyy年MM月dd日", Locale.getDefault()).parse(dates);
            datetime = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(date);
        } catch (Exception e) {
        }
        return datetime;
    }

    /**
     * 获取年月日
     *
     * @param date
     * @param type
     * @return
     */
    public static int getDateType(Date date, String type) {
        SimpleDateFormat yearFormat = new SimpleDateFormat(type, Locale.getDefault());
        String target = yearFormat.format(date);
        return Integer.parseInt(target);
    }

    /**
     * 获取年月日
     *
     * @param type
     * @return
     */
    public static int getCurrentDateType(String type) {
        Date date = new Date();
        return getDateType(date, type);
    }

    /**
     * 获取年月日
     *
     * @param date
     * @param type
     * @return
     */
    public static int getDateType(String date, String type) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        Date datetime = null;
        try {
            datetime = df.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (null == datetime) {
            datetime = new Date();
        }
        SimpleDateFormat yearFormat = new SimpleDateFormat(type, Locale.getDefault());
        String target = yearFormat.format(datetime);
        return Integer.parseInt(target);
    }

    public static String getDateFormat(String format) {
        Date date = new Date();
        SimpleDateFormat sd = new SimpleDateFormat(format, Locale.getDefault());
        return sd.format(date);
    }

    /**
     * 根据日期获取星座
     *
     * @param date 时间
     * @return 星座
     */
    public static String getConstellation(String date) {
        int month = getDateType(date, "MM");
        int day = getDateType(date, "dd");
        int[] dayArr = new int[]{20, 19, 21, 20, 21, 22, 23, 23, 23, 24, 23, 22};
        String[] constellationArr = new String[]{"摩羯座", "水瓶座", "双鱼座", "白羊座", "金牛座", "双子座", "巨蟹座", "狮子座", "处女座", "天秤座",
                "天蝎座", "射手座", "摩羯座"};
        return day < dayArr[month - 1] ? constellationArr[month - 1] : constellationArr[month];
    }

    /**
     * 下拉刷新的获取时间
     *
     * @return
     */
    public static CharSequence getRefreshDate() {
        Date date = new Date();
        SimpleDateFormat sd = new SimpleDateFormat("MM-dd HH:mm", Locale.getDefault());
        String result = sd.format(date);
        return result;
    }

    public static boolean compare_date(String minTime, String datetime) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        try {
            Date dt1 = df.parse(minTime);
            Date dt2 = df.parse(datetime);
            if (dt1.getTime() > dt2.getTime()) {
                return false;
            } else if (dt1.getTime() < dt2.getTime()) {
                return true;
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return false;
    }

    /**
     * 判断两个日期的大小 返回：1：明天；2：昨天；0：就是今天
     */
    public static int compare_datebig(String today, String date) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        try {
            Date dt1 = df.parse(today);
            Date dt2 = df.parse(date);
            if (dt1.getTime() > dt2.getTime()) {
                return 1;
            } else if (dt1.getTime() < dt2.getTime()) {
                return 2;
            } else if (dt1.getTime() == dt2.getTime()) {
                return 0;
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return 3;
    }

    /**
     * 获取后天时间
     *
     * @param cl
     * @return
     */
    public static String getAfterDay(String d, int afterNum) {
        if (TextUtils.isEmpty(d)) {
            d = "1970-01-01";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        Date date;
        Calendar cl = Calendar.getInstance();
        try {
            date = sdf.parse(d);
            cl.setTime(date);
            int day = cl.get(Calendar.DATE);
            cl.set(Calendar.DATE, day + afterNum);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        String dateStr = sdf2.format(cl.getTime());
        return dateStr;
    }

    @SuppressLint("SimpleDateFormat")
    public static boolean isDate(String date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            dateFormat.parse(date);
            return true;
        } catch (Exception e) {
            // 如果throw java.text.ParseException或者NullPointerException，就说明格式不对
            return false;
        }
    }

    /**
     * 将秒转换成*天*时*分*秒
     *
     * @param date 秒
     * @return
     */
    public static String getSToDate(long date) {
        long days = date / (60 * 60 * 24);
        long hours = (date % (60 * 60 * 24)) / (1000 * 60 * 60);
        long minutes = (date % (60 * 60)) / (1000 * 60);
        long seconds = (date % 60) / 1000;
        if (days > 0) {
            return days + "天" + hours + "小时" + minutes + "分" + seconds + "秒";
        }
        if (hours > 0) {
            return hours + "小时" + minutes + "分" + seconds + "秒";
        }
        if (minutes > 0) {
            return minutes + "分" + seconds + "秒";
        }
        if (seconds > 0) {
            return seconds + "秒";
        }
        return "0秒";

    }

    /**
     * 将服务器返回的秒转换为00:00:00格式
     */
    public static String formatDuring(long millis) {
        if (millis <= 0) {
            return "00:00:00";
        }
        long hours = 60 * 60 * 1000;
        long days = hours * 24; // 一天的毫秒

        long day = millis / days;
        long hour = (millis % days) / hours; // 小时
        long minute = (millis % hours) / (60 * 1000);
        long second = (millis % (1000 * 60)) / 1000;

        hour = day * 24 + hour;
        StringBuffer sBuffer = new StringBuffer(9);
        if (hour > 0) {
            sBuffer.append(format(hour)).append(":").append(format(minute)).append(":").append(format(second));
        } else {
            sBuffer.append(format(minute)).append(":").append(format(second));
        }
        return sBuffer.toString();
    }

    private static String format(long time) {
        if (time < 0) {
            return "00";
        } else if (time <= 9) {
            return "0" + time;
        } else {
            return Long.toString(time);
        }
    }

    /**
     * 将服务器返回的秒转换为天时分秒格式
     */
    public static String formatDate(long millis) {
        if (millis <= 0) {
            return "00:00:00";
        }
        long hours = 60 * 60 * 1000;
        long days = hours * 24; // 一天的毫秒

        long day = millis / days;
        long hour = (millis % days) / hours; // 小时
        long minute = (millis % hours) / (60 * 1000);
        long second = (millis % (1000 * 60)) / 1000;
        StringBuffer sBuffer = new StringBuffer(9);
        sBuffer.append(day + "天" + format(hour)).append("时").append(format(minute)).append("分")
                .append(format(second) + "秒");
        return sBuffer.toString();
    }

    /**
     * 获取系统微秒数
     */
    public static long getDateTimeLong() {
        long millionSeconds2 = 0;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            // 获取系统时间的毫秒数
            Date date = new Date();
            String time = sdf.format(date);
            millionSeconds2 = sdf.parse(time).getTime();// 毫秒
        } catch (Exception e) {
        }
        return millionSeconds2;
    }

    /**
     * 根据后台传递的时间获取两个时间的间隔
     *
     * @param getDateTime 后台传递的时间
     * @return
     */
    public static String getDateTimeFor(String getDateTime) {
        try {
            // 获取后台给的时间毫秒数
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            long millionSeconds = sdf.parse(getDateTime).getTime();// 毫秒
            // 获取系统时间的毫秒数
            Date date = new Date();
            String time = sdf.format(date);
            long millionSeconds2 = sdf.parse(time).getTime();// 毫秒

            long millis = millionSeconds2 - millionSeconds;

            if (millis <= 0) {
                return "刚刚";
            }
            long hours = 60 * 60 * 1000;
            long days = hours * 24; // 一天的毫秒

            // long month = millis / days / 30; //获取的月
            long week = millis / days / 7; // 获取的是星期

            long day = millis / days;
            long hour = (millis % days) / hours; // 小时
            long minute = (millis % hours) / (60 * 1000);
            // long second = (millis % (1000 * 60)) / 1000;
            if (week <= 2) {
                if (week > 0) {
                    return week + "个星期前";
                } else {
                    if (day > 0 && day <= 7) {
                        return day + "天前";
                    } else {
                        if (hour > 0) {
                            return hour + "小时前";
                        } else {
                            if (minute > 0) {
                                return minute + "分钟前";
                            } else {
                                return "刚刚";
                            }

                        }
                    }
                }
            } else {
                return getDateTime;
            }
        } catch (Exception e) {
            return getDateTime;
        }
    }

    /**
     * 获取时间
     *
     * @return
     */
    public static String getNowDate() {
        Date date = new Date();
        SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
        String result = sd.format(date);
        return result;
    }

}
