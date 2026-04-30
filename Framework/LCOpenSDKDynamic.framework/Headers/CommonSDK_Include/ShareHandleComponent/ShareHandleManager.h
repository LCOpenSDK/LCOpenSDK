//
//  ShareHandleManager.h
//  shareHandleComponent
//
//  Created by Fizz on 2018/12/21.
//  Copyright © 2018 Fizz. All rights reserved.
//

#ifndef ShareHandleManager_h
#define ShareHandleManager_h

#include <string>
#include <map>
#include <utility>
#include <mutex>
#include <memory>

namespace Basic {
namespace LCCommon {

class CShareHandle;
typedef std::map<std::string, std::shared_ptr<CShareHandle>> HANDLEMAP;

enum ShareLinkStreamStatus
{
   ShareLinkStreamStatus_Playing,    // 播放业务
   ShareLinkStreamStatus_Talking,    // 对讲业务
};

// 私有协议回调函数定义，参数含义见StreamApp的HttpClientSessionWrapper.h头文件
typedef void(*dhhttpcb_msg)(const char *message, void *user, void *reserve1, void *reserve2);
typedef void (*dhhttpcb_state)(unsigned int message, unsigned int error_code, void* user, void *reserve);
typedef void(*dhhttpcb_frame)(const char* frame, int len, void* user, void *frame_info);
typedef void(*dhhttpcb_stream_info)(void *user, const char *message, unsigned int len, void *reserve1, void *reserve2);
typedef void(*dhhttpcb_stream_switch)(void *user, const char *message, unsigned int len, void *reserve1, void *reserve2);

class CShareHandleManager{
public:
     static CShareHandleManager* getInstance();

public:

    int creatHandle(int iPort, const std::string& strIp, const std::string& strUrl, const std::string& strUsername, 
        const std::string& strPwd, const std::string& strDeviceSn, const std::string& strKey, int bEncrypt, 
        const std::string& strPsk, bool isTalk, bool isTls, const std::string& wsseKey, int streamModeType, void* streamClient,
        const std::string& jsonCfg = "", const std::string& xUserInfo = "", bool enableIPv6Net = false, 
        int iPortV6 = 0, const std::string& strIpV6 = "", const std::string& strUrlV6 = "");
    
    /// @brief 流媒体句柄是否与对端完成初始化交互, 达到就绪状态
    /// @param key  devicesn+channel
    /// @return 达到就绪状态返回0, 否则返回非0
    /// @note 对外接口
    int findHandle(const std::string &key);

    /// @brief 流媒体句柄是否与对端完成初始化交互, 达到就绪状态
    /// @param key devicesn+channel
    /// @param iStatus 判断的业务, 参见ShareLinkStreamStatus
    /// @return 达到就绪状态返回0, 否则返回非0
    /// @note 对外接口
    int findHandleEx(const std::string &key, int iStatus);

    int startPlay(const std::string &key, int imageSize, void* streamClient);

    int stopPlay(const std::string &key);

    /// @brief 开始对讲
    /// @param key 
    /// @param talkType 对讲类型: 普通对讲, 可视对讲. 协议透传给设备
    /// @return 
    int startTalk(const std::string &key, const std::string &talkType);

    /// @brief 停止对讲
    /// @param key 
    /// @param talkType 对讲类型: 普通对讲, 可视对讲. 协议透传给设备
    /// @return 
    int stopTalk(const std::string &key, const std::string &talkType);

    /// @brief 开始可视对讲
    /// @param key 
    /// @param talkType 对讲类型: 普通对讲, 可视对讲. 协议透传给设备
    /// @return 
    int  startTalkVideo(const std::string &key, const std::string &talkType);

    /// @brief 停止可视对讲
    /// @param key 
    /// @param talkType 对讲类型: 普通对讲, 可视对讲. 协议透传给设备
    /// @return 
    int  stopTalkVideo(const std::string &key, const std::string &talkType);
    
    int continuePlay(const std::string &key);

    int playAudio(const std::string &key);

    int setCustomSampleCfg(const std::string &key, const std::string& cfg);

    void setPlayCallback(dhhttpcb_frame frameFunc, dhhttpcb_state stateFunc, dhhttpcb_msg msgFunc, dhhttpcb_stream_info streamInfoFunc, 
        dhhttpcb_stream_switch streamSwitchFunc, void* user, const std::string &key);

    void setTalkCallback(dhhttpcb_frame frameFunc, dhhttpcb_state stateFunc, dhhttpcb_msg msgFunc, dhhttpcb_stream_info streamInfoFunc,
        void* user, const std::string &key);

    void unInit();
    
    int getStreamMode(const std::string &key);

    // 尝试切换到p2p链路
    std::pair<bool, std::string> trySwitchP2PLink(const std::string &desKey, const std::string &srcKey);

    int setXUserInfo(const std::string &key, const std::string& info);

    /// @brief 是否走的混流协议
    /// @param key 
    /// @return true-是  false-不是
    bool isMixStream(const std::string &key);

    /// @brief 获取共享链路实际拉流网路地址类型（埋点功能）
    /// @param key 
    /// @return -1-error 0-ipv4  1-ipv6
    int getStreamNetType(const std::string &key);

private:

    CShareHandleManager(){}

    ~CShareHandleManager(){}

    /// @brief 获取share handle
    /// @param key 
    /// @return share handle 弱指针
    std::weak_ptr<CShareHandle> getShareHandle(const std::string &key);

    /// @brief 添加share handle
    /// @param key 
    /// @param shareHandle 共享指针
    /// @return 成功返回true, 失败返回false
    bool addShareHandle(const std::string &key, const std::shared_ptr<CShareHandle> &shareHandle);

    /// @brief 删除share handle
    /// @param key 
    void removeShareHandle(const std::string &key);

    /// @brief 交换两个key的shareHandle
    /// @param dstkey 
    /// @param srcKey 
    /// @return 成功返回true, 否则返回false
    bool swapShareHandle(const std::string &dstkey, const std::string &srcKey);
     
private:
    HANDLEMAP                           m_handleMap;                // share handle map, <key, shareHandle>
    std::mutex                          m_handleMapMutex;

    static CShareHandleManager*         sm_handleManager;           // 单例指针
};
}
}


#endif /* ShareHandleManager_h */
