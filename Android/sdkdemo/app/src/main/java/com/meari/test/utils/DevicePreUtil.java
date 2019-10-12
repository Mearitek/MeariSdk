package com.meari.test.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

import java.io.IOException;
import java.io.StreamCorruptedException;
import java.util.ArrayList;
import java.util.List;

public class DevicePreUtil
{

    // 用户名key
    public final static String KEY_NAME = "KEY_NAME";

    public final static String KEY_LEVEL = "KEY_LEVEL";


    private static DevicePreUtil s_SharedPreUtil;

    private static List<Long> deviceIDList = null;

    private SharedPreferences msp;

    // 初始化，一般在应用启动之后就要初始化
    public static synchronized void initSharedPreference(Context context)
    {
        if (s_SharedPreUtil == null)
        {
            s_SharedPreUtil = new DevicePreUtil(context);
        }
    }

    /**
     * 获取唯一的instance
     *
     * @return
     */
    public static synchronized DevicePreUtil getInstance()
    {
        return s_SharedPreUtil;
    }

    public DevicePreUtil(Context context)
    {
        msp = context.getSharedPreferences("SharedPreUtil",
                Context.MODE_PRIVATE | Context.MODE_APPEND);
    }

    public SharedPreferences getSharedPref()
    {
        return msp;
    }


    public synchronized void putDeviceIDList(List<Long> deviceIDs)
    {

        Editor editor = msp.edit();

        String str="";
        try {
            str = SerializableUtil.list2String(deviceIDs);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        editor.putString(KEY_NAME,str);
        editor.commit();

        deviceIDList = deviceIDs;
    }

    @SuppressWarnings("unchecked")
    public synchronized List<Long> getDeviceIDList()
    {

        if (deviceIDList == null)
        {
            deviceIDList = new ArrayList<Long>();
            //获取序列化的数据
            String str = msp.getString(DevicePreUtil.KEY_NAME, "");
            if (str == "") {
                return deviceIDList;
            }
            try {
                Object obj = SerializableUtil.str2Obj(str);
                if(obj != null){
                    deviceIDList = (List<Long>)obj;
                }
            } catch (StreamCorruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        return deviceIDList;
    }

    public synchronized void DeleteUser()
    {
        Editor editor = msp.edit();
        editor.putString(KEY_NAME,"");

        editor.commit();
        deviceIDList = null;
    }

}
