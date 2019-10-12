package com.meari.test.bean;
/*

 * -----------------------------------------------------------------
 * Copyright (C) 2015-2055 ljh www.meari.com.cn all rights reserved.
 * -----------------------------------------------------------------
 * 作  者：ljh
 * 版  本：1.0
 * 文  件：RegionBean
 * 日  期：17-12-1
 * 描  述：
 * 修订历史：
 */

import java.util.ArrayList;
import java.util.List;

public class RegionBean {

    private List<RegionGroup> datas;
    private List<String> alifNames;

    public List<RegionGroup> getDatas() {
        return datas;
    }

    public List<String> getAlifNames()

    {
        return alifNames;
    }

    public void setDatas(List<RegionGroup> datas) {
        this.datas = datas;
    }


    public void addRegion(String alifName, RegionInfo regionInfo) {
        if (getDatas() == null || alifName == null) {
            datas = new ArrayList<>();
            alifNames = new ArrayList<>();
            alifNames.add(alifName);
            RegionGroup group = new RegionGroup();
            group.setFirstLetter(alifName);
            if (group.getRegions() != null)
                group.getRegions().add(regionInfo);
            else {
                group.setRegions(new ArrayList<RegionInfo>());
                group.getRegions().add(regionInfo);
            }
            datas.add(group);
        } else {
            if (!alifNames.contains(alifName)) {
                alifNames.add(alifName);
                RegionGroup group = new RegionGroup();
                group.setFirstLetter(alifName);
                if (group.getRegions() != null)
                    group.getRegions().add(regionInfo);
                else {
                    group.setRegions(new ArrayList<RegionInfo>());
                    group.getRegions().add(regionInfo);
                }
                datas.add(group);
            } else {
                for (RegionGroup group : datas) {
                    if (group.getFirstLetter().equals(alifName)) {
                        group.getRegions().add(regionInfo);
                    }

                }
            }
        }
    }
}
