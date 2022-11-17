//
//  Copyright © 2018年 Imou. All rights reserved.
//	离线配网完成操作

import LCBaseModule.LCModule

@objc public protocol LCOfflineWifiConfigProtocol: LCServiceProtocol {
	
	/// 根据设备id和设备密码更新服务端的设备密码
	///
	/// - Parameters:
	///   - deviceId: 设备id
	///   - devicePassword: 设备密码
	func updateDeviceInfo(deviceId: String, byPassword devicePassword: String)
	
	/// 保存设备密码至本地缓存
	///
	/// - Parameters:
	///   - deviceId: 设备id
	///   - password: 设备密码
	func savePasswordInCache(deviceId: String, password: String)
	
	/// 成功后跳转处理：海外至主页
	func backToMainController()
}

