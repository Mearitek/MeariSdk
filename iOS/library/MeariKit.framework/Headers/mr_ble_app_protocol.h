#ifndef ALLSDKLIBS_MR_BLE_APP_PROTOCOL_H
#define ALLSDKLIBS_MR_BLE_APP_PROTOCOL_H

#include "mr_ble_common.h"
#include "hexport.h"
typedef struct {
    unsigned short magic;/// 0x5099
    unsigned short cmd; /// 命令码
    unsigned short seq; /// 本次请求号
    unsigned short data_len; /// 数据长度
    unsigned char  data_enc_type; /// 数据加密方式 0x00 -不加密 0x01-aes
    char res[3];
}MR_BLE_APP_HEADER;

typedef struct {
    MR_BLE_APP_HEADER header;
    unsigned char* payload;
}MR_BLE_APP_PACKET;

BEGIN_EXTERN_C

/**
 * sample:
 * MR_BLE_APP_PACKET packet;
 * MR_BLE_APP_PACKET* pPacket = &packet;
 *
 * mr_ble_fill_app_packet(pPacket);
 * *******
 * //user code
 * *******
 * mr_ble_clean_app_packet(pPacket);
 *
 * @return 0成功
 */
int mr_ble_fill_app_packet(MR_BLE_APP_PACKET *packet, int cmd, const unsigned char *data, int len);

int mr_ble_fill_enc_app_packet(MR_BLE_APP_PACKET *packet, int cmd,const unsigned char *data, int len,
                                 MR_BLE_ENC_TYPE enc_type, MR_BLE_KEY* key);

void mr_ble_clean_app_packet(MR_BLE_APP_PACKET *packet);

int mr_ble_get_app_data1(MR_BLE_APP_PACKET* packet, unsigned char** out);

int mr_ble_get_app_data(int cmd, unsigned char *data, int len,
                        MR_BLE_ENC_TYPE enc_type, MR_BLE_KEY* key, unsigned char** out, int *seq);

int mr_ble_parse_app_packet_with_dec(MR_BLE_APP_PACKET* packet, MR_BLE_KEY* key, const unsigned char* app_data, int len);

END_EXTERN_C

#endif //ALLSDKLIBS_MR_BLE_APP_PROTOCOL_H
