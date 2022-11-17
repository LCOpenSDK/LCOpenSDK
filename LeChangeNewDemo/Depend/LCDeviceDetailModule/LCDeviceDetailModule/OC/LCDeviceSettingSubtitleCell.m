//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCDeviceSettingSubtitleCell.h"
#import <Masonry/Masonry.h>

@implementation LCDeviceSettingSubtitleCellModel

@end

@interface LCDeviceSettingSubtitleCell ()
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *subTitleLab;
@property (strong, nonatomic) UILabel *detailLab;
@end

@implementation LCDeviceSettingSubtitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupUI];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
    return self;
}

- (void)setupUI {
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.titleLab.textColor = [UIColor colorWithRed:44.0/255 green:44.0/255 blue:44.0/255 alpha:1.0];
    [self addSubview:self.titleLab];
    
    self.subTitleLab = [[UILabel alloc] init];
    self.subTitleLab.font = [UIFont systemFontOfSize:14];
    self.subTitleLab.textColor = [UIColor colorWithRed:143.0/255 green:143.0/255 blue:143.0/255 alpha:1.0];
    self.subTitleLab.numberOfLines = 0;
    self.subTitleLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.subTitleLab];
    
    self.detailLab = [[UILabel alloc] init];
    self.detailLab.font = [UIFont systemFontOfSize:14];
    self.detailLab.textColor = [UIColor colorWithRed:143.0/255 green:143.0/255 blue:143.0/255 alpha:1.0];
    self.detailLab.numberOfLines = 0;
    [self addSubview:self.detailLab];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    if (self.block) {
        self.block();
    }
}

- (void)setModel:(LCDeviceSettingSubtitleCellModel *)model {
    self.titleLab.text = model.title;
    self.subTitleLab.text = model.subtitle;
    self.detailLab.text = model.detail;
    
    if (model.detail != nil && model.detail.length > 0) {
        [self.detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self).offset(-25);
            make.leading.mas_equalTo(self).offset(20);
            make.bottom.mas_equalTo(self).offset(-15);
            make.height.greaterThanOrEqualTo(@50);
        }];
        
        [self.subTitleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self).offset(-25);
            make.top.mas_equalTo(self).offset(15);
            make.bottom.mas_equalTo(self.detailLab.mas_top).offset(-15);
            make.width.mas_equalTo(180);
        }];
        
        [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(15);
            make.trailing.mas_equalTo(self.subTitleLab.mas_leading).offset(-20);
            make.centerY.mas_equalTo(self.subTitleLab.mas_centerY);
        }];
    } else {
        [self.subTitleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self).offset(-25);
            make.top.mas_equalTo(self).offset(15);
            make.bottom.mas_equalTo(self).offset(-15);
            make.width.mas_equalTo(180);
            make.height.greaterThanOrEqualTo(@30);
        }];
        
        [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(15);
            make.trailing.mas_equalTo(self.subTitleLab.mas_leading).offset(-20);
            make.centerY.mas_equalTo(self.subTitleLab.mas_centerY);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
