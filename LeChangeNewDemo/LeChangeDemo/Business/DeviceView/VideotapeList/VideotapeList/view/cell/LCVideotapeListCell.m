//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCVideotapeListCell.h"
#import "UIImageView+LCPicDecrypt.h"

@implementation LCVideotapeListCell

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
    [self.picImgview lc_setImageWithURL:info.thumbUrl placeholderImage:LC_IMAGENAMED(@"common_video_defaultpic_video") DeviceId:info.deviceId Key:info.deviceId];
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
