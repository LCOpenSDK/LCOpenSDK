//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import "UIDevice+LeChange.h"

#import <stdlib.h>
#import <stdio.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#include <sys/param.h>
#include <sys/mount.h>
#import <net/if.h>
#import <string.h>
#import <TargetConditionals.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <ifaddrs.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <resolv.h>
#import <dns.h>

#if TARGET_IPHONE_SIMULATOR && __IPHONE_OS_VERSION_MAX_ALLOWED < 110000
#import <net/route.h>
#elif TARGET_OS_IPHONE
#import "route.h"
#endif

#define ROUNDUP(a) \
((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))

@implementation UIDevice (LeChange)

+ (void)lc_setOrientation:(UIInterfaceOrientation)orientation
{
    //iOS10.3以上存在问题：设备方向与旋转的方向一致时，不会触发旋转；先旋转到状态栏方向来进行过度（TD32270）
    UIInterfaceOrientation deviceOri = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    UIInterfaceOrientation statusBarOri = [UIApplication sharedApplication].statusBarOrientation;
    if (deviceOri == orientation && statusBarOri != deviceOri) {
        [self private_setDeviceOrientation: statusBarOri];
    }
    
    [self private_setDeviceOrientation:orientation];
}

+ (void)private_setDeviceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}

+ (NSString *)lc_orientationDescprition:(UIInterfaceOrientation)orientation
{
    NSDictionary *dicDescription = @{@(UIInterfaceOrientationUnknown) : @"UIInterfaceOrientationUnknown",
                                     @(UIInterfaceOrientationPortrait) : @"UIInterfaceOrientationPortrait",
                                     @(UIInterfaceOrientationPortraitUpsideDown): @"UIInterfaceOrientationPortraitUpsideDown",
                                     @(UIInterfaceOrientationLandscapeLeft) : @"UIInterfaceOrientationLandscapeLeft",
                                     @(UIInterfaceOrientationLandscapeRight) : @"UIInterfaceOrientationLandscapeRight"};

    NSString *result = dicDescription[@(orientation)];
    return result ? : UIInterfaceOrientationUnknown;
}

+ (long long)lc_freeDiskSpaceInBytes
{
    
    struct statfs buf;
    
    long long freespace = -1;
    
    if(statfs("/var", &buf) >= 0)
    {
        
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
        
    }
    return freespace;
}

#pragma mark - ip mask gate dns

#pragma mark - 获取路由器地址
+ (NSString *)lc_getIPAddress
{
    NSString *address;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}



+ (NSString *)lc_getMaskAddress
{
    NSString *maskAddress = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    maskAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return maskAddress;
}


unsigned char * getdefaultgateway(in_addr_t * addr)
{
    unsigned char * octet=(unsigned char *)malloc(4);
#if 0
    /* net.route.0.inet.dump.0.0 ? */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_DUMP, 0, 0/*tableid*/};
#endif
    /* net.route.0.inet.flags.gateway */
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_FLAGS, RTF_GATEWAY};
    size_t l;
    char * buf, * p;
    struct rt_msghdr * rt;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i;
    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &l, 0, 0) < 0) {
        return octet;
    }
    if(l>0) {
        buf = (char *)malloc(l);
        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &l, 0, 0) < 0) {
            return octet;
        }
        for(p=buf; p<buf+l; p+=rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for(i=0; i<RTAX_MAX; i++) {
                if(rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if( ((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
               && sa_tab[RTAX_DST]->sa_family == AF_INET
               && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                
                
                for (int i=0; i<4; i++){
                    octet[i] = ( ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr >> (i*8) ) & 0xFF;
                }
                
            }
        }
        free(buf);
    }
    return octet;
}

+ (NSString *) lc_getRouterAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL)
        /*/
         int i=255;
         while((i--)>0)
         //*/
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    
    
    in_addr_t i =inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x =&i;
    
    
    unsigned char *s=getdefaultgateway(x);
    NSString *ip=[NSString stringWithFormat:@"%d.%d.%d.%d",s[0],s[1],s[2],s[3]];
    free(s);
    return ip;
}

//libresolv.dylib
+ (NSString *)lc_getDNSAddress
{
    NSString *dnsIP;
    res_state res = (res_state)malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    
    if ( result == 0 )
    {
        //for ( int i = 0; i < res->nscount; i++ )
        //{
        NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[0].sin_addr)];
        dnsIP = s;
        //    break;
        //}
    }
    else
    {
        NSLog(@"%@",@" res_init result != 0");
    }
    
    res_nclose(res);
    return dnsIP;
}

@end
