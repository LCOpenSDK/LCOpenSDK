//
//  LCMotionDetectionPresenter.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/28.
//  Copyright © 2022 Imou. All rights reserved.
//

import LCBaseModule
import LCNetworkModule

@objcMembers public class LCMotionDetectionPresenter: NSObject {
    public weak var viewController: LCMotionDetectionVC? {
        didSet {
            self.adapter.tableview = self.viewController?.tableView
        }
    }

    var deviceInfo: LCDeviceInfo
    
    var selectedChannelId: String
    
    var selectedChannelInfo: LCChannelInfo?
    
    lazy var adapter: LCMotionDetectionTableViewAdapter = {
        let adapter = LCMotionDetectionTableViewAdapter(deviceInfo: self.deviceInfo, selectedChannelId: self.selectedChannelId, presenter: self)
        return adapter
    }()
    
    public init(deviceInfo: LCDeviceInfo, selectedChannelId: String) {
        self.deviceInfo = deviceInfo
        self.selectedChannelId = selectedChannelId
    }
    
    /// 更新动检状态
    ///Update motion detection status
    func updateMotionDetectionStatus() {
        LCDeviceManagerInterface.bindDeviceChannelInfo(withDevice: self.deviceInfo.deviceId, channelId: self.selectedChannelId) {[weak self] info in
            let indexPath = self?.adapter.updateMotionDetectionStatue(isOpen: info.alarmStatus == 1, isLoading: false) ?? IndexPath(row: 0, section: 0)
            self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
        } failure: {[weak self] error in
            let indexPath = self?.adapter.updateMotionDetectionStatue(isOpen: false, isLoading: false) ?? IndexPath(row: 0, section: 0)
            self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    /// 改变动检状态
    /// - Parameter open: 开或关
    /// Set device alarm status
    /// - Parameter open: true or false
    func setDeviceAlarmStatus(open: Bool) {
        if open {
            let show = UserDefaults.standard.object(forKey: "setting_device_alarm_alert".lc_T) as? Bool
            if show == true {
                self.deviceAlarmRequest(open: open)
            } else {
                LCAlertView.lc_ShowAlert(title: "Alert_Title_Notice2".lc_T, detail: "setting_device_alarm_alert".lc_T, showAgain: true, confirmString:  "Alert_Title_Button_Confirm1".lc_T, cancelString: "Alert_Title_Button_Cancle".lc_T) { isConfirmSelected in
                    if isConfirmSelected {
                        self.deviceAlarmRequest(open: open)
                    } else {
                        let indexPath = self.adapter.updateMotionDetectionStatue(isOpen: !open, isLoading: false)
                        self.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
        } else {
            let show = UserDefaults.standard.object(forKey: "CloseAlamShowAgain") as? Bool
            if show == true {
                self.deviceAlarmRequest(open: open)
            } else {
                LCAlertView.lc_ShowAlert(title: "Alert_Title_Notice2".lc_T, detail: "setting_device_alarm_alert_close".lc_T, showAgain: true, confirmString: "Alert_Title_Button_Confirm1".lc_T, cancelString: "Alert_Title_Button_Cancle".lc_T) { isConfirmSelected in
                    if isConfirmSelected {
                        self.deviceAlarmRequest(open: open)
                    } else {
                        let indexPath = self.adapter.updateMotionDetectionStatue(isOpen: !open, isLoading: false)
                        self.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
        }
    }
    
    /// 设备报警开关
    /// - Parameter open: 开或关
    /// Equipment alarm switch
    /// - Parameter open: true or false
    private func deviceAlarmRequest(open: Bool) {
        LCProgressHUD.show(on: self.viewController?.view)
        LCDeviceHandleInterface.modifyDeviceAlarmStatus(self.deviceInfo.deviceId, channelId: self.selectedChannelId, enable: open) { [weak self] in
            LCProgressHUD.hideAllHuds(self?.viewController?.view)
            let indexPath = self?.adapter.updateMotionDetectionStatue(isOpen: open, isLoading: false) ?? IndexPath(row: 0, section: 0)
            self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
            print("DeploymentSetting:",Date.init(),"\(#function)::动检状态更新至最新:",open)
        } failure: { [weak self] error in
            LCProgressHUD.hideAllHuds(self?.viewController?.view)
            LCProgressHUD.showMsg(error.errorMessage)
            //LCProgressHUD.showMsg("operation_failed".lc_T)
            let indexPath = self?.adapter.updateMotionDetectionStatue(isOpen: !open, isLoading: false) ?? IndexPath(row: 0, section: 0)
            self?.viewController?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}


extension LCMotionDetectionPresenter {
    
    /// 跳转至布防时间
    /// - Parameters:
    ///   - deviceInfo: 设备详情
    ///   - selectedChannelId: 选择通道ID
    /// Push to motion detectio times page
    /// - Parameters:
    ///   - deviceInfo: 设备详情
    ///   - selectedChannelId: 选择通道ID
    func pushToMotionDetectionTimesPage(deviceInfo: LCDeviceInfo, selectedChannelId: String) {
        let vc = LCDefenceTimeSetVC()
        vc.deviceId = deviceInfo.deviceId
        vc.channelId = selectedChannelId
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
