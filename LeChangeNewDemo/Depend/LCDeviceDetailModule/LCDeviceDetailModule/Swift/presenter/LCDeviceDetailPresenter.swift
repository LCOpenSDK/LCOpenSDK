//
//  LCDeviceDetailPresenter.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/20.
//  Copyright © 2022 Imou. All rights reserved.
//

import Foundation
import LCBaseModule
import LCNetworkModule
import LCMediaBaseModule
import LCAddDeviceModule

@objcMembers public class LCDeviceDetailPresenter: NSObject {
    public weak var viewController: LCDeviceDetailVC? {
        didSet {
            self.adapter.tableview = self.viewController?.tableView
        }
    }
    
    private var versionInfo: LCDeviceVersionInfo?

    var deviceInfo: LCDeviceInfo

    var updateCheckTimer: Timer?
    
    var selectedChannelId: String
    
    var selectedChannelInfo: LCChannelInfo?
    
    lazy var adapter: LCDeviceDetailTableViewAdapter = {
        let adapter = LCDeviceDetailTableViewAdapter(isMultipleChannels: self.isMultipleChannels(), deviceInfo: self.deviceInfo, selectedChannelId: self.selectedChannelId, presenter: self)
        return adapter
    }()
    
    public init(deviceInfo: LCDeviceInfo, selectedChannelId: String) {
        self.deviceInfo = deviceInfo
        self.selectedChannelId = selectedChannelId
        super.init()
        self.addNotification()
    }


    
    /// 判断是否为多通道设备
    /// - Returns: 是或否
    /// Determine whether it is  a multi-channel device
    /// - Returns: true or false
    func isMultipleChannels() -> Bool {
        if self.deviceInfo.channelNum.intValue() > 1 && self.deviceInfo.multiFlag == false {
            return true
        }
        
        return false
    }
    
    /// 修改设备名称
    /// - Parameter name: 设备名称
    /// Modify device name
    /// - Parameter name: Device name
    func modifyDeviceNme(name: String) {
        LCProgressHUD.show(on: nil)
        // 单通道设备: 国内，同步修改通道名称; 海外，只修改设备名称
        // 多通道通道名称修改：[TODO]预览显示不正确
        // 多通道设备名称修改:
        
        //Single-channel device: domestic, modify the channel name simultaneously; Overseas, only the device name is modified
        //Multi-channel channel name change: [TODO] The preview display is incorrect
        //Multi-channel device name modification:
        var channelId = "0"
        let channelNum = self.deviceInfo.channelNum.intValue()
        if self.selectedChannelId.intValue() != -1 {
            channelId = self.selectedChannelInfo?.channelId ?? "0"
        }
        
        LCDeviceManagerInterface.modifyDevice(forDevice: self.deviceInfo.deviceId, productId: self.deviceInfo.productId, channel: channelId, newName:name.vaildDeviceName()) { [weak self] in
            //单通道
            //Single-channel
            if channelNum == 1 {
                self?.deviceInfo.name = name
                self?.selectedChannelInfo?.channelName = name
            } else {
//                if self?.isMultipleChannels() == true {
//                    self?.selectedChannelInfo?.channelName = name
//                } else {
                    self?.deviceInfo.name = name
//                }
            }
            self?.viewController?.navigationController?.popViewController(animated: true)
            LCProgressHUD.hideAllHuds(nil)
            LCProgressHUD.showMsg("livepreview_localization_success".lc_T)
        } failure: { error in
            LCProgressHUD.hideAllHuds(nil)
            LCProgressHUD.showMsg(error.errorCode + "," + error.errorMessage)
        }
        print("\(NSStringFromClass(LCDeviceDetailPresenter.self))::更改设备名称",self.deviceInfo.name)
    }

    
    /// 删除设备
    /// Delete device
    func deleteDevice() {
        LCProgressHUD.show(on: nil)
        LCDeviceManagerInterface.unBindDevice(withDevice: self.deviceInfo.deviceId, productId: self.deviceInfo.productId) {
            //删除成功后返回设备列表
            //After the deletion is successful, the device list is displayed
            print("DeleteDevice：",Date.init(),"\(#function)::删除设备成功",self.deviceInfo.deviceId)
            LCProgressHUD.hideAllHuds(nil)
            var vc: UIViewController?
            self.viewController?.navigationController?.viewControllers.forEach({ viewcontroller in
                let classDes = viewcontroller.classForCoder.description()
                if classDes.contains("LCDeviceListViewController") == true {
                    vc = viewcontroller
                }
            })
            if vc != nil {
                self.viewController?.navigationController?.popToViewController(vc!, animated: true)
            } else {
                self.viewController?.navigationController?.popViewController(animated: true)
            }
            LCProgressHUD.showMsg("device_delete_success".lc_T)
            //删除本地的截图
            //Example Delete local snapshots
            UIImageView.lc_deleteThumbImage(withDeviceId: self.deviceInfo.deviceId, channelId: self.selectedChannelId)
        } failure: { error in
            LCProgressHUD.hideAllHuds(nil)
            // 乐橙设备无权限时默认成功
            if self.deviceInfo.brand == "lechange" && error.errorCode == "OP1009" {
                print("DeleteDevice：",Date.init(),"乐橙设备 \(#function)::删除设备成功",self.deviceInfo.deviceId)
                self.viewController?.navigationController?.popViewController(animated: true)
                LCProgressHUD.showMsg("device_delete_success".lc_T)
            } else {
                print("DeleteDevice：",Date.init(),"\(#function)::删除设备失败",self.deviceInfo.deviceId)
                LCProgressHUD.showMsg(error.errorCode + "," + error.errorMessage)
            }
        }
    }
    
    ///更新设备链接WIFI名称
    ///Update deviec connect  WIFI name
    func updateDeviceConnectWifiName() {
        LCDeviceHandleInterface.wifiAroundDevice(self.deviceInfo.deviceId, success: {[weak self] (wifiInfo) in
            if wifiInfo.enable {
                for wifiInfo in wifiInfo.wLan {
                    if Int(wifiInfo.linkStatus.rawValue) == 2 {
                        let indexPath = self?.adapter.updateDeviceConnectWifi(name: wifiInfo.ssid) ?? IndexPath(row: 0, section: 0)
                        self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
                        print("NetworkSettings：",Date.init(),"\(#function)::更新设备WiFi名称",wifiInfo.ssid)
                    }
                }
            }
        }) { (error) in
            print("NetworkSettings：",Date.init(),"\(#function)::更新设备WiFi名称失败 wifiAroundDevice error",error.description)
            //print("wifiAroundDevice error" + error.description)
        }
    }
    
    
    /// 查询云存储状态
    /// Query cloud Storage status
    func queryCloudStorageStatue() {
        LCDeviceHandleInterface.getDeviceCloud(self.deviceInfo.deviceId, channelId: self.selectedChannelId) {[weak self] isOpen in
            let indexPath = self?.adapter.updateCloudStorageStatus(isOpen: isOpen, isLoading: false) ?? IndexPath(row: 0, section: 0)
            self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
            print("CloudStorage",Date.init(),"\(#function)::查询云存储开关",isOpen)
        } failure: {[weak self] error in
            let indexPath = self?.adapter.updateCloudStorageStatus(isOpen: false, isLoading: false) ?? IndexPath(row: 0, section: 0)
            self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
            print("CloudStorage",Date.init(),"\(#function)::查询云存储开关失败")
        }
    }
    
    /// 更改云存储状态
    /// - Parameter isOpen: 开或关
    /// Set cloud storage
    /// - Parameter isOpen: true or false
    func setCloudStorage(isOpen: Bool) {
        LCDeviceHandleInterface.setAllStorageStrategy(self.deviceInfo.deviceId, channelId: self.selectedChannelId, isOpen: isOpen) { [weak self] in
            let indexPath = self?.adapter.updateCloudStorageStatus(isOpen: isOpen, isLoading: false) ?? IndexPath(row: 0, section: 0)
            self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
            print("CloudStorage:",Date.init(),"\(#function)::更新云存储开关",isOpen)
        } failure: {[weak self] error in
            let indexPath = self?.adapter.updateCloudStorageStatus(isOpen: false, isLoading: false) ?? IndexPath(row: 0, section: 0)
            self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
            
            LCProgressHUD.showMsg(error.errorCode + "," + error.errorMessage)
        }

    }
    
    
    /// 查询SD卡转态和存储
    /// Query SD card status and storage
    func querySDCardStatusAndStorage() {
        LCDeviceHandleInterface.statusSDCard(forDevice: self.deviceInfo.deviceId) { status in
            // 存储卡状态，empty：无SD卡，normal：正常，abnormal：异常，recovering：格式化中
            if status == "normal" || status == "recovering" || status == "empty"  {
             // 请求卡容量
                LCDeviceHandleInterface.queryMemorySDCard(forDevice: self.deviceInfo.deviceId) {[weak self] storage in
                    // totalBytes    Long    总容量，单位为Byte
                    // usedBytes    Long    已使用容量，单位为Byte
                    let total = storage["totalBytes"] as? Int64 ?? 0
                    let used = storage["usedBytes"] as? Int64 ?? 0
                    let indexPath = self?.adapter.updateLocalStorageStatus(status: status, total: total, used: used) ?? IndexPath(row: 0, section: 0)
                    self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
                    print("DeviceDetailsPage：",Date.init(),"\(#function)::更新SD卡内存数据","total:",total,"used:",used)
                } failure: { error in
                    print(error.errorMessage)
                }
            } else if status == "abnormal" {
                let indexPath = self.adapter.updateLocalStorageStatus(status: status, total: 0, used: 0)
                self.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
            }
        } failure: { error in
            print(error.errorMessage)
        }
    }
    
    /// 本地存储改变
    /// - Parameter notification: 消息通知
    ///Loca storage change
    /// - Parameter notification: notification description
    func localStorageChange(notification: Notification) {
        let userinfo = notification.userInfo
        let total = userinfo?["totalBytes"] as? Int64 ?? 0
        let used = userinfo?["usedBytes"] as? Int64 ?? 0
        let status = userinfo?["status"] ?? "normal"
        let indexPath = self.adapter.updateLocalStorageStatus(status: status as! String, total: total, used: used)
        self.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    /// 更改WIFI
    /// - Parameter notification: 通知消息
    /// Change the wifi
    /// - Parameter notification: notification description
    func wifiChange(notification: Notification) {
        let userinfo = notification.userInfo
        let ssid: String = userinfo?["ssid"] as? String ?? ""
        let indexPath = self.adapter.updateDeviceConnectWifi(name: ssid)
        self.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func deviceNameChanged(notification: Notification) {
        let userinfo = notification.userInfo
        let oldName: String = userinfo?["oldName"] as? String ?? ""
        let newName: String = userinfo?["newName"] as? String ?? ""
        let indexPath = self.adapter.updateDeviceName(oldName: oldName, newName: newName)
        self.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    /// 添加通知
    /// Add Notificiton
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(localStorageChange(notification:)), name: NSNotification.Name(rawValue: SMBNotificationDeviceSDCardUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wifiChange(notification:)), name: NSNotification.Name(rawValue: SMBNotificationDeviceWiFiUpdateSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceNameChanged(notification:)), name: NSNotification.Name(rawValue: SMBNotificationDeviceRenameSuccess), object: nil)
    }

    
    /// 删除通知
    /// Remove Notification
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SMBNotificationDeviceSDCardUpdate), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SMBNotificationDeviceWiFiUpdateSuccess), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:SMBNotificationDeviceRenameSuccess), object: nil)
    }
    
    deinit {
        self.removeNotification()
    }
}

extension LCDeviceDetailPresenter {
    
    /// 跳转设置设备详情
    /// - Parameters:
    ///   - deviceInfo: 设备信息
    ///   - channelId: 通道iD
    /// Push to device setting device detail
    /// - Parameters:
    ///   - deviceInfo: deviceInfo description
    ///   - channelId: channelId description
    func pushToDeviceSettingDeviceDetail(deviceInfo: LCDeviceInfo, channelId: String) {
        /**
         跳转设置设备详情
         Skip Set device details
         */
        let presenter = LCDeviceSettingPersenter(deviceInfo: deviceInfo, channelId: channelId)
        print("DeviceDetails:",Date.init(),"\(#function)::跳转至设备详情页")
        presenter?.style = LCDeviceSettingStyleDeviceDetailInfo
        let deviceSetting = LCDeviceSettingViewController()
        presenter?.viewController = deviceSetting
        deviceSetting.presenter = presenter
        deviceSetting.title = "setting_device_device_info_title".lc_T
        self.viewController?.navigationController?.pushViewController(deviceSetting, animated: true)
    }
    
    /// 跳转设置设备升级
    /// - Parameters:
    ///   - deviceInfo: 设备信息
    ///   - channelId: 通道iD
    /// Push to device setting device version
    /// - Parameters:
    ///   - deviceInfo: deviceInfo description
    ///   - channelId: channelId description
    func pushToDeviceSettingVersion(deviceInfo: LCDeviceInfo, channelId: String) {
        /**
         跳转设置设备升级
         Skip Indicates the device upgrade
         */
        print("ProgramVersion:",Date.init(),"\(#function)::跳转设置设备升级")
        let presenter = LCDeviceSettingPersenter(deviceInfo: deviceInfo, channelId: channelId)
        presenter?.style = LCDeviceSettingStyleVersionUp
        let deviceSetting = LCDeviceSettingViewController()
        presenter?.viewController = deviceSetting
        deviceSetting.presenter = presenter
        deviceSetting.title = "setting_device_version".lc_T
        self.viewController?.navigationController?.pushViewController(deviceSetting, animated: true)
    }
    
    /// 跳转设置移动检测
    /// - Parameters:
    ///   - deviceInfo: 设备信息
    ///   - selectedChannelId: 选择通道iD
    /// Push to motion detection page
    /// - Parameters:
    ///   - deviceInfo: deviceInfo description
    ///   - selectedChannelId: selected channelId description
    func pushToMotionDetectionPage(deviceInfo: LCDeviceInfo, selectedChannelId: String) {
        /**
         跳转设置移动检测
         Jump Sets movement detection
         */
        let presenter = LCMotionDetectionPresenter(deviceInfo: deviceInfo, selectedChannelId: selectedChannelId)
        let vc = LCMotionDetectionVC()
        vc.presenter = presenter
        presenter.viewController = vc
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// 跳转到SD卡管理界面
    /// - Parameters:
    ///   - deviceId: 设备ID
    ///   - sdUsed: 已使用容量
    ///   - sdTotal: 全部容量
    ///   - status: SD卡状态
    /// Push to format card
    /// - Parameters:
    ///   - deviceId: deviceId
    ///   - sdUsed: Used capacity
    ///   - sdTotal: Full capacity
    ///   - status: SD card status
    func pushToFormatCard(deviceId: String, sdUsed: Int64, sdTotal: Int64, status: String) {
        /**
         跳转到SD卡管理页面
         The SD card management page is displayed
         */
        let vc = LCFormatCardViewController(deviceId: deviceId, sdUsed: sdUsed, sdTotal: sdTotal, status: status)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转设置网络
    /// - Parameters:
    ///   - deviceId: 设备ID
    /// Push to WIFI settingl
    /// - Parameters:
    ///   - deviceId: deviceInfo description
    func pushToWifiSettings(deviceInfo: LCDeviceInfo) {
        /**
         跳转设置网络
         Redirect Setting Network
         */
        //【*】路由跳转设备添加模块
        //[*] Router jump device Adds a module
        if deviceInfo.status == "online" || deviceInfo.status == "sleep" {
            if let vc = LCRouter.object(forURL: "/lechange/adddevice/onlineWifiConfig", withUserInfo: ["deviceId": deviceInfo.deviceId]) as? UIViewController {
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        } else if deviceInfo.status == "offline" {
            if let vc = LCRouter.object(forURL: "/lechange/adddevice/offlineWifiConfigByDeviceId", withUserInfo: ["deviceId": deviceInfo.deviceId, "productId": deviceInfo.productId, "status": deviceInfo.status, "ability": deviceInfo.ability, "brand": deviceInfo.brand, "softAPModeWifiVersion":deviceInfo.softAPModeWifiVersion, "softAPModeWifiName":deviceInfo.softAPModeWifiName, "wifiConfigMode":deviceInfo.wifiConfigMode, "deviceModel":deviceInfo.deviceModel, "wifiTransferMode":deviceInfo.wifiTransferMode]) as? UIViewController {
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        } else if deviceInfo.status == "upgrading" {
            LCProgressHUD.showMsg("setting_device_updateing".lc_T)
        }
    }
}
