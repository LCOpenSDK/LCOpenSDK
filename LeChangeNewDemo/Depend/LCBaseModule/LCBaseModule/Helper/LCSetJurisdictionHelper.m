//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <LCBaseModule/LCSetJurisdictionHelper.h>
#import <LCBaseModule/DHAlertController.h>

@implementation LCSetJurisdictionHelper

+(void)setJurisdictionAlertView:(NSString*)title message:(NSString*)message 

{

  void (^aBlock)(void) =  ^(void){
      
      //float version = [[[UIDevice currentDevice] systemVersion] floatValue];
      
      NSString *  urlString = UIApplicationOpenSettingsURLString;

      NSURL* url = [NSURL URLWithString:urlString];
      
     if ([[UIApplication sharedApplication] canOpenURL:url])
     {
          [[UIApplication sharedApplication] openURL:url];
     }
      
     };
	
	[DHAlertController showWithTitle:title message:message cancelButtonTitle:@"mobile_common_common_ignore".lc_T otherButtonTitle:@"go_to_setting".lc_T handler:^(NSInteger index) {
		if (index == 1) {
			aBlock();
		}
	}];
}

+(void)setJurisdictionAlertView:(NSString*)title message:(NSString*)message complete:(void(^)(NSInteger index))complete{
	void (^aBlock)(void) =  ^(void){
		
		//float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		
		NSString *  urlString = UIApplicationOpenSettingsURLString;
		
		NSURL* url = [NSURL URLWithString:urlString];
		
		if ([[UIApplication sharedApplication] canOpenURL:url])
		{
			[[UIApplication sharedApplication] openURL:url];
		}
		
	};
	
	[DHAlertController showWithTitle:title message:message cancelButtonTitle:@"mobile_common_common_ignore".lc_T otherButtonTitle:@"go_to_setting".lc_T handler:^(NSInteger index) {
		complete(index);
		if (index == 1) {
			aBlock();
		}
	}];
}

@end
