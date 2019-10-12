package com.meari.test.db;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import com.meari.sdk.bean.DeviceAlarmMessage;

import org.json.JSONException;

import java.util.ArrayList;
import java.util.List;

public class AlertMsgDb {
    private OpenHelper dbOpenHelper;

    public AlertMsgDb(Context context) {
        dbOpenHelper = new OpenHelper(context);
    }

    /*
     * 批量添加数据
     */
    public void addAlertMsg(List<DeviceAlarmMessage> messageInfoList) {
        SQLiteDatabase db = dbOpenHelper.getWritableDatabase();
        if (db.isOpen()) {
            for (int i = 0; i < messageInfoList.size(); i++) {
                try {
                    Log.i("MessageDetailTAG", "本地插入数据 :" + messageInfoList.get(i));
                    DeviceAlarmMessage messageInfo = messageInfoList.get(i);
                    db.execSQL("insert into ALERT_MSG values(?,?,?,?,?,?,?,?,?,?)",
                            new Object[]{messageInfo.getMsgID(), messageInfo.getImgUrl(),
                                    messageInfo.getIsRead(), messageInfo.getCreateDate(),
                                    messageInfo.getDeviceID(), messageInfo.getUserID(),
                                    messageInfo.getUserIDS(), messageInfo.getImageAlertType(),
                                    messageInfo.getTumbnailPic(), messageInfo.getDecibel()});
                } catch (Exception e) {
//                    Log.i("获取THUMBNAIL", cursor.getString(cursor.getColumnIndex("THUMBNAIL")));
//                    CommonUtils.showToast(e.getMessage());
                    Log.e("插入THUMBNAIL失败", e.getMessage());
                }
            }
            db.close();
        }
    }

    /*
     * 批量更新数据
     */
    public void updateAlertMsgIsRead(Long msgID) {
        SQLiteDatabase db = dbOpenHelper.getWritableDatabase();
        if (db.isOpen()) {
            if (msgID > 0) {
                db.execSQL("update ALERT_MSG set IS_READ='Y' WHERE MSG_ID=?", new Object[]{msgID});
            }
            db.close();
        }
    }

    /*
     * 批量更新数据
     */
    public void updateAlertMsgIsReadByDeviceId(Long Deviceid) {
        SQLiteDatabase db = dbOpenHelper.getWritableDatabase();
        if (db.isOpen()) {
            if (Deviceid > 0) {
                db.execSQL("update ALERT_MSG set IS_READ='Y' WHERE DEVICE_ID=?", new Object[]{Deviceid});
            }
            db.close();
        }
    }

    /*
     * 批量删除数据
     */
    public void deleteAlertMsgIsRead(List<Long> msgIDList) {
        Log.i("MessageDetailTAG", "批量删除的数据：" + msgIDList.toString());
        SQLiteDatabase db = dbOpenHelper.getWritableDatabase();
        if (db.isOpen()) {
            for (int i = 0; i < msgIDList.size(); i++) {
                Long msgID = msgIDList.get(i);
                db.execSQL("delete from  ALERT_MSG WHERE MSG_ID=?", new Object[]{msgID});
            }
            db.close();
        }
    }

    /*
     * 删除设备所有本地消息
     */
    public void deleteDeviceAllMsg(List<Long> msgIDList) {
        Log.i("MessageDetailTAG", "批量设备的所有本地删除的数据：" + msgIDList.toString());
        SQLiteDatabase db = dbOpenHelper.getWritableDatabase();
        if (db.isOpen()) {
            for (int i = 0; i < msgIDList.size(); i++) {
                Long msgID = msgIDList.get(i);
                db.execSQL("delete from  ALERT_MSG WHERE MSG_ID=?", new Object[]{msgID});
            }
            db.close();
        }
    }

    /*
     * 批量删除设备所有的本地消息
     */
    public void deleteAlertMsgByDeviceID(ArrayList<Long> deviceIDs, Long userID) throws JSONException {
        SQLiteDatabase db = dbOpenHelper.getWritableDatabase();
        Log.i("MessageDetailTAG", " 批量删除设备所有的本地消息：" + deviceIDs.toString());
        if (db.isOpen()) {
            for (int i = 0; i < deviceIDs.size(); i++) {
                Long deviceID = deviceIDs.get(i);
                db.execSQL("delete from ALERT_MSG where device_id=? and ((user_id=? and user_ids=0) or user_ids=?)",
                        new Object[]{deviceID, userID, userID});
            }
            db.close();
        }
    }

    /*
         * 批量删除设备所有的本地消息
         */
    public void deleteAlertMsgByDevice(long deviceIDs, Long userID) throws JSONException {
        SQLiteDatabase db = dbOpenHelper.getWritableDatabase();
        if (db.isOpen()) {

            db.execSQL("delete from ALERT_MSG where device_id=? and ((user_id=? and user_ids=0) or user_ids=?)",
                    new Object[]{deviceIDs, userID, userID});
            db.close();
        }
    }

    /*
     * 查找数据库的操作
     */
    public List<Long> findAlertMsgNoReadStatus(long userID) {
        List<Long> deviceIDList = null;
        SQLiteDatabase db = dbOpenHelper.getReadableDatabase();
        if (db.isOpen()) {
            Cursor cursor = db.rawQuery(
                    "select DEVICE_ID from ALERT_MSG where is_read='N' and((user_id=? and user_ids=0) or user_ids=?) group by device_id,user_id,user_ids",
                    new String[]{String.valueOf(userID), String.valueOf(userID)});
            deviceIDList = new ArrayList<>();
            while (cursor.moveToNext()) {
                Log.i("MessageTAG", "date num is:" + cursor.getColumnIndex("DEVICE_ID"));
                deviceIDList.add(cursor.getLong(cursor.getColumnIndex("DEVICE_ID")));
            }
            Log.i("MessageTAG", "得到本地所有未读的标记位:" + deviceIDList);
            cursor.close();
            db.close();
        }
        return deviceIDList;
    }

    /*
     * 查找数据库的操作
     */
    public List<Long> findAlertMsgStatus(long userID) {
        List<Long> deviceIDList = null;
        SQLiteDatabase db = dbOpenHelper.getReadableDatabase();
        if (db.isOpen()) {
            Cursor cursor = db.rawQuery(
                    "select DEVICE_ID from ALERT_MSG where (user_id=? and user_ids=0) or user_ids=? group by device_id,user_id,user_ids",
                    new String[]{String.valueOf(userID), String.valueOf(userID)});
            deviceIDList = new ArrayList<Long>();
            while (cursor.moveToNext()) {
                Log.i("MessageTAG", "date num is:" + cursor.getColumnIndex("DEVICE_ID"));
                deviceIDList.add(cursor.getLong(cursor.getColumnIndex("DEVICE_ID")));
            }
            Log.i("MessageTAG", "得到本地所有的标记位:" + deviceIDList);
            cursor.close();
            db.close();
        }
        return deviceIDList;
    }

    /*
     * 查找数据库的操作
     */
    public List<Long> findSelfAlertMsgStatus(long userID) {
        List<Long> messageIDList = null;
        SQLiteDatabase db = dbOpenHelper.getReadableDatabase();
        if (db.isOpen()) {
            Cursor cursor = db.rawQuery(
                    "select DEVICE_ID from ALERT_MSG where is_read='N' and user_id=? and user_ids=0 group by device_id,user_id,user_ids",
                    new String[]{String.valueOf(userID)});
            messageIDList = new ArrayList<Long>();
            while (cursor.moveToNext()) {
                Log.i("MessageTAG", "date num is:" + cursor.getColumnIndex("DEVICE_ID"));
                messageIDList.add(cursor.getLong(cursor.getColumnIndex("DEVICE_ID")));
            }
            Log.i("MessageTAG", "得到本地所有的标记位:" + messageIDList);
            cursor.close();
            db.close();
        }
        return messageIDList;
    }

    /*
     * 查找数据库的操作
     */
    public ArrayList<DeviceAlarmMessage> findAlertMsg(long deviceID, long userID, int pageNum) {
        Log.i("MessageDetailTAG", "findAlertMsg num is:" + deviceID + "userID" + userID + "pageNum" + pageNum);
        ArrayList<DeviceAlarmMessage> messageInfoList = null;
        SQLiteDatabase db = dbOpenHelper.getReadableDatabase();
        if (db.isOpen()) {
            Cursor cursor = db.rawQuery(
                    "select * from ALERT_MSG where (DEVICE_ID=? AND user_id=? and user_ids=0) or (DEVICE_ID=? and user_ids=?) order by CREATE_DATE desc limit 0,?",
                    new String[]{String.valueOf(deviceID), String.valueOf(userID), String.valueOf(deviceID),
                            String.valueOf(userID), String.valueOf(10 * pageNum)});
            messageInfoList = new ArrayList<DeviceAlarmMessage>();
            while (cursor.moveToNext()) {
                try {
                    DeviceAlarmMessage messageInfo = new DeviceAlarmMessage();
                    Log.i("MessageDetailTAG", "date num is:" + cursor.getColumnIndex("MSG_ID"));
                    messageInfo.setMsgID(cursor.getLong(cursor.getColumnIndex("MSG_ID")));
                    messageInfo.setImgUrl(cursor.getString(cursor.getColumnIndex("IMG_URL")));
                    if (messageInfo.getImgUrl() != null) {
                        String[] url = messageInfo.getImgUrl().split(",");
                        messageInfo.addUrl(url);
                    }
                    messageInfo.setIsRead(cursor.getString(cursor.getColumnIndex("IS_READ")));
                    messageInfo.setCreateDate(cursor.getString(cursor.getColumnIndex("CREATE_DATE")));
                    messageInfo.setDeviceID(cursor.getLong(cursor.getColumnIndex("DEVICE_ID")));
                    messageInfo.setUserID(cursor.getLong(cursor.getColumnIndex("USER_ID")));
                    messageInfo.setUserIDS(cursor.getLong(cursor.getColumnIndex("USER_IDS")));
                    messageInfo.setImageAlertType(cursor.getInt(cursor.getColumnIndex("IMAGE_ALERT_TYPE")));
                    messageInfo.setTumbnailPic(cursor.getString(cursor.getColumnIndex("THUMBNAIL")));
                    messageInfo.setDecibel(cursor.getString(cursor.getColumnIndex("DECIBEL")));
                    messageInfoList.add(messageInfo);
                } catch (Exception e) {

                }

            }
            cursor.close();
            db.close();
        }
        return messageInfoList;
    }
}
