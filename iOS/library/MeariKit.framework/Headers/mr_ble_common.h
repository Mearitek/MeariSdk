#ifndef ALLSDKLIBS_MR_BLE_COMMON_H
#define ALLSDKLIBS_MR_BLE_COMMON_H


#define MR_BLE_ENC_SUPPORT_MAX_NUM (sizeof(int))

#define MR_BLE_ENC_SUPPORT(support_flag, enc_dec_type) ((((int)enc_dec_type)<MR_BLE_ENC_SUPPORT_MAX_NUM)&&((support_flag>>enc_dec_type)&0x01))
#define MR_BLE_ADD_ENC_DEC_SUPPORT(support_flag, enc_dec_type) (support_flag=(0x01<<enc_dec_type)|support_flag)

typedef enum {
    NONE,
    MR_BLE_ENC_AES,

    MR_BLE_ENC_UNKNOWN
}MR_BLE_ENC_TYPE;

typedef enum {
    MR_BLE_CMD_KEY_REQ = 0x0100,//获取临时key
    MR_BLE_CMD_KEY_RSP = 0x0101,
    MR_BLE_CMD_AUTH_REQ = 0x0102,//鉴权验证
    MR_BLE_CMD_AUTH_RSP = 0x0103,
    MR_BLE_CMD_WIFI_REQ = 0x0104,//获取Wifi列表
    MR_BLE_CMD_WIFI_RSP = 0x0105,
    MR_BLE_CMD_CONFIG_NET_REQ = 0x0106,//配网设备
    MR_BLE_CMD_CONFIG_NET_RSP = 0x0107,
    MR_BLE_CMD_BIND_REQ = 0x0108,//蓝牙绑定设备（暂无）
    MR_BLE_CMD_BIND_RSP = 0x0109,
    MR_BLE_CMD_BIND_STATUS_REQ = 0x010a,//绑定设备状态（暂无）
    MR_BLE_CMD_BIND_STATUS_RSP = 0x010b,
    MR_BLE_CMD_ACTIVE_WIFI_REQ = 0x010c,//激活设备Wifi
    MR_BLE_CMD_ACTIVE_WIFI_RSP = 0x010d,
    
    MR_BLE_CMD_GET_DP_REQ = 0x0500,//获取DP点
    MR_BLE_CMD_GET_DP_RSP = 0x0501,
    MR_BLE_CMD_SET_DP_REQ = 0x0502,//设置DP点
    MR_BLE_CMD_SET_DP_RSP = 0x0503,
    MR_BLE_CMD_UPLOAD_DP_REQ = 0x0504,//上报DP点
    MR_BLE_CMD_UPLOAD_DP_RSP = 0x0505,
    MR_BLE_CMD_GET_CAPS_REQ = 0x0506,//获取能力级
    MR_BLE_CMD_GET_CAPS_RSP = 0x0507,
    
}MR_BLE_CMD_TYPE;

typedef struct {
    //加密类型
    int enc_type;

    unsigned char* data1;
    int data1_len;
    unsigned char* data2;
    int data2_len;
}MR_BLE_KEY;

#endif //ALLSDKLIBS_MR_BLE_COMMON_H