package com.meari.test;

import android.text.TextUtils;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.json.BaseJSONObject;

import org.json.JSONException;

public class CommonUtils {
    public static String getDefaultStreamId(CameraInfo cameraInfo) {
        String streamId = "1";
        if (cameraInfo.getVst() == 1) {
            streamId = "0";
        } else {
            if (!TextUtils.isEmpty(cameraInfo.getBps2())) {
                try {
                    BaseJSONObject object = new BaseJSONObject(cameraInfo.getBps2());
                    if (object.has("0")) {
                        streamId = "100";
                    } else if (object.has("1")) {
                        streamId = "101";
                    } else if (object.has("2")) {
                        streamId = "102";
                    } else if (object.has("3")) {
                        streamId = "103";
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else if (cameraInfo.getBps() == 0 || cameraInfo.getBps() == -1) {
                streamId = "0";
            } else {
                streamId = "1";
            }
        }
        return streamId;
    }

}
