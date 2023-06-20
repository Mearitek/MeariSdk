package com.meari.test.bean;

import java.util.List;

public class TrafficPacketBean {
    private boolean trialStatus;
    private int maxMonthQuantity;

    private String simID;
    private List<PackageListDTO> packageList;

    public boolean isTrialStatus() {
        return trialStatus;
    }

    public void setTrialStatus(boolean trialStatus) {
        this.trialStatus = trialStatus;
    }

    public String getSimID() {
        return simID;
    }

    public void setSimID(String simID) {
        this.simID = simID;
    }

    public int getMaxMonthQuantity() {
        return maxMonthQuantity;
    }

    public void setMaxMonthQuantity(int maxMonthQuantity) {
        this.maxMonthQuantity = maxMonthQuantity;
    }

    public List<PackageListDTO> getPackageList() {
        return packageList;
    }

    public void setPackageList(List<PackageListDTO> packageList) {
        this.packageList = packageList;
    }

    public static class PackageListDTO {
        private String id;
        private String mealType;
        private String money;
        private String currencyCode;
        private String currencySymbol;
        private String trafficPackage;
        private int quantity;
        private int unlimited;
        private String type;

        public int getUnlimited() {
            return unlimited;
        }

        public void setUnlimited(int unlimited) {
            this.unlimited = unlimited;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getMealType() {
            return mealType;
        }

        public void setMealType(String mealType) {
            this.mealType = mealType;
        }

        public String getMoney() {
            return money;
        }

        public void setMoney(String money) {
            this.money = money;
        }

        public String getCurrencyCode() {
            return currencyCode;
        }

        public void setCurrencyCode(String currencyCode) {
            this.currencyCode = currencyCode;
        }

        public String getCurrencySymbol() {
            return currencySymbol;
        }

        public void setCurrencySymbol(String currencySymbol) {
            this.currencySymbol = currencySymbol;
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

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }
    }
}
