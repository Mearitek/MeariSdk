package com.meari.test.service;


public class MqttDialogUtils {

    private static MqttDialogUtils instances;
    private static CommonDialogListener mListener;

    private MqttDialogUtils() {

    }

    public void setListener(CommonDialogListener listener) {
        this.mListener = listener;
    }

    public static MqttDialogUtils getInstances() {
        if (instances == null) {
            synchronized (MqttDialogUtils.class) {
                if (instances == null) {
                    instances = new MqttDialogUtils();
                }
            }
        }
        return instances;
    }


    public void showDialog() {
        if (mListener != null) {
            mListener.show();
        }
    }

    public void cancel() {
        if (mListener != null) {
            mListener.cancel();
        }
    }
}
