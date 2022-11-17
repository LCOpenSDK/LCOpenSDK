//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCVideotapeHistoryCell.h"
#import "UIImageView+LCPicDecrypt.h"


@interface LCVideotapeHistoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *moreTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageview;

@end
@implementation LCVideotapeHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moreTitleLab.text = @"play_history_show_more".lc_T;
}

-(void)setDetail:(NSString *)detail{
    _detail = detail;
    self.startTimeLab.text = detail;
}

-(void)setIsMore:(BOOL)isMore{
    _isMore = isMore;
    if (isMore) {
        self.moreTitleLab.hidden = NO;
        self.startTimeLab.hidden = YES;
        self.moreImageview.hidden = NO;
        self.videoImageView.hidden = YES;
        return;
    }else{self.startTimeLab.hidden = NO;
        self.moreTitleLab.hidden = YES;
        self.moreImageview.hidden = YES;
        self.videoImageView.hidden = NO;
    }
}

-(void)loadVideotapImage:(nullable NSString *)url DeviceId:(NSString *)deviceId ProductId:(NSString *)productId Key:(NSString *)key{
    [self.videoImageView lc_setImageWithURL:url placeholderImage:LC_IMAGENAMED(@"common_defaultcover_big") DeviceId:deviceId ProductId:productId Key:key];
}

@end
