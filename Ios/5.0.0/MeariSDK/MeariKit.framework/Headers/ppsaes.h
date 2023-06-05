/**
 * @file        pps_aes.h
 *
 * @copyright   2016-2019 Meari technology Co., Ltd
 *
 * @brief       Descript the file here...
 *              If you want descript file more, please write here...
 *
 * @author
 *
 * @date        2019/7/9
 *
 * @version     1.0.0
 *
 * @note        Something you must take care...
 */

#ifndef _PPS_AES_H_
#define _PPS_AES_H_

#include <stdint.h>
#include "base64.h"
#include "hexport.h"
BEGIN_EXTERN_C
/* #define the macros below to 1/0 to enable/disable the mode of operation. */
/*  */
/* CBC enables AES128 encryption in CBC-mode of operation and handles 0-padding. */
/* ECB enables the basic ECB 16-byte block algorithm. Both can be enabled simultaneously. */

/* The #ifndef-guard allows it to be configured before #include'ing or at compile time. */
#ifndef CBC
  #define CBC 1
#endif

#ifndef ECB
  #define ECB 1
#endif

#if defined (ECB) && ECB

void PPS_AES128_ECB_encrypt(const uint8_t *key, uint8_t *output);
void PPS_AES128_ECB_decrypt(const uint8_t *key, uint8_t *output);

#endif // #if defined(ECB) && ECB

#if defined (CBC) && CBC

void PPS_AES128_CBC_encrypt_buffer(uint8_t *output, uint8_t *input, uint32_t length, const uint8_t *key, const uint8_t *iv);
void PPS_AES128_CBC_decrypt_buffer(uint8_t *output, uint8_t *input, uint32_t length, const uint8_t *key, const uint8_t *iv);

typedef struct ap_data{
    int magic;// 0x56565099
    int length; //enc length aes_128 cbc length
    int version;//defalut 1
    uint8_t *encdata;//enc data
}ap_data;

HV_EXPORT void enc_wifi_data(char *srcdata,ap_data* data);
HV_EXPORT void dec_wifi_data(char *decoutput,ap_data* data);

HV_EXPORT int ble_encrypt(char* srcinfo, int srcLen, char** outInfo, int* outLen);
HV_EXPORT int ble_decode(char* srcinfo, int srcLen, char** outInfo, int* outLen);

#endif // #if defined(CBC) && CBC

END_EXTERN_C

#endif /* _AES_H_ */
