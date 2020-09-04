//
//  AppDelegate.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "AppDelegate.h"
#import "MyNavigationController.h"
#import "StartViewController.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StartViewController* startView = [currentBoard instantiateViewControllerWithIdentifier:@"StartView"];
    MyNavigationController* nav = [[MyNavigationController alloc] initWithRootViewController:startView];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    PHAuthorizationStatus statue = [PHPhotoLibrary authorizationStatus];
    if (statue == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
    };
    
    AVAuthorizationStatus auStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (auStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
        }];
    };
    

    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    signal(SIGPIPE, SIG_IGN);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    return UIInterfaceOrientationMaskAll;
}

void uncaughtExceptionHandler(NSException* exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
    
    //add by sq
    NSArray *symbols = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *ljSymbolsStr =@"";
    for (NSInteger i = 0; i < symbols.count; i++) {
        ljSymbolsStr = [NSString stringWithFormat:@"%@\r\n%@",ljSymbolsStr,symbols[i]];
    }
    
    NSString *ljValue = [NSString stringWithFormat:@"1.name:%@\r\n2.reason:%@\r\n3.symbols:%@",name,reason,ljSymbolsStr];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    NSString *ljpath = [NSString stringWithFormat:@"%@/LCOpensdk.txt",documentsDirectory];
    NSError *error = nil;
    [ljValue writeToFile:ljpath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}
@end
