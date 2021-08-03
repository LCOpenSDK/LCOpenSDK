//
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

@interface PHAsset (Lechange)

+(void)saveImageToCameraRoll:(UIImage*)image
                         url:(NSURL *)url
                     success:(void(^)(void))theSuccess
                     failure:(void(^)(NSError *error))theFailure;

+(void)saveVideoAtURL:(NSURL *)url
              success:(void(^)(void))theSuccess
              failure:(void(^)(NSError *error))theFailure;

+(void)deleteFormCameraRoll:(NSURL *)url
                    success:(void(^)(void))theSuccess
                    failure:(void(^)(NSError *error))theFailure;
@end
