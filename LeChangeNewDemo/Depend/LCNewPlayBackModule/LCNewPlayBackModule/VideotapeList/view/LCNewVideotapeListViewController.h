//
//  Copyright © 2020 Imou. All rights reserved.
// 全部录像列表

#import <LCMediaBaseModule/LCSegmentController.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNewVideotapeListViewController : UIViewController

///云录像列表
@property (nonatomic,strong)UICollectionView * cloudVideoList;

///本地录像列表
@property (nonatomic,strong)UICollectionView * localVideoList;

///本地录像/云录像切换
@property (nonatomic,strong)LCSegmentController * segment;

///0:云录像 1:本地录像
@property (nonatomic)NSInteger defaultType;


@end

NS_ASSUME_NONNULL_END
