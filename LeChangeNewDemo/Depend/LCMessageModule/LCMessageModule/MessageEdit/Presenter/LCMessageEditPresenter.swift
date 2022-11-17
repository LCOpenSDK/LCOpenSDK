//
//  LCMessageEditPresenter.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/14.
//

import UIKit
import LCNetworkModule

class LCMessageEditPresenter: NSObject, ILCMessageEditPresenter {
    
    weak var container:ILCMessageEditController?
    
    var deviceInfo:LCDeviceInfo!
    
    var channelInfo:LCChannelInfo!
    
    var messageInfos:[LCMessageInfo] = []
    
    var selectedAlarmIds:[String] = []
    
    init(_ container:ILCMessageEditController) {
        super.init()
        self.container = container
    }
    
    func deleteMessageAlarms() {
        guard selectedAlarmIds.count > 0 else {
            return
        }
        guard let containView = self.container?.mainView() else {
            return
        }
        var alarmIds = ""
        for alarmId in selectedAlarmIds {
            if alarmIds.count > 0 {
                alarmIds.append(",")
            }
            alarmIds.append(alarmId)
        }
        LCMessageProcessHUD.show(on: containView, animated: true)
        LCMessageInterface.deleteMessageAlarm(by: deviceInfo.productId, deviceId: deviceInfo.deviceId, channelId: channelInfo.channelId, alarmId: alarmIds) { [weak self] in
            guard let self = self else {return}
            LCMessageProcessHUD.hideAllHuds(containView)
            //通知列表页数据已删除
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LCMessageEditDeleteSuccess"), object: nil, userInfo: ["deleteAlarms": self.selectedAlarmIds])
            //更新列表
            self.messageInfos.removeAll(where: {self.selectedAlarmIds.contains($0.alarmId)})
            self.selectedAlarmIds.removeAll()
            self.container?.reloadData()
            
            self.container?.mainVC().navigationController?.popViewController(animated: true)
        } failure: { error in
            LCMessageProcessHUD.hideAllHuds(containView)
            LCMessageProcessHUD.showMsg(error.errorDescription)
        }
    }

}
