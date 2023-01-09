//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

//用于注册, 忘记密码, 帐号解绑换绑等, 流程中数据传递用, 不缓存
@interface LCUserAccountOperationInfo : NSObject
//注册, 忘记密码
@property (nonatomic, copy) NSString    *accountType;//帐号类型, phone、email
@property (nonatomic, copy) NSString    *accountName;
@property (nonatomic, copy) NSString    *validCode;
@property (nonatomic, copy) NSString    *pwdStr;
@property (nonatomic, copy) NSString    *country;//使用iso-3166-1二字母，eg. 中国对应'CN'）
@property (nonatomic, copy) NSString    *userName;//用户名(可选)
//换绑
@property (nonatomic, copy) NSString    *accountTypeToChange;//帐号类型, phone、email
@property (nonatomic, copy) NSString    *accountNameToChange;
@property (nonatomic, copy) NSString    *accessToken; //换绑流程, 原帐号校验成功返回
@end

@interface LCThirdAccountInfo : NSObject

/// 类型，微信, 取值为：weixin、facebook
@property (nonatomic, copy) NSString *type;

/// 第三方昵称
@property (nonatomic, copy) NSString *nickname ;

@end

@interface LCUserInfo : NSObject

@property (nonatomic, copy) NSString *ak;  /**< ak */
@property (nonatomic, copy) NSString *sk;  /**< sk */
@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, assign) int64_t userId; /**< 用户id */
@property (nonatomic, copy) NSString *phoneNumber; /**< 用户机号 */

/// 入口地址，第三方签名的地址，web可用
@property (nonatomic, copy) NSString *entryUrl;

/// 自签名入口地址，SaaS接口请求使用
@property (nonatomic, copy) NSString *entryUrlV2;

@property (nonatomic, copy) NSString *userName; /**< 平台用户名 */
@property (nonatomic, copy) NSString *name; /**< 用户真实姓名 */
@property (nonatomic, copy) NSString *country; /**< 用户国家信息，IOS编码 */
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *avatarMD5;

/// 第三方登录信息
@property (nonatomic, strong) NSArray<LCThirdAccountInfo *> *thirdAccounts;

@property (nonatomic, copy)     NSString            *username __attribute__((deprecated("Deprecated")));
@property (nonatomic, assign)   int                 pushStatus;
@property (nonatomic, copy)     NSString            *pushSound;
@property (nonatomic, assign)   BOOL                isExist __attribute__((deprecated("Deprecated")));
@property (nonatomic, assign)   BOOL                isBind __attribute__((deprecated("Deprecated")));
@property (nonatomic, assign)   int                 userType __attribute__((deprecated("Use thirdAccounts.type instead.")));
@property (nonatomic, copy)     NSString            *wxNickname __attribute__((deprecated("Use thirdAccounts.nickname instead.")));

@end

@interface LCUserPushInfo : NSObject
@property (nonatomic, copy) NSString *pushType __attribute__((deprecated("Deprecated"))); /**< 推送类型 */
@property (nonatomic, copy) NSString *pushLanguage; /**< 语言类型：按ISO 639-1 标准(2字节), 'zh_CN'；'en_US' etc. */
@property (nonatomic, copy) NSString *pushTimeFormat; /**< 日期格式：“yyyy-MM-dd HH:mm:SS” */
@property (nonatomic, copy) NSString *pushSound; //提示音
@property (nonatomic, assign) int pushStatus; //推送开关
@property (nonatomic, assign) int  timezoneOffset;/*Int 必须 手机所在时区与零时区差值，单位为秒，可正负*/
@property (nonatomic, strong) NSArray  *receiveTime;/*String[] 必须 时间设定，如08:00-11:30，是手机本地时间，开始范围（00:00到23:59），结束范围（00:00到23:59）*/
@end

@interface LCUserAccessInfo : NSObject
@property (nonatomic, copy) NSString *userName; //用户名
@property (nonatomic, copy) NSString *token; //账号的AccessToken
@property (nonatomic, copy) NSString *sessionId;

@end

@interface LCHistoryLoginInfoItem: NSObject
@property (nonatomic, copy)     NSString            *clientName __attribute__((deprecated("Use terminalModel instead. ")));/** 客户端名称，如huawei */
@property (nonatomic, copy)     NSString            *refLocation __attribute__((deprecated("Deprecated")));/** 登陆时参考地址，如“浙江”，不一定准确 */
@property (nonatomic, copy)     NSString            *time ;/** 2015-05-11 13:44:53 */
@property (nonatomic, copy)     NSString            *terminalModel; /**< 终端型号 */
@end

@interface LCShareRecordInfo : NSObject
@property (nonatomic, copy)      NSString            *username;//上传录像的平台账号用户名
@property (nonatomic, copy)      NSString            *coverUrl;// 录像封面图URL
@property (nonatomic, assign)    int64_t             userRecordId;//用户录像索引ID
@property (nonatomic, copy)      NSString            *pageUrl; //录像页面URL
@property (nonatomic, assign)    int64_t              time;//上传时间，UNIX时间戳
@property (nonatomic, copy)      NSString             *title;//标题

@end

@interface QRCodeInfo : NSObject
@property(nonatomic, copy  ) NSString *qrToken;   // 用户二维码token
@property(nonatomic, assign) int64_t  time;       // 剩余过期时间

@end

@interface LCUserRecordPublicInfo : NSObject
@property(nonatomic, copy) NSString *title;   //分享的标题
@property(nonatomic, copy) NSString *pageUrl; //公开视频的页面URL
@property(nonatomic, copy) NSString *token;   //公开视频的Token
@end

@interface LCBindPhoneUserInfo : NSObject

@property (nonatomic, assign)     int64_t              bindUserId;
@property (nonatomic, copy)     NSString            *accountLoginIdString;
@property (nonatomic, copy)     NSString            *bindUserPhoneString;
@property (nonatomic, copy)     NSString            *nickNameString;
@property (nonatomic, copy)     NSString            *userIconString;
@property (nonatomic, assign, getter=isFirstLoginFlag) BOOL   firstLoginFlag;/**<第一次登录*/

@end

@interface LCCheckThridBindOrNotInfo : NSObject

@property (nonatomic, assign)   BOOL                isExists;//是否存在
@property (nonatomic, assign)   BOOL                isBind;//是否与第三方账号绑定

@end

@interface LCBindThirdpartyWeixinAccountInfo : NSObject

@property (nonatomic,assign) int64_t bindUserId;//绑定乐橙账号的id
@property (nonatomic,copy) NSString *bindUserPhoneString;//绑定乐橙账号的手机号，为空表示未绑定手机号
@property (nonatomic,copy) NSString *accountLoginIdString;//第三方登录ID，用于第三方登录乐橙
@property (nonatomic,copy) NSString *nickNameString;//昵称
@property (nonatomic,copy) NSString *bindUserEmailString;//绑定乐橙账号的邮箱
@property (nonatomic,copy) NSString *userIconString;//用户头像
@property (nonatomic,copy) NSString *accessTokenString;//第三方账号访问凭证
@property (nonatomic,copy) NSString *wxNickNameString;//微信昵称

@end

@interface LCCheckValidCodeInfo : NSObject

@property (nonatomic,assign) BOOL valid;/**< 是否验证成功*/
@property (nonatomic,copy) NSString *accessTokenString; //验证码token

@end

@interface LCThirdAccountAuthLoginInfo : NSObject

@property (nonatomic,copy) NSString *nickNameString;//昵称
@property (nonatomic,copy) NSString *bindUserPhoneString;//绑定乐橙账号的手机号，为空表示未绑定手机号
@property (nonatomic,assign) BOOL   firstLoginFlag;/**<第一次登录*/
@property (nonatomic,copy) NSString *userIconString;//用户头像
@property (nonatomic,copy) NSString *accountLoginIdString;//第三方登录ID，用于第三方登录乐橙
@property (nonatomic,copy) NSString *bindUserEmailString;//绑定乐橙账号的邮箱
@property (nonatomic,assign) int64_t bindUserId;//绑定乐橙账号的id
@property (nonatomic,copy) NSString *accessTokenString;//第三方账号访问凭证
@property (nonatomic,copy) NSString *wxNickNameString;//微信昵称

@end

@interface LCCaptchaInfo : NSObject

@property (nonatomic,copy) NSString *imgCode;    //图片base64
@property (nonatomic,copy) NSString *codeID;     //图片验证码ID
@property (nonatomic,assign) int timeToExpired;  //有效时间

@end

@interface LCFamilyFaceBook: NSObject
@property (nonatomic, assign) int limitNum;      //脸谱上限
@property (nonatomic, strong) NSArray *faces;    //脸列表数据
@end

@interface LCFamilyFaceInfo : NSObject
@property (nonatomic, copy) NSString *faceID;       //脸的ID
@property (nonatomic, copy) NSString *faceName;     //脸的名字
@property (nonatomic, copy) NSString *facePicUrl;   //脸照片的url
@property (nonatomic, copy) NSData *facePicImgData;  //脸照片的data
@property (nonatomic, assign) BOOL isAddFace;       //添加脸用
@end

@interface LCFamilyFaceToAdd : NSObject
@property (nonatomic, copy) NSString *picBase64Str;    //脸照片的url
@property (nonatomic, copy) NSString *faceName;        //脸的名字
@end

@interface LCCheckCancellationObject : NSObject
@property (nonatomic, assign) BOOL bHaveBindDev;    //ture 有  false无
@property (nonatomic, assign) BOOL bOpenUser;       //true 开通 false 未开通
@property (nonatomic, assign) BOOL bHaveShareDev;    //ture 有  false无
@end

#pragma mark - SaaS Protocol (Push)

@interface LCSubscribeTimeItem : NSObject
@property (nonatomic, copy) NSString *beginTime; /**< 开始时间，格式 HH:mm，如08:30 */
@property (nonatomic, copy) NSString *endTime; /**< 结束时间，格式 HH:mm，如12:30 */
@end


@interface LCSubscribeTimeInfo : NSObject
@property (nonatomic, assign) NSInteger status;  /**< 消息订阅状态，1订阅，0不订阅 */
@property (nonatomic, strong) NSMutableArray <LCSubscribeTimeItem *> *arrayTime;
@end

@interface LCUserEventLogReport : NSObject<NSCoding>

@property (nonatomic, copy) NSString *_id; //功能唯一id，同一个功能成功或者失败使用不同的唯一编号
@property (nonatomic, copy) NSString *object; //页面、按钮对象唯一ID，直至根路径
@property (nonatomic, copy) NSString *name; //功能名称
@property (nonatomic, assign) NSTimeInterval startTimestamp; //起始UNIX时间戳（精确到毫秒）
@property (nonatomic, assign) NSTimeInterval stopTimestamp; //结束UNIX时间戳（精确到毫秒），普通的点击事件时stopTimestamp与startTimestamp填写一样
@property (nonatomic, copy) NSString *sslcost; //[O]ssl握手时间,单位为ms
@property (nonatomic, copy) NSString *apicost; //[O]接口整体耗时,单位为ms
@property (nonatomic, copy) NSString *content; //deviceId=xxx&channelId=xxxx

@end


@interface LCUserSwitch : NSObject
@property (nonatomic, copy  )   NSString *userSwitch;
@property (nonatomic, copy  )   NSString *enable;
@property (nonatomic, assign)   BOOL     isShowSwitch;
@end

@interface LCShopCouponInfo : NSObject
@property (nonatomic, copy) NSString *url;              // 必须 优惠券列表绝对地址： https://cn.imoulife.com/xxx/xx
@property (nonatomic, assign) long long updateTime;     // 必须 优惠券更新时间，单位秒，时间戳格式,如1575343886
@end
