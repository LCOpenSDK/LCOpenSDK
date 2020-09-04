//
//  Header.h
//  appDemo
//
//  Created by chenjian on 15/5/25.
//  Copyright (c) 2015年 yao_bao. All rights reserved.
//

#ifndef LCOpenSDKDemo_RestApiService_h
#define LCOpenSDKDemo_RestApiService_h

#import "LCOpenSDKDynamic.h"
#import "RestApiInfo.h"

extern const NSString* NETWORK_TIMEOUT;
extern const NSString* MSG_SUCCESS;
extern const NSString* MSG_DEVICE_ONLINE;
extern const NSString* MSG_DEVICE_OFFLINE;
extern const NSString* MSG_DEVICE_IS_BIND;
extern const NSString* MSG_DEVICE_NOT_BIND;

@interface RestApiService : NSObject

+ (instancetype)shareMyInstance;

- (NSString *)getToken;

- (void)initComponent:(LCOpenSDK_Api*)hc Token:(NSString*)accessTok_In;

- (BOOL)getDevList:(NSMutableArray*)info_Out Begin:(NSInteger)beginIndex_In End:(NSInteger)endIndex_In Msg:(NSString**)errMsg_Out;

- (BOOL)beAuthDeviceList:(NSMutableArray*)info_Out Begin:(NSInteger)beginIndex_In End:(NSInteger)endIndex_In Msg:(NSString**)errMsg_Out;

- (BOOL)shareDeviceList:(NSMutableArray*)info_Out Begin:(NSInteger)beginIndex_In End:(NSInteger)endIndex_In Msg:(NSString**)errMsg_Out;

- (BOOL)checkDeviceOnline:(NSString*)devID_In Msg:(NSString**)errMsg_Out;

- (BOOL)checkDeviceBindOrNot:(NSString*)devID_In Msg:(NSString**)errMsg_Out;

- (BOOL)unBindDeviceInfo:(NSString*)devID_In Ability:(NSString**)ability Msg:(NSString**)errMsg_Out;

- (BOOL)bindDevice:(NSString*)devID_In Code:(NSString *)code Msg:(NSString**)errMsg_Out;

- (BOOL)unBindDevice:(NSString*)devID_In Msg:(NSString**)errMsg_Out;

- (BOOL)getBindDeviceInfo:(NSString*)devID_In Info_out:(DeviceInfo*)info_out Msg:(NSString**)errMsg_Out;

- (BOOL)getBindDeviceChannelInfo:(NSString*)devID_In  Chnl:(NSString*)iCh_In Info_out:(DeviceInfo*)info_out Msg:(NSString**)errMsg_Out;

- (BOOL)getDeviceVersion:(NSString *)devID_In Info_out:(DeviceInfo *)info_out Msg:(NSString**)errMsg_Out;

- (BOOL)getAlarmMsg:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In Info:(NSMutableArray*)msgInfo_Out Count:(NSInteger)count_In Msg:(NSString**)errMsg_Out;

- (BOOL)deleteAlarmMsg:(int64_t)alarmId Msg:(NSString**)errMsg_Out;

- (BOOL)getRecordNum:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In Num:(NSInteger*)num_Out Msg:(NSString**)errMsg_Out;

- (BOOL)getRecords:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In IndexBegin:(NSInteger)beginIndex_In IndexEnd:(NSInteger)endIndex_In InfoOut:(NSMutableArray*)info_Out Msg:(NSString**)errMsg_Out;

- (BOOL)getCloudRecordNum:(NSString*)devID_In Chnl:(NSInteger)iCh_In Bengin:(NSString*)beginTime_In End:(NSString*)endTime_In Num:(NSInteger*)num_Out Msg:(NSString**)errMsg_Out;

- (BOOL)getCloudRecords:(NSString*)devID_In Chnl:(NSInteger)iCh_In Begin:(NSString*)beginTime_In End:(NSString*)endTime_In IndexBegin:(NSInteger)beginIndex_In IndexEnd:(NSInteger)endIndex_In InfoOut:(NSMutableArray*)info_Out Msg:(NSString**)errMsg_Out;

- (BOOL)controlPTZ:(NSString*)devID_In Chnl:(NSInteger)iCh_In Operate:(NSString*)strOperate_In Horizon:(double)iHorizon_In Vertical:(double)iVertical_In Zoom:(double)iZoom_In Duration:(NSInteger)iDuration_In Msg:(NSString**)errMsg_Out;

- (BOOL)modifyDeviceAlarmStatus:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(BOOL)enable_In Msg:(NSString**)errMsg_Out;

- (BOOL)setStorageStrategy:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(NSString*)enable_In Msg:(NSString**)errMsg_Out;

- (BOOL)setAllStorageStrategy:(NSString*)devID_In Chnl:(NSInteger)iCh_In Enable:(NSString*)enable_In Msg:(NSString**)errMsg_Out;

- (BOOL)getStorageStrategy:(NSString*)devID_In Chnl:(NSInteger)iCh_In Info_out:(DeviceInfo*)info_out Msg:(NSString**)errMsg_Out;

- (BOOL)modifyDevicePwd:(NSString *)devID_In oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd Msg:(NSString **)errMsg_Out;

- (BOOL)upgradeDevice:(NSString *)devID_In Msg:(NSString **)errMsg_Out;

- (BOOL)upgradeProcessDevice:(NSString *)devID_In Msg:(NSString **)errMsg_Out InfoOut:(DeviceUpgradeProcess*)info_Out;

- (BOOL)userBandNoVerify:(NSString*)account errcode:(NSString*)errCode Msg:(NSString **)errMsg_Out;

- (BOOL)userTokenByAccount:(NSString*)account userToken:(NSString*)userToken expireTime:(NSString*)expireTime errcode:(NSString*)errCode Msg:(NSString **)errMsg_Out;



@end
#endif
