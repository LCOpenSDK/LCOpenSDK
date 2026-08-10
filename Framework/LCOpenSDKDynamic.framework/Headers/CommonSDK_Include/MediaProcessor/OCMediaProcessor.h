/***************************************************
 ** 版权保留(C), 2001-2017, 浙江大华技术股份有限公司.
 ** 版权所有.
 **
 ** $Id$
 **
 ** 功能描述   : 转码接口封装
 **
 ** 修改历史   : 2017年5月17日 28966 Modification
 ****************************************************/

#import <Foundation/Foundation.h>

@interface OCMediaProcessor : NSObject

/**
 * 开始转码
 * @param filePath  文件名（带路径）
 * @param streamType  视频文件类型，目前只支持mp4后期可扩展， 目前不生效，填0即可
 *
 * @return >=0: 获取文件时长， < 0 获取时长出错， 可使用上层时间
 */
+(int) getFileDuration:(NSString*)filePath StreamType:(NSInteger)streamType;

@end

