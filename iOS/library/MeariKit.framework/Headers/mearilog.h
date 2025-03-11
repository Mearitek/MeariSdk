#ifndef  _PPS_LOG__H
#define _PPS_LOG__H
#include "stdio.h"
enum PPSLog_Type{
    PPS_LOG_VERBOSE,
    PPS_LOG_DEBUG,
    PPS_LOG_INFO,
    PPS_LOG_WARN,
    PPS_LOG_ERROR,
    PPS_LOG_NONE
};
typedef struct{
    char filename[128];
    FILE* op;
    int totalsize;
    int totalnum;
}file_op;
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__APPLE__)||defined(__linux__)
#ifndef CALLBACK
#define CALLBACK
#endif
#elif defined(_WIN32)
#ifndef  CALLBACK
#define  CALLBACK __stdcall
#endif
#endif

int pps_log_encrypt(char* log, int len, char** out);
int pps_enable_log_encrypt(int enable);
int pps_set_log_path(char* path);
int pps_set_level_print(int level);
char* pps_get_log_filename(void);
int pps_get_print_level(void);
void pps_print_log(int level,const char* tag,const char * format, ...);
typedef void (* pps_log_callback)(int level,const char* tag,char* buffer);
void pps_set_callback(pps_log_callback callback);

file_op* pps_create_stream_file(char* streamfilename);
int pps_write_stream_to_file(file_op* op,char* buf,int size);
int pps_close_stream_file(file_op* op);

#ifdef _WIN32
#ifndef MDIR_SEPARATOR
#define MDIR_SEPARATOR       '\\'
#endif
#ifndef MDIR_SEPARATOR_STR
#define MDIR_SEPARATOR_STR   "\\"
#endif
#else
#ifndef MDIR_SEPARATOR
#define MDIR_SEPARATOR       '/'
#endif
#ifndef MDIR_SEPARATOR_STR
#define MDIR_SEPARATOR_STR   "/"
#endif
#endif

#ifndef __FILENAME__
#define __FILENAME__  (strrchr(MDIR_SEPARATOR_STR __FILE__, MDIR_SEPARATOR) + 1)
#endif

#define MLOGV(fmt,...) pps_print_log(0,(char*)"mrsdk-jni",fmt " [%s:%d:%s]\n", ## __VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define MLOGD(fmt,...) pps_print_log(1,(char*)"mrsdk-jni",fmt " [%s:%d:%s]\n", ## __VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define MLOGI(fmt,...) pps_print_log(2,(char*)"mrsdk-jni",fmt " [%s:%d:%s]\n", ## __VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define MLOGW(fmt,...) pps_print_log(3,(char*)"mrsdk-jni",fmt " [%s:%d:%s]\n", ## __VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define MLOGE(fmt,...) pps_print_log(4,(char*)"mrsdk-jni",fmt " [%s:%d:%s]\n", ## __VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)
#define MLOGF(fmt,...) pps_print_log(4,(char*)"mrsdk-jni",fmt " [%s:%d:%s]\n", ## __VA_ARGS__, __FILENAME__, __LINE__, __FUNCTION__)

#ifdef __cplusplus
}
#endif

#endif
