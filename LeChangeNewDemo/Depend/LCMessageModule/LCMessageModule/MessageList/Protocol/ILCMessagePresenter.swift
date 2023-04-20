//
//  ILCMessagePresenter.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/10.
//

import Foundation
import LCNetworkModule

protocol ILCMessagePresenter:NSObjectProtocol {
    
    var deviceInfo:LCDeviceInfo!{get set}
    
    var channelInfo:LCChannelInfo!{get set}
    
    var showMessageInfos:[LCMessageInfo]{get}
    
    var messageInfosDic:[String: [LCMessageInfo]]{get set}
    
    var currentDate:Date{get set}
    
    var currentDateStr:String{get}
    
    func refreshMessageList()
    
    func loadMoreMessageList()
    
    func deleteMessageAlarm(by alarmId:String)
}
