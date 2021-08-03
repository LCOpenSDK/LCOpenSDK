//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <LCBaseModule/LCPermissionHelper.h>
#import <LCBaseModule/LCSetJurisdictionHelper.h>

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>

@interface LCPermissionHelper ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LCPermissionHelper
	
- (void)requestAlwaysLocationPermissions:(BOOL)always completion:(void (^)(BOOL granted))completion {
    //先判断总定位服务是否可用(设置-->隐私-->定位服务，而不是app自己的定位服务)
    if (![CLLocationManager locationServicesEnabled]) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    BOOL locationEnable = [CLLocationManager locationServicesEnabled];
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!locationEnable || (status < 3 && status > 0)) {
            if (completion) {
                completion(NO);
            }
        } else if (status == kCLAuthorizationStatusNotDetermined){
            //获取授权认证
            if (always) {
                [self.locationManager requestAlwaysAuthorization];
            } else {
                [self.locationManager requestWhenInUseAuthorization]; //使用时开启定位
            }
        } else {
            if (always) {
                if (status == kCLAuthorizationStatusAuthorizedAlways) {
                    if (completion) {
                        completion(YES);
                    }
                } else {
                    if (completion) {
                        completion(NO);
                    }
                }
            } else {
                if (completion) {
                    completion(YES);
                }
            }
        }
    });
}

+ (void)requestAudioPermission:(void (^)(BOOL granted))completion {
	//申请对讲权限
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
	if (authStatus == AVAuthorizationStatusAuthorized) {
		dispatch_async(dispatch_get_main_queue(), ^{
			completion(true);
		});
	} else if (authStatus == AVAuthorizationStatusNotDetermined) {
		[AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(granted);
			});
		}];
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			[LCSetJurisdictionHelper setJurisdictionAlertView:@"mobile_common_permission_apply".lc_T message:@"mobile_common_permission_explain_record_audio".lc_T];
			completion(false);
		});
	}
}

+ (void)requestCameraPermission:(void (^)(BOOL granted))completion {
	//申请摄像头权限
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	if (authStatus == AVAuthorizationStatusAuthorized) {
		dispatch_async(dispatch_get_main_queue(), ^{
			completion(true);
		});
	} else if (authStatus == AVAuthorizationStatusNotDetermined) {
		[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(granted);
			});
		}];
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			[LCSetJurisdictionHelper setJurisdictionAlertView:@"mobile_common_permission_apply".lc_T  message:@"mobile_common_permission_explain_camera".lc_T];
			completion(false);
		});
	}
}

+ (void)requestAlbumPermission:(void (^)(BOOL granted))completion {
	//申请相册访问权限
	PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
	if (authStatus == PHAuthorizationStatusAuthorized) {
		dispatch_async(dispatch_get_main_queue(), ^{
			completion(true);
		});
	} else if (authStatus == PHAuthorizationStatusNotDetermined) {
		[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(status == PHAuthorizationStatusAuthorized);
			});
		}];
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			[LCSetJurisdictionHelper setJurisdictionAlertView:@"mobile_common_permission_apply".lc_T message:@"mobile_common_permission_explain_album".lc_T];
			completion(false);
		});
	}
}

+ (void)requestContacePermission:(void (^)(BOOL granted))completion complete:(void (^)(NSInteger))complete{
	//申请通讯录访问权限
	if (@available(iOS 9.0, *)) {
		CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
		if (authStatus == CNAuthorizationStatusAuthorized) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(true);
			});
		} else if (authStatus == CNAuthorizationStatusNotDetermined) {
			CNContactStore *store = [[CNContactStore alloc] init];
			[store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(granted);
				});
			}];
		} else {
			dispatch_async(dispatch_get_main_queue(), ^{
				[LCSetJurisdictionHelper setJurisdictionAlertView:@"mobile_common_permission_apply".lc_T  message:@"mobile_common_permission_explain_contact".lc_T complete:^(NSInteger index) {
					complete(index);
				}];
				completion(false);
			});
		}
	} else {
		// Fallback on earlier versions
		ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
		if (authStatus == kABAuthorizationStatusAuthorized) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(true);
			});
		} else if (authStatus == kABAuthorizationStatusNotDetermined) {
			ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
			ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(granted);
				});
			});
		} else {
			dispatch_async(dispatch_get_main_queue(), ^{
				[LCSetJurisdictionHelper setJurisdictionAlertView:@"mobile_common_permission_apply".lc_T  message:@"mobile_common_permission_explain_contact".lc_T complete:^(NSInteger index) {
					complete(index);
				}];
				completion(false);
			});
		}
	}
}

@end
