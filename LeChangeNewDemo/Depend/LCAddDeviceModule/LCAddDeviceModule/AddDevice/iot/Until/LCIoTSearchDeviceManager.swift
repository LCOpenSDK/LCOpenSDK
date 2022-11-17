//
//  LCIoTSearchDeviceManager.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/20.
//  Copyright © 2022 Imou. All rights reserved.
//

import MJExtension
import UIKit
import LCBaseModule

class LCIoTSearchDeviceManager: NSObject {
    typealias LCIoTSearchDeviceProgress = (_ currentTime: Int, _ isDeviceFound: Bool, _ wifiList: LCIoTNetConfigBasicInfo) -> Void
    typealias LCIoTSearchDeviceTimeout = () -> Void

    static let sharedInstance = LCIoTSearchDeviceManager()

    /// 是否在搜索中
    var isInSearching: Bool {
        return isStarted
    }

    /// 超时时间
    public var maxTime: Int = 30

    /// 当前计时时间
    public var currentTime: Int = 0

    /// 处理的间隔
    public var timeInterval: Int = 3

    /// 每秒的闭包
    private var progressBlock: LCIoTSearchDeviceProgress?

    /// 超时的闭包
    private var timeoutBlock: LCIoTSearchDeviceTimeout?

    /// 搜索设备定时器
    private var searchTimer: DispatchSourceTimer?

    /// 标记是否开始
    private var isStarted: Bool = false

    /// 标记是否找到设备
    private var isDeviceFound: Bool = false

    /// 标记是否在请求中
    private var isInRequesting: Bool = false

    /// WiFi列表
    private var wifiList: [LCApWifiInfo] = [LCApWifiInfo]()

    /// 从设备获取的设备基本信息
    private var deviceBaseInfo: LCIoTNetConfigBasicInfo = LCIoTNetConfigBasicInfo()

    // MARK: Deinit

    deinit {
        print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: dealloced...")
    }

    // MARK: - Timer Operation

    func startSearching(maxTime:Int? = 30,timeInterval:Int? = 3,progress: LCIoTSearchDeviceProgress?, timeout: LCIoTSearchDeviceTimeout?) {
        progressBlock = progress
        timeoutBlock = timeout
        self.maxTime = maxTime ?? 30
        self.timeInterval = timeInterval ?? 3
        startTimer(reset: true, progress: progress, timeout: timeout)
    }

    public func stopSearching() {
        searchTimer?.cancel()
        isStarted = false
        isDeviceFound = false
        isInRequesting = false
    }

    public func pauseSearching() {
        searchTimer?.cancel()
        isStarted = false
    }

    public func resumeSearching() {
        startTimer(reset: false, progress: progressBlock, timeout: timeoutBlock)
    }

    private func timeoutProcess() {
        timeoutBlock?()
        stopSearching()
    }
}

extension LCIoTSearchDeviceManager {
    
    private func startTimer(reset: Bool, progress: LCIoTSearchDeviceProgress?, timeout: LCIoTSearchDeviceTimeout?) {
        if isStarted == true {
            return
        }

        isStarted = true

        // 重置后清空保存的列表
        if reset {
            wifiList.removeAll()
        }

        // 重置或者超时后，重新开启
        if reset || currentTime > maxTime {
            currentTime = 0
        }

        searchTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        searchTimer?.schedule(wallDeadline: .now(), repeating: TimeInterval(timeInterval), leeway: .microseconds(50))
        searchTimer?.setEventHandler {
            if self.isStarted, Int(self.currentTime) >= self.maxTime {
                self.timeoutProcess()
                return
            }

            
            self.postGetDeviceInfo()

            // 传出时间
            if self.currentTime <= self.maxTime {
                self.progressBlock?(self.currentTime, self.isDeviceFound, self.deviceBaseInfo)
            }

            self.currentTime += self.timeInterval
        }

        searchTimer?.resume()
    }

    // MARK: 发送请求获取设备信息
    func postGetDeviceInfo() {
        if isDeviceFound || isInRequesting {
            return
        }

        isInRequesting = true
        LCIoTRequestUtil.sharedUtil.post(method: .getDeviceInfo, params: nil, success: { responseObject in
            // data转json
            if let data = responseObject as? [String: Any] {
                // 避免多次重复回调
                if self.isDeviceFound, self.isStarted {
                    return
                }
                //未启动时，不进行回调
                if !self.isStarted {
                    return
                }
                print("🍎🍎🍎获取IoT设备信息成功")
                print(data)
                self.deviceBaseInfo.sn = data["sn"] as! String
                self.deviceBaseInfo.pid = data["pid"] as! String
                self.deviceBaseInfo.token = data["token"] as? String
                self.deviceBaseInfo.serviceversion = data["serviceversion"] as? String
                self.isDeviceFound = true
                // 找到设备获取到信息后，立马回调、停止计时
                self.stopSearching()
                self.progressBlock?(self.currentTime,true, self.deviceBaseInfo)
            }

            self.isInRequesting = false
        }) { _ in
            self.isInRequesting = false
            print("❌获取IoT设备信息超时")
        }
    }
    
    func postWiFiInfo(ssid: String, bssid: String, password: String, encryption:LCIoTWifiType?=nil, success: ((_ result: Any?) -> Void)?=nil, failure: ((_ error: Error?) -> Void)?=nil) {
        if self.deviceBaseInfo.serviceversion ?? "" > "V1.3.0" {
            LCIoTRequestUtil.sharedUtil.regServer { result in
                LCProgressHUD.showMsg("iot注册地址下发成功")
                LCIoTRequestUtil.sharedUtil.getIoTSetWifi(ssid: ssid, bssid: bssid, password: password, encryption: encryption, success: success, failure: failure)

            } failure: { error in
                LCProgressHUD.showMsg("iot注册地址下发失败")
                LCIoTRequestUtil.sharedUtil.getIoTSetWifi(ssid: ssid, bssid: bssid, password: password, encryption: encryption, success: success, failure: failure)

            }
        } else {
            LCIoTRequestUtil.sharedUtil.getIoTSetWifi(ssid: ssid, bssid: bssid, password: password, encryption: encryption, success: success, failure: failure)
        }
    }
}
