//
//  Copyright © 2018年 jm. All rights reserved.
//

#ifndef ILCBaseViewController_h
#define ILCBaseViewController_h

@protocol ILCBaseViewController <NSObject>

/**
 页面展示结束处理
 */
- (void)viewDidAppearProcess;


/**
 页面消失处理
 */
- (void)viewDidDisapperProcess;

@end
#endif /* ILCBaseViewController_h */
