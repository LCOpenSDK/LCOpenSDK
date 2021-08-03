//
//  Copyright © 2018年 dahua. All rights reserved.
//

import LCBaseModule.DHModule


// gatewayId：从网关点击进入扫描，需要传入选中的网关id
let RouterUrl_AddDevice_QRScanVC = "/lechange/addDevice/qrScanVC"

/// Hub添加配件（电池相机），参数说明 ["deviceMarketModel": xxxxx]
let RouterUrl_AddDevcie_HubPairAccessory = "/lechange/addDevice/hubPairAccessory"

/// 【暂时未实现】离线配网流程, 参数说明 ["deviceInfo": DHUserBindDeviceInfo, "deviceMarketModel": xxxxx, "deviceId": xxxx]
let RouterUrl_AddDevice_OfflineWifiConfig = "/lechange/adddevice/offlineWifiConfig"

/// 离线配网流程， 参数说明 [ "deviceId": xxxx, "deviceMarketModel": xxxxx, "navigation": "导航控制器"]
let RouterUrl_AddDevice_OfflineWifiConfigByDeviceId = "/lechange/adddevice/offlineWifiConfigByDeviceId"

/// 在线设备配网流程， 参数 []
let RouterUrl_Device_OnlineWifiConfig = "/lechange/adddevice/onlineWifiConfig"

/// 小微首页扫码添加设备， 参数 ["codeStr": "设备二维码"]
let RouterUrl_AddDevice_SMBDeviceInfo = "/lechange/addDevice/smbDeviceInfo"

// MARK: DHOMSConfigManagerProtocol
@objc public protocol DHOMSConfigManagerProtocol: DHServiceProtocol {

	/// 清除OMS缓存
	@objc func clearOMSCache()
	
	/// 获取OMS缓存路径
	@objc func cacheFolderPath() -> String
	
	/// 按市场型号检查/更新引导信息
	@objc func checkUpdateIntrodution(byMarketModel model: String)
	
	/// 检查/更新设备型号
	@objc func checkUpdateDeviceModels()
	
	/// 预加载部分型号
	@objc func preloadIntroductions()
}
