//
//  Copyright © 2019 dahua. All rights reserved.
//

#ifndef DHMessageDaoProtocol_h
#define DHMessageDaoProtocol_h

#import <LCBaseModule/LCMessageInfo.h>
#import "DHModule.h"

#pragma mark - message module

typedef NS_ENUM(NSInteger, LCMessageEditActionType){
    LCMessageEditActionTypeRead,
    LCMessageEditActionTypeDelete,
    LCMessageEditActionTypeClearBegin,
    LCMessageEditActionTypeMarkBeginTag,
    LCMessageEditActionTypeMarkEndTag,
    LCMessageEditActionTypeMarkBeginEndTag,
};

@protocol DHMessageDaoProtocol <NSObject>

/**
 从数据库中获取某一条报警消息

 @param deviceID 设备ID
 @param chnOrApID 通道或配件ID
 @param msgID 消息ID
 @param chnMsgType 消息通道类型——通道、配件
 @return 查询结果
 */
- (LCMessageInfo *)getAlarmMsgFromDBByDeviceID:(NSString *)deviceID ChannelOrApID:(NSString *)chnOrApID MsgID:(int64_t)msgID ChnMessageType:(Chn_MessageType)chnMsgType;

/**
 **********在分类中重写该方法**********
 消息列表编辑,单/多选标记或删除
 
 @param editActionType LCMessageEditActionTypeRead,LCMessageEditActionTypeDelete
 @param deviceID 设备ID
 @param channelID 通道ID
 @param msgIDs 消息IDs
 @param beginTime 查询起始时间
 @param endTime 查询截至时间
 
 */
- (void)editMessagesActionType:(LCMessageEditActionType)editActionType
                      DeviceID:(NSString *)deviceID
                     ChannelID:(NSString *)channelID
                        MsgIds:(NSArray *)msgs
                    chnMsgType:(Chn_MessageType)chnMsgType
                     BeginTime:(int64_t)beginTime
                       EndTime:(int64_t)endTime
                   IsSelectAll:(BOOL)isSelectAll
                   resultBlock:(void(^)(BOOL result))resultBlock;

/**
 根据日期、设备、通道信息获取消息列表

 @param date 报警日期
 @param deviceId 设备序列号
 @param channelId 通道号
 @return 成功返回消息列表
 */
- (NSMutableArray<LCMessageInfo *> *)getMessageInfosByDate:(NSString *)date
                                 deviceId:(NSString *)deviceId
                                channelId:(NSString *)channelId
                               chnMsgType:(Chn_MessageType)chnMsgType
                                beginTime:(int64_t)beginTime;

@end

#endif /* DHMessageDaoProtocol_h */
