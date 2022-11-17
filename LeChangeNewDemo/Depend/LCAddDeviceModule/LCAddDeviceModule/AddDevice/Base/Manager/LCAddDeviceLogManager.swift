//
//  Copyright © 2019 Imou. All rights reserved.
//

import UIKit

enum LogType: String {
    case Start  = "BindDeviceStart"                 //开始添加/离线配网流程
    case End    = "BindDeviceStop"                  //添加/配网流程结束(会上报多次，以最后一次为准)
    case NetSDK = "BindDeviceNetSDKMethod"          //NetSDK接口调用结果,会上报多次，每次数据均保留；(搜索接口只报失败)
    case Init   = "BindDeviceInitDevAccount"        //初始化结果，会上报多次，每次数据均保留(IOS 新设备IP无效时单独调)
}

@objc public class LCAddDeviceLogManager: NSObject {

    @objc public static let shareInstance: LCAddDeviceLogManager = LCAddDeviceLogManager()
    
    let bust: String = "ClientBindDevice"
    
    @objc var requestID: String = ""
}

extension LCAddDeviceLogManager {
    
    /**
     *  开始添加设备log
     *  1、QRCode：扫码添加
     *  2、SN：手输序列号添加
     *  3、NetworkConfig：离线配网
     *  result: inputData
     */
    @objc public func addDeviceStartLog(model: LCAddDeviceLogModel) {
        
        //添加/配网流程开始后需生成一次requestID
        requestID = LCClientEventLogHelper.shareInstance().getRequestId()
        
        let curInputData = model.inputData.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
        let inputDatas = curInputData.components(separatedBy: ",")
        for singalData in inputDatas {
            let datas = singalData.components(separatedBy: ":")
            if datas.count > 1 && datas[0] == "SN" {
                model.did = datas[1]
            }
        }
        
        let logDict = ["bust": bust, "requestid": requestID, "BindDeviceType": model.bindDeviceType.rawValue, "inputData": model.inputData, "did": model.did, "time": model.time]
        let dict = ["type": LogType.Start.rawValue, "log": logDict] as [String: Any]
        LCClientEventLogHelper.shareInstance().addClientEventLog(LogType.Start.rawValue, conent: dict)
    }
    
    /**
     *  添加/配网流程结束log
     */
    @objc public func addDeviceEndLog(model: LCAddDeviceLogModel) {
        
        let logDict = ["bust": bust, "requestid": requestID, "res": model.res, "errCode": model.errCode, "dese": model.dese, "time": model.time] as [String: Any]
        let dict = ["type": LogType.End.rawValue, "log": logDict] as [String: Any]
        LCClientEventLogHelper.shareInstance().addClientEventLog(LogType.End.rawValue, conent: dict)
    }
    
    /**
     *  NetSDK接口调用结果,会上报多次，每次数据均保留；(搜索接口只报失败)
     */
    @objc public func addDeviceNetSDKLog(model: LCAddDeviceLogModel) {
        
        let logDict = ["bust": bust, "requestid": requestID, "method": model.method, "errCode": model.errCode, "res": model.res, "time": model.time] as [String: Any]
        let dict = ["type": LogType.NetSDK.rawValue, "log": logDict] as [String: Any]
        LCClientEventLogHelper.shareInstance().addClientEventLog(LogType.NetSDK.rawValue, conent: dict)
    }
    
    /**
     *  初始化结果，会上报多次，每次数据均保留(IOS 新设备IP无效时单独调)
     */
    @objc public func addDeviceInitLog(model: LCAddDeviceLogModel) {
        
    }
}
