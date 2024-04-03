//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <LCBaseModule/LCPermissionHelper.h>
#import <LCBaseModule/LCSetJurisdictionHelper.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import <UserNotifications/UNNotificationSettings.h>
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (![CLLocationManager locationServicesEnabled]) {
            if (completion) {
                completion(NO);
            }
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

+ (void)requestCameraAndAudioPermission:(void (^)(BOOL granted))completion {
    //申请摄像头权限
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (cameraAuthStatus == AVAuthorizationStatusAuthorized && audioAuthStatus == AVAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(true);
        });
    } else if ((cameraAuthStatus == AVAuthorizationStatusAuthorized || cameraAuthStatus == AVAuthorizationStatusDenied) && audioAuthStatus == AVAuthorizationStatusAuthorized) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                        completion(granted);
                    }];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [LCSetJurisdictionHelper setJurisdictionAlertView:@"mobile_common_permission_apply".lc_T  message:@"mobile_common_permission_explain_camera".lc_T];
                        completion(false);
                    });
                    completion(false);
                }
            });
        }];
    } else if (cameraAuthStatus == AVAuthorizationStatusAuthorized && (audioAuthStatus == AVAuthorizationStatusNotDetermined || audioAuthStatus == AVAuthorizationStatusDenied)) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                        completion(granted);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [LCSetJurisdictionHelper setJurisdictionAlertView:@"mobile_common_permission_apply".lc_T message:@"mobile_common_permission_explain_record_audio".lc_T];
                        completion(false);
                    });
                }
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCSetJurisdictionHelper setJurisdictionAlertView:@"mobile_common_permission_apply".lc_T  message:@"请开启相机访问权限，以正常使用拍照、扫描二维码等功能\n请开启麦克风访问权限，以正常使用对讲等功能".lc_T];
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

+ (void)showUnPermissionLocationAlert:(NSString *)message {
    [LCSetJurisdictionHelper setJurisdictionAlertView:@"common_permission_request".lc_T message:message];
}

@end
