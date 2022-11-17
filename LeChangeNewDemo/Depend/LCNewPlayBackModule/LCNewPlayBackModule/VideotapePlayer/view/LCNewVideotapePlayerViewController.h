//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCBaseModule/LCBaseModule.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LCNewVideotapePlayerFromType) {
    LCNewVideotapePlayerFromTypeCloud,
    LCNewVideotapePlayerFromTypeLocal
};

@interface LCNewVideotapePlayerViewController : LCBaseViewController

@property (nonatomic, assign) LCNewVideotapePlayerFromType fromType;

@end

NS_ASSUME_NONNULL_END
