//
//  Copyright © 2017 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(LeChange)

/**
 是否是某个类，为了兼容Swift

 @param className 类名
 @return 判断结果
 */
- (BOOL)lc_isKindOfClass:(NSString*)className;

/**
 是否导航栈栈顶

 */
@property(nonatomic, assign, readonly) BOOL lc_isOnNavigationControllerTop;



@end
