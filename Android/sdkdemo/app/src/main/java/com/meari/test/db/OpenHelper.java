package com.meari.test.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class OpenHelper extends SQLiteOpenHelper {
    private static final int DATABASE_VERSION = 3;
    /*
     *@param context 应用文上下文
     *@param name 数据库的名称
     *@param factory 查询数据库的游标工厂 一般情况下用sdk默认
     *@param version 数据库的版本版本号必须大于1
     *
     */
    private static OpenHelper instance = null;

    public OpenHelper(Context context) {
        super(context, "ppstorng.db", null, DATABASE_VERSION);
    }

    //在第一被new出来的时候，系统会执行onCreate方法
    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE ALERT_MSG(MSG_ID INTEGER ,IMG_URL VARCHAR(64),IS_READ VARCHAR(1),CREATE_DATE VARCHAR(32),DEVICE_ID INTEGER,USER_ID INTEGER,USER_IDS INTEGER,IMAGE_ALERT_TYPE INTEGER,THUMBNAIL VARCHAR(32),DECIBEL VARCHAR(32))");
        db.execSQL("CREATE TABLE DEVICE_INFO(DEVICE_ID)");
    }

    /*
     * 数据库的版本号将被执行,版本的升级
     */
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // 使用for实现跨版本升级数据库
        for (int i = oldVersion; i < newVersion; i++) {
            switch (i) {
                case 1:
                    upgradeToVersion(db);
                    upgradeToAddDecibelVersion(db);
                    break;
                case 2:
                    upgradeToAddDecibelVersion(db);
                    break;
                default:
                    break;
            }
        }

    }

    private void upgradeToAddDecibelVersion(SQLiteDatabase db) {
        // favorite表新增1个字段
        String sql1 = "ALTER TABLE " + " ALERT_MSG" + " ADD COLUMN DECIBEL INTEGER";
        db.execSQL(sql1);
    }

    private void upgradeToVersion(SQLiteDatabase db) {
        // favorite表新增1个字段
        String sql1 = "ALTER TABLE " + " ALERT_MSG" + " ADD COLUMN THUMBNAIL VARCHAR(32)";
        db.execSQL(sql1);
    }

    public synchronized static OpenHelper getInstance(Context context) {
        if (instance == null) {
            instance = new OpenHelper(context);
        }
        return instance;
    }
}
