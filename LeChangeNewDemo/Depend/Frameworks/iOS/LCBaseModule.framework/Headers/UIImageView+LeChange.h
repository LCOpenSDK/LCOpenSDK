//
//  Copyright © 2015 Imou. All rights reserved.
//
//  UIImageView扩展，主要用于UIImageView的图片网络加载。

#import <UIKit/UIKit.h>

@class AFImageDownloadReceipt;
@class AFHTTPSessionManager;
@class AFImageDownloader;
@class LCError;

@interface UIImageView(LeChange)

/**
 *  是否需要支持gif
 */
@property(nonatomic, assign, readwrite) BOOL isNeedSupportGif;

/// 图片解密需要的token
@property(nonatomic, copy, readwrite) NSString *accessToken;

/**
 *  @brief  将图片存储到硬盘
 *
 *  @param image    图片
 *  @param imageUrl 存储地址
 */
- (void)lc_storeImageToDisk:(UIImage*)image url:(NSString *)imageUrl;

/**
 *  加载缓存图片
 *
 *  @param imageUrl 图片URL
 *
 *  @return UIImage 图片
 */
- (UIImage *)lc_getImageWithCache:(NSString *)imageUrl;

/**
 *  加载加密的网络图片,不存入硬盘
 *
 */
- (void)lc_setImageWithUrl:(NSString *)url;

/**
 *  加载加密的网络图片,不存入硬盘
 *
 */
- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder;

/**
 *  加载加密的网络图片
 *
 *  @param url 图片url
 *  @param key 密钥
 *  @param deviceID     设备序列号
 *  @param productID    iot型号
 *  @param toDisk 是否将图片存在disk文件中
 */
- (void)lc_setImageWithUrl:(NSString *)url aesKey:(NSString *)key deviceID:(NSString *)deviceID productID:(NSString *)productID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk;

/**
 *  加载网络图片
 *
 *  @param url 图片url
 */
- (void)lc_setImageWithUrl:(NSString *)url toDisk:(BOOL)toDisk;

/**
 *  加载网络图片
 *
 *  @param url         图片url
 *  @param placeholder 默认图片名称
 *  @param toDisk 是否将图片存在disk文件中
 */
- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder toDisk:(BOOL)toDisk;

/**
 加载加密的网络图片，不保存在disk中

 @param url 图片url
 @param placeholder 默认图片名称
 @param key 密钥
 @param deviceID     设备序列号
 @param productID    iot型号
 */
- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID productID:(NSString *)productID devicePwd:(NSString *)devicePwd;

/**
 *  加载加密的网络图片
 *
 *  @param url         图片url
 *  @param placeholder 默认图片名称
 *  @param key         密钥
 *  @param deviceID     设备序列号
 *  @param productID    iot型号
 *  @param toDisk      是否将图片存在disk文件中
 */
- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID productID:(NSString *)productID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk;

/**
 *  加载加密的网络图片
 *
 *  @param url         图片url
 *  @param placeholder 默认图片名称
 *  @param key         密钥
 *  @param deviceID     设备序列号
 *  @param productID    iot型号
 *  @param toDisk      是否将图片存在disk文件中
 *  @param success     加载成功回调
 *  @param fail        加载失败回调
 */
- (void)lc_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID productID:(NSString *)productID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk success:(void (^)(void))success fail:(void (^)(LCError *error))fail;

/**
 *  加载加密的网络图片,即使有缓存也需要从网络加载图片
 *
 *  @param url         图片url
 *  @param placeholder 默认图片名称
 *  @param key         密钥
 *  @param deviceID     设备序列号
 *  @param productID    iot型号
 *  @param toDisk      是否将图片存在disk文件中
 *  @param success     加载成功回调
 *  @param fail        加载失败回调
 */
- (void)lc_setImageFromNetWithUrl:(NSString *)url placeholderImage:(NSString *)placeholder aesKey:(NSString *)key deviceID:(NSString *)deviceID productID:(NSString *)productID devicePwd:(NSString *)devicePwd toDisk:(BOOL)toDisk success:(void (^)(void))success fail:(void (^)(LCError *error))fail;

/**
 *  先以customKey进行解密图片，如果密码不匹配，再以默认的defaultKey（一股设置为设备序列号）进行解密；如果 customKey为空，直接以defaultKey解密
 *
 *  @param url          图片url
 *  @param placeholder  默认图片
 *  @param isNewEncrypt 是否是新加密方式(三码合一)
 *  @param customKey    自定义key
 *  @param defaultKey   默认key，为设备序列号
 *  @param deviceID     设备序列号
 *  @param productID    iot型号
 *  @param toDisk       是否保存到硬盘
 *  @param success      成功的回调
 *  @param fail         失败的回调
 */
- (void)lc_setEncryptImageWithUrl:(NSString *)url placeholder:(NSString *)placeholder isNewEncrypt:(BOOL)isNewEncrypt customKey:(NSString *)customKey defaultKey:(NSString *)defaultKey deviceID:(NSString *)deviceID productID:(NSString *)productID toDisk:(BOOL)toDisk success:(void (^)(NSString *correctKey))success fail:(void (^)(LCError *error))fail;

/**
 加载图片

 @param url 图片地址
 @param placeholder  默认图片
 @param isNewEncrypt 是否是新加密方式(三码合一)
 @param customKey    自定义秘钥
 @param defaultKey   默认秘钥
 @param deviceID     设备序列号
 @param productID    iot型号
 @param toDisk       是否存储到硬盘
 */
- (void)lc_setEncryptImageWithUrl:(NSString *)url placeholder:(NSString *)placeholder isNewEncrypt:(BOOL)isNewEncrypt customKey:(NSString *)customKey defaultKey:(NSString *)defaultKey deviceID:(NSString *)deviceID productID:(NSString *)productID toDisk:(BOOL)toDisk;

/**
 加载图片

 @param url 图片地址
 @param placeholder 默认图片
 @param isNewEncrypt 是否是新加密方式(三码合一)
 @param errorImage 解密失败的图片
 @param customKey 自定义密码
 @param defaultKey 默认密码
 @param deviceID   设备序列号
 @param productID    iot型号
 @param toDisk 是否存储到硬盘
 */
- (void)lc_setEncryptImageWithUrl:(NSString *)url
					  placeholder:(NSString *)placeholder
                     isNewEncrypt:(BOOL)isNewEncrypt
					   errorImage:(NSString *)errorImage
						customKey:(NSString *)customKey
					   defaultKey:(NSString *)defaultKey
                         deviceID:(NSString *)deviceID
                        productID:(NSString *)productID
						   toDisk:(BOOL)toDisk;

/**
 压缩图片

 @param filePath 图片地址
 */
+ (void)lc_compressImageWithPath:(NSString *)filePath;

@end


#pragma mark - UIImageView(_Helper)

@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setActiveImageDownloadReceipt:) AFImageDownloadReceipt *af_activeImageDownloadReceipt;

@property (readwrite, nonatomic, strong, setter = af_setURLSessionTask:) NSURLSessionDataTask *af_URLSessionTask;

+ (AFImageDownloader *)sharedImageDownloader;

- (void)cancelImageDownloadTask;

- (void)clearActiveDownloadInformation;

- (BOOL)isActiveTaskURLEqualToURL:(NSString *)url;

- (NSURLSessionDataTask *)af_URLSessionTask;

- (AFHTTPSessionManager *)sessionManager;

@end

