//
//  Copyright © 2020 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCVideotapeHistoryCellClickBlock)(void);

@interface LCVideotapeHistoryCell : UICollectionViewCell

/// 点击事件
@property (copy,nonatomic) LCVideotapeHistoryCellClickBlock selectedBlock;

/// detail
@property (strong, nonatomic) NSString *detail;

/// isMore是否是现实更多按钮
@property (nonatomic) BOOL isMore;

/**
 加载图片视频截图

 @param url 云录像预览图
 @param deviceId 设备序列号
 @param key 解密密钥
 */
-(void)loadVideotapImage:(nullable NSString *)url DeviceId:(NSString *)deviceId Key:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
