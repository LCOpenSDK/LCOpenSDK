//
//  LCNewPlayBackRouter.m
//  LCNewPlayBackModule
//
//  Created by lei on 2022/10/9.
//

#import "LCNewPlayBackRouter.h"
#import <LCBaseModule/LCModule.h>
#import "LCNewVideotapeListViewController.h"
#import "LCNewVideotapePlayerViewController.h"
#import "LCNewDeviceVideotapePlayManager.h"
#import <LCNetworkModule/LCCloudVideotapeInfo.h>

static NSString * const pbVideotapeListRouter = @"LCNewPlayBackRouter_VideotapeListRouter";
static NSString * const pbVideotapePlayer = @"LCNewPlayBackRouter_VideotapePlayer";

@interface LCNewPlayBackRouter()<LCModuleProtocol>

@end

@implementation LCNewPlayBackRouter

- (void)moduleInit {
    //录像列表
    [self registerVideotapeList];
    //录像播放
    [self registerVideotapePlayer];
}

-(void)registerVideotapeList {
    [LCRouter registerURLPattern:pbVideotapeListRouter toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LCRouterParameterUserInfo];
        NSNumber *type = (NSNumber *)userInfo[@"type"];
        
        LCNewVideotapeListViewController *videotapeListVC = [[LCNewVideotapeListViewController alloc] init];
        videotapeListVC.defaultType = [type integerValue];
        return videotapeListVC;
    }];
}

-(void)registerVideotapePlayer {
    [LCRouter registerURLPattern:pbVideotapePlayer toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LCRouterParameterUserInfo];
        NSString *cloudVideoJson = (NSString *)userInfo[@"cloudVideoJson"];
        NSString *localVideoJson = (NSString *)userInfo[@"localVideoJson"];
        
        if (cloudVideoJson != nil) {
            LCCloudVideotapeInfo *cloudInfo = [LCCloudVideotapeInfo jsonToObject:cloudVideoJson];
            if (cloudInfo != nil) {
                [LCNewDeviceVideotapePlayManager manager].cloudVideotapeInfo = cloudInfo;
            }
        }
        
        if (localVideoJson != nil) {
            LCLocalVideotapeInfo *localInfo = [LCLocalVideotapeInfo jsonToObject:localVideoJson];
            if (localInfo != nil) {
                [LCNewDeviceVideotapePlayManager manager].localVideotapeInfo = localInfo;
            }
        }
        
        LCNewVideotapePlayerViewController *videotapePlayerVC = [[LCNewVideotapePlayerViewController alloc] init];
        if (cloudVideoJson != nil && localVideoJson == nil) {
            videotapePlayerVC.fromType = LCNewVideotapePlayerFromTypeCloud;
        } else {
            videotapePlayerVC.fromType = LCNewVideotapePlayerFromTypeLocal;
        }
        return videotapePlayerVC;
    }];
}

@end
