package com.meari.test.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

import com.meari.test.utils.DisplayUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/14
 * ================================================
 */

public class SelectRegionView extends View {

    private List<String> WORDS;

    private int cellWidth;
    private int cellHeight;
    private Paint paint;

    public SelectRegionView(Context context) {
        this(context, null);
    }

    public SelectRegionView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public SelectRegionView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        paint = new Paint();
        paint.setColor(Color.BLACK);
        paint.setAntiAlias(true);
        paint.setTextSize(DisplayUtil.dip2px(getContext(), 11));
        paint.setFakeBoldText(true);
        WORDS = new ArrayList<>();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        for (int i = 0; i < WORDS.size(); i++) {
            String word = WORDS.get(i);
            Rect bound = new Rect();
            paint.getTextBounds(word, 0, word.length(), bound);
            int x = (cellWidth - bound.width()) / 2;
            int y = i * cellHeight + (cellWidth + bound.width()) / 2;
            canvas.drawText(word, x, y, paint);
        }
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        cellWidth = getMeasuredWidth();
        cellHeight = getMeasuredHeight() / WORDS.size();
    }

    private int curIndex = -1;

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                int y = (int) event.getY();
                int index = y / cellHeight;
                if (index >= 0 && index < WORDS.size()) {
                    if (index != curIndex) {
                        curIndex = index;
                        if (indexChangeListener != null) {
                            indexChangeListener.onIndexChange(WORDS.get(curIndex));
                        }
                    }
                }
                break;
            case MotionEvent.ACTION_MOVE:
                int y1 = (int) event.getY();
                int index1 = y1 / cellHeight;
                if (index1 >= 0 && index1 < WORDS.size()) {
                    if (index1 != curIndex) {
                        curIndex = index1;
                        if (indexChangeListener != null) {
                            indexChangeListener.onIndexChange(WORDS.get(curIndex));
                        }
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
                curIndex = -1;
                break;
        }
        return true;
    }

    private OnIndexChangeListener indexChangeListener;

    public void setOnIndexChangeListener(OnIndexChangeListener indexChangeListener) {
        this.indexChangeListener = indexChangeListener;
    }

    public interface OnIndexChangeListener {
        void onIndexChange(String words);
    }
    public void setWORDS(List<String>words)
    {
        this.WORDS.clear();
        this.WORDS.addAll(words);
    }
}
