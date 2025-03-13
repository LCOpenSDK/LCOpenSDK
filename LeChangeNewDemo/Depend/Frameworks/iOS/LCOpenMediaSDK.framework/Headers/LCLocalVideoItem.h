//
//  LCLocalVideoItem.h
//  LCMediaModule
//
//  Created by lei on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLocalVideoItem : NSObject<NSCopying>

@property(nonatomic, copy)NSString *filePath;

@property(nonatomic, assign)LCLocalVideoType videoType;

@property (nonatomic, strong, nullable)NSArray<LCLocalVideoItem *> *associatedItems;

@end



NS_ASSUME_NONNULL_END
