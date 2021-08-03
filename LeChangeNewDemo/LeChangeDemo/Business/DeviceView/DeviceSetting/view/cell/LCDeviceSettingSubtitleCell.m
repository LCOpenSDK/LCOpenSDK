//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCDeviceSettingSubtitleCell.h"

@interface LCDeviceSettingSubtitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end

@implementation LCDeviceSettingSubtitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    if (self.block) {
        self.block();
    }
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

-(void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
    self.subTitleLab.text = subtitle;
}

-(void)setDetail:(NSString *)detail{
    _detail = detail;
    self.detailLab.text = detail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
