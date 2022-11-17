//
//  LCTimeSetPresenter.swift
//  LeChangeOverseas
//
//  Created by hyd on 2021/5/14.
//  Copyright © 2021 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//  布防时间段设置Presenter

import UIKit
import LCNetworkModule

class LCTimeSetPresenter: NSObject, LCTimeSetVCProtocol {
    public weak var controller: LCDefenceTimeSetVC!
    var timePeriods = [LCAlarmPlanRule]()
    // 是否走通用能力协议
    var isComDevice: (isCom: Bool, type: String) {
        return (false, "")
    }

    init(controller: LCDefenceTimeSetVC) {
        super.init()
        // load data
        self.controller = controller
    }

    func fetchComalplChnAlarmPlan() {
        LCProgressHUD.show(on: controller.view)
        LCDeviceHandleInterface.deviceAlarmPlan(controller.deviceId, channelId: controller.channelId) {[weak self] plan in
            self?.timePeriods = plan.rules
            // 更新planView
            self?.controller?.planView.setTimePeriods(timePeriods: plan.rules)
            LCProgressHUD.hideAllHuds(self?.controller?.view)
        } failure: {[weak self] error in
            LCProgressHUD.hideAllHuds(self?.controller?.view)
            error.showTips()
        }
    }

    // 更新数据
    func updateData() {
        fetchComalplChnAlarmPlan()
    }

    // 跳转到下一级控制器
    func didSelectPlanTimeItem(day: LCWeekDay) {
        let vc = LCTimeperiodVC()
        vc.delegate = self
        vc.title = "device_manager_defence_time_set".lc_T
        vc.timePeriods = timePeriods
        vc.currentDay = day
        controller.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LCTimeSetPresenter: LCTimeperiodVCDlegate {
    // 下发报警时间段
    func saveTimeperiods(timePeriods: [LCAlarmPlanRule], finished:(() -> ())?) {
        // 保存当前值
        let plan = LCAlarmPlan()
        plan.rules = timePeriods
        plan.channelId = controller.channelId
        // 下发报警计划时间段
        LCDeviceHandleInterface.modifyDeviceAlarmPlan(controller.deviceId, lcAlarmPlan: plan) { [weak self] in
            self?.controller.navigationController?.popViewController(animated: true)
            self?.updateData()
            self?.controller.planView.setTimePeriods(timePeriods: timePeriods)
            if let callback = finished {
                callback()
            }
            print("DeploymentSetting:",Date.init(),"\(#function)::保存布防时间段",timePeriods)
            LCProgressHUD.showMsg("livepreview_localization_success".lc_T)
        } failure: {error in
            if let callback = finished {
                callback()
            }
            error.showTips()
            print("DeploymentSetting:",Date.init(),"\(#function)::保存布防时间段失败",timePeriods)
        }
    }
}
