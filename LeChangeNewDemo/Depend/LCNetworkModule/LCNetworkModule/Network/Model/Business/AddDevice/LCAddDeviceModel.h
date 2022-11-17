//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCAddDeviceModel : NSObject

@end

@interface LCProductDetailModel : NSObject

///产品市场型号
@property (nonatomic, strong) NSString *deviceModelName;
///产品正视图地址
@property (nonatomic, strong) NSString *deviceImageURI;

@end

@interface LCProductModel : NSObject
///产品大类
@property (nonatomic, strong) NSString *deviceType;
///产品列表
@property (nonatomic, strong) NSArray<LCProductDetailModel *> *deviceModelList;

@end

@interface LCOMSImageModel : NSObject

///图片名称
@property (nonatomic, strong) NSString *imageName;
///图片URL
@property (nonatomic, strong) NSString *imageUrl;

@end

@interface LCOMSIntroductionModel : NSObject

///引导提示名称
@property (nonatomic, strong) NSString *introductionName;
///引导提示文案
@property (nonatomic, strong) NSString *introductionContent;

@end

@interface LCOMSModel : NSObject

///引导图列表
@property (nonatomic, strong) NSArray<LCOMSImageModel *> *images;

///引导文案
@property (nonatomic, strong) NSArray<LCOMSIntroductionModel *> *introductions;

-(NSString *)findImageByName:(NSString *)name;

-(NSString *)findContentByName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
