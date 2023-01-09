//
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit
import LCBaseModule.LCModule

@objc public class LCAddDeviceModule: NSObject, LCModuleProtocol {

	public func moduleInit() {
		loadCustomClass()
		registerQRScanVC()
		registerOfflineWifiConfig()
		registerOfflineWifiConfigByDeviceId()
		registerOfflineWifiConfigHelper()
		registerOMSConfigManager()
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

	
	func registerOfflineWifiConfig() {
		LCRouter.registerURLPattern(RouterUrl_AddDevice_OfflineWifiConfig) { (routerParameters) -> Any? in
			
			//进入前先重置已保存的信息
			LCAddDeviceManager.sharedInstance.reset()
			LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig = true
			
			//开启局域网搜索功能
			LCNetSDKSearchManager.sharedInstance().startSearch()
			
			if let params = routerParameters as? [String: Any], let dicUserInfo = params[LCRouterParameterUserInfo] as? [String: Any] {
				if let device = dicUserInfo["deviceInfo"] as? LCUserDeviceBindInfo {
					LCAddDeviceManager.sharedInstance.setup(deviceInfo: device)
					
					// 离线配网增加SC
					if let ability = device.ability {
						let abilities: [String] = ability.split(separator: ",").compactMap { "\($0)" }
						LCAddDeviceManager.sharedInstance.isSupportSC = abilities.enumerated().contains { (_, item) -> Bool in
							return item.lowercased() == "SCCode".lowercased()
						}
					}
					
				} else {
					LCAddDeviceManager.sharedInstance.supportConfigModes = [.wifi, .wired]
				}
				
				if let marketModel = dicUserInfo["deviceMarketModel"] as? String {
					LCAddDeviceManager.sharedInstance.deviceMarketModel = marketModel
					
					//更新引导信息
					//LCOMSConfigManager.sharedManager.checkUpdateIntrodution(byMarketModel: marketModel)
				}

				if let deviceId = dicUserInfo["deviceId"] as? String {
					LCAddDeviceManager.sharedInstance.deviceId = deviceId
				}
                
                if let scCode = dicUserInfo["scCode"] as? String {
                    LCAddDeviceManager.sharedInstance.initialPassword = scCode
                }
			}
			
			//根据类型进入不同的模式
			let controller = self.parserNetConfigMode(modes: LCAddDeviceManager.sharedInstance.supportConfigModes)
			return controller
		}
	}
	
	func registerOfflineWifiConfigByDeviceId() {
		LCRouter.registerURLPattern(RouterUrl_AddDevice_OfflineWifiConfigByDeviceId, toHandler: { routerParameters in
			if let dicUserInfo = routerParameters?[LCRouterParameterUserInfo] as? [String: Any] {
				guard let deviceId = dicUserInfo["deviceId"] as? String else {
					return
				}

				//进入前先重置已保存的信息
				LCAddDeviceManager.sharedInstance.reset()
				LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig = true

				//开启局域网搜索功能
				LCNetSDKSearchManager.sharedInstance().startSearch()

				//更新引导信息
				let marketModel = dicUserInfo["deviceMarketModel"] as? String
				if marketModel != nil {
					LCAddDeviceManager.sharedInstance.deviceMarketModel = marketModel
					LCOMSConfigManager.sharedManager.checkUpdateIntrodution(byMarketModel: marketModel!)
				}

                if let scCode = dicUserInfo["scCode"] as? String {
                    LCAddDeviceManager.sharedInstance.initialPassword = scCode
                }

				// 查询设备信息
				LCProgressHUD.show(on: nil)
                let productId = dicUserInfo["productId"] as? String
                
				LCAddDeviceManager.sharedInstance.deviceId = deviceId
                LCAddDeviceManager.sharedInstance.productId = productId
                
                LCAddDeviceManager.sharedInstance.getUnBindDeviceInfo(deviceId: deviceId, productId: productId, qrModel: nil, ncCode: nil, marketModel: marketModel, imeiCode: nil, success: { deviceInfo, _ in
					LCProgressHUD.hideAllHuds(nil)
					let controller = self.parserNetConfigMode(modes: deviceInfo.lc_netConfigModes())
					let naviVc = dicUserInfo["navigation"] as? UINavigationController
					naviVc?.pushViewController(controller, animated: true)
				}) { error in
					LCProgressHUD.hideAllHuds(nil)
                    error.showTips()
					print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder))::")
				}
			}
		})
	}
	
	// MARK: Register Manager
	func registerOMSConfigManager() {
		LCModule.registerService(LCOMSConfigManagerProtocol.self, implClass: LCOMSConfigManager.self)
	}
	
	// MARK: OfflineWifiConfig
	private func registerOfflineWifiConfigHelper() {
		//加载海外离线配网功能
		if let cls = NSClassFromString("LCOverseasOfflineWifiConfig") {
			LCModule.registerService(LCOfflineWifiConfigProtocol.self, implClass: cls)
		}
        
        if let cls = NSClassFromString("LCOfflineWifiConfig") {
			LCModule.registerService(LCOfflineWifiConfigProtocol.self, implClass: cls)
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

    
	private func parserNetConfigMode(modes: [LCNetConfigMode]) -> UIViewController {
		var controller: UIViewController
		let manager = LCAddDeviceManager.sharedInstance
        
//		if modes.contains(.nbIoT) {
//			manager.netConfigMode = .nbIoT
//			if manager.imeiCode.count == 0 {
//				controller = LCInputIMEIViewController.storyboardInstance()
//			} else {
//				controller = LCNBCheckViewController()
//			}
//		} else if modes.contains(.local) {
//			manager.netConfigMode = .local
//			controller = LCLocalNetGuideViewController()
//		} else if modes.contains(.simCard) {
        
//		} else
        if modes.contains(.softAp) {
			manager.netConfigMode = .softAp
			let vc = LCApGuideViewController()
			controller = vc
		} else if modes.contains(.wifi) {
			manager.netConfigMode = .wifi
			controller = LCPowerGuideViewController()
        } else if modes.contains(.wired) {
            manager.netConfigMode = .wired
            controller = LCPowerGuideViewController()
        } else {
			controller = LCPowerGuideViewController()
			manager.netConfigMode = .wifi
		}
		
		return controller
	}

}
