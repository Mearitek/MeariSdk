package com.meari.test.common;

/**
 *
 */
public interface StringConstants {
    /**
     * 门铃来电action
     */
    String BELL_CALL = "meari.bell.call";
    /**
     * 门铃call了又call
     */
    String BELL_CALLCALL = "meari.bell.callcall";

    /**
     * http 狀態碼
     */
    /**
     * http 狀態碼
     */
    String STATUS = "resultCode";

    /**
     * mqtt推送设备状态
     */
    String DEVICE_ON_OFF_LINE = "meari.camera.status";

    /**
     * 退出APP (参数为0是表示退出app)
     */
    String MESSAGE_EXIT_APP = "com.meari.test.exit_app";

    /**
     * MESSAGE_ID_EXIT_APP 退出程序
     */

    int MESSAGE_ID_EXIT_APP = 0;
    /**
     * MESSAGE_ID_EXIT_AP
     */
    int MESSAGE_ID_TOKEN_CHANGE = 1;

    /**
     *
     */
    String EXIT_ACTION_QUIT = "com.meari.test.quit";
    String DEVICE_REFRESH_STATUS = "meari.camera.status_RESH";
    String MEARI_USER = "MEARI_USER";
    String USER_INFO = "user_info";
    String SERVER_MQTT = "mqtt_server";
    String MEARI_SDK = "MearSdk";
    String DISTRIBUTION_TYPE = "DistributionType";
    String AP_MODE = "ApMode";
    String DEVICE_TYPE_ID = "deviceTypeID";
    String WIFI_NAME = "wifi_name";
    String WIFI_PWD = "wifi_pwd";
    String WIFI_MODE = "wifi_mode";
    String CAMERAS = "cameras";
    String SMART_CONFIG = "smartConfig";
    String BACK_HOME = "back_home";
    String SCREEN_SHOT = "screenshot";
    String CAMERA_INFO = "cameraInfo";
    String CAMERA_INFOS = "cameraInfos";
    String TYPE = "type";
    String REGION_INFO = "RegionInfo";
    String COUNTRY_CODE_CHINA = "CN";
    String CHINESE_LANGUAGE = "zh";
    String ENGLISH_LANGUAGE = "en";
    String KOREAN_LANGUAGE = "ko";
    String JAPAN_LANGUAGE = "ja";
    String DEVICE_ID = "deviceID";
    String WIFI_DESC = "wifidesc";
    String SSID = "ssid";
    String BSSID = "ssid";
    String MEARI_LOGIN_ACCOUNT = "meari_login_account";
    String NVR_INFO = "nvr_info";
    String MOTION = "motion";
}

