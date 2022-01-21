/*
* Copyright (c) 2009, �㽭�󻪼����ɷ����޹�˾
* All rights reserved.
*
* ժ��Ҫ��SDK�ӿںܶ�,���ƻ�һЩ�����õĹ��ܿ��Է���dhnetsdkEx.h,
*         �����ṩ dhnetsdk.h,
*         ������Ŀ�����ṩ dhnetsdkEx.h
*/
//////////////////////////////////////////////////////////////////////////
#ifndef DHNETSDKEX_H
#define DHNETSDKEX_H

#include "netsdk.h"

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
 
 // ͸������
 typedef enum   tagNET_TRANSMIT_INFO_TYPE
 {
    NET_TRANSMIT_INFO_TYPE_DEFAULT,                 // Ĭ�����ͣ���CLIENT_TransmitInfoForWeb�ӿڵļ���͸����ʽ
    NET_TRANSMIT_INFO_TYPE_F6,                      // F6��͸��
 } NET_TRANSMIT_INFO_TYPE;

 // ͸����������
 typedef enum tagEM_TRANSMIT_ENCRYPT_TYPE
 {
	EM_TRANSMIT_ENCRYPT_TYPE_UNKNOWN = -1,			// δ֪
	EM_TRANSMIT_ENCRYPT_TYPE_NORMAL,				// SDK�ڲ�����ȷ���Ƿ���ܣ�Ĭ��
	EM_TRANSMIT_ENCRYPT_TYPE_MULTISEC,				// �豸֧�ּ��ܵĳ����£���multiSec����
	EM_TRANSMIT_ENCRYPT_TYPE_BINARYSEC,				// �豸֧�ּ��ܵĳ����£���binarySec���ܣ������Ʋ��ֲ�����
 }EM_TRANSMIT_ENCRYPT_TYPE;

 // CLIENT_TransmitInfoForWebEx�������
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

 // CLIENT_TransmitInfoForWebEx�������
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
 // CLIENT_AttachTransmitInfo �ϱ���Ϣ�ص�
 typedef struct tagNET_CB_TRANSMIT_INFO
 {
     BYTE*              pBuffer;            // ���ݻ����ַ��SDK�ڲ�����ռ�
     DWORD              dwBufferSize;       // ���ݻ����ܳ���
     DWORD              dwJsonLen;          // Json���ݳ���
     DWORD              dwBinLen;           // ���������ݳ���
     BYTE               byReserved[512];    // �����ֽ�
 } NET_CB_TRANSMIT_INFO;

 // CLIENT_AttachTransmitInfo()�ص�����ԭ�ͣ���һ������lAttachHandle��CLIENT_AttachTransmitInfo����ֵ
 typedef int  (CALLBACK *AsyncTransmitInfoCallBack)(LLONG lAttachHandle, NET_CB_TRANSMIT_INFO* pTransmitInfo, LDWORD dwUser);

 // CLIENT_AttachTransmitInfo�������
 typedef struct tagNET_IN_ATTACH_TRANSMIT_INFO
 {
     DWORD                       dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_IN_ATTACH_TRANSMIT_INFO)
     AsyncTransmitInfoCallBack   cbTransmitInfo;                 // �ص�����
     LDWORD				         dwUser;                         // �û�����
     char*                       szInJsonBuffer;                 // Json��������,�û�����ռ�
     DWORD                       dwInJsonBufferSize;             // Json�������ݳ���  `
     BOOL						 bSubConnFirst;					 // TRUE-���豸֧��ʱ��ʹ�������ӷ�ʽ���ն������� FALSE-ֻ�������ӽ��ն�������
 }NET_IN_ATTACH_TRANSMIT_INFO;

 // CLIENT_AttachTransmitInfo�������
 typedef struct tagNET_OUT_ATTACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_OUT_ATTACH_TRANSMIT_INFO)
     BYTE*                   szOutBuffer;                    // Ӧ�𻺳��ַ,�û�����ռ�
     DWORD                   dwOutBufferSize;                // Ӧ�𻺳��ܳ���
     DWORD                   dwOutJsonLen;                   // Ӧ��Json���ݳ���
     DWORD                   dwOutBinLen;                    // Ӧ����������ݳ��� 
 } NET_OUT_ATTACH_TRANSMIT_INFO;

 // CLIENT_DetachTransmitInfo�������
 typedef struct tagNET_IN_DETACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_IN_DETACH_TRANSMIT_INFO)
     char*                   szInJsonBuffer;                 // Json��������,�û�����ռ�
     DWORD                   dwInJsonBufferSize;             // Json�������ݳ���
 } NET_IN_DETACH_TRANSMIT_INFO;

 // CLIENT_DetachTransmitInfo�������
 typedef struct tagNET_OUT_DETACH_TRANSMIT_INFO
 {
     DWORD                   dwSize;                         // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_OUT_DETACH_TRANSMIT_INFO)
     char*                   szOutBuffer;                    // Ӧ�����ݻ���ռ�, �û�����ռ�
     DWORD                   dwOutBufferSize;                // Ӧ�����ݻ���ռ䳤��
     DWORD                   dwOutJsonLen;                   // Ӧ��Json���ݳ���
 } NET_OUT_DETACH_TRANSMIT_INFO;

//////�Ϻ�BUS//////
 
// �Ϻ���ʿ�������ͣ� ��ӦCLIENT_ControlSpecialDevice�ӿ�
typedef enum tagNET_SPECIAL_CTRL_TYPE
{
    NET_SPECIAL_CTRL_SHUTDOWN_PAD,            // �ر�PAD����, pInBuf��Ӧ����NET_IN_SHUTDOWN_PAD*, pOutBuf��Ӧ����NET_OUT_SHUTDOWN_PAD*
    NET_SPECIAL_CTRL_REBOOT_PAD,              // ����PAD����, pInBuf��Ӧ����NET_IN_REBOOT_PAD*, pOutBuf��Ӧ����NET_OUT_REBOOT_PAD*                 
} NET_SPECIAL_CTRL_TYPE;

 //////////////////////////////////////////////�豸�������ýṹ�嶨�忪ʼ////////////////////////////////////////////////////////////////////////////////////////////
 // CLIENT_DevSpecialCtrl �����������
 typedef enum tagEM_DEV_SPECIAL_CTRL_TYPE
 {
     DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH,                  // ����¼������ǿ��д��Ӳ��, pInBuf=NET_IN_RECORD_FLUSH_INFO* , pOutBuf=NET_OUT_RECORD_FLUSH_INFO*
 } EM_DEV_SPECIAL_CTRL_TYPE;
 
 // CLIENT_DevSpecialCtrl, ��Ӧ DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH �������
 typedef struct tagNET_IN_NET_IN_RECORD_FLUSH_INFO
 {
    DWORD                                      dwSize;       // �û�ʹ�øýṹ��ʱ��dwSize�踳ֵΪsizeof(NET_IN_RECORD_FLUSH_INFO)               
    int                                        nChannel;     // ͨ����
    NET_STREAM_TYPE                            emStreamType; // ��������, ��Ч���� "main", "Extra1", "Extra2", "Extar3", "Snapshot"     
 }NET_IN_RECORD_FLUSH_INFO;

 // CLIENT_DevSpecialCtrl, ��Ӧ DEV_SPECIAL_CTRL_TYPE_RECORD_FLUSH �������
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

//////////////////////////////////////////////�첽��͸���ṹ�嶨�����////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////�豸������Ϣ�ṹ�嶨�忪ʼ ////////////////////////////////////////////////////////////////////////////////////////////

typedef struct tagNET_DHDEV_ETHERNET_INFO
{
    DWORD               dwSize;                                 // �û�ʹ�øýṹ��ʱ��dwSize �踳ֵΪ sizeof(NET_DHDEV_ETHERNET_INFO)
    int                 nEtherNetNum;                           // ��̫������
    DH_ETHERNET_EX      stuEtherNet[DH_MAX_ETHERNET_NUM_EX];    // ��̫����
} NET_DHDEV_ETHERNET_INFO;

//////////////////////////////////////////////�豸������Ϣ�ṹ�嶨�����////////////////////////////////////////////////////////////////////////////////////////////


//��ȡHCDZ�ɼ���Ϣ,�������
typedef struct tagNET_IN_HCDZ_LIST_INFO 
{
    DWORD                           dwSize;							//  �ṹ���С, �����߱����ʼ�����ֶ�
	UINT							nIndexNum;					   //����szindex��Ч����
    UINT                            szIndex[DH_COMMON_STRING_64]; //һ������,index ֵ��ͨ���±��Ӧ
}NET_IN_HCDZ_LIST_INFO;

// HCDZ�ɼ���Ϣ�����ģ��ɼ���Ϣ
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

// ��ȡHCDZ�ɼ���Ϣ,�������
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

// ��ȡHCDZ(�ݲ����)�����ṹ��
typedef struct tagCFG_HCDZ_CAPS
{
	DWORD                               dwSize;                                 // �ṹ���С, �����߱����ʼ�����ֶ�
	char								szModelID[DH_COMMON_STRING_32];		    // �豸�ͺ�
	unsigned int						nVersion;								// �汾
	unsigned int						nAnalogsNum;							// ���ģ��ģ�����������
	unsigned int						nDINum;									// ���ģ�鿪�����������
	unsigned int						nDONum;									// ���ģ�鿪�����������
}NET_OUT_HCDZ_CAPS;

// ��ȡ����״̬(HADTɽ����³��갲����),�������
typedef struct tagNET_IN_HADT_STATUS
{
    DWORD                               dwSize;                                 // �ṹ���С, �����߱����ʼ�����ֶ�
}NET_IN_HADT_STATUS;

// ��ȡ����״̬(HADTɽ����³��갲����),�������
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

//����������ƽӿ�CLIENT_SetAlarmOut���������
typedef struct tagNET_IN_SET_ALARMOUT
{
    DWORD                               dwSize;                                 // �ṹ���С����Ҫ��ֵ
    int                                 nChannel;                               // ͨ���ţ���0��ʼ
    int                                 nTime;                                  // time > 0 ʱ, time��Ч����λ:��
    int                                 nLevel;                                 // time = 0 ʱ, level��Ч��time��level��Ϊ0ʱ����ʾֹͣ
}NET_IN_SET_ALARMOUT;

//����������ƽӿ�CLIENT_SetAlarmOut���������
typedef struct tagNET_OUT_SET_ALARMOUT
{   
    DWORD                               dwSize;                                 // �ṹ���С,��Ҫ��ֵ
}NET_OUT_SET_ALARMOUT;

// ¼������
typedef enum tagEM_NET_LINK_RECORD_EVENT
{
    EM_NET_LINK_RECORD_UNKNOWN,                         // δ֪
    EM_NET_LINK_RECORD_ALARM,                           // Alarm
} EM_NET_LINK_RECORD_EVENT;

//CLIENT_StartLinkRecord�������
typedef struct tagNET_IN_LINK_RECORD_CTRL
{
    DWORD                       dwSize;                 // �ýṹ���С
    unsigned int                nChannel;               // ͨ����
    unsigned int                nLength;                // ¼��ʱ��
    EM_NET_LINK_RECORD_EVENT    emType;                 // ¼������"Alarm"-����¼�񣬵�ǰ��֧������¼��
} NET_IN_LINK_RECORD_CTRL;

//CLIENT_StartLinkRecord�������
typedef struct tagNET_OUT_LINK_RECORD_CTRL
{
    DWORD                       dwSize;                 // �ýṹ���С
} NET_OUT_LINK_RECORD_CTRL;

// CLIENT_SetDeviceUkey�������
typedef struct tagNET_IN_SET_UEKY
{
    DWORD                       dwSize;                 // �ýṹ���С
    char                        szUkey[128];             // Ukey��
}NET_IN_SET_UEKY;

// CLIENT_SetDeviceUkey �������
typedef struct tagNET_OUT_SET_UEKY
{
    DWORD                       dwSize;                 // �ýṹ���С
}NET_OUT_SET_UEKY;

/******************************************************************************
��������	:	����¼���ļ�--��չ,�ɼ�������ת����
�������	:	
    lLoginID:       ��¼�ӿڷ��صľ��
    lpRecordFile:   ��ѯ¼��ӿڷ��ص�¼����Ϣ
    sSavedFileName: ����¼���ļ���,֧��ȫ·��
    cbDownLoadPos:  ���ؽ��Ȼص�����(�ص����ؽ���,���ؽ��)
    dwUserData:     ���ؽ��Ȼص���Ӧ�û�����
    fDownLoadDataCallBack: ¼�����ݻص�����(�ص���ʽ�ݲ�֧��ת��PS��)
    dwDataUser:     ¼�����ݻص���Ӧ�û�����
    scType:         ����ת������,0-DAV����(Ĭ��); 1-PS��
    pReserved:      �����ֶ�,������չ
�������	��	N/A
�� �� ֵ	��	LLONG ����¼����
����˵��	��	����ӿ�,SDKĬ�ϲ�֧��תPS��,�趨��SDK
******************************************************************************/
CLIENT_NET_API LLONG CALL_METHOD CLIENT_DownloadByRecordFileEx2(LLONG lLoginID, LPNET_RECORDFILE_INFO lpRecordFile, char *sSavedFileName, 
                                                    fDownLoadPosCallBack cbDownLoadPos, LDWORD dwUserData, 
                                                    fDataCallBack fDownLoadDataCallBack, LDWORD dwDataUser, 
                                                    int scType = 0, void* pReserved = NULL);

/******************************************************************************
��������	:	ͨ��ʱ������¼��--��չ,�ɼ�������ת����
�������	:	
    lLoginID:       ��¼�ӿڷ��صľ��
    nChannelId:     ��Ƶͨ����,��0��ʼ
    nRecordFileType:¼������0 ����¼���ļ�
                            1 �ⲿ���� 
                            2 ��̬��ⱨ�� 
                            3 ���б��� 
                            4 ���Ų�ѯ  
                            5 ���������ѯ 
                            6 ¼��λ����ƫ�������� 
                            8 �����Ų�ѯͼƬ(Ŀǰ��HB-U��NVS�����ͺŵ��豸֧��) 
                            9 ��ѯͼƬ(Ŀǰ��HB-U��NVS�����ͺŵ��豸֧��)  
                            10 ���ֶβ�ѯ 
                            15 �����������ݽṹ(��������) 
                            16 ��ѯ����͸��������¼���ļ� 
    tmStart:        ��ʼʱ�� 
    tmEnd:          ����ʱ�� 
    sSavedFileName: ����¼���ļ���,֧��ȫ·��
    cbTimeDownLoadPos: ���ؽ��Ȼص�����(�ص����ؽ���,���ؽ��)
    dwUserData:     ���ؽ��Ȼص���Ӧ�û�����
    fDownLoadDataCallBack: ¼�����ݻص�����(�ص���ʽ�ݲ�֧��ת��PS��)
    dwDataUser:     ¼�����ݻص���Ӧ�û�����
    scType:         ����ת������,0-DAV����(Ĭ��); 1-PS��,3-MP4
    pReserved:      ��������,������չ
�������	��	N/A
�� �� ֵ	��	LLONG ����¼����
����˵��	��	����ӿ�,SDKĬ�ϲ�֧��תPS��,�趨��SDK
******************************************************************************/
CLIENT_NET_API LLONG CALL_METHOD CLIENT_DownloadByTimeEx2(LLONG lLoginID, int nChannelId, int nRecordFileType, 
                                                    LPNET_TIME tmStart, LPNET_TIME tmEnd, char *sSavedFileName, 
                                                    fTimeDownLoadPosCallBack cbTimeDownLoadPos, LDWORD dwUserData, 
                                                    fDataCallBack fDownLoadDataCallBack, LDWORD dwDataUser, 
                                                    int scType = 0, void* pReserved = NULL);

/******************************************************************************
��������	:	͸����չ�ӿ�,��͸�������߶�Ӧ͸����ʽ�ӿڣ�Ŀǰ֧��F6��͸��, ͬʱ����CLIENT_TransmitInfoForWeb�ӿ�
��������	:	
    lLoginID:       ��¼�ӿڷ��صľ��
    pInParam:       ͸����չ�ӿ��������
    pOutParam       ͸����չ�ӿ��������
    nWaittime       �ӿڳ�ʱʱ��

�� �� ֵ	��	BOOL  TRUE :�ɹ�; FALSE :ʧ��
******************************************************************************/
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_TransmitInfoForWebEx(LLONG lLoginID, NET_IN_TRANSMIT_INFO* pInParam, 
                                                             NET_OUT_TRANSMIT_INFO* pOutParam, int nWaittime = 3000);


/******************************************************************************
��������	:	 �첽��͸�����Ľӿ�
��������	:	
    lLoginID:       ��¼�ӿڷ��صľ��
    pInParam:       �첽��͸���ӿ��������
    pOutParam       �첽��͸���ӿ��������
    nWaittime       �ӿڳ�ʱʱ��

�� �� ֵ	��	    LLONG �첽��͸�����
******************************************************************************/
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachTransmitInfo(LLONG lLoginID, const NET_IN_ATTACH_TRANSMIT_INFO* pInParam, NET_OUT_ATTACH_TRANSMIT_INFO* pOutParam, int nWaitTime);

 

/******************************************************************************
��������	:	 �첽��͸��ȡ�����Ľӿ�
��������	:	
    lAttachHandle:  �첽��͸���������CLIENT_AttachTransmitInfo�ӿڵķ���ֵ
    pInParam:       �첽��͸��ȡ�����Ľӿ��������
    pOutParam       �첽��͸��ȡ�����Ľӿ��������
    nWaittime       �ӿڳ�ʱʱ��

�� �� ֵ	��		BOOL  TRUE :�ɹ�; FALSE :ʧ��
******************************************************************************/
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_DetachTransmitInfo(LLONG lAttachHandle, const NET_IN_DETACH_TRANSMIT_INFO* pInParam, NET_OUT_DETACH_TRANSMIT_INFO* pOutParam, int nWaitTime);


/******************************************************************************
��������	:	 �豸������ƽӿ�
��������	:	
    lLoginID:                       ��¼�ӿڷ��صľ��
    EM_DEV_SPECIAL_CTRL_TYPE:       �����������
    pInParam:                       �豸������ƽӿ��������
    pOutParam                       �豸������ƽӿ��������
    nWaittime                       �ӿڳ�ʱʱ��

�� �� ֵ	��		BOOL  TRUE :�ɹ�; FALSE :ʧ��
******************************************************************************/
CLIENT_NET_API  BOOL CALL_METHOD CLIENT_DevSpecialCtrl(LLONG lLoginID, EM_DEV_SPECIAL_CTRL_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime = 3000);


/******************************************************************************
��������	:	 ��ȡ�豸������Ϣ�ӿ�
��������	:	
    lLoginID:                       ��¼�ӿڷ��صľ��
    pstOutParam                     ��ȡ�豸������Ϣ�ӿڵ��������
    nWaittime                       �ӿڳ�ʱʱ��

�� �� ֵ	��		BOOL  TRUE :�ɹ�; FALSE :ʧ��
******************************************************************************/
CLIENT_NET_API  BOOL CALL_METHOD CLIENT_QueryEtherNetInfo(LLONG lLoginID, NET_DHDEV_ETHERNET_INFO* pstuOutParam, int nWaitTime = 3000);

//////�Ϻ�BUS//////

// �������ݽ����ӿ�,�첽��ȡ����
CLIENT_NET_API LLONG CALL_METHOD CLIENT_ExChangeData(LLONG lLoginId, NET_IN_EXCHANGEDATA* pInParam, NET_OUT_EXCHANGEDATA* pOutParam, int nWaittime = 5000);

// ����CAN��������
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachCAN(LLONG lLoginID, const NET_IN_ATTACH_CAN* pstInParam, NET_OUT_ATTACH_CAN* pstOutParam, int nWaitTime = 3000);

// ȡ������CAN�������ݣ�lAttachHandle��CLIENT_AttachCAN����ֵ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachCAN(LLONG lAttachHandle);

// ����CAN��������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SendCAN(LLONG lLoginID, const NET_IN_SEND_CAN* pstInParam, NET_OUT_SEND_CAN* pstOutParam, int nWaitTime = 3000);

// ����͸����������
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachDevComm(LLONG lLoginID, const NET_IN_ATTACH_DEVCOMM* pstInParam, NET_OUT_ATTACH_DEVCOMM* pstOutParam, int nWaitTime = 3000);

// ȡ������͸���������ݣ�lAttachHandle��CLIENT_AttachDevComm����ֵ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachDevComm(LLONG lAttachHandle);

// �Ϻ���ʿ�豸���ƽӿڣ���������PAD�ػ���������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_ControlSpecialDevice(LLONG lLoginID, NET_SPECIAL_CTRL_TYPE emType, void* pInBuf, void* pOutBuf = NULL, int nWaitTime = NET_INTERFACE_DEFAULT_TIMEOUT);

//��ȡHCDZ�ɼ���Ϣ
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_GetHCDZInfo(LLONG lLoginID, const NET_IN_HCDZ_LIST_INFO* pInParam, NET_OUT_HCDZ_LIST_INFO* pOutParam, int nWaitTime = 3000);

//��ȡHCDZ������
CLIENT_NET_API BOOL  CALL_METHOD CLIENT_GetHCDZCaps(LLONG lLoginID, const NET_IN_HCDZ_CAPS* pInParam, NET_OUT_HCDZ_CAPS* pOutParam, int nWaitTime = 3000);


// ������̨�����Կ�������ͼ���������öԵ�ǰ���е�¼����̨�豸����Ч����λms�����ʱ�������100ms��������Ч��
CLIENT_NET_API void CALL_METHOD CLIENT_PTZCmdSendIntervalTime(DWORD dwIntervalTime);

/**********************************************************************************
��������:��ȡHADT(ɽ����³��갲����)����״̬
��������:
    lLoginID:��¼�ӿڷ��صľ��
    pInBuf  :�������,���ʼ��dwSize
    pOutBuf :�������,���ʼ��dwSize
    nWaitTime :�ӿڳ�ʱʱ��
�� �� ֵ:	BOOL  TRUE :�ɹ�; FALSE :ʧ��
**********************************************************************************/
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetHADTStatus(LLONG lLoginID, const NET_IN_HADT_STATUS* pInBuf, NET_OUT_HADT_STATUS* pOutBuf,int nWaitTime = 3000);

/**********************************************************************************
��������:���Ʊ�����������ض��ƣ�
��������:
    lLoginID:��¼�ӿڷ��صľ��
    pInBuf  :�������,���ʼ��dwSize
    pOutBuf :�������,���ʼ��dwSize
    nWaitTime :�ӿڳ�ʱʱ��
�� �� ֵ:	BOOL  TRUE :�ɹ�; FALSE :ʧ��
**********************************************************************************/
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetAlarmOut(LLONG lLoginID, const NET_IN_SET_ALARMOUT* pInBuf, NET_OUT_SET_ALARMOUT* pOutBuf,int nWaitTime);

//����EVS��ʱ¼��
CLIENT_NET_API BOOL CALL_METHOD CLIENT_StartLinkRecord(LLONG lLoginID, const NET_IN_LINK_RECORD_CTRL *pstIn, NET_OUT_LINK_RECORD_CTRL *pstOut, int nWaitTime);

// �����������ƽӿڣ�����Ukeyֵ
/**********************************************************************************
��������:�豸�˴ε�½��Ukeyֵ
��������:
    lLoginID:��¼�ӿڷ��صľ��
    pInBuf  :�������,���ʼ��dwSize
    pOutBuf :�������,���ʼ��dwSize
    nWaitTime :�ӿڳ�ʱʱ��
�� �� ֵ:	BOOL  TRUE :�ɹ�; FALSE :ʧ��
**********************************************************************************/
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

// ��ӦCLIENT_StartSearchCustomDevices�ӿ�
// ����OEM�豸����ö��
typedef enum tagEM_SEARCH_OEM_DEVICE_TYPE
{
	EM_TYPE_JIANGSU_CHUANGTONG = 0,    // ���մ�ͨOEM�豸����
	EM_TYPE_MAX,					   // ���ö��ֵ
}EM_SEARCH_OEM_DEVICE_TYPE;

// OEM�豸��Ϣ
typedef struct tagCUSTOM_DEVICE_NETINFO
{
	char                szMac[DH_MACADDR_LEN];                  // MAC��ַ,��00:40:9D:31:A9:0A
	char                szIP[DH_MAX_IPADDR_EX_LEN];				// IP��ַ,��10.0.0.231
	char                szDevName[DH_MACHINE_NAME_NUM];         // �豸����,�̶�ΪWireless Transmission Device
	BYTE				byReserved[1024];						// �����ֽ�
}CUSTOM_DEVICE_NETINFO;

// �첽����OEM�豸�ص���pCustomDevNetInf�ڴ���SDK�ڲ������ͷţ�
typedef void (CALLBACK *fSearchCustomDevicesCB)(CUSTOM_DEVICE_NETINFO *pCustomDevNetInfo, void* pUserData);

// CLIENT_StartSearchCustomDevices�ӿڵ��������
typedef struct tagNET_IN_SEARCH_PARAM 
{
	DWORD							dwSize;                  // �ṹ���С
	fSearchCustomDevicesCB			cbFunc;			         // ����OEM�豸�ص�����
	void*							pUserData;               // �û�������Զ�������
	char*							szLocalIp;				 // ����IP
	EM_SEARCH_OEM_DEVICE_TYPE       emSearchOemDeviceType;   //	����OEM�豸����
}NET_IN_SEARCH_PARAM;

// CLIENT_StartSearchCustomDevices���������
typedef struct tagNET_OUT_SEARCH_PARAM
{
	DWORD		dwSize;
}NET_OUT_SEARCH_PARAM;

// �첽�鲥����OEM�豸, (pInParam, pOutParam�ڴ����û������ͷ�),��֧�ֶ��̵߳���,�����Ʒ������
CLIENT_NET_API LLONG CALL_METHOD CLIENT_StartSearchCustomDevices(const NET_IN_SEARCH_PARAM *pInParam, NET_OUT_SEARCH_PARAM *pOutParam); 
// ֹͣ�鲥����OEM�豸
CLIENT_NET_API BOOL CALL_METHOD CLIENT_StopSearchCustomDevices(LLONG lSearchHandle);

// �豸��¼�������
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

// �豸��¼���Գ���
typedef struct tagNET_OUT_LOGIN_POLICY_PARAM
{
	DWORD               dwSize;
	NET_DEVICEINFO_Ex   stuDeviceInfo;                          // �豸��Ϣ
}NET_OUT_LOGIN_POLICY_PARAM;


// ��¼��չ�ӿ�, ֧�ֲ���
CLIENT_NET_API LLONG CALL_METHOD CLIENT_LoginWithPolicy(const NET_IN_LOGIN_POLICY_PARAM* pstInParam, NET_OUT_LOGIN_POLICY_PARAM* pstOutParam, int nWaitTime);

// CLIENT_TriggerAutoInspection �ӿ����
typedef struct tagNET_IN_TRIGGER_AUTO_INSPECTION
{
	DWORD dwSize;
}NET_IN_TRIGGER_AUTO_INSPECTION;

// CLIENT_TriggerAutoInspection �ӿڳ���
typedef struct tagNET_OUT_TRIGGER_AUTO_INSPECTON
{
	DWORD dwSize;
}NET_OUT_TRIGGER_AUTO_INSPECTON;

// �����豸�Լ죨¥���Ʒ��ר������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_TriggerAutoInspection(LLONG lLoginID, const NET_IN_TRIGGER_AUTO_INSPECTION* pstInParam, NET_OUT_TRIGGER_AUTO_INSPECTON* pstOutParam, int nWaitTime);

// CLIENT_GetLicenseAssistInfo �ӿ����
typedef struct tagNET_IN_GET_LICENSE_INFO
{
	DWORD dwSize;								// ��ֵΪ�ṹ���С
}NET_IN_GET_LICENSE_INFO;

// ��Ҫ��License���ƵĿ���Ϣ
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


// CLIENT_GetLicenseAssistInfo �ӿڳ���
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
}NET_OUT_GET_LICENSE_INFO;

// ��ȡ����License�ĸ�����Ϣ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetLicenseAssistInfo(LLONG lLoginID, const NET_IN_GET_LICENSE_INFO* pstInParam, NET_OUT_GET_LICENSE_INFO* pstOutParam, int nWaitTime);



// ����Licenced�ĳ������
typedef struct tagNET_IN_GETVENDOR
{
	DWORD				dwSize;						// �˽ṹ���С
}NET_IN_GETVENDOR;

// Licence�Ķ�Ӧ��Ϣ
typedef struct tagNET_VENDOR_INFO
{
	char				szVendorId[32];				// ��������������id
	int					nClassNum;					// �����㷨����
	char				szClass[32][8];				// �����������㷨����
	BYTE				bReserved[512];				// Ԥ���ֽ�
}NET_VENDOR_INFO;

// ����Licence�ĳ��ҳ���
typedef struct tagNET_OUT_GETVENDOR
{
	DWORD				dwSize;						// �˽ṹ���С
	int					nVendorNum;					// ��Ϣ����
	NET_VENDOR_INFO		stuVendorInfo[8];			// ��Ϣ�����Ϊ8��
}NET_OUT_GETVENDOR;


// ��������������License�ĸ�����Ϣ���
typedef struct tagNET_IN_GETTHIRDASSISTED_INFO
{
	DWORD				dwSize;						// �˽ṹ���С
	NET_VENDOR_INFO		stuVendorInfo;				// ��������������license�ĸ�����Ϣ
}NET_IN_GETTHIRDASSISTED_INFO;

// ��Ҫ������Ȩ�ĵ������Ĳ�����Ϣ
typedef struct tagNET_DEVICE_INFO
{
	char				szSN[32];					// ���к�
	int					nMacNum;					// MAC��ַ����
	char				szMac[8][32];				// MAC��ַ��ð��+��д
	char				szAppVersion[16];			// Ӧ�ó���汾
	BYTE				bReserved[512];				// Ԥ���ֽ�
}NET_DEVICE_INFO;

// ��Ҫ������Ȩ�ĵ������Ĳ�����Ϣ
typedef struct tagNET_THIRD_INFO
{
	char				szVendor[32];				// ������������
	int					nClassNum;					// �����㷨����
	char				szClass[32][8];				// �����������㷨����
	char				szData[4096];				// ���ɵĵ�������ɼ�����Ϣ��Ϊ��ֹ�������ַ���Ҫ����base64���롣��Բ�ͬ��������˾���Ӧ��data����Ҳ����ͬ�� 
	BYTE				bReserved[4392];			// Ԥ���ֽ�
}NET_THIRD_INFO;

// ��������������License�ĸ�����Ϣ����
typedef struct tagNET_OUT_GETTHIRDASSISTED_INFO
{
	DWORD				dwSize;						// �˽ṹ���С
	NET_DEVICE_INFO		stuDeviceInfo;				// �豸���ͨ����Ϣ
	NET_THIRD_INFO		stuThirdInfo;				// ��Ҫ������Ȩ�ĵ������Ĳ�����Ϣ
}NET_OUT_GETTHIRDASSISTED_INFO;

// ���������������license�����
typedef struct tagNET_IN_SETTHIRD_LICENSE
{
	DWORD				dwSize;						// �˽ṹ���С
	char				szVendorId[32];				// ��������������ID
	int					nClassNum;					// �����㷨����
	char				szClass[32][8];				// �����������㷨����
	char				szLicense[8192];			// ������license���� base64���룬�������ݸ�ʽ�ɵ��������Ҷ���
}NET_IN_SETTHIRD_LICENSE;

// ���������������license�ĳ���
typedef struct tagNET_OUT_SETTHIRD_LICENE
{
	DWORD				dwSize;						// �˽ṹ���С
}NET_OUT_SETTHIRD_LICENCE;

typedef enum tagEM_LICENCE_OPERATE_TYPE
{
	NET_EM_LICENCE_OPERATE_UNKNOWN = -1,				// δ֪
	NET_EM_LICENCE_OPERATE_GETVENDOR,					// ��ȡ������Ҫ����License�ĳ��� pInParam = NET_IN_GETVENDOR, pOutParam = NET_OUT_GETVENDOR
	NET_EM_LICENCE_OPERATE_GETTHIRDINFO,				// ��ȡ���ڵ�������������License�ĸ�����Ϣ   pInParam = NET_IN_GETTHIRDASSISTED_INFO, pOutParam = NET_OUT_GETTHIRDASSISTED_INFO
	NET_EM_LICENCE_OPERATE_SETTHIRDLICENCE,				// ���������������License pInParam = NET_IN_SETTHIRDLICENCE, pOutParam = NET_OUT_SETTHIRDLICENCE
}NET_EM_LICENCE_OPERATE_TYPE;


// License֤����Ϣ�Ĳ���
CLIENT_NET_API BOOL CALL_METHOD CLIENT_LicenseOperate(LLONG lLoginID, NET_EM_LICENCE_OPERATE_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime);

// CLIENT_SetLicense �ӿ����
typedef struct tagNET_IN_SET_LICENSE
{
	DWORD dwSize;								// ��ֵΪ�ṹ���С
	char  szLicenseInfo[8192];					// License ����
	char  szSignature[512];						// License ���ݵ�����ǩ��
}NET_IN_SET_LICENSE;

// CLIENT_SetLicense �ӿڳ���
typedef struct tagNET_OUT_SET_LICENSE
{
	DWORD dwSize;								// ��ֵΪ�ṹ���С
}NET_OUT_SET_LICENSE;

// ����License
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetLicense(LLONG lLoginID, const NET_IN_SET_LICENSE* pstInParam, NET_OUT_SET_LICENSE* pstOutParam, int nWaitTime);

// ��ȡ¼������������
typedef struct tagNET_IN_GET_RECORD_FILE_PASSWORD
{
	DWORD		dwSize;									// �ṹ���С
	char		szFileName[DH_COMMON_STRING_256];		// ¼���ļ�����
}NET_IN_GET_RECORD_FILE_PASSWORD;

// ��ȡ¼������������
typedef struct tagNET_OUT_GET_RECORD_FILE_PASSWORD
{
	DWORD		dwSize;											// �ṹ���С
	char		szPassword[MAX_RECORD_FILE_PASSWORD_LEN + 1];	// ����
	BYTE		byReserved[3];									// �����ֽ�,Ϊ���ֽڶ���
}NET_OUT_GET_RECORD_FILE_PASSWORD;

// ��ȡ¼���������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetRecordFilePassword(LLONG lLoginID, const NET_IN_GET_RECORD_FILE_PASSWORD* pInParam, NET_OUT_GET_RECORD_FILE_PASSWORD* pOutParam, int nWaitTime);

// �����������������
typedef struct tagNET_SUBCONNECT_NETPARAM
{
	DWORD               dwSize;                                 // �ṹ���С
	UINT				nNetPort;								// ����ӳ��˿ں�	
	char				szNetIP[DH_MAX_IPADDR_EX_LEN];			// ����ӳ��IP��ַ
} NET_SUBCONNECT_NETPARAM;

// �����������������, pSubConnectNetParam ��Դ���û�������ͷ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetSubConnectNetworkParam(LLONG lLoginID, NET_SUBCONNECT_NETPARAM *pSubConnectNetParam);

// ��ȡ�豸״̬���
typedef struct tagNET_IN_UNIFIEDINFOCOLLECT_GET_DEVSTATUS
{
    DWORD               dwSize;                                 // �ṹ���С
}NET_IN_UNIFIEDINFOCOLLECT_GET_DEVSTATUS;

// ��������
typedef enum tagNET_EM_POWER_TYPE
{
    NET_EM_POWER_TYPE_UNKNOWN = -1,                     // δ֪              
    NET_EM_POWER_TYPE_POWERADAPTER,                     // ��Դ������
    NET_EM_POWER_TYPE_BATTERY,                          // ���
    NET_EM_POWER_TYPE_BATTERY_AND_POWERADAPTER,         // ���+��Դ������
}NET_EM_POWER_TYPE;

// ��Դ��������Ϣ
typedef struct tagNET_DEVSTATUS_POWER_INFO
{
	UINT                nBatteryPercent;                        // ��ص����ٷֱ�,0~100
    NET_EM_POWER_TYPE   emPowerType;                            // ��������
}NET_DEVSTATUS_POWER_INFO;

// ����������״̬
typedef enum tagNET_EM_ETH_STATE
{
    NET_EM_ETH_UNKNOWN,                                         // δ֪
    NET_EM_ETH_CONNECT,                                         // ����
    NET_EM_ETH_DISCONNECT,                                      // δ����
}NET_EM_ETH_STATE;

// ���������Ϣ
typedef struct tagNET_DEVSTATUS_NET_INFO
{
    UINT                nWifiIntensity;                         // wifi�ź�ǿ�ȵȼ���0~5��0��ʾû���ź�
    UINT                nWifiSignal;                            // wifi�ź�ǿ�ȣ���λdbm, 0~100,0��ʾû���ź�
    UINT                nCellulSignal;                          // 2g/3g/4g�ź�ǿ��,��λdbm. 0~100, 0��ʾû���ź�
    UINT                nCellulIntensity;                       // 2g/3g/4g�ź�ǿ�ȵȼ�,0~5, 0��ʾû���ź�
    NET_EM_ETH_STATE    emEthState;                             // ����������״̬
    UINT                n3Gflux;                                // ��������ʵ��ʹ����������λ��MB
    UINT                n3GfluxByTime;                          // ����ʵ��ʹ��ʱ������λ������     
}NET_DEVSTATUS_NET_INFO;

// ��������״̬
typedef enum tagNET_EM_TAMPER_STATE
{
    NET_EM_TAMPER_UNKNOWN = -1,                             // δ֪ 
    NET_EM_TAMPER_NOALARM,                                  // δ����
    NET_EM_TAMPER_ALARMING,                                 // ������
}NET_EM_TAMPER_STATE;

// ��ȡ�豸״̬����
typedef struct tagNET_OUT_UNIFIEDINFOCOLLECT_GET_DEVSTATUS
{
    DWORD                           dwSize;                         // �ṹ���С
    NET_DEVSTATUS_POWER_INFO        stuPowerInfo;                   // ��Դ��������Ϣ
    NET_DEVSTATUS_NET_INFO          stuNetInfo;                     // ���������Ϣ
    char                            szVersion[DH_COMMON_STRING_32]; // ��������汾
    NET_EM_TAMPER_STATE             emTamperState;                  // ��������״̬
}NET_OUT_UNIFIEDINFOCOLLECT_GET_DEVSTATUS;

// ��ȡ�豸״̬, DMSSר�ýӿ�, pInParam��pOutParam�ڴ����û������ͷ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetUnifiedStatus(LLONG lLoginID, NET_IN_UNIFIEDINFOCOLLECT_GET_DEVSTATUS* pInParam, NET_OUT_UNIFIEDINFOCOLLECT_GET_DEVSTATUS* pOutParam, int nWaitTime);


// CLIENT_RealPlayEx2 �ӿ����
typedef struct tagNET_IN_REALPLAY
{
	DWORD							dwSize;							// �ṹ���С����ֵΪ�ṹ���С	
	int								nChannelID;						// ͨ��	
	DH_RealPlayType					rType;							// ����
	BYTE							szReserved[4];					// Ԥ���ֶ�
	HWND							hWnd;							// ���ھ��	
	fRealDataCallBackEx2			cbRealData;                     // ʵʱ���ݻص�        
	fOriginalRealDataCallBack		pOriginalRealDataCallBack;		// ԭʼ�������ݻص�
	fEncryptRealDataCallBackEx		pEncryptRealDataCallBackEx;     // �����������ݻص�	
	fRealPlayDisConnect				cbDisconnect;					// ���߻ص�
	fVKInfoCallBack					pVKInfoCallBack;				// VK��Ϣ�ص�
	LDWORD							dwUser;							// �û�����		
} NET_IN_REALPLAY;

// CLIENT_RealPlayEx2 ����
typedef struct tagNET_OUT_REALPLAY
{
	DWORD							dwSize;							// �ṹ���С����ֵΪ�ṹ���С
}NET_OUT_REALPLAY;


// ʵʱ����--��չEx2�ӿ�
CLIENT_NET_API LLONG CALL_METHOD CLIENT_RealPlayEx2(LLONG lLoginID, const NET_IN_REALPLAY* pInParam, NET_OUT_REALPLAY* pOutParam, DWORD	dwWaitTime);

// CLIENT_QueryUserRights �ӿ��������
typedef struct tagNET_IN_QUERYUSER_RIGHT
{
	DWORD               dwSize;						// �˽ṹ���С			
} NET_IN_QUERYUSER_RIGHT;

// CLIENT_QueryUserRights �ӿ��������
typedef struct tagNET_OUT_QUERYUSER_RIGHT
{
	DWORD               dwSize;						// �˽ṹ���С		
	DWORD               dwRightNum;                 // Ȩ����Ϣ
    OPR_RIGHT_NEW       rightList[DH_NEW_MAX_RIGHT_NUM];                      
    USER_INFO_NEW       userInfo;                   // �û���Ϣ
    DWORD               dwFunctionMask;             // ���룻0x00000001 - ֧���û����ã�0x00000002 - �����޸���ҪУ��
} NET_OUT_QUERYUSER_RIGHT;

// APP�û������Ż��ӿ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_QueryUserRights(LLONG lLoginID, const NET_IN_QUERYUSER_RIGHT* pstInParam, NET_OUT_QUERYUSER_RIGHT* pstOutParam ,int waittime);

// CLIENT_GetDeviceAllInfo ����ṹ��
typedef struct tagNET_IN_GET_DEVICE_AII_INFO
{
    DWORD		dwSize;						// ��ֵΪ�ṹ���С
}NET_IN_GET_DEVICE_AII_INFO;

// �洢�豸״̬
typedef enum tagEM_STORAGE_DEVICE_STATUS
{
    EM_STORAGE_DEVICE_UNKNOWN,              // δ֪
    EM_STORAGE_DEVICE_ERROR,                // ��ȡ�豸ʧ��
    EM_STORAGE_DEVICE_INITIALIZING,         // ���ڶ�ȡ�豸
    EM_STORAGE_DEVICE_SUCCESS,              // ��ȡ�豸�ɹ�
}EM_STORAGE_DEVICE_STATUS;

// ����״̬��ʶ
typedef enum tagEM_STORAGE_HEALTH_TYPE
{
    EM_STORAGE_HEALTH_UNKNOWN = -1,         // δ֪
    EM_STORAGE_HEALTH_UNSUPPORT,            // �豸��֧�ֽ�����⹦��
    EM_STORAGE_HEALTH_SUPPORT_AND_SUCCESS,  // ֧�ֽ�����⹦���һ�ȡ���ݳɹ�
    EM_STORAGE_HEALTH_SUPPORT_AND_FAIL,     // ֧�ֽ�����⹦�ܵ���ȡ����ʧ��
}EM_STORAGE_HEALTH_TYPE;

// SD������״̬
typedef enum tagEM_SD_LOCK_STATE
{
    EM_SD_LOCK_STATE_UNKNOWN = -1,          // δ֪
    EM_SD_LOCK_STATE_NORMAL,                // δ���й�������״̬, �����״̬�����������ʱ״̬
    EM_SD_LOCK_STATE_LOCKED,                // ����
    EM_SD_LOCK_STATE_UNLOCKED,              // δ�����������������
}EM_SD_LOCK_STATE;

// SD�����ܹ��ܱ�ʶ
typedef enum tagEM_SD_ENCRYPT_FLAG
{
    EM_SD_ENCRYPT_UNKNOWN = -1,                     // δ֪
    EM_SD_ENCRYPT_UNSUPPORT,                        // �豸��֧��SD�����ܹ���
    EM_SD_ENCRYPT_SUPPORT_AND_GETDATA_SUCCESS,      // ֧��SD�����ܹ����һ�ȡ���ݳɹ�
    EM_SD_ENCRYPT_SUPPORT_AND_GETDATA_FAIL,         // ֧��SD�����ܹ��ܵ���ȡ����ʧ��
}EM_SD_ENCRYPT_FLAG;

// ��������
typedef enum tagEM_PARTITION_TYPE
{
    EM_PARTITION_UNKNOWN,               // δ֪
    EM_PARTITION_READ_WIRTE,            // ��д
    EM_PARTITION_READ_ONLY,             // ֻ��
    EM_PARTITION_READ_GENERIC,          // һ���
}EM_PARTITION_TYPE;

// �豸�洢������Ϣ
typedef struct tagNET_STORAGE_PARTITION_INFO
{
    BOOL                            bError;                 // �����Ƿ��쳣
    EM_PARTITION_TYPE               emType;                 // ������������
    double                          dTotalBytes;            // �����ܿռ䣬��λ�ֽ�
    double                          dUsedBytes;             // ����ʹ�ÿռ�
    char                            szPath[128];            // ��������
    BYTE                            byReserved[128];        // �����ֽ�
}NET_STORAGE_PARTITION_INFO;

// �豸�洢��Ϣ
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

// CLIENT_GetDeviceAllInfo ����ṹ��
typedef struct tagNET_OUT_GET_DEVICE_AII_INFO
{
    DWORD		                    dwSize;					// ��ֵΪ�ṹ���С
    int                             nInfoCount;             // ��Ϣ�ĸ���
    NET_DEVICE_STORAGE_INFO         stuStorageInfo[8];      // �豸�洢��Ϣ
}NET_OUT_GET_DEVICE_AII_INFO;

// ��ȡIPC�豸�Ĵ洢��Ϣ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDeviceAllInfo(LLONG lLoginID, NET_IN_GET_DEVICE_AII_INFO *pstInParam, NET_OUT_GET_DEVICE_AII_INFO *pstOutParam, int nWaitTime);

// CLIENT_SetPlayBackBufferThreshold �������
typedef struct tagNET_IN_SET_PLAYBACK_BUFFER_THRESHOLD
{
	DWORD							dwSize;					// �ṹ���С
	UINT							nUpperLimit;			// ���ޣ���Χ[0, 100), �ٷֱȣ�0��ʾĬ��ֵ
	UINT							nLowerLimit;			// ���ޣ���Χ[0, 100), �ٷֱȣ�0��ʾĬ��ֵ
}NET_IN_SET_PLAYBACK_BUFFER_THRESHOLD;

// CLIENT_SetPlayBackBufferThreshold �������
typedef struct tagNET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD
{
	DWORD							dwSize;					// �ṹ���С
}NET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD;


// ���ûطŻ�������ֵ
// lPlayBackHandle Ϊ�طž��
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetPlayBackBufferThreshold(LLONG lPlayBackHandle, NET_IN_SET_PLAYBACK_BUFFER_THRESHOLD* pstInParam, NET_OUT_SET_PLAYBACK_BUFFER_THRESHOLD* pstOutParam);

// CLIENT_SetConsumeResult ����ṹ��
typedef struct tagNET_IN_SET_CONSUME_RESULT
{
	DWORD				dwSize;				// �ṹ���С
	int					nChannelID;			// ͨ����
	char				szUserID[32];		// �û�ID
	UINT				nRemainAmount;		// ���Ѻ����������ʧ����������ǰ����λ�֡�
	BOOL				bConsumeResult;		// ���ѳɹ����
	int					nErrorCode;			// ������ 
											// 0x00:�޴���;
											// 0x01:���� 
											// 0x02:�ѹ��Ͳ�ʱ�� 
											// 0x03:������
											// 0x04:��Ȩ��

	UINT				nConsumptionAmount; // ƽ̨�̶����ѽ���λ(��)
}NET_IN_SET_CONSUME_RESULT;

// CLIENT_SetConsumeResult ����ṹ��
typedef struct tagNET_OUT_SET_CONSUME_RESULT
{
	DWORD				dwSize;				// �ṹ���С
}NET_OUT_SET_CONSUME_RESULT;

// �������ѽ����������ж��ƣ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetConsumeResult(LLONG lLoginID, const NET_IN_SET_CONSUME_RESULT* pInParam, NET_OUT_SET_CONSUME_RESULT* pOutParam, int nWaitTime);


// CLIENT_GetDeviceServiceType ����ṹ��
typedef struct tagNET_IN_GET_DEVICE_SERVICE_TYPE
{
	DWORD							dwSize;					// �ṹ���С
}NET_IN_GET_DEVICE_SERVICE_TYPE;

// ��������
typedef enum tagEM_DEVICE_SERVICE_TYPE
{
	EM_DEVICE_SERVICE_TYPE_UNKNOWN,							// δ֪
	EM_DEVICE_SERVICE_TYPE_MAIN,							// ������
	EM_DEVICE_SERVICE_TYPE_AOL,								// Always on line ����
}EM_DEVICE_SERVICE_TYPE;

// CLIENT_GetDeviceServiceType ����ṹ��
typedef struct tagNET_OUT_GET_DEVICE_SERVICE_TYPE
{
	DWORD							dwSize;					// �ṹ���С
	EM_DEVICE_SERVICE_TYPE			emServiceType;			// ��������
}NET_OUT_GET_DEVICE_SERVICE_TYPE;

// ��ȡ�豸�˷�������
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetDeviceServiceType(LLONG lLoginID, const NET_IN_GET_DEVICE_SERVICE_TYPE* pInParam, NET_OUT_GET_DEVICE_SERVICE_TYPE* pOutParam, int nWaitTime);

// CLIENT_GetLoginAuthPatchInfo ����ṹ��
typedef struct tagNET_IN_GET_LOGIN_AUTH_PATCH_INFO
{
	DWORD							dwSize;					// �ṹ���С
}NET_IN_GET_LOGIN_AUTH_PATCH_INFO;


// CLIENT_GetLoginAuthPatchInfo ����ṹ��
typedef struct tagNET_OUT_GET_LOGIN_AUTH_PATCH_INFO
{
	DWORD							dwSize;						// �ṹ���С
	BOOL							bSupportHighLevelSecurity;	// �Ƿ�֧�ָߵȼ���ȫ��¼
}NET_OUT_GET_LOGIN_AUTH_PATCH_INFO;

// ��ȡ�豸��¼���ݲ�����Ϣ�����ƣ�VTO�豸ʹ�ã�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetLoginAuthPatchInfo(LLONG lLoginID, const NET_IN_GET_LOGIN_AUTH_PATCH_INFO* pInParam, NET_OUT_GET_LOGIN_AUTH_PATCH_INFO* pOutParam);

// ��Կ����
typedef enum tagEM_SECURETRANSMIT_KEY_LENGTH
{
	EM_SECURETRANSMIT_AES_KEY_LENGTH_UNKNOWN = -1,				// δ֪
	EM_SECURETRANSMIT_AES_KEY_LENGTH_DEFAULT,					// SDK �ڲ������豸�������ȷ��
	EM_SECURETRANSMIT_AES_KEY_LENGTH_128,						// AES ��Կ���� 128 bit��ǰ�����豸֧��
	EM_SECURETRANSMIT_AES_KEY_LENGTH_192,						// AES ��Կ���� 192 bit��ǰ�����豸֧��
	EM_SECURETRANSMIT_AES_KEY_LENGTH_256,						// AES ��Կ���� 256 bit��ǰ�����豸֧��
}EM_SECURETRANSMIT_KEY_LENGTH;

// CLIENT_SetSecureTransmitKeyLength ����ṹ��
typedef struct tagNET_IN_SET_SECURETRANSMIT_KEY_LENGTH
{
	DWORD							dwSize;						// �ṹ���С
	EM_SECURETRANSMIT_KEY_LENGTH	emLength;					// ��Կ����
}NET_IN_SET_SECURETRANSMIT_KEY_LENGTH;


// CLIENT_SetSecureTransmitKeyLength ����ṹ��
typedef struct tagNET_OUT_SET_SECURETRANSMIT_KEY_LENGTH
{
	DWORD							dwSize;						// �ṹ���С
}NET_OUT_SET_SECURETRANSMIT_KEY_LENGTH;

// ������Կ���ȣ�ȫ����Ч��CLIENT_Init �ӿ�֮�����
// �ڳ������й����У������Ҫ������Կ���ȣ���Ҫ�ǳ��豸�����µ�¼
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetSecureTransmitKeyLength(const NET_IN_SET_SECURETRANSMIT_KEY_LENGTH* pInParam, NET_OUT_SET_SECURETRANSMIT_KEY_LENGTH* pOutParam);

// �ֻ�����ȫ��������Ϣ
typedef struct tagNET_MOBILE_SUBSCRIBE_ALL_CFG_INFO
{
	DWORD							dwSize;							// �ṹ���С
	int								nMaxMobileSubscribeNum;			// �û����������ղ�ѯ������Ϣ����
	int								nRetMobileSubscribeNum;			// ʵ�ʷ��ؽ��ղ�ѯ������Ϣ����
	BYTE							byReserved[4];					// �ֽڶ���
	NET_MOBILE_PUSH_NOTIFICATION_GENERAL_INFO	*pstuMobileSubscribe;// ��������	
}NET_MOBILE_SUBSCRIBE_ALL_CFG_INFO;

// ��ȡ�ֻ�ȫ������������Ϣ
CLIENT_NET_API BOOL CALL_METHOD CLIENT_GetMobileSubscribeAllCfg(LLONG lLoginID, NET_MOBILE_SUBSCRIBE_ALL_CFG_INFO *pstuCfg, int *nError, int nWaitTime);

/************************************************************************/
/*                              ������־                               */
/************************************************************************/

// ���ô����ض������
typedef struct tagNET_IN_DBGINFO_SET_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_IN_DBGINFO_SET_REDIR_LOCAL;

// ���ô����ض������
typedef struct tagNET_OUT_DBGINFO_SET_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_OUT_DBGINFO_SET_REDIR_LOCAL;

// ȡ�����ڴ�ӡ�ض��򵽱��ش洢���
typedef struct tagNET_IN_DBGINFO_CANCEL_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_IN_DBGINFO_CANCEL_REDIR_LOCAL;

// ȡ�����ڴ�ӡ�ض��򵽱��ش洢����
typedef struct tagNET_OUT_DBGINFO_CANCEL_REDIR_LOCAL
{
    DWORD               dwSize;
}NET_OUT_DBGINFO_CANCEL_REDIR_LOCAL;

// ��ȡ��־�ض������Ϣ���
typedef struct tagNET_IN_DBGINFO_GET_INFO
{
    DWORD               dwSize;
}NET_IN_DBGINFO_GET_INFO;

// �ض���״̬
typedef enum tagEM_DBGINFO_REDIR_STATUS
{
    EM_DBGINFO_REDIR_STATUS_UNKNOWN,    // δ֪
    EM_DBGINFO_REDIR_STATUS_NO,         // δ�ض���
    EM_DBGINFO_REDIR_STATUS_LOCAL,      // �ض��򵽱���
    EM_DBGINFO_REDIR_STATUS_CALLBACK,   // �ض��򵽻ص�
}EM_DBGINFO_REDIR_STATUS;

// �ļ���Ϣ
typedef struct tagNET_DBGINFO_FILEINFO
{
    char                szFilePath[128]; // ���ɵ��ļ�·��
    unsigned int        nFileSize;       // ���ɵ��ļ���С,��λ�ֽ�
    BYTE                byReserverd[260];// ����
}NET_DBGINFO_FILEINFO;

// ��ȡ��־�ض������Ϣ����
typedef struct tagNET_OUT_DBGINFO_GET_INFO
{
    DWORD               dwSize;
    EM_DBGINFO_REDIR_STATUS emStatus;    // �ض���״̬
    NET_DBGINFO_FILEINFO stuFile[10];    // �ļ���Ϣ
    int                  nRetFileCount;  // ���ص�stuFile��Ч�ĸ���
}NET_OUT_DBGINFO_GET_INFO;

// ��ȡ�ɼ�������־�豸���������
typedef struct tagNET_IN_DBGINFO_GET_CAPS
{
    DWORD               dwSize;
}NET_IN_DBGINFO_GET_CAPS;

// ��ȡ�ɼ�������־�豸����������
typedef struct tagNET_OUT_DBGINFO_GET_CAPS
{
    DWORD               dwSize;
    BOOL                bSupportRedir;        // �Ƿ�֧�ִ�����־�ض��򣬰������ļ��ͻص����֡�
}NET_OUT_DBGINFO_GET_CAPS;

// ������־�������� CLIENT_OperateDebugInfo
typedef enum tagEM_DBGINFO_OP_TYPE
{
    EM_DBGINFO_OP_REDIR_SET_LOCAL,            // ���ô��ڴ�ӡ�ض��򵽱��ش洢 pInParam = NET_IN_DBGINFO_SET_REDIR_LOCAL, pOutParam = NET_OUT_DBGINFO_SET_REDIR_LOCAL
    EM_DBGINFO_OP_REDIR_CANCEL_LOCAL,         // ȡ�����ڴ�ӡ�ض��򵽱��ش洢 pInParam = NET_IN_DBGINFO_CANCEL_REDIR_LOCAL, pOutParam = NET_OUT_DBGINFO_CANCEL_REDIR_LOCAL
    EM_DBGINFO_OP_GET_INFO,                   // ��ȡ��־�ض������Ϣ pInParam = NET_IN_DBGINFO_GET_INFO, pOutParam = NET_OUT_DBGINFO_GET_INFO
    EM_DBGINFO_OP_GET_CAPS,                   // ��ȡ�ɼ�������־�豸������ pInParam = NET_IN_DBGINFO_GET_CAPS, pOutParam = NET_OUT_DBGINFO_GET_CAPS
}EM_DBGINFO_OP_TYPE;

// ������־�ص�����
typedef void (CALLBACK *fDebugInfoCallBack)(LLONG lAttchHandle, BYTE *pBuffer, DWORD dwBufSize, LDWORD dwUser);

// ��־�ȼ�
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

// ������־�ص����
typedef struct tagNET_IN_ATTACH_DBGINFO
{
    DWORD               dwSize;
    EM_DBGINFO_LEVEL    emLevel;        // ��־�ȼ�
    fDebugInfoCallBack  pCallBack;      // �ص� 
    LDWORD              dwUser;         // �û�����
}NET_IN_ATTACH_DBGINFO;

// ������־�ص�����
typedef struct tagNET_OUT_ATTACH_DBGINFO
{
    DWORD               dwSize;    
}NET_OUT_ATTACH_DBGINFO;

//////////////////////////////// ������־ /////////////////////////////////
// ������־�����ӿ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_OperateDebugInfo(LLONG lLoginID, EM_DBGINFO_OP_TYPE emType, void* pInParam, void* pOutParam, int nWaitTime);

// ���ĵ�����־�ص�
CLIENT_NET_API LLONG CALL_METHOD CLIENT_AttachDebugInfo(LLONG lLoginID, const NET_IN_ATTACH_DBGINFO* pInParam, NET_OUT_ATTACH_DBGINFO* pOutParam, int nWaitTime);

// �˶�������־�ص�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_DetachDebugInfo(LLONG lAttachHanle);

// CLIENT_SetInternalControlParam ���
typedef struct tagNET_INTERNAL_CONTROL_PARAM
{
	DWORD							dwSize;										// �ṹ���С
	UINT							nThreadSleepTime;							// �ڲ��߳�˯�߼������Χ[10, 100]��unit:ms��Ĭ��10	
	UINT							nSemaphoreSleepTimePerLoop;					// �ȴ��ź���ʱ���ڲ��߳�˯�߼������Χ[10, 100]��unit:ms��Ĭ��10
}NET_INTERNAL_CONTROL_PARAM;

// �����ڲ����Ʋ��������ƣ�
CLIENT_NET_API BOOL CALL_METHOD CLIENT_SetInternalControlParam(const NET_INTERNAL_CONTROL_PARAM *pInParam);

#ifdef __cplusplus
}
#endif



#endif // DHNETSDKEX_H



