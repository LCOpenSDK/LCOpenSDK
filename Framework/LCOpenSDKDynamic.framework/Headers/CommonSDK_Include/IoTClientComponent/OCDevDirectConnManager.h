#import <Foundation/Foundation.h>


@protocol IOCDevDirectConnListener <NSObject>
//DevUid = sn+pid
-(void) onError:(NSString*)uuid DevUid : (int) err;
	
-(int) reportEvent:(NSString*)uuid DevUid : (NSString*)eventref EventData: (NSString*)data;
	
-(int) onNotifyProperty:(NSString*)uuid DevUid : (NSString*) JsonProperty;

@end



@interface OCDevDirectConnManager : NSObject

/// @brief 创建直连设备
/// @param devInfo 设备信息,json格式字符串,参数格式如下:
/// {
///     "pid": "xxxxxx",         // 产品型号: 在物联云平台上注册的型号
///     "sn": "xxxxxx",          // 设备序列号，大写字母加数字组合，唯一，不可重复
///     "devIP": "xxxxxx",       // 设备ip
///     "devPort": 554,          // 设备端口
///     "tls":false              // 是否使用tls，无该字符时，则sdk内部自动尝试
/// }
/// @return 设备句柄
-(long) createDirectDev:(NSString*)jsonStr;

/// @brief 销毁设备
/// @return 0 成功; <0 失败
-(int) destroyDirectDev:(long)devHandle;

/// @brief 设置监听器
/// @param devHandle 设备句柄
/// @param listener 监听器
-(void) setlistener:Listener:(id<IOCDevDirectConnListener>) listener;
     
/// @brief 登录设备
/// @param devHandle 设备句柄
/// @param username 设备用户名
/// @param password 设备密码
/// @param timeout_ms 超时时间
/// @return 0 成功;其他失败，错误码见'DevDirectConnErrorCode'
 
-(int) loginDevice:(long)devHandle userName:(NSString *)username passWord:(NSString *) password timeOut:(int)timeout_ms;

/// @brief 登出设备，断开连接
/// @param devHandle 设备句柄
-(void) logoutDevice:(long) devHandle;

/// @brief 配置云平台注册地址
/// @param devHandle 设备句柄
/// @param info，json格式字符串
/// {
///     "addr": "xxxxxx",         //云平台注册地址, 如:"iotaccess.easy4ipcloud.com"
///     "port":  xxxxxx,          //云平台注册端口, 如:10001
/// }
/// @param timeout_ms 超时时间
/// @return 0成功; 其他失败，错误码见'DevDirectConnErrorCode'
-(int) confRegServer:(long)devHandle info:(NSString *)info timeOut:(int)timeout_ms;

/// @brief 获取设备管理账户初始化状态
/// @param devHandle 设备句柄
/// @param timeout_ms 超时时间
/// @return 0:未初始化，1:已经初始化,其他失败，错误码见'DevDirectConnErrorCode'
-(int) getAccountState:(long) devHandle timeOut:(int)timeout_ms;


/// @brief 设置设备向导配置状态,当由App进行设备向导设置时, 设置完成后, 由App设置完成的状态
/// 如：路由器需在联网前，先执行上网参数配置
/// @param devHandle 设备句柄
/// @param state 0-未初始化配置 1-已初始化配置
/// @param timeout_ms 超时时间
/// @return 0: 成功(或不需要进行向导配置时, 直接返回0);其他失败，错误码见'DevDirectConnErrorCode'
-(int) setGuideConfigState:(long) devHandle state:(int)state timeOut:(int)timeout_ms;

/// @brief 获取设备向导配置状态，如：路由器需在联网前，先执行上网参数配置
/// @param devHandle 设备句柄
/// @param timeout_ms 超时时间
/// @return 0: 未进行向导配置(即需要进行向导配置);1:
/// 已进行向导配置(或不需要进行向导配置);其他失败，错误码见'DevDirectConnErrorCode'
-(int) getGuideConfigState:(long) devHandle timeOut:(int)timeout_ms;

/// @brief 配置设备WiFi信息
/// @param devHandle 设备句柄
/// @param info json格式字符串，参数如下:
/// {
///     "SSID": "xxxxxx",         //最长128字节, 主要用于区分重复的SSID
///     "BSSID": "xxxxxx",        //最长128字节, 主要用于区分重复的SSID
///     "encryption":xxx,         //加密方式，int类型
///     "password": "xxxxxx",     //连接WIFI的密码
///     "ReqeustID":“xxxxxx”      //配网添加时唯一ID，由APP生成，CUT8(BASE64(SHA256(PID+SN+UTC时间)))
/// }
/// @param timeout_ms 超时时间
/// @return 0 成功;其他失败，错误码见'DevDirectConnErrorCode'
-(int) setWiFi:(long) devHandle info:(NSString *)info timeOut:(int)timeout_ms;

/// @brief 获取设备基本信息
/// @param devHandle 设备句柄
/// @return 设备信息json格式字符串，格式如下:
/// {
///     "pid": "xxxxxx",         //产品型号: 在物联云平台上注册的型号
///     "sn": "xxxxxx",          //设备序列号，大写字母加数字组合，唯一，不可重复
///     "sc": "xxxxxx",          //信任标识/SC码
/// }
-(NSString *) getDeviceInfo:(long) devHandle timeOut:(int)timeout_ms;

/// @brief 初始化设备管理账户
/// @param devHandle 设备句柄
/// @param conf json格式字符串，格式如下:
/// {
///     "pid": "xxxxxx",         // 产品型号: 在物联云平台上注册的型号
///     "sn": "xxxxxx",          // 设备序列号，大写字母加数字组合，唯一，不可重复
///     "username": "xxxxxx",    // 用户名
///     "password": "xxxxxx",         // 密码
/// }
/// @param timeout_ms 超时时间
/// @return 0 成功;其他失败，错误码见'DevDirectConnErrorCode'
-(int) initAccountConf:(long) devHandle conf:(NSString *)conf timeOut:(int)timeout_ms;

/// @brief 设置物模型属性点
/// @param devHandle 设备句柄
/// @param reqdata json字符串 {"properties": {"$ref" : $value, ...}}
/// 注：$ref为物模型中properties属性对应ref值；$value为对应properties属性的值
/// 示例：{"properties": {"1001" : 0, "1002" : 60, "1003" : 220}}
/// 解析：json对应解析，获取对应属性点的值
/// @param timeout_ms 超时时间
/// @return 0成功;其他失败，错误码见'DevDirectConnErrorCode'
-(int) setProperty:(long) devHandle reqdata:(NSString *)reqdata timeOut:(int)timeout_ms;

/// @brief 获取物模型属性点
/// @param devHandle 设备句柄
/// @param reqdata json字符串 {"properties": ["$ref", ...]}
/// 注：$ref为物模型中properties属性对应ref值；
/// 示例：{"properties": ["1001", "1002", "1003"]}
/// 解析：json对应解析，获取需要查询的属性点
/// @param timeout_ms 超时时间
/// @return [out] rspdata json字符串 {"properties": {"$ref" : $value, ...}}
/// 注：$ref为物模型中properties属性对应ref值；$value为对应properties属性的值
/// 示例：{"properties": {"1001" : 0, "1002" : 60, "1003" : 220}}
/// 解析：json对应生成，填充实际查询属性点的值返回
-(NSString*) getProperty:(long) devHandle reqdata:(NSString *)reqdata  timeOut:(int)timeout_ms;

/// @brief 调用物模型服务
/// @param devHandle 设备句柄
/// @param reqdata json字符串 {"service": "$ref", "inputData" : {"$ref" :
/// $value, ...}}
/// 注：$ref为物模型中service属性对应ref值；$value为对应service属性的值
/// 示例：{"service": "2100", "inputData" : {"2101" : 0, "1002" : 60}}
/// 解析：json对应解析，获取服务需要的入参参数，并对应执行服务
/// @param timeout_ms 超时时间
/// @return [out] rspdata json字符串 {"outputData" : {"$ref" : $value, ...}}
/// 注：$ref为物模型中service属性对应ref值；$value为对应service属性的值
/// 示例：{"outputData" : {"2102" : 1, "2103": test}}
/// 解析：json对应生成，返回服务执行完后的出参

-(NSString*) requestService:(long) devHandle reqdata:(NSString*)reqdata timeOut:(int)timeout_ms;

@end
