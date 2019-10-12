package com.meari.test.widget;

import android.content.Context;
import android.graphics.Color;
import android.net.Uri;
import android.support.v4.view.ViewCompat;
import android.support.v4.widget.ViewDragHelper;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.interfaces.DraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.test.utils.DisplayUtil;

/**
 * Created by pupu on 2017/7/20.
 * 右滑删除的控件
 *
 * @author pupu
 * @time 2017年7月20日11:40:43
 */

public class DragDelView extends RelativeLayout {
    static final String TAG = "DragDelView";

    //控件状态
    final static int NORMAL = 1;//普通状态
    final static int DELETE = 2;//右滑打开了删除按钮
    int status = NORMAL;

    private ViewDragHelper mViewDragHelper;

    //内容布局
    RelativeLayout rl_main;//内容布局
    TextView tv_date, tv_time;//留言的日期和时间
    boolean rlMainClicked = false;
    SimpleDraweeView sdv_anim;//在播放状态时的gif动画
    int sdvAnimW, sdvAnimH;//gif动画宽高

    //删除按钮
    TextView tv_delete;//删除的文字
    RelativeLayout rl_delete;//删除按钮布局
    int rlDeleteW, rlDeleteH;//删除按钮宽高

    //暴露出去点击事件接口
    MainClickListener mainClickListener;

    public interface MainClickListener {
        void onClick(View view);
    }

    public void setOnMainClickListener(MainClickListener mainClickListener) {
        this.mainClickListener = mainClickListener;
    }

    DeleteClickListener deleteClickListener;

    public interface DeleteClickListener {
        void onClick(View view);
    }

    public void setOnDeleteClickListener(DeleteClickListener deleteClickListener) {
        this.deleteClickListener = deleteClickListener;
    }

    //设置文本
    public void setDateText(String str) {
        if (str == null) {
            return;
        }
        this.tv_date.setText(str);
    }

    public void setTimeText(String str) {
        if (str == null) {
            return;
        }
        this.tv_time.setText(str);
    }

    //设置gif动画可见性
    public void setGifVisiable(boolean flag) {
        if (flag) {
            this.sdv_anim.setVisibility(VISIBLE);
        } else {
            this.sdv_anim.setVisibility(GONE);
        }
    }

    public DragDelView(Context context) {
        this(context, null);
    }

    public DragDelView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initView(context);
    }

    public DragDelView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView(context);
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        super.onLayout(changed, l, t, r, b);

    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        return mViewDragHelper.shouldInterceptTouchEvent(ev);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        //将触摸事件传递给ViewDragHelper,此操作必不可少
        mViewDragHelper.processTouchEvent(event);
        return true;
    }

    private void initView(Context context) {
        mViewDragHelper = ViewDragHelper.create(this, callback);
        //初始化布局
        //删除按钮
        tv_delete = new TextView(context);
        tv_delete.setText(getResources().getString(R.string.delete));
        tv_delete.setTextSize(16);
        tv_delete.setTextColor(Color.WHITE);
        LayoutParams tvDeleteParams = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
        tvDeleteParams.addRule(CENTER_IN_PARENT, TRUE);
        tv_delete.setLayoutParams(tvDeleteParams);
        rlDeleteW = DisplayUtil.dip2px(context, 66);
        rlDeleteH = rlDeleteW;
        rl_delete = new RelativeLayout(context);
        LayoutParams rlDeleteParams = new LayoutParams(rlDeleteW, rlDeleteH);
        rlDeleteParams.addRule(ALIGN_PARENT_RIGHT, TRUE);
        rl_delete.setBackgroundColor(Color.RED);
        rl_delete.setLayoutParams(rlDeleteParams);
        rl_delete.addView(tv_delete);
        addView(rl_delete);

        //内容布局
        tv_date = new TextView(context);
        tv_date.setTextSize(16);
        tv_date.setText("date");
        LayoutParams tvDateParams = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
        tvDateParams.addRule(ALIGN_PARENT_TOP, TRUE);
        tv_date.setTextColor(0xff000000);
        tv_date.setLayoutParams(tvDateParams);

        tv_time = new TextView(context);
        tv_time.setTextSize(16);
        tv_time.setText("time");
        LayoutParams tvTimeParams = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
        tvTimeParams.addRule(ALIGN_PARENT_BOTTOM, TRUE);
        tv_time.setLayoutParams(tvTimeParams);

        sdv_anim = new SimpleDraweeView(context);
        sdvAnimW = DisplayUtil.dpToPx(context, 22);
        sdvAnimH = sdvAnimW;
        LayoutParams sdvAnimParams = new LayoutParams(sdvAnimW, sdvAnimH);
        sdvAnimParams.addRule(CENTER_VERTICAL, TRUE);
        sdvAnimParams.addRule(ALIGN_PARENT_RIGHT, TRUE);
        sdvAnimParams.setMargins(0, 0, sdvAnimW, 0);
        sdv_anim.setLayoutParams(sdvAnimParams);
        //加载gif图
        DraweeController mDraweeController = Fresco.newDraweeControllerBuilder()
                .setAutoPlayAnimations(true)
                .setUri(Uri.parse("res://" + context.getPackageName() + "/" + R.mipmap.gif_playrecord))//设置uri
                .build();
        sdv_anim.setController(mDraweeController);
        sdv_anim.setVisibility(GONE);//默认不可见

        rl_main = new RelativeLayout(context);
        final LayoutParams rlMainParams = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        rl_main.setLayoutParams(rlMainParams);
        int padding = DisplayUtil.dip2px(context, 10);
        int padding16 = DisplayUtil.dip2px(context, 16);
        rl_main.setPadding(padding16, padding, padding, padding);
        rl_main.addView(tv_date);
        rl_main.addView(tv_time);
        rl_main.addView(sdv_anim);
        rl_main.setBackgroundColor(Color.WHITE);
        addView(rl_main);

    }

    private ViewDragHelper.Callback callback =
            new ViewDragHelper.Callback() {

                // 何时开始检测触摸事件
                @Override
                public boolean tryCaptureView(View child, int pointerId) {
                    //只要触摸就开始检测
                    //注意区分点击事件
                    rlMainClicked = true;
                    return true;
                }

                // 触摸到View后回调
                @Override
                public void onViewCaptured(View capturedChild,
                                           int activePointerId) {
                    super.onViewCaptured(capturedChild, activePointerId);
                }

                // 当拖拽状态改变，比如idle，dragging
                @Override
                public void onViewDragStateChanged(int state) {
                    super.onViewDragStateChanged(state);
                }

                // 当位置改变的时候调用,常用与滑动时更改scale等
                @Override
                public void onViewPositionChanged(View changedView,
                                                  int left, int top, int dx, int dy) {
                    super.onViewPositionChanged(changedView, left, top, dx, dy);

                }

                // 处理垂直滑动
                @Override
                public int clampViewPositionVertical(View child, int top, int dy) {
//                    return super.clampViewPositionVertical(child,top,dy);
                    return 0;
                }

                // 处理水平滑动
                @Override
                public int clampViewPositionHorizontal(View child, int left, int dx) {
                    //注意只能滑动rl_main
                    if (child == rl_main) {
                        //如果滑动，则判断为不是点击事件
                        rlMainClicked = false;
                        if (rl_main.getLeft() >= 0 && dx > 0) {
                            return 0;
                        }
                        if (left >= 0) {
                            return 0;
                        }
                        return left;
                    }
                    return rl_delete.getLeft();
                }

                // 拖动结束后调用
                @Override
                public void onViewReleased(View releasedChild, float xvel, float yvel) {
                    super.onViewReleased(releasedChild, xvel, yvel);
                    Log.i(TAG, "getLeft==>" + rl_main.getLeft());
                    Log.i(TAG, "delete getLeft==>" + rl_delete.getLeft());
                    //处理点击事件
                    if (releasedChild == rl_main) {
                        if (rlMainClicked == true) {
                            //做逻辑处理
                            if (status == NORMAL) {
                                //只有在NORMAL状态处理
                                mainClickListener.onClick(releasedChild);
                            } else {
                                //收回去删除
                                //切换状态
                                status = NORMAL;
                                //收回去
                                mViewDragHelper.smoothSlideViewTo(rl_main, 0, 0);
                                ViewCompat.postInvalidateOnAnimation(DragDelView.this);
                            }
                            return;
                        }

                        //手指抬起后缓慢移动到指定位置
                        if (rl_main.getLeft() > -rlDeleteW / 2) {
                            //切换状态
                            status = NORMAL;
                            //收回去
                            mViewDragHelper.smoothSlideViewTo(rl_main, 0, 0);
                            ViewCompat.postInvalidateOnAnimation(DragDelView.this);
                        } else {
                            //切换状态,待删除
                            status = DELETE;
                            //打开删除按钮
                            mViewDragHelper.smoothSlideViewTo(rl_main, -200, 0);
                            ViewCompat.postInvalidateOnAnimation(DragDelView.this);
                        }
                    } else if (releasedChild == rl_delete) {
                        //rl_delete只要手指抬起就是点击事件
                        if (status == DELETE) {
                            deleteClickListener.onClick(releasedChild);
                        } else {
                            return;
                        }
                    }

                }
            };

    @Override
    public void computeScroll() {
        if (mViewDragHelper.continueSettling(true)) {
            ViewCompat.postInvalidateOnAnimation(this);
        }
    }
}