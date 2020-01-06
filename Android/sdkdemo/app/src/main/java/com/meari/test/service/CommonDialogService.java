package com.meari.test.service;

import android.app.Activity;
import android.app.Dialog;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.meari.test.R;
import com.meari.test.application.MeariSmartApp;
import com.meari.test.utils.CommonUtils;

import static com.meari.test.service.CommonData.mNowContext;


public class CommonDialogService extends Service implements CommonDialogListener {

    private static Dialog dialog;
    private static View view;

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        MqttDialogUtils.getInstances().setListener(this);//绑定

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (dialog != null && dialog.isShowing()) {
            dialog.cancel();
            dialog = null;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    private void showDialog() {
        if (mNowContext != null && (mNowContext instanceof Activity)) {
            if (((Activity) mNowContext).isFinishing())
                return;
        }
        if (dialog == null && mNowContext != null) {
            dialog = new Dialog(mNowContext, R.style.PPSDialog);
            view = LayoutInflater.from(this).inflate(R.layout.dialog_common, null, false);
            ((TextView) view.findViewById(R.id.title)).setText(mNowContext.getString(R.string.app_meari_name));
            ((TextView) view.findViewById(R.id.message)).setText(mNowContext.getString(R.string.error_1023));
            (view.findViewById(R.id.positiveButton)).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    cancel();
                }
            });
            view.findViewById(R.id.negativeButton_layout).setVisibility(View.GONE);
            dialog.setContentView(view);
            dialog.setCanceledOnTouchOutside(false);
            dialog.setCancelable(false);
            dialog.show();
        } else {
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void show() {
        showDialog();
    }

    @Override
    public void cancel() {
        if (dialog != null) {
            dialog.dismiss();
            dialog = null;
            CommonUtils.clearAutoLoginData();
            MeariSmartApp.getInstance().tokenChange();
        }
    }
}
