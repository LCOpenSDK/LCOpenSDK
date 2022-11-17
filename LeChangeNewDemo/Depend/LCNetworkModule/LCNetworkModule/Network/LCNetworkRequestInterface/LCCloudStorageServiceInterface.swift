//
//  LCCloudStorageServiceInterface.swift
//  LCNetworkModule
//
//  Created by yyg on 2022/9/24.
//  Copyright © 2022 jm. All rights reserved.
//

import Foundation

class LCCloudStorageServiceInterface {
    
    func getCloudStorageInfo(deviceId: String, channelId: String, token: String) {
        LCNetworkRequestManager().lc_POST("", parameters: ["":""]) { response in
            
        } failure: { error in
            
        }

    }
    
    
//    + (void)setDeviceSnapEnhancedWithDevice:(NSString *)deviceId Channel:(NSString *)channelId success:(void (^)(NSString *picUrlString))success
//                                    failure:(void (^)(LCError *error))failure {
//        [[LCNetworkRequestManager manager] lc_POST:@"/setDeviceSnapEnhanced" parameters:@{ KEY_DEVICE_ID: deviceId, KEY_CHANNEL_ID: channelId } success:^(id _Nonnull objc) {
//            NSDictionary *dic = objc;
//            if ([dic objectForKey:KEY_URL] && success) {
//                success(dic[KEY_URL]);
//            } else {
//                //需要处理URL为空情况
//                success(@"");
//            }
//        } failure:^(LCError *error) {
//            //开发者应自行处理错误
//            failure(error);
//        }];
//    }
}
