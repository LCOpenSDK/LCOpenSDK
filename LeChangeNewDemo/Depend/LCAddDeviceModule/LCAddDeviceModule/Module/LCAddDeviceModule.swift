//
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit
import LCBaseModule.LCModule

@objc public class LCAddDeviceModule: NSObject, LCModuleProtocol {

	public func moduleInit() {
		loadCustomClass()
		registerQRScanVC()
		registerOfflineWifiConfigByDeviceId()
        registerOnlineWifiConfig()
	}
	
	public func moduleCustomEvent(_ eventname: String!, userInfo: [AnyHashable: Any]! = [:]) {
		
	}
	
	// MARK: - Load Custom Class
	func loadCustomClass() {
		//Unknown class xxxx in Interface Builder file
		print(" \(Date()) \(NSStringFromClass(self.classForCoder))::Load \(LCAutoKeyboardView.classForCoder())...")
		print(" \(Date()) \(NSStringFromClass(self.classForCoder))::Load \(LCCycleTimerView.classForCoder())...")
	}
	
	// MARK: Register Router
	func registerQRScanVC() {
        LCPermissionHelper.requestCameraPermission { granted in
            if granted {
                LCRouter.registerURLPattern(RouterUrl_AddDevice_QRScanVC) { (routerParameters) -> Any? in
                    let controller = LCQRScanViewController.storyboardInstance()
                    //进入前先重置已保存的信息
                    LCAddDeviceManager.sharedInstance.reset()
                    
                    if let params = routerParameters as? [String: Any], let dicUserInfo = params[LCRouterParameterUserInfo] as? [String: Any] {
                        if let gatewayId = dicUserInfo["gatewayId"] as? String {
                            LCAddDeviceManager.sharedInstance.gatewayId = gatewayId
                            LCAddDeviceManager.sharedInstance.gatewayIdNeedReset = false
                        }
                    }
                    return controller
                }
            }
        }
	}

    // MARK: 在线设备配网
    private func registerOnlineWifiConfig() {
        LCRouter.registerURLPattern(RouterUrl_Device_OnlineWifiConfig) { (routerParameters) -> Any? in
            if let vc = UIStoryboard.lc_vc(storyboardName: "AddDevice", vcIdentifier: "LCWiFiConfigVC", bundle: Bundle.lc_addDeviceBundle()) as? LCWiFiConfigVC {
                if let params = routerParameters as? [String: Any], let dicUserInfo = params[LCRouterParameterUserInfo] as? [String: Any] {
                    
                    if let deviceId = dicUserInfo["deviceId"] as? String {
                        vc.deviceId = deviceId
                    }
                    
                    if let wifiTransferMode = dicUserInfo["wifiTransferMode"] as? String {
                        LCAddDeviceManager.sharedInstance.isSupport5GWifi = wifiTransferMode.lc_caseInsensitiveContain(string: "5Ghz")
                    }
                }
                
                return vc
            }
            return nil
        }
    }
    
	func registerOfflineWifiConfigByDeviceId() {
		LCRouter.registerURLPattern(RouterUrl_AddDevice_OfflineWifiConfigByDeviceId) { (routerParameters) -> Any? in
			if let dicUserInfo = routerParameters?[LCRouterParameterUserInfo] as? [String: Any] {
				guard let deviceId = dicUserInfo["deviceId"] as? String else {
					return
				}
				//进入前先重置已保存的信息
				LCAddDeviceManager.sharedInstance.reset()
				LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig = true
				// 更新引导信息
				let deviceModel = dicUserInfo["deviceModel"] as? String
				if deviceModel != nil {
					LCAddDeviceManager.sharedInstance.deviceMarketModel = deviceModel
				}
                // 支持SCCode能力
                if (dicUserInfo["ability"] as? String)?.contains("SCCode") == true {
                    LCAddDeviceManager.sharedInstance.isSupportSC = true
                    LCAddDeviceManager.sharedInstance.initialPassword = ""
                }
                
                if let softAPModeWifiName = dicUserInfo["softAPModeWifiName"] as? String {
                    LCAddDeviceManager.sharedInstance.softAPModeWifiName = softAPModeWifiName
                }
                
                if let softAPModeWifiVersion = dicUserInfo["softAPModeWifiVersion"] as? String {
                    LCAddDeviceManager.sharedInstance.softAPModeWifiVersion = softAPModeWifiVersion
                }

				// 查询设备信息
                let productId = dicUserInfo["productId"] as? String
				LCAddDeviceManager.sharedInstance.deviceId = deviceId
                LCAddDeviceManager.sharedInstance.productId = productId
                
                let model = LCUserDeviceBindInfo()
                model.deviceId = deviceId
                model.productId = productId
                model.wifiTransferMode = dicUserInfo["wifiConfigMode"] as? String
                model.wifiConfigMode = dicUserInfo["wifiConfigMode"] as? String
                model.deviceModel = dicUserInfo["deviceModel"] as? String
                model.status = dicUserInfo["status"] as? String
//                model.type = ""
                model.ability = dicUserInfo["ability"] as? String
                model.brand = dicUserInfo["brand"] as? String
                LCAddDeviceManager.sharedInstance.setup(deviceInfo: model)
                //进入配网流程标识
                let pid = LCAddDeviceManager.sharedInstance.productId ?? ""
                if pid.count > 0 {
                    if LCAddDeviceManager.sharedInstance.netConfigMode == .iotLan || LCAddDeviceManager.sharedInstance.netConfigMode == .iot4G {
                        return LCPowerGuideViewController.init()
                    } else {
                        let wifiVc = LCIoTWifiConfigViewController.storyboardInstance()
                        wifiVc.wifiConfigBlock = {[weak wifiVc] in // wifi 信息配置完成，跳转引导流程
                            if LCAddDeviceManager.sharedInstance.netConfigMode == .wifi {
                                let guideVc = LCApGuideViewController()
                                wifiVc?.navigationController?.pushViewController(guideVc, animated: true)
                            } else {
                                let guideVc = LCDeviceAddGuideViewController.init(productID: LCAddDeviceManager.sharedInstance.productId ?? "")
                                wifiVc?.navigationController?.pushViewController(guideVc, animated: true)
                            }
                        }
                        return wifiVc
                    }
                } else {
                    return self.parserNetConfigMode(modes: LCUserDeviceBindInfo.lc_netConfigModes(wifiConfigMode: "", isIotDevice: (productId != nil && productId!.length > 0)))
                }
			}
            return nil
		}
	}
    
	private func parserNetConfigMode(modes: [LCNetConfigMode]) -> UIViewController {
        let manager = LCAddDeviceManager.sharedInstance
        if manager.netConfigMode == .softAp || manager.netConfigMode == .lan || manager.netConfigMode == .iotLan || manager.netConfigMode == .iot4G || manager.netConfigMode == .soundWave || manager.netConfigMode == .soundWaveV2 || manager.netConfigMode == .smartConfig {
            return LCPowerGuideViewController()
        } else {
            let controller = LCWifiPasswordViewController.storyboardInstance()
            let presenter = LCWifiPasswordPresenter(container: controller)
            controller.setup(presenter: presenter)
            return controller
        }
	}

}
