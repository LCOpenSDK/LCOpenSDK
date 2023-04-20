//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	手机与设备处于同一局域网提示

import UIKit
import LCBaseModule
import AFNetworking

class LCSameNetworkViewController: LCGuideBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		adjustConstraint()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private func adjustConstraint() {
		guideView.updateTopImageViewConstraint(top: 0, width: 375, maxHeight: 300)
	}
	
	// MARK: LCAddBaseVCProtocol
//    override func rightActionType() -> [LCAddBaseRightAction] {
//        var actions: [LCAddBaseRightAction] = [.restart]
//        if LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wifi) {
//            actions.append(.switchToWireless)
//        }
//        
//        return actions
//    }

	// MARK: LCGuideBaseVCProtocol
	override func tipText() -> String? {
		return "add_device_same_network_tip".lc_T()
	}
	
	override func tipImageName() -> String? {
		return "adddevice_samenet"
	}
	
	override func tipImageUrl() -> String? {
		return nil
	}

	override func isCheckHidden() -> Bool {
		return false
	}
	
	override func isDetailHidden() -> Bool {
		return true
	}
	
	override func doNext() {
		if LCNetWorkHelper.sharedInstance().emNetworkStatus == AFNetworkReachabilityStatus.reachableViaWiFi.rawValue {
			if LCAddDeviceManager.sharedInstance.isSupportSC {
				basePushToConnectCloudVC()
			} else {
				//跳转设备初始化界面
				basePushToInitializeSearchVC()
			}
		} else {
			LCProgressHUD.showMsg("add_devices_smartconfig_msg_no_wifi".lc_T())
		}
		
	}
}
