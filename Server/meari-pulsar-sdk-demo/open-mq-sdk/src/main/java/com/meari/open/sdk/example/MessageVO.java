package com.meari.open.sdk.example;

import java.io.Serializable;

public class MessageVO implements Serializable {

    private String data;
    private String msgType;
    private String version;
    private Long t;

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getMsgType() {
        return msgType;
    }

    public void setMsgType(String msgType) {
        this.msgType = msgType;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public Long getT() {
        return t;
    }

    public void setT(Long t) {
        this.t = t;
    }


    @Override
    public String toString() {
        return "MessageVO{" +
                "data='" + data + '\'' +
                ", msgType='" + msgType + '\'' +
                ", version='" + version + '\'' +
                ", t=" + t +
                '}';
    }
}