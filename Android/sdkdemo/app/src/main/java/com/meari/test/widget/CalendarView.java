package com.meari.test.widget;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.meari.test.R;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

/**
 * 日历控件 功能：获得点选的日期区间
 * Created by yejunjie on 2015/12/30.
 */
public class CalendarView extends View implements View.OnTouchListener {
    private final static String TAG = "anCalendar";
    private Date curDate;                            // 当前日历显示的月
    private Date today;                            // 今天的日期文字显示红色
    private Date downDate;                            // 手指按下状态时临时日期
    private Date showFirstDate, showLastDate;        // 日历显示的第一个日期和最后一个日期
    private int downIndex;                            // 按下的格子索引
    private int[] date = new int[49];                // 日历显示数字
    private int curStartIndex, curEndIndex;        // 当前显示的日历起始的索引
    private boolean completed = false;                // 为false表示只选择了开始日期，true表示结束日期也选择了
    private boolean isSelectMore = false;
    private OnItemClickListener onItemClickListener;//给控件设置监听事件
    private Date selectedStartDate;
    private Date selectedEndDate;
    private Calendar calendar;
    private Surface surface;
    public String[] weekText;
    private CalendarDialog.CalendarDayInterface mCalendarDayInterface;

    /**
     * 刷新日期
     *
     * @param days
     */
    public void refreshDays(ArrayList<Integer> days) {
        invalidate();
    }


    /**
     * 构造方法
     *
     * @param context
     */
    public CalendarView(Context context) {
        super(context);
    }

    /**
     * 判断是否横屏
     *
     * @return
     */
    public boolean isScreenChange() {
        Configuration mConfiguration = this.getResources().getConfiguration(); //获取设置的配置信息
        int ori = mConfiguration.orientation; //获取屏幕方向
        if (ori == mConfiguration.ORIENTATION_LANDSCAPE) {//横屏
            return true;
        } else if (ori == mConfiguration.ORIENTATION_PORTRAIT) {//竖屏
            return false;
        }
        return false;
    }

    /**
     * 构造方法
     *
     * @param context
     * @param attrs
     */
    public CalendarView(Context context, AttributeSet attrs) {
        super(context, attrs);
        weekText = context.getResources().getStringArray(R.array.WeekNum);
    }

    public Date getVideoDate(int year, int month, int day) {
        Date date = null;
        try {
            String timestring = String.format("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, 0, 0, 0);
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            date = format.parse(timestring);
            long unixTimestamp = date.getTime() / 1000;
            System.out.println(unixTimestamp);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }

    /**
     * 初始化
     */
    public void init(int yerar, int month, int day) {
        Date dateTime = getVideoDate(yerar, month, day);
        if (dateTime != null)
            curDate = selectedStartDate = selectedEndDate = today = dateTime;
        else
            curDate = selectedStartDate = selectedEndDate = today = new Date();
        calendar = Calendar.getInstance();
        calendar.setTime(curDate);
        surface = new Surface();
        surface.density = getResources().getDisplayMetrics().density;
        setBackgroundColor(surface.bgColor);
        setOnTouchListener(this);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int screenWidth;
        if (!isScreenChange()) {
            screenWidth = getResources().getDisplayMetrics().widthPixels;
        } else {
            screenWidth = getResources().getDisplayMetrics().heightPixels;
        }
        surface.width = screenWidth;
        surface.height = (screenWidth) * 480 / 578;

        widthMeasureSpec = MeasureSpec.makeMeasureSpec(surface.width,
                MeasureSpec.EXACTLY);
        heightMeasureSpec = MeasureSpec.makeMeasureSpec(surface.height,
                MeasureSpec.EXACTLY);
        setMeasuredDimension(widthMeasureSpec, heightMeasureSpec);

        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right,
                            int bottom) {
        if (changed) {
            surface.init();
        }
        super.onLayout(changed, left, top, right, bottom);
    }


    @Override
    protected void onDraw(Canvas canvas) {
        Log.d(TAG, "onDraw");
        // 画框
//		canvas.drawPath(surface.boxPath, surface.borderPaint);
        // 星期
        float weekTextY = surface.monthHeight + surface.weekHeight * 3 / 4f;

        // 星期背景
        canvas.drawRect(0, 0, surface.width, surface.weekHeight, surface.datePaint);
        for (int i = 0; i < weekText.length; i++) {
            float weekTextX = i
                    * surface.cellWidth
                    + (surface.cellWidth - surface.weekPaint
                    .measureText(weekText[i])) / 2f;
            canvas.drawText(weekText[i], weekTextX, weekTextY,
                    surface.weekPaint);
//			canvas.drawRect(surface.weekHeight,surface.width,surface.weekHeight, surface.width,surface.weekPaint);
        }
        /** 计算日期 */
        calculateDate();

        /** 按下状态，选择状态背景色*/
        //drawDownOrSelectedBg(canvas);

        /** today index */
        int todayIndex = -1;
        int curIndex = -1;
        if (downDate == null) {
            downDate = curDate;
        }
        calendar.setTime(downDate);
        int curNumber = calendar.get(Calendar.DAY_OF_MONTH);
        curIndex = curStartIndex + curNumber - 1;
        String seletcYearAndMoth = calendar.get(Calendar.YEAR) + "" + calendar.get(Calendar.MONTH);
        int month = calendar.get(Calendar.MONTH) + 1;
        calendar.setTime(curDate);
        String curYearAndMonth = calendar.get(Calendar.YEAR) + "" + calendar.get(Calendar.MONTH);
        calendar.setTime(today);
        String todayYearAndMonth = calendar.get(Calendar.YEAR) + ""
                + calendar.get(Calendar.MONTH);
        if (curYearAndMonth.equals(todayYearAndMonth)) {
            int todayNumber = calendar.get(Calendar.DAY_OF_MONTH);
            todayIndex = curStartIndex + todayNumber - 1;
        }

        /**绘制日期文字 （1-30号等）*/
        for (int i = 0; i < 42; i++) {
            int color = surface.borderColor;
            if (isLastMonth(i)) {//上个月的日期
                color = surface.borderColor;
//				Log.e("NUmber","isLastMonth ="+String.valueOf(i));
            } else if (isNextMonth(i)) {//下个月的日期
                color = surface.borderColor;
//				Log.e("NUmber","isNextMonth ="+String.valueOf(i));
//			}else if (todayIndex != -1 && i == todayIndex) { //今天
//				color = surface.borderColor;
//				Log.e("NUmber","today ="+String.valueOf(i));
            }
            if (isInDays(i)) {//本月有视频的日期
//					color = surface.textColor;
                color = surface.todayNumberColor;   // 蓝色,有视频
            }
            if (curIndex != -1 && i == curIndex && curYearAndMonth.equals(seletcYearAndMoth)) { //今天
                color = surface.curColor;
//				Log.e("NUmber","today ="+String.valueOf(i));
            }
            drawCellText(canvas, i, date[i] + "", color);
        }
        super.onDraw(canvas);
    }


    /**
     * 计算日期
     */
    private void calculateDate() {
        calendar.setTime(curDate);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        int dayInWeek = calendar.get(Calendar.DAY_OF_WEEK);
        Log.d(TAG, "day in week:" + dayInWeek);
        int monthStart = dayInWeek;
        if (monthStart == 1) {
            monthStart = 8;
        }
        monthStart -= 1;  //以日为开头-1，以星期一为开头-2
        curStartIndex = monthStart;
        date[monthStart] = 1;
        // last month
        if (monthStart > 0) {
            calendar.set(Calendar.DAY_OF_MONTH, 0);
            int dayInmonth = calendar.get(Calendar.DAY_OF_MONTH);
            for (int i = monthStart - 1; i >= 0; i--) {
                date[i] = dayInmonth;
                dayInmonth--;
            }
            calendar.set(Calendar.DAY_OF_MONTH, date[0]);
        }
        showFirstDate = calendar.getTime();
        // this month
        calendar.setTime(curDate);
        calendar.add(Calendar.MONTH, 1);
        calendar.set(Calendar.DAY_OF_MONTH, 0);
        // Log.d(TAG, "m:" + calendar.get(Calendar.MONTH) + " d:" +
        // calendar.get(Calendar.DAY_OF_MONTH));
        int monthDay = calendar.get(Calendar.DAY_OF_MONTH);
        for (int i = 1; i < monthDay; i++) {
            date[monthStart + i] = i + 1;
        }
        curEndIndex = monthStart + monthDay;
        // next month
        for (int i = monthStart + monthDay; i < 42; i++) {
            date[i] = i - (monthStart + monthDay) + 1;
        }
        if (curEndIndex < 49) {
            // 显示了下一月的
            calendar.add(Calendar.DAY_OF_MONTH, 1);
        }
        calendar.set(Calendar.DAY_OF_MONTH, date[48]);
        showLastDate = calendar.getTime();
    }

    /**
     * 绘制  日期 号 （1-31）（和上下月的日期号）
     *
     * @param canvas
     * @param index
     * @param text
     */
    private void drawCellText(Canvas canvas, int index, String text, int color) {
        int x = getXByIndex(index);
        int y = getYByIndex(index);
        surface.datePaint.setColor(color);
        float cellY = surface.monthHeight + surface.weekHeight + (y - 1)
                * surface.cellHeight + surface.cellHeight * 3 / 4f;
        float cellX = (surface.cellWidth * (x - 1))
                + (surface.cellWidth - surface.datePaint.measureText(text))
                / 2f;
        canvas.drawText(text, cellX, cellY, surface.datePaint);
    }

    /**
     * 绘制背景色  （暂时没用）
     *
     * @param canvas
     * @param index
     * @param color
     */
    private void drawCellBg(Canvas canvas, int index, int color) {
        int x = getXByIndex(index);
        int y = getYByIndex(index);
        surface.cellBgPaint.setColor(color);
        float left = surface.cellWidth * (x - 1) + surface.borderWidth;
        float top = surface.monthHeight + surface.weekHeight + (y - 1)
                * surface.cellHeight + surface.borderWidth;
        canvas.drawRect(left, top, left + surface.cellWidth
                - surface.borderWidth, top + surface.cellHeight
                - surface.borderWidth, surface.cellBgPaint);
    }

    /**
     * （暂时没用）
     *
     * @param canvas
     */
    private void drawDownOrSelectedBg(Canvas canvas) {
        // down and not up
        if (downDate != null) {
            drawCellBg(canvas, downIndex, surface.cellDownColor);
        }
        // selected bg color
        if (!selectedEndDate.before(showFirstDate)
                && !selectedStartDate.after(showLastDate)) {
            int[] section = new int[]{-1, -1};
            calendar.setTime(curDate);
            calendar.add(Calendar.MONTH, -1);
            findSelectedIndex(0, curStartIndex, calendar, section);
            if (section[1] == -1) {
                calendar.setTime(curDate);
                findSelectedIndex(curStartIndex, curEndIndex, calendar, section);
            }
            if (section[1] == -1) {
                calendar.setTime(curDate);
                calendar.add(Calendar.MONTH, 1);
                findSelectedIndex(curEndIndex, 49, calendar, section);
            }
            if (section[0] == -1) {
                section[0] = 0;
            }
            if (section[1] == -1) {
                section[1] = 51;
            }
            for (int i = section[0]; i <= section[1]; i++) {
                drawCellBg(canvas, i, surface.cellSelectedColor);
            }
        }
    }

    /**
     * （暂时没用）
     *
     * @param startIndex
     * @param endIndex
     * @param calendar
     * @param section
     */
    private void findSelectedIndex(int startIndex, int endIndex,
                                   Calendar calendar, int[] section) {
        for (int i = startIndex; i < endIndex; i++) {
            calendar.set(Calendar.DAY_OF_MONTH, date[i]);
            Date temp = calendar.getTime();
            // Log.d(TAG, "temp:" + temp.toLocaleString());
            if (temp.compareTo(selectedStartDate) == 0) {
                section[0] = i;
            }
            if (temp.compareTo(selectedEndDate) == 0) {
                section[1] = i;
                return;
            }
        }
    }

    /**
     * 是否是有视频的日期
     *
     * @param downIndex
     * @return
     */
    private boolean isInDays(int downIndex) {
        int year = getYear();
        int month = getMonth();
        ArrayList<Integer> days = mCalendarDayInterface.getDaysOfMonth(year,month);
        if (days == null) {
            return false;
        }
        for (int j = 0; j < days.size(); j++) {
            if (downIndex + 1 - curStartIndex == days.get(j)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 是否是有视频的日期
     */
    private boolean isInDays2(float x, float y) {
        int year = getYear();
        int month = getMonth();
        ArrayList<Integer> days = mCalendarDayInterface.getDaysOfMonth(year,month);
        if (days == null) {
            return false;
        }
        if (y > surface.monthHeight + surface.weekHeight) {
            int m = (int) (Math.floor(x / surface.cellWidth) + 1);
            int n = (int) (Math
                    .floor((y - (surface.monthHeight + surface.weekHeight))
                            / Float.valueOf(surface.cellHeight)) + 1);
            downIndex = (n - 1) * 7 + m - 1;
            for (int j = 0; j < days.size(); j++) {
                if (downIndex + 1 - curStartIndex == days.get(j)) {
                    return true;
                }
            }
        }
        return false;
    }


    /**
     * 判断是否是上个月的日期
     *
     * @param i
     * @return
     */
    private boolean isLastMonth(int i) {
        if (i < curStartIndex) {
            return true;
        }
        return false;
    }

    /**
     * 判断是否是下个月日期
     *
     * @param i
     * @return
     */
    private boolean isNextMonth(int i) {
        if (i >= curEndIndex) {
            return true;
        }
        return false;
    }

    /**
     * 换算 取出x
     */
    private int getXByIndex(int i) {
        return i % 7 + 1; // 1 2 3 4 5 6 7
    }

    /**
     * 换算 取出y
     */
    private int getYByIndex(int i) {
        return i / 7 + 1; // 1 2 3 4 5 6
    }

    // 获得当前应该显示的年月
    public String getCurYearAndmonth() {
        calendar.setTime(curDate);
        String format = "%d/%02d";
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        return String.format(format, year, month);
    }

    // 获得当前应该显示的年月
    public String getYearAndmonth() {
        calendar.setTime(curDate);
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        return year + "-" + month;
    }

    // 获得当前应该显示的年月
    public int getYear() {
        calendar.setTime(curDate);
        int year = calendar.get(Calendar.YEAR);
        return year;

    } // 获得当前应该显示的年月

    public int getMonth() {
        calendar.setTime(curDate);
        int month = calendar.get(Calendar.MONTH) + 1;
        return month;
    }

    //上一月
    public String clickLeftMonth() {
        calendar.setTime(curDate);
        calendar.add(Calendar.MONTH, -1);
        curDate = calendar.getTime();
        invalidate();
        return getYearAndmonth();
    }

    //下一月
    public String clickRightMonth() {
        calendar.setTime(curDate);
        calendar.add(Calendar.MONTH, 1);
        curDate = calendar.getTime();
        invalidate();
        return getYearAndmonth();
    }

    //设置日历时间
    public void setCalendarData(Date date) {
        calendar.setTime(date);
        invalidate();
    }

    //获取日历时间
    public void getCalendatData() {
        calendar.getTime();
    }

    //设置是否多选
    public boolean isSelectMore() {
        return isSelectMore;
    }

    public void setSelectMore(boolean isSelectMore) {
        this.isSelectMore = isSelectMore;
    }

    private void setSelectedDateByCoor(float x, float y) {
        // cell click down
        if (y > surface.monthHeight + surface.weekHeight) {
            int m = (int) (Math.floor(x / surface.cellWidth) + 1);
            int n = (int) (Math
                    .floor((y - (surface.monthHeight + surface.weekHeight))
                            / Float.valueOf(surface.cellHeight)) + 1);
            downIndex = (n - 1) * 7 + m - 1;
            calendar.setTime(curDate);
            if (isLastMonth(downIndex)) {
                calendar.add(Calendar.MONTH, -1);
            } else if (isNextMonth(downIndex)) {
                calendar.add(Calendar.MONTH, 1);
            }
            calendar.set(Calendar.DAY_OF_MONTH, date[downIndex]);
            downDate = calendar.getTime();
        }
        invalidate();
    }


    /**
     * 点击事件处理
     *
     * @param v
     * @param event
     * @return
     */
    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                if (!isInDays2(event.getX(), event.getY())) {
                    break;
                }
                setSelectedDateByCoor(event.getX(), event.getY());
                break;
            case MotionEvent.ACTION_UP:
                if (isInDays2(event.getX(), event.getY())) {
                    if (downDate != null) {
                        if (isSelectMore) {
                            if (!completed) {
                                if (downDate.before(selectedStartDate)) {
                                    selectedEndDate = selectedStartDate;
                                    selectedStartDate = downDate;
                                } else {
                                    selectedEndDate = downDate;
                                }
                                completed = true;
                                //响应监听事件
//							onItemClickListener.OnItemClick(selectedStartDate,selectedEndDate,downDate);
                                onItemClickListener.OnItemClick(downDate);
                            } else {
                                selectedStartDate = selectedEndDate = downDate;
                                completed = false;
                            }
                        } else {
                            selectedStartDate = selectedEndDate = downDate;
                            //响应监听事件
//						onItemClickListener.OnItemClick(selectedStartDate,selectedEndDate,downDate);
                            onItemClickListener.OnItemClick(downDate);
                        }
                        invalidate();
                    }
                }
                break;
        }
        return true;
    }

    //给控件设置监听事件
    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    public void setDownDate(int year, int month, int day) {
        if (year != 0 || month != 0 || day != 0) {
            Calendar downDateCalendar = Calendar.getInstance();
            downDateCalendar.set(year, month - 1, day);
            downDate = downDateCalendar.getTime();
        }

    }

    public void setCalendarDayInterface(CalendarDialog.CalendarDayInterface calendarDayInterface) {
        this.mCalendarDayInterface = calendarDayInterface;
    }

    //监听接口
    public interface OnItemClickListener {
        //		void OnItemClick(Date selectedStartDate, Date selectedEndDate, Date downDate);
        void OnItemClick(Date downDate);
    }

    /**
     * 1. 布局尺寸 2. 文字颜色，大小 3. 当前日期的颜色，选择的日期颜色
     */
    private class Surface {
        public float density;
        public int width;                                                // 整个控件的宽度
        public int height;                                                // 整个控件的高度
        public float monthHeight;                                        // 显示月的高度
        //public float monthChangeWidth; 								// 上一月、下一月按钮宽度
        public float weekHeight;                                        // 显示星期的高度
        public float cellWidth;                                        // 日期方框宽度
        public float cellHeight;                                        // 日期方框高度
        public float borderWidth;
        public int bgColor = Color.parseColor("#FFFFFF");                //背景白色
        private int textColor = Color.parseColor("#010101");            //字体黑色
        private int weekColor = Color.parseColor("#757575");
        //		private int weekbg=Color.parseColor("#b3b3b3");
        private int weekbg = Color.parseColor("#dddddd");
        //private int textColorUnimportant = Color.parseColor("#666666");
        private int btnColor = Color.parseColor("#FFFFFF");
        private int borderColor = Color.parseColor("#CCCCCC");            //日期上 不属于本月的date
        private int curColor = Color.parseColor("#FF0000");           //日期上 不属于本月的date
        public int todayNumberColor =  Color.parseColor("#21bba3");       //今天字体颜色
        public int cellDownColor = Color.parseColor("#CCFFFF");            //按下按钮时
        public int cellSelectedColor = Color.parseColor("#99CCFF");        //按下按钮离开时
        public Paint borderPaint;                                        //边框画笔
        public Paint monthPaint;                                        //月份画笔
        public Paint weekPaint;                                            //星期画笔
        public Paint datePaint;                                            //日期画笔
        public Paint monthChangeBtnPaint;                                //
        public Paint cellBgPaint;                                        //
        public Path boxPath;                                            // 边框路径


        public void init() {
            float temp = height / 7;
            monthHeight = 0;//(float) ((temp + temp * 0.3f) * 0.6);
            //monthChangeWidth = monthHeight * 1.5f;
            weekHeight = (float) ((temp + temp * 0.3f) * 0.60);
            cellHeight = (height - monthHeight - weekHeight) / 8f;
            cellWidth = width / 8f;
            borderPaint = new Paint();
            borderPaint.setColor(borderColor);
            borderPaint.setStyle(Paint.Style.STROKE);
            borderWidth = (float) (0.5 * density);
            // Log.d(TAG, "borderwidth:" + borderWidth);
            borderWidth = borderWidth < 1 ? 1 : borderWidth;
            borderPaint.setStrokeWidth(borderWidth);
            monthPaint = new Paint();
            monthPaint.setColor(textColor);
            monthPaint.setAntiAlias(true);
            float textSize = cellHeight * 0.29f;
            Log.d(TAG, "text size:" + textSize);
            monthPaint.setTextSize(textSize);
            monthPaint.setTypeface(Typeface.DEFAULT_BOLD);
            weekPaint = new Paint();
            weekPaint.setColor(textColor);
            weekPaint.setAntiAlias(true);
//			float weekTextSize = weekHeight * 0.6f;
            float weekTextSize = weekHeight * 0.37f;
            weekPaint.setTextSize(weekTextSize);
//			weekPaint.setTypeface(Typeface.DEFAULT_BOLD);
            datePaint = new Paint();
            datePaint.setColor(weekbg);
            datePaint.setAntiAlias(true);
            float cellTextSize = cellHeight * 0.4f;
            datePaint.setTextSize(cellTextSize);
//			datePaint.setTypeface(Typeface.DEFAULT_BOLD);
            boxPath = new Path();
            //boxPath.addRect(0, 0, width, height, Direction.CW);
            //boxPath.moveTo(0, monthHeight);
            boxPath.rLineTo(width, 0);
            boxPath.moveTo(0, monthHeight + weekHeight);
            boxPath.rLineTo(width, 0);
            for (int i = 1; i < 6; i++) {
                boxPath.moveTo(0, monthHeight + weekHeight + i * cellHeight);
                boxPath.rLineTo(width, 0);
                boxPath.moveTo(i * cellWidth, monthHeight);
                boxPath.rLineTo(0, height - monthHeight);
            }
            boxPath.moveTo(6 * cellWidth, monthHeight);
            boxPath.rLineTo(0, height - monthHeight);

            monthChangeBtnPaint = new Paint();
            monthChangeBtnPaint.setAntiAlias(true);
            monthChangeBtnPaint.setStyle(Paint.Style.FILL_AND_STROKE);
            monthChangeBtnPaint.setColor(btnColor);
            cellBgPaint = new Paint();
            cellBgPaint.setAntiAlias(true);
            cellBgPaint.setStyle(Paint.Style.FILL);
            cellBgPaint.setColor(cellSelectedColor);
        }
    }
}
