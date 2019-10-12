package com.meari.test.utils;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Dialog;
import android.app.Service;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Vibrator;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

import com.meari.sdk.utils.JsonUtil;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.R;
import com.meari.test.common.Preference;
import com.meari.test.widget.CustomDialog;
import com.ppstrong.ppsplayer.BaseDeviceInfo;
import com.ppstrong.ppsplayer.CameraPlayer;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/13
 * ================================================
 */

public class CommonUtils {

    /**
     * 显示吐司
     *
     * @param msg
     */
    public static void showToast(String msg) {
        ToastUtils.getInstance().showToast(msg,  Toast.LENGTH_LONG );
    }
    public static void showToast(int msg) {
        ToastUtils.getInstance().showToast(msg,  Toast.LENGTH_LONG );
    }

    public static String getMataData(String meta_tag, Context instance) {
        ApplicationInfo appInfo = null;
        String msg = null;
        try {
            appInfo = instance.getPackageManager()
                    .getApplicationInfo(instance.getPackageName(),
                            PackageManager.GET_META_DATA);
            msg = String.valueOf(appInfo.metaData.getString(meta_tag));
            return msg;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return msg;
    }
    /**
     * 清除登陆数据
     */
    public static void clearAutoLoginData() {

    }
    /**
     * 隐藏软键盘
     */
    public static void showKeyBoard(Context activity, EditText view) {
        InputMethodManager imm = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.showSoftInput(view, InputMethodManager.SHOW_FORCED);
    }
    /**
     * 隐藏软键盘
     */
    public static void hideKeyBoard(Activity activity) {
        InputMethodManager inputMsg = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (inputMsg.isActive()) { // 隐藏软键盘
            View curView = activity.getCurrentFocus();
            if (curView != null) {
                inputMsg.hideSoftInputFromWindow(curView.getWindowToken(), 0);
            }
        }
    }



    /**
     * @param context
     * @param packageName
     * @return 判断是否打开
     */
    public static boolean isAppAlive(Context context, String packageName) {
        ActivityManager activityManager =
                (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> processInfos
                = activityManager.getRunningAppProcesses();
        for (int i = 0; i < processInfos.size(); i++) {
            if (processInfos.get(i).processName.equals(packageName)) {
                return true;
            }
        }
        return false;
    }
    /**
     * @param context
     * @param message
     * @param positiveListener
     * @param bCancel          //是否可以点返回取消
     * @return
     */
    public static Dialog showDialog(Context context, String message, DialogInterface.OnClickListener positiveListener,
                                    boolean bCancel) {
        return showDlg(context, context.getString(R.string.app_meari_name), message, context.getString(R.string.ok),
                positiveListener, null, null, bCancel);
    }

    /**
     * @param context
     * @param message
     * @param positiveListener
     * @param bCancel          //是否可以点返回取消
     * @return
     */
    public static CustomDialog getDlg(Context context, String message, DialogInterface.OnClickListener positiveListener, boolean bCancel) {
        return getdlg(context, context.getString(R.string.app_meari_name), message, context.getString(R.string.ok),
                positiveListener, null, null, bCancel);
    }

    /**
     * @param context
     * @param title
     * @param message
     * @param positiveBtnName
     * @param positiveListener
     * @param NegativeBtnName
     * @param negativeListener
     * @param bCance
     * @return
     */
    public static CustomDialog getdlg(Context context, String title, String message, String positiveBtnName,
                                      DialogInterface.OnClickListener positiveListener, String NegativeBtnName,
                                      DialogInterface.OnClickListener negativeListener, boolean bCance) {
        try {
            CustomDialog.Builder localBuilder = new CustomDialog.Builder(context);
            localBuilder.setTitle(title).setMessage(message);
            if (positiveBtnName != null)
                localBuilder.setPositiveButton(positiveBtnName, positiveListener);
            if (NegativeBtnName != null)
                localBuilder.setNegativeButton(NegativeBtnName, negativeListener);
            CustomDialog dlg = localBuilder.create();
            dlg.setCancelable(bCance);
            dlg.setCanceledOnTouchOutside(bCance);
            return dlg;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * @param context
     * @param title
     * @param message
     * @param positiveBtnName
     * @param positiveListener
     * @param NegativeBtnName
     * @param negativeListener
     * @param bCance
     * @return
     */
    public static CustomDialog showDlg(Context context, String title, String message, String positiveBtnName,
                                       DialogInterface.OnClickListener positiveListener, String NegativeBtnName,
                                       DialogInterface.OnClickListener negativeListener, boolean bCance) {
        try {
            CustomDialog.Builder localBuilder = new CustomDialog.Builder(context);
            localBuilder.setTitle(title).setMessage(message);
            if (positiveBtnName != null)
                localBuilder.setPositiveButton(positiveBtnName, positiveListener);
            if (NegativeBtnName != null)
                localBuilder.setNegativeButton(NegativeBtnName, negativeListener);
            CustomDialog dlg = localBuilder.create();
            dlg.setCancelable(bCance);
            dlg.setCanceledOnTouchOutside(bCance);
            dlg.show();
            return dlg;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * @param context
     * @param title
     * @param message
     * @param positiveBtnName
     * @param positiveListener
     * @param NegativeBtnName
     * @param negativeListener
     * @param bCance
     * @param graty
     * @return
     */
    public static CustomDialog showDlg(Context context, String title, String message, String positiveBtnName,
                                       DialogInterface.OnClickListener positiveListener, String NegativeBtnName,
                                       DialogInterface.OnClickListener negativeListener, boolean bCance, int graty) {
        try {
            CustomDialog.Builder localBuilder = new CustomDialog.Builder(context);
            localBuilder.setTitle(title).setMessage(message);
            if (positiveBtnName != null)
                localBuilder.setPositiveButton(positiveBtnName, positiveListener);
            if (NegativeBtnName != null)
                localBuilder.setNegativeButton(NegativeBtnName, negativeListener);
            localBuilder.setContentViewGravity(Gravity.LEFT);
            CustomDialog dlg = localBuilder.create();
            dlg.setCancelable(bCance);
            dlg.setCanceledOnTouchOutside(bCance);
            dlg.show();
            return dlg;
        } catch (Exception e) {
            return null;
        }
    }
    public static String getStringDataByResourceId(Context context, int id) {
        InputStream stream = context.getResources().openRawResource(id);
        return read(stream);
    }
    public static String read(InputStream stream) {
        return read(stream, "utf-8");
    }
    public static String read(InputStream is, String encode) {
        if (is != null) {
            try {
                BufferedReader reader = new BufferedReader(new InputStreamReader(is, encode));
                StringBuilder sb = new StringBuilder();
                String line = null;
                while ((line = reader.readLine()) != null) {
                    sb.append(line + "\n");
                }
                is.close();
                return sb.toString();
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return "";
    }
    @Nullable
    public static HashMap<String, String> getPhoneCode(BaseJSONArray jsonArray) {
        HashMap<String, String> maps = new HashMap<>();
        try {
            if (jsonArray == null)
                return maps;
            for (int index = 0; index < jsonArray.length(); index++) {
                BaseJSONObject jsonObject = jsonArray.getJSONObject(index);
                Iterator<String> it = jsonObject.keys();
                while (it.hasNext()) {
                    String myKey = it.next().toString();
                    String jsonValue = jsonObject.optString(myKey);
                    maps.put(myKey,   jsonValue);
                }
            }
            return maps;
        } catch (Exception e) {
        }
        return null;
    }
    /**
     * @return 获取通用CameraPlayer
     */
    public static CameraPlayer getSdkUtil() {
        return Preference.getPreference().getSdkNativeUtil();
    }


    public static void setSdkUtil(CameraPlayer sdkUtil) {
        Preference.getPreference().setSdkNativeUtil(sdkUtil);
    }
    /**
     * @param context
     * @return yu yuan
     */
    public static String getLangType(Context context) {
        Locale locale = context.getResources().getConfiguration().locale;
        String lngType = locale.getLanguage();
        if (lngType.startsWith("zh"))
            lngType = "zh";
        else
            lngType = "en";
        return lngType;
    }

    private static ArrayList<Integer> getRepeat(BaseJSONArray repeatJsonArray) {
        ArrayList<Integer> rePeat = new ArrayList<>();
        for (int i = 0; i < repeatJsonArray.length(); i++) {
            rePeat.add(Integer.valueOf(repeatJsonArray.get(i).toString()));
        }
        Collections.sort(rePeat, new JsonUtil.IntegerComparator());
        return rePeat;
    }
    public static CameraPlayer getSdkNVRNativeUtil() {
        return Preference.getPreference().getSdkNVRNativeUtil();
    }

    /**
     * 震动
     *
     * @param activity
     * @param milliseconds
     */
    public static void vibrateStart(Activity activity, long milliseconds) {
        Vibrator vib = (Vibrator) activity.getSystemService(Service.VIBRATOR_SERVICE);
        vib.vibrate(milliseconds);
    }

    /**
     * 以pattern方式震动
     *
     * @param activity
     * @param pattern
     * @param repeat
     */
    public static void vibrateStart(Activity activity, long[] pattern, int repeat) {
        Vibrator vib = (Vibrator) activity.getSystemService(Service.VIBRATOR_SERVICE);
        vib.vibrate(pattern, repeat);
    }

    /**
     * 取消震动
     *
     * @param activity
     */
    public static void virateCancel(Activity activity) {
        Vibrator vib = (Vibrator) activity.getSystemService(Service.VIBRATOR_SERVICE);
        vib.cancel();
    }
    /**
     * 判断某个服务是否正在运行的方法
     *
     * @param mContext    上下文环境
     * @param serviceName 是包名+服务的类名（例如：net.loonggg.testbackstage.TestService）
     * @return true代表正在运行，false代表服务没有正在运行
     */
    public static boolean isServiceWork(Context mContext, String serviceName) {
        boolean isWork = false;
        ActivityManager myAM = (ActivityManager) mContext
                .getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningServiceInfo> myList = myAM.getRunningServices(40);
        if (myList.size() <= 0) {
            return false;
        }
        for (int i = 0; i < myList.size(); i++) {
            String mName = myList.get(i).service.getClassName();
            if (mName.equals(serviceName)) {
                isWork = true;
                break;
            }
        }
        return isWork;
    }
    /**
     * @param cameraInfo
     * @return
     */
    public static String getCameraString(BaseDeviceInfo cameraInfo) {
         JSONObject jsonObject = new JSONObject();
        if (cameraInfo.getFactory() == 9) {
            try {
                jsonObject.put("trytimes", 3);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            try {
                jsonObject.put("udpport", 12305);
            } catch (JSONException e) {
                e.printStackTrace();
            }

            try {

                jsonObject.put("did", cameraInfo.getDeviceUUID());

            } catch (JSONException e) {
                e.printStackTrace();
            }
            try {
                jsonObject.put("initstring", TextUtils.isEmpty(cameraInfo.getInitstring()) ? "EBGAEIBIKHJJGFJKEOGCFAEPHPMAHONDGJFPBKCPAJJMLFKBDBAGCJPBGOLKIKLKAJMJKFDOOFMOBECEJIMM" : cameraInfo.getInitstring());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            try {
                jsonObject.put("factory", cameraInfo.getFactory());
            } catch (JSONException e) {
                e.printStackTrace();
            }

            try {
                jsonObject.put("delaysec", 5);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else {
            try {
                jsonObject.put("uuid", cameraInfo.getDeviceUUID());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        try {
            jsonObject.put("username", "admin");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        try {
            jsonObject.put("password", cameraInfo.getHostKey());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        try {
            jsonObject.put("factory", cameraInfo.getFactory());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        try {
            jsonObject.put("mode", 5);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return jsonObject.toString();
    }
}
