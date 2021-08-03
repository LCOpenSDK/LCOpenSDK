//
//  Copyright © 2018 dahua. All rights reserved.
//

import UIKit
//import LCWeiKit

class DHWiFiConfigPresenter: IDHWiFiConfigPresenter {
    
    weak var container: IDHWiFiConfigContainer?
    var deviceId = ""
    var wifiList = [LCWifiInfo]()
    var currentWifi: LCWifiInfo!
    private var canShowOtherLabel: Bool = false
    
    func setContainer(container: IDHWiFiConfigContainer) {
        self.container = container
    }
    
    deinit {
		container?.table().lc_clearTipsView()
        print("DHWiFiConfigPresenter deinit")
    }
    
    convenience init(deviceId: String) {
        self.init()
        self.deviceId = deviceId
    }
    
    // MARK: - 🍌bussiness
    func sectionNumber() -> Int {
        // sb添加的tableview进页面会直接reload几次。
        if canShowOtherLabel {
            return wifiList.count > 0 ? 3 : 1
        } else {
            return 0
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if (section != sectionNumber() - 1) {
            return section == 0 ? 1 : wifiList.count
        }
        
        return 1
    }
    
    
    func configCell(cell: UITableViewCell, indexPath: IndexPath) {
        let cell = cell as! DHWiFiConfigListCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath.section == 0 {
            cell.configView(status: currentWifi)
        } else {
            cell.configView(status: wifiList[indexPath.row])
        }
        
    }
    
    func refresh() {
        loadWiFiList()
    }
    
    func loadWiFiList() {
        self.container?.table().lc_setEmyptImageName("common_pic_nointernet", andDescription: "device_manager_wifi_list_empty".lc_T)
        
        func loadWifiListSuccess() {
            //获取已连接的wifi + 设备周围wifi成功时
            LCProgressHUD.hideAllHuds(self.container?.mainView())
            self.container?.refreshEnable(isEnable: true)
            self.container?.table().lc_addTipsView(.wifiNone)
            self.container?.table().reloadData()
        }
        
        func loadWifiListFail() {
            //获取设备周围wifi失败时
            LCProgressHUD.hideAllHuds(self.container?.mainView())
            self.container?.refreshEnable(isEnable: true)
            self.container?.table().lc_setEmyptImageName("common_pic_nointernet", andDescription: "mobile_common_get_info_failed".lc_T)
            self.wifiList.removeAll()
            self.container?.table().reloadData()
        }
        
        func loadCurrentWifiFail() {
            //设备周围wifi成功，但设备当前连接wifi无法获取时
            LCProgressHUD.hideAllHuds(self.container?.mainView())
            self.container?.refreshEnable(isEnable: true)
            self.container?.table().reloadData()
        }
        
        func getCurrentWifiFromList() -> LCWifiInfo? {
            for wifiStatus in self.wifiList {
                if Int(wifiStatus.linkStatus.rawValue) == 2 {
                   return wifiStatus
                }
            }
            return nil
        }
        
        func getCurrentWifiFromServer() {
            //请求当前连接的wifi
            LCDeviceHandleInterface.currentDeviceWifiDevice(deviceId, success: { (wifiInfo) in
                self.currentWifi = wifiInfo
                // 更新本地数据
                updateLocalWifiInfo(ssid: self.currentWifi.ssid)
                if self.wifiList.count > 0 {
                    loadWifiListSuccess()
                    LCProgressHUD.hideAllHuds(self.container?.mainView())
                }
            }) { (error) in
                LCProgressHUD.hideAllHuds(self.container?.mainView())
                loadCurrentWifiFail()
            }
        }
		
		func updateLocalWifiInfo(ssid: String) {
			// Todo::
			//发送通知，详情页更新
			var userInfo = [String: String]()
			userInfo["deviceId"] = self.deviceId
			userInfo["ssid"] = ssid
            print("deviceId: %s  ssid: %s",  userInfo["deviceId"] ?? "", userInfo["ssid"] ?? "")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SMBNotificationDeviceWiFiUpdateSuccess), object: nil, userInfo: userInfo)
		}
        
        //获取设备周围的Wifi列表信息
        self.container?.refreshEnable(isEnable: false)
        LCProgressHUD.show(onLowerView: self.container?.mainView())
        LCDeviceHandleInterface.wifiAroundDevice(deviceId, success: { (wifiInfo) in
            if wifiInfo.enable {
                self.canShowOtherLabel = true
                  
                self.wifiList = wifiInfo.wLan
                
                  if let currentWifi = getCurrentWifiFromList() {
                      self.currentWifi = currentWifi
                      // 更新本地数据
                      updateLocalWifiInfo(ssid: self.currentWifi.ssid)
                      // 过滤
                      let fittlerWifiList = self.wifiList.filter({$0.ssid != self.currentWifi.ssid})
                      self.wifiList = fittlerWifiList
                  }
                  if self.currentWifi != nil {
                      LCProgressHUD.hideAllHuds(self.container?.mainView())
                      loadWifiListSuccess()
                  } else {
                      // 如果周围的Wifi列表里没有设备配置过的wifi，则单独查询接口
                      getCurrentWifiFromServer()
                  }
            } else {
                self.canShowOtherLabel = true
                LCProgressHUD.showMsg("mobile_common_get_info_failed".lc_T)
                loadWifiListFail()
            }
        }) { (error) in
            self.canShowOtherLabel = true
            LCProgressHUD.showMsg("mobile_common_get_info_failed".lc_T)
            loadWifiListFail()
        }

    }
    
    func connectWifi(indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        let status = wifiList[indexPath.row]
        let container = DHWifiConnectOnlineVC.storyboardInstance()
        let presenter = DHWiFiConnectOnlinePresenter.init(connectWifiInfo: status, deviceId: self.deviceId)
        
        container.setPresenter(presenter: presenter)
        presenter.setContainer(container: container)
        presenter.successHandler = {
            for i in 0 ..< self.wifiList.count {
                let status = self.wifiList[i]
                if i == indexPath.row {
                    status.linkStatus = LinkStatusConnected
                    self.currentWifi = status
                } else {
                    status.linkStatus = LinkStatusNoConnect
                }
            }
            //过滤
            let fittlerWifiList = self.wifiList.filter({$0.ssid != self.currentWifi.ssid})
            self.wifiList = fittlerWifiList

            self.container?.table().reloadData()
        }
        self.container?.navigationVC()?.pushViewController(container, animated: true)
    }
    
    func connectHideWifi() {
        let vc = LCAddOtherWifiController(deviceId: self.deviceId)
		vc.myTitle = "Device_AddDevice_Network_Config".lc_T
        self.container?.navigationVC()?.pushViewController(vc, animated: true)
    }
    
    func explain5GInfo() {
        let supportVc = DHWiFiUnsupportVC()
		supportVc.myTitle = "Device_AddDevice_Network_Config".lc_T
        self.container?.navigationVC()?.pushViewController(supportVc, animated: true)
    }
    
    func explainWifiInfo() {
        let vc = LCWifiInfoExplainController()
		vc.myTitle = "Device_AddDevice_Network_Config".lc_T
        self.container?.navigationVC()?.pushViewController(vc, animated: true)
    }
    
    func hasConfigedWifi() -> Bool {
        guard currentWifi != nil else {
            return false
        }
        
        guard currentWifi.ssid != nil, currentWifi.ssid != "" else {
            return false
        }
        return true
    }
}
