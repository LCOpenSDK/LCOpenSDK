//
//  Copyright © 2018年 Imou. All rights reserved.
//

import LCBaseModule.LCModule


// gatewayId：从网关点击进入扫描，需要传入选中的网关id
let RouterUrl_AddDevice_QRScanVC = "/lechange/addDevice/qrScanVC"

/// Hub添加配件（电池相机），参数说明 ["deviceMarketModel": xxxxx]
let RouterUrl_AddDevcie_HubPairAccessory = "/lechange/addDevice/hubPairAccessory"

/// 离线配网流程， 参数说明 [ "deviceId": xxxx, "deviceMarketModel": xxxxx, "navigation": "导航控制器"]
let RouterUrl_AddDevice_OfflineWifiConfigByDeviceId = "/lechange/adddevice/offlineWifiConfigByDeviceId"

/// 在线设备配网流程， 参数 []
let RouterUrl_Device_OnlineWifiConfig = "/lechange/adddevice/onlineWifiConfig"

/// 小微首页扫码添加设备， 参数 ["codeStr": "设备二维码"]
let RouterUrl_AddDevice_SMBDeviceInfo = "/lechange/addDevice/smbDeviceInfo"
