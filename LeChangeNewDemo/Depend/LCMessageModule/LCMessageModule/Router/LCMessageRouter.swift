//
//  LCMessageRouter.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/11.
//

import UIKit
import LCBaseModule.LCModule
import LCNetworkModule

let messageModule_MessageList = "messageModule_MessageList"

@objc public class LCMessageRouter: NSObject, LCModuleProtocol {
    
    public func moduleInit() {
        registerMessageList()
    }
    
    private func registerMessageList() {
        LCRouter.registerURLPattern(messageModule_MessageList) { (routerParameters) -> Any? in
            guard let params = routerParameters as? [String: Any], let dicUserInfo = params[LCRouterParameterUserInfo] as? [String: Any] else {
                return nil
            }
            guard let deviceJson = dicUserInfo["deviceJson"] as? String, let channelIndex = dicUserInfo["index"] as? Int else {
                return nil
            }
            guard let deviceInfo = LCDeviceInfo.json(toObject: deviceJson) else {
                return nil
            }
            let messageListVC = LCMessageListController()
            messageListVC.configData(deviceInfo, index: channelIndex)
            return messageListVC
        }
    }
}
