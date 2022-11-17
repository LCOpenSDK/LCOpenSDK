//
//  LCSoftAPConfigHelper.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/20.
//  Copyright © 2022 Imou. All rights reserved.
//

import Foundation
import LCBaseModule
import UIKit

public class LCSoftAPConfigHelper: NSObject {
    var isInRequest = false
    
    //定义
    public typealias ConfigBlock = (_ success: Bool)->Void
    
    //声明
    var configBlock: ConfigBlock?
    
    override public init() {
        super.init()
    }
    
    func startNetworkConfig(configBlock: @escaping ConfigBlock) {
        // 监听从wifi列表页返回app
        NotificationCenter.default.addObserver(self, selector: #selector(appBackForeground(notification:)), name: .UIApplicationWillEnterForeground, object: nil)
        self.configBlock = configBlock
        LCProgressHUD.show(on: UIViewController.lc_top().view)
        LCAddDeviceManager.sharedInstance.autoConnectHotSpot(wifiName:("DAP-" + LCAddDeviceManager.sharedInstance.deviceId), password: LCAddDeviceManager.sharedInstance.initialPassword) { success in
            if success {
                // 自动连接成功
                self.appBackForeground(notification: Notification.init(name: .UIApplicationWillEnterForeground, object: nil, userInfo: nil))
            } else {
                LCProgressHUD.hideAllHuds(UIViewController.lc_top().view)
                LCProgressHUD.showMsg("add_device_softap_connect_device_hotspot_fail".lc_T)
            }
        }
    }
    
    func checkStatus() {
        // 检查发送状态，如果3秒内还可以收到信息表示WIFI信息发送失败，重新发送信息，如果收不到则表示信息发送成功
        LCIoTSearchDeviceManager.sharedInstance.startSearching(maxTime:10, timeInterval: 3, progress: { _, isFind, _ in
            if isFind == true {
                print("❌❌❌，已发送WiFi信息，但仍未断开网络连接，需要再次发送配网信息")
                LCIoTSearchDeviceManager.sharedInstance.stopSearching()
                self.sendWiFiInfo()
            } else {
                self.isInRequest = false
                LCIoTSearchDeviceManager.sharedInstance.stopSearching()
                LCProgressHUD.hideAllHuds(UIViewController.lc_top().view)
                NotificationCenter.default.removeObserver(self)
                
//                LCDeviceAddEngine.shared.dealConnectProcess()
                self.configBlock!(true)
            }
        }) {
            self.isInRequest = false
            
            DispatchQueue.main.async {
                /// 搜索设备失败, tost提示
                LCProgressHUD.hideAllHuds(UIViewController.lc_top().view)
                self.configBlock!(false)
            }
        }
    }
    
    func sendWiFiInfo() {
        LCIoTSearchDeviceManager.sharedInstance.postWiFiInfo(ssid: LCAddDeviceManager.sharedInstance.wifiSSID ?? "", bssid: LCNetWorkHelper.sharedInstance().lc_lastWifiName, password: LCAddDeviceManager.sharedInstance.wifiPassword ?? "", success: nil, failure: nil)
        checkStatus()
    }
}

extension LCSoftAPConfigHelper {
    @objc func appBackForeground(notification: Notification) {
        // 确保当前页面是引导页，才进行获取信息操作
        if UIViewController.lc_top().isKind(of: LCSoftApConfigViewController.self) == false {
            LCProgressHUD.hideAllHuds(UIViewController.lc_top().view)
            return
        }
        
        if isInRequest {
            return
        }
        isInRequest = true

        LCProgressHUD.show(on: UIViewController.lc_top().view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            LCIoTSearchDeviceManager.sharedInstance.startSearching(maxTime: 30, timeInterval: 3, progress: { _, isFind, info in
                if isFind == true {
                    //兼容老的无sn的iot设备
//                    if LCIoTAddDeviceManager.shareInstance.deviceBaseInfo.sn == "" {
//                        LCIoTAddDeviceManager.shareInstance.deviceBaseInfo = info
//                    }
//                    LCDeviceAddEngine.shared.engineConfig.token = info.token
//                    LCDeviceAddEngine.shared.engineConfig.sn = info.sn
                    self.sendWiFiInfo()
                    
                }
            }) {
                self.isInRequest = false
                self.configBlock!(false)
                DispatchQueue.main.async {
                    /// 搜索设备失败, tost提示
                    LCProgressHUD.hideAllHuds(UIViewController.lc_top().view)
                    LCProgressHUD.showMsg("add_device_softap_connect_device_hotspot_fail".lc_T)
                }
            }
        }
    }
}
