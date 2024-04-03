//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPermissionHelper : NSObject

/**
 判断、申请音频权限，对讲时申请，结果通过completion回调出来

 @param completion grand为YES时表示有权限，NO表示无权限
 */
+ (void)requestAudioPermission:(void (^)(BOOL granted))completion;

/**
 判断、申请摄像头权限，拍照、扫描二维码时使用，结果通过completion回调出来
 
 @param completion grand为YES时表示有权限，NO表示无权限
 */
+ (void)requestCameraPermission:(void (^)(BOOL granted))completion;
/**
 判断、申请摄像头和麦克风权限，可视对讲时使用，结果通过completion回调出来
 
 @param completion grand为YES时表示有权限，NO表示无权限
 */
+ (void)requestCameraAndAudioPermission:(void (^)(BOOL granted))completion;
/**
 判断、申请相册权限，导出时使用，结果通过completion回调出来
 
 @param completion grand为YES时表示有权限，NO表示无权限
 */
+ (void)requestAlbumPermission:(void (^)(BOOL granted))completion;


/**
判断、申请定位
@param always 是否总是允许
@param completion grand为YES时表示有权限，NO表示无权限
*/
- (void)requestAlwaysLocationPermissions:(BOOL)always completion:(void (^)(BOOL granted))completion;

/**
 位置权限,这里只提供一个被拒之后的弹窗, 跳转系统设置
 */

+ (void)showUnPermissionLocationAlert:(NSString *)message;

@end
