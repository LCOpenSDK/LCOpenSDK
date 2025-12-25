#import <Foundation/Foundation.h>


@interface OCDevBindAuth : NSObject

 /**
  * 中绑定鉴权
  * @param pid [in] 设备产品型号
  * @param did [in] 设备序列号
  * @return 传参pid+did("piddid")经过sha256+base64,转大写后截取前32位长度字符串
  */
+(NSString*) MakeMidBindingAuthCode:(NSString*)pid Did:(NSString*)did;

@end

