//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCAddDeviceModel.h"

@implementation LCAddDeviceModel

@end

@implementation LCProductDetailModel

@end

@implementation LCProductModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"deviceModelList" : [LCProductDetailModel class]};
}

@end

@implementation LCOMSImageModel

@end

@implementation LCOMSIntroductionModel

@end

@implementation LCOMSModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"images" : [LCOMSImageModel class],@"introductions" : [LCOMSIntroductionModel class]};
}

- (NSString *)findImageByName:(NSString *)name {
    for (LCOMSImageModel * model in self.images) {
        if ([model.imageName isEqualToString:name]) {
            return model.imageUrl;
        }
    }
    return @"";
}

- (NSString *)findContentByName:(NSString *)name {
    for (LCOMSIntroductionModel * model in self.introductions) {
           if ([model.introductionName isEqualToString:name]) {
               return model.introductionContent;
           }
       }
     return @"";
}

@end
