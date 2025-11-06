//
//  ShareHandleManager.h
//  shareHandleComponent
//
//  Created by Fizz on 2018/12/21.
//  Copyright © 2018 Fizz. All rights reserved.
//

#ifndef ShareHandleManager_h
#define ShareHandleManager_h
#include <stdio.h>
#include <string>
#include <map>
#include "StreamApp/HttpDh/HttpClientSessionWrapper.h"
#include "Infra/ReadWriteMutex.h"
#include <utility>

namespace Dahua {
namespace LCCommon {

typedef std::map<std::string, void*> HANDLEMAP;

enum ShareLinkStreamStatus
{
   ShareLinkStreamStatus_Playing,
   ShareLinkStreamStatus_Talking,
};

class CShareHandleManager{
public:
     static CShareHandleManager* getInstance();

public:
    int creatHandle(int iPort, const std::string& strIp, const std::string& strUrl, const std::string& strUsername, 
        const std::string& strPwd, const std::string& strDeviceSn, const std::string& strKey, int bEncrypt, 
        const std::string& strPsk, bool isTalk, bool isTls, const std::string& wsseKey, int streamModeType, 
        const std::string& jsonCfg = "");
    
    /*key: devicesn+channel �?�?23456+1�?返回为CShareHandle对象指针 */
    int findHandle(const std::string &key);

    int findHandleEx(const std::string &key, int iStatus);

    int startPlay(const std::string &key);

    int startTalk(const std::string &key, const std::string &talkType);

    int stopPlay(const std::string &key);

    int stopTalk(const std::string &key, const std::string &talkType);
    
    int continuePlay(const std::string &key);

    int playAudio(const std::string &key);

    int setCustomSampleCfg(const std::string &key, const std::string& cfg);

    void setPlayCallback(frame_proc_func frameFunc, state_proc_func stateFunc, msgcallback_proc_func msgFunc, void* user, const std::string &key);

    void setTalkCallback(frame_proc_func frameFunc, state_proc_func stateFunc, msgcallback_proc_func msgFunc, stream_info_proc_func streamInfoFunc,
        void* user, const std::string &key);

    int  startTalkVideo(const std::string &key, const std::string &talkType);

    int  stopTalkVideo(const std::string &key, const std::string &talkType);

    void unInit();
    
    int getStreamMode(const std::string &key);

    // 尝试切换到p2p链路
    std::pair<bool, std::string> trySwitchP2PLink(const std::string &desKey, const std::string &srcKey);

private:
    CShareHandleManager(){}

    ~CShareHandleManager(){}

private:
    HANDLEMAP                          m_handleMap;
    Infra::CReadWriteMutex             m_mapLock;

    static CShareHandleManager*        sm_handleManager;
};
}
}


#endif /* ShareHandleManager_h */
