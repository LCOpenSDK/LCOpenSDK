//
//  Copyright © 2019 Imou. All rights reserved.
//

import UIKit

public enum StartAddType: String {
    case QRCode         = "QRCode"
    case SN             = "SN"
    case NetworkConfig  = "NetworkConfig"
}

public enum ResType: String {
    case Fail       = "fail"
    case Success    = "success"
}

public enum DescType: String {
    case Success                = "success"
    case ParseQRCodeFail        = "ParseQRCodeFail"
    case ConnectCloudTimeOut    = "ConnectCloudTimeOut"
    case FindDevFail            = "FindDevFail"
    case ConnectAPFail          = "ConnectAPFail"
}

public enum InitType: String {
    case InitDev        = "initDev"             //组播
    case InitDevByIP    = "initDevByIP"         //单播
}

@objc public enum CodeType: Int {
    case Success = 200         //成功
    case ParseQRCodeFail = 201         //二维码解析失败
    case ConnectCloudTimeOut = 202         //超时
    case FindDevFail = 203         //局域网搜索不到设备
    case ConnectAPFail = 204         //连接设备热点失败
    case BindByMe = 205         //被自己绑定
    case BingByOther = 206         //被别人绑定
    case InputScError = 207         //sc码输入错误
    case BoxExisted = 208         //已添加其它盒子
    case BoxOffline = 209         //乐盒不在线
    case OtherCode = 500         //5其他错误
}

@objc public class LCAddDeviceLogModel: NSObject {

    //var requestid : String = ""
    
    var bindDeviceType: StartAddType = StartAddType.QRCode
    
    @objc public var inputData: String = ""
    
    @objc public var did: String = ""                       //SN:序列号
    
    @objc public let time: String =  LCClientEventLogHelper.shareInstance().getCurrentSystemTimeMillis()
    
    @objc public var res: String = ResType.Success.rawValue
    
    @objc public var errCode: Int = CodeType.Success.rawValue
    
    @objc public var dese: String = DescType.Success.rawValue
    
    @objc public var type: String = InitType.InitDev.rawValue
    
    @objc public var method: String = ""
    
	@objc public var deviceInfo: LCDeviceInfoLogModel = LCDeviceInfoLogModel()
	
    //只可读，用于外部获取数据
    @objc public let resFail: String = ResType.Fail.rawValue
    
    @objc public let initDev: String = InitType.InitDev.rawValue
    
    @objc public let initDevByIP: String = InitType.InitDevByIP.rawValue
}

