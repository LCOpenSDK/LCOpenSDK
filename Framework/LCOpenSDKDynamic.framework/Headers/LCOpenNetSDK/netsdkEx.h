/*
* Copyright (c) 2009, �㽭�󻪼����ɷ����޹�˾
* All rights reserved.
*
* ժ��Ҫ��SDK�ӿںܶ�,���ƻ�һЩ�����õĹ��ܿ��Է���dhnetsdkEx.h,
*         �����ṩ dhnetsdk.h,
*         ������Ŀ�����ṩ dhnetsdkEx.h
*/
////////////////////////////////////////////////////////////////////////
#ifndef DHNETSDKEX_H
#define DHNETSDKEX_H

#include "dhnetsdk.h"

#ifdef __cplusplus
extern "C" {
#endif

/************************************************************************
 ** ��������
 ***********************************************************************/
#define MAX_RECORD_FILE_PASSWORD_LEN   128    // ����¼���ļ����볤��
/************************************************************************
 ** ö�ٶ���
 ***********************************************************************/

/************************************************************************
 ** �ṹ�嶨��
************************************************************************/

 //////////////////////////////////////͸����չ�ӿڲ���//////////////////////////////////////////////////////////////////
 
///@brief ͸������
 typedef enum   tagNET_TRANSMIT_INFO_TYPE
 {
    NET_TRANSMIT_INFO_TYPE_DEFAULT,                 // Ĭ�����ͣ���CLIENT_TransmitInfoForWeb�ӿڵļ���͸����ʽ
    NET_TRANSMIT_INFO_TYPE_F6,                      // F6��͸��
 } NET_TRANSMIT_INFO_TYPE;

///@brief ͸����������
 typedef enum tagEM_TRANSMIT_ENCRYPT_TYPE
 {
	EM_TRANSMIT_ENCRYPT_TYPE_UNKNOWN = -1,			// δ֪
	EM_TRANSMIT_ENCRYPT_TYPE_NORMAL,				// SDK�ڲ�����ȷ���Ƿ���ܣ�Ĭ��
	EM_TRANSMIT_ENCRYPT_TYPE_MULTISEC,				// �豸֧�ּ��ܵĳ����£���multiSec����
	EM_TRANSMIT_ENCRYPT_TYPE_BINARYSEC,				// �豸֧�ּ��ܵĳ����£���binarySec���ܣ������Ʋ��ֲ�����
 }EM_TRANSMIT_ENCRYPT_TYPE;

///@brief CLIENT_TransmitInfoForWebEx�������
 typedef struct tagNET_IN_TRANSMIT_INFO
 {
    DWORD						dwSize;                         // �û�ʹ�øýṹ�壬dwSize�踳ֵΪsizeof(NET_IN_TRANSMIT_INFO)
    NET_TRANSMIT_INFO_TYPE		emType;                         // ͸������
    char*						szInJsonBuffer;                 // Json��������,�û�����ռ�
    DWORD						dwInJsonBufferSize;             // Json�������ݳ���
    unsigned char*				szInBinBuffer;                  // �������������ݣ��û�����ռ�
    DWORD						dwInBinBufferSize;              // �������������ݳ���
	EM_TRANSMIT_ENCRYPT_TYPE	emEncryptType;					// ��������
 } NET_IN_TRANSMIT_INFO;

///@brief CLIENT_TransmitInfoForWebEx�������
 typedef struct tagNET_OUT_TRANSMIT_INFO
 {
    DWORD                   dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_OUT_TRANSMIT_INFO)
    char*                   szOutBuffer;                    // Ӧ�����ݻ���ռ�, �û�����ռ�
    DWORD                   dwOutBufferSize;                // Ӧ�����ݻ���ռ䳤��
    DWORD                   dwOutJsonLen;                   // JsonӦ�����ݳ���
    DWORD                   dwOutBinLen;                    // ������Ӧ�����ݳ���
 } NET_OUT_TRANSMIT_INFO;

 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 //////////////////////////////////////////////�첽��͸���ṹ�嶨�忪ʼ////////////////////////////////////////////////////////////////////////////////////////////
///@brief CLIENT_AttachTransmitInfo �ϱ���Ϣ�ص�
 typedef struct tagNET_CB_TRANSMIT_INFO
 {
     BYTE*              pBuffer;            // ���ݻ����ַ��SDK�ڲ�����ռ�
     DWORD              dwBufferSize;       // ���ݻ����ܳ���
     DWORD              dwJsonLen;          // Json���ݳ���
     DWORD              dwBinLen;           // ���������ݳ���
     BYTE               byReserved[512];    // �����ֽ�
 } NET_CB_TRANSMIT_INFO;

///@brief CLIENT_AttachTransmitInfo()�ص�����ԭ�ͣ���һ������lAttachHandle��CLIENT_AttachTransmitInfo����ֵ
 typedef int  (CALLBACK *AsyncTransmitInfoCallBack)(LLONG lAttachHandle, NET_CB_TRANSMIT_INFO* pTransmitInfo, LDWORD dwUser);

///@brief CLIENT_AttachTransmitInfo�������
 typedef struct tagNET_IN_ATTACH_TRANSMIT_INFO
 {
     DWORD                       dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_IN_ATTACH_TRANSMIT_INFO)
     AsyncTransmitInfoCallBack   cbTransmitInfo;                 // �ص�����
     LDWORD				         dwUser;                         // �û�����
     char*                       szInJsonBuffer;                 // Json��������,�û�����ռ�
     DWORD                       dwInJsonBufferSize;             // Json�������ݳ���  `
     BOOL						 bSubConnFirst;					 // TRUE-���豸֧��ʱ��ʹ�������ӷ�ʽ���ն������� FALSE-ֻ�������ӽ��ն�������
 }NET_IN_ATTACH_TRANSMIT_INFO;

///@brief CLIENT_AttachTransmitInfo�������
 typedef struct tagNET_OUT_ATTACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_OUT_ATTACH_TRANSMIT_INFO)
     BYTE*                   szOutBuffer;                    // Ӧ�𻺳��ַ,�û�����ռ�
     DWORD                   dwOutBufferSize;                // Ӧ�𻺳��ܳ���
     DWORD                   dwOutJsonLen;                   // Ӧ��Json���ݳ���
     DWORD                   dwOutBinLen;                    // Ӧ����������ݳ��� 
 } NET_OUT_ATTACH_TRANSMIT_INFO;

///@brief CLIENT_DetachTransmitInfo�������
 typedef struct tagNET_IN_DETACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_IN_DETACH_TRANSMIT_INFO)
     char*                   szInJsonBuffer;                 // Json��������,�û�����ռ�
     DWORD                   dwInJsonBufferSize;             // Json�������ݳ���
 } NET_IN_DETACH_TRANSMIT_INFO;

///@brief CLIENT_DetachTransmitInfo�������
 typedef struct tagNET_OUT_DETACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_OUT_DETACH_TRANSMIT_INFO)
     char*                   szOutBuffer;                    // Ӧ�����ݻ���ռ�, �û�����ռ�
     DWORD                   dwOutBufferSize;                // Ӧ�����ݻ���ռ䳤��
     DWORD                   dwOutJsonLen;                   // Ӧ��Json���ݳ���
 } NET_OUT_DETACH_TRANSMIT_INFO;

////�Ϻ�BUS//////
 
///@brief  �Ϻ���ʿ�������ͣ� ��ӦCLIENT_ControlSpecialDevice�ӿ�
typedef enum tagNET_SPECIAL_CTRL_TYPE
{
    NET_SPECIAL_CTRL_SHUTDOWN_PAD,            // �ر�PAD����, pInBuf��Ӧ����NET_IN_SHUTDOWN_PAD*, pOutBuf��Ӧ����NET_OUT_SHUTDOWN_PAD*
    NET_SPECIAL_CTRL_REBOOT_PAD,              // ����PAD����, pInBuf��Ӧ����NET_IN_REBOOT_PAD*, pOutBuf��Ӧ����NET_OUT_REBOOT_PAD*                 
} NET_SPECIAL_CTRL_TYPE;

 //////////////////////////////////////////////�豸�������ýṹ�嶨�忪ʼ////////////////////////////////////////////////////////////////////////////////////////////
///@brief CLIENT_DevSpecialCtrl �����������
 typedef enum tagEM_DEV_SPECIAL_CTRL_TYPE
 {
     DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH,                  // ����¼������ǿ��д��Ӳ��, pInBuf=NET_IN_RECORD_FLUSH_INFO* , pOutBuf=NET_OUT_RECORD_FLUSH_INFO*
 } EM_DEV_SPECIAL_CTRL_TYPE;
 
///@brief CLIENT_DevSpecialCtrl, ��Ӧ DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH �������
 typedef struct tagNET_IN_NET_IN_RECORD_FLUSH_INFO
 {
    DWORD                                      dwSize;       // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_IN_RECORD_FLUSH_INFO)               
    int                                        nChannel;     // ͨ����
    NET_STREAM_TYPE                            emStreamType; // ��������, ��Ч���� "main", "Extra1", "Extra2", "Extar3", "Snapshot"     
 }NET_IN_RECORD_FLUSH_INFO;

///@brief CLIENT_DevSpecialCtrl, ��Ӧ DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH �������
 typedef struct tagNET_OUT_RECORD_FLUSH_INFO
 {
     DWORD                                     dwSize;       // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_OUT_RECORD_FLUSH_INFO)              
 }NET_OUT_RECORD_FLUSH_INFO;
 
 //////////////////////////////////////////////�豸�������ýṹ�嶨�����////////////////////////////////////////////////////////////////////////////////////////////
 

typedef struct tagNET_IN_REBOOT_PAD
{
    DWORD               dwSize;                  // �û�ʹ�øýṹ��ʱ��dwSize �踳ֵΪ sizeof(NET_IN_REBOOT_PAD)
} NET_IN_REBOOT_PAD;

typedef struct tagNET_OUT_REBOOT_PADE
{
    DWORD               dwSize;                  // �û�ʹ�øýṹ��ʱ��dwSize �踳ֵΪ sizeof(NET_OUT_REBOOT_PAD)
} NET_OUT_REBOOT_PAD;

typedef struct tagNET_IN_SHUTDOWN_PAD
{
    DWORD               dwSize;                  // �û�ʹ�øýṹ��ʱ��dwSize �踳ֵΪ sizeof(NET_IN_REBOOT_PAD)
    int                 nDelayTime;              // ��ʱ�ػ�ʱ��, ��λ����
} NET_IN_SHUTDOWN_PAD;

typedef struct tagNET_OUT_SHUTDOWN_PAD
{
    DWORD               dwSize;                  // �û�ʹ�øýṹ��ʱ��dwSize �踳ֵΪ sizeof(NET_OUT_SHUTDOWN_PAD)
} NET_OUT_SHUTDOWN_PAD;

////////////////////////////////////////////�첽��͸���ṹ�嶨�����////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////�豸������Ϣ�ṹ�嶨�忪ʼ ////////////////////////////////////////////////////////////////////////////////////////////

typedef struct tagNET_DHDEV_ETHERNET_INFO
{
    DWORD               dwSize;                                 // �û�ʹ�øýṹ��ʱ��dwSize �踳ֵΪ sizeof(NET_DHDEV_ETHERNET_INFO)
    int                 nEtherNetNum;                           // ��̫������
    DH_ETHERNET_EX      stuEtherNet[DH_MAX_ETHERNET_NUM_EX];    // ��̫����
} NET_DHDEV_ETHERNET_INFO;

////////////////////////////////////////////�豸������Ϣ�ṹ�嶨�����////////////////////////////////////////////////////////////////////////////////////////////


///@brief ��ȡHCDZ�ɼ���Ϣ,�������
typedef struct tagNET_IN_HCDZ_LIST_INFO 
{
    DWORD                           dwSize;							//  �ṹ���С, �����߱����ʼ�����ֶ�
	UINT							nIndexNum;					   //����szindex��Ч����
    UINT                            szIndex[DH_COMMON_STRING_64]; //һ������,index ֵ��ͨ���±��Ӧ
}NET_IN_HCDZ_LIST_INFO;

///@brief  HCDZ�ɼ���Ϣ�����ģ��ɼ���Ϣ
typedef struct tagNET_HCDZ_INFO 
{
    UINT            nChannelID;								// ͨ����(��0��ʼ)
    UINT            nAIMode;								// AI��������ģʽ����  0 ��ʾ��������0-10000��Ӧ0-100%���� 1 ��ʾ4-20mA������ʽ����������0-10000��Ӧ4-20mA(20%-100%AI����)
	UINT            nAIO;									// ���ģ��ģ������ͨ������ 20��ʾ20mA 5��ʾ5V 10��ʾ10V
	UINT			nAnalogInputNum;						// ��Ч��ģ������������
    UINT            arrAnalogInput[DH_COMMON_STRING_8];     // ��һ������,���ģ��ģ��������Ĵ���ֵ �޷�����0-10000��Ӧ0-�����̣�ʵ��ֵ=DATA/10000*����AI0����λmA��V 
	UINT			nDINum;						            // ��Ч��ģģ�鿪������������
    UINT            arrDI[DH_COMMON_STRING_4];              // ���ģ�鿪��������ֵ����һ�����飬0Ϊ�أ�1Ϊ��
	UINT			nDONum;						            // ��Ч��ģ�鿪�����������
    UINT            arrDO[DH_COMMON_STRING_4];              // ���ģ�鿪�������ֵ����һ�����飬0Ϊ�أ�1Ϊ��
}NET_HCDZ_INFO;

///@brief  ��ȡHCDZ�ɼ���Ϣ,�������
typedef struct tagNET_OUT_HCDZ_LIST_INFO 
{
    DWORD                       dwSize;                             // �ṹ���С, �����߱����ʼ�����ֶ�
	UINT				        nValidNum;						    // ����stuInfo����Ч����
    NET_HCDZ_INFO				stuInfo[DH_COMMON_STRING_64];       // HCDZ�ɼ���Ϣ
}NET_OUT_HCDZ_LIST_INFO;

typedef struct tagNET_IN_HCDZ_CAPS 
{
    DWORD                           dwSize;                          // �ṹ���С, �����߱����ʼ�����ֶ�
}NET_IN_HCDZ_CAPS;

///@brief  ��ȡHCDZ(�ݲ����)�����ṹ��
typedef struct tagCFG_HCDZ_CAPS
{
	DWORD                               dwSize;                                 // �ṹ���С, �����߱����ʼ�����ֶ�
	char								szModelID[DH_COMMON_STRING_32];		    // �豸�ͺ�
	unsigned int						nVersion;								// �汾
	unsigned int						nAnalogsNum;							// ���ģ��ģ�����������
	unsigned int						nDINum;									// ���ģ�鿪�����������
	unsigned int						nDONum;									// ���ģ�鿪�����������
}NET_OUT_HCDZ_CAPS;

///@brief  ��ȡ����״̬(HADTɽ����³��갲����),�������
typedef struct tagNET_IN_HADT_STATUS
{
    DWORD                               dwSize;                                 // �ṹ���С, �����߱����ʼ�����ֶ�
}NET_IN_HADT_STATUS;

///@brief  ��ȡ����״̬(HADTɽ����³��갲����),�������
typedef struct tagNET_OUT_HADT_STATUS
{
    DWORD                               dwSize;                                 // �ṹ���С, �����߱����ʼ�����ֶ�
    int                                 nLevelSignal1;                          // ¥���ź�ֵ�����ڻ�ȡ¥��ĸ�λ����Ϣ����Χ(0~37)�ɿͻ���ȡֵ�����н���
    int                                 nLevelSignal2;                          // ¥���ź�ֵ�����ڻ�ȡ¥���ʮλ����Ϣ����Χ(0~37)�ɿͻ���ȡֵ�����н���
    int                                 nLevelSignal3;                          // ¥���ź�ֵ�����ڻ�ȡ¥��İ�λ����Ϣ����Χ(0~37)�ɿͻ���ȡֵ�����н��� 
    DWORD                               dwliftStatus;                           // ����״̬��Ϣ��ÿһλ����һ��״̬
                                                                                // bit0: ���𣻸�λ��1��ʾ������0��ʾû�е���
                                                                                // bit1: �Ծȣ���λ��1��ʾ�Ծȣ���0��ʾû���Ծ�
                                                                                // bit2: ���أ���λ��1��bit3��bit12��0��ʾ���أ�������ʾ��Ч
                                                                                // bit3: ���أ���λ��1��bit2��bit12��0��ʾ���أ�������ʾ��Ч
                                                                                // bit4: ��������λ��1��ʾ��������0��ʾû������
                                                                                // bit5: ���ޣ���λ��1��ʾ���ޣ���0��ʾû�м���
                                                                                // bit6: ���У���λ��1��bit7��0���У�������ʾ��Ч
                                                                                // bit7: ���У���λ��1��bit6��0��ʾ���У�������ʾ��Ч
                                                                                // bit8: ������վ����λ��1��ʾ��������վ����0��ʾû��������վ
                                                                                // bit12: ���أ���λ��1��bit2��bit3��0��ʾ���أ�������ʾ��Ч
                                                                                // bit13: ֹͣ/���У���λ��1��ʾ���У���0��ʾֹͣ
                                                                                // bit14: ���ţ���λ��1��bit15��0��ʾ���ţ�������ʾ��Ч
                                                                                // bit15: ���ţ���λ��1��bit14��0��ʾ���ţ�������ʾ��Ч
}NET_OUT_HADT_STATUS;

///@brief ����������ƽӿ�CLIENT_SetAlarmOut���������
typedef struct tagNET_IN_SET_ALARMOUT
{
    DWORD                               dwSize;                                 // �ṹ���С����Ҫ��ֵ
    int                                 nChannel;                               // ͨ���ţ���0��ʼ
    int                                 nTime;                                  // time > 0 ʱ, time��Ч����λ:��
    int                                 nLevel;                                 // time = 0 ʱ, level��Ч��time��level��Ϊ0ʱ����ʾֹͣ
}NET_IN_SET_ALARMOUT;

///@brief ����������ƽӿ�CLIENT_SetAlarmOut���������
typedef struct tagNET_OUT_SET_ALARMOUT
{   
    DWORD                               dwSize;                                 // �ṹ���С,��Ҫ��ֵ
}NET_OUT_SET_ALARMOUT;

///@brief  ¼������
typedef enum tagEM_NET_LINK_RECORD_EVENT
{
    EM_NET_LINK_RECORD_UNKNOWN,                         // δ֪
    EM_NET_LINK_RECORD_ALARM,                           // Alarm
} EM_NET_LINK_RECORD_EVENT;

///@brief CLIENT_StartLinkRecord�������
typedef struct tagNET_IN_LINK_RECORD_CTRL
{
    DWORD                       dwSize;                 // �ýṹ���С
    unsigned int                nChannel;               // ͨ����
    unsigned int                nLength;                // ¼��ʱ��
    EM_NET_LINK_RECORD_EVENT    emType;                 // ¼������"Alarm"-����¼�񣬵�ǰ��֧������¼��
} NET_IN_LINK_RECORD_CTRL;

///@brief CLIENT_StartLinkRecord�������
typedef struct tagNET_OUT_LINK_RECORD_CTRL
{
    DWORD                       dwSize;                 // �ýṹ���С
} NET_OUT_LINK_RECORD_CTRL;

///@brief  CLIENT_SetDeviceUkey�������
typedef struct tagNET_IN_SET_UEKY
{
    DWORD                       dwSize;                 // �ýṹ���С
    char                        szUkey[128];             // Ukey��
}NET_IN_SET_UEKY;

///@brief  CLIENT_SetDeviceUkey �������
typedef struct tagNET_OUT_SET_UEKY
{
    DWORD                       dwSize;                 // �ýṹ���С
}NET_OUT_SET_UEKY;

///@brief  ��������	:	����¼���ļ�--��չ,�ɼ�������ת����	
///@param[in] lLoginID:       ��¼�ӿڷ��صľ��
///@param[in] lpRecordFile:   ��ѯ¼��ӿڷ��ص�¼����Ϣ
///@param[in] sSavedFileName: ����¼���ļ���,֧��ȫ·��
///@param[in] cbDownLoadPos:  ���ؽ��Ȼص�����(�ص����ؽ���,���ؽ��)
///@param[in] dwUserData:     ���ؽ��Ȼص���Ӧ�û�����
///@param[in] fDownLoadDataCallBack: ¼�����ݻص�����(�ص���ʽ�ݲ�֧��ת��PS��)
///@param[in] dwDataUser:     ¼�����ݻص���Ӧ�û�����
///@param[in] scType:         ����ת������,0-DAV����(Ĭ��); 1-PS��
///@param[in] pReserved:      �����ֶ�,������չ
///@return  	��	LLONG ����¼����
//����˵��	��	����ӿ�,SDKĬ�ϲ�֧��תPS��,�趨��SDK

CLIENT_NET_API LLONG CALL_METHOD CLIENT_DownloadByRecordFileEx2(LLONG lLoginID, LPNET_RECORDFILE_INFO lpRecordFile, char *sSavedFileName, 
                                                    fDownLoadPosCallBack cbDownLoadPos, LDWORD dwUserData, 
                                                    fDataCallBack fDownLoadDataCallBack, LDWORD dwDataUser, 
                                                    int scType = 0, void* pReserved = NULL);


///@brief  ��������	:	ͨ��ʱ������¼��--��չ,�ɼ�������ת����
///@param[in]     lLoginID:       ��¼�ӿڷ��صľ��
///@param[in]     nChannelId:     ��Ƶͨ����,��0��ʼ
///@param[in]     nRecordFileType:¼������ 0 ����¼���ļ�
/*                                         1 �ⲿ���� 
*                                          2 ��̬��ⱨ�� 
*                                          3 ���б��� 
*                                          4 ���Ų�ѯ  
*                                          5 ���������ѯ 
*                                          6 ¼��λ����ƫ�������� 
*                                          8 �����Ų�ѯͼƬ(Ŀǰ��HB-U��NVS�����ͺŵ��豸֧��) 
*                                          9 ��ѯͼƬ(Ŀǰ��HB-U��NVS�����ͺŵ��豸֧��)  
*                                          10 ���ֶβ�ѯ 
*                                          15 �����������ݽṹ(��������) 
*                                          16 ��ѯ����͸��������¼���ļ� 
*/
///@param[in]     tmStart:        ��ʼʱ�� 
///@param[in]     tmEnd:          ����ʱ�� 
///@param[in]     sSavedFileName: ����¼���ļ���,֧��ȫ·��
///@param[in]     cbTimeDownLoadPos: ���ؽ��Ȼص�����(�ص����ؽ���,���ؽ��)
///@param[in]     dwUserData:     ���ؽ��Ȼص���Ӧ�û�����
///@param[in]     fDownLoadDataCallBack: ¼�����ݻص�����(�ص���ʽ�ݲ�֧��ת��PS��)
///@param[in]     dwDataUser:     ¼�����ݻص���Ӧ�û�����
///@param[in]     scType:         ����ת������,0-DAV����(Ĭ��); 1-PS��,3-MP4
///@param[in]     pReserved:      ��������,������չ
///@return 	��	LLONG ����¼����
//����˵��	��	����ӿ�,SDKĬ�ϲ�֧��תPS��,�趨��SDK
/******************************************************************************/
CLIENT_NET_API LLONG CALL_METHOD CLIENT_DownloadByTimeEx2(LLONG lLoginID, int nChannelId, int nRecordFileType, 
                                                    LPNET_TIME tmStart, LPNET_TIME tmEnd, char *sSavedFileName, 
                                                    fTimeDownLoadPosCallBack cbTimeDownLoadPos, LDWORD dwUserData, 
                                                    fDataCallBack fDownLoadDataCallBack, LDWORD dwDataUser, 
                                                    int scType = 0, void* pReserved = NULL);


///@brief  ��������	:	͸����չ�ӿ�,��͸�������߶�Ӧ͸����ʽ�ӿڣ�Ŀǰ֧��F6��͸��, ͬʱ����CLIENT_TransmitInfoForWeb�ӿ�
///@param[in]    lLoginID:       ��¼�ӿڷ��صľ��
///@param[in]    pInParam:       ͸����չ�ӿ��������
///@param[in]    pOutParam       ͸����չ�ӿ��������
///@param[in]   nWaittime       �ӿڳ�ʱʱ��
///@return	��	BOOL  TRUE :�ɹ�; FALSE :ʧ��
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_TransmitInfoForWebEx(LLONG lLoginID, NET_IN_TRANSMIT_INFO* pInParam, 
                                                             NET_OUT_TRANSMIT_INFO* pOutParam, int nWaittime = 3000);



///@brief  ��������	:	 �첽��͸�����Ľӿ�	
///@param[in]    lLoginID:       ��¼�ӿڷ��صľ��
///@param[in]    pInParam:       �첽��͸���ӿ��������
///@param[in]    pOutParam       �첽��͸���ӿ��������
///@param[in]    nWaittime       �ӿڳ�ʱʱ��
///@return	��	    LLONG �첽��͸�����
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachTransmitInfo(LLONG lLoginID, const NET_IN_ATTACH_TRANSMIT_INFO* pInParam, NET_OUT_ATTACH_TRANSMIT_INFO* pOutParam, int nWaitTime);

 


///@brief  ��������	:	 �첽��͸��ȡ�����Ľӿ�	
///@param[in]    lAttachHandle:  �첽��͸���������CLIENT_AttachTransmitInfo�ӿڵķ���ֵ
///@param[in]    pInParam:       �첽��͸��ȡ�����Ľӿ��������
///@param[in]    pOutParam       �첽��͸��ȡ�����Ľӿ��������
///@param[in]    nWaittime       �ӿڳ�ʱʱ��
///@return	��		BOOL  TRUE :�ɹ�; FALSE :ʧ��
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_DetachTransmitInfo(LLONG lAttachHandle, const NET_IN_DETACH_TRANSMIT_INFO* pInParam, NET_OUT_DETACH_TRANSMIT_INFO* pOutParam, int nWaitTime);



///@brief  ��������	:	 �豸������ƽӿ�
///@param[in]    lLoginID:                       ��¼�ӿڷ��صľ��
///@param[in]    EM_DEV_SPECIAL_CTRL_TYPE:       �����������
///@param[in]    pInParam:                       �豸������ƽӿ��������
///@param[in]    pOutParam                       �豸������ƽӿ��������
///@param[in]   nWaittime                       �ӿڳ�ʱʱ��
///@return	��		BOOL  TRUE :�ɹ�; FALSE :ʧ��
CLIENT_NET_API  BOOL CALL_METHOD CLIENT_DevSpecialCtrl(LLONG lLoginID, EM_DEV_SPECIAL_CTRL_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime = 3000);



///@brief  ��������	:	 ��ȡ�豸������Ϣ�ӿ�		
///@param[in]    lLoginID:                       ��¼�ӿڷ��صľ��
///@param[in]    pstOutParam                     ��ȡ�豸������Ϣ�ӿڵ��������
///@param[in]    nWaittime                       �ӿڳ�ʱʱ��
///@return	��		BOOL  TRUE :�ɹ�; FALSE :ʧ��
CLIENT_NET_API  BOOL CALL_METHOD CLIENT_QueryEtherNetInfo(LLONG lLoginID, NET_DHDEV_ETHERNET_INFO* pstuOutParam, int nWaitTime = 3000);

////�Ϻ�BUS//////

///@brief  �������ݽ����ӿ�,�첽��ȡ����
CLIENT_NET_API LLONG CALL_METHOD CLIENT_ExChangeData(LLONG lLoginId, NET_IN_EXCHANGEDATA* pInParam, NET_OUT_EXCHANGEDATA* pOutParam, int nWaittime = 5000);

///@brief  ����CAN��������
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachCAN(LLONG lLoginID, const NET_IN_ATTACH_CAN* pstInParam, NET_OUT_ATTACH_CAN* pstOutParam, int nWaitTime = 3000);

///@brief  ȡ������CAN�������ݣ�lAttachHandle��CLIENT_AttachCAN����ֵ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachCAN(LLONG lAttachHandle);

///@brief  ����CAN��������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SendCAN(LLONG lLoginID, const NET_IN_SEND_CAN* pstInParam, NET_OUT_SEND_CAN* pstOutParam, int nWaitTime = 3000);

///@brief  ����͸����������
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachDevComm(LLONG lLoginID, const NET_IN_ATTACH_DEVCOMM* pstInParam, NET_OUT_ATTACH_DEVCOMM* pstOutParam, int nWaitTime = 3000);

///@brief  ȡ������͸���������ݣ�lAttachHandle��CLIENT_AttachDevComm����ֵ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachDevComm(LLONG lAttachHandle);

///@brief  �Ϻ���ʿ�豸���ƽӿڣ���������PAD�ػ���������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_ControlSpecialDevice(LLONG lLoginID, NET_SPECIAL_CTRL_TYPE emType, void* pInBuf, void* pOutBuf = NULL, int nWaitTime = NET_INTERFACE_DEFAULT_TIMEOUT);

///@brief ��ȡHCDZ�ɼ���Ϣ
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_GetHCDZInfo(LLONG lLoginID, const NET_IN_HCDZ_LIST_INFO* pInParam, NET_OUT_HCDZ_LIST_INFO* pOutParam, int nWaitTime = 3000);

///@brief ��ȡHCDZ������
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_GetHCDZCaps(LLONG lLoginID, const NET_IN_HCDZ_CAPS* pInParam, NET_OUT_HCDZ_CAPS* pOutParam, int nWaitTime = 3000);


///@brief  ������̨�����Կ�������ͼ���������öԵ�ǰ���е�¼����̨�豸����Ч����λms�����ʱ�������100ms��������Ч��
CLIENT_NET_API void CALL_METHOD CLIENT_PTZCmdSendIntervalTime(DWORD dwIntervalTime);


///@brief  ��������:��ȡHADT(ɽ����³��갲����)����״̬
///@param[in]    lLoginID:��¼�ӿڷ��صľ��
///@param[in]    pInBuf  :�������,���ʼ��dwSize
///@param[in]    pOutBuf :�������,���ʼ��dwSize
///@param[in]    nWaitTime :�ӿڳ�ʱʱ��
///@return:	BOOL  TRUE :�ɹ�; FALSE :ʧ��
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetHADTStatus(LLONG lLoginID, const NET_IN_HADT_STATUS* pInBuf, NET_OUT_HADT_STATUS* pOutBuf,int nWaitTime = 3000);


///@brief  ��������:���Ʊ�����������ض��ƣ�
///@param[in]    lLoginID:��¼�ӿڷ��صľ��
///@param[in]    pInBuf  :�������,���ʼ��dwSize
///@param[in]    pOutBuf :�������,���ʼ��dwSize
///@param[in]    nWaitTime :�ӿڳ�ʱʱ��
///@return:	BOOL  TRUE :�ɹ�; FALSE :ʧ��
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetAlarmOut(LLONG lLoginID, const NET_IN_SET_ALARMOUT* pInBuf, NET_OUT_SET_ALARMOUT* pOutBuf,int nWaitTime);

///@brief ����EVS��ʱ¼��
CLIENT_NET_API BOOL CALL_METHOD CLIENT_StartLinkRecord(LLONG lLoginID, const NET_IN_LINK_RECORD_CTRL *pstIn, NET_OUT_LINK_RECORD_CTRL *pstOut, int nWaitTime);

/// �����������ƽӿڣ�����Ukeyֵ
///@brief  ��������:�豸�˴ε�½��Ukeyֵ
///@param[in]    lLoginID:��¼�ӿڷ��صľ��
///@param[in]    pInBuf  :�������,���ʼ��dwSize
///@param[in]   pOutBuf :�������,���ʼ��dwSize
///@param[in]    nWaitTime :�ӿڳ�ʱʱ��
///@return:	BOOL  TRUE :�ɹ�; FALSE :ʧ��
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetDeviceUkey(LLONG lLoginID, const NET_IN_SET_UEKY *pInBuf, NET_OUT_SET_UEKY *pOutBuf, int nWaitTime);

typedef struct tagNET_IN_NETACCESS
{
	DWORD		dwSize;									// �ṹ���С
	char		szMac[DH_MACADDR_LEN];					// �豸mac��ַ
	char		szSecurity[MAX_SECURITY_CODE_LEN];		// ��ȫ��
	BYTE		byInitStaus;							// �豸��ʼ��״̬�������豸�ӿ�(CLIENT_SearchDevices��CLIENT_StartSearchDevices�Ļص�������CLIENT_SearchDevicesByIPs)�����ֶ�byInitStatus��ֵ
	BYTE		byReserved[3];							// �����ֶ�
}NET_IN_NETACCESS;
typedef struct tagNET_OUT_NETACCESS
{
	DWORD		dwSize;					// �ṹ���С
}NET_OUT_NETACCESS;
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetNetAccess(const NET_IN_NETACCESS* pNetAccessIn, NET_OUT_NETACCESS* pNetAccessOut, DWORD dwWaitTime, char* szLocalIp);

///@brief  ��ӦCLIENT_StartSearchCustomDevices�ӿ�
///@brief  ����OEM�豸����ö��
typedef enum tagEM_SEARCH_OEM_DEVICE_TYPE
{
	EM_TYPE_JIANGSU_CHUANGTONG = 0,    // ���մ�ͨOEM�豸����
	EM_TYPE_MAX,					   // ���ö��ֵ
}EM_SEARCH_OEM_DEVICE_TYPE;

///@brief  OEM�豸��Ϣ
typedef struct tagCUSTOM_DEVICE_NETINFO
{
	char                szMac[DH_MACADDR_LEN];                  // MAC��ַ,��00:40:9D:31:A9:0A
	char                szIP[DH_MAX_IPADDR_EX_LEN];				// IP��ַ,��10.0.0.231
	char                szDevName[DH_MACHINE_NAME_NUM];         // �豸����,�̶�ΪWireless Transmission Device
	BYTE				byReserved[1024];						// �����ֽ�
}CUSTOM_DEVICE_NETINFO;

///@brief  �첽����OEM�豸�ص���pCustomDevNetInf�ڴ���SDK�ڲ������ͷţ�
typedef void (CALLBACK *fSearchCustomDevicesCB)(CUSTOM_DEVICE_NETINFO *pCustomDevNetInfo, void* pUserData);

///@brief  CLIENT_StartSearchCustomDevices�ӿڵ��������
typedef struct tagNET_IN_SEARCH_PARAM 
{
	DWORD							dwSize;                  // �ṹ���С
	fSearchCustomDevicesCB			cbFunc;			         // ����OEM�豸�ص�����
	void*							pUserData;               // �û�������Զ�������
	char*							szLocalIp;				 // ����IP
	EM_SEARCH_OEM_DEVICE_TYPE       emSearchOemDeviceType;   //	����OEM�豸����
}NET_IN_SEARCH_PARAM;

///@brief  CLIENT_StartSearchCustomDevices���������
typedef struct tagNET_OUT_SEARCH_PARAM
{
	DWORD		dwSize;
}NET_OUT_SEARCH_PARAM;

///@brief  �첽�鲥����OEM�豸, (pInParam, pOutParam�ڴ����û������ͷ�),��֧�ֶ��̵߳���,�����Ʒ������
CLIENT_NET_API LLONG CALL_METHOD CLIENT_StartSearchCustomDevices(const NET_IN_SEARCH_PARAM *pInParam, NET_OUT_SEARCH_PARAM *pOutParam); 
///@brief  ֹͣ�鲥����OEM�豸
CLIENT_NET_API BOOL CALL_METHOD CLIENT_StopSearchCustomDevices(LLONG lSearchHandle);

///@brief  �豸��¼�������
typedef struct tagNET_IN_LOGIN_POLICY_PARAM
{
	DWORD               dwSize;
	int		            nDevicePort;							// �豸�˿ں�
	char		        *szDeviceIp;			                // �豸ip��ַ    
	char		        *szUserName;		                    // �û���
	char 		        *szPassword;		                    // �û�����

	EM_LOGIN_SPAC_CAP_TYPE 		emSpecCap;				        // ��½����, Ŀǰ��֧�� TCP / Mobile / P2P ��¼
	void	            *pCapParam; 							// ��½��������, ����������emSpeCap���

	int                 nLoginPolicyFlag;                       // ��¼���Ա�־λ
	// bit0 == 1 ���ٵ�¼: �豸��Ϣ ���к�/��������/���������Ч 

	int                 nPlayPolicyFlag;                        // ʵʱԤ�����Ա�־λ
	// bit0 == 1 ��֧�ֻ��л�

	int                 nPlayBackPolicyFlag;					// ¼��طź�¼���ѯ���Ա�־λ
	// bit0 == 1 ����ѯ���л�����

}NET_IN_LOGIN_POLICY_PARAM;

///@brief  �豸��¼���Գ���
typedef struct tagNET_OUT_LOGIN_POLICY_PARAM
{
	DWORD               dwSize;
	NET_DEVICEINFO_Ex   stuDeviceInfo;                          // �豸��Ϣ
}NET_OUT_LOGIN_POLICY_PARAM;


///@brief  ��¼��չ�ӿ�, ֧�ֲ���
CLIENT_NET_API LLONG CALL_METHOD CLIENT_LoginWithPolicy(const NET_IN_LOGIN_POLICY_PARAM* pstInParam, NET_OUT_LOGIN_POLICY_PARAM* pstOutParam, int nWaitTime);

/**************************** �ֳ��豸ר�ýӿ�  Start  ********************************/
///@brief  ��ʼ���豸�˻�����ṹ��
typedef struct tagNET_IN_INIT_DEVICE_ACCOUNT_BY_PORT
{
	DWORD					dwSize;										// �ṹ���С:��ʼ���ṹ��ʱ��ֵ
	char					szMac[DH_MACADDR_LEN];						// �豸mac��ַ	
	char					szUserName[MAX_USER_NAME_LEN];				// �û���
	char					szPwd[MAX_PWD_LEN];							// �豸����
	char					szCellPhone[MAX_CELL_PHONE_NUMBER_LEN];		// Ԥ���ֻ���
	char					szMail[MAX_MAIL_LEN];						// Ԥ������
	BYTE					byInitStatus;								// ���ֶ��Ѿ�����															
	BYTE					byPwdResetWay;								// �豸֧�ֵ��������÷�ʽ�������豸�ӿ�(CLIENT_SearchDevices��CLIENT_StartSearchDevices�Ļص�������CLIENT_SearchDevicesByIPs)�����ֶ�byPwdResetWay��ֵ	
																		// ��ֵ�ľ��庬��� DEVICE_NET_INFO_EX �ṹ�壬��Ҫ���豸�����ӿڷ��ص� byPwdResetWay ֵ����һ��
																		// bit0 : 1-֧��Ԥ���ֻ��ţ���ʱ��Ҫ��szCellPhone����������Ԥ���ֻ���(�����Ҫ����Ԥ���ֻ�) ; 
																		// bit1 : 1-֧��Ԥ�����䣬��ʱ��Ҫ��szMail����������Ԥ������(�����Ҫ����Ԥ������)
	int						nPort;										// �˿ں� : �ֳ��豸���鲥�˿ں�
}NET_IN_INIT_DEVICE_ACCOUNT_BY_PORT;

///@brief  ��ʼ���豸�˻�����ṹ��
typedef struct tagNET_OUT_INIT_DEVICE_ACCOUNT_BY_PORT
{
	DWORD					dwSize;										// �ṹ���С:��ʼ���ṹ��ʱ��ֵ
}NET_OUT_INIT_DEVICE_ACCOUNT_BY_PORT;

///@brief  ��ʼ���ֳ��豸�˻�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_InitDevAccountByPort(const NET_IN_INIT_DEVICE_ACCOUNT_BY_PORT* pInitAccountIn, NET_OUT_INIT_DEVICE_ACCOUNT_BY_PORT* pInitAccountOut, DWORD dwWaitTime, char* szLocalIp);

///@brief  ������������ṹ��
typedef struct tagNET_IN_RESET_PWD_BY_PORT
{
	DWORD					dwSize;								// �ṹ���С:��ʼ���ṹ��ʱ��ֵ
	char					szMac[DH_MACADDR_LEN];				// �豸mac��ַ	
	char					szUserName[MAX_USER_NAME_LEN];		// �û���
	char					szPwd[MAX_PWD_LEN];					// ����
	char					szSecurity[MAX_SECURITY_CODE_LEN];	// ƽ̨���͵�Ԥ���ֻ��������еİ�ȫ��
	BYTE					byInitStaus;						// �豸��ʼ��״̬�������豸�ӿ�(CLIENT_SearchDevices��CLIENT_StartSearchDevices�Ļص�������CLIENT_SearchDevicesByIPs)�����ֶ�byInitStatus��ֵ
	BYTE					byPwdResetWay;						// �豸֧�ֵ��������÷�ʽ�������豸�ӿ�(CLIENT_SearchDevices��CLIENT_StartSearchDevices�Ļص�������CLIENT_SearchDevicesByIPs)�����ֶ�byPwdResetWay��ֵ
	BYTE					byReserved[2];						// �����ֶ�			
	char                    szContact[MAX_CONTACT_LEN];         // �û����밲ȫ����������հ�ȫ�����ϵ��ʽ�����bSetContactΪTRUE�������ϵ��ʽ����ΪԤ����ϵ��ʽ
	BOOL                    bSetContact;                        // �Ƿ�ͬ������ΪԤ���ֻ���, TRUE:ͬ��; FALSE:��ͬ��
	int						nPort;								// �˿ں� : �ֳ��豸���鲥�˿ں�
}NET_IN_RESET_PWD_BY_PORT;

///@brief  ������������ṹ��
typedef struct tagNET_OUT_RESET_PWD_BY_PORT
{
	DWORD					dwSize;// �ṹ���С:��ʼ���ṹ��ʱ��ֵ
}NET_OUT_RESET_PWD_BY_PORT;

///@brief  �����ֳ��豸����
CLIENT_NET_API BOOL CALL_METHOD CLIENT_ResetPwdByPort(const NET_IN_RESET_PWD_BY_PORT* pResetPwdIn, NET_OUT_RESET_PWD_BY_PORT* pResetPwdOut, DWORD dwWaitTime, char* szLocalIp);

///@brief  ��ȡ����������Ϣ����ṹ��
typedef struct tagNET_IN_DESCRIPTION_FOR_RESET_PWD_BY_PORT
{
	DWORD					dwSize;								// �ṹ���С:��ʼ���ṹ��ʱ��ֵ
	char					szMac[DH_MACADDR_LEN];				// �豸mac��ַ
	char					szUserName[MAX_USER_NAME_LEN];		// �û���	
	BYTE					byInitStatus;						// �豸��ʼ��״̬�������豸�ӿ�(CLIENT_SearchDevices��CLIENT_StartSearchDevices�Ļص�������CLIENT_SearchDevicesByIPs)�����ֶ�byInitStatus��ֵ
	int						nPort;								// �˿ں� : �ֳ��豸���鲥�˿ں�
}NET_IN_DESCRIPTION_FOR_RESET_PWD_BY_PORT;

///@brief  ��ȡ����������Ϣ����ṹ��
typedef struct tagNET_OUT_DESCRIPTION_FOR_RESET_PWD_BY_PORT
{
	DWORD			dwSize;										// �ṹ���С:��ʼ���ṹ��ʱ��ֵ
	char			szCellPhone[MAX_CELL_PHONE_NUMBER_LEN];		// Ԥ���ֻ���
	char			szMailAddr[MAX_MAIL_LEN];					// Ԥ������
	char*			pQrCode;									// ��ά����Ϣ,�û������ڴ棨��ǰ��СΪ360�ֽڣ�
	unsigned int	nQrCodeLen;									// �û�����Ķ�ά����Ϣ����
	unsigned int    nQrCodeLenRet;								// �豸���صĶ�ά����Ϣ����
}NET_OUT_DESCRIPTION_FOR_RESET_PWD_BY_PORT;

///@brief  ��ȡ�ֳ��豸��������Ϣ:�ֻ��š����䡢��ά����Ϣ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDescriptionForResetPwdByPort(const NET_IN_DESCRIPTION_FOR_RESET_PWD_BY_PORT* pDescriptionIn, NET_OUT_DESCRIPTION_FOR_RESET_PWD_BY_PORT* pDescriptionOut, DWORD dwWaitTime, char* szLocalIp);


/****************************  �ֳ��豸ר�ýӿ�  End  ********************************/

///@brief  CLIENT_TriggerAutoInspection �ӿ����
typedef struct tagNET_IN_TRIGGER_AUTO_INSPECTION
{
	DWORD dwSize;
}NET_IN_TRIGGER_AUTO_INSPECTION;

///@brief  CLIENT_TriggerAutoInspection �ӿڳ���
typedef struct tagNET_OUT_TRIGGER_AUTO_INSPECTON
{
	DWORD dwSize;
}NET_OUT_TRIGGER_AUTO_INSPECTON;

///@brief  �����豸�Լ죨¥���Ʒ��ר������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_TriggerAutoInspection(LLONG lLoginID, const NET_IN_TRIGGER_AUTO_INSPECTION* pstInParam, NET_OUT_TRIGGER_AUTO_INSPECTON* pstOutParam, int nWaitTime);

///@brief  CLIENT_GetLicenseAssistInfo �ӿ����
typedef struct tagNET_IN_GET_LICENSE_INFO
{
	DWORD dwSize;								// ��ֵΪ�ṹ���С
	int	  nChannel;								// ��Ȩ�豸ͨ����
}NET_IN_GET_LICENSE_INFO;

///@brief  ��Ҫ��License���ƵĿ���Ϣ
typedef struct tagNET_RESTRICTED_LIB_INFO
{
	char szId[40];								// �����ƿ�Id
	char szVersion[32];							// �����ƿ�İ汾
	char szKey1[128];							// ����Ҫ���ض���Ϣ1���������������ƿ�ȷ��
	char szKey2[128];							// ����Ҫ���ض���Ϣ2���������������ƿ�ȷ��
	char szKey3[128];							// ����Ҫ���ض���Ϣ3���������������ƿ�ȷ��
	char szKey4[128];							// ����Ҫ���ض���Ϣ4���������������ƿ�ȷ��
	char szReserved[1024];						// �����ֶ�
}NET_RESTRICTED_LIB_INFO;


///@brief �Զ��豸��Ȩ
typedef struct tagNET_MULTIPLE_AUTH_INFO
{
	
	int		nIndex;								// �豸�±�id
	int		nTotalDevices;						// �豸����
	char	szReserved[256];					// �����ֶ�
}NET_MULTIPLE_AUTH_INFO;

///@brief  CLIENT_GetLicenseAssistInfo �ӿڳ���
typedef struct tagNET_OUT_GET_LICENSE_INFO
{
	DWORD dwSize;								// ��ֵΪ�ṹ���С
	char  szSeriesNum[32];						// �豸���к�
	char  szMac[8][32];							// �豸Mac ��ַ
	int   nMacRet;								// ���ص�Mac��ַ����
	char  szBindInfo[256];						// ����Ϣ
	char  szAppVersion[32];						// Ӧ�ó���汾
	char  szAppVerificationCode[512];			// Ӧ�ó���У����Ϣ	
	char  szLicenseLibVsersion[32];				// License �����汾��Ϣ
	NET_RESTRICTED_LIB_INFO stuLibInfo[8];		// ��Ҫ��License���ƵĿ���Ϣ
	int	  nLibInfoRet;							// ���ص�stuLibInfo�ṹ������
	NET_MULTIPLE_AUTH_INFO	stuMultipleAuth;	// �Զ��豸��Ȩ
}NET_OUT_GET_LICENSE_INFO;

///@brief  ��ȡ����License�ĸ�����Ϣ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetLicenseAssistInfo(LLONG lLoginID, const NET_IN_GET_LICENSE_INFO* pstInParam, NET_OUT_GET_LICENSE_INFO* pstOutParam, int nWaitTime);



///@brief  ����Licenced�ĳ������
typedef struct tagNET_IN_GETVENDOR
{
	DWORD				dwSize;						// �˽ṹ���С
}NET_IN_GETVENDOR;

///@brief  Licence�Ķ�Ӧ��Ϣ
typedef struct tagNET_VENDOR_INFO
{
	char				szVendorId[32];				// ��������������id
	int					nClassNum;					// �����㷨����
	char				szClass[32][8];				// �����������㷨����
	BYTE				bReserved[512];				// Ԥ���ֽ�
}NET_VENDOR_INFO;

///@brief  ����Licence�ĳ��ҳ���
typedef struct tagNET_OUT_GETVENDOR
{
	DWORD				dwSize;						// �˽ṹ���С
	int					nVendorNum;					// ��Ϣ����
	NET_VENDOR_INFO		stuVendorInfo[8];			// ��Ϣ�����Ϊ8��
}NET_OUT_GETVENDOR;


///@brief  ��������������License�ĸ�����Ϣ���
typedef struct tagNET_IN_GETTHIRDASSISTED_INFO
{
	DWORD				dwSize;						// �˽ṹ���С
	NET_VENDOR_INFO		stuVendorInfo;				// ��������������license�ĸ�����Ϣ
}NET_IN_GETTHIRDASSISTED_INFO;

///@brief  ��Ҫ������Ȩ�ĵ������Ĳ�����Ϣ
typedef struct tagNET_DEVICE_INFO
{
	char				szSN[32];					// ���к�
	int					nMacNum;					// MAC��ַ����
	char				szMac[8][32];				// MAC��ַ��ð��+��д
	char				szAppVersion[16];			// Ӧ�ó���汾
	BYTE				bReserved[512];				// Ԥ���ֽ�
}NET_DEVICE_INFO;

///@brief  ��Ҫ������Ȩ�ĵ������Ĳ�����Ϣ
typedef struct tagNET_THIRD_INFO
{
	char				szVendor[32];				// ������������
	int					nClassNum;					// �����㷨����
	char				szClass[32][8];				// �����������㷨����
	char				szData[4096];				// ���ɵĵ�������ɼ�����Ϣ��Ϊ��ֹ�������ַ���Ҫ����base64���롣��Բ�ͬ��������˾���Ӧ��data����Ҳ����ͬ�� 
	BYTE				bReserved[4392];			// Ԥ���ֽ�
}NET_THIRD_INFO;

///@brief  ��������������License�ĸ�����Ϣ����
typedef struct tagNET_OUT_GETTHIRDASSISTED_INFO
{
	DWORD				dwSize;						// �˽ṹ���С
	NET_DEVICE_INFO		stuDeviceInfo;				// �豸���ͨ����Ϣ
	NET_THIRD_INFO		stuThirdInfo;				// ��Ҫ������Ȩ�ĵ������Ĳ�����Ϣ
}NET_OUT_GETTHIRDASSISTED_INFO;

///@brief  ���������������license�����
typedef struct tagNET_IN_SETTHIRD_LICENSE
{
	DWORD				dwSize;						// �˽ṹ���С
	char				szVendorId[32];				// ��������������ID
	int					nClassNum;					// �����㷨����
	char				szClass[32][8];				// �����������㷨����
	char				szLicense[8192];			// ������license���� base64���룬�������ݸ�ʽ�ɵ��������Ҷ���
}NET_IN_SETTHIRD_LICENSE;

///@brief  ���������������license�ĳ���
typedef struct tagNET_OUT_SETTHIRD_LICENE
{
	DWORD				dwSize;						// �˽ṹ���С
}NET_OUT_SETTHIRD_LICENCE;

///@brief  ��ȡ��Ȩ����Ϣ���
typedef struct tagNET_IN_GET_AUTH_BOX_INFO
{
	DWORD				dwSize;						// �˽ṹ���С
}NET_IN_GET_AUTH_BOX_INFO;

///@brief  ��Ȩ����Ϣ
typedef struct tagNET_AUTH_BOX_INFO
{
	char				szIP[32];				// ��Ȩ��IP��ַ
	UINT				nPort;					// ��Ȩ�ж˿�
	char				szUserName[64];			// ��Ȩ�е�½�û���
	char				szPassWord[64];			// ��Ȩ�е�½����
	char				szReserved[348];		// Ԥ���ֽ�
}NET_AUTH_BOX_INFO;

///@brief  ��ȡ��Ȩ����Ϣ����
typedef struct tagNET_OUT_GET_AUTH_BOX_INFO
{
	DWORD				dwSize;					// �˽ṹ���С
	NET_AUTH_BOX_INFO	stuAuthBoxInfo;			// ��Ȩ����Ϣ
}NET_OUT_GET_AUTH_BOX_INFO;

///@brief  ������Ȩ����Ϣ���
typedef struct tagNET_IN_SET_AUTH_BOX_INFO
{
	DWORD				dwSize;					// �˽ṹ���С
	NET_AUTH_BOX_INFO	stuAuthBoxInfo;			// ��Ȩ����Ϣ
}NET_IN_SET_AUTH_BOX_INFO;

///@brief  ������Ȩ����Ϣ����
typedef struct tagNET_OUT_SET_AUTH_BOX_INFO
{
	DWORD				dwSize;					// �˽ṹ���С
}NET_OUT_SET_AUTH_BOX_INFO;

///@brief  ��ȡ�豸��License�ļ���Ϣ���
typedef struct tagNET_IN_GET_REAL_LICENSE_INFO
{
	DWORD				dwSize;					// �˽ṹ���С
}NET_IN_GET_REAL_LICENSE_INFO;

///@brief  �豸��������Ϣ
typedef enum tagEM_LICENCE_ABROAD_INFO
{
	EM_LICENCE_ABROAD_INFO_UNKNOWN,						// δ֪
	EM_LICENCE_ABROAD_INFO_MAINLAND,					// ����
	EM_LICENCE_ABROAD_INFO_OVERSEA,						// ����
}EM_LICENCE_ABROAD_INFO;

///@brief ������Ŀ
typedef struct tagNET_LIMIT_ITEMS
{
	UINT				nPolicy;				// ��������
												// 1 ÿ�벢����
												// 60 ÿ���Ӳ�����
												// 3600 ÿСʱ������
												// 86400 ÿ�첢����
												// 604800 ÿ�ܲ�����
												// 2592000 ÿ�²�����
												// 31516000 ÿ�겢����
	TP_U64				nValue;					// ����ֵ
	char				szReserved[128];		// Ԥ���ֽ�
}NET_LIMIT_ITEMS;

///@brief ҵ������
typedef struct tagNET_BUSINESS_LIMIT
{
	UINT				nType;					// �����㷨����
	int					nLimitItemsCnt;			// ������Ŀ����
	NET_LIMIT_ITEMS		stuLimitItems[16];		// ������Ŀ
	char				szReserved[128];		// Ԥ���ֽ�
}NET_BUSINESS_LIMIT;

///@brief  �豸��������Ϣ
typedef enum tagEM_CLUSTER_LIMIT_POLICY
{
	EM_CLUSTER_LIMIT_POLICY_UNKNOWN,				// δ֪
	EM_CLUSTER_LIMIT_POLICY_CPU,					// CPU����
	EM_CLUSTER_LIMIT_POLICY_CLUSTER,				// ��Ⱥ�н�������
}EM_CLUSTER_LIMIT_POLICY;

///@brief ��Ⱥ���п���
typedef struct tagNET_CLUSTER_LIMIT
{
	EM_CLUSTER_LIMIT_POLICY				emPolicy;	// ��������
	TP_U64				nValue;						// ����ֵ
	char				szReserved[128];			// Ԥ���ֽ�
}NET_CLUSTER_LIMIT;

///@brief  ״̬��Ϣ
typedef enum tagEM_REAL_LICENSE_STATUS
{
	EM_REAL_LICENSE_STATUS_UNKNOWN,				// δ֪
	EM_REAL_LICENSE_STATUS_NORMAL,				// ����
	EM_REAL_LICENSE_STATUS_LICENSE_EXPIRES,		// license����
	EM_REAL_LICENSE_STATUS_LICENSE_UNBURNED,	// licenseδ��¼
	EM_REAL_LICENSE_STATUS_LICENSE_NOT_MATCH,	// license���豸֧���������Ͳ�ƥ��
	EM_REAL_LICENSE_STATUS_LICENSE_TIMENOTARRIVED,	// license��Ȩʱ��δ��
}EM_REAL_LICENSE_STATUS;

///@brief  License��Ϣ
typedef struct tagNET_REAL_LICENSE_INFO
{
	char				szUsername[64];			// License�����Ŀ�ʹ�õ��û�
	UINT				nLicenseID;				// �豸�ڲ������License�ļ��ı��
	int					nLicenseUUIDCnt;		// ���ܷ���������
	char				szLicenseUUID[1000][16];	// ���ܷ�����ʹ�ã����ڱ�ʶ��ͬ������/GPU��
	char				szProductType[40];		// ��Ȩ���豸����
	UINT				nEffectiveTime;			// ��Чʱ�䣬��׼UTCʱ��
	int					nDigitChannel;			// �豸�������ͨ����
	NET_BUSINESS_LIMIT	stuBusinessLimit[16];	// ҵ������
	int					nBusinessLimitCnt;		// ҵ�����Ƹ���
	int					nClusterLimitCnt;		// ��Ⱥ���п��Ƹ���
	NET_CLUSTER_LIMIT	stuClusterLimit[16];	// ��Ⱥ���п���
	BOOL				bAllType;				// �Ƿ���Ȩȫ���㷨����
	EM_REAL_LICENSE_STATUS emStatus;			// ״̬��Ϣ
	EM_LICENCE_ABROAD_INFO	emAbroadInfo;		// �豸��������Ϣ
	UINT				nEffectiveDays;			// ��������
	char				szReserved[1024];		// Ԥ���ֽ�
}NET_REAL_LICENSE_INFO;

///@brief  ��ȡ�豸��License�ļ���Ϣ����
typedef struct tagNET_OUT_GET_REAL_LICENSE_INFO
{
	DWORD				dwSize;					// �˽ṹ���С
	int					nLicenseInfoMax;		// License��Ϣ�û��������
	int					nLicenseInfoRet;		// License��Ϣʵ�ʷ��ظ���
	NET_REAL_LICENSE_INFO* pstuLicenseInfo;		// License��Ϣ���ռ����û�������ͷ�, �����СΪnLicenseInfoMax * sizeof(NET_REAL_LICENSE_INFO)
}NET_OUT_GET_REAL_LICENSE_INFO;

typedef enum tagEM_LICENCE_OPERATE_TYPE
{
	NET_EM_LICENCE_OPERATE_UNKNOWN = -1,				// δ֪
	NET_EM_LICENCE_OPERATE_GETVENDOR,					// ��ȡ������Ҫ����License�ĳ��� pInParam = NET_IN_GETVENDOR, pOutParam = NET_OUT_GETVENDOR
	NET_EM_LICENCE_OPERATE_GETTHIRDINFO,				// ��ȡ���ڵ�������������License�ĸ�����Ϣ   pInParam = NET_IN_GETTHIRDASSISTED_INFO, pOutParam = NET_OUT_GETTHIRDASSISTED_INFO
	NET_EM_LICENCE_OPERATE_SETTHIRDLICENCE,				// ���������������License pInParam = NET_IN_SETTHIRDLICENCE, pOutParam = NET_OUT_SETTHIRDLICENCE
	NET_EM_LICENCE_OPERATE_GET_AUTH_BOX_INFO,			// ��ȡ��Ȩ����Ϣ, pInParam = NET_IN_GET_AUTH_BOX_INFO, pOutParam = NET_OUT_GET_AUTH_BOX_INFO
	NET_EM_LICENCE_OPERATE_SET_AUTH_BOX_INFO,			// ������Ȩ����Ϣ, pInParam = NET_IN_SET_AUTH_BOX_INFO, pOutParam = NET_OUT_SET_AUTH_BOX_INFO
	NET_EM_LICENCE_OPERATE_GET_LICENSE_INFO,			// ��ȡ�豸��License�ļ���Ϣ, pInParam = NET_IN_GET_REAL_LICENSE_INFO, pOutParam = NET_OUT_GET_REAL_LICENSE_INFO
}NET_EM_LICENCE_OPERATE_TYPE;


///@brief  License֤����Ϣ�Ĳ���
CLIENT_NET_API BOOL CALL_METHOD CLIENT_LicenseOperate(LLONG lLoginID, NET_EM_LICENCE_OPERATE_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime);

///@brief  CLIENT_GetPreProcessInfo�ӿ����
typedef struct tagNET_IN_GET_PRE_PROCESS_INFO
{
	DWORD				dwSize;					// �˽ṹ���С
}NET_IN_GET_PRE_PROCESS_INFO;

///@brief  CLIENT_GetPreProcessInfo�ӿڳ���
typedef struct tagNET_OUT_GET_PRE_PROCESS_INFO
{
	DWORD				dwSize;					// �˽ṹ���С
	int					nTotalDevices;			// ��Ҫ��Ȩ���豸��
}NET_OUT_GET_PRE_PROCESS_INFO;

///@brief  ��ȡ����license�ĸ�����Ϣ
///@param[in]		lLoginID:		��¼���
///@param[in]		pstuInParam:	�ӿ��������, �ڴ���Դ���û�������ͷ�
///@param[out]		pstuOutParam:	�ӿ��������, �ڴ���Դ���û�������ͷ�
///@param[in]		nWaitTime:		�ӿڳ�ʱʱ��, ��λ����
///@return TRUE��ʾ�ɹ�FALSE��ʾʧ�� 
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetPreProcessInfo(LLONG lLoginID, const NET_IN_GET_PRE_PROCESS_INFO* pstuInParam, NET_OUT_GET_PRE_PROCESS_INFO* pstuOutParam, int nWaitTime);

///@brief  CLIENT_SetLicense �ӿ����
typedef struct tagNET_IN_SET_LICENSE
{
	DWORD dwSize;								// ��ֵΪ�ṹ���С
	char  szLicenseInfo[8192];					// License ����
	char  szSignature[512];						// License ���ݵ�����ǩ��
	int   nChannel;								// ��Ȩ�豸ͨ����
}NET_IN_SET_LICENSE;

///@brief  CLIENT_SetLicense �ӿڳ���
typedef struct tagNET_OUT_SET_LICENSE
{
	DWORD dwSize;								// ��ֵΪ�ṹ���С
}NET_OUT_SET_LICENSE;

///@brief  ����License
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetLicense(LLONG lLoginID, const NET_IN_SET_LICENSE* pstInParam, NET_OUT_SET_LICENSE* pstOutParam, int nWaitTime);

///@brief  ��ȡ¼������������
typedef struct tagNET_IN_GET_RECORD_FILE_PASSWORD
{
	DWORD		dwSize;									// �ṹ���С
	char		szFileName[DH_COMMON_STRING_256];		// ¼���ļ�����
}NET_IN_GET_RECORD_FILE_PASSWORD;

///@brief  ��ȡ¼������������
typedef struct tagNET_OUT_GET_RECORD_FILE_PASSWORD
{
	DWORD		dwSize;											// �ṹ���С
	char		szPassword[MAX_RECORD_FILE_PASSWORD_LEN + 1];	// ����
	BYTE		byReserved[3];									// �����ֽ�,Ϊ���ֽڶ���
}NET_OUT_GET_RECORD_FILE_PASSWORD;

///@brief  ��ȡ¼���������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetRecordFilePassword(LLONG lLoginID, const NET_IN_GET_RECORD_FILE_PASSWORD* pInParam, NET_OUT_GET_RECORD_FILE_PASSWORD* pOutParam, int nWaitTime);

///@brief  �����������������
typedef struct tagNET_SUBCONNECT_NETPARAM
{
	DWORD               dwSize;                                 // �ṹ���С
	UINT				nNetPort;								// ����ӳ��˿ں�	
	char				szNetIP[DH_MAX_IPADDR_EX_LEN];			// ����ӳ��IP��ַ
} NET_SUBCONNECT_NETPARAM;

///@brief  �����������������, pSubConnectNetParam ��Դ���û�������ͷ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetSubConnectNetworkParam(LLONG lLoginID, NET_SUBCONNECT_NETPARAM *pSubConnectNetParam);


///@brief  CLIENT_QueryUserRights �ӿ��������
typedef struct tagNET_IN_QUERYUSER_RIGHT
{
	DWORD               dwSize;						// �˽ṹ���С			
} NET_IN_QUERYUSER_RIGHT;

///@brief  CLIENT_QueryUserRights �ӿ��������
typedef struct tagNET_OUT_QUERYUSER_RIGHT
{
	DWORD               dwSize;						// �˽ṹ���С		
	DWORD               dwRightNum;                 // Ȩ����Ϣ
    OPR_RIGHT_NEW       rightList[DH_NEW_MAX_RIGHT_NUM];                      
    USER_INFO_NEW       userInfo;                   // �û���Ϣ
    DWORD               dwFunctionMask;             // ���룻0x00000001 - ֧���û����ã�0x00000002 - �����޸���ҪУ��
} NET_OUT_QUERYUSER_RIGHT;

///@brief  APP�û������Ż��ӿ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_QueryUserRights(LLONG lLoginID, const NET_IN_QUERYUSER_RIGHT* pstInParam, NET_OUT_QUERYUSER_RIGHT* pstOutParam ,int waittime);

///@brief  CLIENT_GetDeviceAllInfo ����ṹ��
typedef struct tagNET_IN_GET_DEVICE_AII_INFO
{
    DWORD		dwSize;						// ��ֵΪ�ṹ���С
}NET_IN_GET_DEVICE_AII_INFO;

///@brief  �洢�豸״̬
typedef enum tagEM_STORAGE_DEVICE_STATUS
{
    EM_STORAGE_DEVICE_UNKNOWN,              // δ֪
    EM_STORAGE_DEVICE_ERROR,                // ��ȡ�豸ʧ��
    EM_STORAGE_DEVICE_INITIALIZING,         // ���ڶ�ȡ�豸
    EM_STORAGE_DEVICE_SUCCESS,              // ��ȡ�豸�ɹ�
}EM_STORAGE_DEVICE_STATUS;

///@brief  ����״̬��ʶ
typedef enum tagEM_STORAGE_HEALTH_TYPE
{
    EM_STORAGE_HEALTH_UNKNOWN = -1,         // δ֪
    EM_STORAGE_HEALTH_UNSUPPORT,            // �豸��֧�ֽ�����⹦��
    EM_STORAGE_HEALTH_SUPPORT_AND_SUCCESS,  // ֧�ֽ�����⹦���һ�ȡ���ݳɹ�
    EM_STORAGE_HEALTH_SUPPORT_AND_FAIL,     // ֧�ֽ�����⹦�ܵ���ȡ����ʧ��
}EM_STORAGE_HEALTH_TYPE;

///@brief  SD������״̬
typedef enum tagEM_SD_LOCK_STATE
{
    EM_SD_LOCK_STATE_UNKNOWN = -1,          // δ֪
    EM_SD_LOCK_STATE_NORMAL,                // δ���й�������״̬, �����״̬�����������ʱ״̬
    EM_SD_LOCK_STATE_LOCKED,                // ����
    EM_SD_LOCK_STATE_UNLOCKED,              // δ�����������������
}EM_SD_LOCK_STATE;

///@brief  SD�����ܹ��ܱ�ʶ
typedef enum tagEM_SD_ENCRYPT_FLAG
{
    EM_SD_ENCRYPT_UNKNOWN = -1,                     // δ֪
    EM_SD_ENCRYPT_UNSUPPORT,                        // �豸��֧��SD�����ܹ���
    EM_SD_ENCRYPT_SUPPORT_AND_GETDATA_SUCCESS,      // ֧��SD�����ܹ����һ�ȡ���ݳɹ�
    EM_SD_ENCRYPT_SUPPORT_AND_GETDATA_FAIL,         // ֧��SD�����ܹ��ܵ���ȡ����ʧ��
}EM_SD_ENCRYPT_FLAG;

///@brief  ��������
typedef enum tagEM_PARTITION_TYPE
{
    EM_PARTITION_UNKNOWN,               // δ֪
    EM_PARTITION_READ_WIRTE,            // ��д
    EM_PARTITION_READ_ONLY,             // ֻ��
    EM_PARTITION_READ_GENERIC,          // һ���
}EM_PARTITION_TYPE;

///@brief  �豸�洢������Ϣ
typedef struct tagNET_STORAGE_PARTITION_INFO
{
    BOOL                            bError;                 // �����Ƿ��쳣
    EM_PARTITION_TYPE               emType;                 // ������������
    double                          dTotalBytes;            // �����ܿռ䣬��λ�ֽ�
    double                          dUsedBytes;             // ����ʹ�ÿռ�
    char                            szPath[128];            // ��������
    BYTE                            byReserved[128];        // �����ֽ�
}NET_STORAGE_PARTITION_INFO;

///@brief  �豸�洢��Ϣ
typedef struct tagNET_DEVICE_STORAGE_INFO
{
    char                            szNmae[32];             // �豸����
    BOOL                            bSupportHotPlug;        // �洢�豸�ܷ��Ȳ��
    float                           fLifePercent;           // �������ȱ�ʶ
    EM_SD_LOCK_STATE                emLockState;            // SD������״̬
    EM_SD_ENCRYPT_FLAG              emSDEncryptFlag;        // SD�����ܹ��ܱ�ʶ
    EM_STORAGE_HEALTH_TYPE          emHealthType;           // ����״̬��ʶ
    EM_STORAGE_DEVICE_STATUS        emState;                // �洢�豸״̬
    NET_STORAGE_PARTITION_INFO      stuPartitionInfo[12];   // �����ľ�����Ϣ
    int                             nPartition;             // ��������
    BYTE                            byReserved[516];        // �����ֽ�
}NET_DEVICE_STORAGE_INFO;

///@brief  CLIENT_GetDeviceAllInfo ����ṹ��
typedef struct tagNET_OUT_GET_DEVICE_AII_INFO
{
    DWORD		                    dwSize;					// ��ֵΪ�ṹ���С
    int                             nInfoCount;             // ��Ϣ�ĸ���
    NET_DEVICE_STORAGE_INFO         stuStorageInfo[8];      // �豸�洢��Ϣ
}NET_OUT_GET_DEVICE_AII_INFO;

///@brief  ��ȡIPC�豸�Ĵ洢��Ϣ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDeviceAllInfo(LLONG lLoginID, NET_IN_GET_DEVICE_AII_INFO *pstInParam, NET_OUT_GET_DEVICE_AII_INFO *pstOutParam, int nWaitTime);

///@brief  CLIENT_SetPlayBackBufferThreshold �������
typedef struct tagNET_IN_SET_PLAYBACK_BUFFER_THRESHOLD
{
	DWORD							dwSize;					// �ṹ���С
	UINT							nUpperLimit;			// ���ޣ���Χ[0, 100), �ٷֱȣ�0��ʾĬ��ֵ
	UINT							nLowerLimit;			// ���ޣ���Χ[0, 100), �ٷֱȣ�0��ʾĬ��ֵ
}NET_IN_SET_PLAYBACK_BUFFER_THRESHOLD;

///@brief  CLIENT_SetPlayBackBufferThreshold �������
typedef struct tagNET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD
{
	DWORD							dwSize;					// �ṹ���С
}NET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD;


///@brief  ���ûطŻ�������ֵ
///@brief  lPlayBackHandle Ϊ�طž��
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetPlayBackBufferThreshold(LLONG lPlayBackHandle, NET_IN_SET_PLAYBACK_BUFFER_THRESHOLD* pstInParam, NET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD* pstOutParam);


///@brief  CLIENT_GetDeviceServiceType ����ṹ��
typedef struct tagNET_IN_GET_DEVICE_SERVICE_TYPE
{
	DWORD							dwSize;					// �ṹ���С
}NET_IN_GET_DEVICE_SERVICE_TYPE;

///@brief  ��������
typedef enum tagEM_DEVICE_SERVICE_TYPE
{
	EM_DEVICE_SERVICE_TYPE_UNKNOWN,							// δ֪
	EM_DEVICE_SERVICE_TYPE_MAIN,							// ������
	EM_DEVICE_SERVICE_TYPE_AOL,								// Always on line ����
}EM_DEVICE_SERVICE_TYPE;

///@brief  CLIENT_GetDeviceServiceType ����ṹ��
typedef struct tagNET_OUT_GET_DEVICE_SERVICE_TYPE
{
	DWORD							dwSize;					// �ṹ���С
	EM_DEVICE_SERVICE_TYPE			emServiceType;			// ��������
}NET_OUT_GET_DEVICE_SERVICE_TYPE;

///@brief  ��ȡ�豸�˷�������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDeviceServiceType(LLONG lLoginID, const NET_IN_GET_DEVICE_SERVICE_TYPE* pInParam, NET_OUT_GET_DEVICE_SERVICE_TYPE* pOutParam, int nWaitTime);

///@brief  CLIENT_GetLoginAuthPatchInfo ����ṹ��
typedef struct tagNET_IN_GET_LOGIN_AUTH_PATCH_INFO
{
	DWORD							dwSize;					// �ṹ���С
}NET_IN_GET_LOGIN_AUTH_PATCH_INFO;


///@brief  CLIENT_GetLoginAuthPatchInfo ����ṹ��
typedef struct tagNET_OUT_GET_LOGIN_AUTH_PATCH_INFO
{
	DWORD							dwSize;						// �ṹ���С
	BOOL							bSupportHighLevelSecurity;	// �Ƿ�֧�ָߵȼ���ȫ��¼
}NET_OUT_GET_LOGIN_AUTH_PATCH_INFO;

///@brief  ��ȡ�豸��¼���ݲ�����Ϣ�����ƣ�VTO�豸ʹ�ã�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetLoginAuthPatchInfo(LLONG lLoginID, const NET_IN_GET_LOGIN_AUTH_PATCH_INFO* pInParam, NET_OUT_GET_LOGIN_AUTH_PATCH_INFO* pOutParam);

///@brief  ��Կ����
typedef enum tagEM_SECURETRANSMIT_KEY_LENGTH
{
	EM_SECURETRANSMIT_AES_KEY_LENGTH_UNKNOWN = -1,				// δ֪
	EM_SECURETRANSMIT_AES_KEY_LENGTH_DEFAULT,					// SDK �ڲ������豸�������ȷ��
	EM_SECURETRANSMIT_AES_KEY_LENGTH_128,						// AES ��Կ���� 128 bit��ǰ�����豸֧��
	EM_SECURETRANSMIT_AES_KEY_LENGTH_192,						// AES ��Կ���� 192 bit��ǰ�����豸֧��
	EM_SECURETRANSMIT_AES_KEY_LENGTH_256,						// AES ��Կ���� 256 bit��ǰ�����豸֧��
}EM_SECURETRANSMIT_KEY_LENGTH;

///@brief  CLIENT_SetSecureTransmitKeyLength ����ṹ��
typedef struct tagNET_IN_SET_SECURETRANSMIT_KEY_LENGTH
{
	DWORD							dwSize;						// �ṹ���С
	EM_SECURETRANSMIT_KEY_LENGTH	emLength;					// ��Կ����
}NET_IN_SET_SECURETRANSMIT_KEY_LENGTH;


///@brief  CLIENT_SetSecureTransmitKeyLength ����ṹ��
typedef struct tagNET_OUT_SET_SECURETRANSMIT_KEY_LENGTH
{
	DWORD							dwSize;						// �ṹ���С
}NET_OUT_SET_SECURETRANSMIT_KEY_LENGTH;

///@brief  ������Կ���ȣ�ȫ����Ч��CLIENT_Init �ӿ�֮�����
///@brief  �ڳ������й����У������Ҫ������Կ���ȣ���Ҫ�ǳ��豸�����µ�¼
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetSecureTransmitKeyLength(const NET_IN_SET_SECURETRANSMIT_KEY_LENGTH* pInParam, NET_OUT_SET_SECURETRANSMIT_KEY_LENGTH* pOutParam);

///@brief  �ֻ�����ȫ��������Ϣ
typedef struct tagNET_MOBILE_SUBSCRIBE_ALL_CFG_INFO
{
	DWORD							dwSize;							// �ṹ���С
	int								nMaxMobileSubscribeNum;			// �û����������ղ�ѯ������Ϣ����
	int								nRetMobileSubscribeNum;			// ʵ�ʷ��ؽ��ղ�ѯ������Ϣ����
	BYTE							byReserved[4];					// �ֽڶ���
	NET_MOBILE_PUSH_NOTIFICATION_GENERAL_INFO	*pstuMobileSubscribe;// ��������	
}NET_MOBILE_SUBSCRIBE_ALL_CFG_INFO;

///@brief  ��ȡ�ֻ�ȫ������������Ϣ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetMobileSubscribeAllCfg(LLONG lLoginID, NET_MOBILE_SUBSCRIBE_ALL_CFG_INFO *pstuCfg, int *nError, int nWaitTime);

/************************************************************************/
/*                              ������־                               */
/************************************************************************/

///@brief  ���ô����ض������
typedef struct tagNET_IN_DBGINFO_SET_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_IN_DBGINFO_SET_REDIR_LOCAL;

///@brief  ���ô����ض������
typedef struct tagNET_OUT_DBGINFO_SET_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_OUT_DBGINFO_SET_REDIR_LOCAL;

///@brief  ȡ�����ڴ�ӡ�ض��򵽱��ش洢���
typedef struct tagNET_IN_DBGINFO_CANCEL_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_IN_DBGINFO_CANCEL_REDIR_LOCAL;

///@brief  ȡ�����ڴ�ӡ�ض��򵽱��ش洢����
typedef struct tagNET_OUT_DBGINFO_CANCEL_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_OUT_DBGINFO_CANCEL_REDIR_LOCAL;

///@brief  ��ȡ��־�ض������Ϣ���
typedef struct tagNET_IN_DBGINFO_GET_INFO
{
    DWORD               dwSize;
}NET_IN_DBGINFO_GET_INFO;

///@brief  �ض���״̬
typedef enum tagEM_DBGINFO_REDIR_STATUS
{
    EM_DBGINFO_REDIR_STATUS_UNKNOWN,    // δ֪
    EM_DBGINFO_REDIR_STATUS_NO,         // δ�ض���
    EM_DBGINFO_REDIR_STATUS_LOCAL,      // �ض��򵽱���
    EM_DBGINFO_REDIR_STATUS_CALLBACK,   // �ض��򵽻ص�
}EM_DBGINFO_REDIR_STATUS;

///@brief  �ļ���Ϣ
typedef struct tagNET_DBGINFO_FILEINFO
{
    char                szFilePath[128]; // ���ɵ��ļ�·��
    unsigned int        nFileSize;       // ���ɵ��ļ���С,��λ�ֽ�
    BYTE                byReserverd[260];// ����
}NET_DBGINFO_FILEINFO;

///@brief  ��ȡ��־�ض������Ϣ����
typedef struct tagNET_OUT_DBGINFO_GET_INFO
{
    DWORD               dwSize;
    EM_DBGINFO_REDIR_STATUS emStatus;    // �ض���״̬
    NET_DBGINFO_FILEINFO stuFile[10];    // �ļ���Ϣ
    int                  nRetFileCount;  // ���ص�stuFile��Ч�ĸ���
}NET_OUT_DBGINFO_GET_INFO;

///@brief  ��ȡ�ɼ�������־�豸���������
typedef struct tagNET_IN_DBGINFO_GET_CAPS
{
    DWORD               dwSize;
}NET_IN_DBGINFO_GET_CAPS;

///@brief  ��ȡ�ɼ�������־�豸����������
typedef struct tagNET_OUT_DBGINFO_GET_CAPS
{
    DWORD               dwSize;
    BOOL                bSupportRedir;        // �Ƿ�֧�ִ�����־�ض��򣬰������ļ��ͻص����֡�
}NET_OUT_DBGINFO_GET_CAPS;

///@brief  ������־�������� CLIENT_OperateDebugInfo
typedef enum tagEM_DBGINFO_OP_TYPE
{
    EM_DBGINFO_OP_REDIR_SET_LOCAL,            // ���ô��ڴ�ӡ�ض��򵽱��ش洢 pInParam = NET_IN_DBGINFO_SET_REDIR_LOCAL, pOutParam = NET_OUT_DBGINFO_SET_REDIR_LOCAL
    EM_DBGINFO_OP_REDIR_CANCEL_LOCAL,         // ȡ�����ڴ�ӡ�ض��򵽱��ش洢 pInParam = NET_IN_DBGINFO_CANCEL_REDIR_LOCAL, pOutParam = NET_OUT_DBGINFO_CANCEL_REDIR_LOCAL
    EM_DBGINFO_OP_GET_INFO,                   // ��ȡ��־�ض������Ϣ pInParam = NET_IN_DBGINFO_GET_INFO, pOutParam = NET_OUT_DBGINFO_GET_INFO
    EM_DBGINFO_OP_GET_CAPS,                   // ��ȡ�ɼ�������־�豸������ pInParam = NET_IN_DBGINFO_GET_CAPS, pOutParam = NET_OUT_DBGINFO_GET_CAPS
}EM_DBGINFO_OP_TYPE;

///@brief  ������־�ص�����
typedef void (CALLBACK *fDebugInfoCallBack)(LLONG lAttchHandle, BYTE *pBuffer, DWORD dwBufSize, LDWORD dwUser);

///@brief  ��־�ȼ�
typedef enum tagEM_DBGINFO_LEVEL
{
    EM_DBGINFO_LEVEL_NOPRINT,       // �޴�ӡ
    EM_DBGINFO_LEVEL_FATAL,         // ����
    EM_DBGINFO_LEVEL_ERROR,         // ����
    EM_DBGINFO_LEVEL_WARN,          // ����
    EM_DBGINFO_LEVEL_INFO,          // ��Ϣ
    EM_DBGINFO_LEVEL_TRACE,         // ����
    EM_DBGINFO_LEVEL_DEBUG,         // ����
}EM_DBGINFO_LEVEL;

///@brief  ������־�ص����
typedef struct tagNET_IN_ATTACH_DBGINFO
{
    DWORD               dwSize;
    EM_DBGINFO_LEVEL    emLevel;        // ��־�ȼ�
    fDebugInfoCallBack  pCallBack;      // �ص� 
    LDWORD              dwUser;         // �û�����
}NET_IN_ATTACH_DBGINFO;

///@brief  ������־�ص�����
typedef struct tagNET_OUT_ATTACH_DBGINFO
{
    DWORD               dwSize;    
}NET_OUT_ATTACH_DBGINFO;

////////////////////////////// ������־ /////////////////////////////////
///@brief  ������־�����ӿ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_OperateDebugInfo(LLONG lLoginID, EM_DBGINFO_OP_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime);

///@brief  ���ĵ�����־�ص�
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachDebugInfo(LLONG lLoginID, const NET_IN_ATTACH_DBGINFO* pInParam, NET_OUT_ATTACH_DBGINFO* pOutParam, int nWaitTime);

///@brief  �˶�������־�ص�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachDebugInfo(LLONG lAttachHanle);

///@brief  CLIENT_SetInternalControlParam ���
typedef struct tagNET_INTERNAL_CONTROL_PARAM
{
	DWORD							dwSize;										// �ṹ���С
	UINT							nThreadSleepTime;							// �ڲ��߳�˯�߼������Χ[10, 100]��unit:ms��Ĭ��10	
	UINT							nSemaphoreSleepTimePerLoop;					// �ȴ��ź���ʱ���ڲ��߳�˯�߼������Χ[10, 100]��unit:ms��Ĭ��10
}NET_INTERNAL_CONTROL_PARAM;

///@brief  �����ڲ����Ʋ��������ƣ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetInternalControlParam(const NET_INTERNAL_CONTROL_PARAM *pInParam);


///@brief �¼�����EVENT_IVS_FACERECOGNITION(Ŀ��ʶ��)��Ӧ�����ݿ�������Ϣ  �ص㣺��ָ�����ԭ�ȵ�CANDIDATE_INFOEX����
typedef struct tagDEV_EVENT_FACERECOGNITION_INFO_V1
{
    int                 nChannelID;                                 // ͨ����
    char                szName[128];                                // �¼�����
    int                 nEventID;                                   // �¼�ID
    NET_TIME_EX         UTC;                                        // �¼�������ʱ��
    DH_MSG_OBJECT       stuObject;                                  // ��⵽������
    int                 nCandidateNum;                              // ��ǰ����ƥ�䵽�ĺ�ѡ��������
    CANDIDATE_INFOEX*   pstuCandidates;                            // ��ǰ����ƥ�䵽�ĺ�ѡ������Ϣ
    BYTE                bEventAction;                               // �¼�����,0��ʾ�����¼�,1��ʾ�������¼���ʼ,2��ʾ�������¼�����;
    BYTE                byImageIndex;                               // ͼƬ�����, ͬһʱ����(��ȷ����)�����ж���ͼƬ, ��0��ʼ
    BYTE                byReserved1[2];                             // ����
    BOOL                bGlobalScenePic;                            // ȫ��ͼ�Ƿ����
    DH_PIC_INFO         stuGlobalScenePicInfo;                      // ȫ��ͼƬ��Ϣ
    char                szSnapDevAddress[MAX_PATH];                 // ץ�ĵ�ǰ�������豸��ַ,�磺����·37��  
    unsigned int        nOccurrenceCount;                           // �¼������ۼƴ���
    EVENT_INTELLI_COMM_INFO     stuIntelliCommInfo;                 // �����¼�������Ϣ
    NET_FACE_DATA		stuFaceData;								// ��������
    char				szUID[DH_COMMON_STRING_32];					// ץ����Աд�����ݿ��Ψһ��ʶ��
    NET_FEATURE_VECTOR	stuFeatureVector;							// ����ֵ��Ϣ
    char				szFeatureVersion[32];						// ����ֵ�㷨�汾
    EM_FACE_DETECT_STATUS emFaceDetectStatus;                       // ����������������е�״̬
    char				szSourceID[32];								// �¼�����ID,ͬһ�������ͼƬ���ɶ���¼�ʱSourceID��ͬ
    NET_PASSERBY_INFO	stuPasserbyInfo;							// ·�˿���Ϣ
    unsigned int		nStayTime;									// ·�˶���ʱ�� ��λ����
    NET_GPS_INFO        stuGPSInfo;                                 // GPS��Ϣ(�� stuCustomProjects�µ� stuGPSInfo��Ϣһ��)
    char                szCameraID[64];                             // �������
    DH_RESOLUTION_INFO  stuResolution;                              // ��ӦͼƬ�ķֱ���
    int					nPerFlag;									// ICC������ϵͳ����, ������ǩ��־λ, -1:δ֪, 0:��Ȩ����, 1:δ��Ȩ����, 2:İ����
    BYTE                bReserved[360];                             // �����ֽ�,������չ.
    char				szSerialUUID[22];							// ��������IDΨһ��ʶ
    // ��ʽ���£�ǰ2λ%d%d:01-��ƵƬ��,02-ͼƬ,03-�ļ�,99-����;
    // �м�14λYYYYMMDDhhmmss:������ʱ����;��5λ%u%u%u%u%u������ID����00001
    BYTE                byReserved[2];                              // ����
    NET_CUSTOM_PROJECTS_INFO stuCustomProjects;						// ��Ŀ������Ϣ
    BOOL				bIsDuplicateRemove;							// �ǻ����ۣ��Ƿ����ȥ�ز��ԣ�TRUE������ FALSE�������ϣ�
    BYTE				byReserved2[4];								// �ֽڶ���
    NET_IMAGE_INFO_EX2  stuImageInfo[32];							// ͼƬ��Ϣ����    
    int					nImageInfoNum;								// ͼƬ��Ϣ����
    DH_MSG_OBJECT_SUPPLEMENT    stuObjectSupplement;                // ��⵽�����岹���ֶ�
    UINT                nMode;                                      // 0-��ͨ  1-����İ����ģʽ
    SCENE_IMAGE_INFO    stuThumImageInfo;                           // ��ͼ��ȫ��ͼ��������ͼ��Ϣ
    SCENE_IMAGE_INFO    stuHumanImageInfo;                          // ����ͼƬ��Ϣ
    char                szVideoPath[256];                           // Υ�¹�����ƵFTP�ϴ�·��
    char				byReserved3[316];							// �����ֽ�
}DEV_EVENT_FACERECOGNITION_INFO_V1;


///@brief �����ɫ��Ϣ
typedef struct  tagLAMP_GROUP_INFO_V1
{
    int				nLampNo;							// ������
    EM_LAMP_TYPE	emLampType;							// ��������
    int				nRemainTime;						// �źŵ����ɫʣ��ʱ�䣬��������λΪ�루s��
    int				nLampColorCount;					// �����ɫ����
    int				nLampColor[4];						// �����ɫ����������Ϊ1~12ʱ,int[0]��ʾ��ɫ���ⵥԪ��int[1]��ʾ��ɫ���ⵥԪ��int[2]��ʾ��ɫ���ⵥԪ��int[3]����
    // ����������Ϊ13~15ʱ��int[0]���ڱ�ʾ��ֹͨ���źŷ��ⵥԪ��int[1]���ڱ�ʾ�����źŷ��ⵥԪ��int[2]���ڱ�ʾͨ���źŷ��ⵥԪ��int[3]����
    // ����ȡֵ 0���޵� 1����� 2������3����˸
}LAMP_GROUP_INFO_V1;

///@brief ���ڵ�ɫ״̬��Ϣ
typedef struct tagENTER_INFO_V1
{
    int					nEnterDir;						// ���ڷ���
    int					nLampNumber;					// ���ڵ���������0~48��
    int					nLampGroupNum;					// �����ɫ��Ϣ����
    LAMP_GROUP_INFO_V1	stuLampGroupInfo[48];			// �����ɫ��Ϣ������1��M�����ڵ����������������ɫ��Ϣ

}ENTER_INFO_V1;


///@brief ��ɫ״̬��Ϣ
typedef struct tagLAMP_STATE_V1
{
    int					nEnterNumber;					// �źŵƿ���·�ڵĽ���������0~8��
    int					nEnterInfoNum;					// ���ڵ�ɫ״̬��Ϣ����
    ENTER_INFO_V1		stuEnterInfo[8];				// ���ڵ�ɫ״̬��Ϣ������1��N��·�ڽ��������������ڵ�ɫ״̬��Ϣ
}LAMP_STATE_V1;


///@brief �źŻ������¼�, ��Ӧ�¼����� DH_ALARM_RTSC_RUNING
typedef struct tagALARM_RTSC_RUNNING_INFO_V1
{
    int							nChannelID;                  // ͨ����,��0��ʼ
    int							nEventAction;				 // �¼�����, 1��ʾ��ʼ,  2��ʾ����, -1��ʾδ֪
    DWORD						dwReportState;				 // bit0:����״̬
                                                             // bit1:���Ʒ�ʽ
                                                             // bit2:��ɫ״̬��Ϣ
                                                             // bit3:��������״̬
                                                             // bit4:����/�ѵ�����״̬��Ϣ
                                                             // bit5:��ǰ�źŷ���ɫ����Ϣ
                                                             // bit6: ��һ�������źŷ���ɫ����Ϣ
    int							nLongitudeNum;				 // ���ȸ���
    double						dbLongitude[3];				 // ����,��ʽ���ȣ��֣���(��Ϊ������)
    int							nLatitudeNum;				 // γ�ȸ���
    double						dbLatitude[3];				 // γ��,��ʽ���ȣ��֣���(��Ϊ������)
    double						dbAltitude;					 // �߶ȣ���λΪ��	
    NET_TIME_EX					UTC;						 //	�¼�����ʱ�䣬��ʱ��ƫ���UTCʱ�䣬��λ��
    EM_STATUS					emStatus;					 // �豸״̬ 
    EM_CONTROL_MODE				emControlMode;				 // ����ģʽ
    LAMP_STATE_V1				stuLampStateInfo;			 // ��ɫ״̬��Ϣ
}ALARM_RTSC_RUNNING_INFO_V1;

///@brief  CLIENT_SetIVSEventParseType ���
typedef struct tagNET_IN_SET_IVSEVENT_PARSE_INFO
{
    DWORD							dwSize;										// �ṹ���С
    DWORD                           dwIVSEvent;                                 // �¼�����,�ο�dhnetsdk.h�ж�������ܷ����¼���򱨾��¼���.
                                                                                // ��ǰ֧���������:
                                                                                // nCallBackTypeΪ0ʱ(�������¼���������)��
                                                                                // EVENT_IVS_FACERECOGNITION:       dwStructTypeΪ 1 ʱ,��Ӧ�ṹ�� DEV_EVENT_FACERECOGNITION_INFO_V1

                                                                                // nCallBackTypeΪ1ʱ(�������¼���������)��
                                                                                // DH_ALARM_RTSC_RUNING     :       dwStructTypeΪ 1 ʱ,��Ӧ�ṹ�� ALARM_RTSC_RUNNING_INFO_V1

    DWORD                           dwStructType;                               // ָ������������,���庬��ο� dwIVSEvent 

    int                             nCallBackType;                              // 0 - �����¼��ϱ�
                                                                                // 1 - ��ͨ�����¼��ϱ�

}NET_IN_SET_IVSEVENT_PARSE_INFO;


///@brief ָ�������¼��򱨾��¼��������õĽṹ�� ���ڽ��java��ṹ��new���������µ�����.�ýӿ�ȫ����Ч,������SDK��ʼ��ǰ����
///@param[in] pInParam �ӿ��������, �ڴ���Դ���û�������ͷ�
///@return TRUE��ʾ�ɹ� FALSE��ʾʧ��
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetIVSEventParseType(const NET_IN_SET_IVSEVENT_PARSE_INFO* pInParam);


///@brief  CLIENT_ProbeAlarm���
typedef struct tagNET_IN_PROBE_ALARM
{
    DWORD               dwSize;
}NET_IN_PROBE_ALARM;

///@brief  CLIENT_ProbeAlarm����
typedef struct tagNET_OUT_PROBE_ALARM
{
    DWORD               dwSize;
}NET_OUT_PROBE_ALARM;

///@brief ���豸̽�ⱨ���ϱ�֧�����,̽������Ӱ��CLIENT_StartListen/CLIENT_StartListenEx�������������Ľӿڵ��ڲ�����,���ڽ��һ�α����������յ����������ص������
///@param[in]	lLoginID:		��¼���
///@param[in]	pstuInParam:	�ӿ��������, �ڴ���Դ���û�������ͷ�
///@param[out]	pstuOutParam:	�ӿ��������, �ڴ���Դ���û�������ͷ�
///@param[in]	dwWaittime:		�ӿڳ�ʱʱ��, ��λ����
///@return TRUE��ʾ�ɹ� ��ʾ֧��������������,�����ٵ��ñ������Ľӿ�ʱ,�����ٶ��Ĳ����Ѿ�֧�����������ϱ��Ķ������� 
///@return FALSE��ʾʧ�� ��ʾ��֧������������������,�����ٶ��ı������Ľӿ�ʱ,��Ȼ�ᶩ�����ж�������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_ProbeAlarm(LLONG lLoginID,const NET_IN_PROBE_ALARM* pstuInParam,NET_OUT_PROBE_ALARM* pstuOutParam,DWORD dwWaittime);



#ifdef __cplusplus
}
#endif



#endif // DHNETSDKEX_H



