//
// Created by 0494 on 2023/2/6.
//

#ifndef ALLSDKLIBS_TEST_H
#define ALLSDKLIBS_TEST_H

#include "mr_ble_app_protocol.h"

void test();
void reset_pwd();
int request_tmp_key(unsigned char **app);
int getApp(int cmd, const char *data, int len,const char *token, MR_BLE_ENC_TYPE enc_type, unsigned char **app);
unsigned char * parse_app(const unsigned char* app_data, int len, int *cmd);

const char* parseAd(const char* manufacturerAd, int len);

#endif //ALLSDKLIBS_TEST_H
