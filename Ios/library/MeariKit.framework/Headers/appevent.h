#ifndef _APP_EVENT_H
#define _APP_EVENT_H
#ifdef _cplusplus

extern "C"
{
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
    typedef struct
    {
        int num;
        char eventid[8];
        char des[256];
        char datatypes[5][32];
        int  upload;
    } eventIds;

    char* getappeventnode();

    int setappeventnodes(char* id,int upload);

    int regappeventnodes(eventIds id);

    typedef void (CALLBACK * eventlogcallback)(void*arg);
    
    int setappeventcallback(eventlogcallback callback);

    int pauseevent(bool flag);

    int destoryappevent();

    int setappeventswitch(int enable);

    int initappevent();

    int iotappevent(char* err,char*ip,char* extraparams);

    int p2pconnectevent(char* uid,char* errorcode);

    int p2pliveevent(char* uid,char* errorcode);

    int p2phistoryevent(char* uid,char* errorcode);

    int p2pcloudevent(char* uid,char* errorcode);

    int p2pvoiceevent(char* uid,char* errorcode);

    int p2pcmdevent(char* uid,int cmd,char* errorcode);

    int p2pdisconnectedevent(char* uid,char* errorcode);


#ifdef _cplusplus
}
#endif

#endif
