//
//  LCMediaAudioSampleConfigParam.h
//  LCMediaComponents
//
//  Created by lei on 2023/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCMediaAudioSampleConfigParam : NSObject

@property(nonatomic, assign)NSInteger encodeType;
@property(nonatomic, assign)NSInteger packType;
@property(nonatomic, assign)NSInteger sampleDepth;
@property(nonatomic, assign)NSInteger sampleRate;

/// 生成默认配置
-(void)createDefaultConfig;

-(NSDictionary *)toDictionary;

@end

@interface LCMediaVideoSampleConfigParam : NSObject

@property(nonatomic, assign)NSInteger width;
@property(nonatomic, assign)NSInteger height;
@property(nonatomic, assign)NSInteger I_frame_interval;
@property(nonatomic, assign)NSInteger encodeType;
@property(nonatomic, assign)NSInteger frameRate;
@property(nonatomic, assign)BOOL isCameraOpen;
@property(nonatomic, assign)BOOL softEncodeMode;

/// 生成默认配置
-(void)createDefaultConfig:(NSInteger)width height:(NSInteger)height isCameraOpen:(BOOL)isCameraOpen;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
