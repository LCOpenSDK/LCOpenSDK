//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	插网线引导页

import UIKit
import LCBaseModule

class DHPlugNetGuideViewController: DHGuideBaseViewController {

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
		guideView.topImageView.contentMode = .scaleAspectFill
		guideView.updateTopImageViewConstraint(top: 0, width: view.bounds.width, maxHeight: 350)
	}
	
	// MARK: DHAddBaseVCProtocol
//    override func rightActionType() -> [DHAddBaseRightAction] {
//        var actions: [DHAddBaseRightAction] = [.restart]
//        if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wifi) {
//            actions.append(.switchToWireless)
//        }
//        
//        return actions
//    }

	// MARK: DHGuideBaseVCProtocol
	override func tipText() -> String? {
		return "add_device_plug_cable_to_device".lc_T
	}
	
	override func tipImageName() -> String? {
		return "adddevice_netsetting_networkcable"
	}
	
	override func isCheckHidden() -> Bool {
		return true
	}

	override func doNext() {
		// 【*】支持SC码的，直接进入云配置流程；不支持SC的，进入旧的局域网提示界面
		if DHAddDeviceManager.sharedInstance.isSupportSC {
			basePushToConnectCloudVC()
		} else {
			let sameNetworkVC = DHSameNetworkViewController()
			navigationController?.pushViewController(sameNetworkVC, animated: true)
		}
	}
}
