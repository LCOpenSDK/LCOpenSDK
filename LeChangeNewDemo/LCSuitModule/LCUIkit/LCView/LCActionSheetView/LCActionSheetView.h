//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCUIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCActionSheetView : UIView

/**
 弹出ActionSheet

 @param itemsList 按钮的文字数组，数组长度最大为 6
 @param itemColor 按钮的文字颜色（16进制）
 @param view 加到视图上
 @param success 接口调用成功的回调函数
 @param cancle 接口调用失败的回调函数
 @param complete 接口调用结束的回调函数（调用成功、失败都会执行）
 */
+(instancetype)lc_ShowActionView:(NSArray *)itemsList ToView:(UIView *)view ItemColor:(nullable NSString *)itemColor Success:(void(^)(NSInteger index))success Cancle:(void(^)(void))cancle Complete:(void(^)(void))complete;


-(void)dismiss;

@end

NS_ASSUME_NONNULL_END
