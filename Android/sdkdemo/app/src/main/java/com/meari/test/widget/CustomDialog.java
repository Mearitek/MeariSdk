package com.meari.test.widget;


import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.utils.DisplayUtil;


public class CustomDialog extends Dialog {

    public CustomDialog(Context context, int theme) {
        super(context, theme);
    }

    public void setPositiveResouce() {
    }


    @SuppressLint("InflateParams")
    public static class Builder {
        private Context context;
        private String title;
        private String messageTips;
        private String message;
        private String positiveButtonText;
        private String negativeButtonText;
        private View contentView;
        private int mGravity = Gravity.CENTER;
        private View.OnClickListener messageClick;
        private OnClickListener positiveButtonClickListener, negativeButtonClickListener;
        private int positiveResouce = 0;
        private int negativeResouce = 0;

        public Builder(Context context) {
            this.context = context;
        }

        /**
         * Set the Dialog message from String
         *
         * @param message
         * @return
         */
        public Builder setMessage(String message) {
            this.message = message;
            return this;
        }

        /**
         * Set the Dialog message from resource
         *
         * @param message
         * @return
         */
        public Builder setMessage(int message) {
            this.message = (String) context.getText(message);
            return this;
        }

        /**
         * Set the Dialog title from resource
         *
         * @param title
         * @return
         */
        public Builder setTitle(int title) {
            this.title = (String) context.getText(title);
            return this;
        }

        /**
         * Set the Dialog title from String
         *
         * @param title
         * @return
         */
        public Builder setTitle(String title) {
            this.title = title;
            return this;
        }

        /**
         * Set a custom content view for the Dialog. If a message is set, the
         * contentView is not added to the Dialog...
         *
         * @param v
         * @return
         */
        public Builder setContentView(View v) {
            this.contentView = v;
            return this;
        }

        /**
         * Set the positive TextView resource and it's listener
         *
         * @param positiveButtonText
         * @param listener
         * @return
         */
        public Builder setPositiveButton(int positiveButtonText, OnClickListener listener) {
            this.positiveButtonText = (String) context.getText(positiveButtonText);
            this.positiveButtonClickListener = listener;
            return this;
        }

        /**
         * Set the positive TextView text and it's listener
         *
         * @param positiveButtonText
         * @param listener
         * @return
         */
        public Builder setPositiveButton(String positiveButtonText, OnClickListener listener) {
            this.positiveButtonText = positiveButtonText;
            this.positiveButtonClickListener = listener;
            return this;
        }

        /**
         * Set the negative TextView resource and it's listener
         *
         * @param negativeButtonText
         * @param listener
         * @return
         */
        public Builder setNegativeButton(int negativeButtonText, OnClickListener listener) {
            this.negativeButtonText = (String) context.getText(negativeButtonText);
            this.negativeButtonClickListener = listener;
            return this;
        }

        /**
         * Set the negative TextView text and it's listener
         *
         * @param negativeButtonText
         * @param listener
         * @return
         */
        public Builder setNegativeButton(String negativeButtonText, OnClickListener listener) {
            this.negativeButtonText = negativeButtonText;
            this.negativeButtonClickListener = listener;
            return this;
        }

        public CustomDialog create() {
            LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            final CustomDialog dialog = new CustomDialog(context, R.style.PPSDialog);
            dialog.setCanceledOnTouchOutside(false);
            View layout = inflater.inflate(R.layout.dialog_common, null);
            ((TextView) layout.findViewById(R.id.title)).setText(title);
            if (positiveButtonText != null) {
                ((TextView) layout.findViewById(R.id.positiveButton)).setText(positiveButtonText);
                if (positiveResouce != 0) {
                    ((TextView) layout.findViewById(R.id.positiveButton)).setTextColor(Color.parseColor("#ffffff"));
                    layout.findViewById(R.id.positiveButton).setBackgroundResource(positiveResouce);
                }
                if (positiveButtonClickListener != null) {
                    ((TextView) layout.findViewById(R.id.positiveButton))
                            .setOnClickListener(new View.OnClickListener() {
                                public void onClick(View v) {
                                    positiveButtonClickListener.onClick(dialog, DialogInterface.BUTTON_POSITIVE);
                                }
                            });
                }
                if (negativeButtonClickListener == null) {
                    ((TextView) layout.findViewById(R.id.positiveButton)).setWidth(DisplayUtil.dpToPx(context, 150));

                }

            } else {
                layout.findViewById(R.id.positiveButton_layout).setVisibility(View.GONE);
            }
            // set the cancel TextView
            if (negativeButtonText != null) {
                ((TextView) layout.findViewById(R.id.negativeButton)).setText(negativeButtonText);
                if (negativeResouce != 0) {
                    ((TextView) layout.findViewById(R.id.negativeButton)).setTextColor(Color.parseColor("#ff9966"));
                    layout.findViewById(R.id.negativeButton).setBackgroundResource(negativeResouce);
                }
                if (negativeButtonClickListener != null) {
                    ((TextView) layout.findViewById(R.id.negativeButton))
                            .setOnClickListener(new View.OnClickListener() {
                                public void onClick(View v) {
                                    negativeButtonClickListener.onClick(dialog, DialogInterface.BUTTON_NEGATIVE);
                                }
                            });
                    if (positiveButtonClickListener == null) {
                        ((TextView) layout.findViewById(R.id.negativeButton)).setWidth(DisplayUtil.dpToPx(context, 150));
                    }

                }


            } else {
                layout.findViewById(R.id.negativeButton_layout).setVisibility(View.GONE);
            }
            if (message != null) {
                ((TextView) layout.findViewById(R.id.message)).setText(message);
                ((TextView) layout.findViewById(R.id.message)).setGravity(mGravity);
            } else if (contentView != null) {
                // if no message set
                // add the contentView to the dialog body
                ((LinearLayout) layout.findViewById(R.id.content)).removeAllViews();
                ((LinearLayout) layout.findViewById(R.id.content)).addView(contentView,
                        new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
            }
            if (messageTips == null || messageTips.isEmpty()) {
                layout.findViewById(R.id.message_tip).setVisibility(View.GONE);
            } else {
                layout.findViewById(R.id.message_tip).setVisibility(View.VISIBLE);
                ((TextView) layout.findViewById(R.id.message_tip)).setText(messageTips);
                layout.findViewById(R.id.message_tip).setOnClickListener(messageClick);

            }
            dialog.setContentView(layout);
            return dialog;
        }

        public void setContentViewGravity(int contentViewGravity) {
            this.mGravity = contentViewGravity;
        }

        public void setMessageTips(String messageTips) {
            this.messageTips = messageTips;
        }

        public void setMessageClick(View.OnClickListener click) {
            this.messageClick = click;
        }

        public void setPositiveResouce(int positiveResouce) {
            this.positiveResouce = positiveResouce;
        }

        public void setNegativeResouce(int negativeResouce) {
            this.negativeResouce = negativeResouce;
        }
    }
}
