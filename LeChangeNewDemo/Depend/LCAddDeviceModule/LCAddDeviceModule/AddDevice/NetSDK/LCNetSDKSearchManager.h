//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISearchDeviceNetInfo.h"

@interface LCNetSDKSearchManager : NSObject

@property (nonatomic)BOOL isSearching;

/// 展示调试信息
@property (nonatomic, assign) BOOL showDebugLog;

+ (instancetype)sharedInstance;

- (void)startSearch;

- (void)stopSearch;

- (id<ISearchDeviceNetInfo>)getNetInfoByID:(NSString *)deviceID;

@end
