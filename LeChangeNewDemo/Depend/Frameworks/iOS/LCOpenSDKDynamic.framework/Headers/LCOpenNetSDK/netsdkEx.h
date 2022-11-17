/*
* Copyright (c) 2009, 浙江大华技术股份有限公司
* All rights reserved.
*
* 摘　要：SDK接口很多,定制或一些不常用的功能可以放入dhnetsdkEx.h,
*         对外提供 dhnetsdk.h,
*         定制项目额外提供 dhnetsdkEx.h
*/
//////////////////////////////////////////////////////////////////////////
#ifndef DHNETSDKEX_H
#define DHNETSDKEX_H

#include "netsdk.h"

#ifdef __cplusplus
extern "C" {
#endif

/************************************************************************
 ** 常量定义
 ***********************************************************************/
#define MAX_RECORD_FILE_PASSWORD_LEN   128    // 最大的录像文件密码长度
/************************************************************************
 ** 枚举定义
 ***********************************************************************/

/************************************************************************
 ** 结构体定义
************************************************************************/

 //////////////////////////////////////透传扩展接口参数//////////////////////////////////////////////////////////////////
 
 // 透传类型
 typedef enum   tagNET_TRANSMIT_INFO_TYPE
 {
    NET_TRANSMIT_INFO_TYPE_DEFAULT,                 // 默认类型，即CLIENT_TransmitInfoForWeb接口的兼容透传方式
    NET_TRANSMIT_INFO_TYPE_F6,                      // F6纯透传
 } NET_TRANSMIT_INFO_TYPE;

 // 透传加密类型
 typedef enum tagEM_TRANSMIT_ENCRYPT_TYPE
 {
	EM_TRANSMIT_ENCRYPT_TYPE_UNKNOWN = -1,			// 未知
	EM_TRANSMIT_ENCRYPT_TYPE_NORMAL,				// SDK内部自行确定是否加密，默认
	EM_TRANSMIT_ENCRYPT_TYPE_MULTISEC,				// 设备支持加密的场景下，走multiSec加密
	EM_TRANSMIT_ENCRYPT_TYPE_BINARYSEC,				// 设备支持加密的场景下，走binarySec加密，二进制部分不加密
 }EM_TRANSMIT_ENCRYPT_TYPE;

 // CLIENT_TransmitInfoForWebEx输入参数
 typedef struct tagNET_IN_TRANSMIT_INFO
 {
    DWORD						dwSize;                         // 用户使用该结构体，dwSize需赋值为sizeof(NET_IN_TRANSMIT_INFO)
    NET_TRANSMIT_INFO_TYPE		emType;                         // 透传类型
    char*						szInJsonBuffer;                 // Json请求数据,用户申请空间
    DWORD						dwInJsonBufferSize;             // Json请求数据长度
    unsigned char*				szInBinBuffer;                  // 二进制请求数据，用户申请空间
    DWORD						dwInBinBufferSize;              // 二进制请求数据长度
	EM_TRANSMIT_ENCRYPT_TYPE	emEncryptType;					// 加密类型
 } NET_IN_TRANSMIT_INFO;

 // CLIENT_TransmitInfoForWebEx输出参数
 typedef struct tagNET_OUT_TRANSMIT_INFO
 {
    DWORD                   dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_OUT_TRANSMIT_INFO)
    char*                   szOutBuffer;                    // 应答数据缓冲空间, 用户申请空间
    DWORD                   dwOutBufferSize;                // 应答数据缓冲空间长度
    DWORD                   dwOutJsonLen;                   // Json应答数据长度
    DWORD                   dwOutBinLen;                    // 二进制应答数据长度
 } NET_OUT_TRANSMIT_INFO;

 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 //////////////////////////////////////////////异步纯透传结构体定义开始////////////////////////////////////////////////////////////////////////////////////////////
 // CLIENT_AttachTransmitInfo 上报信息回调
 typedef struct tagNET_CB_TRANSMIT_INFO
 {
     BYTE*              pBuffer;            // 数据缓冲地址，SDK内部申请空间
     DWORD              dwBufferSize;       // 数据缓冲总长度
     DWORD              dwJsonLen;          // Json数据长度
     DWORD              dwBinLen;           // 二进制数据长度
     BYTE               byReserved[512];    // 保留字节
 } NET_CB_TRANSMIT_INFO;

 // CLIENT_AttachTransmitInfo()回调函数原型，第一个参数lAttachHandle是CLIENT_AttachTransmitInfo返回值
 typedef int  (CALLBACK *AsyncTransmitInfoCallBack)(LLONG lAttachHandle, NET_CB_TRANSMIT_INFO* pTransmitInfo, LDWORD dwUser);

 // CLIENT_AttachTransmitInfo输入参数
 typedef struct tagNET_IN_ATTACH_TRANSMIT_INFO
 {
     DWORD                       dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_IN_ATTACH_TRANSMIT_INFO)
     AsyncTransmitInfoCallBack   cbTransmitInfo;                 // 回调函数
     LDWORD				         dwUser;                         // 用户数据
     char*                       szInJsonBuffer;                 // Json请求数据,用户申请空间
     DWORD                       dwInJsonBufferSize;             // Json请求数据长度  `
     BOOL						 bSubConnFirst;					 // TRUE-当设备支持时，使用子连接方式接收订阅数据 FALSE-只在主连接接收订阅数据
 }NET_IN_ATTACH_TRANSMIT_INFO;

 // CLIENT_AttachTransmitInfo输出参数
 typedef struct tagNET_OUT_ATTACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_OUT_ATTACH_TRANSMIT_INFO)
     BYTE*                   szOutBuffer;                    // 应答缓冲地址,用户申请空间
     DWORD                   dwOutBufferSize;                // 应答缓冲总长度
     DWORD                   dwOutJsonLen;                   // 应答Json数据长度
     DWORD                   dwOutBinLen;                    // 应答二进制数据长度 
 } NET_OUT_ATTACH_TRANSMIT_INFO;

 // CLIENT_DetachTransmitInfo输入参数
 typedef struct tagNET_IN_DETACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_IN_DETACH_TRANSMIT_INFO)
     char*                   szInJsonBuffer;                 // Json请求数据,用户申请空间
     DWORD                   dwInJsonBufferSize;             // Json请求数据长度
 } NET_IN_DETACH_TRANSMIT_INFO;

 // CLIENT_DetachTransmitInfo输出参数
 typedef struct tagNET_OUT_DETACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_OUT_DETACH_TRANSMIT_INFO)
     char*                   szOutBuffer;                    // 应答数据缓冲空间, 用户申请空间
     DWORD                   dwOutBufferSize;                // 应答数据缓冲空间长度
     DWORD                   dwOutJsonLen;                   // 应答Json数据长度
 } NET_OUT_DETACH_TRANSMIT_INFO;

//////上海BUS//////
 
// 上海巴士控制类型， 对应CLIENT_ControlSpecialDevice接口
typedef enum tagNET_SPECIAL_CTRL_TYPE
{
    NET_SPECIAL_CTRL_SHUTDOWN_PAD,            // 关闭PAD命令, pInBuf对应类型NET_IN_SHUTDOWN_PAD*, pOutBuf对应类型NET_OUT_SHUTDOWN_PAD*
    NET_SPECIAL_CTRL_REBOOT_PAD,              // 重启PAD命令, pInBuf对应类型NET_IN_REBOOT_PAD*, pOutBuf对应类型NET_OUT_REBOOT_PAD*                 
} NET_SPECIAL_CTRL_TYPE;

 //////////////////////////////////////////////设备特殊配置结构体定义开始////////////////////////////////////////////////////////////////////////////////////////////
 // CLIENT_DevSpecialCtrl 特殊控制类型
 typedef enum tagEM_DEV_SPECIAL_CTRL_TYPE
 {
     DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH,                  // 缓存录像数据强制写入硬盘, pInBuf=NET_IN_RECORD_FLUSH_INFO* , pOutBuf=NET_OUT_RECORD_FLUSH_INFO*
 } EM_DEV_SPECIAL_CTRL_TYPE;
 
 // CLIENT_DevSpecialCtrl, 对应 DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH 输入参数
 typedef struct tagNET_IN_NET_IN_RECORD_FLUSH_INFO
 {
    DWORD                                      dwSize;       // 用户使用该结构体时，dwSize需赋值为sizeof(NET_IN_RECORD_FLUSH_INFO)               
    int                                        nChannel;     // 通道号
    NET_STREAM_TYPE                            emStreamType; // 码流类型, 有效类型 "main", "Extra1", "Extra2", "Extar3", "Snapshot"     
 }NET_IN_RECORD_FLUSH_INFO;

 // CLIENT_DevSpecialCtrl, 对应 DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH 输出参数
 typedef struct tagNET_OUT_RECORD_FLUSH_INFO
 {
     DWORD                                     dwSize;       // 用户使用该结构体时，dwSize需赋值为sizeof(NET_OUT_RECORD_FLUSH_INFO)              
 }NET_OUT_RECORD_FLUSH_INFO;
 
 //////////////////////////////////////////////设备特殊配置结构体定义结束////////////////////////////////////////////////////////////////////////////////////////////
 

typedef struct tagNET_IN_REBOOT_PAD
{
    DWORD               dwSize;                  // 用户使用该结构体时，dwSize 需赋值为 sizeof(NET_IN_REBOOT_PAD)
} NET_IN_REBOOT_PAD;

typedef struct tagNET_OUT_REBOOT_PADE
{
    DWORD               dwSize;                  // 用户使用该结构体时，dwSize 需赋值为 sizeof(NET_OUT_REBOOT_PAD)
} NET_OUT_REBOOT_PAD;

typedef struct tagNET_IN_SHUTDOWN_PAD
{
    DWORD               dwSize;                  // 用户使用该结构体时，dwSize 需赋值为 sizeof(NET_IN_REBOOT_PAD)
    int                 nDelayTime;              // 延时关机时间, 单位：秒
} NET_IN_SHUTDOWN_PAD;

typedef struct tagNET_OUT_SHUTDOWN_PAD
{
    DWORD               dwSize;                  // 用户使用该结构体时，dwSize 需赋值为 sizeof(NET_OUT_SHUTDOWN_PAD)
} NET_OUT_SHUTDOWN_PAD;

//////////////////////////////////////////////异步纯透传结构体定义结束////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////设备网卡信息结构体定义开始 ////////////////////////////////////////////////////////////////////////////////////////////

typedef struct tagNET_DHDEV_ETHERNET_INFO
{
    DWORD               dwSize;                                 // 用户使用该结构体时，dwSize 需赋值为 sizeof(NET_DHDEV_ETHERNET_INFO)
    int                 nEtherNetNum;                           // 以太网口数
    DH_ETHERNET_EX      stuEtherNet[DH_MAX_ETHERNET_NUM_EX];    // 以太网口
} NET_DHDEV_ETHERNET_INFO;

//////////////////////////////////////////////设备网卡信息结构体定义结束////////////////////////////////////////////////////////////////////////////////////////////


//获取HCDZ采集信息,输入参数
typedef struct tagNET_IN_HCDZ_LIST_INFO 
{
    DWORD                           dwSize;							//  结构体大小, 调用者必须初始化该字段
	UINT							nIndexNum;					   //数组szindex有效数量
    UINT                            szIndex[DH_COMMON_STRING_64]; //一个数组,index 值与通道下标对应
}NET_IN_HCDZ_LIST_INFO;

// HCDZ采集信息，检测模块采集信息
typedef struct tagNET_HCDZ_INFO 
{
    UINT            nChannelID;								// 通道号(从0开始)
    UINT            nAIMode;								// AI测量数据模式设置  0 表示输入数据0-10000对应0-100%输入 1 表示4-20mA测量方式，输入数据0-10000对应4-20mA(20%-100%AI量程)
	UINT            nAIO;									// 检测模块模拟输入通道量程 20表示20mA 5表示5V 10表示10V
	UINT			nAnalogInputNum;						// 有效的模拟量输入数量
    UINT            arrAnalogInput[DH_COMMON_STRING_8];     // 是一个数组,检测模块模拟量输入寄存器值 无符号数0-10000对应0-满量程；实际值=DATA/10000*量程AI0，单位mA或V 
	UINT			nDINum;						            // 有效的模模块开关量输入数量
    UINT            arrDI[DH_COMMON_STRING_4];              // 检测模块开关量输入值，是一个数组，0为关，1为开
	UINT			nDONum;						            // 有效的模块开关量输出数量
    UINT            arrDO[DH_COMMON_STRING_4];              // 检测模块开关量输出值，是一个数组，0为关，1为开
}NET_HCDZ_INFO;

// 获取HCDZ采集信息,输出参数
typedef struct tagNET_OUT_HCDZ_LIST_INFO 
{
    DWORD                       dwSize;                             // 结构体大小, 调用者必须初始化该字段
	UINT				        nValidNum;						    // 数组stuInfo的有效个数
    NET_HCDZ_INFO				stuInfo[DH_COMMON_STRING_64];       // HCDZ采集信息
}NET_OUT_HCDZ_LIST_INFO;

typedef struct tagNET_IN_HCDZ_CAPS 
{
    DWORD                           dwSize;                          // 结构体大小, 调用者必须初始化该字段
}NET_IN_HCDZ_CAPS;

// 获取HCDZ(惠测电子)能力结构体
typedef struct tagCFG_HCDZ_CAPS
{
	DWORD                               dwSize;                                 // 结构体大小, 调用者必须初始化该字段
	char								szModelID[DH_COMMON_STRING_32];		    // 设备型号
	unsigned int						nVersion;								// 版本
	unsigned int						nAnalogsNum;							// 检测模块模拟量输入个数
	unsigned int						nDINum;									// 检测模块开关量输入个数
	unsigned int						nDONum;									// 检测模块开关量输出个数
}NET_OUT_HCDZ_CAPS;

// 获取电梯状态(HADT山东金鲁班宏安电梯),输入参数
typedef struct tagNET_IN_HADT_STATUS
{
    DWORD                               dwSize;                                 // 结构体大小, 调用者必须初始化该字段
}NET_IN_HADT_STATUS;

// 获取电梯状态(HADT山东金鲁班宏安电梯),输出参数
typedef struct tagNET_OUT_HADT_STATUS
{
    DWORD                               dwSize;                                 // 结构体大小, 调用者必须初始化该字段
    int                                 nLevelSignal1;                          // 楼层信号值，用于获取楼层的个位数信息，范围(0~37)由客户获取值后自行解析
    int                                 nLevelSignal2;                          // 楼层信号值，用于获取楼层的十位数信息，范围(0~37)由客户获取值后自行解析
    int                                 nLevelSignal3;                          // 楼层信号值，用于获取楼层的百位数信息，范围(0~37)由客户获取值后自行解析 
    DWORD                               dwliftStatus;                           // 电梯状态信息，每一位代表一种状态
                                                                                // bit0: 地震；该位置1表示地震，置0表示没有地震
                                                                                // bit1: 自救；该位置1表示自救，置0表示没有自救
                                                                                // bit2: 满载；该位置1且bit3和bit12置0表示满载，其它表示无效
                                                                                // bit3: 超载；该位置1且bit2和bit12置0表示超载，其它表示无效
                                                                                // bit4: 消防；该位置1表示消防，置0表示没有消防
                                                                                // bit5: 检修；该位置1表示检修，置0表示没有检修
                                                                                // bit6: 下行；该位置1且bit7置0下行，其它表示无效
                                                                                // bit7: 上行；该位置1且bit6置0表示上行，其它表示无效
                                                                                // bit8: 语音报站；该位置1表示有语音报站，置0表示没有语音报站
                                                                                // bit12: 空载；该位置1且bit2和bit3置0表示空载，其它表示无效
                                                                                // bit13: 停止/运行；该位置1表示运行，置0表示停止
                                                                                // bit14: 关门；该位置1且bit15置0表示关门，其它表示无效
                                                                                // bit15: 开门；该位置1且bit14置0表示开门，其它表示无效
}NET_OUT_HADT_STATUS;

//报警输出控制接口CLIENT_SetAlarmOut，输入参数
typedef struct tagNET_IN_SET_ALARMOUT
{
    DWORD                               dwSize;                                 // 结构体大小，需要赋值
    int                                 nChannel;                               // 通道号，从0开始
    int                                 nTime;                                  // time > 0 时, time生效。单位:秒
    int                                 nLevel;                                 // time = 0 时, level生效。time与level都为0时，表示停止
}NET_IN_SET_ALARMOUT;

//报警输出控制接口CLIENT_SetAlarmOut，输出参数
typedef struct tagNET_OUT_SET_ALARMOUT
{   
    DWORD                               dwSize;                                 // 结构体大小,需要赋值
}NET_OUT_SET_ALARMOUT;

// 录像类型
typedef enum tagEM_NET_LINK_RECORD_EVENT
{
    EM_NET_LINK_RECORD_UNKNOWN,                         // 未知
    EM_NET_LINK_RECORD_ALARM,                           // Alarm
} EM_NET_LINK_RECORD_EVENT;

//CLIENT_StartLinkRecord输入参数
typedef struct tagNET_IN_LINK_RECORD_CTRL
{
    DWORD                       dwSize;                 // 该结构体大小
    unsigned int                nChannel;               // 通道号
    unsigned int                nLength;                // 录像时长
    EM_NET_LINK_RECORD_EVENT    emType;                 // 录像类型"Alarm"-报警录像，当前仅支持这种录像
} NET_IN_LINK_RECORD_CTRL;

//CLIENT_StartLinkRecord输出参数
typedef struct tagNET_OUT_LINK_RECORD_CTRL
{
    DWORD                       dwSize;                 // 该结构体大小
} NET_OUT_LINK_RECORD_CTRL;

// CLIENT_SetDeviceUkey输入参数
typedef struct tagNET_IN_SET_UEKY
{
    DWORD                       dwSize;                 // 该结构体大小
    char                        szUkey[128];             // Ukey号
}NET_IN_SET_UEKY;

// CLIENT_SetDeviceUkey 输出参数
typedef struct tagNET_OUT_SET_UEKY
{
    DWORD                       dwSize;                 // 该结构体大小
}NET_OUT_SET_UEKY;

/******************************************************************************
功能描述	:	下载录像文件--扩展,可加载码流转换库
输入参数	:	
    lLoginID:       登录接口返回的句柄
    lpRecordFile:   查询录像接口返回的录像信息
    sSavedFileName: 保存录像文件名,支持全路径
    cbDownLoadPos:  下载进度回调函数(回调下载进度,下载结果)
    dwUserData:     下载进度回调对应用户数据
    fDownLoadDataCallBack: 录像数据回调函数(回调形式暂不支持转换PS流)
    dwDataUser:     录像数据回调对应用户数据
    scType:         码流转换类型,0-DAV码流(默认); 1-PS流
    pReserved:      保留字段,后续扩展
输出参数	：	N/A
返 回 值	：	LLONG 下载录像句柄
其他说明	：	特殊接口,SDK默认不支持转PS流,需定制SDK
******************************************************************************/
CLIENT_NET_API LLONG CALL_METHOD CLIENT_DownloadByRecordFileEx2(LLONG lLoginID, LPNET_RECORDFILE_INFO lpRecordFile, char *sSavedFileName, 
                                                    fDownLoadPosCallBack cbDownLoadPos, LDWORD dwUserData, 
                                                    fDataCallBack fDownLoadDataCallBack, LDWORD dwDataUser, 
                                                    int scType = 0, void* pReserved = NULL);

/******************************************************************************
功能描述	:	通过时间下载录像--扩展,可加载码流转换库
输入参数	:	
    lLoginID:       登录接口返回的句柄
    nChannelId:     视频通道号,从0开始
    nRecordFileType:录像类型0 所有录像文件
                            1 外部报警 
                            2 动态检测报警 
                            3 所有报警 
                            4 卡号查询  
                            5 组合条件查询 
                            6 录像位置与偏移量长度 
                            8 按卡号查询图片(目前仅HB-U和NVS特殊型号的设备支持) 
                            9 查询图片(目前仅HB-U和NVS特殊型号的设备支持)  
                            10 按字段查询 
                            15 返回网络数据结构(金桥网吧) 
                            16 查询所有透明串数据录像文件 
    tmStart:        开始时间 
    tmEnd:          结束时间 
    sSavedFileName: 保存录像文件名,支持全路径
    cbTimeDownLoadPos: 下载进度回调函数(回调下载进度,下载结果)
    dwUserData:     下载进度回调对应用户数据
    fDownLoadDataCallBack: 录像数据回调函数(回调形式暂不支持转换PS流)
    dwDataUser:     录像数据回调对应用户数据
    scType:         码流转换类型,0-DAV码流(默认); 1-PS流,3-MP4
    pReserved:      保留参数,后续扩展
输出参数	：	N/A
返 回 值	：	LLONG 下载录像句柄
其他说明	：	特殊接口,SDK默认不支持转PS流,需定制SDK
******************************************************************************/
CLIENT_NET_API LLONG CALL_METHOD CLIENT_DownloadByTimeEx2(LLONG lLoginID, int nChannelId, int nRecordFileType, 
                                                    LPNET_TIME tmStart, LPNET_TIME tmEnd, char *sSavedFileName, 
                                                    fTimeDownLoadPosCallBack cbTimeDownLoadPos, LDWORD dwUserData, 
                                                    fDataCallBack fDownLoadDataCallBack, LDWORD dwDataUser, 
                                                    int scType = 0, void* pReserved = NULL);

/******************************************************************************
功能描述	:	透传扩展接口,按透传类型走对应透传方式接口，目前支持F6纯透传, 同时兼容CLIENT_TransmitInfoForWeb接口
参数定义	:	
    lLoginID:       登录接口返回的句柄
    pInParam:       透传扩展接口输入参数
    pOutParam       透传扩展接口输出参数
    nWaittime       接口超时时间

返 回 值	：	BOOL  TRUE :成功; FALSE :失败
******************************************************************************/
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_TransmitInfoForWebEx(LLONG lLoginID, NET_IN_TRANSMIT_INFO* pInParam, 
                                                             NET_OUT_TRANSMIT_INFO* pOutParam, int nWaittime = 3000);


/******************************************************************************
功能描述	:	 异步纯透传订阅接口
参数定义	:	
    lLoginID:       登录接口返回的句柄
    pInParam:       异步纯透传接口输入参数
    pOutParam       异步纯透传接口输出参数
    nWaittime       接口超时时间

返 回 值	：	    LLONG 异步纯透传句柄
******************************************************************************/
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachTransmitInfo(LLONG lLoginID, const NET_IN_ATTACH_TRANSMIT_INFO* pInParam, NET_OUT_ATTACH_TRANSMIT_INFO* pOutParam, int nWaitTime);

 

/******************************************************************************
功能描述	:	 异步纯透传取消订阅接口
参数定义	:	
    lAttachHandle:  异步纯透传句柄，即CLIENT_AttachTransmitInfo接口的返回值
    pInParam:       异步纯透传取消订阅接口输入参数
    pOutParam       异步纯透传取消订阅接口输出参数
    nWaittime       接口超时时间

返 回 值	：		BOOL  TRUE :成功; FALSE :失败
******************************************************************************/
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_DetachTransmitInfo(LLONG lAttachHandle, const NET_IN_DETACH_TRANSMIT_INFO* pInParam, NET_OUT_DETACH_TRANSMIT_INFO* pOutParam, int nWaitTime);


/******************************************************************************
功能描述	:	 设备特殊控制接口
参数定义	:	
    lLoginID:                       登录接口返回的句柄
    EM_DEV_SPECIAL_CTRL_TYPE:       特殊控制类型
    pInParam:                       设备特殊控制接口输入参数
    pOutParam                       设备特殊控制接口输出参数
    nWaittime                       接口超时时间

返 回 值	：		BOOL  TRUE :成功; FALSE :失败
******************************************************************************/
CLIENT_NET_API  BOOL CALL_METHOD CLIENT_DevSpecialCtrl(LLONG lLoginID, EM_DEV_SPECIAL_CTRL_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime = 3000);


/******************************************************************************
功能描述	:	 获取设备网卡信息接口
参数定义	:	
    lLoginID:                       登录接口返回的句柄
    pstOutParam                     获取设备网卡信息接口的输出参数
    nWaittime                       接口超时时间

返 回 值	：		BOOL  TRUE :成功; FALSE :失败
******************************************************************************/
CLIENT_NET_API  BOOL CALL_METHOD CLIENT_QueryEtherNetInfo(LLONG lLoginID, NET_DHDEV_ETHERNET_INFO* pstuOutParam, int nWaitTime = 3000);

//////上海BUS//////

// 串口数据交互接口,异步获取数据
CLIENT_NET_API LLONG CALL_METHOD CLIENT_ExChangeData(LLONG lLoginId, NET_IN_EXCHANGEDATA* pInParam, NET_OUT_EXCHANGEDATA* pOutParam, int nWaittime = 5000);

// 监听CAN总线数据
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachCAN(LLONG lLoginID, const NET_IN_ATTACH_CAN* pstInParam, NET_OUT_ATTACH_CAN* pstOutParam, int nWaitTime = 3000);

// 取消监听CAN总线数据，lAttachHandle是CLIENT_AttachCAN返回值
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachCAN(LLONG lAttachHandle);

// 发送CAN总线数据
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SendCAN(LLONG lLoginID, const NET_IN_SEND_CAN* pstInParam, NET_OUT_SEND_CAN* pstOutParam, int nWaitTime = 3000);

// 监听透明串口数据
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachDevComm(LLONG lLoginID, const NET_IN_ATTACH_DEVCOMM* pstInParam, NET_OUT_ATTACH_DEVCOMM* pstOutParam, int nWaitTime = 3000);

// 取消监听透明串口数据，lAttachHandle是CLIENT_AttachDevComm返回值
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachDevComm(LLONG lAttachHandle);

// 上海巴士设备控制接口，包括控制PAD关机和重启等
CLIENT_NET_API BOOL CALL_METHOD CLIENT_ControlSpecialDevice(LLONG lLoginID, NET_SPECIAL_CTRL_TYPE emType, void* pInBuf, void* pOutBuf = NULL, int nWaitTime = NET_INTERFACE_DEFAULT_TIMEOUT);

//获取HCDZ采集信息
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_GetHCDZInfo(LLONG lLoginID, const NET_IN_HCDZ_LIST_INFO* pInParam, NET_OUT_HCDZ_LIST_INFO* pOutParam, int nWaitTime = 3000);

//获取HCDZ能力集
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_GetHCDZCaps(LLONG lLoginID, const NET_IN_HCDZ_CAPS* pInParam, NET_OUT_HCDZ_CAPS* pOutParam, int nWaitTime = 3000);


// 设置云台持续性控制命令发送间隔，该设置对当前所有登录的云台设备都生效（单位ms，间隔时间需大于100ms，否则不生效）
CLIENT_NET_API void CALL_METHOD CLIENT_PTZCmdSendIntervalTime(DWORD dwIntervalTime);

/**********************************************************************************
功能描述:获取HADT(山东金鲁班宏安电梯)运行状态
参数定义:
    lLoginID:登录接口返回的句柄
    pInBuf  :输入参数,需初始化dwSize
    pOutBuf :输出参数,需初始化dwSize
    nWaitTime :接口超时时间
返 回 值:	BOOL  TRUE :成功; FALSE :失败
**********************************************************************************/
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetHADTStatus(LLONG lLoginID, const NET_IN_HADT_STATUS* pInBuf, NET_OUT_HADT_STATUS* pOutBuf,int nWaitTime = 3000);

/**********************************************************************************
功能描述:控制报警输出（车载定制）
参数定义:
    lLoginID:登录接口返回的句柄
    pInBuf  :输入参数,需初始化dwSize
    pOutBuf :输出参数,需初始化dwSize
    nWaitTime :接口超时时间
返 回 值:	BOOL  TRUE :成功; FALSE :失败
**********************************************************************************/
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetAlarmOut(LLONG lLoginID, const NET_IN_SET_ALARMOUT* pInBuf, NET_OUT_SET_ALARMOUT* pOutBuf,int nWaitTime);

//开启EVS定时录像
CLIENT_NET_API BOOL CALL_METHOD CLIENT_StartLinkRecord(LLONG lLoginID, const NET_IN_LINK_RECORD_CTRL *pstIn, NET_OUT_LINK_RECORD_CTRL *pstOut, int nWaitTime);

// 北京公交定制接口，传入Ukey值
/**********************************************************************************
功能描述:设备此次登陆的Ukey值
参数定义:
    lLoginID:登录接口返回的句柄
    pInBuf  :输入参数,需初始化dwSize
    pOutBuf :输出参数,需初始化dwSize
    nWaitTime :接口超时时间
返 回 值:	BOOL  TRUE :成功; FALSE :失败
**********************************************************************************/
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetDeviceUkey(LLONG lLoginID, const NET_IN_SET_UEKY *pInBuf, NET_OUT_SET_UEKY *pOutBuf, int nWaitTime);

typedef struct tagNET_IN_NETACCESS
{
	DWORD		dwSize;									// 结构体大小
	char		szMac[DH_MACADDR_LEN];					// 设备mac地址
	char		szSecurity[MAX_SECURITY_CODE_LEN];		// 安全码
	BYTE		byInitStaus;							// 设备初始化状态：搜索设备接口(CLIENT_SearchDevices、CLIENT_StartSearchDevices的回调函数、CLIENT_SearchDevicesByIPs)返回字段byInitStatus的值
	BYTE		byReserved[3];							// 保留字段
}NET_IN_NETACCESS;
typedef struct tagNET_OUT_NETACCESS
{
	DWORD		dwSize;					// 结构体大小
}NET_OUT_NETACCESS;
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetNetAccess(const NET_IN_NETACCESS* pNetAccessIn, NET_OUT_NETACCESS* pNetAccessOut, DWORD dwWaitTime, char* szLocalIp);

// 对应CLIENT_StartSearchCustomDevices接口
// 搜索OEM设备类型枚举
typedef enum tagEM_SEARCH_OEM_DEVICE_TYPE
{
	EM_TYPE_JIANGSU_CHUANGTONG = 0,    // 江苏创通OEM设备类型
	EM_TYPE_MAX,					   // 最大枚举值
}EM_SEARCH_OEM_DEVICE_TYPE;

// OEM设备信息
typedef struct tagCUSTOM_DEVICE_NETINFO
{
	char                szMac[DH_MACADDR_LEN];                  // MAC地址,如00:40:9D:31:A9:0A
	char                szIP[DH_MAX_IPADDR_EX_LEN];				// IP地址,如10.0.0.231
	char                szDevName[DH_MACHINE_NAME_NUM];         // 设备名称,固定为Wireless Transmission Device
	BYTE				byReserved[1024];						// 保留字节
}CUSTOM_DEVICE_NETINFO;

// 异步搜索OEM设备回调（pCustomDevNetInf内存由SDK内部申请释放）
typedef void (CALLBACK *fSearchCustomDevicesCB)(CUSTOM_DEVICE_NETINFO *pCustomDevNetInfo, void* pUserData);

// CLIENT_StartSearchCustomDevices接口的输入参数
typedef struct tagNET_IN_SEARCH_PARAM 
{
	DWORD							dwSize;                  // 结构体大小
	fSearchCustomDevicesCB			cbFunc;			         // 搜索OEM设备回调函数
	void*							pUserData;               // 用户传入的自定义数据
	char*							szLocalIp;				 // 本地IP
	EM_SEARCH_OEM_DEVICE_TYPE       emSearchOemDeviceType;   //	搜索OEM设备类型
}NET_IN_SEARCH_PARAM;

// CLIENT_StartSearchCustomDevices的输出参数
typedef struct tagNET_OUT_SEARCH_PARAM
{
	DWORD		dwSize;
}NET_OUT_SEARCH_PARAM;

// 异步组播搜索OEM设备, (pInParam, pOutParam内存由用户申请释放),不支持多线程调用,配件产品线需求
CLIENT_NET_API LLONG CALL_METHOD CLIENT_StartSearchCustomDevices(const NET_IN_SEARCH_PARAM *pInParam, NET_OUT_SEARCH_PARAM *pOutParam); 
// 停止组播搜索OEM设备
CLIENT_NET_API BOOL CALL_METHOD CLIENT_StopSearchCustomDevices(LLONG lSearchHandle);

// 设备登录策略入参
typedef struct tagNET_IN_LOGIN_POLICY_PARAM
{
	DWORD               dwSize;
	int		            nDevicePort;							// 设备端口号
	char		        *szDeviceIp;			                // 设备ip地址    
	char		        *szUserName;		                    // 用户名
	char 		        *szPassword;		                    // 用户密码

	EM_LOGIN_SPAC_CAP_TYPE 		emSpecCap;				        // 登陆类型, 目前仅支持 TCP / Mobile / P2P 登录
	void	            *pCapParam; 							// 登陆附带参数, 具体类型与emSpeCap相关

	int                 nLoginPolicyFlag;                       // 登录策略标志位
	// bit0 == 1 快速登录: 设备信息 序列号/报警输入/输出参数无效 

	int                 nPlayPolicyFlag;                        // 实时预览策略标志位
	// bit0 == 1 不支持画中画

	int                 nPlayBackPolicyFlag;					// 录像回放和录像查询策略标志位
	// bit0 == 1 不查询画中画能力

}NET_IN_LOGIN_POLICY_PARAM;

// 设备登录策略出参
typedef struct tagNET_OUT_LOGIN_POLICY_PARAM
{
	DWORD               dwSize;
	NET_DEVICEINFO_Ex   stuDeviceInfo;                          // 设备信息
}NET_OUT_LOGIN_POLICY_PARAM;


// 登录扩展接口, 支持策略
CLIENT_NET_API LLONG CALL_METHOD CLIENT_LoginWithPolicy(const NET_IN_LOGIN_POLICY_PARAM* pstInParam, NET_OUT_LOGIN_POLICY_PARAM* pstOutParam, int nWaitTime);

// CLIENT_TriggerAutoInspection 接口入参
typedef struct tagNET_IN_TRIGGER_AUTO_INSPECTION
{
	DWORD dwSize;
}NET_IN_TRIGGER_AUTO_INSPECTION;

// CLIENT_TriggerAutoInspection 接口出参
typedef struct tagNET_OUT_TRIGGER_AUTO_INSPECTON
{
	DWORD dwSize;
}NET_OUT_TRIGGER_AUTO_INSPECTON;

// 触发设备自检（楼宇产品线专用需求）
CLIENT_NET_API BOOL CALL_METHOD CLIENT_TriggerAutoInspection(LLONG lLoginID, const NET_IN_TRIGGER_AUTO_INSPECTION* pstInParam, NET_OUT_TRIGGER_AUTO_INSPECTON* pstOutParam, int nWaitTime);

// CLIENT_GetLicenseAssistInfo 接口入参
typedef struct tagNET_IN_GET_LICENSE_INFO
{
	DWORD dwSize;								// 赋值为结构体大小
}NET_IN_GET_LICENSE_INFO;

// 需要被License限制的库信息
typedef struct tagNET_RESTRICTED_LIB_INFO
{
	char szId[40];								// 被限制库Id
	char szVersion[32];							// 被限制库的版本
	char szKey1[128];							// 所需要的特定信息1，具体内容由限制库确定
	char szKey2[128];							// 所需要的特定信息2，具体内容由限制库确定
	char szKey3[128];							// 所需要的特定信息3，具体内容由限制库确定
	char szKey4[128];							// 所需要的特定信息4，具体内容由限制库确定
	char szReserved[1024];						// 保留字段
}NET_RESTRICTED_LIB_INFO;


// CLIENT_GetLicenseAssistInfo 接口出参
typedef struct tagNET_OUT_GET_LICENSE_INFO
{
	DWORD dwSize;								// 赋值为结构体大小
	char  szSeriesNum[32];						// 设备序列号
	char  szMac[8][32];							// 设备Mac 地址
	int   nMacRet;								// 返回的Mac地址数量
	char  szBindInfo[256];						// 绑定信息
	char  szAppVersion[32];						// 应用程序版本
	char  szAppVerificationCode[512];			// 应用程序校验信息	
	char  szLicenseLibVsersion[32];				// License 管理库版本信息
	NET_RESTRICTED_LIB_INFO stuLibInfo[8];		// 需要被License限制的库信息
	int	  nLibInfoRet;							// 返回的stuLibInfo结构体数量
}NET_OUT_GET_LICENSE_INFO;

// 获取制作License的辅助信息
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetLicenseAssistInfo(LLONG lLoginID, const NET_IN_GET_LICENSE_INFO* pstInParam, NET_OUT_GET_LICENSE_INFO* pstOutParam, int nWaitTime);



// 制作Licenced的厂家入参
typedef struct tagNET_IN_GETVENDOR
{
	DWORD				dwSize;						// 此结构体大小
}NET_IN_GETVENDOR;

// Licence的对应信息
typedef struct tagNET_VENDOR_INFO
{
	char				szVendorId[32];				// 第三方厂商名称id
	int					nClassNum;					// 厂商算法个数
	char				szClass[32][8];				// 第三方厂商算法大类
	BYTE				bReserved[512];				// 预留字节
}NET_VENDOR_INFO;

// 制作Licence的厂家出参
typedef struct tagNET_OUT_GETVENDOR
{
	DWORD				dwSize;						// 此结构体大小
	int					nVendorNum;					// 信息个数
	NET_VENDOR_INFO		stuVendorInfo[8];			// 信息，最大为8组
}NET_OUT_GETVENDOR;


// 第三方厂商制作License的辅助信息入参
typedef struct tagNET_IN_GETTHIRDASSISTED_INFO
{
	DWORD				dwSize;						// 此结构体大小
	NET_VENDOR_INFO		stuVendorInfo;				// 第三方厂商制作license的辅助信息
}NET_IN_GETTHIRDASSISTED_INFO;

// 需要制作授权的第三方的采用信息
typedef struct tagNET_DEVICE_INFO
{
	char				szSN[32];					// 序列号
	int					nMacNum;					// MAC地址个数
	char				szMac[8][32];				// MAC地址，冒号+大写
	char				szAppVersion[16];			// 应用程序版本
	BYTE				bReserved[512];				// 预留字节
}NET_DEVICE_INFO;

// 需要制作授权的第三方的采用信息
typedef struct tagNET_THIRD_INFO
{
	char				szVendor[32];				// 第三厂商名称
	int					nClassNum;					// 厂商算法个数
	char				szClass[32][8];				// 第三方厂商算法大类
	char				szData[4096];				// 集成的第三方库采集的信息。为防止有特殊字符需要进行base64编码。针对不同的三方公司其对应的data内容也不相同， 
	BYTE				bReserved[4392];			// 预留字节
}NET_THIRD_INFO;

// 第三方厂商制作License的辅助信息出参
typedef struct tagNET_OUT_GETTHIRDASSISTED_INFO
{
	DWORD				dwSize;						// 此结构体大小
	NET_DEVICE_INFO		stuDeviceInfo;				// 设备相关通用信息
	NET_THIRD_INFO		stuThirdInfo;				// 需要制作授权的第三方的采用信息
}NET_OUT_GETTHIRDASSISTED_INFO;

// 导入第三方制作的license的入参
typedef struct tagNET_IN_SETTHIRD_LICENSE
{
	DWORD				dwSize;						// 此结构体大小
	char				szVendorId[32];				// 第三方厂家名称ID
	int					nClassNum;					// 厂商算法个数
	char				szClass[32][8];				// 第三方厂商算法大类
	char				szLicense[8192];			// 第三方license数据 base64编码，具体数据格式由第三方厂家定义
}NET_IN_SETTHIRD_LICENSE;

// 导入第三方制作的license的出参
typedef struct tagNET_OUT_SETTHIRD_LICENE
{
	DWORD				dwSize;						// 此结构体大小
}NET_OUT_SETTHIRD_LICENCE;

typedef enum tagEM_LICENCE_OPERATE_TYPE
{
	NET_EM_LICENCE_OPERATE_UNKNOWN = -1,				// 未知
	NET_EM_LICENCE_OPERATE_GETVENDOR,					// 获取用于需要制作License的厂家 pInParam = NET_IN_GETVENDOR, pOutParam = NET_OUT_GETVENDOR
	NET_EM_LICENCE_OPERATE_GETTHIRDINFO,				// 获取用于第三方厂商制作License的辅助信息   pInParam = NET_IN_GETTHIRDASSISTED_INFO, pOutParam = NET_OUT_GETTHIRDASSISTED_INFO
	NET_EM_LICENCE_OPERATE_SETTHIRDLICENCE,				// 导入第三方制作的License pInParam = NET_IN_SETTHIRDLICENCE, pOutParam = NET_OUT_SETTHIRDLICENCE
}NET_EM_LICENCE_OPERATE_TYPE;


// License证书信息的操作
CLIENT_NET_API BOOL CALL_METHOD CLIENT_LicenseOperate(LLONG lLoginID, NET_EM_LICENCE_OPERATE_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime);

// CLIENT_SetLicense 接口入参
typedef struct tagNET_IN_SET_LICENSE
{
	DWORD dwSize;								// 赋值为结构体大小
	char  szLicenseInfo[8192];					// License 数据
	char  szSignature[512];						// License 数据的数字签名
}NET_IN_SET_LICENSE;

// CLIENT_SetLicense 接口出参
typedef struct tagNET_OUT_SET_LICENSE
{
	DWORD dwSize;								// 赋值为结构体大小
}NET_OUT_SET_LICENSE;

// 设置License
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetLicense(LLONG lLoginID, const NET_IN_SET_LICENSE* pstInParam, NET_OUT_SET_LICENSE* pstOutParam, int nWaitTime);

// 获取录像加密密码入参
typedef struct tagNET_IN_GET_RECORD_FILE_PASSWORD
{
	DWORD		dwSize;									// 结构体大小
	char		szFileName[DH_COMMON_STRING_256];		// 录像文件名称
}NET_IN_GET_RECORD_FILE_PASSWORD;

// 获取录像加密密码出参
typedef struct tagNET_OUT_GET_RECORD_FILE_PASSWORD
{
	DWORD		dwSize;											// 结构体大小
	char		szPassword[MAX_RECORD_FILE_PASSWORD_LEN + 1];	// 密码
	BYTE		byReserved[3];									// 保留字节,为了字节对齐
}NET_OUT_GET_RECORD_FILE_PASSWORD;

// 获取录像加密密码
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetRecordFilePassword(LLONG lLoginID, const NET_IN_GET_RECORD_FILE_PASSWORD* pInParam, NET_OUT_GET_RECORD_FILE_PASSWORD* pOutParam, int nWaitTime);

// 设置子链接网络参数
typedef struct tagNET_SUBCONNECT_NETPARAM
{
	DWORD               dwSize;                                 // 结构体大小
	UINT				nNetPort;								// 网络映射端口号	
	char				szNetIP[DH_MAX_IPADDR_EX_LEN];			// 网络映射IP地址
} NET_SUBCONNECT_NETPARAM;

// 设置子连接网络参数, pSubConnectNetParam 资源由用户申请和释放
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetSubConnectNetworkParam(LLONG lLoginID, NET_SUBCONNECT_NETPARAM *pSubConnectNetParam);

// 获取设备状态入参
typedef struct tagNET_IN_UNIFIEDINFOCOLLECT_GET_DEVSTATUS
{
    DWORD               dwSize;                                 // 结构体大小
}NET_IN_UNIFIEDINFOCOLLECT_GET_DEVSTATUS;

// 供电类型
typedef enum tagNET_EM_POWER_TYPE
{
    NET_EM_POWER_TYPE_UNKNOWN = -1,                     // 未知              
    NET_EM_POWER_TYPE_POWERADAPTER,                     // 电源适配器
    NET_EM_POWER_TYPE_BATTERY,                          // 电池
    NET_EM_POWER_TYPE_BATTERY_AND_POWERADAPTER,         // 电池+电源适配器
}NET_EM_POWER_TYPE;

// 电源电池相关信息
typedef struct tagNET_DEVSTATUS_POWER_INFO
{
	UINT                nBatteryPercent;                        // 电池电量百分比,0~100
    NET_EM_POWER_TYPE   emPowerType;                            // 供电类型
}NET_DEVSTATUS_POWER_INFO;

// 有线网连接状态
typedef enum tagNET_EM_ETH_STATE
{
    NET_EM_ETH_UNKNOWN,                                         // 未知
    NET_EM_ETH_CONNECT,                                         // 连接
    NET_EM_ETH_DISCONNECT,                                      // 未连接
}NET_EM_ETH_STATE;

// 网络相关信息
typedef struct tagNET_DEVSTATUS_NET_INFO
{
    UINT                nWifiIntensity;                         // wifi信号强度等级，0~5，0表示没有信号
    UINT                nWifiSignal;                            // wifi信号强度，单位dbm, 0~100,0表示没有信号
    UINT                nCellulSignal;                          // 2g/3g/4g信号强度,单位dbm. 0~100, 0表示没有信号
    UINT                nCellulIntensity;                       // 2g/3g/4g信号强度等级,0~5, 0表示没有信号
    NET_EM_ETH_STATE    emEthState;                             // 有线网连接状态
    UINT                n3Gflux;                                // 蜂窝网络实际使用流量，单位：MB
    UINT                n3GfluxByTime;                          // 网络实际使用时长，单位：分钟     
}NET_DEVSTATUS_NET_INFO;

// 主机防拆状态
typedef enum tagNET_EM_TAMPER_STATE
{
    NET_EM_TAMPER_UNKNOWN = -1,                             // 未知 
    NET_EM_TAMPER_NOALARM,                                  // 未报警
    NET_EM_TAMPER_ALARMING,                                 // 报警中
}NET_EM_TAMPER_STATE;

// 获取设备状态出参
typedef struct tagNET_OUT_UNIFIEDINFOCOLLECT_GET_DEVSTATUS
{
    DWORD                           dwSize;                         // 结构体大小
    NET_DEVSTATUS_POWER_INFO        stuPowerInfo;                   // 电源电池相关信息
    NET_DEVSTATUS_NET_INFO          stuNetInfo;                     // 网络相关信息
    char                            szVersion[DH_COMMON_STRING_32]; // 主机软件版本
    NET_EM_TAMPER_STATE             emTamperState;                  // 主机防拆状态
}NET_OUT_UNIFIEDINFOCOLLECT_GET_DEVSTATUS;

// 获取设备状态, DMSS专用接口, pInParam与pOutParam内存由用户申请释放
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetUnifiedStatus(LLONG lLoginID, NET_IN_UNIFIEDINFOCOLLECT_GET_DEVSTATUS* pInParam, NET_OUT_UNIFIEDINFOCOLLECT_GET_DEVSTATUS* pOutParam, int nWaitTime);


// CLIENT_RealPlayEx2 接口入参
typedef struct tagNET_IN_REALPLAY
{
	DWORD							dwSize;							// 结构体大小：赋值为结构体大小	
	int								nChannelID;						// 通道	
	DH_RealPlayType					rType;							// 类型
	BYTE							szReserved[4];					// 预留字段
	HWND							hWnd;							// 窗口句柄	
	fRealDataCallBackEx2			cbRealData;                     // 实时数据回调        
	fOriginalRealDataCallBack		pOriginalRealDataCallBack;		// 原始码流数据回调
	fEncryptRealDataCallBackEx		pEncryptRealDataCallBackEx;     // 加密码流数据回调	
	fRealPlayDisConnect				cbDisconnect;					// 断线回调
	fVKInfoCallBack					pVKInfoCallBack;				// VK信息回调
	LDWORD							dwUser;							// 用户参数		
} NET_IN_REALPLAY;

// CLIENT_RealPlayEx2 出参
typedef struct tagNET_OUT_REALPLAY
{
	DWORD							dwSize;							// 结构体大小：赋值为结构体大小
}NET_OUT_REALPLAY;


// 实时监视--扩展Ex2接口
CLIENT_NET_API LLONG CALL_METHOD CLIENT_RealPlayEx2(LLONG lLoginID, const NET_IN_REALPLAY* pInParam, NET_OUT_REALPLAY* pOutParam, DWORD	dwWaitTime);

// CLIENT_QueryUserRights 接口输入参数
typedef struct tagNET_IN_QUERYUSER_RIGHT
{
	DWORD               dwSize;						// 此结构体大小			
} NET_IN_QUERYUSER_RIGHT;

// CLIENT_QueryUserRights 接口输入参数
typedef struct tagNET_OUT_QUERYUSER_RIGHT
{
	DWORD               dwSize;						// 此结构体大小		
	DWORD               dwRightNum;                 // 权限信息
    OPR_RIGHT_NEW       rightList[DH_NEW_MAX_RIGHT_NUM];                      
    USER_INFO_NEW       userInfo;                   // 用户信息
    DWORD               dwFunctionMask;             // 掩码；0x00000001 - 支持用户复用，0x00000002 - 密码修改需要校验
} NET_OUT_QUERYUSER_RIGHT;

// APP用户操作优化接口
CLIENT_NET_API BOOL CALL_METHOD CLIENT_QueryUserRights(LLONG lLoginID, const NET_IN_QUERYUSER_RIGHT* pstInParam, NET_OUT_QUERYUSER_RIGHT* pstOutParam ,int waittime);

// CLIENT_GetDeviceAllInfo 输入结构体
typedef struct tagNET_IN_GET_DEVICE_AII_INFO
{
    DWORD		dwSize;						// 赋值为结构体大小
}NET_IN_GET_DEVICE_AII_INFO;

// 存储设备状态
typedef enum tagEM_STORAGE_DEVICE_STATUS
{
    EM_STORAGE_DEVICE_UNKNOWN,              // 未知
    EM_STORAGE_DEVICE_ERROR,                // 获取设备失败
    EM_STORAGE_DEVICE_INITIALIZING,         // 正在读取设备
    EM_STORAGE_DEVICE_SUCCESS,              // 获取设备成功
}EM_STORAGE_DEVICE_STATUS;

// 健康状态标识
typedef enum tagEM_STORAGE_HEALTH_TYPE
{
    EM_STORAGE_HEALTH_UNKNOWN = -1,         // 未知
    EM_STORAGE_HEALTH_UNSUPPORT,            // 设备不支持健康检测功能
    EM_STORAGE_HEALTH_SUPPORT_AND_SUCCESS,  // 支持健康检测功能且获取数据成功
    EM_STORAGE_HEALTH_SUPPORT_AND_FAIL,     // 支持健康检测功能但获取数据失败
}EM_STORAGE_HEALTH_TYPE;

// SD卡加锁状态
typedef enum tagEM_SD_LOCK_STATE
{
    EM_SD_LOCK_STATE_UNKNOWN = -1,          // 未知
    EM_SD_LOCK_STATE_NORMAL,                // 未进行过加锁的状态, 如出厂状态，或清除密码时状态
    EM_SD_LOCK_STATE_LOCKED,                // 加锁
    EM_SD_LOCK_STATE_UNLOCKED,              // 未加锁（加锁后解锁）
}EM_SD_LOCK_STATE;

// SD卡加密功能标识
typedef enum tagEM_SD_ENCRYPT_FLAG
{
    EM_SD_ENCRYPT_UNKNOWN = -1,                     // 未知
    EM_SD_ENCRYPT_UNSUPPORT,                        // 设备不支持SD卡加密功能
    EM_SD_ENCRYPT_SUPPORT_AND_GETDATA_SUCCESS,      // 支持SD卡加密功能且获取数据成功
    EM_SD_ENCRYPT_SUPPORT_AND_GETDATA_FAIL,         // 支持SD卡加密功能但获取数据失败
}EM_SD_ENCRYPT_FLAG;

// 分区类型
typedef enum tagEM_PARTITION_TYPE
{
    EM_PARTITION_UNKNOWN,               // 未知
    EM_PARTITION_READ_WIRTE,            // 读写
    EM_PARTITION_READ_ONLY,             // 只读
    EM_PARTITION_READ_GENERIC,          // 一般的
}EM_PARTITION_TYPE;

// 设备存储分区信息
typedef struct tagNET_STORAGE_PARTITION_INFO
{
    BOOL                            bError;                 // 分区是否异常
    EM_PARTITION_TYPE               emType;                 // 分区属性类型
    double                          dTotalBytes;            // 分区总空间，单位字节
    double                          dUsedBytes;             // 分区使用空间
    char                            szPath[128];            // 分区名字
    BYTE                            byReserved[128];        // 保留字节
}NET_STORAGE_PARTITION_INFO;

// 设备存储信息
typedef struct tagNET_DEVICE_STORAGE_INFO
{
    char                            szNmae[32];             // 设备名称
    BOOL                            bSupportHotPlug;        // 存储设备能否热插拔
    float                           fLifePercent;           // 寿命长度标识
    EM_SD_LOCK_STATE                emLockState;            // SD卡加锁状态
    EM_SD_ENCRYPT_FLAG              emSDEncryptFlag;        // SD卡加密功能标识
    EM_STORAGE_HEALTH_TYPE          emHealthType;           // 健康状态标识
    EM_STORAGE_DEVICE_STATUS        emState;                // 存储设备状态
    NET_STORAGE_PARTITION_INFO      stuPartitionInfo[12];   // 分区的具体信息
    int                             nPartition;             // 分区数量
    BYTE                            byReserved[516];        // 保留字节
}NET_DEVICE_STORAGE_INFO;

// CLIENT_GetDeviceAllInfo 输出结构体
typedef struct tagNET_OUT_GET_DEVICE_AII_INFO
{
    DWORD		                    dwSize;					// 赋值为结构体大小
    int                             nInfoCount;             // 信息的个数
    NET_DEVICE_STORAGE_INFO         stuStorageInfo[8];      // 设备存储信息
}NET_OUT_GET_DEVICE_AII_INFO;

// 获取IPC设备的存储信息
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDeviceAllInfo(LLONG lLoginID, NET_IN_GET_DEVICE_AII_INFO *pstInParam, NET_OUT_GET_DEVICE_AII_INFO *pstOutParam, int nWaitTime);

// CLIENT_SetPlayBackBufferThreshold 输入参数
typedef struct tagNET_IN_SET_PLAYBACK_BUFFER_THRESHOLD
{
	DWORD							dwSize;					// 结构体大小
	UINT							nUpperLimit;			// 上限，范围[0, 100), 百分比，0表示默认值
	UINT							nLowerLimit;			// 下限，范围[0, 100), 百分比，0表示默认值
}NET_IN_SET_PLAYBACK_BUFFER_THRESHOLD;

// CLIENT_SetPlayBackBufferThreshold 输出参数
typedef struct tagNET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD
{
	DWORD							dwSize;					// 结构体大小
}NET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD;


// 设置回放缓存区阈值
// lPlayBackHandle 为回放句柄
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetPlayBackBufferThreshold(LLONG lPlayBackHandle, NET_IN_SET_PLAYBACK_BUFFER_THRESHOLD* pstInParam, NET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD* pstOutParam);

// CLIENT_SetConsumeResult 输入结构体
typedef struct tagNET_IN_SET_CONSUME_RESULT
{
	DWORD				dwSize;				// 结构体大小
	int					nChannelID;			// 通道号
	char				szUserID[32];		// 用户ID
	UINT				nRemainAmount;		// 消费后余额，如果消费失败则是消费前余额，单位分。
	BOOL				bConsumeResult;		// 消费成功与否
	int					nErrorCode;			// 错误码 
											// 0x00:无错误;
											// 0x01:余额不足 
											// 0x02:已过就餐时间 
											// 0x03:已消费
											// 0x04:无权限

	UINT				nConsumptionAmount; // 平台固定消费金额，单位(分)
}NET_IN_SET_CONSUME_RESULT;

// CLIENT_SetConsumeResult 输出结构体
typedef struct tagNET_OUT_SET_CONSUME_RESULT
{
	DWORD				dwSize;				// 结构体大小
}NET_OUT_SET_CONSUME_RESULT;

// 设置消费结果（光大银行定制）
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetConsumeResult(LLONG lLoginID, const NET_IN_SET_CONSUME_RESULT* pInParam, NET_OUT_SET_CONSUME_RESULT* pOutParam, int nWaitTime);


// CLIENT_GetDeviceServiceType 输入结构体
typedef struct tagNET_IN_GET_DEVICE_SERVICE_TYPE
{
	DWORD							dwSize;					// 结构体大小
}NET_IN_GET_DEVICE_SERVICE_TYPE;

// 服务类型
typedef enum tagEM_DEVICE_SERVICE_TYPE
{
	EM_DEVICE_SERVICE_TYPE_UNKNOWN,							// 未知
	EM_DEVICE_SERVICE_TYPE_MAIN,							// 主服务
	EM_DEVICE_SERVICE_TYPE_AOL,								// Always on line 服务
}EM_DEVICE_SERVICE_TYPE;

// CLIENT_GetDeviceServiceType 输出结构体
typedef struct tagNET_OUT_GET_DEVICE_SERVICE_TYPE
{
	DWORD							dwSize;					// 结构体大小
	EM_DEVICE_SERVICE_TYPE			emServiceType;			// 服务类型
}NET_OUT_GET_DEVICE_SERVICE_TYPE;

// 获取设备端服务类型
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDeviceServiceType(LLONG lLoginID, const NET_IN_GET_DEVICE_SERVICE_TYPE* pInParam, NET_OUT_GET_DEVICE_SERVICE_TYPE* pOutParam, int nWaitTime);

// CLIENT_GetLoginAuthPatchInfo 输入结构体
typedef struct tagNET_IN_GET_LOGIN_AUTH_PATCH_INFO
{
	DWORD							dwSize;					// 结构体大小
}NET_IN_GET_LOGIN_AUTH_PATCH_INFO;


// CLIENT_GetLoginAuthPatchInfo 输出结构体
typedef struct tagNET_OUT_GET_LOGIN_AUTH_PATCH_INFO
{
	DWORD							dwSize;						// 结构体大小
	BOOL							bSupportHighLevelSecurity;	// 是否支持高等级安全登录
}NET_OUT_GET_LOGIN_AUTH_PATCH_INFO;

// 获取设备登录兼容补丁信息（定制，VTO设备使用）
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetLoginAuthPatchInfo(LLONG lLoginID, const NET_IN_GET_LOGIN_AUTH_PATCH_INFO* pInParam, NET_OUT_GET_LOGIN_AUTH_PATCH_INFO* pOutParam);

// 秘钥长度
typedef enum tagEM_SECURETRANSMIT_KEY_LENGTH
{
	EM_SECURETRANSMIT_AES_KEY_LENGTH_UNKNOWN = -1,				// 未知
	EM_SECURETRANSMIT_AES_KEY_LENGTH_DEFAULT,					// SDK 内部根据设备情况自行确定
	EM_SECURETRANSMIT_AES_KEY_LENGTH_128,						// AES 秘钥长度 128 bit，前提是设备支持
	EM_SECURETRANSMIT_AES_KEY_LENGTH_192,						// AES 秘钥长度 192 bit，前提是设备支持
	EM_SECURETRANSMIT_AES_KEY_LENGTH_256,						// AES 秘钥长度 256 bit，前提是设备支持
}EM_SECURETRANSMIT_KEY_LENGTH;

// CLIENT_SetSecureTransmitKeyLength 输入结构体
typedef struct tagNET_IN_SET_SECURETRANSMIT_KEY_LENGTH
{
	DWORD							dwSize;						// 结构体大小
	EM_SECURETRANSMIT_KEY_LENGTH	emLength;					// 秘钥长度
}NET_IN_SET_SECURETRANSMIT_KEY_LENGTH;


// CLIENT_SetSecureTransmitKeyLength 输出结构体
typedef struct tagNET_OUT_SET_SECURETRANSMIT_KEY_LENGTH
{
	DWORD							dwSize;						// 结构体大小
}NET_OUT_SET_SECURETRANSMIT_KEY_LENGTH;

// 设置秘钥长度，全局生效，CLIENT_Init 接口之后调用
// 在程序运行过程中，如果需要更新秘钥长度，需要登出设备，重新登录
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetSecureTransmitKeyLength(const NET_IN_SET_SECURETRANSMIT_KEY_LENGTH* pInParam, NET_OUT_SET_SECURETRANSMIT_KEY_LENGTH* pOutParam);

// 手机订阅全部推送信息
typedef struct tagNET_MOBILE_SUBSCRIBE_ALL_CFG_INFO
{
	DWORD							dwSize;							// 结构体大小
	int								nMaxMobileSubscribeNum;			// 用户分配最大接收查询配置消息个数
	int								nRetMobileSubscribeNum;			// 实际返回接收查询配置消息个数
	BYTE							byReserved[4];					// 字节对齐
	NET_MOBILE_PUSH_NOTIFICATION_GENERAL_INFO	*pstuMobileSubscribe;// 订阅配置	
}NET_MOBILE_SUBSCRIBE_ALL_CFG_INFO;

// 获取手机全部订阅推送信息
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetMobileSubscribeAllCfg(LLONG lLoginID, NET_MOBILE_SUBSCRIBE_ALL_CFG_INFO *pstuCfg, int *nError, int nWaitTime);

/************************************************************************/
/*                              调试日志                               */
/************************************************************************/

// 设置串口重定向入参
typedef struct tagNET_IN_DBGINFO_SET_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_IN_DBGINFO_SET_REDIR_LOCAL;

// 设置串口重定向出参
typedef struct tagNET_OUT_DBGINFO_SET_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_OUT_DBGINFO_SET_REDIR_LOCAL;

// 取消串口打印重定向到本地存储入参
typedef struct tagNET_IN_DBGINFO_CANCEL_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_IN_DBGINFO_CANCEL_REDIR_LOCAL;

// 取消串口打印重定向到本地存储出参
typedef struct tagNET_OUT_DBGINFO_CANCEL_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_OUT_DBGINFO_CANCEL_REDIR_LOCAL;

// 读取日志重定向的信息入参
typedef struct tagNET_IN_DBGINFO_GET_INFO
{
    DWORD               dwSize;
}NET_IN_DBGINFO_GET_INFO;

// 重定向状态
typedef enum tagEM_DBGINFO_REDIR_STATUS
{
    EM_DBGINFO_REDIR_STATUS_UNKNOWN,    // 未知
    EM_DBGINFO_REDIR_STATUS_NO,         // 未重定向
    EM_DBGINFO_REDIR_STATUS_LOCAL,      // 重定向到本地
    EM_DBGINFO_REDIR_STATUS_CALLBACK,   // 重定向到回调
}EM_DBGINFO_REDIR_STATUS;

// 文件信息
typedef struct tagNET_DBGINFO_FILEINFO
{
    char                szFilePath[128]; // 生成的文件路径
    unsigned int        nFileSize;       // 生成的文件大小,单位字节
    BYTE                byReserverd[260];// 保留
}NET_DBGINFO_FILEINFO;

// 读取日志重定向的信息出参
typedef struct tagNET_OUT_DBGINFO_GET_INFO
{
    DWORD               dwSize;
    EM_DBGINFO_REDIR_STATUS emStatus;    // 重定向状态
    NET_DBGINFO_FILEINFO stuFile[10];    // 文件信息
    int                  nRetFileCount;  // 返回的stuFile有效的个数
}NET_OUT_DBGINFO_GET_INFO;

// 获取采集串口日志设备能力集入参
typedef struct tagNET_IN_DBGINFO_GET_CAPS
{
    DWORD               dwSize;
}NET_IN_DBGINFO_GET_CAPS;

// 获取采集串口日志设备能力集出参
typedef struct tagNET_OUT_DBGINFO_GET_CAPS
{
    DWORD               dwSize;
    BOOL                bSupportRedir;        // 是否支持串口日志重定向，包含存文件和回调两种。
}NET_OUT_DBGINFO_GET_CAPS;

// 调试日志操作类型 CLIENT_OperateDebugInfo
typedef enum tagEM_DBGINFO_OP_TYPE
{
    EM_DBGINFO_OP_REDIR_SET_LOCAL,            // 设置串口打印重定向到本地存储 pInParam = NET_IN_DBGINFO_SET_REDIR_LOCAL, pOutParam = NET_OUT_DBGINFO_SET_REDIR_LOCAL
    EM_DBGINFO_OP_REDIR_CANCEL_LOCAL,         // 取消串口打印重定向到本地存储 pInParam = NET_IN_DBGINFO_CANCEL_REDIR_LOCAL, pOutParam = NET_OUT_DBGINFO_CANCEL_REDIR_LOCAL
    EM_DBGINFO_OP_GET_INFO,                   // 读取日志重定向的信息 pInParam = NET_IN_DBGINFO_GET_INFO, pOutParam = NET_OUT_DBGINFO_GET_INFO
    EM_DBGINFO_OP_GET_CAPS,                   // 获取采集串口日志设备能力集 pInParam = NET_IN_DBGINFO_GET_CAPS, pOutParam = NET_OUT_DBGINFO_GET_CAPS
}EM_DBGINFO_OP_TYPE;

// 调试日志回调函数
typedef void (CALLBACK *fDebugInfoCallBack)(LLONG lAttchHandle, BYTE *pBuffer, DWORD dwBufSize, LDWORD dwUser);

// 日志等级
typedef enum tagEM_DBGINFO_LEVEL
{
    EM_DBGINFO_LEVEL_NOPRINT,       // 无打印
    EM_DBGINFO_LEVEL_FATAL,         // 致命
    EM_DBGINFO_LEVEL_ERROR,         // 错误
    EM_DBGINFO_LEVEL_WARN,          // 警告
    EM_DBGINFO_LEVEL_INFO,          // 信息
    EM_DBGINFO_LEVEL_TRACE,         // 跟踪
    EM_DBGINFO_LEVEL_DEBUG,         // 调试
}EM_DBGINFO_LEVEL;

// 订阅日志回调入参
typedef struct tagNET_IN_ATTACH_DBGINFO
{
    DWORD               dwSize;
    EM_DBGINFO_LEVEL    emLevel;        // 日志等级
    fDebugInfoCallBack  pCallBack;      // 回调 
    LDWORD              dwUser;         // 用户数据
}NET_IN_ATTACH_DBGINFO;

// 订阅日志回调出参
typedef struct tagNET_OUT_ATTACH_DBGINFO
{
    DWORD               dwSize;    
}NET_OUT_ATTACH_DBGINFO;

//////////////////////////////// 调试日志 /////////////////////////////////
// 调试日志操作接口
CLIENT_NET_API BOOL CALL_METHOD CLIENT_OperateDebugInfo(LLONG lLoginID, EM_DBGINFO_OP_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime);

// 订阅调试日志回调
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachDebugInfo(LLONG lLoginID, const NET_IN_ATTACH_DBGINFO* pInParam, NET_OUT_ATTACH_DBGINFO* pOutParam, int nWaitTime);

// 退订调试日志回调
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachDebugInfo(LLONG lAttachHanle);

// CLIENT_SetInternalControlParam 入参
typedef struct tagNET_INTERNAL_CONTROL_PARAM
{
	DWORD							dwSize;										// 结构体大小
	UINT							nThreadSleepTime;							// 内部线程睡眠间隔，范围[10, 100]，unit:ms，默认10	
	UINT							nSemaphoreSleepTimePerLoop;					// 等待信号量时，内部线程睡眠间隔，范围[10, 100]，unit:ms，默认10
}NET_INTERNAL_CONTROL_PARAM;

// 设置内部控制参数（定制）
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetInternalControlParam(const NET_INTERNAL_CONTROL_PARAM *pInParam);

#ifdef __cplusplus
}
#endif



#endif // DHNETSDKEX_H



