//
//  Copyright © 2018年 jm. All rights reserved.
//

#ifndef IDHBaseViewController_h
#define IDHBaseViewController_h

@protocol IDHBaseViewController <NSObject>

/**
 页面展示结束处理
 */
- (void)viewDidAppearProcess;


/**
 页面消失处理
 */
- (void)viewDidDisapperProcess;

@end
#endif /* IDHBaseViewController_h */
