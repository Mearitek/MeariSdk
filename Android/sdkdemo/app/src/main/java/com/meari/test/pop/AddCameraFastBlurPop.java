package com.meari.test.pop;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.RequiresApi;
import android.support.annotation.StringRes;
import android.support.annotation.UiThread;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.common.Constant;
import com.meari.test.utils.FastBlur;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/26
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class AddCameraFastBlurPop {
    private RelativeLayout pop_root_layout;
    private RelativeLayout pop_layout;
    private View layout_add;
    private View layout_scan;
    private ImageView close;
    private Builder builder;
    private PopupWindow popupWindow;
    private int radius;
    private float touchY;
    private Bitmap localBit;

    public static final String GRAVITY_BOTTOM = "BOTTOM";
    public static final String GRAVITY_CENTER = "CENTER";
    public static final String GRAVITY_RIGHT_TOP = "RIGHT_TOP";

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    public AddCameraFastBlurPop(Builder builder) {
        this.builder = builder;
        builder.AddCameraFastBlurPop = initAddCameraFastBlurPop(builder);
    }

    @UiThread
    public void show(View view) {
        builder.AddCameraFastBlurPop.popupWindow.showAtLocation(view, Gravity.CENTER, 0, Constant.statusHeight);
    }

    @UiThread
    public void dismiss() {
        if (builder != null && builder.AddCameraFastBlurPop != null)
            builder.AddCameraFastBlurPop.popupWindow.dismiss();
    }

    /*
    截取屏幕
    * */
    @Nullable
    private Bitmap getIerceptionScreen() {
        try {
            // View是你需要截图的View
            View view = builder.activity.getWindow().getDecorView();
            view.setDrawingCacheEnabled(true);
            view.buildDrawingCache();
            Bitmap b = view.getDrawingCache();

            // 获取状态栏高度
            Rect frame = new Rect();
            builder.activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
            int statusBarHeight = frame.top;

            // 获取屏幕长和高
            int width = builder.activity.getWindowManager().getDefaultDisplay().getWidth();
            int height = builder.activity.getWindowManager().getDefaultDisplay()
                    .getHeight();
            // 去掉标题栏
            // Bitmap b = Bitmap.createBitmap(b1, 0, 25, 320, 455);
            Bitmap bitmap = null;
            try {
                if (b.getHeight() < statusBarHeight + height) {
                    height = b.getHeight() - statusBarHeight;
                }
                bitmap = Bitmap.createBitmap(b, 0, statusBarHeight, width, height
                        - statusBarHeight);
            } catch (IllegalArgumentException e) {
                bitmap = Bitmap.createBitmap(b, 0, 25, 320, 455);
            }

            view.destroyDrawingCache();
            bitmap = FastBlur.fastBlur(bitmap, radius);
            if (bitmap != null) {
                return bitmap;
            } else {
                return null;
            }
        } catch (OutOfMemoryError e) {
            return null;
        }
    }

    /*
    初始化
    * */
    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN)
    @UiThread
    public AddCameraFastBlurPop initAddCameraFastBlurPop(final Builder builder) {
        if (builder != null) {
            View rootView = builder.activity.getLayoutInflater().inflate(R.layout.pop_layout, null, false);
            popupWindow = new PopupWindow(rootView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT, true);
            popupWindow.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
            pop_layout = (RelativeLayout) rootView.findViewById(R.id.pop_layout);
            pop_root_layout = (RelativeLayout) rootView.findViewById(R.id.pop_root_layout);
            layout_add = rootView.findViewById(R.id.layout_add);
            layout_scan = rootView.findViewById(R.id.layout_scan);
            close = (ImageView) rootView.findViewById(R.id.close);
            if (builder.title != null) {
                TextView title = (TextView) layout_add.findViewById(R.id.wifi_add_text);
                title.setText(builder.title);
            }

            if (builder.content != null) {
                TextView content = (TextView) layout_scan.findViewById(R.id.wifi_scan_text);
                content.setText(builder.content);
            }

            if (builder.radius != 0) {
                radius = builder.radius;
            } else {
                radius = 5;
            }
            rootView.findViewById(R.id.close_layout).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    popupWindow.dismiss();
                }
            });
            rootView.findViewById(R.id.pop_root).setOnClickListener(null);

            if (builder.isShowClose) {
                close.setVisibility(View.VISIBLE);
                close.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        popupWindow.dismiss();
                    }
                });
            } else {
                close.setClickable(false);
                close.setVisibility(View.INVISIBLE);
            }

//            RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
//            if (builder.showAtLocationType.equals(GRAVITY_CENTER)) {
//                lp.addRule(RelativeLayout.CENTER_VERTICAL, RelativeLayout.TRUE);
//            } else if (builder.showAtLocationType.equals(GRAVITY_RIGHT_TOP)) {
//                lp.addRule(RelativeLayout.ALIGN_PARENT_RIGHT , RelativeLayout.TRUE);
//            } else {
//                lp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM, RelativeLayout.TRUE);
//            }
//            pop_layout.setLayoutParams(lp);
            this.layout_add.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    builder.mImplement.onAddCameraClick();
                    popupWindow.dismiss();
                }
            });
            this.layout_scan.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    builder.mImplement.onScanCameraClick();
                    popupWindow.dismiss();
                }
            });
            if (localBit == null) {
                localBit = getIerceptionScreen();
            }
            popupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
                @Override
                public void onDismiss() {
                    builder.mImplement.onDismiss();
                }
            });
            pop_root_layout.setBackground(new BitmapDrawable(localBit));

        } else {
            throw new NullPointerException("---> AddCameraFastBlurPop ---> initAddCameraFastBlurPop --->builder=null");
        }
        return this;
    }

    public static class Builder {

        protected AddCameraFastBlurPop AddCameraFastBlurPop;
        protected int titleTextSize, contentTextSize;
        protected Activity activity;
        protected Context context;
        protected PopupCallback popupCallback;
        protected int radius;
        protected String title, content;
        protected boolean isCancelable;
        //默认不显示XX
        protected boolean isShowClose = false;
        protected boolean isBackgroundClose = true;
        protected String showAtLocationType = GRAVITY_CENTER;
        private AddPopImplement mImplement;

        public Builder(@NonNull Context context) {
            this.activity = (Activity) context;
            this.context = context;
            this.isCancelable = true;
        }

        public Builder onClick(PopupCallback popupCallback) {
            this.popupCallback = popupCallback;
            return this;
        }

        /*
        * 设置标题
        * */
        public Builder setTitle(@StringRes int titleRes) {
            setTitle(this.context.getString(titleRes));
            return this;
        }


        public Builder setTitle(@NonNull String title) {
            this.title = title;
            return this;
        }

        public Builder setRadius(int radius) {
            this.radius = radius;
            return this;
        }

        public Builder setTitleTextSize(int size) {
            this.titleTextSize = size;
            return this;
        }

        public Builder setContentTextSize(int size) {
            this.contentTextSize = size;
            return this;
        }

        /*
        * 设置主文内容
        * */
        public Builder setContent(@StringRes int contentRes) {
            setContent(this.context.getString(contentRes));
            return this;
        }

        /*
        * 设置主文内容
        * */
        public Builder setContent(@NonNull String content) {
            this.content = content;
            return this;
        }

        /*
        * 默认居中,手动设置了才在最下面
        * */
        public Builder setshowAtLocationType(int type) {
            if (type == 0) {
                this.showAtLocationType = GRAVITY_CENTER;
            } else if (type == 1) {
                this.showAtLocationType = GRAVITY_BOTTOM;
            } else if (type == 2) {
                this.showAtLocationType = GRAVITY_RIGHT_TOP;
            }

            return this;
        }

        public Builder setShowCloseButton(@NonNull boolean flag) {
            this.isShowClose = flag;
            return this;
        }

        public Builder setOutSideClickable(@NonNull boolean flag) {
            this.isBackgroundClose = flag;
            return this;
        }

        @UiThread
        public AddCameraFastBlurPop build() {
            return new AddCameraFastBlurPop(this);
        }

        @UiThread
        public AddCameraFastBlurPop show(View view) {
            AddCameraFastBlurPop AddCameraFastBlurPop = build();
            AddCameraFastBlurPop.show(view);

            return AddCameraFastBlurPop;
        }

        public AddCameraFastBlurPop setImplement(AddPopImplement mImplement) {
            AddCameraFastBlurPop AddCameraFastBlurPop = build();
            this.mImplement = mImplement;
            return AddCameraFastBlurPop;

        }
    }

    public interface PopupCallback {

        void onClick(@NonNull AddCameraFastBlurPop AddCameraFastBlurPop);
    }

    public interface AddPopImplement {
        void onAddCameraClick();

        void onScanCameraClick();

        void onFourVideolClick();

        void onDismiss();

    }
}
