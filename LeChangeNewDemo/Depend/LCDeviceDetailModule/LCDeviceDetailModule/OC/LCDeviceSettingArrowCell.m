//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCDeviceSettingArrowCell.h"
#import <LCBaseModule/LCBaseModule.h>

@interface LCDeviceSettingArrowCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet LCButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *deviceSnap;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLab;

@end

@implementation LCDeviceSettingArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    if (self.block) {
        self.block(0);
    }
}
- (IBAction)rightBtnClick:(UIButton *)sender {
    if (self.block) {
        self.block(1);
    }
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

-(void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
    self.subtitleLab.text = subtitle;
}

-(void)setArrowImage:(UIImage *)image{
    [self.rightBtn setImage:image forState:UIControlStateNormal];
}

- (void)loadImage:(NSString *)imageUrl DeviceId:(NSString *)deviceId ChannelId:(NSString *)channelId {
    [self.deviceSnap lc_setThumbImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"common_defaultcover_big"] DeviceId:deviceId ChannelId:channelId];
}

-(void)setDeviceSnapHidden:(BOOL)deviceSnapHidden{
    
    self.deviceSnap.hidden = deviceSnapHidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if ([self.rightBtn pointInside:point withEvent:event]) {
        return self.rightBtn;
    }
    return [super hitTest:point withEvent:event];
}

@end
