//
//  Copyright © 2015 dahua. All rights reserved.
//

#import <LCBaseModule/UIImageView+LeChange.h>
#import <LCBaseModule/DHImageLoaderManager.h>
#import <AFNetworking/AFImageDownloader.h>
#import <LCBaseModule/DHPubDefine.h>
#import <LCBaseModule/NSString+MD5.h>
#import <LCBaseModule/DHModuleConfig.h>
#import <LCBaseModule/LCError.h>
#import <LCBaseModule/LCErrorCode.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Utils.h>
#import <SDWebImage/SDWebImage.h>
#import <LCBaseModule/UIImage+DHGIF.h>

#import <objc/runtime.h>


/*  Todo::根据组件定义错误类型
 *- 0 表示解密成功
 *- 1 表示完整性校验失败
 *- 2 表示密钥错误
 *- 3 表示图片非加密
 *- 4 不支持的加密方式
 *- 5 缓存区不足
 *- -99 内部错误
 */

#pragma mark - UIImageView(LeChange)

static NSString *gifKey = @"gifKey";
static NSString *tokenKey = @"tokenKey";

@implementation UIImageView(LeChange)

+ (void)load {
	//DTS000227688：多线程操作偶现崩溃问题，修改为全局只设置一次
	[[self class] sharedImageDownloader].sessionManager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"lechange/lechange", @"image/png", nil];
}

- (void)setIsNeedSupportGif:(BOOL)isNeedSupportGif
{
   objc_setAssociatedObject(self, &gifKey, [NSNumber numberWithBool:isNeedSupportGif], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isNeedSupportGif
{
    NSNumber *tempNum = objc_getAssociatedObject(self, &gifKey);
    if (tempNum == nil){
        return NO;
    }
    return tempNum.boolValue;
}

- (void)setAccessToken:(NSString *)accessToken {
	objc_setAssociatedObject(self, &tokenKey, accessToken, OBJC_ASSOCIATION_COPY);
}

- (NSString *)accessToken {
	return objc_getAssociatedObject(self, &tokenKey) ? : @"";
}

- (void)lc_storeImageToDisk:(UIImage*)image url:(NSString *)imageUrl {
    //获取缓存路径
    NSString *baseUrl = [DHImageLoaderManager getImageCacheKey:imageUrl];
    [[SDImageCache sharedImageCache] storeImage:image forKey:baseUrl toDisk:YES completion:nil];
}

- (UIImage *)lc_getImageWithCache:(NSString *)imageUrl {
    UIImage *cacheImage = [[SDImageCache sharedImageCache]imageFromMemoryCacheForKey:imageUrl];
    return cacheImage;
}

- (void)lc_setImageWithUrl:(NSString *)url {
    [self setImageWithUrl:url placeholderImage:nil aesKey:nil deviceID:nil devicePwd:nil toDisk:NO reload:NO progress:nil success:nil fail:nil];
}

- (void)lc_setImageWithUrl:(NSString *)url toDisk:(BOOL)toDisk {
    [self setImageWithUrl:url placeholderImage:nil aesKey:nil deviceID:nil devicePwd:nil toDisk:toDisk reload:NO progress:nil success:nil fail:nil];
}

- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder {
    [self setImageWithUrl:url placeholderImage:placeholder aesKey:nil deviceID:nil devicePwd:nil toDisk:NO reload:NO progress:nil success:nil fail:nil];
}

- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder  toDisk:(BOOL)toDisk {
    [self setImageWithUrl:url placeholderImage:placeholder aesKey:nil deviceID:nil devicePwd:nil toDisk:toDisk reload:NO progress:nil success:nil fail:nil];
}

- (void)lc_setImageWithUrl:(NSString *)url aesKey:(NSString *)key deviceID:(NSString *)deviceID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk {
    [self setImageWithUrl:url placeholderImage:nil aesKey:key deviceID:deviceID devicePwd:devicePwd toDisk:toDisk reload:NO progress:nil success:nil fail:nil];
}

- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID devicePwd:(NSString *)devicePwd {
    [self setImageWithUrl:url placeholderImage:placeholder aesKey:key deviceID:deviceID devicePwd:devicePwd toDisk:NO reload:NO progress:nil success:nil fail:nil];
}

- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk {
    [self setImageWithUrl:url placeholderImage:placeholder aesKey:key deviceID:deviceID devicePwd:devicePwd toDisk:toDisk reload:NO progress:nil success:nil fail:nil];
}

- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk success:(void (^)(void))success fail:(void (^)(LCError *error))fail {
    [self setImageWithUrl:url placeholderImage:placeholder aesKey:key deviceID:deviceID devicePwd:devicePwd toDisk:toDisk reload:NO progress:nil success:success fail:fail];
}

- (void)lc_setImageFromNetWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk success:(void (^)(void))success fail:(void (^)(LCError *error))fail {

     [self setImageWithUrl:url placeholderImage:placeholder aesKey:key deviceID:deviceID devicePwd:devicePwd toDisk:toDisk reload:YES progress:nil success:success fail:fail];
    
}

- (void)setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(void))success fail:(void (^)(LCError *error))fail {
    
    [self setImageWithUrl:url placeholderImage:placeholder aesKey:key deviceID:deviceID devicePwd:devicePwd toDisk:toDisk reload:NO progress:downloadProgress success:success fail:fail];
}


- (void)setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk reload:(BOOL)relaod progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(void))success fail:(void (^)(LCError *error))fail {
    
    //由于将gif格式image存储本地会有问题（加载慢、部分存入的是gif格式的image，但是取出的是静态image），故gif格式的存储data，取出也是data
    BOOL isGIF = [UIImage dh_isGIFFromUrl:url];
    
    [self cancelImageDownloadTask];
    
    //如果有缓存的话，就不设置placeHoder
    if (url == nil || url.length==0)
    {
        if (fail)
        {
            LCError *err = LCError.new;
            err.errorCode = [NSString stringWithFormat:@"%@",EC_IMAGE_URL_NONE];
            fail(err);
        }
        if (placeholder)
        {
            dispatch_main_async_safe(^{
                [self setImage:DH_IMAGENAMED(placeholder)];
            });
        }
        return ;
    }
    
    //防止URL中出现中文,如果有中文则转码
    NSString *validUrl = url;
    if (![NSURL URLWithString:url])
    {
        validUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    
    __block NSString *baseUrl = isGIF ? [[DHImageLoaderManager getImageCacheKey:validUrl] stringByAppendingString:@"Data"] : [DHImageLoaderManager getImageCacheKey:validUrl];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:baseUrl];
    NSData *cacheData = [[SDImageCache sharedImageCache] diskImageDataForKey:baseUrl];

    if (relaod) {
        //网上重新加载
        if (cacheImage != nil || cacheData != nil) {
            dispatch_main_async_safe(^{
                //加入cacheImage是gif格式时，但是UIImageView不需要支持gif的判断
                if (isGIF) {
                    self.image = [UIImage dh_imageAutoWithData:cacheData];
                } else {
                    self.image = !self.isNeedSupportGif && cacheImage.sd_isAnimated ? cacheImage.images[0] : cacheImage;
                }
            });
        } else {
            dispatch_main_async_safe(^{
                if (placeholder) {
                    self.image = DH_IMAGENAMED(placeholder);
                }
            });
        }
    } else {
        if (cacheImage != nil) {
            dispatch_main_async_safe(^{
                if (isGIF) {
                    self.image = [UIImage dh_imageAutoWithData:cacheData];
                } else {
                    self.image = !self.isNeedSupportGif && cacheImage.sd_isAnimated ? cacheImage.images[0] : cacheImage;
                }
                if (success) {
                    success();
                }
            });
            return;
        }
        
        dispatch_main_async_safe(^{
            if (placeholder) {
                self.image = DH_IMAGENAMED(placeholder);
            }
        });
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //图片之前已下载，但未解密成功
        if (key != nil) {
            NSString *path = [[SDImageCache sharedImageCache] cachePathForKey:baseUrl];
            //本地缓存数据
            NSData *cacheImageData = [NSData dataWithContentsOfFile:path];
            
            if (cacheImageData != nil) {
                LCError *encryptError;
                NSData *imageData = [self deCodeData:cacheImageData key:key deviceID:deviceID devicePWD:devicePwd error:&encryptError];
                if (encryptError == nil) {
                    UIImage *img = [UIImage dh_imageAutoWithData:imageData];
                    dispatch_main_async_safe(^{
						if (img) {
							self.image = img;
						}
						
                        if (success) {
                            success();
                        }
                    });
                    if (isGIF) {
                        [[SDImageCache sharedImageCache] storeImageDataToDisk:imageData forKey:baseUrl];
                    } else {
                        [[SDImageCache sharedImageCache] storeImage:img forKey:baseUrl toDisk:toDisk completion:nil];
                    }
                } else {
                    dispatch_main_async_safe(^{
                        if (fail) {
                            fail(encryptError);
                        }
                    });
                }
                return ;
            }
        }
        
        __weak typeof(self) weakSelf = self;
        
        //AF内部的block已在主线程中处理了
		[self getImageWithURLRequest:validUrl progress:^(NSProgress * progress) {
			if (downloadProgress) {
				downloadProgress(progress);
			}
		} success:^(NSHTTPURLResponse *response, NSData *data) {
			//需要在子线程中进行解密
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				//当key不为nil需要解密
				LCError *encryptError;
				NSData *imageData = key == nil ? data : [weakSelf deCodeData:data key:key deviceID:deviceID devicePWD:devicePwd error:&encryptError];
				dispatch_async(dispatch_get_main_queue(), ^{
					if (encryptError != nil) {
						//解密失败，存储未解密图片
						[[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:baseUrl];

						if (fail) {
							fail(encryptError);
						}
					} else {
						//不需要解密或者解密成功
						UIImage *img = [UIImage dh_imageAutoWithData:imageData];
						if (img != nil) {
							weakSelf.image = img;
							
							if (isGIF) {
								[[SDImageCache sharedImageCache] storeImageDataToDisk:imageData forKey:baseUrl];
							} else {
								 [[SDImageCache sharedImageCache] storeImage:weakSelf.image forKey:baseUrl toDisk:toDisk completion:nil];
							}
							
							if (success) {
								success();
							}
						} else {
							//图片不存在（即有URL，但地址为空）
							if (fail) {
								encryptError.errorCode = [NSString stringWithFormat:@"%@",EC_IMAGE_NOT_EXISTED];
								fail(encryptError);
							}
						}
					}
				});
			});
		} failure:^(NSError *error) {
			if (fail){
			   LCError *err = LCError.new;
			   err.errorCode = [NSString stringWithFormat:@"%@",EC_IMAGE_DOWNLOAD];
			   fail(err);
			}
		}];
	});
}

- (void)getImageWithURLRequest:(NSString *)url
                      progress:(void (^)(NSProgress *))downloadProgress
                       success:(void (^)(NSHTTPURLResponse *response, NSData *data))success
                       failure:(void (^)(NSError *error))failure
{
    if (url == nil)
    {
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    
    __weak __typeof(self)weakSelf = self;
    NSUUID *downloadID = [NSUUID UUID];
    __block AFImageDownloadReceipt *receipt;
    receipt = [[[self class] sharedImageDownloader]
               downloadImageForURLRequest:request
               withReceiptID:downloadID
               success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                   __strong __typeof(weakSelf)strongSelf = weakSelf;
                   if ([strongSelf.af_activeImageDownloadReceipt.receiptID isEqual:downloadID]) {
                       if (success) {
                           success(response,UIImagePNGRepresentation(responseObject));
                       }
                       
                       [strongSelf clearActiveDownloadInformation];
                   }
               }
               failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                   __strong __typeof(weakSelf)strongSelf = weakSelf;
                   if ([strongSelf.af_activeImageDownloadReceipt.receiptID isEqual:downloadID]) {
                       if (error.userInfo)
                       {
                           NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                           success(response,data);
                           [strongSelf clearActiveDownloadInformation];
                           return ;
                       }
                       
                       if (failure)
                       {
                           failure(error);
                       }
                       
                       [strongSelf clearActiveDownloadInformation];
                   }
                   
               }];
    
    self.af_activeImageDownloadReceipt = receipt;
}

#pragma mark - 图片解密

- (NSData *)deCodeData:(NSData *)data key:(NSString *)key deviceID:(NSString *)deviceId devicePWD:(NSString *)devicePwd error:(LCError **)err
{
    char header[4] = {0};
    [data getBytes:header length:4];
	//SMB Todo: 解密头判断？
    if (key != nil && memcmp(header,"DHAV",4) == 0 ) //&& memcmp(header,"DHAV",4) == 0
    {
        NSData *imageData;
        
        /// LCOpenSDK
        //NSInteger result = [[LCOpenSDK_Utils new] decryptPic:data deviceID:deviceId key:key token:self.accessToken bufOut:&imageData];
        // SMB: DTS000869908 TCM设备修改设备密码后云录像缩略图无法解密 外部传进来的key其实为acsKey,为空字符串,此处应该是设备密码
        NSInteger result = [[LCOpenSDK_Utils new] decryptPic:data deviceID:deviceId key:devicePwd token:self.accessToken bufOut:&imageData];
        
        if (result != 0) { 
            *err = LCError.new;
            if (result == 2) {
                (*err).errorCode = [NSString stringWithFormat:@"%@",EC_IMAGE_ENCRYPT_KEY_WRONG];
            } else {
                (*err).errorCode = [NSString stringWithFormat:@"%@",EC_IMAGE_ENCRYPT_FAIL];
            }
            NSLog(@"_🎈🎈🎈图片解密失败：%ld", (long)result);
        }else {
            NSLog(@"_😁😁😁图片解密成功：%ld", (long)result);
        }
        
        if (imageData == nil || [UIImage imageWithData:imageData] == nil) {
            *err = LCError.new;
            (*err).errorCode = [NSString stringWithFormat:@"%@",EC_IMAGE_ENCRYPT_FAIL];
        }
           
        return imageData;
    }
 
    return data;    //不需解密
}

- (void)lc_setEncryptImageWithUrl:(NSString *)url placeholder:(NSString *)placeholder isNewEncrypt:(BOOL)isNewEncrypt customKey:(NSString *)customKey defaultKey:(NSString *)defaultKey deviceID:(NSString *)deviceID toDisk:(BOOL)toDisk {
    [self lc_setEncryptImageWithUrl:url placeholder:placeholder isNewEncrypt:isNewEncrypt customKey:customKey defaultKey:defaultKey deviceID:deviceID toDisk:toDisk success:nil fail:nil];
}

- (void)lc_setEncryptImageWithUrl:(NSString *)url placeholder:(NSString *)placeholder isNewEncrypt:(BOOL)isNewEncrypt customKey:(NSString *)customKey defaultKey:(NSString *)defaultKey deviceID:(NSString *)deviceID toDisk:(BOOL)toDisk success:(void (^)(NSString *correctKey))success fail:(void (^)(LCError *error))fail
{
    //第一次尝试解密：如果customKey存在，则以customKey解密；不存在，则以defaultKey解密
    NSString *firstTryKey = customKey.length ? customKey : defaultKey;
    if (firstTryKey.length == 0) {
        NSLog(@"UIImageView+LeChange::DecryptKey can't be nil...");
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self setImageWithUrl:url placeholderImage:placeholder aesKey:isNewEncrypt ? @"" : firstTryKey deviceID:deviceID devicePwd:isNewEncrypt ? firstTryKey : @"" toDisk:toDisk progress:nil success:^{
        //直接传出成功
        if (success) {
            success(firstTryKey);
        }
        
    } fail:^(LCError *error){
        if (customKey.length == 0 && fail) {
            //直接传出错误
            fail(error);
            return;
        }
        
        //以自定义密码解失败后，再以默认密码去解
        if (defaultKey && ![firstTryKey isEqualToString:defaultKey]) {
            [weakSelf setImageWithUrl:url placeholderImage:placeholder aesKey:isNewEncrypt ? @"" : defaultKey deviceID:isNewEncrypt ? deviceID : @"" devicePwd:isNewEncrypt ? defaultKey : @"" toDisk:toDisk progress:nil success:^{
                if (success) {
                    success(defaultKey);
                }
            } fail:^(LCError *error){
                if (fail) {
                    fail(error);
                }
            }];
        }
    }];
}

- (void)lc_setEncryptImageWithUrl:(NSString *)url
                      placeholder:(NSString *)placeholder
                     isNewEncrypt:(BOOL)isNewEncrypt
                       errorImage:(NSString *)errorImage
                        customKey:(NSString *)customKey
                       defaultKey:(NSString *)defaultKey
                         deviceID:(NSString *)deviceID
                           toDisk:(BOOL)toDisk {
    [self lc_setEncryptImageWithUrl:url placeholder:placeholder isNewEncrypt:isNewEncrypt customKey:customKey defaultKey:defaultKey deviceID:deviceID toDisk:toDisk success:nil fail:^(LCError *error) {
		if (([error.errorCode integerValue] == EC_IMAGE_ENCRYPT_KEY_WRONG || [error.errorCode integerValue] == EC_IMAGE_ENCRYPT_FAIL) &&
			errorImage.length) {
			self.image = [UIImage imageNamed:errorImage];
		}
	}];
}

+ (void)lc_compressImageWithPath:(NSString *)filePath {
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    //图片压缩大小以宽度不超过200
    CGFloat factor = 400 / image.size.width;
    
    if (factor >= 1) {
        return;
    }
    
    CGSize size = CGSizeMake(image.size.width * factor, image.size.height * factor);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    [UIImagePNGRepresentation(compressedImage) writeToFile:filePath atomically:YES];
}

@end


@implementation UIImageView (_AFNetworking)

+ (AFImageDownloader *)sharedImageDownloader {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(sharedImageDownloader)) ?: [AFImageDownloader defaultInstance];
#pragma clang diagnostic pop
}


- (void)cancelImageDownloadTask {
    if (self.af_activeImageDownloadReceipt != nil) {
        [[self.class sharedImageDownloader] cancelTaskForImageDownloadReceipt:self.af_activeImageDownloadReceipt];
        [self clearActiveDownloadInformation];
    }
}

- (void)clearActiveDownloadInformation {
    self.af_activeImageDownloadReceipt = nil;
}

- (BOOL)isActiveTaskURLEqualToURL:(NSString *)url {
    return [self.af_activeImageDownloadReceipt.task.originalRequest.URL.absoluteString isEqualToString:url];
}

- (NSURLSessionDataTask *)af_URLSessionTask {
    return (NSURLSessionDataTask *)objc_getAssociatedObject(self, @selector(af_URLSessionTask));
}

- (void)af_setURLSessionTask:(NSURLSessionDataTask *)af_URLSessionTask {
    objc_setAssociatedObject(self, @selector(af_URLSessionTask), af_URLSessionTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AFHTTPSessionManager  *)sessionManager {
    static AFHTTPSessionManager *_af_defaultHTTPSessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_defaultHTTPSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _af_defaultHTTPSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _af_defaultHTTPSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(sessionManager)) ?: _af_defaultHTTPSessionManager;
#pragma clang diagnostic pop
}

- (AFImageDownloadReceipt *)af_activeImageDownloadReceipt {
    return (AFImageDownloadReceipt *)objc_getAssociatedObject(self, @selector(af_activeImageDownloadReceipt));
}

- (void)af_setActiveImageDownloadReceipt:(AFImageDownloadReceipt *)imageDownloadReceipt {
    objc_setAssociatedObject(self, @selector(af_activeImageDownloadReceipt), imageDownloadReceipt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

