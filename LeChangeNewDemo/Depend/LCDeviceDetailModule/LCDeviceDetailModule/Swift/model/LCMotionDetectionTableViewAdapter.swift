//
//  LCMotionDetectionTableViewAdapter.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/28.
//  Copyright © 2022 Imou. All rights reserved.
//
import Foundation
import LCNetworkModule

class LCMotionDetectionTableViewAdapter {
    
    var sectionsModel: [LCTableViewSectionModel] = [LCTableViewSectionModel]()
    
    var cellsModel: [[LCTableViewCellModelProtocol]] = [[LCTableViewCellModelProtocol]]()
    
    var deviceInfo: LCDeviceInfo
    
    weak var presenter: LCMotionDetectionPresenter?
    
    weak var tableview: UITableView?
    
    init(deviceInfo: LCDeviceInfo, presenter: LCMotionDetectionPresenter? = nil) {
        self.deviceInfo = deviceInfo
        self.presenter = presenter
        
        self.sectionsModel = [
            LCTableViewSectionModel.init(title: nil, height: 0),
            LCTableViewSectionModel.init(title: nil)
        ]
        self.cellsModel = [
            [LCSwitchTableViewCellModel(icon: nil, title: "setting_device_deployment_switch".lc_T, subTitle: "setting_device_deployment_detail".lc_T, height: 73, showArrow: false, showSeparatedLine: false, switchAction: { [weak self]  isOn in
                if let stongSelf = self {
                    stongSelf.presenter?.setDeviceAlarmStatus(open: isOn)
                }
            })],
            
            [LCTableViewCellModel(icon: nil, title: "setting_of_deployment_time_period".lc_T, height: 70, showArrow: true, selectAction: { [weak self] in
                if let stongSelf = self {
                    stongSelf.presenter?.pushToMotionDetectionTimesPage(deviceInfo: stongSelf.deviceInfo, selectedChannelId: stongSelf.presenter?.selectedChannelId ?? "")
                }
            })]
        ]
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
    
    func updateMotionDetectionStatue(isOpen: Bool, isLoading: Bool) -> IndexPath {
        for i in 0..<self.cellsModel.count {
            for j in 0..<self.cellsModel[i].count {
                if self.cellsModel[i][j].title == "setting_device_deployment_switch".lc_T {
                    let model = self.cellsModel[i][j] as? LCSwitchTableViewCellModel
                    model?.isOpen = isOpen
                    model?.isLoading = isLoading
                    print("DeploymentSetting:",Date.init(),"\(#function)::","setting_device_deployment_switch".lc_T,"更新页面" ,isOpen ,isLoading)
                    return IndexPath(row: j, section: i)
                }
            }
        }
        return IndexPath(row: 0, section: 0)
    }
}

