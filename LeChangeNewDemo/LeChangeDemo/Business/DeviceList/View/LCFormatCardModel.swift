//
//  File.swift
//  LeChangeDemo
//
//  Created by WWB on 2022/9/29.
//  Copyright © 2022 dahua. All rights reserved.
//

import LCNetworkModule
import UIKit

@objcMembers class LCFormatCardModel {
    
    lazy var timer: Timer = {
        let temp = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(useDeviceSdCardStatus), userInfo: nil, repeats: true)
        return temp
    }()
    func stateCard(deviceId: String, success: @escaping (String) -> (), failure:@escaping (LCError) -> ()) {
        LCDeviceHandleInterface.statusSDCard(forDevice: "7J0191AFACC608E") { objc in
            success(objc)
        } failure: { error in
            print("失败" + error.errorMessage)
        }
    }
    func recoverSDCard(deviceId: String, success: @escaping (String) -> (), failure:@escaping (LCError) -> ()) {
        LCDeviceHandleInterface.recoverSDCard(forDevice: "7J0191AFACC608E") { objc in //[weak self]
            if objc == "start-recover" {
                self.timer.fireDate = Date.init(timeIntervalSinceNow: 3.0)
            } else if objc == "sdcard-error" {
                self.timer.fireDate = Date.distantFuture
            } else if objc == "in-recover" {
                self.timer.fireDate = Date.init(timeIntervalSinceNow: 3.0)
            }
            success(objc)
        } failure: { error in
            print("失败" + error.errorMessage)
        }
    }
   
    func useDeviceSdCardStatus() {
        deviceSDCardStatus(deviceId: "7J0191AFACC608E") { status in
        } failure: { error in
        }
    }
    
     func deviceSDCardStatus(deviceId: String, success: @escaping (String) -> (), failure:@escaping (LCError) -> ()) {
        LCDeviceHandleInterface.statusSDCard(forDevice: deviceId) { [self] objc in
            if objc == "formatting" { //"formatting" {
                self.timer.fireDate = Date.init(timeIntervalSinceNow: 3.0)
            } else if objc == "normal" {  //"normal" {
                //返回成功状态显示二次格式化界面
                self.timer.fireDate = Date.distantFuture
            } else if objc == "abnormal" { //"abnormal"{
                self.timer.fireDate = Date.distantFuture
                //返回失败状态显示二次格式化界面
            }
            success(objc)
        }failure: { error in
            print("失败" + error.errorMessage)
            LCProgressHUD.hideAllHuds(nil)
            failure(error)
        }
    }
    
    func deviceStorage(deviceId: String, success: @escaping (Dictionary<AnyHashable, Any>) -> (), failure:@escaping (LCError) -> ()) {
        LCDeviceHandleInterface.queryMemorySDCard(forDevice: "7J0191AFACC608E") { objc in //[self]
            success(objc)
        } failure: { error in
            print("失败" + error.errorMessage)
            LCProgressHUD.hideAllHuds(nil)
        }
    }
    
}



