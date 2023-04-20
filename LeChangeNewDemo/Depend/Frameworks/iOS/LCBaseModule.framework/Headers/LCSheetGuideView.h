//
//  LCSheetGuideView.h
//  LCBaseModule
//
//  Created by yyg on 2023/3/6.
//  Copyright © 2023 jm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCSheetGuideViewCancleBlock)(void);

@interface LCSheetGuideView : UIView

@property (nonatomic, copy) LCSheetGuideViewCancleBlock cancleBlock;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message image:(UIImage * __nullable)iamge cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
