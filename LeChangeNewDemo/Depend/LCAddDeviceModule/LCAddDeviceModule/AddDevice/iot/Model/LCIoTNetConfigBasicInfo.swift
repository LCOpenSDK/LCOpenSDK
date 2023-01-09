//
//  LCIoTNetConfigBasicInfo.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/20.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit

public class LCIoTNetConfigBasicInfo: NSObject {
    // 设备型号代码
    @objc open var pid = ""
    // 设备序列号
    @objc open var sn = ""
    // 设备安全码
    @objc open var sc = ""
    //是否有sn码
    @objc open var snVisible:Bool = true
    // 信任标志
    @objc open var token: String?
    //设备名称
    @objc open var deviceName:String?
    
    /*  在获取设备基本信息协议和设备登录协议中，增加serviceversion字段（格式为Vx.x.x）。
     App调用配置云平台注册地址接口前，必须先判断serviceversion，只有serviceversion字段存在，并且不低于版本V1.3.0时，才能调用此接口
    */
    @objc var serviceversion: String?
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    //拼接获取设备名称
//    func getDeviceName() -> String {
//        let subSN = sn.substring(fromIndex: sn.length-4)
//        return pid + subSN
//    }
}
