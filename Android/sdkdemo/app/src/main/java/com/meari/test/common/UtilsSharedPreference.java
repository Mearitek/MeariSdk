package com.meari.test.common;

import android.content.Context;
import android.content.SharedPreferences;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.ConcurrentModificationException;
import java.util.Map;

/**
 * 数据持久化类
 * Created by yejunjie on 2016/1/14.
 */
public class UtilsSharedPreference {
    private Context context;
    private String saveCameraInfo = "cameralist";
    private String key;
    private final String WIFI_SHAREPREFEREBCE = "wifiInfo";

    public UtilsSharedPreference(Context context) {
        this.context = context;
    }

    public void savaWifiInfo(String key, String values)
    {
        SharedPreferences sp = context.getSharedPreferences(WIFI_SHAREPREFEREBCE, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(key, values);
        editor.commit();
    }
    public String getWifipwd(String key) {
        SharedPreferences sp = context.getSharedPreferences(WIFI_SHAREPREFEREBCE, Context.MODE_PRIVATE);
        return sp.getString(key, "");
    }
    public void putString(String key, String values) {
        String useAccout = MeariUser.getInstance().getUserInfo().getUserAccount();
        if (useAccout == null || useAccout.length() == 0) {
            return;
        }
        SharedPreferences sp = context.getSharedPreferences(useAccout, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(key, values);
        editor.commit();
    }


    public String getString(String key) {
        String userAccount = MeariUser.getInstance().getUserInfo().getUserAccount();
        if (userAccount == null || userAccount.length() == 0) {
            return null;
        }
        SharedPreferences sp = context.getSharedPreferences(userAccount, Context.MODE_PRIVATE);
        return sp.getString(key, "");
    }
    /**
     * 序列化对象
     *
     * @param cameraInfo
     * @return
     */
    public String serialize(CameraInfo cameraInfo) throws IOException {
        key = cameraInfo.getDeviceUUID();
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
        objectOutputStream.writeObject(cameraInfo);
        String serStr = byteArrayOutputStream.toString("ISO-8859-1");
        serStr = java.net.URLEncoder.encode(serStr, "UTF-8");
        objectOutputStream.close();
        byteArrayOutputStream.close();
        return serStr;
    }

    /**
     * 反序列化对象
     *
     * @param str
     * @return
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public CameraInfo deSerialization(String str) throws IOException,
            ClassNotFoundException {
        String redStr = java.net.URLDecoder.decode(str, "UTF-8");
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(
                redStr.getBytes("ISO-8859-1"));
        ObjectInputStream objectInputStream = new ObjectInputStream(
                byteArrayInputStream);
        CameraInfo cameraInfo = (CameraInfo) objectInputStream.readObject();
        objectInputStream.close();
        byteArrayInputStream.close();
        return cameraInfo;
    }

    public void saveObject(String strObject) {
        SharedPreferences sp = context.getSharedPreferences(MeariUser.getInstance().getUserInfo().getUserAccount(), Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(key, strObject);
        editor.commit();
    }

    public String getObject() {
        SharedPreferences sp = context.getSharedPreferences(saveCameraInfo, Context.MODE_PRIVATE);
        return sp.getString("cameraInfo", null);
    }

    /**
     * 遍历保存的camerainfo
     */
    public ArrayList<CameraInfo> getAllCameraInfo(Context context) {
        ArrayList<CameraInfo> cameraInfoList = new ArrayList<>();
        if(MeariUser.getInstance().getUserInfo().getUserAccount()== null || MeariUser.getInstance().getUserInfo().getUserAccount().isEmpty())
        {
            return cameraInfoList;
        }
        SharedPreferences sp = context.getSharedPreferences(MeariUser.getInstance().getUserInfo().getUserAccount(), Context.MODE_PRIVATE);
        Map<String, ?> allContent = sp.getAll();
        //注意遍历map的方法
        for (Map.Entry<String, ?> entry : allContent.entrySet()) {
            try {
                CameraInfo cameraInfo = deSerialization((String) entry.getValue());
                cameraInfoList.add(cameraInfo);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
        return cameraInfoList;
    }

    public CameraInfo getCameraInfo(String deviceUUID) {
        SharedPreferences sp = context.getSharedPreferences(saveCameraInfo, Context.MODE_PRIVATE);
        String str = sp.getString(deviceUUID, null);
        if (str == null) {
            return null;
        }
        CameraInfo cameraInfo;
        try {
            cameraInfo = deSerialization(str);
            return cameraInfo;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }


    /**
     * 保存 cameraInfo到sp中
     *
     * @param cameraInfo
     */
    public void saveCameraInfo(CameraInfo cameraInfo) {
        String str = null;
        try {
            str = serialize(cameraInfo);
        } catch (IOException e) {
            e.printStackTrace();
        }
        saveObject(str);
    }

    public void setSaveCameraInfos(ArrayList<CameraInfo> infos) {
        try {
            SharedPreferences sp = context.getSharedPreferences(MeariUser.getInstance().getUserInfo().getUserAccount(), Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = sp.edit();
            editor.clear();
            editor.commit();
            ArrayList<CameraInfo> list = new ArrayList<>();
            list.addAll(infos);
            if (infos == null || infos.size() == 0) {
                return;
            } else {
                for (CameraInfo info : list) {
                    saveCameraInfo(info);
                }
            }
        } catch (ConcurrentModificationException e) {
            e.printStackTrace();
        }

    }

    public void clearSaveCameraInfos() {
        try {
            SharedPreferences sp = context.getSharedPreferences(MeariUser.getInstance().getUserInfo().getUserAccount(), Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = sp.edit();
            editor.clear();
            editor.commit();
        } catch (ConcurrentModificationException e) {
            e.printStackTrace();
        }
    }

}
