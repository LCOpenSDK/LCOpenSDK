//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCEncryptInfo.h"

@class LCDevice;

/**
 通道封面图类型
 */
typedef NS_ENUM(NSInteger, LCChannelPicType ) {
    LCChannelPicTypeUnkown,        /**< 未定义 */
    LCChannelPicTypeAuto,        /**< 自动抓图 */
    LCChannelPicTypeCustom,        /**< 自定义 */
};

/**
 设备/通道状态
 */
typedef NS_ENUM(NSInteger, LCOnlineStatus) {
    LCOnlineStatusOnline,        /**< 在线 */
    LCOnlineStatusOffline,        /**< 离线 */
    LCOnlineStatusSleep,        /**< 睡眼 */
    LCOnlineStatusClose,        /**< 未配置 */
    LCOnlineStatusUpgrading,    /**< 升级中 */
};


@interface LCIntroductionContentItem: NSObject
@property (nonatomic, copy) NSString *introductionName; /**< String 必须 引导提示名称，app自定义，用于区分，统计好后发给平台录入 */
@property (nonatomic, copy) NSString *introductionContent; /**< String 必须 引导提示内容 */
@end

/*************** LCDevice ***************/

@interface LCDevice : NSObject<NSCopying, NSCoding>
//ID，也是序列号
@property (nonatomic, copy)   NSString        *deviceID;
//bindid ,分组id
@property (nonatomic, copy)   NSString        *bindId;
//设备是否在线
@property (nonatomic, assign) BOOL            isOnline;
//[int]当前状态：0-离线，1-在线，3-升级中，5-休眠中
@property (nonatomic, assign) int             status;
//视频通道的总数量
@property (nonatomic, assign) int             channelNum;
//设备基线类型，详见华视微讯设备协议
@property (nonatomic, copy)   NSString        *baseline;
//加密模式
@property (nonatomic, assign) int             encryptMode;
//型号
@property (nonatomic, copy)   NSString        *deviceModel;
//设备外部型号
@property (nonatomic, copy)   NSString        *deviceModelName;
//设备分类[NVR/DVR/HCVR/IPC/SD]
@property (nonatomic, copy)   NSString        *deviceCatalog;
//品牌：lechange表示乐橙，general表示通用
@property (nonatomic, copy)   NSString        *deviceBrand;
//设备软件版本号
@property (nonatomic, copy)   NSString        *deviceVersion;
//名字
@property (nonatomic, copy)   NSString        *deviceName;
//设备名称
@property (nonatomic, copy)   NSString        *deviceUsername;
//设备密码
@property (nonatomic, copy)   NSString        *devicePassword;
//DMS服务器的IP
@property (nonatomic, copy)   NSString        *dmsIP;
//能力集
@property (nonatomic, copy)   NSString        *ability;
//是否有新版本可以升级
@property (nonatomic, assign) BOOL            isNeedUpdate;
//是否已被分享
@property (nonatomic, assign) BOOL            isSharedTo;
//是否分享设备
@property (nonatomic, assign) BOOL            isSharedFrom;
// 1表示别人分享给自己的设备，2表示别人授权给自己的设备
@property (nonatomic, assign) int             shareState;
// （isSharedTo为YES时有效）0共享且授权给别人 1表示共享给别人的设备，2表示授权给别人的设备
@property (nonatomic, assign) int             beShareToState;
//分享者的用户名
@property (nonatomic, copy)   NSString        *ownerUsername;
//分享者的昵称
@property (nonatomic, copy)   NSString        *ownerNickname;
//分享者头像
@property (nonatomic, copy)   NSString        *urlShareUser;
//设备LOGO
@property (nonatomic, copy)   NSString        *urlDeviceLogo;
//全景图
@property (nonatomic, copy)   NSString        *urlPano;
//通道列表
@property (nonatomic, strong) NSMutableArray  *channelList;
//网关配件列表
@property (nonatomic, strong) NSMutableArray  *apList;
//AD2空气探测器
@property (nonatomic, strong) NSMutableArray  *airDetectionList;
//是否可用tls连接
@property (nonatomic, assign) BOOL tlsEnable;
//tls私有端口
@property (nonatomic, strong) NSString *tlsPrivatePort;
/***************** 附加属性 *****************/
//分享时间
@property (nonatomic, assign) int64_t  shareTime;
//展示设备类型——
@property (nonatomic, copy)   NSString *deviceCategory;
//配件列表
@property (nonatomic, strong) NSMutableArray *zbList;
//网关布防按钮状态
@property (nonatomic, assign) int agEnableState; //0未知默认 1开启 2未知开启 3关闭 4未知关闭
///设备接入是否通过乐橙pass协议
@property (nonatomic, assign) int paasFlag; /**< 0通过老的乐橙平台接入， 1通过乐橙paas协议接入 */

@end

/**************** LCChannel ****************/

@interface LCChannel : NSObject<NSCopying, NSCoding>

//封面图地址
@property (nonatomic, copy)   NSString  *picurl;
//通道号
@property (nonatomic, assign) int       channelID;
//通道名称
@property (nonatomic, copy)   NSString  *channelName;
//设备ID
@property (nonatomic, copy)   NSString  *deviceID;
//分享的功能列表
@property (nonatomic, copy)   NSString  *functions;
//通道能力级
@property (nonatomic, copy)   NSString  *channelAbility;
//兼容PC，可选，国内必须，设备归属属性 0：自己的设备，1：他人分享，2：他人授权，3：他人分享+授权
@property (nonatomic, assign) int       belong;

@property (nonatomic, copy)   NSString  *lastOffLineTime;
//是否分享给别人的
@property (nonatomic, assign) BOOL      isSharedTo;
//（isSharedTo为YES时有效）0共享且授权给别人  1 共享给别人   2 授权给别人
@property (nonatomic, assign) int       beShareToState;
//是否在线
@property (nonatomic, assign) BOOL      isOnline;
//0:异常  1 正常   2 无SD卡   3 格式化中
@property (nonatomic, assign) int       sdCardStatus;
//云存储状态：-1-未开通 0-已失效 1-使用中 2-套餐暂停
@property (nonatomic, assign) int       csStatus;
//设备通道最后一个套餐的过期时间,可选,csStatus为1或者2时有效,格式yyyyMMddTHHmmssZ格式
@property (nonatomic, copy) NSString  *csExpireTime;
//云存储类型：0-默认 1-收费套餐
@property (nonatomic, assign) int       csType;
//报警布撤防状态:0,撤防；1,布防
@property (nonatomic, assign) int       alarmStatus;
//动检提醒：1-开启 2-未开启
@property (nonatomic, assign) int       remindStatus;
//到期时间
@property (nonatomic, assign) int64_t   publicExpire;
//公开视频的token
@property (nonatomic, copy)   NSString  *publicToken;
///加密内容信息，为空时表示旧的加密模式
@property (nonatomic, strong) LCContentEncryptInfo *encryptInfo;
//通道动检时段信息
@property (nonatomic, strong) NSMutableArray *mdRules;
//摄像头是否被遮罩  0-未遮罩  1-遮罩     为了保存加载状态 添加-1 表示当前设备正在开启遮罩   -2 表示正在取消遮罩
@property (nonatomic, assign) int isCloseCamera;
/// 封面图类型
@property (nonatomic, assign) LCChannelPicType picType;

/****************** 附加属性，以lc_开头 *****************/
//设备地理位置，不用缓存
@property (nonatomic, strong) NSMutableDictionary *lc_userInfo;
// 1表示别人分享给自己的设备，2表示别人授权给自己的设备
@property (nonatomic, assign) int       lc_shareState;
//设备语音交互开关状态，不用缓存，0：未知，1：开，2：关
@property (nonatomic, assign) int       lc_dialogStatus;
//设备位置温度，不用缓存
@property (nonatomic, copy)   NSString *lc_temperature;
//设备位置天气，不用缓存
@property (nonatomic, copy)   NSString *lc_weather;
//设备地理位置，不用缓存
@property (nonatomic, copy)   NSString *lc_region;

- (id)lc_generateLCChannel;

/// 解决融合版本数据转换问题【只做数据转换时使用】
@property (nonatomic, strong) LCDevice *lc_pConvertDevice;


@end

@interface LCZBDevicePowerConsumptionMessage: NSObject

@property (nonatomic, copy)     NSString        *zbDeviceId;/** 配件ID */
@property (nonatomic, copy)     NSString        *name;/** 配件名称 */
@property (nonatomic, copy)     NSString        *channelId;/** 通道号 */
@property (nonatomic, assign)   double          total;/** [double]总耗电量 */
@property (nonatomic, assign)   double          monthToatl;/** 本月总耗电量 */
@property (nonatomic, strong)   NSMutableArray  *month;/** 从昨天开始，前一个月每天的耗电量，数组形式表示 */
@end

@interface LCDevicePowerConsumptionMessage : NSObject
@property (nonatomic, copy)     NSString        *deviceID;/** 设备ID */
@property (nonatomic, strong)   NSMutableArray  *zbDevicePowerList;/** 该设备下面所有配件的耗电信息 */
@end

@interface LCUserPowerConsumptionMessage : NSObject
@property (nonatomic, assign)   double   total;/** [double]总耗电量 */
@property (nonatomic, strong)   NSMutableArray  *month;/** [double]从昨天开始，前一个月每天的耗电量，数组形式表示 */
@end


/*********************************** LCDeviceShareInfo *********************************************/
//设备共享信息
@interface LCDeviceShareInfo : NSObject

//允许分享数量, 999表示不限制,999表示为vip
@property (nonatomic, assign) int      allowShareCount;
//剩余分享和授权的数量
@property (nonatomic, assign) int      leftShareCount;
//共享成员信息
@property (nonatomic, strong)  NSArray *shareInfos;

@end
//共享成员
@interface LCDeviceSharer : NSObject
//用户名
@property (nonatomic, copy)   NSString  *username;
//用户id
@property (nonatomic, copy)   NSString  *userId;
//昵称
@property (nonatomic, copy)   NSString  *nickname;
//备注名
@property (nonatomic, copy)   NSString  *remarkName;
//用户头像
@property (nonatomic, copy)   NSString  *userIcon;
//分享的功能，可选项见说明，用逗号分隔
@property (nonatomic, copy)   NSString  *functions;

//分享激活时间，UNIX时间戳，1970年秒数
@property (nonatomic, assign) int64_t   activeTime;
//操作类型，0删除，1增加，2更新
@property (nonatomic, assign) int       operation;

@end

@interface LCDeviceUpdateVersionList : NSObject

@property (nonatomic, copy)     NSString  *description;  /** 升级描述信息 */
@property (nonatomic, copy)     NSString  *deviceId;   /** 设备ID */
@property (nonatomic, copy)     NSString  *version;   /** 设备版本号 */
@property (nonatomic, copy)     NSString  *url;   /** 升级包url地址 */

@end

//@interface LCDeviceUpgradeInfo : NSObject
//
//@property (nonatomic, copy)     NSString    *deviceID;
//@property (nonatomic, copy)     NSString    *status;
//@property (nonatomic, copy)     NSString    *version;
//@property (nonatomic, assign)     int       percent;
//
//@end

@interface LCDeviceWifiInfo : NSObject

@property (nonatomic, copy)     NSString    *deviceID;
@property (nonatomic, assign)   BOOL        enabled;

@property (nonatomic, strong)   NSMutableArray  *wifiStatusList;

@end

@interface LCDeviceWifiStatus : NSObject

@property (nonatomic, copy)     NSString    *BSSID;
@property (nonatomic, copy)     NSString    *auth;
@property (nonatomic, copy)     NSString    *SSID;
@property (nonatomic, assign)     int       linkStatus;
@property (nonatomic, assign)     int       intensity;

@end

@interface LCChannelAlarmPlan : NSObject

@property (nonatomic, copy)     NSString    *channelID;
@property (nonatomic, strong)   NSMutableArray  *alarmRluleList;

@end

@interface LCAlarmRule : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, assign)   BOOL        enable;
@property (nonatomic, copy)     NSString    *period;
@property (nonatomic, copy)     NSString    *beginTime;
@property (nonatomic, copy)     NSString    *endTime;
@property (nonatomic, assign)   BOOL        bPlus;

@end

@interface LCAlarmMode : NSObject
@property (nonatomic, copy)     NSString    *AlarmMode;/** 两种模式：Normal或Timing */
@property (nonatomic, assign)   int         TimeLimit;/** [int]长时间没有发生事件的时限，单位为秒 */
@end

@interface DeviceModelInfo : NSObject
@property (nonatomic, copy)     NSString    *logoUrl; /** 该型号对应的设备logo图片url */
@property (nonatomic, copy)     NSString    *deviceCatalog; /**设备分类【NVR/DVR/HCVR/IPC/SD/IHG】*/
@property (nonatomic, assign)   int         type; /** 型号分类（0-配件 1-设备） */
@property (nonatomic, copy)     NSString    *modelName; /** 型号名称（设备外部型号） */
@property (nonatomic, strong)   NSArray     *wifiConfigMode; /** 设备支持的WIFI配置方式数组，可有多种方式*/
@property (nonatomic, strong)   NSArray     *faqs;/** 存放NSDictionary类型 {@"picUrl":@"帮助图片URL", @"caption":@"文字说明"} */
@property (nonatomic, copy)     NSString    *brand;/**< 设备品牌*/
@property (nonatomic, strong)   NSArray     *moreDesc;/**< 存放NSDictionary类型 {@"picUrl":@"帮助图片URL", @"caption":@"文字说明"} */
@property (nonatomic, copy)     NSString *wifiTransferMode;/** 设备支持的wifi通信频段，支持多种频段，以逗号隔开，如2.4Ghz,5Ghz */
@end

@interface PublicLiveInfo : NSObject

//直播流hls访问地址
@property(nonatomic, copy)   NSString  *url;

//直播网页http地址
@property(nonatomic, copy)   NSString  *page;

//公开视频的token
@property(nonatomic, copy)   NSString  *token;

//公开到期时间，UNIX时间戳，单位秒。为0表示非公共视频【SaaS改成剩余时间】
@property(nonatomic, assign) int64_t   publicExpire;

@end

@interface PublicLiveStream : NSObject
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *page;
@end

//码流设置；
@interface VideoParameter : NSObject

@property (nonatomic, assign)   int       iFrameIntv;   /** [int]关键帧间隔 */
@property (nonatomic, assign)   int       streamId;   /** [int]流ID：0,1,2依次代表主码流、辅码流、辅码流2，以此类推。 */
@property (nonatomic, assign)   int       fps;   /** [int]帧率 */
@property (nonatomic, assign)   int       bitRate;   /** [int]码率，单位kbps */
@property (nonatomic, copy)     NSString  *resolution;   /** 分辨率，可选：1080P，720P，D1，CIF，QCIF */

@end

//用户授权
@interface LCPermission : NSObject

//用户允许的类型
@property (nonatomic, copy)   NSString *type;
//rue-授权 false-未授权
@property (nonatomic, assign) BOOL     flag;

@end

//WiFi配对信息上报
@interface LCWifiAutoPairInfo : NSObject

@property (nonatomic,assign) int index;
@property (nonatomic,strong) NSString *typeString;
@property (nonatomic,strong) NSString *resultString;
@property (nonatomic,strong) NSString *startTimeString;
@property (nonatomic,strong) NSString *endTimeString;
@property (nonatomic,strong) NSString *deviceSNString;
@property (nonatomic,strong) NSString *deviceTypeString;
@property (nonatomic,strong) NSString *phoneTypeString;
@property (nonatomic,strong) NSString *phoneVerString;
@property (nonatomic,strong) NSString *userNameString;
@property (nonatomic,assign) BOOL getDevRsp;
@property (nonatomic,assign) BOOL interruption;
@property (nonatomic,strong) NSString *routeInfoString;
@property (nonatomic,strong) NSString *dataString;

@end

@interface LCWeatherInfo : NSObject

//日期
@property (nonatomic,copy) NSString *date;
//白天天气
@property (nonatomic,copy) NSString *dayWeather;
//晚上天气
@property (nonatomic,copy) NSString *nightWeather;
//白天温度
@property (nonatomic,copy) NSString *dayTemperature;
//晚上温度
@property (nonatomic,copy) NSString *nightTemperature;

@end

@interface LCMotionDetectRulesInfo : NSObject

//每周X
@property (nonatomic,copy) NSString *period;
//开始时间
@property (nonatomic,copy) NSString *beginTime;
//截至时间
@property (nonatomic,copy) NSString *endTime;

@end

//解绑申请
@interface LCUnbindDeviceApplyListInfo : NSObject<NSCopying, NSCoding>

@property (nonatomic,copy) NSString *deviceCode; //设备序列号
@property (nonatomic,assign) int64_t applyID; //申请流程编号
@property (nonatomic, assign) int status; //流程状态
@property (nonatomic, assign) int64_t startTime; //流程发起时间
@property (nonatomic, assign) int64_t updateTime; //流程更新时间

@end

@interface LCUnbindDeviceApplyInfo : NSObject

@property (nonatomic,copy   )    NSString      *deviceCode;    //设备序列号
@property (nonatomic, assign)    int           status;         //流程状态
@property (nonatomic, assign)    int64_t       createTime;     //流程发起时间
@property (nonatomic, copy  )    NSString      *statusExplain; //状态说明
@property (nonatomic, assign)    BOOL          isExpired;     // 是否过期

@end

@interface LCUnbindDeviceApplicationInfo : NSObject

@property (nonatomic,copy) NSString *applicantName;  //申请人姓名
@property (nonatomic,copy) NSString *phoneNumber;    //申请人手机号
@property (nonatomic,copy) NSString *deviceCode;     //设备序列号
@property (nonatomic,copy) NSString *devicePicUrl;   //设备序列号
@property (nonatomic,copy) NSString *idFrontPicUrl;  //设备序列号
@property (nonatomic,copy) NSString *idBackPicUrl;   //设备序列号
@property (nonatomic,copy) NSString *signPicUrl;     //设备序列号

@end

@interface LCGetDevModelInfo : NSObject<NSCoding>

@property (nonatomic, assign) int64_t modelId; //设备型号ID
@property (nonatomic, copy) NSString *deviceModel; //设备内部型号
@property (nonatomic, copy) NSString *modelName; //设备外部型号
@property (nonatomic, copy) NSString *logoUrl; //该型号对应的设备logo图片URL

@end

@interface LCGetDevModelInfoList : NSObject<NSCoding>

@property (nonatomic,strong) NSArray *modelsArray; //
@property (nonatomic, assign) int64_t timeStamp;      //时间戳

@end



/**
 全景图Url信息
 */
@interface LCPanoUrlInfo : NSObject
@property (nonatomic, copy) NSString *url;

/**
 加密内容信息
 */
@property (nonatomic, strong) LCContentEncryptInfo *encryptInfo;

@end

/**
 巡航信息
 */
@interface LCDeviceCuriseInfo: NSObject
// 周期
@property (nonatomic, copy) NSString *period;
// 开始时间
@property (nonatomic, copy) NSString *beginTime;
// 结束时间
@property (nonatomic, copy) NSString *endTime;
@end

/**
 收藏点信息
 */
@interface LCDeviceCollectionInfo: NSObject
// 名称
@property (nonatomic, copy) NSString *name;
// 停留时间, 单位是秒
@property (nonatomic, assign) NSInteger stayTime;
// 收藏点图片字符串，通过Base64编码
@property (nonatomic, copy) NSString *imageString;
// 收藏点图片地址
@property (nonatomic, copy) NSString *imagePath;
// 收藏点网络图片地址
@property (nonatomic, copy) NSString *url;
// 解密秘钥
@property (nonatomic, copy) NSString *key;
// 设备序列号
@property (nonatomic, copy) NSString *deviceId;

@end

/**
 巡航设置
 */
@interface LCDeviceCuriseConfig: NSObject
// 名称
@property (nonatomic, copy) NSString *name;
// 模式
@property (nonatomic, copy) NSString *mode;
// 路径
@property (nonatomic, copy) NSString *path;
// 收藏点信息
@property (nonatomic, strong) NSArray<LCDeviceCollectionInfo *> *collectionInfos;


@end


@interface LCShareStrategy :NSObject

@property (nonatomic) int64_t strategyId;       //套餐ID
@property (nonatomic, copy) NSString *name;     //套餐名称
@property (nonatomic) double fee;        //套餐单价
@property (nonatomic) int64_t validTime;  //套餐有效期（单位日）
@property (nonatomic, copy) NSString *desc;     //套餐描述
@property (nonatomic, copy) NSString *picUrl;   //套餐图片url

@end

@interface LCDevShareStrategy :NSObject
@property (nonatomic) int64_t strategyListId;       //套餐ID
@property (nonatomic) int64_t beginTime;        //开始时间,unix时间戳
@property (nonatomic) int64_t endTime;          //结束时间，unix时间戳
@property (nonatomic, copy) NSString *name;     //套餐名称
@property (nonatomic, copy) NSString *desc;     //套餐描述
@property (nonatomic) int64_t shareNum;         //购买的授权分享人数
@property (nonatomic, copy) NSString *backgroudPicUrl;     //背景图片url
@property (nonatomic) int64_t defaultNum;       //默认的授权分享人数
@property (nonatomic, copy) NSString *status;   //套餐状态，-1：未使用；1：正在使用；0：过期

@end


@interface LCReportStatisticNode :NSObject
@property (nonatomic, copy) NSString *time;   //请求时间段
@property (nonatomic, strong) NSArray<NSNumber *> *numberArray; //各时间点客流总量
@end


@interface LCReportStatisticData :NSObject

@property (nonatomic) int64_t reportId;
@property (nonatomic, copy) NSString *reportName;   //我的客流报表
@property (nonatomic, copy) NSString *strategyType; //报表套餐类型
@property (nonatomic, copy) NSString *updateTime;   //数据更新时间,yyyyMMddTHHmmss

@property (nonatomic) int64_t todayNum;     //今日客流总量
@property (nonatomic) int64_t yesterdayNum; //昨日客流总量
@property (nonatomic) int64_t weekNum;      //本周客流总量
@property (nonatomic) int64_t lastWeekNum;  //本周客流总量
@property (nonatomic) int64_t monthNum;     //本月客流总量
@property (nonatomic) int64_t lastMonthNum; //上月客流总量
@property (nonatomic) int64_t yearNum;     //本年客流总量
@property (nonatomic) int64_t lastYearNum; //去年客流总量
@property (nonatomic, strong) NSArray<LCReportStatisticNode *> *dataList; //上月客流总量

@end

//客流统计套餐
@interface LCReportStrategy:NSObject
@property (nonatomic) int64_t strategyId;     //套餐id
@property (nonatomic, copy) NSString *name;   //套餐名称
@property (nonatomic) double price;           //套餐价格
@property (nonatomic) NSInteger type;         //套餐类型
@property (nonatomic, copy) NSString *picUrl;   //套餐图片地址
@property (nonatomic, copy) NSString *describe; //套餐描述
@property (nonatomic) NSInteger validTime; //有效时间
@end

@interface LCStrategyDetail:NSObject
@property (nonatomic, copy) NSString *strategyType; //报表套餐类型
@property (nonatomic, copy) NSString *startTime;    //报表增值套餐最早购买时间yyyyMMddTHHmmss,普通报表为空
@property (nonatomic, copy) NSString *endTime;      //报表增值套餐到期时间yyyyMMddTHHmmss,普通报表为空
@end


@interface LCOneDayStrategy:NSObject
@property (nonatomic, copy) NSString* type;         //套餐类型，storage:云存储默认套餐; wonderfull：精彩一天套餐
@property (nonatomic) int64_t strategyId;           //套餐id
@property (nonatomic, copy) NSString* status;       //-1-未领取 ，1-已经领取，0-没资格领取
@property (nonatomic, copy) NSString* beginTime;    //开始时间，yyyyMMddTHHmmssZ格式
@property (nonatomic, copy) NSString* endTime;      //yyyyMMddTHHmmssZ格式
@property (nonatomic, copy) NSString* name;      //yyyyMMddTHHmmssZ格式
@end

@interface LCDevCloudStrategy:NSObject
@property (nonatomic, copy) NSString* type;         //套餐类型，storage:云存储默认套餐; wonderfull：精彩一天套餐
@property (nonatomic, copy) NSString* status;       //-1-未领取 ，1-已经领取，0-没资格领取
@property (nonatomic, copy) NSString* beginTime;    //开始时间，yyyyMMddTHHmmssZ格式
@property (nonatomic, copy) NSString* endTime;      //yyyyMMddTHHmmssZ格式
@property (nonatomic, copy) NSString* name;      //yyyyMMddTHHmmssZ格式
@end

@interface LCSnapKeyInfo:NSObject
@property (nonatomic, copy) NSString *keyId;     //String 必须 临时秘钥唯一标示符
@property (nonatomic, copy) NSString *snapKey;     //String 必须 临时秘钥
@property (nonatomic, copy) NSString *name;     //String 必须 秘钥名称
@property (nonatomic, copy) NSString *status;     //String 必须 秘钥状态，notUsed:未使用；bUsed:已使用；failed:已失效
@property (nonatomic, copy) NSString *createUtcTime;     //String 必须 创建Utc时间，20170418T162832Z格式
@property (nonatomic, copy) NSString *createLocalTime;     //String 必须 创建的本地时间，20170418T162832格式
@property (nonatomic, copy) NSString *localTime;     //String 可选 临时秘钥失效或者使用本地时间，格式20170418T162832
@property (nonatomic, copy) NSString *utcTime;    //String 可选 临时秘钥失效或者使用utc时间，格式20170418T162832Z
@end

@interface LCKeyEffectPeriod:NSObject
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@end

@interface LCSecretKeyInfo:NSObject
@property (nonatomic, copy) NSString *type; //[String]，钥匙类型：password：密码；card：卡；fingerPrint：指纹；
@property (nonatomic, copy) NSString *keyId; //[String]，密码、卡、指纹的唯一标示符；
@property (nonatomic, copy) NSString *name;         //String 必须 钥匙名称
@property (nonatomic) BOOL bManager;        //Bool 必须 是否为管理员钥匙，true:是；false:否
@property (nonatomic) int effectTime;         //Int 必须 钥匙有效天数
@property (nonatomic) BOOL bHijackAlarm;         //Bool 必须 true
@property (nonatomic, copy) NSString *location;         //String 可选 地址，当bHijackAlarm为true时，表示用户设置地址
@property (nonatomic, copy) NSString *phone;         //String 可选 当bHijackAlarm为true时，表示用户设置的劫持报警手机号
@property (nonatomic, strong) NSArray<LCKeyEffectPeriod *> *effectPeriod;         //有效期
@end

@interface LCHoveringAlarmInfo:NSObject
@property (nonatomic, copy) NSString *hoveringAlarmStatus; //String 必须 徘徊报警使能开关，on-开启 off-关闭
@property (nonatomic, assign) NSInteger stayTime; //Int 必须 逗留时长，单位S
@end

@interface LCDevicePowerInfo:NSObject
@property (nonatomic, copy) NSString *type; //可选 供电类型，当type为空时，默认为battery类型
@property (nonatomic, assign) int electric; //Int 必须 电量百分比，取值范围0-100；-1:设备无该电池
@property (nonatomic, assign) int alkElec;  //Int 必须 碱性电池电量百分比，取值范围0-100；-1:设备无该电池
@property (nonatomic, assign) int litElec;  //Int 必须 锂电池电量百分比，取值范围0-100；-1:设备无该电池
@end

@interface LCDeviceFlushInfo:NSObject
@property (nonatomic, assign) NSInteger ringIndex;
@property (nonatomic, copy) NSArray *list;
@end

@interface LCDeviceFlushCellInfo:NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *name;
@end

@interface LCDeviceGearInfo:NSObject
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger gear;
@end

@interface NVMMode: NSObject
@property (nonatomic, copy  ) NSString *model;   // Intelligent/FullColor/Infrared,分别表示智能夜视/全彩夜视/红外夜视
@property (nonatomic, copy  ) NSArray<NSString *> *models; // 设备可支持的夜视模式，Intelligent/FullColor/Infrared中的一个或多个
@end

@interface NVMChannelMode: NSObject
@property (nonatomic, copy  ) NSString *chan;   // 通道,不存在默认为设备
@property (nonatomic, copy  ) NSString *sn;     // 暂不使用。设备序列号,不存在默认是设备，接入库协议有此参数，平台端目前不会处理此参数
@property (nonatomic, copy  ) NSString *mode;
@end

@interface LCDeviceMotionDetectInfo:NSObject
@property (nonatomic, assign) NSInteger stall;//档位
@property (nonatomic, assign) NSInteger row;//动态检测区域的行数
@property (nonatomic, assign) NSInteger column;//动态检测区域的列数
@property (nonatomic, assign) NSInteger sensitive;//灵敏度，取值
@property (nonatomic, assign) NSInteger threshold;//面积阀值，取值
@property (nonatomic, copy) NSString *region;//多个32位整形组成的字段

@end

@interface LCQuerySirenStateResultObject : NSObject

@property (nonatomic, assign) int time;
@property (nonatomic, copy) NSString *whiteLight;
@property (nonatomic, copy) NSString *searchLight;
@property (nonatomic, copy) NSString *clientLocalTime;

@end

@interface LCDeviceZoomFocusInfo : NSObject

@property (nonatomic, assign) int channelId;
@property (nonatomic, assign) double zoomFocus;
@end

/// 从服务器缓冲拉取的WiFi信息
@interface LCDeviceWifiStateFromServer : NSObject

@property (nonatomic, assign) BOOL linkEnable; // 是否连接
@property (nonatomic, copy) NSString *intensity; // wifi强度（0最弱  5最强）
@property (nonatomic, copy) NSString *sigStrength; // 热点强度 可选值（单位dbm）
@property (nonatomic, copy) NSString *ssid; //热点名称

@end

@interface LCDeviceWifiForRemoteDevice : NSObject

@property (nonatomic, assign) int channelId; // 通道ID
@property (nonatomic, assign) BOOL linkEnable; // 是否连接
@property (nonatomic, assign) int intensity; // wifi强度（0最弱  5最强）
@property (nonatomic, copy) NSString *sigStrength; // 热点强度 可选值（单位dbm）
@property (nonatomic, copy) NSString *ssid; //热点名称

@end

@interface LCDeviceBatteryElectric : NSObject

@property (nonatomic, copy) NSString *type; // 供电类型 battary : 电池类型，adapter : 适配器   batteryAdapter : 充电中
@property (nonatomic, copy) NSString *electric; // 电量百分比
@property (nonatomic, copy) NSString *alkElec; // 碱性电池电量百分比
@property (nonatomic, copy) NSString *litElec; // 锂电池电量百分比

@end

@interface LCDeviceRemoteDeviceElectric: NSObject

@property (nonatomic, assign) int channelId; // 通道号
@property (nonatomic, copy) NSString *type; // 供电类型 battary : 电池类型，adapter : 适配器   batteryAdapter : 充电中
@property (nonatomic, assign) int electric; // 电量百分比
@property (nonatomic, assign) int alkElec; // 碱性电池电量百分比
@property (nonatomic, assign) int litElec; // 锂电池电量百分比

@end


/// 动检+PIR
@interface LCMotionDetectParamInfo : NSObject

@property (nonatomic, assign) NSInteger stall;    //动检灵敏度  【1-6】  0表示设备不支持
@property (nonatomic, assign) NSInteger row;      //动检区域的行数
@property (nonatomic, assign) NSInteger column;   //动检区域的列数
@property (nonatomic, assign) NSInteger sensitive;//动检灵敏度  【1-100】
@property (nonatomic, assign) NSInteger threshold;//面积阀值    【1-100】
@property (nonatomic, copy) NSString *region;

@end

//AD2空气探测器
@interface LCAirDetection : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *type; //温度temperature / 湿度humidity / PM2.5 / VOC
@property (nonatomic, copy) NSString *value; //数据值
//质量类型 qualityV1 优 / qualityV2 良 / qualityV3 轻度污染 / qualityV4 中度污染 / qualityV5 重度污染 / qualityV6 严重污染
@property (nonatomic, copy) NSString *qualityType;
@property (nonatomic, copy) NSString *unit;//单位

@end
//空气探测器报表数据
@interface LCAirDetectReportData : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *utcTime; //20180423T101326Z
@property (nonatomic, copy) NSString *value; //数据值(平均值)

@property (nonatomic, copy) NSString *minValue;//最小值
@property (nonatomic, copy) NSString *maxValue;//最大值

@property (nonatomic, copy) NSString *qualityType;//质量类型(报警阈值获取时使用)
@property (nonatomic, copy) NSString *type;//报警阈值类型(报警阈值获取时使用)

@end
//空气探测器指标项配置信息
@interface LCAirDetectAllData : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *type;//数据类型
@property (nonatomic, copy) NSString *minRange;//取值最小范围
@property (nonatomic, copy) NSString *maxRange;//取值最大范围
@property (nonatomic, copy) NSString *percision;//精确度
@property (nonatomic, copy) NSString *unit;//单位, 如ppm
@property (nonatomic, copy) NSString *mode;//模式, 如7Day
@property (nonatomic, strong) NSMutableArray *space;//时间刻度

@end

//警笛时长
@interface LCSirenTimeInfo: NSObject

@property (nonatomic, copy) NSString *currentIndex;//选中索引
@property (nonatomic, copy) NSString *index;//时长索引
@property (nonatomic, copy) NSString *time;//警笛时长

@end

//MARK: 设备添加融合
/// 设备添加用户获取的设备信息
@interface LCUserDeviceBindInfo: NSObject
/// 非iot设备
/// LAN：有线
/// SIMCard：Sim卡
/// SoftAP：软AP
/// SoundWave：声波
/// SmartConfig：SmartConfig方式
/// QRCode：二维码
/// SoundWaveV2：声波V2版本，优化声波算法
///
/// iot设备
/// wifi
/// bluetooth       蓝牙
/// bluetoothBatch  蓝牙
/// 4G
/// lan             有线
/// vlog            热点直连
/// sim
/// accessory       配件
/// lanWeak         弱绑定 有线
/// EZ              声波快连
/// 
/// 如果productId不为空，设备为iot设备
/// iot设备共用属性
// 设备在平台是否存在："exist":存在,"notExist":不存在
@property (nonatomic, copy) NSString *deviceExist;
// 设备状态：online-在线,offline-在线,upgrading-升级中,sleep-休眠
@property (nonatomic, copy) NSString *status;
// 设备绑定情况：unbind, bindByMe, bindByOther
@property (nonatomic, copy) NSString *bindStatus;
// 设备所属账号
@property (nonatomic, copy) NSString *userAccount;
// 设备SN
@property (nonatomic, copy) NSString *deviceId;

@property (nonatomic, copy) NSString *wifiConfigMode; /**< 表示支持的配对模式：SmartConfig,SoundWave,SoundWaveV2,SoftAP,LAN,SIMCard,Bluetooth,   */
@property (nonatomic) BOOL support; /**< 是否支持该设备，true:支持,false:不支持  */
@property (nonatomic, copy) NSString *wifiTransferMode; /**< 可选 表示无线支持频段的序列，逗号隔开：2.4Ghz,5Ghz  */
@property (nonatomic, copy) NSString *deviceModel; /**< 可选 设备型号   */
@property (nonatomic, copy) NSString *ability; /**<  可选 设备能力项，逗号隔开，如AlarmMD,AudioTalk,AlarmPIR,WLAN,VVP2P; */
@property (nonatomic, copy) NSString *catalog; /**< 可选 设备大类【NVR/DVR/HCVR/IPC/SD/IHG/ARC】  */
//@property (nonatomic, copy) NSString *accessType; /**< 设备接入类型，PaaS-表示Paas程序接入、Lechange-表示乐橙非PaaS设备、Easy4IP表示Easy4IP程序设备、P2P表示P2P程序设   */
@property (nonatomic, copy) NSString *brand; /**< 设备品牌信息：国内：lechange-乐橙设备，general-通用设备, 海外：imou-乐橙设备，general-通用设备   */
@property (nonatomic, copy) NSString *family; /**< 设备系列：'A'、'C'、'K'、'SE'等;服务中没有则返回空''   */
@property (nonatomic, copy) NSString *modelName; /**< 可选 型号名称（设备外部型号，app展示使用，可选）  */
@property (nonatomic, copy) NSString *type; /**< 可选 分类：ap，device  */
@property (nonatomic, copy) NSString *channelNum; /**< 国内使用 视频通道的总数量（包含未接入的通道），网关的通道数可能为0 */
@property (nonatomic, copy) NSString *watchSetupVideoUrl;//添加设备引导页，查看视频
@property (nonatomic, copy) NSString *p2pPort;
@property (nonatomic, copy) NSString *tlsPrivatePort; /**< 可选 设备加密端口,海外使用  */
@property (nonatomic, copy) NSString *privateMediaPort ; /**< 可选 设备私有拉流协议监听端口  */
@property (nonatomic, copy) NSString *canBeBind ; /**< 可选 是否可绑定  */    //待处理问题： canBeBind 重复定义 一个定义bool值，一个定义为string 当前处理注释掉 string类型
@property (copy, nonatomic) NSString *nextStep; // 下个步骤，取值：bind-绑定；networkConfig-配网；bindByMe-被自己绑定； bindByOther-被他人绑定
/// 设备类别
@property (strong, nonatomic) NSString *deviceType;
/// 设备分类
@property (strong, nonatomic) NSString *deviceCatalog;
/// 设备型号
@property (strong, nonatomic) NSString *dt;
/// 设备市场型号
@property (strong, nonatomic) NSString *dtName;
/// 支持配网方式
@property (strong, nonatomic) NSString *wifiMode;
// SMB新增属性
@property (nonatomic, copy) NSString *deviceImageURI ; /**< 可选 设备图片地址  */

/// iot设备属性
// 产品ID
@property (nonatomic, copy) NSString *productId;
// 产品型号
@property (nonatomic, copy) NSString *productModel;
// 默认配网方式
@property (nonatomic, copy) NSString *defaultWifiConfigMode;

@property (nonatomic, copy) NSString *softAPModeWifiName;
@property (nonatomic, copy) NSString *softAPModeWifiVersion;
@property (nonatomic, copy) NSString *wifiConfigModeOptional;

/// iot设备
- (BOOL)isIotDevice;


@end


@interface LCBindDeviceInfo: NSObject
@property (nonatomic, copy) NSString *deviceId; /**< 必须 设备ID */
@property (nonatomic, copy) NSString *code; /**< 可选 设备验证码，在设备能力集支持时填写 */
@property (nonatomic, copy) NSString *deviceKey; /**< String 可选 从设备拿到的一串随机字符串（随机密码），用于后续平台对设备的认证,国内使用  */
@property (nonatomic, copy) NSString *longitude; /**< 可选 经度，东经0~180度，西经-180~0度,转成double最多保留6位 */
@property (nonatomic, copy) NSString *latitude; /**< String 可选 纬度，北纬0~90度, 南纬-90~0度，转成double最多保留6位 */
@property (nonatomic, copy) NSString *deviceUsername; /**< String 可选 设备用户名（Base64(AES256加密)）,海外必须，国内设备有Auth能力集的带 */
@property (nonatomic, copy) NSString *devicePassword; /**< String 可选 设备密码（Base64(AES256加密)）,海外必须，国内设备有Auth能力集的带*/
@property (nonatomic, copy) NSString *imeiCode;     /**< String 可选 NB*/
@end


@interface LCBindDeviceSuccess: NSObject
@property (nonatomic, copy) NSString *deviceName; /**< 可选，返回的设备名称 */
@property (nonatomic, copy) NSString *bindStatus; /**< 可选，绑定状态，bindByMe、bindByOther */
@property (nonatomic, copy) NSString *userAccount; /**< 可选，所属账户，bindByOther时返回*/
@property (nonatomic, copy) NSString *recordSaveDays; /**< 可选 录像保存天数（免费套餐信息,设备有可赠送免费套餐时返回）*/
@property (nonatomic, copy) NSString *streamType; /**< 可选 码流类型：main：主码流extra1：辅码流（免费套餐信息,设备有可赠送免费套餐时返回）*/
@property (nonatomic, copy) NSString *seviceTime; /**< 可选 服务时长(秒)（免费套餐信息,设备有可赠送免费套餐时返回）*/

@end

@interface LCDeviceTimeZone: NSObject
@property (nonatomic, copy) NSString *area; /**< String 必须 APP设置的时区对应索引值，服务保存，给app拉取用 */
@property (nonatomic, copy) NSString *timeZone; /**< String 必须 设备所在时区 */
@property (nonatomic, copy) NSString *beginSunTime; /**< String 必须 格式为MM-dd HH:mm:ss夏令时开始时间 */
@property (nonatomic, copy) NSString *endSunTime; /**< String 必须 格式为MM-dd HH:mm:ss夏令时结束时间 */
@property (nonatomic, copy) NSString *offset;
@property (nonatomic, assign, readonly) NSInteger areaIndex;
@property (nonatomic, assign, readonly) NSInteger timeZoneIndex;

+ (NSString *)dstTimeFormat;

@end

@interface LCDeviceTimeZoneQueryInfo: NSObject

/** [O]夏令时结束时间, 可选。表示“某月-该月的第几个星期-该星期的第几天，时分秒 */
@property (nonatomic, copy) NSString *endWeekSunTime;

/** [O]格式为MM-dd HH:mm:ss夏令时开始时间 */
@property (nonatomic, copy) NSString *beginSunTime;

/** [int]设备所在时区 */
@property (nonatomic, assign) int timeZone;

/** [O]夏令时开始时间, 可选。表示“某月-该月的第几个星期-该星期的第几天，时分秒 */
@property (nonatomic, copy) NSString *beginWeekSunTime;

/** [O]按周、或按日设置的夏令时模式区分，可选，该字段不存在，则默认为day */
@property (nonatomic, copy) NSString *mode;

/** [O]格式为MM-dd HH:mm:ss夏令时结束时间 */
@property (nonatomic, copy) NSString *endSunTime;

/** [O]APP设置的时区对应索引值，服务保存，给app拉取用,未设置过不返回该字段 */
@property (nonatomic, copy) NSString *areaIndex;

@property (nonatomic, copy) NSString *offset;

-(BOOL)isDayModel;
-(BOOL)isWeekModel;

@end

@interface LCSearchLightModel: NSObject

@property (nonatomic, assign) NSInteger index; /** 探照灯模式对应的索引值，有效值大于等于0，从0顺序递增 */
@property (nonatomic, copy) NSString *mode; /** 探照灯模式: manual：通用模式,motion activation：PIR联动模式,dusk to dawn：光敏联动模式 */

@end

@interface LCSearchLightWorkMode: NSObject

@property (nonatomic, assign) NSInteger index; /** 探照灯模式对应的索引值，有效值大于等于0 */
@property (nonatomic, strong) NSArray<LCSearchLightModel *> *models;

@end


@interface LCLightTimeModel: NSObject

@property (nonatomic, assign) NSInteger index; /** 探照灯时长对应的索引值，有效值大于等于0，从0顺序递增 */
@property (nonatomic, strong) NSString *time; /** 探照灯时长，单位为S */

@end

@interface LCLightTimeWorkMode: NSObject

@property (nonatomic, assign) NSInteger index; /** 探照灯时长对应的索引值，有效值大于等于0 */
@property (nonatomic, strong) NSArray<LCLightTimeModel *> *models;

@end

@interface LCSirenContentModel: NSObject

@property (nonatomic, copy) NSString *clientLocalTime;  //必须 客户端本地时间，如20180301T111730
@property (nonatomic, strong) NSArray *channels;          //Int[] 必须 设备通道号，从0开始

@end

@interface LCSirenChannelModel: NSObject

@property (nonatomic, copy) NSString *channelId;    // String 必须 通道号
@property (nonatomic, assign) int time;             // Int 必须 警笛持续时间
@property (nonatomic, copy) NSString *whiteLight;   // String 可选 白光灯开关状态，on-开启，off-关闭
@property (nonatomic, copy) NSString *searchLight;  // String 可选 探照灯开关状态，on-开启，off-关闭

@end

@interface LCSirenResponseModel: NSObject

@property (nonatomic, copy) NSString *clientLocalTime;  //必须 客户端本地时间，如20180301T111730
@property (nonatomic, strong) NSArray <LCSirenChannelModel *>*channels;     //

@end

@interface LCBellContentModel: NSObject

@property (nonatomic, assign) BOOL isMultiChannel;  // 用来标记是否是多通道（如果是多通道就需要传入sn、chan）
@property (nonatomic, assign) int index;            // Int 必须 歌曲索引

@property (nonatomic, copy) NSString *sn;           // String 可选 设备序列号
@property (nonatomic, copy) NSString *chan;         // String 可选 通道,不存在默认为设备
@property (nonatomic, copy) NSString *relateType;   // String 必须 生效类型,device:关联设备报警,accessory:关联配件报警,reply:关联自定义回复,local: 设备本地铃声，按下门铃后的响声
@property (nonatomic, copy) NSString *name;         // String 必须 铃声名称,最大32字节,不要带上文件后缀名
@property (nonatomic, copy) NSString *url;          // String 必须 铃声音频文件对应的已授权URL地址,最大512字节
@property (nonatomic, copy) NSString *type;         // String 必须 铃声类型:wav,pcm,aac

@end

@interface LCIntelligentlockNotesInfo: NSObject

@property (nonatomic, copy) NSString *name;          /** 用户名称  */
@property (nonatomic, copy) NSString *keyType;       /** 密码类型  */
@property (nonatomic, copy) NSString *localKeyType;       /** 密码类型  */
@property (nonatomic, copy) NSString *operateType;   /** 操作类型  */
@property (nonatomic, copy) NSString *localOperateType;    /** 操作类型   */
@property (nonatomic, copy) NSString *time;          /** 开锁UTC时间，时间格式为yyyyMMddTHHmmssZ  */
@property (nonatomic, copy) NSString *localTime;    /** 开锁设备本地时间，时间格式为yyyyMMddTHHmmss  */

@end

