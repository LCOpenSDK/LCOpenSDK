//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapeListCell.h"
#import <LCMediaBaseModule/UIImageView+LCMediaPicDecoder.h>
#import <LCNetworkModule/LCCloudVideotapeInfo.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>

@implementation LCNewVideotapeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(id)model {
    _model = model;
    if ([model isKindOfClass:[LCCloudVideotapeInfo class]]) {
        [self configCloudVideotape];
    } else if ([model isKindOfClass:[LCLocalVideotapeInfo class]]) {
        [self configLocalVideotape];
    } else {
        
    }
}

- (void)configCloudVideotape {
    LCCloudVideotapeInfo *info = (LCCloudVideotapeInfo *)self.model;
    NSString *pid = info.productId != nil ? info.productId : @"";
    [self.picImgview lcMedia_setImageWithURL:info.thumbUrl placeholderImage:LC_IMAGENAMED(@"common_video_defaultpic_video") DeviceId:info.deviceId ProductId:pid Key:info.deviceId];
    self.startTimeLab.text = [[info.beginTime componentsSeparatedByString:@" "] objectAtIndex:1];
    self.durationTimeLab.text = [info durationTime];
}

- (void)configLocalVideotape {
    LCLocalVideotapeInfo *info = (LCLocalVideotapeInfo *)self.model;
    [self.picImgview setImage:LC_IMAGENAMED(@"common_video_defaultpic_video")];
   
    self.startTimeLab.text = [[info.beginTime componentsSeparatedByString:@" "] objectAtIndex:1];
    self.durationTimeLab.text = [info durationTime];
}

@end
