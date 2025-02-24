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
    MR_BLE_CMD_KEY_REQ_V2 = 0x0110,//获取临时key v2
    MR_BLE_CMD_KEY_RSP_V2 = 0x0111,
    MR_BLE_CMD_GET_TOKEN_REQ = 0x0112,//获取真实token
    MR_BLE_CMD_GET_TOKEN_RSP = 0x0113,
    
    MR_BLE_CMD_GET_SIM_INFO_REQ = 0x0201,//获取SIM信息
    MR_BLE_CMD_GET_SIM_INFO_RSP = 0x0202,
    MR_BLE_CMD_CONFIG_SIM_AND_BIND_REQ = 0x0203,//配置SIM卡并绑定用户
    MR_BLE_CMD_CONFIG_SIM_AND_BIND_RSP = 0x0204,

    MR_BLE_CMD_GET_DP_REQ = 0x0500,//获取DP点
    MR_BLE_CMD_GET_DP_RSP = 0x0501,
    MR_BLE_CMD_SET_DP_REQ = 0x0502,//设置DP点
    MR_BLE_CMD_SET_DP_RSP = 0x0503,
    MR_BLE_CMD_UPLOAD_DP_REQ = 0x0504,//上报DP点
    MR_BLE_CMD_UPLOAD_DP_RSP = 0x0505,
    MR_BLE_CMD_GET_CAPS_REQ = 0x0506,//获取能力级
    MR_BLE_CMD_GET_CAPS_RSP = 0x0507,
    MR_BLE_CMD_DP_CONTROL_AUTH_REQ = 0x0508,//dp点操作权限认证
    MR_BLE_CMD_DP_CONTROL_AUTH_RSP = 0x0509,
    
    MR_BLE_CMD_GET_NET_IP_INFO_REQ = 0x02000,//获取设备IP信息
    MR_BLE_CMD_GET_NET_IP_INFO_RSP = 0x02001,
    MR_BLE_CMD_CONFIG_NET_IP_REQ = 0x02002,//设置设备IP信息
    MR_BLE_CMD_CONFIG_NET_IP_RSP = 0x02003,

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
