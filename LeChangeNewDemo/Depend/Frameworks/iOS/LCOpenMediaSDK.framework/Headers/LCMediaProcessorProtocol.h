//
//  LCMediaProcessorProtocol.h
//  LCOpenMediaSDK
//
//  Created by lei on 2025/6/18.
//

#import <Foundation/Foundation.h>

@protocol LCMediaProcessorProtocol <NSObject>
/**
 * 开始转码
 * @param filePath  文件名（带路径）
 * @param streamType  视频文件类型，目前只支持mp4后期可扩展， 目前不生效，填0即可
 *
 * @return >=0: 获取文件时长， < 0 获取时长出错， 可使用上层时间
 */
-(int)getFileDuration:(NSString*)filePath StreamType:(NSInteger)streamType;

@end
