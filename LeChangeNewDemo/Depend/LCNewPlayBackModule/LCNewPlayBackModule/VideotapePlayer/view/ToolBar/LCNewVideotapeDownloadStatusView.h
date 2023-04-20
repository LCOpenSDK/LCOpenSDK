//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^NewDownloadStatusViewClickBlock)(void);

@interface LCNewVideotapeDownloadStatusView : UIView

/// 总大小
@property (nonatomic) NSInteger size;
/// 增量大小
@property (nonatomic) NSInteger recieve;
/// 当前下载进度
@property (nonatomic) NSInteger totalRevieve;
///取消下载
@property (copy,nonatomic) NewDownloadStatusViewClickBlock cancleBlock;



+(instancetype)showDownloadStatusInView:(UIView *)view Size:(NSInteger)size;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
