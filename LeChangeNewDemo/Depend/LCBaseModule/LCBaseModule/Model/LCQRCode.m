//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "LCQRCode.h"

@implementation LCQRCode

- (void)pharseQRCode:(NSString *)qrCode {
	NSString *vaildString = [qrCode stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
	
	//【*】标准二维码格式，以SN：区分，{SN:xxxxx,DT:xxxx,SC:123456LC,NC:11}，中间可能不以,进行分隔
	//【*】非标准二维码，做兼容处理
	NSRange snRange = [vaildString rangeOfString:@"SN:"];
	if (snRange.location != NSNotFound) {
		
		self.deviceSN = [self getValueByKey:@"SN:" validQRCode:vaildString isType:NO];
		self.deviceType = [self getValueByKey:@"DT:" validQRCode:vaildString isType:YES];
		
		//兼容旧的验证码RD或RC
		self.identifyingCode = [self getValueByKey:@"RD:" validQRCode:vaildString isType:NO];
		if (self.identifyingCode.length == 0) {
			self.identifyingCode = [self getValueByKey:@"RC:" validQRCode:vaildString isType:NO];
		}
		
		//SC码及NC
		self.scCode = [self getValueByKey:@"SC:" validQRCode:vaildString isType:NO];
		self.ncCode = [self getValueByKey:@"NC:" validQRCode:vaildString isType:NO];
		self.imeiCode = [self getValueByKey:@"IMEI:" validQRCode:vaildString isType:NO];
		
	} else {
		//序列号:设备类型:验证码 或者 序列号:设备类型 或者 序列号
		if ([vaildString rangeOfString:@":"].location != NSNotFound) {
			NSArray *strarray = [vaildString componentsSeparatedByString:@":"];
			if (strarray.count == 2) {
				// 序列号:设备类型
				self.deviceSN = strarray[0];
				self.deviceType = strarray[1];
			} else if (strarray.count == 3) {
				// 序列号:设备类型:验证码
				self.deviceSN = strarray[0];
				self.deviceType = strarray[1];
				self.identifyingCode = strarray[2];
			}
		} else if ([vaildString rangeOfString:@","].location != NSNotFound) {
			//DH-IPC-C35P,4K002C6PAJA49A7   兼容错误二维码
			NSArray<NSString *> *list = [vaildString componentsSeparatedByString:@","];
			if(list.count >= 2){
				self.deviceType = list[0];
				self.deviceSN = list[1];
			}
		}
		else{
			// 只有序列号
			self.deviceSN = vaildString;
		}
	}
	
	NSLog(@"🍎🍎🍎 %@:: SN:%@, Type:%@, IdentifyCode:%@, SCCdoe:%@, NCCode:%@, IMEI:%@", NSStringFromClass([self class]), self.deviceSN, self.deviceType, self.identifyingCode, self.scCode, self.ncCode, self.imeiCode);
}

- (NSString *)getValueByKey:(NSString *)key
				validQRCode:(NSString *)validQRCode
					 isType:(BOOL)isType {
	NSString *result;
	NSRange range = [validQRCode rangeOfString:key];
	if (range.location != NSNotFound) {
		result = [self getStringFromNSrange:range urlString:validQRCode isType:isType];
	}
	
	return result;
}

- (NSString*) getStringFromNSrange:(NSRange)range
                         urlString:(NSString*)urlString
                            isType:(BOOL)isType
{
    NSString *validString = [urlString substringFromIndex:range.location+range.length];
    
    int nIndex = 0;
    for (int i = 0; i < [validString length]; i++)
    {
        NSRange r ;
        r.length = 1;
        r.location = i;
        NSString* c = [validString substringWithRange:r];
        
        if (isType)
        {
            //符合a-z,A-Z,0-9,\,/,-,空格等字符
            if ([c rangeOfString:@"^[a-zA-Z0-9-\\/\\\\ ]$" options:NSRegularExpressionSearch].location == NSNotFound)
            {
                nIndex = i;
                break;
            }
        }
        else
        {
            if ([c rangeOfString:@"^([a-z]|[A-Z]|[0-9])$" options:NSRegularExpressionSearch].location == NSNotFound)
            {
                nIndex = i;
                break;
            }
        }
    }
    
    return [validString substringToIndex:nIndex];
}

@end
