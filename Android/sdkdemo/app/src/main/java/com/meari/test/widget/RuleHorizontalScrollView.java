package com.meari.test.widget;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.util.AttributeSet;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.widget.HorizontalScrollView;

/**
 * Created by LIAO on 2016/8/15.
 */
public class RuleHorizontalScrollView extends HorizontalScrollView {
    public final int IDLE = 0;
    public final int TOUCH_SCROLL = 1;
    public final int FLING = 2;
    public boolean mIsDoubleClick = false;
    public boolean mDown = false;


    public RuleHorizontalScrollView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    public RuleHorizontalScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public RuleHorizontalScrollView(Context context) {
        super(context);
    }

    public void removeScorllCallbacks() {
        scrollTo(currentX, 0);
        mHandler.removeCallbacks(scrollRunnable);
        scrollType = IDLE;
    }


    private Handler mHandler;
    private ScrollViewListener scrollViewListener;

    /**
     * 滚动状态   IDLE 滚动停止  TOUCH_SCROLL 手指拖动滚动         FLING滚动
     *
     * @author DZC
     * @version XHorizontalScrollViewgallery
     * @Time 2014-12-7 上午11:06:52
     */


    /**
     * 记录当前滚动的距离
     */
    private int currentX = -9999999;
    /**
     * 当前滚动状态
     */
    private int scrollType = IDLE;
    /**
     * 滚动监听间隔
     */
    private int scrollDealy = 50;
    /**
     * 滚动监听runnable
     */
    private Runnable scrollRunnable = new Runnable() {

        @Override
        public void run() {
            // TODO Auto-generated method stub
            int x = getScrollX();

            if (getScrollX() == currentX) {
                //滚动停止  取消监听线程
                Log.d("", "停止滚动");
                scrollType = IDLE;
                if (scrollViewListener != null) {
                    scrollViewListener.onScrollChanged(scrollType);
                    if (!mDown) {
                        scrollViewListener.onScrollFinish(scrollType);
                        mHandler.removeCallbacks(this);
                        return;
                    }
                }
                mHandler.postDelayed(this, scrollDealy);
                return;
            } else {
                scrollType = FLING;
                if (scrollViewListener != null) {
                    scrollViewListener.onScrollChanged(scrollType);
                }
            }
            currentX = getScrollX();
            mHandler.postDelayed(this, scrollDealy);

        }
    };

    @TargetApi(Build.VERSION_CODES.M)
    public void init() {
        this.setOnTouchListener(new OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                gestureDetector.onTouchEvent(event);
                switch (event.getAction()) {
                    case MotionEvent.ACTION_MOVE:
                        if (mIsDoubleClick) {
                            mIsDoubleClick = false;
                            break;
                        }
                        if (!mDown)
                            break;
                        if (scrollType == IDLE) {
                            mHandler.removeCallbacks(scrollRunnable);
                            mHandler.post(scrollRunnable);
                        }
                        break;
                }
                return false;
            }
        });
    }

    private GestureDetector gestureDetector = new GestureDetector(getContext(), new GestureDetector.SimpleOnGestureListener() {


        @Override
        public boolean onDoubleTap(MotionEvent e) {    //双击事件
            scrollViewListener.onChangeRule();
            mIsDoubleClick = true;
            return super.onDoubleTap(e);
        }
    });

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        switch (ev.getAction()) {
            case MotionEvent.ACTION_DOWN:
                mDown = true;
                break;

            case MotionEvent.ACTION_UP:

                mDown = false;
                break;
        }
        return super.onTouchEvent(ev);
    }

    /**
     * 必须先调用这个方法设置Handler  不然会出错
     * 2014-12-7 下午3:55:39
     *
     * @param handler
     * @return void
     * @author DZC
     * @TODO
     */
    public void setHandler(Handler handler) {
        this.mHandler = handler;
    }

    /**
     * 设置滚动监听
     * 2014-12-7 下午3:59:51
     *
     * @param listener
     * @return void
     * @author DZC
     * @TODO
     */
    public void setOnScrollStateChangedListener(ScrollViewListener listener) {
        this.scrollViewListener = listener;
    }

    public int getSorollType() {
        return scrollType;
    }

    public interface ScrollViewListener {

        void onScrollChanged(int scrollType);

        void onScrollFinish(int scrollType);

        void onChangeRule();


    }

}