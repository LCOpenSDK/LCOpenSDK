//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "PluginVideotapeHistoryCell.h"
#import <LCMediaBaseModule/UIImageView+LCMediaPicDecoder.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>


@interface PluginVideotapeHistoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *moreTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageview;

@end
@implementation PluginVideotapeHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moreTitleLab.text = @"play_history_show_more".lcMedia_T;
    self.moreImageview.image = [UIImage imageNamed:@"more"];
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

-(void)loadVideotapImage:(NSString *)url deviceId:(NSString *)deviceId productId:(NSString *)productId playtoken:(NSString *)playtoken key:(NSString *)key {
    [self.videoImageView lcMedia_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"common_defaultcover_big"] deviceId:deviceId productId:productId playtoken:playtoken key:key];
}

@end
