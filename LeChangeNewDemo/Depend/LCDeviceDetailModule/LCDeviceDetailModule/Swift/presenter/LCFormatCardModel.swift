//
//  File.swift
//  LeChangeDemo
//
//  Created by WWB on 2022/9/29.
//  Copyright © 2022 Imou. All rights reserved.
//

import LCNetworkModule
import UIKit

@objcMembers class LCFormatCardModel {
    private let deviceId: String
    
    init(deviceId: String) {
        self.deviceId = deviceId
    }
    
    /// 设备状态查询
    /// - Parameters:
    ///   - success: 回调成功
    ///   - failure: 回调失败
    ///Device status query
    /// - Parameters:
    ///   - success: Callback success
    ///   - failure: Callback failed
    
    func stateCard(success: @escaping (String) -> (), failure:@escaping (LCError) -> ()) {
        LCDeviceHandleInterface.statusSDCard(forDevice: self.deviceId) { objc in
            success(objc)
            print("LocalStorage：",Date.init(),"\(#function)::查询状态成功:",objc)
        } failure: { error in
            print("LocalStorage：",Date.init(),"\(#function)::查询状态失败" + error.errorMessage)
        }
    }
    
    /// 请求格式化SD卡
    /// - Parameters:
    ///   - success: 回调成功
    ///   - failure: 回调失败
    ///  Request to initalize the SD card
    /// - Parameters:
    ///   - success: Callback success
    ///   - failure: Callback failed
    
    func recoverSDCard(success: @escaping (String) -> (), failure:@escaping (LCError) -> ()) {
        LCDeviceHandleInterface.recoverSDCard(forDevice: self.deviceId) { objc in //[weak self]
            success(objc)
            print("LocalStorage：",Date.init(),"\(#function)::开始格式化" + objc)
        } failure: { error in
            failure(error)
            print("LocalStorage：",Date.init(),"\(#function)::格式化失败:" + error.errorMessage)
        }
    }
    
    func useDeviceSdCardStatus() {
        deviceSDCardStatus() { status in
            
        } failure: { error in
            
        }
    }
    
    /// 查询设备格式化后SD卡状态
    /// - Parameters:
    ///   - success: 回调成功
    ///   - failure: 回调失败
    ///  Request to initalize the SD card
    /// - Parameters:
    ///   - success: Callback success
    ///   - failure: Callback failed
    
     func deviceSDCardStatus(success: @escaping (String) -> (), failure:@escaping (LCError) -> ()) {
        LCDeviceHandleInterface.statusSDCard(forDevice: self.deviceId) {objc in
            success(objc)
            print("LocalStorage：",Date.init(),"\(#function)::格式化后SD卡状态查询成功:" + objc)
        }failure: { error in
            print("LocalStorage：",Date.init(),"\(#function)::格式化后SD卡状态查询失败:" + error.errorMessage)
            failure(error)
        }
    }
    ///  获取SD卡介质容量信息
    /// - Parameters:
    ///   - success: 回调成功
    ///   - failure: 回调失败
    ///  Obtain device storage medium capacity information
    /// - Parameters:
    ///   - success: Callback success
    ///   - failure: Callback failed
    func deviceStorage(success: @escaping (Dictionary<AnyHashable, Any>) -> (), failure:@escaping (LCError) -> ()) {
        LCDeviceHandleInterface.queryMemorySDCard(forDevice: self.deviceId) { objc in //[self]
            success(objc)
            print("LocalStorage：",Date.init(),"\(#function)::进入格式化界面获取内存卡数据",objc)
        } failure: { error in
            print("LocalStorage：",Date.init(),"\(#function)::进入格式化界面获取内存卡数据失败" + error.errorMessage)
            LCProgressHUD.hideAllHuds(nil)
        }
    }
    
}



