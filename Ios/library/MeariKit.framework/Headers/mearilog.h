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

int pps_set_log_path(char* path);
int pps_set_level_print(int level);
int pps_get_print_level();
void pps_print_log(int level,const char* tag,const char * format, ...);

file_op* pps_create_stream_file(char* streamfilename);
int pps_write_stream_to_file(file_op* op,char* buf,int size);
int pps_close_stream_file(file_op* op);

int putappevent(char *json);
#ifdef __cplusplus
}
#endif

#endif
