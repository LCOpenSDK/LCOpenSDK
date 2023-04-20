//
//  DHAddDeviceModule.swift
//  LCIphoneAdhocIP
//
//  Created by iblue on 2018/6/1.
//  Copyright © 2018年 dahua. All rights reserved.
//

import UIKit
import DHModule

class DHAddDeviceModule: NSObject, DHModuleProtocol {

	func moduleInit() {
		self.registerQRScanVC()
		self.registerHubPairAccessoryVC()
		self.registerOfflineWifiConfig()
		self.registerOfflineWifiConfigByNetMode()
		self.registerOfflineWifiConfigHelper()
		self.registerOMSConfigManager()
		self.registerGatewayListHelper()
	}
	
	func moduleCustomEvent(_ eventname: String!, userInfo: [AnyHashable: Any]! = [:]) {
		
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
			DHAppStatistics.event(event: device_add)
			return controller
			
			//return self.testInitDevicePassword()
		}
	}
	
	func registerHubPairAccessoryVC() {
		DHRouter.registerURLPattern(RouterUrl_AddDevcie_HubPairAccessory) { (routerParameters) -> Any? in
			
			//进入前先重置已保存的信息
			DHAddDeviceManager.sharedInstance.reset()
			
			if let params = routerParameters as? [String: Any], let dicUserInfo = params[DHRouterParameterUserInfo] as? [String: Any] {
				if let marketModel = dicUserInfo["deviceMarketModel"] as? String {
					DHAddDeviceManager.sharedInstance.deviceMarketModel = marketModel
				}
			}
			
			let controller = DHHubLightCheckViewController()
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
	
	func registerOfflineWifiConfigByNetMode() {
		DHRouter.registerURLPattern(RouterUrl_AddDevice_OfflineWifiConfigByNetMode) { (routerParameters) -> Any? in
			
			//进入前先重置已保存的信息
			DHAddDeviceManager.sharedInstance.reset()
			DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig = true
			
			//开启局域网搜索功能
			DHNetSDKSearchManager.sharedInstance().startSearch()
			
			var controller: UIViewController = DHPowerGuideViewController()
			if let params = routerParameters as? [String: Any], let dicUserInfo = params[DHRouterParameterUserInfo] as? [String: Any] {
				if let modes = dicUserInfo["supportConfigModes"] as? [DHNetConfigMode] {
					DHAddDeviceManager.sharedInstance.supportConfigModes = modes
					controller = self.parserNetConfigMode(modes: modes)
				}
			}
			
			return controller
		}
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

	// MARK: 网关列表
	private func registerGatewayListHelper() {
		//加载海外获取网关列表
		if let cls = NSClassFromString("DHOverseasGatewayListHelper") {
			DHModule.registerService(DHGatewayListProtocol.self, implClass: cls)
		}
        
        if let cls = NSClassFromString("LCGatewayListHelper") {
            DHModule.registerService(DHGatewayListProtocol.self, implClass: cls)
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
	
	// MARK: Test
	func testApConnectCloud() -> UIViewController {
		let manager = DHAddDeviceManager.sharedInstance
		manager.netConfigMode = .softAp
		manager.deviceId = "4B00135PAZ7B83A"
		let controller = DHConnectCloudViewController.storyboardInstance()
		return controller
	}
	
	func testAccessory() -> UIViewController {
		let manager = DHAddDeviceManager.sharedInstance
		manager.netConfigMode = .wifi
		manager.isAccessory = true
		manager.deviceId = "2M06696PAN00005"
		let controller = DHSelectGatewayViewController.storyboardInstance()
		controller.accessoryId = manager.deviceId
		controller.accessoryType = "defence"
		return controller
	}
	
	func testInitDevicePassword() -> UIViewController {
		let manager = DHAddDeviceManager.sharedInstance
		manager.netConfigMode = .wifi
		manager.deviceId = "4C004D5PAG26A78"
		let controller = DHInitializePasswordViewController.storyboardInstance()
		return controller
	}
}
