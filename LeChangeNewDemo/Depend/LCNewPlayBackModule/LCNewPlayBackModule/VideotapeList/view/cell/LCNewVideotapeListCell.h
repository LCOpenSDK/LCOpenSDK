//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNewVideotapeListCell : UICollectionViewCell
///缩略图
@property (weak, nonatomic) IBOutlet UIImageView *picImgview;
///选择图片
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
///开始时间lab
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
///持续时间Lab
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLab;

///Model
@property (strong,nonatomic)id model;

@end

NS_ASSUME_NONNULL_END
