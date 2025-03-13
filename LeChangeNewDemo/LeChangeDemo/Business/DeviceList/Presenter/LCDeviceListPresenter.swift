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
import LCOpenMediaSDK

@objcMembers class LCDeviceListPresenter : LCBasicPresenter {
    /// 开发平台设备
    var openDevices = [LCDeviceInfo]() {
        didSet {
            self.p2pPredrilling()
            self.mtsPreKeepalive()
        }
    }
    /// containter
    weak var listContainer: LCDeviceListViewController?
    
//    lazy var livePreviewVC: LCNewLivePreviewViewController = {
//        return LCNewLivePreviewViewController()
//    }()
    
    /// 当前是否在网络请求中
    var isRefreshing: Bool = false
    /// p2p预打洞设备
    var p2pDevices: Set<String> = Set<String>()
    /// p2p预打洞设备
    var mtsKeepDevices: Set<String> = Set<String>()
    
    var pageIndex = 1
    let pageSize = 10

    deinit {
        NSLog(" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.classForCoder))
    }
    
    func initSDK() {
        print("\(LCApplicationDataManager.sdkHost())" + "\(LCApplicationDataManager.sdkHost())")
        let param = LCOpenSDK_ApiParam()
        param.procotol = LCApplicationDataManager.hostApi().contains("https") ? .PROCOTOL_TYPE_HTTPS : .PROCOTOL_TYPE_HTTP
        param.addr = LCApplicationDataManager.sdkHost()
        param.port = LCApplicationDataManager.sdkPort()
        param.token = LCApplicationDataManager.token()
        let _ = LCOpenSDK_Api(openApi: param)
        print(" \(NSStringFromClass(self.classForCoder)):: Init open api: \(param.addr)")
    }
    
    func initSDKLog() {
        let logInfo = LCOpenSDK_LogInfo()
        logInfo.levelType = LogLevelTypeALL
        LCOpenSDK_Log.shareInstance().setLogInfo(logInfo)
    }
    
    func refreshData() {
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
            if info.channels.count <= 2 {
                return 200.0
            } else {
                return 315.0
            }
        } else {
            //单通道设备
            return 260.0
        }
    }
    
    // p2p预打洞
    func p2pPredrilling()  {
        var jsonArray = [LCOpenSDK_P2PDeviceInfo]()
        self.openDevices.forEach {[weak self] device in
            if self?.p2pDevices.contains(device.deviceId) == false && device.status == "online" {
                let info = LCOpenSDK_P2PDeviceInfo()
                info.playToken = device.playToken
                info.did = device.deviceId
                jsonArray.append(info)
                self?.p2pDevices.insert(device.deviceId)
            }
        }
        if jsonArray.count > 0 {
            LCOpenSDK_LoginManager.shareMyInstance().addDevices(LCApplicationDataManager.token(), devices: jsonArray)
        }
    }
    
    // MTS预连接
    func mtsPreKeepalive()  {
        var datas = Array<Dictionary<String, String>>()
        self.openDevices.forEach {[weak self] device in
            if self?.mtsKeepDevices.contains(device.deviceId) == false && device.status == "online" {
                datas.append(["playtoken":device.playToken, "deviceId":device.deviceId, "productId":device.productId])
                self?.mtsKeepDevices.insert(device.deviceId)
            }
        }
        
        LCOpenSDK_Utils.mtsPreKeepalive(datas, token: LCApplicationDataManager.token())
    }
}

extension LCDeviceListPresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.openDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LCDeviceListCell", for: indexPath)
        (cell as? LCDeviceListCell)?.deviceInfo = self.openDevices[indexPath.row]
        (cell as? LCDeviceListCell)?.resultBlock = {[weak self] info, channelIndex, index in
            LCNewDeviceVideoManager.shareInstance().reset()
            LCNewDeviceVideoManager.shareInstance().currentDevice = info
            /// 多目相机
            if (info.channels.count > 0) {
                if (info.multiFlag == true) {
                    LCNewDeviceVideoManager.shareInstance().mainChannelInfo = info.channels[0]
                    LCNewDeviceVideoManager.shareInstance().displayChannelID = info.channels[channelIndex].channelId
                } else {
                    LCNewDeviceVideoManager.shareInstance().mainChannelInfo = info.channels[channelIndex]
                    LCNewDeviceVideoManager.shareInstance().displayChannelID = info.channels[channelIndex].channelId
                }
            }
            if index == 0 {
                if info.catalog.uppercased() == "NVR" &&  LCNewDeviceVideoManager.shareInstance().mainChannelInfo.status != "online" {
                    return
                }
                if info.catalog.uppercased() == "IPC" && info.status != "online" {
                    return
                }
//                if let vc = self?.livePreviewVC {
                let vc = LCNewLivePreviewViewController()
                vc.isFirstIntoVC = true
//                    self?.listContainer?.navigationController?.pushViewController(vc, animated: true)
//                }
//                let vc = LCLivePluginViewController()
//                let item = LCOpenLiveSource()
//                item.cid = Int(info.channels[channelIndex].channelId) ?? 0
//                item.did = info.channels[channelIndex].deviceId
//                item.pid = info.productId
//                vc.playItem = item
                self?.listContainer?.navigationController?.pushViewController(vc, animated: true)
            } else if index == 1 {
                var channleId = ""
                if self?.openDevices[indexPath.row].channels.count ?? -1 > channelIndex {
                    channleId = self?.openDevices[indexPath.row].channels[channelIndex].channelId ?? "-1"
                }
                self?.listContainer?.navigationController?.push(toDeviceSettingPage: self?.openDevices[indexPath.row] ?? LCDeviceInfo(), selectedChannelId:channleId)
            } else if index == 2 {
                let deviceJson = info.transfromToJson()
                let userInfo = ["deviceJson": deviceJson, "index":channelIndex] as [String : Any]
                self?.listContainer?.navigationController?.push(toMessagePage: userInfo)
            } else if index == 3 {
                NSLog("模拟接听");
                LCAlertView.lc_ShowAlert(title: "提示", detail: "请先按下设备上的【呼叫】按钮，听到“正在呼叫”提示音后，再在30秒内按App界面上的【模拟接听呼叫】按钮", confirmString: "开始模拟", cancelString: "取消") { isConfirmSelected in
                    if isConfirmSelected {
                        //开始模拟呼叫
                        LCPermissionHelper.requestCameraAndAudioPermission { granted in
                            if granted {
                                let vc = LCVisualTalkViewController()
                                vc.intercomStatus = .ringing
//                                vc.isNeedSoftEncode = false
                                vc.modalPresentationStyle = .fullScreen
                                self?.listContainer?.present(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getTableViewCellHeight(info: self.openDevices[indexPath.row])
    }
}
