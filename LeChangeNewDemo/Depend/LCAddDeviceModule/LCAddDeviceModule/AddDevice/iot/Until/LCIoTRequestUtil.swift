//
//  LCIoTRequestUtil.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/20.
//  Copyright © 2022 Imou. All rights reserved.
//


import AFNetworking
import MJExtension
import UIKit
import LCBaseModule
//import Categories

enum LCIoTRequestMethod: String {
    case getWifilist = "/things/v1/wireless/wifi/list"
    case setWifi = "/things/v1/wireless/wifi/set"
    case getDeviceInfo = "/things/v1/deviceinfo/get"
    case regserver = "/things/v1/dcs/cloud/regserver/conf" // iot设备 配置云平台注册地址
}

enum LCIoTWifiType: Int {
    case open = 0
    case SHARED = 1
    case WPA = 2
    case WPA_PSK = 3
    case WPA2 = 4
    case WPA2_PSK = 5
    case WPA_NONE = 6
    case WPA_PSK_WPA2_PSK = 7
    case WPA_WPA2 = 8
}

class LCIoTRequestUtil: AFHTTPSessionManager {
    var prfix: String = "http://"
    var host: String = "192.168.111.1" // 192.168.0.108
    var port: String = "13015" // 39000

    /// 超时时间
    var timeout: TimeInterval = 5.0 {
        didSet {
            requestSerializer.timeoutInterval = timeout
        }
    }

    static let sharedUtil: LCIoTRequestUtil = {
        let instance = LCIoTRequestUtil()
        instance.requestSerializer = AFJSONRequestSerializer()
        instance.responseSerializer = AFJSONResponseSerializer()
        instance.requestSerializer.timeoutInterval = 5
        // 设置请求头
        instance.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        instance.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return instance
    }()

    // MARK: - Post

    func post(method: LCIoTRequestMethod, params: Any?, timeout: TimeInterval = 5.0, success: ((_ result: Any?) -> Void)? = nil, failure: ((_ error: Error) -> Void)? = nil) {
        self.timeout = timeout
        let url = completeUrl(method: method)
        print(" \(Date()) \(NSStringFromClass(classForCoder))::post:\(url), params:\(String(describing: params))")
        
        var request = URLRequest(url: URL(string:url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if params != nil,let tempParam = params as? NSDictionary {
            let data = tempParam.mj_JSONData()
            request.httpBody = data
        }
        let dataSession: URLSession = URLSession.shared
        let dataTask = dataSession.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder))::\(error!)")
                failure?(error!)
            }else{
                print(" \(Date()) \(NSStringFromClass(self.classForCoder))::\(String(describing: data))")
                print(data!)
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let dic = json as! Dictionary<String, Any>
                    success?(dic)
                } catch _ {
                    success?(nil)
                }
                
            }
        }
        dataTask.resume()
        
//        post(url, parameters: params, headers: nil, progress: nil, success: { _, data in
//            print(" \(Date()) \(NSStringFromClass(self.classForCoder))::\(String(describing: data))")
//            print(data!)
//            success?(data)
//        }) { _, error in
//            print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder))::\(error)")
//            failure?(error)
//        }
    }

    /// 完整请求的url
    /// - Parameter method: 方法名称
    func completeUrl(method: LCIoTRequestMethod) -> String {
        //新方式：自动获取ip
//        LCAddDeviceManager.sharedInstance.deviceId = LCIoTAddDeviceManager.shareInstance.deviceBaseInfo.sn
//        let device = LCAddDeviceManager.sharedInstance.getLocalDevice()
        let deviceIp = NSString.getGatewayIpForCurrentWiFi() ?? ""
        //有序列号以扫描序列号作为标识获取ip地址，否则以固定IP为准
        if deviceIp.count > 0 {
            return prfix + deviceIp + ":" + port + method.rawValue
        } else {
            //使用当前wifi网关IP(@auth:110801, 自动获取IP有可能获取不到，导致软AP添加失败)
            let ip = UIDevice.lc_getGatewayIpForCurrentWiFi() ?? host
            return prfix + ip + ":" + port + method.rawValue
        }
        
    }
}

extension LCIoTRequestUtil {
    func regServer(success: ((_ result: Any?) -> Void)? = nil, failure: ((_ error: Error?) -> Void)? = nil) {
        // TODO: 下发的数据为login接口获取
        let dic = ["addr": "testaddr", "port": 8888] as [String: Any]
        post(method: .regserver, params: dic, timeout: 3, success: success, failure: failure)
    }
    
    /// 获取iot设备信息
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failure: 失败回调
    func getIoTDeviceBasic(success: ((_ result: LCIoTNetConfigBasicInfo?) -> Void)?, failure: ((_ error: Error?) -> Void)?) {
        post(method: .getDeviceInfo, params: nil, timeout: 3, success: { data in
            if let map = data as? Dictionary<String, Any> {
                let info = LCIoTNetConfigBasicInfo()
                info.pid = map["pid"] as! String
                info.sn = map["sn"] as! String
                info.token = map["token"] as? String
                info.serviceversion = map["serviceversion"] as? String
            } else {
                if failure != nil {
                    failure!(nil)
                }
            }
        }, failure: failure)
    }

    /// 给物联网设备配网
    /// - Parameters:
    ///   - ssid: ssid
    ///   - bssid: 主要用于区分重复的ssid
    ///   - password: 密码
    ///   - encryption:  加密方式, 枚举
    ///   - success: 成功回调
    ///   - failure: 失败回调
    func getIoTSetWifi(ssid: String, bssid: String?, password: String, encryption:LCIoTWifiType?=nil, success: ((_ result: Any?) -> Void)? = nil, failure: ((_ error: Error?) -> Void)? = nil) {
        let dic = ["SSID": ssid, "BSSID":ssid, "encryption": 5, "password": password] as [String: Any]
        post(method: .setWifi, params: dic, timeout: 3, success: success, failure: failure)
    }
}

