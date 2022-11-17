//
//  LCDeviceListPresenter.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/24.
//  Copyright © 2022 Imou. All rights reserved.
//

import LCOpenSDKDynamic
import LCNetworkModule
import LCNewLivePreviewModule

@objcMembers class LCDeviceListPresenter : LCBasicPresenter {
    /// 开发平台设备
    var openDevices = [LCDeviceInfo]() {
        didSet {
            self.p2pPredrilling()
        }
    }
    /// containter
    weak var listContainer: LCDeviceListViewController?
    
    let livePreviewVC = LCNewLivePreviewViewController()
    
    /// 当前是否在网络请求中
    var isRefreshing: Bool = false
    /// p2p预打洞设备
    var p2pDevices: Set<String> = Set<String>()
    
    var pageIndex = 1
    let pageSize = 10

    func initSDK() {
        print("\(LCApplicationDataManager.sdkHost())" + "\(LCApplicationDataManager.sdkHost())")
        let param = LCOpenSDK_ApiParam()
        param.procotol = LCApplicationDataManager.hostApi().contains("https") ? .PROCOTOL_TYPE_HTTPS : .PROCOTOL_TYPE_HTTP
        param.addr = LCApplicationDataManager.sdkHost()
        param.port = LCApplicationDataManager.sdkPort()
        param.token = LCApplicationDataManager.token()
        let _ = LCOpenSDK_Api(openApi: param)
        print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: Init open api: \(param.addr)")
    }
    
    func initSDKLog() {
        let logInfo = LCOpenSDK_LogInfo()
        logInfo.levelType = LogLevelTypeDebug
        LCOpenSDK_Log.shareInstance().setLogInfo(logInfo)
    }
    
    func refreshData() {
        // TODO： 判断是否在上拉 yes：return
        if self.isRefreshing {
            self.listContainer?.deviceListView.mj_header?.endRefreshing()
            return
        }
        
        self.isRefreshing = true
        LCDeviceManagerInterface.queryDeviceDetailPage(pageIndex, pageSize: pageSize) {[weak self] devices in
            self?.openDevices.removeAll()
            //只显示NVR与通道数大于等于1
            if let ds = devices as? [LCDeviceInfo] {
                let temp = ds.filter { device in
                    return (device.channels.count == 0 && device.catalog.uppercased() != "NVR") ? false : true
                }
                self?.openDevices.append(contentsOf: temp)
                self?.listContainer?.deviceListView.reloadData()
            }
            LCProgressHUD.hideAllHuds(nil)
            self?.listContainer?.deviceListView.mj_header?.endRefreshing()
            self?.isRefreshing = false
        } failure: {[weak self] error in
            LCProgressHUD.hideAllHuds(nil)
            self?.listContainer?.deviceListView.mj_header?.endRefreshing()
            self?.isRefreshing = false
            LCProgressHUD.showMsg(error.errorMessage)
        }
    }

    func loadMoreData() {
        if self.isRefreshing {
            self.listContainer?.deviceListView.mj_footer?.endRefreshing()
            return
        }
        
        self.isRefreshing = true
        
        if self.openDevices.count > 0 && self.openDevices.count % pageSize == 0 {
            LCDeviceManagerInterface.queryDeviceDetailPage(self.openDevices.count / pageSize + 1, pageSize: pageSize) { [weak self] devices in
                //只显示NVR与通道数大于等于1
                if let ds = devices as? [LCDeviceInfo] {
                    let temp = ds.filter { device in
                        return (device.channels.count == 0 && device.catalog.uppercased() != "NVR") ? false : true
                    }
                    self?.openDevices.append(contentsOf: temp)
                    self?.listContainer?.deviceListView.reloadData()
                }
                LCProgressHUD.hideAllHuds(nil)
                self?.listContainer?.deviceListView.mj_footer?.endRefreshing()
                self?.isRefreshing = false
            } failure: {[weak self] error in
                LCProgressHUD.hideAllHuds(nil)
                self?.listContainer?.deviceListView.mj_footer?.endRefreshing()
                self?.isRefreshing = false
                LCProgressHUD.showMsg(error.errorMessage)
            }
        } else {
            self.listContainer?.deviceListView.mj_footer?.endRefreshing()
            self.isRefreshing = false
        }
    }
    
    func getTableViewCellHeight(info: LCDeviceInfo) -> CGFloat {
        if info.channels.count > 1 {
            //多通道设备
            return 315.0
        } else {
            //单通道设备
            return 260.0
        }
    }
    
    // p2p预打洞
    func p2pPredrilling()  {
        var jsonArray = [LCOpenSDK_P2PDeviceInfo]()
        self.openDevices.forEach { device in
            if self.p2pDevices.contains(device.deviceId) == false && device.status == "online" {
                let info = LCOpenSDK_P2PDeviceInfo()
                info.playToken = device.playToken
                info.did = device.deviceId
                jsonArray.append(info)
                self.p2pDevices.insert(device.deviceId)
            }
        }
        if jsonArray.count > 0 {
            LCOpenSDK_LoginManager.shareMyInstance().addDevices(LCApplicationDataManager.token(), devices: jsonArray)
        }
    }
}

extension LCDeviceListPresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.openDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LCDeviceListCell", for: indexPath)
        (cell as? LCDeviceListCell)?.deviceInfo = self.openDevices[indexPath.row]
        (cell as? LCDeviceListCell)?.resultBlock = { info, channelIndex, index in
            LCDeviceVideoManager.shareInstance().currentDevice = info
            LCNewDeviceVideoManager.shareInstance().currentDevice = info
            LCDeviceVideoManager.shareInstance().currentChannelIndex = -1
            LCNewDeviceVideoManager.shareInstance().currentChannelIndex = -1
            if index == 0 {
                LCDeviceVideoManager.shareInstance().currentChannelIndex = channelIndex
                LCNewDeviceVideoManager.shareInstance().currentChannelIndex = channelIndex
                if info.catalog.uppercased() == "NVR" &&  LCDeviceVideoManager.shareInstance().currentChannelInfo.status != "online" {
                    return
                }
                if info.catalog.uppercased() == "IPC" && info.status != "online" {
                    return
                }
                self.listContainer?.navigationController?.pushViewController(self.livePreviewVC, animated: true)
            } else if index == 1 {
                var channleId = ""
                if self.openDevices[indexPath.row].channels.count > channelIndex {
                    channleId = self.openDevices[indexPath.row].channels[channelIndex].channelId
                }
                self.listContainer?.navigationController?.push(toDeviceSettingPage: self.openDevices[indexPath.row], selectedChannelId:channleId)
            } else if index == 2 {
                let deviceJson = info.transfromToJson()
                let userInfo = ["deviceJson": deviceJson, "index":channelIndex] as [String : Any]
                self.listContainer?.navigationController?.push(toMessagePage: userInfo)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getTableViewCellHeight(info: self.openDevices[indexPath.row])
    }
}
