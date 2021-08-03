//
//  Copyright (c) 2015年 Dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCRecordInfo.h"

NS_ASSUME_NONNULL_BEGIN

#define kCategorysTypeHumanAlarm    @"humanAlarm"
#define kCategorysTypeFaceAlarm     @"faceAlarm"
#define kCategorysTypeCarAlarm      @"carAlarm"
#define kCategorysTypeAbSoundAlarm  @"abSoundAlarm"
#define kCategorysTypeMotionAlarm   @"motionAlarm"
#define kCategorysTypeOther         @"other"

enum MessageType
{
    MessageTypeAlarm = 0,       // ipc动态检测，人体红外报警
    MessageTypeSystem,
    MessageTypeIndicator,       // 感应器人体红外报警
    MessageTypeSmoke,           // 烟感报警
    MessageTypeLowPower,        // 低电压
    MessageTypeMotion           // 移动感应器
};

typedef enum
{
    Chn_MessageType_Device = 0,       // 设备报警
    Chn_MessageType_AP,               // 网关报警
    Chn_MessageType_BLE               // 蓝牙
}Chn_MessageType;

@class DetectModel;
@class LCHomePageAlarmInfo;

@interface LCChnMessageInfo : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString   *deviceId;	/**< 如果是配件，表示配件id */
@property (nonatomic, copy) NSString   *channelId;
@property (nonatomic, copy) NSString   *channelDeviceId; /**< 如果是配件，表示deviceId */
@property (nonatomic, copy) NSString   *channelName;
@property (nonatomic, assign) int      alarmType;//0：人体红外,1：动态检测,2：未知告警,3：低电压告警,4：配件人体红外检测,5：移动感应器发生移动事件,6：移动感应器长时间未发生移动事件,7: 配件人体红外检测长久未报警事件,8: 门磁报警事件
@property (nonatomic, copy)   NSString   *alarmTypeStr;
@property (nonatomic, copy)   NSString   *title;  // 展示文案
@property (nonatomic, copy)   NSString   *remark;
@property (nonatomic, copy)   NSString   *token;
@property (nonatomic)         int64_t    time;//最新报警时间UNIX时间戳秒
@property (nonatomic, copy) NSString   *thumbUrl;//缩略图地址
@property (nonatomic)         int        unreadCount;//未读数
@property (nonatomic, copy) NSString   *channelDeviceType;//通道设备的类型
@property (nonatomic, assign) Chn_MessageType chnMessageType;//消息类型  融合版本新增字段
@property (nonatomic, copy) NSString *lrecordStopTime;    //认本地录像播放时长
@property (nonatomic, strong) NSMutableArray *detectArray;
@property (nonatomic, strong) NSMutableArray *picUrlArray;
@property (nonatomic, assign) BOOL isVeriFace;//[O]人脸识别-陌生人报警(smartStrangerAppear)的陌生人人脸是否可以加入人脸库
@property (nonatomic, copy) NSString   *alarmIdStr;//String类型的告警消息ID,海外pc使用
@property (nonatomic, assign) int64_t   alarmId;
@property (nonatomic, copy) NSString   *timeStr;//设备本地报警时间,格式yyyyMMddTHHmmss
@property (nonatomic, copy) NSString   *authority;//当前用户对设备的权限集合，同时在多个部门时取并集

@end

@interface LCHomePageChannelOrApAlarmList : NSObject<NSCoding>

@property (nonatomic, copy) NSString   *channelId;
@property (nonatomic, copy) NSString   *channelName;
@property (nonatomic, copy) NSString   *apId;
@property (nonatomic, copy) NSString   *apName;
@property (nonatomic, copy) NSString   *apType;
@property (nonatomic, copy) NSString   *messageFlag;

@property (nonatomic, strong) NSArray<LCHomePageAlarmInfo *> *alarms;

@end

@interface LCHomePageAlarmInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString   *token;
@property (nonatomic, assign) int64_t   alarmId;
@property (nonatomic, copy) NSString   *alarmIdStr;//String类型的告警消息ID,海外pc使用
@property (nonatomic, copy) NSString   *type;
@property (nonatomic, copy) NSString   *labelType;
@property (nonatomic, copy) NSString   *typeInt;
@property (nonatomic, copy) NSString   *time;
@property (nonatomic, strong) NSMutableArray<NSString *>   *picUrls;
@property (nonatomic, copy) NSString   *lrecordStopTime;
@property (nonatomic, copy) NSString   *thumbUrl;
@property (nonatomic, copy) NSString   *remark;
@property (nonatomic, copy) NSString   *title;
@property (nonatomic, copy) NSString   *subType;
@property (nonatomic, strong) NSArray<DetectModel *>   *detect;
@property (nonatomic, assign) BOOL hasLinkage;
@property (nonatomic, assign) BOOL isVeriFace;
@property (nonatomic, assign) BOOL isStopSosAlarm;
@property (nonatomic, copy) NSString   *serverTime;

@end

@interface LCRequestLatestAlarmMessage : NSObject
@property (nonatomic, copy)     NSString                  *deviceId; //设备序列号
@property (nonatomic, strong)   NSArray                   *channelIds; //通道号
@property (nonatomic, strong)   NSArray                   *apIds; // 配件设备序列号
@property (nonatomic, copy) NSString *lrecordStopTime;    //认本地录像播放时长

@end

@interface LCHomeAlarmMessageRequestInfo: NSObject

@property(nonatomic, copy) NSString *deviceId; //设备序列号
@property(nonatomic, strong) NSArray *channelIds;
@property(nonatomic, strong) NSArray *apIds;
@property (nonatomic, copy) NSString *lrecordStopTime;    //认本地录像播放时长

@end

@interface LCHomeAlarmChannelOrApRequestInfo : NSObject

@property(nonatomic, copy) NSString *channalId;
@property(nonatomic, copy) NSString *apId;
@property(nonatomic, strong) NSArray *alarmId;

@end

@interface LCChnMessageInfoList : NSObject

@property (nonatomic, copy)     NSString                  *deviceId; //设备序列号
@property (nonatomic, strong)   NSArray                   *chnAlarms;//普通通道报警  融合版本新增字段
@property (nonatomic, strong)   NSArray                   *apAlarms;//配件报警   融合版本新增字段
@end

@interface LCHomePageDeviceMessageList : NSObject<NSCoding>

@property (nonatomic, copy)     NSString                  *deviceId; //设备序列号
@property (nonatomic, strong)   NSArray<LCHomePageChannelOrApAlarmList *>   *chnAlarms;//普通通道报警  融合版本新增字段
@property (nonatomic, strong)   NSArray<LCHomePageChannelOrApAlarmList *>   *apAlarms;//配件报警   融合版本新增字段
@end

@interface LCMessageListInfo : NSObject

@property (nonatomic, assign)   int                 unread; //查询返回的消息组的总未读数
@property (nonatomic, strong)   NSMutableArray      *msgList; //查询返回的消息组 LCMessageInfo

@end

@interface LCMessageInfo : NSObject

/*
 [O]mute 代表消音报警类型,存在多个子类型用逗号隔开
 */
@property (copy, nonatomic) NSString *subType;

@property (nonatomic, assign)   int64_t             time; /**< 报警发生的时间 */
@property (nonatomic, assign)   int64_t             serverTime; /**< 门铃呼叫，解决设备时间不准确的问题 */
@property (nonatomic, assign)   int64_t             timeReceived; /**< 报警接收的时间 */
@property (nonatomic, copy)     NSString            *timeStr; /**< 报警发生的时间 */
@property (nonatomic, assign)   BOOL                appStateReceived; //app接收到消息时的AppState 0表示app处于前台，1表示app处于后台
@property (nonatomic, assign)   int64_t             msgId;
@property (nonatomic, assign)   BOOL                bChecked;
@property (nonatomic, assign)   int                 msgType;
@property (nonatomic, copy)     NSString            *msgTypeStr;  // 报警类型字段(小的类型)
@property (nonatomic, copy)     NSString            *msgCategorys; // 报警类型（大的类型，可能存在多个大类）
@property (nonatomic, strong)   NSMutableArray      *categorysArr; // 通过报警消息大类字符串转化成对应的枚举类型数组

@property (nonatomic, copy)     NSString            *msgTypeDescription;
@property (nonatomic, copy)     NSString            *msgDescription;
@property (nonatomic, copy)     NSString            *url;
@property (nonatomic, copy)     NSString            *deviceCode;
@property (nonatomic, copy)     NSString            *channelCode;
@property (nonatomic, copy)     NSString            *devOrChlName;
@property (nonatomic, copy)     NSString            *remark;    /** [O]备注字段。如果是低电量，填写电量百分比0-100。 */
@property (nonatomic, strong)   NSMutableArray      *picUrlArray;
@property (nonatomic, strong)   NSMutableArray      *detectArray;
@property (nonatomic, copy)     NSString            *devPartCode;               //设备下的配件ID
@property (nonatomic, assign)   int                 unreadNum;
@property (nonatomic, assign)   BOOL                hasLinkage; /**< V2.1新增字段:是否有联动告警 */
@property (nonatomic, copy)     NSString            *desc;    /**< V3.2新增字段:报警详情描述 */
@property (nonatomic, copy)     NSString            *aptype;    /**< V2.1新增字段:配件类型 */

@property (nonatomic, assign)   int64_t             videoMsgRecordID; /**< V2.7新增字段:留言消息对应的录像ID */
@property (nonatomic, copy)     NSString            *videoMsgTitle; /**< V2.7新增字段:留言消息标题 */
@property (nonatomic, strong)   LCRecordInfo        *videoMsgRecordInfo; /**< V2.7新增字段:留言消息录像信息 */

@property (nonatomic, copy)     NSString            *pageType; /**< V2.8新增字段:页面类型 */
@property (nonatomic, copy)     NSString            *pageName; /**< V2.8新增字段:页面图标名称 */
@property (nonatomic, copy)     NSString            *pageLogoUrl; /**< V2.8新增字段:页面图标url */
@property (nonatomic, copy)     NSString            *pageUrl; /**< V2.8新增字段:页面地址url */

@property (nonatomic, strong)   LCRecordInfo        *oneDayRecordInfo; /**< V3.3.5新增字段:精彩一天录像信息 */
@property (nonatomic, copy)     NSString            *token; /**融合版本新增 token，用于查询云录像 */
@property (nonatomic, assign)   int                 mId; /**融合版本新增 mId，Easy4ip主键 */
@property (nonatomic, assign)   Chn_MessageType     chnMessageType;;/**融合版本新增 chnMessageType，消息类型 */
@property (nonatomic, assign)   int                 tag;/**融合版本新增 tag，二进制起始标志  00 01 10 11 */
@property (nonatomic, copy)     NSString            *region;/** 录像区域唯一标识id */
@property (nonatomic, assign)   BOOL                isVideoMsg;/** 是否是留言消息 */
@property (nonatomic, assign)   BOOL                isPicMsg;/** DB10 是否图片消息 */

@property (nonatomic, copy)     NSString            *title; /// v3.5新增字段，展示的文案

@property (nonatomic, assign)   BOOL                isStopSosAlarm;/** [bool][O]SOS报警状态，true表示停止 */

@property (nonatomic, copy,nullable)   NSString *lrecordStopTime;    //认本地录像播放时长
@property (nonatomic, copy)    NSString             *labelType; /// 消息筛选类型 3.15.0 增加
@end

@interface DetectModel : NSObject<NSCoding>

@property (nonatomic, copy)     NSString            *type ;             //检测类型，1-人形检测
@property (nonatomic, copy)     NSString            *result ;           //人形结果，0-不准确 1-准确

@end

@interface LCPushCenterMessageInfo : NSObject <NSCoding, NSCopying> //V2.3新增推送中心信息 包括系统,个人,活动

@property (nonatomic, assign)   int                 msgType;
@property (nonatomic, copy)     NSString            *msgTypeStr;
@property (nonatomic, assign)   int64_t             msgId;
@property (nonatomic, assign)   int64_t             msgUNIXTime;
@property (nonatomic, copy)     NSString            *msgTitle;
@property (nonatomic, copy)     NSString            *msgContent;
@property (nonatomic, copy)     NSString            *msgUrl;
@property (nonatomic, copy)     NSString            *deviceId;
@property (nonatomic, copy)     NSString            *channelId;
@property (nonatomic, copy)     NSString            *imgUrl;    /**< V2.3新增字段:活动中心消息展示图url */
@property (nonatomic, copy)     NSString            *templateParam;
@property (nonatomic, copy)     NSString            *contentH5Url;
@end

@interface LCGroupMsgInfo : NSObject
@property (nonatomic, copy)     NSString            *msgDate;
@property (nonatomic, strong)   NSMutableArray      *msgList;
@end

@interface LCChannelRemindPlan : NSObject
@property (nonatomic, copy)     NSString    *channelID;
@property (nonatomic, strong)   NSMutableArray  *remindRluleList;
@end


@interface LCRemindRule : NSObject<NSCopying>
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, assign) BOOL enable;
@end

/**
 *  V2.1新增：联动的消息列表
 */
@interface LCLinkageMessage : NSObject
@property (nonatomic, assign) int type;/** [int]报警类型 */
@property (nonatomic, copy) NSString  *thumbUrl;/** 缩略图URL */
@property (nonatomic, copy) NSString  *remark;/** 备注字段。如果是低电量，填写电量百分比。 */
@property (nonatomic, copy) NSString  *deviceId;/** 设备ID */
@property (nonatomic, assign) int64_t alarmId;/** [long]联动消息ID */
@property (nonatomic, copy) NSString  *channelDeviceId;/** 通道所接的设备ID */
@property (nonatomic, assign) int64_t time;/** [long]报警时间UNIX时间戳秒 */
@property (nonatomic, assign) int readFlag;/** [int]是否已读。0未读，1已读 */
@property (nonatomic, copy) NSString  *channelId;/** 通道号 */
@property (nonatomic, strong)NSMutableArray  *picurlArray; /** 报警图片url */  
@property (nonatomic, copy) NSString  *name;/** 设备或通道的名称 */
@end

/**
 *  saas protocol 配件联动的消息列表
 */
@interface DHSaasLinkageMessage : NSObject

@property (nonatomic, copy) NSString *token;/** String 可选 消息唯一标识，用于查询云录像 */
@property (nonatomic, assign) long long alarmId;/** Long 必须 联动消息ID */
@property (nonatomic, copy) NSString *deviceId;/** String 必须 设备ID */
@property (nonatomic, copy) NSString *channelId;/** String 必须 通道号 */
@property (nonatomic, copy) NSString *name;/** String 必须 设备或通道的名称 */
@property (nonatomic, assign) int type;/** Int 必须 报警类型 */
@property (nonatomic, copy) NSString *typeStr;/** NSString 必须 报警类型 */
@property (nonatomic, copy) NSString *time;/** String 必须 设备本地时间,,yyyyMMddTHHmmss格式 */
@property (nonatomic, strong) NSArray *picUrls;/** String 必须 报警图片url */
@property (nonatomic, copy) NSString *thumbUrl;/** String 必须 缩略图URL */
@property (nonatomic, copy) NSString *title;/** 展示的文案 */
@end

@interface DHApMessageInfo : NSObject

@property (nonatomic, assign) long long alarmId;/** Long 必须 消息ID */
@property (nonatomic, copy) NSString *deviceId;/** String 必须 网关设备ID */
@property (nonatomic, copy) NSString *apId;/** String 必须 配件ID */
@property (nonatomic, copy) NSString *apName;/** String 必须 配件的名称 */
@property (nonatomic, assign) int type;/** Int 必须 报警类型 */
@property (nonatomic, copy) NSString *typeStr;/** String 必须 报警类型 */
@property (nonatomic, copy) NSString *time;/** String 必须 设备本地时间,,yyyyMMddTHHmmss格式 */
@property (nonatomic, assign) BOOL hasLinkage;/** [bool]是否存在联动消息 */
@property (nonatomic, copy) NSString *remark;/** 备注字段。如果是低电量，填写电量百分比 */
@property (nonatomic, assign) int  unread;/** 未读消息 */
@property (nonatomic, copy) NSString *title;/** String 必须 配件ID */
@end

@interface LCAppVersion : NSObject
@property (nonatomic, copy) NSString *lastVersion;  //最新版本
@property (nonatomic, copy) NSString *apkUrl;       //最新版本的下载地址
@property (nonatomic, copy) NSString *baseVersion;  //基础版本（最低要求版本）
@property (nonatomic, copy) NSString *updateInfo;   //最新版本的更新信息
@property (nonatomic, copy) NSString *publishTime;  //新版发布时间
@property (nonatomic, assign) BOOL isForceUpgrade;  //是否强制升级
@end

@interface LCUpgradeInfo : NSObject
@property (nonatomic, copy) NSString *upgradeStatus;  //必须 升级类型。commonUpgrade(普通升级)、forceUpgrade(强制升级)、noUpgrade(无需升级)
@property (nonatomic, copy) NSString *lastVersion;  //最新版本
@property (nonatomic, copy) NSString *apkUrl;       //最新版本的下载地址
@property (nonatomic, copy) NSString *updateInfo;   //最新版本的更新信息
@property (nonatomic, assign) BOOL isForceUpgrade;  //是否强制升级
@end


typedef NS_ENUM(NSInteger, AdversimentShowType)
{
    AdversimentShowTypeWaiting, // 等待显示
    AdversimentShowTypeShowing, // 正在显示
    AdversimentShowTypeShowed,  // 已经显示 不一定需要
};

@interface LCGetAdversimentInfo  : NSObject <NSCopying, NSCoding>
@property(nonatomic, copy)     NSString  *advertPicUrl;     //广告图片Url地址
@property (nonatomic, assign)  int64_t   advertId;          //广告id
@property(nonatomic, copy)     NSString  *advertUrl;        //广告网页Url地址
@property (nonatomic, assign)  int64_t   time;              //[long]更新时间，UNIX时间
@property(nonatomic, copy)     NSString *title;             //标题
@property (nonatomic, assign)  int64_t   countDown;         //广告倒计时
@property(nonatomic, copy)     NSString  *logoPicUrl;       //logo图片Url地址
@property (nonatomic, assign)  int64_t   logoId;            //[long]logo活动的id
@property(nonatomic, copy)     NSString  *logoUrl;          // 跳转网页Url地址

@property (nonatomic, assign)   AdversimentShowType  showType; //广告的显示状态
@end

@interface LCCallRecordInfo : NSObject
@property (nonatomic, assign) int64_t callRecordId;/** Long 必须 呼叫记录id */
@property (nonatomic, copy) NSString *status;/** String 必须  answer:接听,call:未接听 */
@property (nonatomic, copy) NSString *recordTime;/** String 必须 设备呼叫本地时间,yyyyMMddTHHmmss格式 */
@property (nonatomic, copy) NSString *title;/** String 必须 展示的文案 */

@end

@interface LCOpenDoorRecordInfo : NSObject
@property (nonatomic, assign) int64_t recordId;/** Long 必须 呼叫记录id */
@property (nonatomic, copy) NSString *name;/** String 必须  钥匙名称 */
@property (nonatomic, copy) NSString *type;/** String 必须  钥匙类型，password:密码；card:卡；fingerPrint：指纹；snapkey:临时秘钥 */
@property (nonatomic, copy) NSString *recordTime;/** String 必须 设备呼叫本地时间,yyyyMMddTHHmmss格式 */
@property (nonatomic, copy) NSString *title;/** String 必须 展示的文案 */

@end

@interface LCClouStoreUrls : NSObject
@property (nonatomic, copy) NSString *storageStrategyDetailUrl;/** String 云存储详情url */
@property (nonatomic, copy) NSString *storageStrategyBuyUrl;/** String 云存储购买url */
@property (nonatomic, copy) NSString *userStorageStrategyUrl;/** String 我的云存储url */
@end

NS_ASSUME_NONNULL_END
