//
//  ILCMessageEditPresenter.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/14.
//

import Foundation
import LCNetworkModule

protocol ILCMessageEditPresenter:NSObjectProtocol {
    
    var deviceInfo:LCDeviceInfo!{get set}
    
    var channelInfo:LCChannelInfo!{get set}
    
    var messageInfos:[LCMessageInfo]{get set}
    
    var selectedAlarmIds:[String]{get set}
    
    func deleteMessageAlarms()
    
}

