//
//  LCBluetoothDeviceModel.swift
//  LCAddDeviceModule
//
//  Created on 2026/1/22.
//  Copyright © 2026 Imou. All rights reserved.
//

import Foundation

/// 蓝牙设备模型
@objcMembers public class LCBluetoothDeviceModel: NSObject {
    /// 产品ID
    public var productId: String = ""
    
    /// 设备ID（序列号）
    public var deviceId: String = ""
    
    /// 蓝牙名称（设备序列号后四位）
    public var bluetoothName: String = ""
    
    /// 显示名称：PID-蓝牙名称
    public var displayName: String {
        return "\(productId)-\(bluetoothName)"
    }
    
    /// 是否被选中
    public var isSelected: Bool = false
    
    public override init() {
        super.init()
    }
    
    public init(productId: String, deviceId: String, bluetoothName: String) {
        self.productId = productId
        self.deviceId = deviceId
        self.bluetoothName = bluetoothName
        super.init()
    }
}
