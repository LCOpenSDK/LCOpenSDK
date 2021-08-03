//
//  Copyright © 2018年 dahua. All rights reserved.
//

import UIKit
import LCBaseModule.DHModule

@objc public class LCAddDeviceModule: NSObject, DHModuleProtocol {

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
		//加载DHAutoKeyboardView，规避storyboard找不到该类的问题
		//Unknown class xxxx in Interface Builder file
		print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::Load \(DHAutoKeyboardView.classForCoder())...")
		print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::Load \(DHCycleTimerView.classForCoder())...")
	}
	
	// MARK: Register Router
	func registerQRScanVC() {
		DHRouter.registerURLPattern(RouterUrl_AddDevice_QRScanVC) { (routerParameters) -> Any? in
			let controller = DHQRScanViewController.storyboardInstance()
			
			//进入前先重置已保存的信息
			DHAddDeviceManager.sharedInstance.reset()
			
			if let params = routerParameters as? [String: Any], let dicUserInfo = params[DHRouterParameterUserInfo] as? [String: Any] {
				if let gatewayId = dicUserInfo["gatewayId"] as? String {
					DHAddDeviceManager.sharedInstance.gatewayId = gatewayId
					DHAddDeviceManager.sharedInstance.gatewayIdNeedReset = false
				}
			}
			return controller
		}
	}

	
	func registerOfflineWifiConfig() {
		DHRouter.registerURLPattern(RouterUrl_AddDevice_OfflineWifiConfig) { (routerParameters) -> Any? in
			
			//进入前先重置已保存的信息
			DHAddDeviceManager.sharedInstance.reset()
			DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig = true
			
			//开启局域网搜索功能
			DHNetSDKSearchManager.sharedInstance().startSearch()
			
			if let params = routerParameters as? [String: Any], let dicUserInfo = params[DHRouterParameterUserInfo] as? [String: Any] {
				if let device = dicUserInfo["deviceInfo"] as? DHUserDeviceBindInfo {
					DHAddDeviceManager.sharedInstance.setup(deviceInfo: device)
					
					// 离线配网增加SC
					if let ability = device.ability {
						let abilities: [String] = ability.split(separator: ",").compactMap { "\($0)" }
						DHAddDeviceManager.sharedInstance.isSupportSC = abilities.enumerated().contains { (_, item) -> Bool in
							return item.lowercased() == "SCCode".lowercased()
						}
					}
					
				} else {
					DHAddDeviceManager.sharedInstance.supportConfigModes = [.wifi, .wired]
				}
				
				if let marketModel = dicUserInfo["deviceMarketModel"] as? String {
					DHAddDeviceManager.sharedInstance.deviceMarketModel = marketModel
					
					//更新引导信息
					//DHOMSConfigManager.sharedManager.checkUpdateIntrodution(byMarketModel: marketModel)
				}

				if let deviceId = dicUserInfo["deviceId"] as? String {
					DHAddDeviceManager.sharedInstance.deviceId = deviceId
				}
                
                if let scCode = dicUserInfo["scCode"] as? String {
                    DHAddDeviceManager.sharedInstance.initialPassword = scCode
                }
			}
			
			//根据类型进入不同的模式
			let controller = self.parserNetConfigMode(modes: DHAddDeviceManager.sharedInstance.supportConfigModes)
			return controller
		}
	}
	
	func registerOfflineWifiConfigByDeviceId() {
		DHRouter.registerURLPattern(RouterUrl_AddDevice_OfflineWifiConfigByDeviceId, toHandler: { routerParameters in
			if let dicUserInfo = routerParameters?[DHRouterParameterUserInfo] as? [String: Any] {
				guard let deviceId = dicUserInfo["deviceId"] as? String else {
					return
				}

				//进入前先重置已保存的信息
				DHAddDeviceManager.sharedInstance.reset()
				DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig = true

				//开启局域网搜索功能
				DHNetSDKSearchManager.sharedInstance().startSearch()

				//更新引导信息
				let marketModel = dicUserInfo["deviceMarketModel"] as? String
				if marketModel != nil {
					DHAddDeviceManager.sharedInstance.deviceMarketModel = marketModel
					DHOMSConfigManager.sharedManager.checkUpdateIntrodution(byMarketModel: marketModel!)
				}

                if let scCode = dicUserInfo["scCode"] as? String {
                    DHAddDeviceManager.sharedInstance.initialPassword = scCode
                }

				// 查询设备信息
				LCProgressHUD.show(on: nil)
				DHAddDeviceManager.sharedInstance.deviceId = deviceId
				DHAddDeviceManager.sharedInstance.getDeviceInfo(deviceId: deviceId, qrModel: nil, ncCode: nil, marketModel: marketModel, imeiCode: nil, success: { deviceInfo, _ in
					LCProgressHUD.hideAllHuds(nil)
					let controller = self.parserNetConfigMode(modes: deviceInfo.dh_netConfigModes())
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
		DHModule.registerService(DHOMSConfigManagerProtocol.self, implClass: DHOMSConfigManager.self)
	}
	
	// MARK: OfflineWifiConfig
	private func registerOfflineWifiConfigHelper() {
		//加载海外离线配网功能
		if let cls = NSClassFromString("DHOverseasOfflineWifiConfig") {
			DHModule.registerService(DHOfflineWifiConfigProtocol.self, implClass: cls)
		}
        
        if let cls = NSClassFromString("LCOfflineWifiConfig") {
			DHModule.registerService(DHOfflineWifiConfigProtocol.self, implClass: cls)
		}
	}
    
    // MARK: 在线设备配网
    private func registerOnlineWifiConfig() {
        DHRouter.registerURLPattern(RouterUrl_Device_OnlineWifiConfig) { (routerParameters) -> Any? in
            if let vc = UIStoryboard.dh_vc(storyboardName: "AddDevice", vcIdentifier: "DHWiFiConfigVC", bundle: Bundle.dh_addDeviceBundle()) as? DHWiFiConfigVC {
                if let params = routerParameters as? [String: Any], let dicUserInfo = params[DHRouterParameterUserInfo] as? [String: Any] {
                    
                    if let deviceId = dicUserInfo["deviceId"] as? String {
                        vc.deviceId = deviceId
                    }
                    
                    if let wifiTransferMode = dicUserInfo["wifiTransferMode"] as? String {
                        DHAddDeviceManager.sharedInstance.isSupport5GWifi = wifiTransferMode.dh_caseInsensitiveContain(string: "5Ghz")
                    }
                }
                
                return vc
            }
            return nil
        }
    }

    
	private func parserNetConfigMode(modes: [DHNetConfigMode]) -> UIViewController {
		var controller: UIViewController
		let manager = DHAddDeviceManager.sharedInstance
        
		if modes.contains(.nbIoT) {
			manager.netConfigMode = .nbIoT
			if manager.imeiCode.count == 0 {
				controller = DHInputIMEIViewController.storyboardInstance()
			} else {
				controller = DHNBCheckViewController()
			}
		} else if modes.contains(.local) {
			manager.netConfigMode = .local
			controller = DHLocalNetGuideViewController()
		} else if modes.contains(.simCard) {
			manager.netConfigMode = .simCard
			controller = DHSIMCardGuideViewController()
		} else if modes.contains(.softAp) {
			manager.netConfigMode = .softAp
			let vc = DHApGuideViewController()
			controller = vc
		} else if modes.contains(.wifi) {
			manager.netConfigMode = .wifi
			controller = DHPowerGuideViewController()
        } else if modes.contains(.wired) {
            manager.netConfigMode = .wired
            controller = DHPowerGuideViewController()
        } else {
			controller = DHPowerGuideViewController()
			manager.netConfigMode = .wifi
		}
		
		return controller
	}

}
