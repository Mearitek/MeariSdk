package com.meari.test.bean;
public class SearchInfo {
    private String uuid;
    private String sn;
    private String ip;
    private String tp;
    private String model;
    private String licenseId;
    private String version;
    private String deviceName;
    private String capability;
    private String produceAuth;
    private String mac;

    public SearchInfo() {
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getTp() {
        return tp;
    }

    public void setTp(String tp) {
        this.tp = tp;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getLicenseId() {
        return licenseId;
    }

    public void setLicenseId(String licenseId) {
        this.licenseId = licenseId;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public String getCapability() {
        return capability;
    }

    public void setCapability(String capability) {
        this.capability = capability;
    }

    public String getProduceAuth() {
        return produceAuth;
    }

    public void setProduceAuth(String produceAuth) {
        this.produceAuth = produceAuth;
    }

    public String getMac() {
        return mac;
    }

    public void setMac(String mac) {
        this.mac = mac;
    }
}
