/*
* Copyright (c) 2009, 浙江大华技术股份有限公司
* All rights reserved.
*
* 摘　要：SDK接口很多,定制或一些不常用的功能可以放入dhnetsdkEx.h,
*         对外提供 dhnetsdk.h,
*         定制项目额外提供 dhnetsdkEx.h
*/
////////////////////////////////////////////////////////////////////////
#ifndef DHNETSDKEX_H
#define DHNETSDKEX_H

#include "dhnetsdk.h"

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
 
///@brief 透传类型
 typedef enum   tagNET_TRANSMIT_INFO_TYPE
 {
    NET_TRANSMIT_INFO_TYPE_DEFAULT,                 // 默认类型，即CLIENT_TransmitInfoForWeb接口的兼容透传方式
    NET_TRANSMIT_INFO_TYPE_F6,                      // F6纯透传
 } NET_TRANSMIT_INFO_TYPE;

///@brief 透传加密类型
 typedef enum tagEM_TRANSMIT_ENCRYPT_TYPE
 {
	EM_TRANSMIT_ENCRYPT_TYPE_UNKNOWN = -1,			// 未知
	EM_TRANSMIT_ENCRYPT_TYPE_NORMAL,				// SDK内部自行确定是否加密，默认
	EM_TRANSMIT_ENCRYPT_TYPE_MULTISEC,				// 设备支持加密的场景下，走multiSec加密
	EM_TRANSMIT_ENCRYPT_TYPE_BINARYSEC,				// 设备支持加密的场景下，走binarySec加密，二进制部分不加密
 }EM_TRANSMIT_ENCRYPT_TYPE;

///@brief CLIENT_TransmitInfoForWebEx输入参数
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

///@brief CLIENT_TransmitInfoForWebEx输出参数
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
///@brief CLIENT_AttachTransmitInfo 上报信息回调
 typedef struct tagNET_CB_TRANSMIT_INFO
 {
     BYTE*              pBuffer;            // 数据缓冲地址，SDK内部申请空间
     DWORD              dwBufferSize;       // 数据缓冲总长度
     DWORD              dwJsonLen;          // Json数据长度
     DWORD              dwBinLen;           // 二进制数据长度
     BYTE               byReserved[512];    // 保留字节
 } NET_CB_TRANSMIT_INFO;

///@brief CLIENT_AttachTransmitInfo()回调函数原型，第一个参数lAttachHandle是CLIENT_AttachTransmitInfo返回值
 typedef int  (CALLBACK *AsyncTransmitInfoCallBack)(LLONG lAttachHandle, NET_CB_TRANSMIT_INFO* pTransmitInfo, LDWORD dwUser);

///@brief CLIENT_AttachTransmitInfo输入参数
 typedef struct tagNET_IN_ATTACH_TRANSMIT_INFO
 {
     DWORD                       dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_IN_ATTACH_TRANSMIT_INFO)
     AsyncTransmitInfoCallBack   cbTransmitInfo;                 // 回调函数
     LDWORD				         dwUser;                         // 用户数据
     char*                       szInJsonBuffer;                 // Json请求数据,用户申请空间
     DWORD                       dwInJsonBufferSize;             // Json请求数据长度  `
     BOOL						 bSubConnFirst;					 // TRUE-当设备支持时，使用子连接方式接收订阅数据 FALSE-只在主连接接收订阅数据
 }NET_IN_ATTACH_TRANSMIT_INFO;

///@brief CLIENT_AttachTransmitInfo输出参数
 typedef struct tagNET_OUT_ATTACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_OUT_ATTACH_TRANSMIT_INFO)
     BYTE*                   szOutBuffer;                    // 应答缓冲地址,用户申请空间
     DWORD                   dwOutBufferSize;                // 应答缓冲总长度
     DWORD                   dwOutJsonLen;                   // 应答Json数据长度
     DWORD                   dwOutBinLen;                    // 应答二进制数据长度 
 } NET_OUT_ATTACH_TRANSMIT_INFO;

///@brief CLIENT_DetachTransmitInfo输入参数
 typedef struct tagNET_IN_DETACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_IN_DETACH_TRANSMIT_INFO)
     char*                   szInJsonBuffer;                 // Json请求数据,用户申请空间
     DWORD                   dwInJsonBufferSize;             // Json请求数据长度
 } NET_IN_DETACH_TRANSMIT_INFO;

///@brief CLIENT_DetachTransmitInfo输出参数
 typedef struct tagNET_OUT_DETACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // 用户使用该结构体时，dwSize需赋值为sizeof(NET_OUT_DETACH_TRANSMIT_INFO)
     char*                   szOutBuffer;                    // 应答数据缓冲空间, 用户申请空间
     DWORD                   dwOutBufferSize;                // 应答数据缓冲空间长度
     DWORD                   dwOutJsonLen;                   // 应答Json数据长度
 } NET_OUT_DETACH_TRANSMIT_INFO;

////上海BUS//////
 
///@brief  上海巴士控制类型， 对应CLIENT_ControlSpecialDevice接口
typedef enum tagNET_SPECIAL_CTRL_TYPE
{
    NET_SPECIAL_CTRL_SHUTDOWN_PAD,            // 关闭PAD命令, pInBuf对应类型NET_IN_SHUTDOWN_PAD*, pOutBuf对应类型NET_OUT_SHUTDOWN_PAD*
    NET_SPECIAL_CTRL_REBOOT_PAD,              // 重启PAD命令, pInBuf对应类型NET_IN_REBOOT_PAD*, pOutBuf对应类型NET_OUT_REBOOT_PAD*                 
} NET_SPECIAL_CTRL_TYPE;

 //////////////////////////////////////////////设备特殊配置结构体定义开始////////////////////////////////////////////////////////////////////////////////////////////
///@brief CLIENT_DevSpecialCtrl 特殊控制类型
 typedef enum tagEM_DEV_SPECIAL_CTRL_TYPE
 {
     DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH,                  // 缓存录像数据强制写入硬盘, pInBuf=NET_IN_RECORD_FLUSH_INFO* , pOutBuf=NET_OUT_RECORD_FLUSH_INFO*
 } EM_DEV_SPECIAL_CTRL_TYPE;
 
///@brief CLIENT_DevSpecialCtrl, 对应 DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH 输入参数
 typedef struct tagNET_IN_NET_IN_RECORD_FLUSH_INFO
 {
    DWORD                                      dwSize;       // 用户使用该结构体时，dwSize需赋值为sizeof(NET_IN_RECORD_FLUSH_INFO)               
    int                                        nChannel;     // 通道号
    NET_STREAM_TYPE                            emStreamType; // 码流类型, 有效类型 "main", "Extra1", "Extra2", "Extar3", "Snapshot"     
 }NET_IN_RECORD_FLUSH_INFO;

///@brief CLIENT_DevSpecialCtrl, 对应 DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH 输出参数
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

////////////////////////////////////////////异步纯透传结构体定义结束////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////设备网卡信息结构体定义开始 ////////////////////////////////////////////////////////////////////////////////////////////

typedef struct tagNET_DHDEV_ETHERNET_INFO
{
    DWORD               dwSize;                                 // 用户使用该结构体时，dwSize 需赋值为 sizeof(NET_DHDEV_ETHERNET_INFO)
    int                 nEtherNetNum;                           // 以太网口数
    DH_ETHERNET_EX      stuEtherNet[DH_MAX_ETHERNET_NUM_EX];    // 以太网口
} NET_DHDEV_ETHERNET_INFO;

////////////////////////////////////////////设备网卡信息结构体定义结束////////////////////////////////////////////////////////////////////////////////////////////


///@brief 获取HCDZ采集信息,输入参数
typedef struct tagNET_IN_HCDZ_LIST_INFO 
{
    DWORD                           dwSize;							//  结构体大小, 调用者必须初始化该字段
	UINT							nIndexNum;					   //数组szindex有效数量
    UINT                            szIndex[DH_COMMON_STRING_64]; //一个数组,index 值与通道下标对应
}NET_IN_HCDZ_LIST_INFO;

///@brief  HCDZ采集信息，检测模块采集信息
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

///@brief  获取HCDZ采集信息,输出参数
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

///@brief  获取HCDZ(惠测电子)能力结构体
typedef struct tagCFG_HCDZ_CAPS
{
	DWORD                               dwSize;                                 // 结构体大小, 调用者必须初始化该字段
	char								szModelID[DH_COMMON_STRING_32];		    // 设备型号
	unsigned int						nVersion;								// 版本
	unsigned int						nAnalogsNum;							// 检测模块模拟量输入个数
	unsigned int						nDINum;									// 检测模块开关量输入个数
	unsigned int						nDONum;									// 检测模块开关量输出个数
}NET_OUT_HCDZ_CAPS;

///@brief  获取电梯状态(HADT山东金鲁班宏安电梯),输入参数
typedef struct tagNET_IN_HADT_STATUS
{
    DWORD                               dwSize;                                 // 结构体大小, 调用者必须初始化该字段
}NET_IN_HADT_STATUS;

///@brief  获取电梯状态(HADT山东金鲁班宏安电梯),输出参数
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

///@brief 报警输出控制接口CLIENT_SetAlarmOut，输入参数
typedef struct tagNET_IN_SET_ALARMOUT
{
    DWORD                               dwSize;                                 // 结构体大小，需要赋值
    int                                 nChannel;                               // 通道号，从0开始
    int                                 nTime;                                  // time > 0 时, time生效。单位:秒
    int                                 nLevel;                                 // time = 0 时, level生效。time与level都为0时，表示停止
}NET_IN_SET_ALARMOUT;

///@brief 报警输出控制接口CLIENT_SetAlarmOut，输出参数
typedef struct tagNET_OUT_SET_ALARMOUT
{   
    DWORD                               dwSize;                                 // 结构体大小,需要赋值
}NET_OUT_SET_ALARMOUT;

///@brief  录像类型
typedef enum tagEM_NET_LINK_RECORD_EVENT
{
    EM_NET_LINK_RECORD_UNKNOWN,                         // 未知
    EM_NET_LINK_RECORD_ALARM,                           // Alarm
} EM_NET_LINK_RECORD_EVENT;

///@brief CLIENT_StartLinkRecord输入参数
typedef struct tagNET_IN_LINK_RECORD_CTRL
{
    DWORD                       dwSize;                 // 该结构体大小
    unsigned int                nChannel;               // 通道号
    unsigned int                nLength;                // 录像时长
    EM_NET_LINK_RECORD_EVENT    emType;                 // 录像类型"Alarm"-报警录像，当前仅支持这种录像
} NET_IN_LINK_RECORD_CTRL;

///@brief CLIENT_StartLinkRecord输出参数
typedef struct tagNET_OUT_LINK_RECORD_CTRL
{
    DWORD                       dwSize;                 // 该结构体大小
} NET_OUT_LINK_RECORD_CTRL;

///@brief  CLIENT_SetDeviceUkey输入参数
typedef struct tagNET_IN_SET_UEKY
{
    DWORD                       dwSize;                 // 该结构体大小
    char                        szUkey[128];             // Ukey号
}NET_IN_SET_UEKY;

///@brief  CLIENT_SetDeviceUkey 输出参数
typedef struct tagNET_OUT_SET_UEKY
{
    DWORD                       dwSize;                 // 该结构体大小
}NET_OUT_SET_UEKY;

///@brief  功能描述	:	下载录像文件--扩展,可加载码流转换库	
///@param[in] lLoginID:       登录接口返回的句柄
///@param[in] lpRecordFile:   查询录像接口返回的录像信息
///@param[in] sSavedFileName: 保存录像文件名,支持全路径
///@param[in] cbDownLoadPos:  下载进度回调函数(回调下载进度,下载结果)
///@param[in] dwUserData:     下载进度回调对应用户数据
///@param[in] fDownLoadDataCallBack: 录像数据回调函数(回调形式暂不支持转换PS流)
///@param[in] dwDataUser:     录像数据回调对应用户数据
///@param[in] scType:         码流转换类型,0-DAV码流(默认); 1-PS流
///@param[in] pReserved:      保留字段,后续扩展
///@return  	：	LLONG 下载录像句柄
//其他说明	：	特殊接口,SDK默认不支持转PS流,需定制SDK

CLIENT_NET_API LLONG CALL_METHOD CLIENT_DownloadByRecordFileEx2(LLONG lLoginID, LPNET_RECORDFILE_INFO lpRecordFile, char *sSavedFileName, 
                                                    fDownLoadPosCallBack cbDownLoadPos, LDWORD dwUserData, 
                                                    fDataCallBack fDownLoadDataCallBack, LDWORD dwDataUser, 
                                                    int scType = 0, void* pReserved = NULL);


///@brief  功能描述	:	通过时间下载录像--扩展,可加载码流转换库
///@param[in]     lLoginID:       登录接口返回的句柄
///@param[in]     nChannelId:     视频通道号,从0开始
///@param[in]     nRecordFileType:录像类型 0 所有录像文件
/*                                         1 外部报警 
*                                          2 动态检测报警 
*                                          3 所有报警 
*                                          4 卡号查询  
*                                          5 组合条件查询 
*                                          6 录像位置与偏移量长度 
*                                          8 按卡号查询图片(目前仅HB-U和NVS特殊型号的设备支持) 
*                                          9 查询图片(目前仅HB-U和NVS特殊型号的设备支持)  
*                                          10 按字段查询 
*                                          15 返回网络数据结构(金桥网吧) 
*                                          16 查询所有透明串数据录像文件 
*/
///@param[in]     tmStart:        开始时间 
///@param[in]     tmEnd:          结束时间 
///@param[in]     sSavedFileName: 保存录像文件名,支持全路径
///@param[in]     cbTimeDownLoadPos: 下载进度回调函数(回调下载进度,下载结果)
///@param[in]     dwUserData:     下载进度回调对应用户数据
///@param[in]     fDownLoadDataCallBack: 录像数据回调函数(回调形式暂不支持转换PS流)
///@param[in]     dwDataUser:     录像数据回调对应用户数据
///@param[in]     scType:         码流转换类型,0-DAV码流(默认); 1-PS流,3-MP4
///@param[in]     pReserved:      保留参数,后续扩展
///@return 	：	LLONG 下载录像句柄
//其他说明	：	特殊接口,SDK默认不支持转PS流,需定制SDK
/******************************************************************************/
CLIENT_NET_API LLONG CALL_METHOD CLIENT_DownloadByTimeEx2(LLONG lLoginID, int nChannelId, int nRecordFileType, 
                                                    LPNET_TIME tmStart, LPNET_TIME tmEnd, char *sSavedFileName, 
                                                    fTimeDownLoadPosCallBack cbTimeDownLoadPos, LDWORD dwUserData, 
                                                    fDataCallBack fDownLoadDataCallBack, LDWORD dwDataUser, 
                                                    int scType = 0, void* pReserved = NULL);


///@brief  功能描述	:	透传扩展接口,按透传类型走对应透传方式接口，目前支持F6纯透传, 同时兼容CLIENT_TransmitInfoForWeb接口
///@param[in]    lLoginID:       登录接口返回的句柄
///@param[in]    pInParam:       透传扩展接口输入参数
///@param[in]    pOutParam       透传扩展接口输出参数
///@param[in]   nWaittime       接口超时时间
///@return	：	BOOL  TRUE :成功; FALSE :失败
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_TransmitInfoForWebEx(LLONG lLoginID, NET_IN_TRANSMIT_INFO* pInParam, 
                                                             NET_OUT_TRANSMIT_INFO* pOutParam, int nWaittime = 3000);



///@brief  功能描述	:	 异步纯透传订阅接口	
///@param[in]    lLoginID:       登录接口返回的句柄
///@param[in]    pInParam:       异步纯透传接口输入参数
///@param[in]    pOutParam       异步纯透传接口输出参数
///@param[in]    nWaittime       接口超时时间
///@return	：	    LLONG 异步纯透传句柄
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachTransmitInfo(LLONG lLoginID, const NET_IN_ATTACH_TRANSMIT_INFO* pInParam, NET_OUT_ATTACH_TRANSMIT_INFO* pOutParam, int nWaitTime);

 


///@brief  功能描述	:	 异步纯透传取消订阅接口	
///@param[in]    lAttachHandle:  异步纯透传句柄，即CLIENT_AttachTransmitInfo接口的返回值
///@param[in]    pInParam:       异步纯透传取消订阅接口输入参数
///@param[in]    pOutParam       异步纯透传取消订阅接口输出参数
///@param[in]    nWaittime       接口超时时间
///@return	：		BOOL  TRUE :成功; FALSE :失败
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_DetachTransmitInfo(LLONG lAttachHandle, const NET_IN_DETACH_TRANSMIT_INFO* pInParam, NET_OUT_DETACH_TRANSMIT_INFO* pOutParam, int nWaitTime);



///@brief  功能描述	:	 设备特殊控制接口
///@param[in]    lLoginID:                       登录接口返回的句柄
///@param[in]    EM_DEV_SPECIAL_CTRL_TYPE:       特殊控制类型
///@param[in]    pInParam:                       设备特殊控制接口输入参数
///@param[in]    pOutParam                       设备特殊控制接口输出参数
///@param[in]   nWaittime                       接口超时时间
///@return	：		BOOL  TRUE :成功; FALSE :失败
CLIENT_NET_API  BOOL CALL_METHOD CLIENT_DevSpecialCtrl(LLONG lLoginID, EM_DEV_SPECIAL_CTRL_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime = 3000);



///@brief  功能描述	:	 获取设备网卡信息接口		
///@param[in]    lLoginID:                       登录接口返回的句柄
///@param[in]    pstOutParam                     获取设备网卡信息接口的输出参数
///@param[in]    nWaittime                       接口超时时间
///@return	：		BOOL  TRUE :成功; FALSE :失败
CLIENT_NET_API  BOOL CALL_METHOD CLIENT_QueryEtherNetInfo(LLONG lLoginID, NET_DHDEV_ETHERNET_INFO* pstuOutParam, int nWaitTime = 3000);

////上海BUS//////

///@brief  串口数据交互接口,异步获取数据
CLIENT_NET_API LLONG CALL_METHOD CLIENT_ExChangeData(LLONG lLoginId, NET_IN_EXCHANGEDATA* pInParam, NET_OUT_EXCHANGEDATA* pOutParam, int nWaittime = 5000);

///@brief  监听CAN总线数据
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachCAN(LLONG lLoginID, const NET_IN_ATTACH_CAN* pstInParam, NET_OUT_ATTACH_CAN* pstOutParam, int nWaitTime = 3000);

///@brief  取消监听CAN总线数据，lAttachHandle是CLIENT_AttachCAN返回值
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachCAN(LLONG lAttachHandle);

///@brief  发送CAN总线数据
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SendCAN(LLONG lLoginID, const NET_IN_SEND_CAN* pstInParam, NET_OUT_SEND_CAN* pstOutParam, int nWaitTime = 3000);

///@brief  监听透明串口数据
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachDevComm(LLONG lLoginID, const NET_IN_ATTACH_DEVCOMM* pstInParam, NET_OUT_ATTACH_DEVCOMM* pstOutParam, int nWaitTime = 3000);

///@brief  取消监听透明串口数据，lAttachHandle是CLIENT_AttachDevComm返回值
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachDevComm(LLONG lAttachHandle);

///@brief  上海巴士设备控制接口，包括控制PAD关机和重启等
CLIENT_NET_API BOOL CALL_METHOD CLIENT_ControlSpecialDevice(LLONG lLoginID, NET_SPECIAL_CTRL_TYPE emType, void* pInBuf, void* pOutBuf = NULL, int nWaitTime = NET_INTERFACE_DEFAULT_TIMEOUT);

///@brief 获取HCDZ采集信息
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_GetHCDZInfo(LLONG lLoginID, const NET_IN_HCDZ_LIST_INFO* pInParam, NET_OUT_HCDZ_LIST_INFO* pOutParam, int nWaitTime = 3000);

///@brief 获取HCDZ能力集
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_GetHCDZCaps(LLONG lLoginID, const NET_IN_HCDZ_CAPS* pInParam, NET_OUT_HCDZ_CAPS* pOutParam, int nWaitTime = 3000);


///@brief  设置云台持续性控制命令发送间隔，该设置对当前所有登录的云台设备都生效（单位ms，间隔时间需大于100ms，否则不生效）
CLIENT_NET_API void CALL_METHOD CLIENT_PTZCmdSendIntervalTime(DWORD dwIntervalTime);


///@brief  功能描述:获取HADT(山东金鲁班宏安电梯)运行状态
///@param[in]    lLoginID:登录接口返回的句柄
///@param[in]    pInBuf  :输入参数,需初始化dwSize
///@param[in]    pOutBuf :输出参数,需初始化dwSize
///@param[in]    nWaitTime :接口超时时间
///@return:	BOOL  TRUE :成功; FALSE :失败
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetHADTStatus(LLONG lLoginID, const NET_IN_HADT_STATUS* pInBuf, NET_OUT_HADT_STATUS* pOutBuf,int nWaitTime = 3000);


///@brief  功能描述:控制报警输出（车载定制）
///@param[in]    lLoginID:登录接口返回的句柄
///@param[in]    pInBuf  :输入参数,需初始化dwSize
///@param[in]    pOutBuf :输出参数,需初始化dwSize
///@param[in]    nWaitTime :接口超时时间
///@return:	BOOL  TRUE :成功; FALSE :失败
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetAlarmOut(LLONG lLoginID, const NET_IN_SET_ALARMOUT* pInBuf, NET_OUT_SET_ALARMOUT* pOutBuf,int nWaitTime);

///@brief 开启EVS定时录像
CLIENT_NET_API BOOL CALL_METHOD CLIENT_StartLinkRecord(LLONG lLoginID, const NET_IN_LINK_RECORD_CTRL *pstIn, NET_OUT_LINK_RECORD_CTRL *pstOut, int nWaitTime);

/// 北京公交定制接口，传入Ukey值
///@brief  功能描述:设备此次登陆的Ukey值
///@param[in]    lLoginID:登录接口返回的句柄
///@param[in]    pInBuf  :输入参数,需初始化dwSize
///@param[in]   pOutBuf :输出参数,需初始化dwSize
///@param[in]    nWaitTime :接口超时时间
///@return:	BOOL  TRUE :成功; FALSE :失败
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

///@brief  对应CLIENT_StartSearchCustomDevices接口
///@brief  搜索OEM设备类型枚举
typedef enum tagEM_SEARCH_OEM_DEVICE_TYPE
{
	EM_TYPE_JIANGSU_CHUANGTONG = 0,    // 江苏创通OEM设备类型
	EM_TYPE_MAX,					   // 最大枚举值
}EM_SEARCH_OEM_DEVICE_TYPE;

///@brief  OEM设备信息
typedef struct tagCUSTOM_DEVICE_NETINFO
{
	char                szMac[DH_MACADDR_LEN];                  // MAC地址,如00:40:9D:31:A9:0A
	char                szIP[DH_MAX_IPADDR_EX_LEN];				// IP地址,如10.0.0.231
	char                szDevName[DH_MACHINE_NAME_NUM];         // 设备名称,固定为Wireless Transmission Device
	BYTE				byReserved[1024];						// 保留字节
}CUSTOM_DEVICE_NETINFO;

///@brief  异步搜索OEM设备回调（pCustomDevNetInf内存由SDK内部申请释放）
typedef void (CALLBACK *fSearchCustomDevicesCB)(CUSTOM_DEVICE_NETINFO *pCustomDevNetInfo, void* pUserData);

///@brief  CLIENT_StartSearchCustomDevices接口的输入参数
typedef struct tagNET_IN_SEARCH_PARAM 
{
	DWORD							dwSize;                  // 结构体大小
	fSearchCustomDevicesCB			cbFunc;			         // 搜索OEM设备回调函数
	void*							pUserData;               // 用户传入的自定义数据
	char*							szLocalIp;				 // 本地IP
	EM_SEARCH_OEM_DEVICE_TYPE       emSearchOemDeviceType;   //	搜索OEM设备类型
}NET_IN_SEARCH_PARAM;

///@brief  CLIENT_StartSearchCustomDevices的输出参数
typedef struct tagNET_OUT_SEARCH_PARAM
{
	DWORD		dwSize;
}NET_OUT_SEARCH_PARAM;

///@brief  异步组播搜索OEM设备, (pInParam, pOutParam内存由用户申请释放),不支持多线程调用,配件产品线需求
CLIENT_NET_API LLONG CALL_METHOD CLIENT_StartSearchCustomDevices(const NET_IN_SEARCH_PARAM *pInParam, NET_OUT_SEARCH_PARAM *pOutParam); 
///@brief  停止组播搜索OEM设备
CLIENT_NET_API BOOL CALL_METHOD CLIENT_StopSearchCustomDevices(LLONG lSearchHandle);

///@brief  设备登录策略入参
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

///@brief  设备登录策略出参
typedef struct tagNET_OUT_LOGIN_POLICY_PARAM
{
	DWORD               dwSize;
	NET_DEVICEINFO_Ex   stuDeviceInfo;                          // 设备信息
}NET_OUT_LOGIN_POLICY_PARAM;


///@brief  登录扩展接口, 支持策略
CLIENT_NET_API LLONG CALL_METHOD CLIENT_LoginWithPolicy(const NET_IN_LOGIN_POLICY_PARAM* pstInParam, NET_OUT_LOGIN_POLICY_PARAM* pstOutParam, int nWaitTime);

/**************************** 乐橙设备专用接口  Start  ********************************/
///@brief  初始化设备账户输入结构体
typedef struct tagNET_IN_INIT_DEVICE_ACCOUNT_BY_PORT
{
	DWORD					dwSize;										// 结构体大小:初始化结构体时赋值
	char					szMac[DH_MACADDR_LEN];						// 设备mac地址	
	char					szUserName[MAX_USER_NAME_LEN];				// 用户名
	char					szPwd[MAX_PWD_LEN];							// 设备密码
	char					szCellPhone[MAX_CELL_PHONE_NUMBER_LEN];		// 预留手机号
	char					szMail[MAX_MAIL_LEN];						// 预留邮箱
	BYTE					byInitStatus;								// 此字段已经废弃															
	BYTE					byPwdResetWay;								// 设备支持的密码重置方式：搜索设备接口(CLIENT_SearchDevices、CLIENT_StartSearchDevices的回调函数、CLIENT_SearchDevicesByIPs)返回字段byPwdResetWay的值	
																		// 该值的具体含义见 DEVICE_NET_INFO_EX 结构体，需要与设备搜索接口返回的 byPwdResetWay 值保持一致
																		// bit0 : 1-支持预留手机号，此时需要在szCellPhone数组中填入预留手机号(如果需要设置预留手机) ; 
																		// bit1 : 1-支持预留邮箱，此时需要在szMail数组中填入预留邮箱(如果需要设置预留邮箱)
	int						nPort;										// 端口号 : 乐橙设备的组播端口号
}NET_IN_INIT_DEVICE_ACCOUNT_BY_PORT;

///@brief  初始化设备账户输出结构体
typedef struct tagNET_OUT_INIT_DEVICE_ACCOUNT_BY_PORT
{
	DWORD					dwSize;										// 结构体大小:初始化结构体时赋值
}NET_OUT_INIT_DEVICE_ACCOUNT_BY_PORT;

///@brief  初始化乐橙设备账户
CLIENT_NET_API BOOL CALL_METHOD CLIENT_InitDevAccountByPort(const NET_IN_INIT_DEVICE_ACCOUNT_BY_PORT* pInitAccountIn, NET_OUT_INIT_DEVICE_ACCOUNT_BY_PORT* pInitAccountOut, DWORD dwWaitTime, char* szLocalIp);

///@brief  重置密码输入结构体
typedef struct tagNET_IN_RESET_PWD_BY_PORT
{
	DWORD					dwSize;								// 结构体大小:初始化结构体时赋值
	char					szMac[DH_MACADDR_LEN];				// 设备mac地址	
	char					szUserName[MAX_USER_NAME_LEN];		// 用户名
	char					szPwd[MAX_PWD_LEN];					// 密码
	char					szSecurity[MAX_SECURITY_CODE_LEN];	// 平台发送到预留手机或邮箱中的安全码
	BYTE					byInitStaus;						// 设备初始化状态：搜索设备接口(CLIENT_SearchDevices、CLIENT_StartSearchDevices的回调函数、CLIENT_SearchDevicesByIPs)返回字段byInitStatus的值
	BYTE					byPwdResetWay;						// 设备支持的密码重置方式：搜索设备接口(CLIENT_SearchDevices、CLIENT_StartSearchDevices的回调函数、CLIENT_SearchDevicesByIPs)返回字段byPwdResetWay的值
	BYTE					byReserved[2];						// 保留字段			
	char                    szContact[MAX_CONTACT_LEN];         // 用户输入安全码需输入接收安全码的联系方式，如果bSetContact为TRUE，则该联系方式将作为预留联系方式
	BOOL                    bSetContact;                        // 是否同意设置为预留手机号, TRUE:同意; FALSE:不同意
	int						nPort;								// 端口号 : 乐橙设备的组播端口号
}NET_IN_RESET_PWD_BY_PORT;

///@brief  重置密码输出结构体
typedef struct tagNET_OUT_RESET_PWD_BY_PORT
{
	DWORD					dwSize;// 结构体大小:初始化结构体时赋值
}NET_OUT_RESET_PWD_BY_PORT;

///@brief  重置乐橙设备密码
CLIENT_NET_API BOOL CALL_METHOD CLIENT_ResetPwdByPort(const NET_IN_RESET_PWD_BY_PORT* pResetPwdIn, NET_OUT_RESET_PWD_BY_PORT* pResetPwdOut, DWORD dwWaitTime, char* szLocalIp);

///@brief  获取重置密码信息输入结构体
typedef struct tagNET_IN_DESCRIPTION_FOR_RESET_PWD_BY_PORT
{
	DWORD					dwSize;								// 结构体大小:初始化结构体时赋值
	char					szMac[DH_MACADDR_LEN];				// 设备mac地址
	char					szUserName[MAX_USER_NAME_LEN];		// 用户名	
	BYTE					byInitStatus;						// 设备初始化状态：搜索设备接口(CLIENT_SearchDevices、CLIENT_StartSearchDevices的回调函数、CLIENT_SearchDevicesByIPs)返回字段byInitStatus的值
	int						nPort;								// 端口号 : 乐橙设备的组播端口号
}NET_IN_DESCRIPTION_FOR_RESET_PWD_BY_PORT;

///@brief  获取重置密码信息输出结构体
typedef struct tagNET_OUT_DESCRIPTION_FOR_RESET_PWD_BY_PORT
{
	DWORD			dwSize;										// 结构体大小:初始化结构体时赋值
	char			szCellPhone[MAX_CELL_PHONE_NUMBER_LEN];		// 预留手机号
	char			szMailAddr[MAX_MAIL_LEN];					// 预留邮箱
	char*			pQrCode;									// 二维码信息,用户分配内存（当前大小为360字节）
	unsigned int	nQrCodeLen;									// 用户分配的二维码信息长度
	unsigned int    nQrCodeLenRet;								// 设备返回的二维码信息长度
}NET_OUT_DESCRIPTION_FOR_RESET_PWD_BY_PORT;

///@brief  获取乐橙设备的重置信息:手机号、邮箱、二维码信息
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDescriptionForResetPwdByPort(const NET_IN_DESCRIPTION_FOR_RESET_PWD_BY_PORT* pDescriptionIn, NET_OUT_DESCRIPTION_FOR_RESET_PWD_BY_PORT* pDescriptionOut, DWORD dwWaitTime, char* szLocalIp);


/****************************  乐橙设备专用接口  End  ********************************/

///@brief  CLIENT_TriggerAutoInspection 接口入参
typedef struct tagNET_IN_TRIGGER_AUTO_INSPECTION
{
	DWORD dwSize;
}NET_IN_TRIGGER_AUTO_INSPECTION;

///@brief  CLIENT_TriggerAutoInspection 接口出参
typedef struct tagNET_OUT_TRIGGER_AUTO_INSPECTON
{
	DWORD dwSize;
}NET_OUT_TRIGGER_AUTO_INSPECTON;

///@brief  触发设备自检（楼宇产品线专用需求）
CLIENT_NET_API BOOL CALL_METHOD CLIENT_TriggerAutoInspection(LLONG lLoginID, const NET_IN_TRIGGER_AUTO_INSPECTION* pstInParam, NET_OUT_TRIGGER_AUTO_INSPECTON* pstOutParam, int nWaitTime);

///@brief  CLIENT_GetLicenseAssistInfo 接口入参
typedef struct tagNET_IN_GET_LICENSE_INFO
{
	DWORD dwSize;								// 赋值为结构体大小
	int	  nChannel;								// 授权设备通道号
}NET_IN_GET_LICENSE_INFO;

///@brief  需要被License限制的库信息
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


///@brief 对多设备授权
typedef struct tagNET_MULTIPLE_AUTH_INFO
{
	
	int		nIndex;								// 设备下标id
	int		nTotalDevices;						// 设备总数
	char	szReserved[256];					// 保留字段
}NET_MULTIPLE_AUTH_INFO;

///@brief  CLIENT_GetLicenseAssistInfo 接口出参
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
	NET_MULTIPLE_AUTH_INFO	stuMultipleAuth;	// 对多设备授权
}NET_OUT_GET_LICENSE_INFO;

///@brief  获取制作License的辅助信息
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetLicenseAssistInfo(LLONG lLoginID, const NET_IN_GET_LICENSE_INFO* pstInParam, NET_OUT_GET_LICENSE_INFO* pstOutParam, int nWaitTime);



///@brief  制作Licenced的厂家入参
typedef struct tagNET_IN_GETVENDOR
{
	DWORD				dwSize;						// 此结构体大小
}NET_IN_GETVENDOR;

///@brief  Licence的对应信息
typedef struct tagNET_VENDOR_INFO
{
	char				szVendorId[32];				// 第三方厂商名称id
	int					nClassNum;					// 厂商算法个数
	char				szClass[32][8];				// 第三方厂商算法大类
	BYTE				bReserved[512];				// 预留字节
}NET_VENDOR_INFO;

///@brief  制作Licence的厂家出参
typedef struct tagNET_OUT_GETVENDOR
{
	DWORD				dwSize;						// 此结构体大小
	int					nVendorNum;					// 信息个数
	NET_VENDOR_INFO		stuVendorInfo[8];			// 信息，最大为8组
}NET_OUT_GETVENDOR;


///@brief  第三方厂商制作License的辅助信息入参
typedef struct tagNET_IN_GETTHIRDASSISTED_INFO
{
	DWORD				dwSize;						// 此结构体大小
	NET_VENDOR_INFO		stuVendorInfo;				// 第三方厂商制作license的辅助信息
}NET_IN_GETTHIRDASSISTED_INFO;

///@brief  需要制作授权的第三方的采用信息
typedef struct tagNET_DEVICE_INFO
{
	char				szSN[32];					// 序列号
	int					nMacNum;					// MAC地址个数
	char				szMac[8][32];				// MAC地址，冒号+大写
	char				szAppVersion[16];			// 应用程序版本
	BYTE				bReserved[512];				// 预留字节
}NET_DEVICE_INFO;

///@brief  需要制作授权的第三方的采用信息
typedef struct tagNET_THIRD_INFO
{
	char				szVendor[32];				// 第三厂商名称
	int					nClassNum;					// 厂商算法个数
	char				szClass[32][8];				// 第三方厂商算法大类
	char				szData[4096];				// 集成的第三方库采集的信息。为防止有特殊字符需要进行base64编码。针对不同的三方公司其对应的data内容也不相同， 
	BYTE				bReserved[4392];			// 预留字节
}NET_THIRD_INFO;

///@brief  第三方厂商制作License的辅助信息出参
typedef struct tagNET_OUT_GETTHIRDASSISTED_INFO
{
	DWORD				dwSize;						// 此结构体大小
	NET_DEVICE_INFO		stuDeviceInfo;				// 设备相关通用信息
	NET_THIRD_INFO		stuThirdInfo;				// 需要制作授权的第三方的采用信息
}NET_OUT_GETTHIRDASSISTED_INFO;

///@brief  导入第三方制作的license的入参
typedef struct tagNET_IN_SETTHIRD_LICENSE
{
	DWORD				dwSize;						// 此结构体大小
	char				szVendorId[32];				// 第三方厂家名称ID
	int					nClassNum;					// 厂商算法个数
	char				szClass[32][8];				// 第三方厂商算法大类
	char				szLicense[8192];			// 第三方license数据 base64编码，具体数据格式由第三方厂家定义
}NET_IN_SETTHIRD_LICENSE;

///@brief  导入第三方制作的license的出参
typedef struct tagNET_OUT_SETTHIRD_LICENE
{
	DWORD				dwSize;						// 此结构体大小
}NET_OUT_SETTHIRD_LICENCE;

///@brief  获取授权盒信息入参
typedef struct tagNET_IN_GET_AUTH_BOX_INFO
{
	DWORD				dwSize;						// 此结构体大小
}NET_IN_GET_AUTH_BOX_INFO;

///@brief  授权盒信息
typedef struct tagNET_AUTH_BOX_INFO
{
	char				szIP[32];				// 授权盒IP地址
	UINT				nPort;					// 授权盒端口
	char				szUserName[64];			// 授权盒登陆用户名
	char				szPassWord[64];			// 授权盒登陆密码
	char				szReserved[348];		// 预留字节
}NET_AUTH_BOX_INFO;

///@brief  获取授权盒信息出参
typedef struct tagNET_OUT_GET_AUTH_BOX_INFO
{
	DWORD				dwSize;					// 此结构体大小
	NET_AUTH_BOX_INFO	stuAuthBoxInfo;			// 授权盒信息
}NET_OUT_GET_AUTH_BOX_INFO;

///@brief  设置授权盒信息入参
typedef struct tagNET_IN_SET_AUTH_BOX_INFO
{
	DWORD				dwSize;					// 此结构体大小
	NET_AUTH_BOX_INFO	stuAuthBoxInfo;			// 授权盒信息
}NET_IN_SET_AUTH_BOX_INFO;

///@brief  设置授权盒信息出参
typedef struct tagNET_OUT_SET_AUTH_BOX_INFO
{
	DWORD				dwSize;					// 此结构体大小
}NET_OUT_SET_AUTH_BOX_INFO;

///@brief  获取设备上License文件信息入参
typedef struct tagNET_IN_GET_REAL_LICENSE_INFO
{
	DWORD				dwSize;					// 此结构体大小
}NET_IN_GET_REAL_LICENSE_INFO;

///@brief  设备所属地信息
typedef enum tagEM_LICENCE_ABROAD_INFO
{
	EM_LICENCE_ABROAD_INFO_UNKNOWN,						// 未知
	EM_LICENCE_ABROAD_INFO_MAINLAND,					// 国内
	EM_LICENCE_ABROAD_INFO_OVERSEA,						// 海外
}EM_LICENCE_ABROAD_INFO;

///@brief 限制项目
typedef struct tagNET_LIMIT_ITEMS
{
	UINT				nPolicy;				// 限制名称
												// 1 每秒并发量
												// 60 每分钟并发量
												// 3600 每小时并发量
												// 86400 每天并发量
												// 604800 每周并发量
												// 2592000 每月并发量
												// 31516000 每年并发量
	TP_U64				nValue;					// 限制值
	char				szReserved[128];		// 预留字节
}NET_LIMIT_ITEMS;

///@brief 业务限制
typedef struct tagNET_BUSINESS_LIMIT
{
	UINT				nType;					// 智能算法大类
	int					nLimitItemsCnt;			// 限制项目个数
	NET_LIMIT_ITEMS		stuLimitItems[16];		// 限制项目
	char				szReserved[128];		// 预留字节
}NET_BUSINESS_LIMIT;

///@brief  设备所属地信息
typedef enum tagEM_CLUSTER_LIMIT_POLICY
{
	EM_CLUSTER_LIMIT_POLICY_UNKNOWN,				// 未知
	EM_CLUSTER_LIMIT_POLICY_CPU,					// CPU卡数
	EM_CLUSTER_LIMIT_POLICY_CLUSTER,				// 集群中接入总数
}EM_CLUSTER_LIMIT_POLICY;

///@brief 集群特有控制
typedef struct tagNET_CLUSTER_LIMIT
{
	EM_CLUSTER_LIMIT_POLICY				emPolicy;	// 限制名称
	TP_U64				nValue;						// 限制值
	char				szReserved[128];			// 预留字节
}NET_CLUSTER_LIMIT;

///@brief  状态信息
typedef enum tagEM_REAL_LICENSE_STATUS
{
	EM_REAL_LICENSE_STATUS_UNKNOWN,				// 未知
	EM_REAL_LICENSE_STATUS_NORMAL,				// 正常
	EM_REAL_LICENSE_STATUS_LICENSE_EXPIRES,		// license过期
	EM_REAL_LICENSE_STATUS_LICENSE_UNBURNED,	// license未烧录
	EM_REAL_LICENSE_STATUS_LICENSE_NOT_MATCH,	// license和设备支持智能类型不匹配
	EM_REAL_LICENSE_STATUS_LICENSE_TIMENOTARRIVED,	// license授权时间未到
}EM_REAL_LICENSE_STATUS;

///@brief  License信息
typedef struct tagNET_REAL_LICENSE_INFO
{
	char				szUsername[64];			// License关联的可使用的用户
	UINT				nLicenseID;				// 设备内部分配给License文件的编号
	int					nLicenseUUIDCnt;		// 智能服务器个数
	char				szLicenseUUID[1000][16];	// 智能服务器使用，用于标识不同的算子/GPU卡
	char				szProductType[40];		// 授权的设备类型
	UINT				nEffectiveTime;			// 生效时间，标准UTC时间
	int					nDigitChannel;			// 设备最大数字通道数
	NET_BUSINESS_LIMIT	stuBusinessLimit[16];	// 业务限制
	int					nBusinessLimitCnt;		// 业务限制个数
	int					nClusterLimitCnt;		// 集群特有控制个数
	NET_CLUSTER_LIMIT	stuClusterLimit[16];	// 集群特有控制
	BOOL				bAllType;				// 是否授权全部算法类型
	EM_REAL_LICENSE_STATUS emStatus;			// 状态信息
	EM_LICENCE_ABROAD_INFO	emAbroadInfo;		// 设备所属地信息
	UINT				nEffectiveDays;			// 可用天数
	char				szReserved[1024];		// 预留字节
}NET_REAL_LICENSE_INFO;

///@brief  获取设备上License文件信息出参
typedef struct tagNET_OUT_GET_REAL_LICENSE_INFO
{
	DWORD				dwSize;					// 此结构体大小
	int					nLicenseInfoMax;		// License信息用户申请个数
	int					nLicenseInfoRet;		// License信息实际返回个数
	NET_REAL_LICENSE_INFO* pstuLicenseInfo;		// License信息，空间由用户申请和释放, 申请大小为nLicenseInfoMax * sizeof(NET_REAL_LICENSE_INFO)
}NET_OUT_GET_REAL_LICENSE_INFO;

typedef enum tagEM_LICENCE_OPERATE_TYPE
{
	NET_EM_LICENCE_OPERATE_UNKNOWN = -1,				// 未知
	NET_EM_LICENCE_OPERATE_GETVENDOR,					// 获取用于需要制作License的厂家 pInParam = NET_IN_GETVENDOR, pOutParam = NET_OUT_GETVENDOR
	NET_EM_LICENCE_OPERATE_GETTHIRDINFO,				// 获取用于第三方厂商制作License的辅助信息   pInParam = NET_IN_GETTHIRDASSISTED_INFO, pOutParam = NET_OUT_GETTHIRDASSISTED_INFO
	NET_EM_LICENCE_OPERATE_SETTHIRDLICENCE,				// 导入第三方制作的License pInParam = NET_IN_SETTHIRDLICENCE, pOutParam = NET_OUT_SETTHIRDLICENCE
	NET_EM_LICENCE_OPERATE_GET_AUTH_BOX_INFO,			// 获取授权盒信息, pInParam = NET_IN_GET_AUTH_BOX_INFO, pOutParam = NET_OUT_GET_AUTH_BOX_INFO
	NET_EM_LICENCE_OPERATE_SET_AUTH_BOX_INFO,			// 设置授权盒信息, pInParam = NET_IN_SET_AUTH_BOX_INFO, pOutParam = NET_OUT_SET_AUTH_BOX_INFO
	NET_EM_LICENCE_OPERATE_GET_LICENSE_INFO,			// 获取设备上License文件信息, pInParam = NET_IN_GET_REAL_LICENSE_INFO, pOutParam = NET_OUT_GET_REAL_LICENSE_INFO
}NET_EM_LICENCE_OPERATE_TYPE;


///@brief  License证书信息的操作
CLIENT_NET_API BOOL CALL_METHOD CLIENT_LicenseOperate(LLONG lLoginID, NET_EM_LICENCE_OPERATE_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime);

///@brief  CLIENT_GetPreProcessInfo接口入参
typedef struct tagNET_IN_GET_PRE_PROCESS_INFO
{
	DWORD				dwSize;					// 此结构体大小
}NET_IN_GET_PRE_PROCESS_INFO;

///@brief  CLIENT_GetPreProcessInfo接口出参
typedef struct tagNET_OUT_GET_PRE_PROCESS_INFO
{
	DWORD				dwSize;					// 此结构体大小
	int					nTotalDevices;			// 需要授权的设备数
}NET_OUT_GET_PRE_PROCESS_INFO;

///@brief  获取制作license的辅助信息
///@param[in]		lLoginID:		登录句柄
///@param[in]		pstuInParam:	接口输入参数, 内存资源由用户申请和释放
///@param[out]		pstuOutParam:	接口输出参数, 内存资源由用户申请和释放
///@param[in]		nWaitTime:		接口超时时间, 单位毫秒
///@return TRUE表示成功FALSE表示失败 
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetPreProcessInfo(LLONG lLoginID, const NET_IN_GET_PRE_PROCESS_INFO* pstuInParam, NET_OUT_GET_PRE_PROCESS_INFO* pstuOutParam, int nWaitTime);

///@brief  CLIENT_SetLicense 接口入参
typedef struct tagNET_IN_SET_LICENSE
{
	DWORD dwSize;								// 赋值为结构体大小
	char  szLicenseInfo[8192];					// License 数据
	char  szSignature[512];						// License 数据的数字签名
	int   nChannel;								// 授权设备通道号
}NET_IN_SET_LICENSE;

///@brief  CLIENT_SetLicense 接口出参
typedef struct tagNET_OUT_SET_LICENSE
{
	DWORD dwSize;								// 赋值为结构体大小
}NET_OUT_SET_LICENSE;

///@brief  设置License
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetLicense(LLONG lLoginID, const NET_IN_SET_LICENSE* pstInParam, NET_OUT_SET_LICENSE* pstOutParam, int nWaitTime);

///@brief  获取录像加密密码入参
typedef struct tagNET_IN_GET_RECORD_FILE_PASSWORD
{
	DWORD		dwSize;									// 结构体大小
	char		szFileName[DH_COMMON_STRING_256];		// 录像文件名称
}NET_IN_GET_RECORD_FILE_PASSWORD;

///@brief  获取录像加密密码出参
typedef struct tagNET_OUT_GET_RECORD_FILE_PASSWORD
{
	DWORD		dwSize;											// 结构体大小
	char		szPassword[MAX_RECORD_FILE_PASSWORD_LEN + 1];	// 密码
	BYTE		byReserved[3];									// 保留字节,为了字节对齐
}NET_OUT_GET_RECORD_FILE_PASSWORD;

///@brief  获取录像加密密码
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetRecordFilePassword(LLONG lLoginID, const NET_IN_GET_RECORD_FILE_PASSWORD* pInParam, NET_OUT_GET_RECORD_FILE_PASSWORD* pOutParam, int nWaitTime);

///@brief  设置子链接网络参数
typedef struct tagNET_SUBCONNECT_NETPARAM
{
	DWORD               dwSize;                                 // 结构体大小
	UINT				nNetPort;								// 网络映射端口号	
	char				szNetIP[DH_MAX_IPADDR_EX_LEN];			// 网络映射IP地址
} NET_SUBCONNECT_NETPARAM;

///@brief  设置子连接网络参数, pSubConnectNetParam 资源由用户申请和释放
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetSubConnectNetworkParam(LLONG lLoginID, NET_SUBCONNECT_NETPARAM *pSubConnectNetParam);


///@brief  CLIENT_QueryUserRights 接口输入参数
typedef struct tagNET_IN_QUERYUSER_RIGHT
{
	DWORD               dwSize;						// 此结构体大小			
} NET_IN_QUERYUSER_RIGHT;

///@brief  CLIENT_QueryUserRights 接口输入参数
typedef struct tagNET_OUT_QUERYUSER_RIGHT
{
	DWORD               dwSize;						// 此结构体大小		
	DWORD               dwRightNum;                 // 权限信息
    OPR_RIGHT_NEW       rightList[DH_NEW_MAX_RIGHT_NUM];                      
    USER_INFO_NEW       userInfo;                   // 用户信息
    DWORD               dwFunctionMask;             // 掩码；0x00000001 - 支持用户复用，0x00000002 - 密码修改需要校验
} NET_OUT_QUERYUSER_RIGHT;

///@brief  APP用户操作优化接口
CLIENT_NET_API BOOL CALL_METHOD CLIENT_QueryUserRights(LLONG lLoginID, const NET_IN_QUERYUSER_RIGHT* pstInParam, NET_OUT_QUERYUSER_RIGHT* pstOutParam ,int waittime);

///@brief  CLIENT_GetDeviceAllInfo 输入结构体
typedef struct tagNET_IN_GET_DEVICE_AII_INFO
{
    DWORD		dwSize;						// 赋值为结构体大小
}NET_IN_GET_DEVICE_AII_INFO;

///@brief  存储设备状态
typedef enum tagEM_STORAGE_DEVICE_STATUS
{
    EM_STORAGE_DEVICE_UNKNOWN,              // 未知
    EM_STORAGE_DEVICE_ERROR,                // 获取设备失败
    EM_STORAGE_DEVICE_INITIALIZING,         // 正在读取设备
    EM_STORAGE_DEVICE_SUCCESS,              // 获取设备成功
}EM_STORAGE_DEVICE_STATUS;

///@brief  健康状态标识
typedef enum tagEM_STORAGE_HEALTH_TYPE
{
    EM_STORAGE_HEALTH_UNKNOWN = -1,         // 未知
    EM_STORAGE_HEALTH_UNSUPPORT,            // 设备不支持健康检测功能
    EM_STORAGE_HEALTH_SUPPORT_AND_SUCCESS,  // 支持健康检测功能且获取数据成功
    EM_STORAGE_HEALTH_SUPPORT_AND_FAIL,     // 支持健康检测功能但获取数据失败
}EM_STORAGE_HEALTH_TYPE;

///@brief  SD卡加锁状态
typedef enum tagEM_SD_LOCK_STATE
{
    EM_SD_LOCK_STATE_UNKNOWN = -1,          // 未知
    EM_SD_LOCK_STATE_NORMAL,                // 未进行过加锁的状态, 如出厂状态，或清除密码时状态
    EM_SD_LOCK_STATE_LOCKED,                // 加锁
    EM_SD_LOCK_STATE_UNLOCKED,              // 未加锁（加锁后解锁）
}EM_SD_LOCK_STATE;

///@brief  SD卡加密功能标识
typedef enum tagEM_SD_ENCRYPT_FLAG
{
    EM_SD_ENCRYPT_UNKNOWN = -1,                     // 未知
    EM_SD_ENCRYPT_UNSUPPORT,                        // 设备不支持SD卡加密功能
    EM_SD_ENCRYPT_SUPPORT_AND_GETDATA_SUCCESS,      // 支持SD卡加密功能且获取数据成功
    EM_SD_ENCRYPT_SUPPORT_AND_GETDATA_FAIL,         // 支持SD卡加密功能但获取数据失败
}EM_SD_ENCRYPT_FLAG;

///@brief  分区类型
typedef enum tagEM_PARTITION_TYPE
{
    EM_PARTITION_UNKNOWN,               // 未知
    EM_PARTITION_READ_WIRTE,            // 读写
    EM_PARTITION_READ_ONLY,             // 只读
    EM_PARTITION_READ_GENERIC,          // 一般的
}EM_PARTITION_TYPE;

///@brief  设备存储分区信息
typedef struct tagNET_STORAGE_PARTITION_INFO
{
    BOOL                            bError;                 // 分区是否异常
    EM_PARTITION_TYPE               emType;                 // 分区属性类型
    double                          dTotalBytes;            // 分区总空间，单位字节
    double                          dUsedBytes;             // 分区使用空间
    char                            szPath[128];            // 分区名字
    BYTE                            byReserved[128];        // 保留字节
}NET_STORAGE_PARTITION_INFO;

///@brief  设备存储信息
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

///@brief  CLIENT_GetDeviceAllInfo 输出结构体
typedef struct tagNET_OUT_GET_DEVICE_AII_INFO
{
    DWORD		                    dwSize;					// 赋值为结构体大小
    int                             nInfoCount;             // 信息的个数
    NET_DEVICE_STORAGE_INFO         stuStorageInfo[8];      // 设备存储信息
}NET_OUT_GET_DEVICE_AII_INFO;

///@brief  获取IPC设备的存储信息
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDeviceAllInfo(LLONG lLoginID, NET_IN_GET_DEVICE_AII_INFO *pstInParam, NET_OUT_GET_DEVICE_AII_INFO *pstOutParam, int nWaitTime);

///@brief  CLIENT_SetPlayBackBufferThreshold 输入参数
typedef struct tagNET_IN_SET_PLAYBACK_BUFFER_THRESHOLD
{
	DWORD							dwSize;					// 结构体大小
	UINT							nUpperLimit;			// 上限，范围[0, 100), 百分比，0表示默认值
	UINT							nLowerLimit;			// 下限，范围[0, 100), 百分比，0表示默认值
}NET_IN_SET_PLAYBACK_BUFFER_THRESHOLD;

///@brief  CLIENT_SetPlayBackBufferThreshold 输出参数
typedef struct tagNET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD
{
	DWORD							dwSize;					// 结构体大小
}NET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD;


///@brief  设置回放缓存区阈值
///@brief  lPlayBackHandle 为回放句柄
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetPlayBackBufferThreshold(LLONG lPlayBackHandle, NET_IN_SET_PLAYBACK_BUFFER_THRESHOLD* pstInParam, NET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD* pstOutParam);


///@brief  CLIENT_GetDeviceServiceType 输入结构体
typedef struct tagNET_IN_GET_DEVICE_SERVICE_TYPE
{
	DWORD							dwSize;					// 结构体大小
}NET_IN_GET_DEVICE_SERVICE_TYPE;

///@brief  服务类型
typedef enum tagEM_DEVICE_SERVICE_TYPE
{
	EM_DEVICE_SERVICE_TYPE_UNKNOWN,							// 未知
	EM_DEVICE_SERVICE_TYPE_MAIN,							// 主服务
	EM_DEVICE_SERVICE_TYPE_AOL,								// Always on line 服务
}EM_DEVICE_SERVICE_TYPE;

///@brief  CLIENT_GetDeviceServiceType 输出结构体
typedef struct tagNET_OUT_GET_DEVICE_SERVICE_TYPE
{
	DWORD							dwSize;					// 结构体大小
	EM_DEVICE_SERVICE_TYPE			emServiceType;			// 服务类型
}NET_OUT_GET_DEVICE_SERVICE_TYPE;

///@brief  获取设备端服务类型
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDeviceServiceType(LLONG lLoginID, const NET_IN_GET_DEVICE_SERVICE_TYPE* pInParam, NET_OUT_GET_DEVICE_SERVICE_TYPE* pOutParam, int nWaitTime);

///@brief  CLIENT_GetLoginAuthPatchInfo 输入结构体
typedef struct tagNET_IN_GET_LOGIN_AUTH_PATCH_INFO
{
	DWORD							dwSize;					// 结构体大小
}NET_IN_GET_LOGIN_AUTH_PATCH_INFO;


///@brief  CLIENT_GetLoginAuthPatchInfo 输出结构体
typedef struct tagNET_OUT_GET_LOGIN_AUTH_PATCH_INFO
{
	DWORD							dwSize;						// 结构体大小
	BOOL							bSupportHighLevelSecurity;	// 是否支持高等级安全登录
}NET_OUT_GET_LOGIN_AUTH_PATCH_INFO;

///@brief  获取设备登录兼容补丁信息（定制，VTO设备使用）
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetLoginAuthPatchInfo(LLONG lLoginID, const NET_IN_GET_LOGIN_AUTH_PATCH_INFO* pInParam, NET_OUT_GET_LOGIN_AUTH_PATCH_INFO* pOutParam);

///@brief  秘钥长度
typedef enum tagEM_SECURETRANSMIT_KEY_LENGTH
{
	EM_SECURETRANSMIT_AES_KEY_LENGTH_UNKNOWN = -1,				// 未知
	EM_SECURETRANSMIT_AES_KEY_LENGTH_DEFAULT,					// SDK 内部根据设备情况自行确定
	EM_SECURETRANSMIT_AES_KEY_LENGTH_128,						// AES 秘钥长度 128 bit，前提是设备支持
	EM_SECURETRANSMIT_AES_KEY_LENGTH_192,						// AES 秘钥长度 192 bit，前提是设备支持
	EM_SECURETRANSMIT_AES_KEY_LENGTH_256,						// AES 秘钥长度 256 bit，前提是设备支持
}EM_SECURETRANSMIT_KEY_LENGTH;

///@brief  CLIENT_SetSecureTransmitKeyLength 输入结构体
typedef struct tagNET_IN_SET_SECURETRANSMIT_KEY_LENGTH
{
	DWORD							dwSize;						// 结构体大小
	EM_SECURETRANSMIT_KEY_LENGTH	emLength;					// 秘钥长度
}NET_IN_SET_SECURETRANSMIT_KEY_LENGTH;


///@brief  CLIENT_SetSecureTransmitKeyLength 输出结构体
typedef struct tagNET_OUT_SET_SECURETRANSMIT_KEY_LENGTH
{
	DWORD							dwSize;						// 结构体大小
}NET_OUT_SET_SECURETRANSMIT_KEY_LENGTH;

///@brief  设置秘钥长度，全局生效，CLIENT_Init 接口之后调用
///@brief  在程序运行过程中，如果需要更新秘钥长度，需要登出设备，重新登录
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetSecureTransmitKeyLength(const NET_IN_SET_SECURETRANSMIT_KEY_LENGTH* pInParam, NET_OUT_SET_SECURETRANSMIT_KEY_LENGTH* pOutParam);

///@brief  手机订阅全部推送信息
typedef struct tagNET_MOBILE_SUBSCRIBE_ALL_CFG_INFO
{
	DWORD							dwSize;							// 结构体大小
	int								nMaxMobileSubscribeNum;			// 用户分配最大接收查询配置消息个数
	int								nRetMobileSubscribeNum;			// 实际返回接收查询配置消息个数
	BYTE							byReserved[4];					// 字节对齐
	NET_MOBILE_PUSH_NOTIFICATION_GENERAL_INFO	*pstuMobileSubscribe;// 订阅配置	
}NET_MOBILE_SUBSCRIBE_ALL_CFG_INFO;

///@brief  获取手机全部订阅推送信息
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetMobileSubscribeAllCfg(LLONG lLoginID, NET_MOBILE_SUBSCRIBE_ALL_CFG_INFO *pstuCfg, int *nError, int nWaitTime);

/************************************************************************/
/*                              调试日志                               */
/************************************************************************/

///@brief  设置串口重定向入参
typedef struct tagNET_IN_DBGINFO_SET_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_IN_DBGINFO_SET_REDIR_LOCAL;

///@brief  设置串口重定向出参
typedef struct tagNET_OUT_DBGINFO_SET_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_OUT_DBGINFO_SET_REDIR_LOCAL;

///@brief  取消串口打印重定向到本地存储入参
typedef struct tagNET_IN_DBGINFO_CANCEL_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_IN_DBGINFO_CANCEL_REDIR_LOCAL;

///@brief  取消串口打印重定向到本地存储出参
typedef struct tagNET_OUT_DBGINFO_CANCEL_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_OUT_DBGINFO_CANCEL_REDIR_LOCAL;

///@brief  读取日志重定向的信息入参
typedef struct tagNET_IN_DBGINFO_GET_INFO
{
    DWORD               dwSize;
}NET_IN_DBGINFO_GET_INFO;

///@brief  重定向状态
typedef enum tagEM_DBGINFO_REDIR_STATUS
{
    EM_DBGINFO_REDIR_STATUS_UNKNOWN,    // 未知
    EM_DBGINFO_REDIR_STATUS_NO,         // 未重定向
    EM_DBGINFO_REDIR_STATUS_LOCAL,      // 重定向到本地
    EM_DBGINFO_REDIR_STATUS_CALLBACK,   // 重定向到回调
}EM_DBGINFO_REDIR_STATUS;

///@brief  文件信息
typedef struct tagNET_DBGINFO_FILEINFO
{
    char                szFilePath[128]; // 生成的文件路径
    unsigned int        nFileSize;       // 生成的文件大小,单位字节
    BYTE                byReserverd[260];// 保留
}NET_DBGINFO_FILEINFO;

///@brief  读取日志重定向的信息出参
typedef struct tagNET_OUT_DBGINFO_GET_INFO
{
    DWORD               dwSize;
    EM_DBGINFO_REDIR_STATUS emStatus;    // 重定向状态
    NET_DBGINFO_FILEINFO stuFile[10];    // 文件信息
    int                  nRetFileCount;  // 返回的stuFile有效的个数
}NET_OUT_DBGINFO_GET_INFO;

///@brief  获取采集串口日志设备能力集入参
typedef struct tagNET_IN_DBGINFO_GET_CAPS
{
    DWORD               dwSize;
}NET_IN_DBGINFO_GET_CAPS;

///@brief  获取采集串口日志设备能力集出参
typedef struct tagNET_OUT_DBGINFO_GET_CAPS
{
    DWORD               dwSize;
    BOOL                bSupportRedir;        // 是否支持串口日志重定向，包含存文件和回调两种。
}NET_OUT_DBGINFO_GET_CAPS;

///@brief  调试日志操作类型 CLIENT_OperateDebugInfo
typedef enum tagEM_DBGINFO_OP_TYPE
{
    EM_DBGINFO_OP_REDIR_SET_LOCAL,            // 设置串口打印重定向到本地存储 pInParam = NET_IN_DBGINFO_SET_REDIR_LOCAL, pOutParam = NET_OUT_DBGINFO_SET_REDIR_LOCAL
    EM_DBGINFO_OP_REDIR_CANCEL_LOCAL,         // 取消串口打印重定向到本地存储 pInParam = NET_IN_DBGINFO_CANCEL_REDIR_LOCAL, pOutParam = NET_OUT_DBGINFO_CANCEL_REDIR_LOCAL
    EM_DBGINFO_OP_GET_INFO,                   // 读取日志重定向的信息 pInParam = NET_IN_DBGINFO_GET_INFO, pOutParam = NET_OUT_DBGINFO_GET_INFO
    EM_DBGINFO_OP_GET_CAPS,                   // 获取采集串口日志设备能力集 pInParam = NET_IN_DBGINFO_GET_CAPS, pOutParam = NET_OUT_DBGINFO_GET_CAPS
}EM_DBGINFO_OP_TYPE;

///@brief  调试日志回调函数
typedef void (CALLBACK *fDebugInfoCallBack)(LLONG lAttchHandle, BYTE *pBuffer, DWORD dwBufSize, LDWORD dwUser);

///@brief  日志等级
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

///@brief  订阅日志回调入参
typedef struct tagNET_IN_ATTACH_DBGINFO
{
    DWORD               dwSize;
    EM_DBGINFO_LEVEL    emLevel;        // 日志等级
    fDebugInfoCallBack  pCallBack;      // 回调 
    LDWORD              dwUser;         // 用户数据
}NET_IN_ATTACH_DBGINFO;

///@brief  订阅日志回调出参
typedef struct tagNET_OUT_ATTACH_DBGINFO
{
    DWORD               dwSize;    
}NET_OUT_ATTACH_DBGINFO;

////////////////////////////// 调试日志 /////////////////////////////////
///@brief  调试日志操作接口
CLIENT_NET_API BOOL CALL_METHOD CLIENT_OperateDebugInfo(LLONG lLoginID, EM_DBGINFO_OP_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime);

///@brief  订阅调试日志回调
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachDebugInfo(LLONG lLoginID, const NET_IN_ATTACH_DBGINFO* pInParam, NET_OUT_ATTACH_DBGINFO* pOutParam, int nWaitTime);

///@brief  退订调试日志回调
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachDebugInfo(LLONG lAttachHanle);

///@brief  CLIENT_SetInternalControlParam 入参
typedef struct tagNET_INTERNAL_CONTROL_PARAM
{
	DWORD							dwSize;										// 结构体大小
	UINT							nThreadSleepTime;							// 内部线程睡眠间隔，范围[10, 100]，unit:ms，默认10	
	UINT							nSemaphoreSleepTimePerLoop;					// 等待信号量时，内部线程睡眠间隔，范围[10, 100]，unit:ms，默认10
}NET_INTERNAL_CONTROL_PARAM;

///@brief  设置内部控制参数（定制）
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetInternalControlParam(const NET_INTERNAL_CONTROL_PARAM *pInParam);


///@brief 事件类型EVENT_IVS_FACERECOGNITION(目标识别)对应的数据块描述信息  特点：用指针替代原先的CANDIDATE_INFOEX数组
typedef struct tagDEV_EVENT_FACERECOGNITION_INFO_V1
{
    int                 nChannelID;                                 // 通道号
    char                szName[128];                                // 事件名称
    int                 nEventID;                                   // 事件ID
    NET_TIME_EX         UTC;                                        // 事件发生的时间
    DH_MSG_OBJECT       stuObject;                                  // 检测到的物体
    int                 nCandidateNum;                              // 当前人脸匹配到的候选对象数量
    CANDIDATE_INFOEX*   pstuCandidates;                            // 当前人脸匹配到的候选对象信息
    BYTE                bEventAction;                               // 事件动作,0表示脉冲事件,1表示持续性事件开始,2表示持续性事件结束;
    BYTE                byImageIndex;                               // 图片的序号, 同一时间内(精确到秒)可能有多张图片, 从0开始
    BYTE                byReserved1[2];                             // 对齐
    BOOL                bGlobalScenePic;                            // 全景图是否存在
    DH_PIC_INFO         stuGlobalScenePicInfo;                      // 全景图片信息
    char                szSnapDevAddress[MAX_PATH];                 // 抓拍当前人脸的设备地址,如：滨康路37号  
    unsigned int        nOccurrenceCount;                           // 事件触发累计次数
    EVENT_INTELLI_COMM_INFO     stuIntelliCommInfo;                 // 智能事件公共信息
    NET_FACE_DATA		stuFaceData;								// 人脸数据
    char				szUID[DH_COMMON_STRING_32];					// 抓拍人员写入数据库的唯一标识符
    NET_FEATURE_VECTOR	stuFeatureVector;							// 特征值信息
    char				szFeatureVersion[32];						// 特征值算法版本
    EM_FACE_DETECT_STATUS emFaceDetectStatus;                       // 人脸在摄像机画面中的状态
    char				szSourceID[32];								// 事件关联ID,同一个物体或图片生成多个事件时SourceID相同
    NET_PASSERBY_INFO	stuPasserbyInfo;							// 路人库信息
    unsigned int		nStayTime;									// 路人逗留时间 单位：秒
    NET_GPS_INFO        stuGPSInfo;                                 // GPS信息(与 stuCustomProjects下的 stuGPSInfo信息一致)
    char                szCameraID[64];                             // 国标编码
    DH_RESOLUTION_INFO  stuResolution;                              // 对应图片的分辨率
    int					nPerFlag;									// ICC人脸子系统定制, 人脸标签标志位, -1:未知, 0:授权人脸, 1:未授权人脸, 2:陌生人
    BYTE                bReserved[360];                             // 保留字节,留待扩展.
    char				szSerialUUID[22];							// 级联物体ID唯一标识
    // 格式如下：前2位%d%d:01-视频片段,02-图片,03-文件,99-其他;
    // 中间14位YYYYMMDDhhmmss:年月日时分秒;后5位%u%u%u%u%u：物体ID，如00001
    BYTE                byReserved[2];                              // 对齐
    NET_CUSTOM_PROJECTS_INFO stuCustomProjects;						// 项目定制信息
    BOOL				bIsDuplicateRemove;							// 智慧零售，是否符合去重策略（TRUE：符合 FALSE：不符合）
    BYTE				byReserved2[4];								// 字节对齐
    NET_IMAGE_INFO_EX2  stuImageInfo[32];							// 图片信息数组    
    int					nImageInfoNum;								// 图片信息个数
    DH_MSG_OBJECT_SUPPLEMENT    stuObjectSupplement;                // 检测到的物体补充字段
    UINT                nMode;                                      // 0-普通  1-开启陌生人模式
    SCENE_IMAGE_INFO    stuThumImageInfo;                           // 大图（全景图）的缩略图信息
    SCENE_IMAGE_INFO    stuHumanImageInfo;                          // 人体图片信息
    char                szVideoPath[256];                           // 违章关联视频FTP上传路径
    char				byReserved3[316];							// 保留字节
}DEV_EVENT_FACERECOGNITION_INFO_V1;


///@brief 灯组灯色信息
typedef struct  tagLAMP_GROUP_INFO_V1
{
    int				nLampNo;							// 灯组编号
    EM_LAMP_TYPE	emLampType;							// 灯组类型
    int				nRemainTime;						// 信号灯组灯色剩余时间，整数，单位为秒（s）
    int				nLampColorCount;					// 灯组灯色个数
    int				nLampColor[4];						// 灯组灯色当灯组类型为1~12时,int[0]表示红色发光单元，int[1]表示黄色发光单元，int[2]表示绿色发光单元，int[3]保留
    // 当灯组类型为13~15时，int[0]用于表示禁止通行信号发光单元，int[1]用于表示过渡信号发光单元，int[2]用于表示通行信号发光单元，int[3]保留
    // 具体取值 0：无灯 1：灭灯 2：亮灯3：闪烁
}LAMP_GROUP_INFO_V1;

///@brief 进口灯色状态信息
typedef struct tagENTER_INFO_V1
{
    int					nEnterDir;						// 进口方向
    int					nLampNumber;					// 进口灯组数量（0~48）
    int					nLampGroupNum;					// 灯组灯色信息个数
    LAMP_GROUP_INFO_V1	stuLampGroupInfo[48];			// 灯组灯色信息，包含1到M（进口灯组数量）个灯组灯色信息

}ENTER_INFO_V1;


///@brief 灯色状态信息
typedef struct tagLAMP_STATE_V1
{
    int					nEnterNumber;					// 信号灯控制路口的进口数量（0~8）
    int					nEnterInfoNum;					// 进口灯色状态信息个数
    ENTER_INFO_V1		stuEnterInfo[8];				// 进口灯色状态信息，包含1到N（路口进口数量）个进口灯色状态信息
}LAMP_STATE_V1;


///@brief 信号机运行事件, 对应事件类型 DH_ALARM_RTSC_RUNING
typedef struct tagALARM_RTSC_RUNNING_INFO_V1
{
    int							nChannelID;                  // 通道号,从0开始
    int							nEventAction;				 // 事件动作, 1表示开始,  2表示结束, -1表示未知
    DWORD						dwReportState;				 // bit0:运行状态
                                                             // bit1:控制方式
                                                             // bit2:灯色状态信息
                                                             // bit3:车道功能状态
                                                             // bit4:车道/匝道控制状态信息
                                                             // bit5:当前信号方案色步信息
                                                             // bit6: 下一个周期信号方案色步信息
    int							nLongitudeNum;				 // 经度个数
    double						dbLongitude[3];				 // 经度,格式：度，分，秒(秒为浮点数)
    int							nLatitudeNum;				 // 纬度个数
    double						dbLatitude[3];				 // 纬度,格式：度，分，秒(秒为浮点数)
    double						dbAltitude;					 // 高度，单位为米	
    NET_TIME_EX					UTC;						 //	事件发生时间，带时区偏差的UTC时间，单位秒
    EM_STATUS					emStatus;					 // 设备状态 
    EM_CONTROL_MODE				emControlMode;				 // 控制模式
    LAMP_STATE_V1				stuLampStateInfo;			 // 灯色状态信息
}ALARM_RTSC_RUNNING_INFO_V1;

///@brief  CLIENT_SetIVSEventParseType 入参
typedef struct tagNET_IN_SET_IVSEVENT_PARSE_INFO
{
    DWORD							dwSize;										// 结构体大小
    DWORD                           dwIVSEvent;                                 // 事件类型,参考dhnetsdk.h中定义的智能分析事件宏或报警事件宏.
                                                                                // 当前支持情况如下:
                                                                                // nCallBackType为0时(即智能事件解析类型)：
                                                                                // EVENT_IVS_FACERECOGNITION:       dwStructType为 1 时,对应结构体 DEV_EVENT_FACERECOGNITION_INFO_V1

                                                                                // nCallBackType为1时(即报警事件解析类型)：
                                                                                // DH_ALARM_RTSC_RUNING     :       dwStructType为 1 时,对应结构体 ALARM_RTSC_RUNNING_INFO_V1

    DWORD                           dwStructType;                               // 指定解析的类型,具体含义参考 dwIVSEvent 

    int                             nCallBackType;                              // 0 - 智能事件上报
                                                                                // 1 - 普通报警事件上报

}NET_IN_SET_IVSEVENT_PARSE_INFO;


///@brief 指定智能事件或报警事件解析所用的结构体 用于解决java大结构体new对象慢导致的问题.该接口全局有效,建议在SDK初始化前调用
///@param[in] pInParam 接口输入参数, 内存资源由用户申请和释放
///@return TRUE表示成功 FALSE表示失败
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetIVSEventParseType(const NET_IN_SET_IVSEVENT_PARSE_INFO* pInParam);


///@brief  CLIENT_ProbeAlarm入参
typedef struct tagNET_IN_PROBE_ALARM
{
    DWORD               dwSize;
}NET_IN_PROBE_ALARM;

///@brief  CLIENT_ProbeAlarm出参
typedef struct tagNET_OUT_PROBE_ALARM
{
    DWORD               dwSize;
}NET_OUT_PROBE_ALARM;

///@brief 向设备探测报警上报支持情况,探测结果会影响CLIENT_StartListen/CLIENT_StartListenEx这两个报警订阅接口的内部流程,用于解决一次报警触发能收到两个报警回调的情况
///@param[in]	lLoginID:		登录句柄
///@param[in]	pstuInParam:	接口输入参数, 内存资源由用户申请和释放
///@param[out]	pstuOutParam:	接口输出参数, 内存资源由用户申请和释放
///@param[in]	dwWaittime:		接口超时时间, 单位毫秒
///@return TRUE表示成功 表示支持三代报警订阅,后续再调用报警订阅接口时,将不再订阅部分已经支持三代报警上报的二代报警 
///@return FALSE表示失败 表示不支持三代报警订阅流程,后续再订阅报警订阅接口时,仍然会订阅所有二代报警
CLIENT_NET_API BOOL CALL_METHOD CLIENT_ProbeAlarm(LLONG lLoginID,const NET_IN_PROBE_ALARM* pstuInParam,NET_OUT_PROBE_ALARM* pstuOutParam,DWORD dwWaittime);



#ifdef __cplusplus
}
#endif



#endif // DHNETSDKEX_H



