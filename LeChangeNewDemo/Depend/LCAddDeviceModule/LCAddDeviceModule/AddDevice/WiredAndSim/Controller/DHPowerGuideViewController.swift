//
//  Copyright © 2018年 Imou. All rights reserved.
//	电源引导页：如果此时搜索到了设备，直接走有线添加

import UIKit
import CoreLocation
import LCBaseModule
import AFNetworking

class LCPowerGuideViewController: LCGuideBaseViewController {
	
	private lazy var locationManager: CLLocationManager = {
		let location = CLLocationManager()
		return location
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        adjustConstraint()
        
        addDeviceStartLog()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 由于无线/有线添加过程中，会进行切换，不会重新创建controller，这里使用didAppear处理

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func adjustConstraint() {
		let width = min(view.bounds.width, 375)
		let height = 300 * width / 375
		guideView.updateTopImageViewConstraint(top: 0, width: width, maxHeight: height)
	}
	
	private func pushToInitializeSearchVC() {
		let controller = LCInitializeSearchViewController.storyboardInstance()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: LCAddBaseVCProtocol
	override func rightActionType() -> [LCAddBaseRightAction] {
		return  [.restart]
	}
	
	// MARK: LCGuideBaseVCProtocol
	override func tipText() -> String? {
		return "add_device_plug_power".lc_T
	}
	
	override func tipImageName() -> String? {
		return "adddevice_netsetting_power"
	}
	
	override func isCheckHidden() -> Bool {
		return true
	}
	
	override func isDetailHidden() -> Bool {
		return true
	}
	
	override func doNext() {
		//【*】iOS13兼容：点一步，如果是WIFI配网，则判断
		if #available(iOS 13.0, *), LCAddDeviceManager.sharedInstance.netConfigMode == .wifi {
			let status = CLLocationManager.authorizationStatus()
            if (status == .notDetermined) || (status == .restricted) {
				//申请权限
				locationManager.requestWhenInUseAuthorization()
			} else if status == .denied {
				//被拒绝后，重新申请
				LCSetJurisdictionHelper.setJurisdictionAlertView("mobile_common_permission_apply".lc_T, message: "mobile_common_permission_explain_access_location_usage".lc_T)
			} else {
				//有位置访问权限，跳转下一步
				goNextStep()
			}
		} else {
			goNextStep()
		}
	}
	
	private func goNextStep() {
		//【*】局域网搜索到了设备：不需要初始化的，进入连接云平台；需要初始化的，进入初始化流程
		//【*】局域网搜索不到设备：进入配网流程
		if let device = LCAddDeviceManager.sharedInstance.getLocalDevice() {
			
			LCAddDeviceManager.sharedInstance.netConfigMode = .wired
			
			//【*】不需要初始化：支持sc码的设备、已经初始化的设备、没有初始化能力集的设备
			if LCAddDeviceManager.sharedInstance.isSupportSC ||
				device.deviceInitStatus == .init ||
				device.deviceInitStatus == .noAbility {
				self.basePushToConnectCloudVC(devicePassword: nil)
			} else {
				self.pushToInitializeSearchVC()
			}
		} else {
			let netConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
			if netConfigMode == .wired {
				let plugVc = LCPlugNetGuideViewController()
				self.navigationController?.pushViewController(plugVc, animated: true)
				
			} else if netConfigMode == .wifi {
				if LCNetWorkHelper.sharedInstance().emNetworkStatus == AFNetworkReachabilityStatus.reachableViaWiFi.rawValue {
					let passwordVc = LCWifiPasswordViewController.storyboardInstance()
					let presenter = LCWifiPasswordPresenter(container: passwordVc)
					passwordVc.setup(presenter: presenter)
					self.navigationController?.pushViewController(passwordVc, animated: true)
					
				} else {
					let plugVc = LCWifiCheckViewController()
					self.navigationController?.pushViewController(plugVc, animated: true)
				}
			}
		}
	}
    
    private func addDeviceStartLog() {
        let result = "{SN: \(LCAddDeviceManager.sharedInstance.deviceId)，deviceModelName: \(LCAddDeviceManager.sharedInstance.deviceModel)}"
        let model = LCAddDeviceLogModel()
        model.bindDeviceType = StartAddType.NetworkConfig
        model.inputData = result
        LCAddDeviceLogManager.shareInstance.addDeviceStartLog(model: model)
    }
}
