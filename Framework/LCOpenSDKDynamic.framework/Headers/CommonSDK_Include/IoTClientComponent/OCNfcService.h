#import <Foundation/Foundation.h>

@protocol IOCNfcServiceListener <NSObject>

/// @brief  设备分组回调接口
/// @param  seq 协议seq
/// @param  GroupID 分组ID
/// @param  Mac  响应设备分组的设备mac地址
/// @param  statusCode  设备响应状态，透传错误码，参考分组协议

- (void)onSetGroupResult:(NSString *)seq GroupId:(NSString *)groupId Mac:(NSString *)mac statusCode:(NSInteger)statusCode;

/// 设备属性设置回调通知
/// @param  seq 协议seq
/// @param  Mac  响应设备分组的设备mac地址
/// @param  statusCode  设备响应状态，透传错误码，参考分组协议
- (void)onSetPropertyResult:(NSString *)seq Mac:(NSString *)mac statusCode:(NSInteger)statusCode;

/// 设备属性获取回调通知
/// @param  seq 协议seq
/// @param  Mac  响应设备分组的设备mac地址
/// @param  rsp 设备属性"params":{"properties":["1001","1008"]}
/// @param  rspdatalen rspdata的长度
/// @param  statusCode  设备响应状态，透传错误码，参考物模型协议
- (void)onGetPropertyResult:(NSString *)seq Mac:(NSString *)mac rsp:(NSString *)rsp rspdatalen:(NSInteger)rspdatalen statusCode:(NSInteger)statusCode;

/// 设备服务调用回调通知
/// @param  seq 协议seq
/// @param  Mac  响应设备分组的设备mac地址
/// @param  rsp  服务调用响应 "params":{"outputData":{"2102":1}}
/// @param  rspdatalen rspdata的长度
/// @param  statusCode  设备响应状态，透传错误码，参考物模型协议
- (void)onRequestServiceResult:(NSString *)seq Mac:(NSString *)mac rsp:(NSString *)rsp rspdatalen:(NSInteger)rspdatalen statusCode:(NSInteger)statusCode;

/// @brief 属性上报
/// @param  seq 协议seq
/// @param mac 设备mac地址
/// @param rspdata json字符串 {"properties": {"$ref" : $value, ...}}
/// 注：$ref为物模型中properties属性对应ref值；$value为对应properties属性的值
/// 示例：{"properties": {"1001" : 0, "1002" : 60, "1003" : 220}}
/// 解析：json对应生成，传入填充实际上报属性点的值
/// @param rspdatalen rspdata的长度
/// @note 上报前提：设备已成功连接云平台，否则上报失败
- (void)onNotifyProperty:(NSString *)seq Mac:(NSString *)mac rsp:(NSString *)rsp rspdatalen:(NSInteger)rspdatalen;
@end

@interface OCIotNfcService : NSObject

/// @brief NFC服务初始化, 前置接口
/// @param loaclIP [in] 本机IP地址
/// @param appID 设备终端id
/// @param trustCodeInfo 互信码信息，平台查询获取 格式如下
/// {"trustList":[{"code":"kfi05ii2zman40p5m1d8254425xxkd00","invalidTime":"1715083015"},{"code":"kfi05ii2zman40p5m1d8254425xxkd02","invalidTime":"1715083025"}]}
- (BOOL)Initialize:(NSString *)loaclIP appid:(NSString *)appID trustCode:(NSString *)trustcodeInfo;

/// @brief 设置NFC服务异步监听回调
/// @param listener 回调对象
- (BOOL)Setlistener:(id<IOCNfcServiceListener>)listener;

/// @brief 设置群控分组
/// @param  seq 协议seq(全局从1递增)
/// @param groupInfo
/// groupInfo格式
/// {
/// "group":"123456" // 群控分组号
/// "list":["12:34:A4:G5", "65:32:78:DQ"]  // mac分组数组
///  }
/// 返回值 成功返回0 失败见错误码NFCServiceErrorCode
- (int)SetGroup:(NSString *)seq XCount:(NSString *)xCount groupInfo:(NSString *)groupinfo;

/// @brief 物模型属性设置 groupID和devIP 同时设置时走群控
/// @param  seq 协议seq(全局从1递增)
/// @param xCount 防重码
/// @param groupID 设备组id，如果是群控设备，请填对应的设备组id，单控则填空即可
/// @param devIP  单控设备IP
/// @param properties
/// {
///	 "params":"物模型json体，与mqtt保持一致",
///	  "mac":"mac地址（单播必填），格式 xx:xx:xx:xx:xx:xx"
/// }
/// 返回值 成功返回0 失败见错误码NFCServiceErrorCode
- (int)SetProperty:(NSString *)seq XCount:(NSString *)xCount GroupID:(NSString *)groupID DevIP:(NSString *)devIP Properties:(NSString *)properties;

/// @brief 销毁群控分组
/// @param  seq 协议seq(全局从1递增)
/// @param groupInfo
/// groupInfo格式
/// {
/// "group":"123456" // 群控分组号
/// "list":["12:34:A4:G5", "65:32:78:DQ"]  // mac分组数组
///  }
/// 返回值 成功返回0 失败见错误码NFCServiceErrorCode
- (int)ResetGroup:(NSString *)seq XCount:(NSString *)xCount groupInfo:(NSString *)groupinfo;

/// @brief 获取设备属性 groupID和devIP 同时设置时走群控
/// @param  seq 协议seq(全局从1递增)
/// @param xCount 防重码
/// @param groupID 设备组id，如果是群控设备，请填对应的设备组id，单控则填空字符串即可
/// @param devIP  单控设备IP
/// @param reqdata 格式如下
/// {"mac":"50-65-F3-46-07-A2","params":{"properties":["1001","1008"]}}
/// 返回值 成功返回0 失败见错误码NFCServiceErrorCode
- (int)GetProperty:(NSString *)seq XCount:(NSString *)xCount GroupID:(NSString *)groupID DevIP:(NSString *)devIP  reqData:(NSString *)reqdata;

/// @brief 调用设备服务 groupID和devIP 同时设置时走群控
/// @param  seq 协议seq(全局从1递增)
/// @param xCount 防重码
/// @param groupID 设备组id，如果是群控设备，请填对应的设备组id，单控则填空字符串即可
/// @param devIP  单控设备IP
/// @param reqdata 格式如下：
///  {"mac":"50-65-F3-46-07-A2","params":{"service":"2100","inputData":{"2101":0}}}
/// 返回值 成功返回0 失败见错误码NFCServiceErrorCode
- (int)RequestService:(NSString *)seq XCount:(NSString *)xCount GroupID:(NSString *)groupID  DevIP:(NSString *)devIP  reqData:(NSString *)reqdata;
@end
