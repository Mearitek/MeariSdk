package com.meari.test.bean;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/7/19
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class DeviceTypeInfo {
    private String deviceName;
    private int deviceTypeId;
    private int deviceImageId;

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public int getDeviceTypeId() {
        return deviceTypeId;
    }

    public void setDeviceTypeId(int deviceTypeId) {
        this.deviceTypeId = deviceTypeId;
    }

    public int getDeviceImageId() {
        return deviceImageId;
    }

    public void setDeviceImageId(int deviceImageId) {
        this.deviceImageId = deviceImageId;
    }
}
