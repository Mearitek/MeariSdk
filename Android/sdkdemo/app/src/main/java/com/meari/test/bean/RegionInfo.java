package com.meari.test.bean;
/*

 * -----------------------------------------------------------------
 * Copyright (C) 2015-2055 ljh www.meari.com.cn all rights reserved.
 * -----------------------------------------------------------------
 * 作  者：ljh
 * 版  本：1.0
 * 文  件：RegionInfo
 * 日  期：17-12-1
 * 描  述：
 * 修订历史：
 */


import java.io.Serializable;

public class RegionInfo implements Serializable {
    private String regionName;//当前系统系名字
    private String phoneCode;
    private String regionDisplayName;//拼音名字
    private String countryCode;
    private String language;

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }



    public String getRegionDisplayName() {
        return regionDisplayName;
    }

    public void setRegionDisplayName(String regionDisplayName) {
        this.regionDisplayName = regionDisplayName;
    }
    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getPhoneCode() {
        return phoneCode;
    }

    public void setPhoneCode(String phoneCode) {
        this.phoneCode = phoneCode;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }
}
