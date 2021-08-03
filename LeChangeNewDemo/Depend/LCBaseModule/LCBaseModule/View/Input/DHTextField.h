//
//  Copyright © 2020 jm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DHTextFieldInputBlock)(NSString * result);

typedef BOOL(^DHTextFieldInputingBlock)(NSString * result,NSString * replace);

@interface DHTextField : UITextField

/// 回调代码块
@property (copy, nonatomic) DHTextFieldInputingBlock inputingBlock;

/// placeholder
@property (nonatomic, copy,nullable) NSString *placeholder;

+(instancetype)lcTextFieldWithResult:(void(^)(NSString *result))result;

@end

NS_ASSUME_NONNULL_END
