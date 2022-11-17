//
//  LCMessageListPresenter.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/10.
//

import UIKit
import LCNetworkModule

class LCMessageListPresenter: NSObject, ILCMessagePresenter {
    
    let alarmPageCount = 30
    
    var deviceInfo:LCDeviceInfo!
    
    var channelInfo:LCChannelInfo!
    
    var messageInfosDic:[String: [LCMessageInfo]] = [:]
    
    var nextAlarmId:Int = -1
    
    var currentDate:Date = Date()
    
    var currentDateStr:String {
        return NSDate.lcMessage_string(of: currentDate, format: "yyyy-MM-dd")
    }
    
    var showMessageInfos:[LCMessageInfo] {
        return messageInfosDic[currentDateStr] ?? []
    }
    
    weak var container:ILCMessageListController?
    
    init(with container:ILCMessageListController) {
        super.init()
        self.container = container
        addNotification()
    }
    
    func refreshMessageList() {
        LCMessageInterface.getMessageAlarms(deviceInfo.productId, deviceId: deviceInfo.deviceId, channelId: channelInfo.channelId, day: currentDate, count: alarmPageCount, nextAlarmId: "-1") { alarmInfo in
            self.messageInfosDic[self.currentDateStr] = alarmInfo.alarms
            self.nextAlarmId = alarmInfo.nextAlarmId
            if alarmInfo.alarms.count == 0 {
                self.container?.showEmptyView()
            }else {
                self.container?.reloadData()
            }
        } failure: { error in
            self.container?.showErrorView()
        }

    }
    
    func loadMoreMessageList() {
        LCMessageInterface.getMessageAlarms(deviceInfo.productId, deviceId: deviceInfo.deviceId, channelId: channelInfo.channelId, day: currentDate, count: alarmPageCount, nextAlarmId: "\(nextAlarmId)") { alarmInfo in
            var messageInfos = self.showMessageInfos
            messageInfos.append(contentsOf: alarmInfo.alarms)
            self.messageInfosDic[self.currentDateStr] = messageInfos
            if self.showMessageInfos.count == 0 {
                self.container?.showEmptyView()
            }else {
                self.container?.reloadData()
            }
            if alarmInfo.nextAlarmId != 0 {
                self.nextAlarmId = alarmInfo.nextAlarmId
            }
            if alarmInfo.alarms.count < self.alarmPageCount {
                self.container?.showNoMoreData()
            }
        } failure: { error in
            //
            self.container?.showErrorView()
        }
    }
    
    func deleteMessageAlarm(by alarmId:String) {
        guard let containView = self.container?.mainView() else {
            return
        }
        LCMessageProcessHUD.show(on: containView, animated: true)
        LCMessageInterface.deleteMessageAlarm(by: deviceInfo.productId, deviceId: deviceInfo.deviceId, channelId: channelInfo.channelId, alarmId: alarmId) {
            LCMessageProcessHUD.hideAllHuds(containView)
            var messageInfos = self.showMessageInfos
            messageInfos.removeAll(where: {$0.alarmId == alarmId})
            self.messageInfosDic[self.currentDateStr] = messageInfos
            self.container?.reloadData()
        } failure: { error in
            LCMessageProcessHUD.hideAllHuds(containView)
            LCMessageProcessHUD.showMsg(error.errorDescription)
        }

    }
    
    //MARK: - @objc func
    @objc func deleteMessageSuccess(_ noti:Notification) {
        guard let userInfo = noti.userInfo, let deleteAlarms = userInfo["deleteAlarms"] as? [String] else {
            return
        }
        var messageInfos = self.showMessageInfos
        messageInfos.removeAll(where: {deleteAlarms.contains($0.alarmId)})
        self.messageInfosDic[currentDateStr] = messageInfos
        self.container?.reloadData()
    }
    
    //MARK: - Notificaton
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteMessageSuccess(_:)), name: NSNotification.Name(rawValue: "LCMessageEditDeleteSuccess"), object: nil)
    }

}
