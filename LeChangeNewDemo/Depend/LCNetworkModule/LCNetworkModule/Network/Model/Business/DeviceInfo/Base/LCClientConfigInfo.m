//
//  Copyright © 2018年 dahua. All rights reserved.
//

#import "LCClientConfigInfo.h"

@implementation DHOMSDeviceModelItem
- (id)copyWithZone:(NSZone *)zone {
	DHOMSDeviceModelItem *item = [DHOMSDeviceModelItem new];
	item.deviceModelName = self.deviceModelName;
	item.deviceImageURI = self.deviceImageURI;
	return item;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeObject:self.deviceModelName forKey:@"deviceModelName"];
	[aCoder encodeObject:self.deviceImageURI forKey:@"deviceImageURI"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self)
	{
		self.deviceModelName = [aDecoder decodeObjectForKey:@"deviceModelName"];
		self.deviceImageURI = [aDecoder decodeObjectForKey:@"deviceImageURI"];
	}
	return self;
}
@end

@implementation DHOMSDeviceType
- (instancetype)init {
	if (self = [super init]) {
		_modelItems = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	DHOMSDeviceType *info = [DHOMSDeviceType new];
	info.deviceType = self.deviceType;
	info.modelItems = self.modelItems;
	return info;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeObject:self.deviceType forKey:@"deviceType"];
	[aCoder encodeObject:self.modelItems forKey:@"modelItems"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self)
	{
		self.deviceType = [aDecoder decodeObjectForKey:@"deviceType"];
		self.modelItems = [aDecoder decodeObjectForKey:@"modelItems"];
	}
	return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"modelItems": @"deviceModelList"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"modelItems" : [DHOMSDeviceModelItem class]};
}

@end



@implementation DHOMSIntroductionImageItem
- (id)copyWithZone:(NSZone *)zone {
	DHOMSIntroductionImageItem *item = [DHOMSIntroductionImageItem new];
	item.imageName = self.imageName;
	item.imageURI = self.imageURI;
	return item;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeObject:self.imageName forKey:@"imageName"];
	[aCoder encodeObject:self.imageURI forKey:@"imageURI"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self)
	{
		self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
		self.imageURI = [aDecoder decodeObjectForKey:@"imageURI"];
	}
	return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"imageURI": @"imageUrl"};
}

@end


@implementation DHOMSIntroductionContentItem

- (instancetype)init {
    if (self = [super init]) {
        _introductionName = @"";
        _introductionContent = @"";
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
	DHOMSIntroductionContentItem *item = [DHOMSIntroductionContentItem new];
	item.introductionName = self.introductionName;
	item.introductionContent = self.introductionContent;
	return item;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeObject:self.introductionName forKey:@"introductionName"];
	[aCoder encodeObject:self.introductionContent forKey:@"introductionContent"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self)
	{
		self.introductionName = [aDecoder decodeObjectForKey:@"introductionName"];
		self.introductionContent = [aDecoder decodeObjectForKey:@"introductionContent"];
	}
	return self;
}
@end



@implementation DHOMSIntroductionInfo

- (instancetype)init {
	if (self = [super init]) {
		_images = [[NSMutableArray alloc] init];
		_contens = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	DHOMSIntroductionInfo *info = [DHOMSIntroductionInfo new];
	info.updateTime = self.updateTime;
	info.images = self.images;
	info.contens = self.contens;
	return info;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.updateTime forKey:@"updateTime"];
	[aCoder encodeObject:self.images forKey:@"images"];
	[aCoder encodeObject:self.contens forKey:@"contens"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.updateTime = [aDecoder decodeObjectForKey:@"updateTime"];
		self.images = [aDecoder decodeObjectForKey:@"images"];
		self.contens = [aDecoder decodeObjectForKey:@"contens"];
	}
	return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"contens": @"introductions"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"images" : [DHOMSIntroductionImageItem class],@"contens" : [DHOMSIntroductionContentItem class]};
}

@end

@implementation DHTabbarIconInfo
- (id)copyWithZone:(NSZone *)zone {
    DHTabbarIconInfo *info = [DHTabbarIconInfo new];
    info.iconName = self.iconName;
    info.iconPic = self.iconPic;
    info.iconPicSelected = self.iconPicSelected;
    return info;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.iconName forKey:@"iconName"];
    [aCoder encodeObject:self.iconPic forKey:@"iconPic"];
    [aCoder encodeObject:self.iconPicSelected forKey:@"iconPicSelected"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.iconName = [aDecoder decodeObjectForKey:@"iconName"];
        self.iconPic = [aDecoder decodeObjectForKey:@"iconPic"];
        self.iconPicSelected = [aDecoder decodeObjectForKey:@"iconPicSelected"];
    }
    return self;
}

@end
