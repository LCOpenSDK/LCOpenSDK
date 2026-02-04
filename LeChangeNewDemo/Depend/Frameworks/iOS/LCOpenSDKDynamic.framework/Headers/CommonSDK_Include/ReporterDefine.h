#ifndef __DAHUA_LCCommon_REPORTERCOMPONENT_REPORTERDEFINE_H__
#define __DAHUA_LCCommon_REPORTERCOMPONENT_REPORTERDEFINE_H__
#include <stdio.h>
#include <string>

// PSS上报老代码, 业务代码已注掉, IOS上层接口仍有依赖, 保留符号
namespace Dahua
{
namespace LCCommon
{
    /* 拉流方式 */
    typedef enum StreamMode
    {
        MODE_ERR = -1,  /* 内部出错 */
        MODE_P2P,       /* P2P方式 */
        MODE_MTS,       /* MTS转发方式 */
    }STREAM_MODE;

    /* P2P穿透状态 */
    typedef enum TraversalInfo
    {
        STATUS_LAN = 0, /* 局域网 */
        STATUS_P2P,     /* P2P */
        STATUS_RELAY,   /* 中转 */
    }TRAVERSAL_INFO;

    /* 协议类型 */
    typedef enum
    {
        PROT_HTTP,
        PROT_HTTPS,
    }PROTOCOL_TYPE;

    /* 设备类型 */
    typedef enum
    {
        DEVICE_LC,  /* 乐橙P2P设备 */
        DEVICE_DH,  /* 大华P2P设备 */
    }DH_DEVICE_TYPE;

    /* 海外P2P穿透状态信息结构 */
    typedef struct overseasP2pTraversalInfo
    {
        const char     *deviceSN;           /* 设备序列号 */
        int             punchCount;         /* 尝试打洞次数 */
        int             punchTime;          /* 最后一次打洞成功时的时长, 单位毫秒 */
        const char     *deviceNATIp;        /* 设备端公网IP */
        int             deviceNATPort;      /* 设备端公网端口 */
        const char     *clientNATIp;        /* 客户端公网IP */
        int             clientNATPort;      /* 客户端公网端口 */
        TRAVERSAL_INFO  traversalState;     /* 穿透状态 */
        
        overseasP2pTraversalInfo()
            : deviceSN(NULL)
            , punchCount(0)
            , punchTime(0)
            , deviceNATIp(0)
            , deviceNATPort(0)
            , clientNATIp(0)
            , clientNATPort(0)
            , traversalState(STATUS_LAN)
        {
        }

    } OVERSEAS_P2PTRAVERSAL_INFO;
} //LCCommon
} //Dahua

#endif /* __DAHUA_LCCommon_REPORTERCOMPONENT_REPORTERDEFINE_H__ */