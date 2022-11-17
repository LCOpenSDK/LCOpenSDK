//
//  Copyright © 2020 jm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCCTextFieldInputBlock)(NSString * result);

typedef BOOL(^LCCTextFieldInputingBlock)(NSString * result,NSString * replace);

@interface LCCTextField : UITextField

/// 回调代码块
@property (copy, nonatomic) LCCTextFieldInputingBlock inputingBlock;

/// placeholder
@property (nonatomic, copy,nullable) NSString *placeholder;

+(instancetype)lcTextFieldWithResult:(void(^)(NSString *result))result;

@end

NS_ASSUME_NONNULL_END
