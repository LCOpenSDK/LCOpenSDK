#import <Foundation/Foundation.h>

@interface OCConfigManager : NSObject

typedef NS_ENUM(NSInteger, CONFIG_TYPE)
{
    OC_ConfigClientUA = 0,      // 配置：终端信息
};

/**
 * 设置配置信息
 * @param configType 配置类型
 * @param param 配置参数
 * @return 是否成功
 */
+(BOOL)setConfig:(CONFIG_TYPE)type ConfigParam:(NSString*)param;

@end
