//
//  LCTableViewAdapter.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/20.
//  Copyright © 2022 Imou. All rights reserved.
//

import Foundation
import LCNetworkModule

public class LCDeviceDetailTableViewAdapter {
    
    var sectionsModel: [LCTableViewSectionModel] = [LCTableViewSectionModel]()
    
    var cellsModel: [[LCTableViewCellModelProtocol]] = [[LCTableViewCellModelProtocol]]()
    
    var isMultipleChannels: Bool = false
    
    var deviceInfo: LCDeviceInfo
    
    var selectedChannelId: String
    
    weak var presenter: LCDeviceDetailPresenter?
    
    weak var tableview: UITableView?
    
    init(isMultipleChannels: Bool = false, deviceInfo: LCDeviceInfo, selectedChannelId: String, presenter: LCDeviceDetailPresenter? = nil) {
        self.isMultipleChannels = isMultipleChannels
        self.deviceInfo = deviceInfo
        self.selectedChannelId = selectedChannelId
        self.presenter = presenter
        
        if isMultipleChannels {
            self.sectionsModel = [
                LCTableViewSectionModel.init(title: nil, height: 0),
                LCTableViewSectionModel.init(title: "save_setting".lc_T)
            ]
            self.cellsModel = [
                [
                    LCSubImageTableViewCellModel(icon: UIImage(named: "icon_photo"), title: self.deviceInfo.name, subImageURL: self.getChannelPreviewImageUrl(), height: 70, showArrow: true, showSeparatedLine: true, deviceID: self.deviceInfo.deviceId, channelID: self.selectedChannelId, canUsing: self.isOnline(), selectAction: { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.presenter?.pushToDeviceSettingDeviceDetail(deviceInfo: strongSelf.deviceInfo, channelId: strongSelf.selectedChannelId)
                    }),
                    LCTableViewCellModel(icon: UIImage(named: "icon_edition"), title: "setting_device_version".lc_T, subTitle: self.deviceInfo.deviceVersion, height: 70, showArrow: false, canusing: self.isOnline(), selectAction: { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.presenter?.pushToDeviceSettingVersion(deviceInfo: strongSelf.deviceInfo, channelId: strongSelf.selectedChannelId)
                    })
                ],
                
                [LCLocalStorageTableViewCellModel(icon: UIImage(named: "icon_local_storage"), title: "local_storage".lc_T, subTitle: "no_SD_card".lc_T, height: 129, showArrow: true, canUsing: self.isOnline(), action: {[weak self] in
                    if let deviceId = self?.deviceInfo.deviceId {
                        if let indexPath = self?.titleForIndexPath(title: "local_storage".lc_T) {
                            if let model = self?.cellsModel[indexPath.section][indexPath.row] as? LCLocalStorageTableViewCellModel {
                                self?.presenter?.pushToFormatCard(deviceId: deviceId, sdUsed: model.useByte, sdTotal: model.totalByte, status: model.status)
                            }
                        }
                    }
                })]
            ]
        } else {
            self.sectionsModel = [
                LCTableViewSectionModel.init(title: nil, height: 0),
                LCTableViewSectionModel.init(title: "setting_device_footer_alarm".lc_T),
                LCTableViewSectionModel.init(title: "save_setting".lc_T),
                LCTableViewSectionModel.init(title: "devices_setting_up".lc_T)
            ]
            self.cellsModel = [
                [
                    LCSubImageTableViewCellModel(icon: UIImage(named: "icon_photo"), title: self.deviceInfo.name, subImageURL: self.getChannelPreviewImageUrl(), height: 70, showArrow: true, showSeparatedLine: true, deviceID: self.deviceInfo.deviceId, channelID: self.selectedChannelId, canUsing: self.isOnline(), selectAction: { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.presenter?.pushToDeviceSettingDeviceDetail(deviceInfo: strongSelf.deviceInfo, channelId: strongSelf.selectedChannelId)
                    }),
                    LCTableViewCellModel(icon: UIImage(named: "icon_edition"), title: "setting_device_version".lc_T, subTitle: self.deviceInfo.deviceVersion, height: 70, showArrow: false, canusing: self.isOnline(), selectAction: { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.presenter?.pushToDeviceSettingVersion(deviceInfo: strongSelf.deviceInfo, channelId: strongSelf.selectedChannelId)
                    })
                ],
                
                [LCTableViewCellModel(icon: UIImage(named: "icon_deployment_setting"), title: "setting_device_deployment".lc_T, height: 70, showArrow: true, canusing: self.isOnline(), selectAction: { [weak self] in
                    if let stongSelf = self {
                        self?.presenter?.pushToMotionDetectionPage(deviceInfo: stongSelf.deviceInfo, selectedChannelId: stongSelf.selectedChannelId)
                    }
                })],
                
                [LCSwitchTableViewCellModel(icon: UIImage(named: "icon_cloud_storage"), title: "device_detail_cloud_storage".lc_T, height: 70, showArrow: false, showSeparatedLine: true, canUsing: self.isOnline(), switchAction: {[weak self] isOn in
                    self?.presenter?.setCloudStorage(isOpen: isOn)
                }),
                 LCLocalStorageTableViewCellModel(icon: UIImage(named: "icon_local_storage"), title: "local_storage".lc_T, subTitle: "no_SD_card".lc_T, height: 129, showArrow: true, canUsing: self.isOnline(), action: {[weak self] in
                     if let deviceId = self?.deviceInfo.deviceId {
                         if let indexPath = self?.titleForIndexPath(title: "local_storage".lc_T) {
                             if let model = self?.cellsModel[indexPath.section][indexPath.row] as? LCLocalStorageTableViewCellModel {
                                 self?.presenter?.pushToFormatCard(deviceId: deviceId, sdUsed: model.useByte, sdTotal: model.totalByte, status: model.status)
                             }
                         }
                     }
                 })
                ],
                
                [LCTableViewCellModel(icon: UIImage(named: "icon_network_configuration"), title: "mobile_common_network_config".lc_T, subTitle: "", height: 70, showArrow: true, canusing:true, selectAction: { [weak self] in
                    if let stongSelf = self {
                        self?.presenter?.pushToWifiSettings(deviceInfo: stongSelf.deviceInfo)
                    }
                })
                ]
            ]
        }
    }
    
    func getChannelPreviewImageUrl() -> String {
        var imageUrl = ""
        self.deviceInfo.channels.forEach({ channel in
            if channel.channelId == self.selectedChannelId {
                imageUrl = channel.picUrl
            }
        })
        return imageUrl
    }
    
    func numberOfSections() -> Int {
        return sectionsModel.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section < 0 || section >= cellsModel.count {
            return 0
        }
        return cellsModel[section].count
    }
    
    func modelForRowAtIndexPath(indexPath: IndexPath) -> LCTableViewCellModelProtocol {
        if indexPath.section >= self.sectionsModel.count || indexPath.row >= self.cellsModel[indexPath.section].count {
            return LCTableViewCellModel(height: 0)
        }
        return self.cellsModel[indexPath.section][indexPath.row]
    }
    
    func modelForSection(section: NSInteger) -> LCTableViewSectionModel {
        if section >= self.sectionsModel.count {
            return LCTableViewSectionModel.init(title: "", height: 0)
        }
        return self.sectionsModel[section]
    }
    
    func updateDeviceConnectWifi(name: String) -> IndexPath {
        for i in 0..<self.cellsModel.count {
            for j in 0..<self.cellsModel[i].count {
                if self.cellsModel[i][j].title == "mobile_common_network_config".lc_T {
                    self.cellsModel[i][j].subTitle = name
                    print("DeviceDetailsPage:",Date.init(),"\(#function)::","mobile_common_network_config".lc_T,"更新页面" ,name)
                    return IndexPath(row: j, section: i)
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    
    func updateDeviceName(oldName: String, newName: String) -> IndexPath {
        for i in 0..<self.cellsModel.count {
            for j in 0..<self.cellsModel[i].count {
                if let displayName = self.cellsModel[i][j].title {
                    if displayName == oldName {
                        self.cellsModel[i][j].title = newName
                        self.deviceInfo.name = newName
                        return IndexPath(row: j, section: i)
                    }
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    
    func updateCloudStorageStatus(isOpen: Bool, isLoading: Bool) -> IndexPath {
        for i in 0..<self.cellsModel.count {
            for j in 0..<self.cellsModel[i].count {
                if self.cellsModel[i][j].title == "device_detail_cloud_storage".lc_T {
                    let model = self.cellsModel[i][j] as? LCSwitchTableViewCellModel
                    model?.isOpen = isOpen
                    model?.isLoading = isLoading
                    print("DeviceDetailsPage:",Date.init(),"\(#function)::","device_detail_cloud_storage".lc_T,"页面更新" ,isOpen ,isLoading)

                    return IndexPath(row: j, section: i)
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    
    func updateLocalStorageStatus(status: String, total: Int64, used: Int64) -> IndexPath {
        for i in 0..<self.cellsModel.count {
            for j in 0..<self.cellsModel[i].count {
                if self.cellsModel[i][j].title == "local_storage".lc_T {
                    let model = self.cellsModel[i][j] as? LCLocalStorageTableViewCellModel
                    model?.status = status
                    model?.totalByte = total
                    model?.useByte = used
                    print("DeviceDetailsPage:",Date.init(),"\(#function)::本地存储","更新页面" ,status ,total ,used)
                    return IndexPath(row: j, section: i)
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    
    func titleForIndexPath(title: String) -> IndexPath {
        for i in 0..<self.cellsModel.count {
            for j in 0..<self.cellsModel[i].count {
                if self.cellsModel[i][j].title == title {
                    print("DeviceDetailsPage:",Date.init(),"\(#function)::",title,"更新页面",title)
                    return IndexPath(row: j, section: i)
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    
    func isOnline() -> Bool {
        return self.deviceInfo.status == "online"
    }
}

