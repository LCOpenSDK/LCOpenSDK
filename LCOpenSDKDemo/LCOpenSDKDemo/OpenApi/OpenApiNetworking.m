//
//  OpenApiNetworking.m
//  LCOpenSDKDemo
//
//  Created by bzy on 17/3/21.
//  Copyright © 2017年 lechange. All rights reserved.
//

#import "OpenApiNetworking.h"

typedef NSString* (^CallBack)(void);
@interface OpenApiNetworking ()
<
NSURLConnectionDataDelegate,
NSURLConnectionDelegate
>

@property (nonatomic, strong) dispatch_semaphore_t sema;
@property (nonatomic, copy)  NSString *resp;
@end

@implementation OpenApiNetworking

static OpenApiNetworking* _instance = nil;
+ (instancetype)shareMyInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [OpenApiNetworking shareMyInstance];
}

- (id)copy {
     return [OpenApiNetworking shareMyInstance];
}

- (id)mutableCopy {
    return [OpenApiNetworking shareMyInstance];
}

- (NSString *)requestByPost:(NSString*)url params:(NSString*)params
{
    _resp = nil;
    NSLog(@"%@", params);
    NSURL *nsURL =[NSURL URLWithString:url];
    /**
     Ch:创建请求对象
     En:Create request object
     */
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:nsURL];
    /**
    Ch:创建请求方式
    En:Create request method
    */
    [request setHTTPMethod:@"post"];
    /**
    Ch:设置请求参数
    En:Set request parameters
    */
    NSData *tempData = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:tempData];
    [request setTimeoutInterval:10.0];
    /**
    Ch:创建连接对象
    En:Create connection object
    */
    NSURLConnection *Connection = [[NSURLConnection alloc] initWithRequest:request delegate:self  startImmediately:NO];
    /**
    Ch:设置回调队列
    En:Set up callback queue
    */
    [Connection setDelegateQueue:[NSOperationQueue mainQueue]];
    /**
    Ch:开始请求(异步转化为同步)
    En:Start request (asynchronous to synchronous)
    */
    _sema = dispatch_semaphore_create(0);
    [Connection start];
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    
    return _resp;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_resp) {
         _resp = [NSString stringWithFormat:@"%@%@", _resp, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    }
    else {
         _resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
   
    NSLog(@"%@", _resp);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    dispatch_semaphore_signal(_sema);
}

/**
 Ch:服务器的数据接收完毕
 En:Server data received
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dispatch_semaphore_signal(_sema);
}
/**
Ch:取消证书验证
En:Cancel certificate verification
*/
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)cancelRequest {
    dispatch_semaphore_signal(_sema);
}

@end
