//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	WIFI配置：设备指示灯检查

import UIKit

class LCDeviceLightCheckViewController: LCAddBaseViewController, LCAddGuideViewDelegate {    
    @objc var productId: String = ""

    func guideView(view: LCAddGuideView, action: LCAddGuideActionType) {
        if action == .next {
            self.next()
        }
        if action == .detail {
            LCSheetGuideView(title: "add_device_network_config_guide_tips".lc_T(), message: "add_device_network_config_guide_alert".lc_T(), image: UIImage(lc_named: "adddevice_netsetting_guide_reset"), cancelButtonTitle: "Alert_Title_Button_Confirm1".lc_T()).show()
        }
    }
    
    private let guideView: LCAddGuideView = LCAddGuideView.xibInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        if LCAddDeviceManager.sharedInstance.netConfigMode != .iotBluetooth {
            self.setupNaviRightItem();
        }
        
        guideView.delegate = self
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        if LCAddDeviceManager.sharedInstance.netConfigMode == .iotBluetooth || LCAddDeviceManager.sharedInstance.netConfigMode == .soundWave || LCAddDeviceManager.sharedInstance.netConfigMode == .soundWaveV2 {
            guideView.topTipLabel.text = "add_device_network_config_guide".lc_T()
            guideView.descriptionLabel.text = "add_device_network_config_guide_light_alert".lc_T()
            guideView.detailButton.setTitle("add_device_network_config_guide_light_error".lc_T(), for: .normal)
            guideView.topImageView.image = UIImage(lc_named: "adddevice_netsetting_guide")
            if !NSString.lc_currentLanguageCode().contains("zh") {
                guideView.topImageView.image = UIImage(lc_named: "adddevice_netsetting_guide_en")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
    private func next() {
        if LCAddDeviceManager.sharedInstance.netConfigMode == .iotBluetooth {
            self.pushToBluetooth()
        }
        if LCAddDeviceManager.sharedInstance.netConfigMode == .soundWave || LCAddDeviceManager.sharedInstance.netConfigMode == .soundWaveV2 || LCAddDeviceManager.sharedInstance.netConfigMode == .smartConfig {
            self.pushToPhoneVolumeCheckVC()
        }
    }
    
	private func pushToPhoneVolumeCheckVC() {
		let controller = LCPhoneVolumeCheckViewController()
		self.navigationController?.pushViewController(controller, animated: true)
	}
    
    private func pushToBluetooth() {
        LCProgressHUD.show(on: self.view, tip: "device_bluetooth_distribution_network".lc_T())
        LCOpenSDK_Bluetooth.startAsyncBLEConfig(LCAddDeviceManager.sharedInstance.wifiSSID ?? "", wifiPwd: LCAddDeviceManager.sharedInstance.wifiPassword ?? "", productId: productId, deviceId: LCAddDeviceManager.sharedInstance.deviceId) { success, errorMessage in
            LCProgressHUD.hideAllHuds(self.view)
            if success {
                LCProgressHUD.showMsg("equipment_distribution_network_succeeded".lc_T())
                let controller = LCConnectCloudViewController.storyboardInstance()
                controller.deviceInitialPassword = LCAddDeviceManager.sharedInstance.initialPassword
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                LCProgressHUD.showMsg("device_distribution_network_failure_retry".lc_T() + (errorMessage ?? ""), duration: 5)
            }
        }
    }
	
	private func pushToResetDeviceVC() {
		let controller = LCResetDeviceViewController()
		controller.placeholderImage = LCIPCLightCheckDefault.imagename
		controller.resetContent = LCIPCLightResetDefault.operation
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: - LCAddBaseVCProtocol
	override func rightActionType() -> [LCAddBaseRightAction] {
		var actions: [LCAddBaseRightAction] = [.restart]
		if LCAddDeviceManager.sharedInstance.supportWired() {
			actions.append(.switchToWired)
		}
		return actions
	}
}
