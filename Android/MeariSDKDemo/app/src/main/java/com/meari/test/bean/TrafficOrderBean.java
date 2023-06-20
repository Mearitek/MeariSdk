package com.meari.test.bean;

import java.util.List;

public class TrafficOrderBean {

    private List<OrderListDTO> orderList;

    public List<OrderListDTO> getOrderList() {
        return orderList;
    }

    public void setOrderList(List<OrderListDTO> orderList) {
        this.orderList = orderList;
    }

    public static class OrderListDTO {
        private String orderNum;
        private String mealType;
        private String payMoney;
        private String payDate;
        private int quantity;
        private String trafficPackage;
        private int trafficQuantity;
        private String currencyCode;
        private String currencySymbol;

        private int payType;

        public int getPayType() {
            return payType;
        }

        public void setPayType(int payType) {
            this.payType = payType;
        }
        private int unlimited;

        public int getUnlimited() {
            return unlimited;
        }

        public void setUnlimited(int unlimited) {
            this.unlimited = unlimited;
        }
        public String getOrderNum() {
            return orderNum;
        }

        public void setOrderNum(String orderNum) {
            this.orderNum = orderNum;
        }

        public String getMealType() {
            return mealType;
        }

        public void setMealType(String mealType) {
            this.mealType = mealType;
        }

        public String getPayMoney() {
            return payMoney;
        }

        public void setPayMoney(String payMoney) {
            this.payMoney = payMoney;
        }

        public String getPayDate() {
            return payDate;
        }

        public void setPayDate(String payDate) {
            this.payDate = payDate;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public String getTrafficPackage() {
            return trafficPackage;
        }

        public void setTrafficPackage(String trafficPackage) {
            this.trafficPackage = trafficPackage;
        }

        public int getTrafficQuantity() {
            return trafficQuantity;
        }

        public void setTrafficQuantity(int trafficQuantity) {
            this.trafficQuantity = trafficQuantity;
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
    }
}
