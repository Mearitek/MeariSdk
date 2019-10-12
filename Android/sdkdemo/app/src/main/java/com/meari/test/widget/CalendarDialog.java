package com.meari.test.widget;

import android.app.Dialog;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.test.R;

import java.text.SimpleDateFormat;
import java.util.ArrayList;

/**
 * 弹出的日历对话框
 * Created by yejunjie on 2015/12/30.
 */
public class CalendarDialog extends Dialog {

    private final int HANDLER_MSG_UPDATA_DAYS = 101;    // 更新有视频的日期
    private CalendarView calendarView;                  //日历控件
    private ImageView calendarLeft;                   //按钮（点击上个月）
    private TextView calendarCenter;                    //顶部提示文字
    private ImageView calendarRight;                  //按钮（点击下个月）
    private SimpleDateFormat format;
    private String[] mouthNum;                         //用于存储英文月份
    private Context context;
    private CalendarDayInterface curPlayer;     // 当前播放
    private CalendarView.OnItemClickListener onItemClickListener;   // 点击获取日期回调

    /**
     * 有视频的日期
     */
    private int mYear;
    private int mMonth;
    private int mDay;

    public CalendarDialog(Context context, CalendarDayInterface curPlayer, CalendarView.OnItemClickListener onItemClickListener, boolean babymoniter) {
        super(context, R.style.CalendarDialog);
        this.context = context;
        this.curPlayer = curPlayer;
        this.onItemClickListener = onItemClickListener;
        mouthNum = context.getResources().getStringArray(R.array.monthNum);
        format = new SimpleDateFormat("yyyy-MM-dd");
        setCustomDialog(babymoniter);
    }

    public void initCustomDialog(int year, int month, int day) {
        this.mYear = year;
        this.mMonth = month;
        this.mDay = day;
        calendarView.init(year, month, day);
        calendarView.setDownDate(this.mYear, this.mMonth, this.mDay);
        String[] ya = calendarView.getYearAndmonth().split("-");
        setTitle(ya[0], getENGMonthNum(ya[1]));
    }

    /**
     * 设置对话框内布局
     * @param babymoniter
     */
    private void setCustomDialog(boolean babymoniter) {
        View mView = LayoutInflater.from(getContext()).inflate(R.layout.layout_calendar, null);
        super.setContentView(mView);
        calendarView = (CalendarView) findViewById(R.id.calendar);
        calendarView.setCalendarDayInterface(curPlayer);
        calendarView.setSelectMore(false); //单选
        calendarLeft = (ImageView) findViewById(R.id.calendarLeft);
        calendarCenter = (TextView) findViewById(R.id.calendarCenter);
        calendarRight = (ImageView) findViewById(R.id.calendarRight);
        if (babymoniter)
        {
            calendarLeft.setImageResource(R.mipmap.ic_ca_baby_left);
            calendarRight.setImageResource(R.mipmap.ic_can_baby_right);
            calendarCenter.setTextColor(getContext().getResources().getColor(R.color.com_yellow));
        }else
        {
            calendarLeft.setImageResource(R.mipmap.ic_ca_left);
            calendarRight.setImageResource(R.mipmap.ic_can_right);
            calendarCenter.setTextColor(getContext().getResources().getColor(R.color.com_blue));
        }
        calendarLeft.setOnClickListener(leftClickListener);
        calendarRight.setOnClickListener(rightClickListener);
        calendarView.setOnItemClickListener(onItemClickListener);


    }

    /**
     * 点击上个月
     */
    private View.OnClickListener leftClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            String leftYearAndmonth = calendarView.clickLeftMonth();//点击上一月 同样返回年月
            String[] ya = leftYearAndmonth.split("-");
            setTitle(ya[0], getENGMonthNum(ya[1]));
            int year = calendarView.getYear();
            int month = calendarView.getMonth();
            ArrayList<Integer> days = curPlayer.getDaysOfMonth(year, month);
            if (days == null || days.size() == 0) {
                curPlayer.SearchVideoByMonth(year, month);
            } else if (curPlayer != null) {
                calendarView.refreshDays(days);
            }
        }
    };


    /**
     * 更新日期
     */
    private Handler searchVideoHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case HANDLER_MSG_UPDATA_DAYS:
                    calendarView.refreshDays(curPlayer.getDaysOfMonth(mYear, mMonth));
                    break;
            }
        }
    };


    public void refreshVideoDay() {
        searchVideoHandler.sendEmptyMessage(HANDLER_MSG_UPDATA_DAYS);
    }

    public void refreshVideoDayByMonth(String yearAndMonth) {
        if (calendarView == null)
            return;
        String curYearAndmonth = calendarView.getCurYearAndmonth();
        if (!curYearAndmonth.equals(yearAndMonth)) {
            return;
        }
        searchVideoHandler.sendEmptyMessage(HANDLER_MSG_UPDATA_DAYS);
    }

    /**
     * 点击下个月
     */
    private View.OnClickListener rightClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            String rightYearAndmonth = calendarView.clickRightMonth();//点击下一月
            String[] ya = rightYearAndmonth.split("-");
            setTitle(ya[0], getENGMonthNum(ya[1]));
            int year = calendarView.getYear();
            int month = calendarView.getMonth();
            ArrayList<Integer> days = curPlayer.getDaysOfMonth(year, month);
            if (days == null || days.size() == 0) {
                curPlayer.SearchVideoByMonth(year, month);
            } else if (curPlayer != null) {
                calendarView.refreshDays(days);
            }
        }
    };

    private void setTitle(String year, String month) {
        calendarCenter.setText(month + " " + year);
    }

    /**
     * 将数字 转为英文月份
     *
     * @param str
     * @return
     */
    public String getENGMonthNum(String str) {
        for (int i = 1; i < 13; i++) {
            if (str.equals(String.valueOf(i))) {
                str = mouthNum[i - 1];
            }
        }
        return str;
    }


    public void setDownDate(int year, int month, int day) {
        this.mYear = year;
        this.mMonth = month;
        this.mDay = day;
    }

    public interface CalendarDayInterface {
        void SearchVideoByMonth(int year, int month);

        ArrayList<Integer> getDaysOfMonth(int year, int month);
    }
}
