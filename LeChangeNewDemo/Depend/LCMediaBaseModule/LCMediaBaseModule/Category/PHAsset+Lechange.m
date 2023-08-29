//
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "PHAsset+Lechange.h"
#import <Foundation/Foundation.h>
@import Photos;

@implementation PHAsset (Lechange)

#pragma mark Public methods

+(void)saveImageToCameraRoll:(UIImage*)image
                         url:(NSURL *)url
                     success:(void (^)(void))theSuccess
                     failure:(void(^)(NSError *error))theFailure
{
    __block PHObjectPlaceholder *placeholderAsset = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *newAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        placeholderAsset = newAssetRequest.placeholderForCreatedAsset;
    } completionHandler:^(BOOL success, NSError *error) {
        if(success){
            [[NSUserDefaults standardUserDefaults] setObject:placeholderAsset.localIdentifier forKey:url.absoluteString];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (theSuccess) {
                theSuccess();
            }
        } else {
            if(theFailure){
                theFailure(error);
            }
        }
    }];
}

+(void)saveVideoAtURL:(NSURL *)url
              success:(void (^)(void))theSuccess
              failure:(void(^)(NSError *error))theFailure
{
    __block PHObjectPlaceholder *placeholderAsset = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest *videoRequest = [PHAssetCreationRequest creationRequestForAsset];
        [videoRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:url options:nil];
        placeholderAsset = videoRequest.placeholderForCreatedAsset;
    } completionHandler:^(BOOL success, NSError *error) {
        if(success){
            [[NSUserDefaults standardUserDefaults] setObject:placeholderAsset.localIdentifier forKey:url.absoluteString];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (theSuccess) {
                theSuccess();
            }
        } else {
            if(theFailure){
                theFailure(error);
            }
        }
    }];
}

+(void)deleteFormCameraRoll:(NSURL *)url
                    success:(void (^)(void))theSuccess
                    failure:(void(^)(NSError *error))theFailure
{
    
    PHAsset *asset = [self getAssetFromlocalIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:url.absoluteString]];
    if (asset) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:url.absoluteString];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (theSuccess) {
                    theSuccess();
                }
            } else {
                if (theFailure) {
                    theFailure(error);
                }
            }
        }];
    } else {
        if (theSuccess) {
            theSuccess();
        }
    }
}

#pragma mark Private helpers

+(PHAsset*)getAssetFromlocalIdentifier:(NSString*)localIdentifier {
    if(localIdentifier == nil){
        NSLog(@"Cannot get asset from localID because it is nil");
        return nil;
    }
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    if(result.count){
        return result[0];
    }
    return nil;
}

@end
