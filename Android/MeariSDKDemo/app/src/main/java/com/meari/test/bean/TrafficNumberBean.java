package com.meari.test.bean;

import java.util.List;

public class TrafficNumberBean {

    private String resultCode;
    private String simID;
    private ResultDataDTO resultData;

    public String getResultCode() {
        return resultCode;
    }

    public void setResultCode(String resultCode) {
        this.resultCode = resultCode;
    }

    public String getSimID() {
        return simID;
    }

    public void setSimID(String simID) {
        this.simID = simID;
    }

    public ResultDataDTO getResultData() {
        return resultData;
    }

    public void setResultData(ResultDataDTO resultData) {
        this.resultData = resultData;
    }

    public static class ResultDataDTO {
        private SubscriberQuotaDTO subscriberQuota;
        private List<PreActivePackageListDTO> preActivePackageList;
        private List<HistoryQuotaDTO> historyQuota;

        public SubscriberQuotaDTO getSubscriberQuota() {
            return subscriberQuota;
        }

        public void setSubscriberQuota(SubscriberQuotaDTO subscriberQuota) {
            this.subscriberQuota = subscriberQuota;
        }

        public List<PreActivePackageListDTO> getPreActivePackageList() {
            return preActivePackageList;
        }

        public void setPreActivePackageList(List<PreActivePackageListDTO> preActivePackageList) {
            this.preActivePackageList = preActivePackageList;
        }

        public List<HistoryQuotaDTO> getHistoryQuota() {
            return historyQuota;
        }

        public void setHistoryQuota(List<HistoryQuotaDTO> historyQuota) {
            this.historyQuota = historyQuota;
        }

        public static class SubscriberQuotaDTO {
            private String qtavalue;
            private String qtabalance;
            private String qtaconsumption;
            private String activeTime;
            private String expireTime;
            private String mealType;
            private String money;
            private int unlimited;

            public String getMoney() {
                return money;
            }

            public void setMoney(String money) {
                this.money = money;
            }

            public int getUnlimited() {
                return unlimited;
            }

            public void setUnlimited(int unlimited) {
                this.unlimited = unlimited;
            }


            public String getQtavalue() {
                return qtavalue;
            }

            public void setQtavalue(String qtavalue) {
                this.qtavalue = qtavalue;
            }

            public String getQtabalance() {
                return qtabalance;
            }

            public void setQtabalance(String qtabalance) {
                this.qtabalance = qtabalance;
            }

            public String getQtaconsumption() {
                return qtaconsumption;
            }

            public void setQtaconsumption(String qtaconsumption) {
                this.qtaconsumption = qtaconsumption;
            }

            public String getActiveTime() {
                return activeTime;
            }

            public void setActiveTime(String activeTime) {
                this.activeTime = activeTime;
            }

            public String getMearlType() {
                return mealType;
            }

            public void setMearlType(String mearlType) {
                this.mealType = mearlType;
            }

            public String getExpireTime() {
                return expireTime;
            }

            public void setExpireTime(String expireTime) {
                this.expireTime = expireTime;
            }

        }

        public static class PreActivePackageListDTO {
            private String mealType;
            private String trafficPackage;
            private String money;
            private int quantity;
            private int unlimited;
            private String expireTime;

            public String getExpireTime() {
                return expireTime;
            }

            public void setExpireTime(String expireTime) {
                this.expireTime = expireTime;
            }

            public String getMoney() {
                return money;
            }

            public void setMoney(String money) {
                this.money = money;
            }

            public int getUnlimited() {
                return unlimited;
            }

            public void setUnlimited(int unlimited) {
                this.unlimited = unlimited;
            }

            public String getMealType() {
                return mealType;
            }

            public void setMealType(String mealType) {
                this.mealType = mealType;
            }

            public String getTrafficPackage() {
                return trafficPackage;
            }

            public void setTrafficPackage(String trafficPackage) {
                this.trafficPackage = trafficPackage;
            }

            public int getQuantity() {
                return quantity;
            }

            public void setQuantity(int quantity) {
                this.quantity = quantity;
            }
        }

        public static class HistoryQuotaDTO {
            private String time;
            private String qtaconsumption;

            public String getTime() {
                return time;
            }

            public void setTime(String time) {
                this.time = time;
            }

            public String getQtaconsumption() {
                return qtaconsumption;
            }

            public void setQtaconsumption(String qtaconsumption) {
                this.qtaconsumption = qtaconsumption;
            }
        }
    }
}
