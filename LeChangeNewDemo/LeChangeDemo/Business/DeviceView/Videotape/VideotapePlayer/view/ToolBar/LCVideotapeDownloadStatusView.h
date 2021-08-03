//
//  Copyright © 2020 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^DownloadStatusViewClickBlock)(void);

@interface LCVideotapeDownloadStatusView : UIView

/// 总大小
@property (nonatomic) NSInteger size;
/// 增量大小
@property (nonatomic) NSInteger recieve;
/// 当前下载进度
@property (nonatomic) NSInteger totalRevieve;
///取消下载
@property (copy,nonatomic) DownloadStatusViewClickBlock cancleBlock;



+(instancetype)showDownloadStatusInView:(UIView *)view Size:(NSInteger)size;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
