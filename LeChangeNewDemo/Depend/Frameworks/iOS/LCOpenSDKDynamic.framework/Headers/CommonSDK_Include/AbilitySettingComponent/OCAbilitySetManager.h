#import <Foundation/Foundation.h>

@interface OCAbilitySetManager : NSObject

/**
 * 功能配置开关接口
 * @param param json字符串类型的开关配置
 * {"link_mts2p2p":[O][INT:1-on 0-off](mts链路切换成p2p)}
 */
+(BOOL)config:(NSString*)param;

@end