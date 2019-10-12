package com.meari.test.bean;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/12/14
 * ================================================
 */

public class RegionGroup implements Serializable {
    private String firstLetter;
    private ArrayList<RegionInfo> regions = new ArrayList<>();

    public String getFirstLetter() {
        return firstLetter;
    }

    public void setFirstLetter(String firstLetter) {
        this.firstLetter = firstLetter;
    }

    public ArrayList<RegionInfo> getRegions() {
        return regions;
    }

    public void setRegions(ArrayList<RegionInfo> regions) {
        this.regions = regions;
    }
}

