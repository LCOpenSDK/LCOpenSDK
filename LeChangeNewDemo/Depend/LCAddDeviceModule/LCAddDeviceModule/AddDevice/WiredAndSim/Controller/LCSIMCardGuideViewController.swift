//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	SIM卡：引导页

import UIKit

class LCSIMCardGuideViewController: LCGuideBaseViewController {

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
	
	// MARK: LCGuideBaseVCProtocol
	override func tipText() -> String? {
		return "add_device_confirm_power_and_sim".lc_T
	}
	
	override func tipImageName() -> String? {
		return "adddevice_netsetting_sim"
	}
	
	override func isDetailHidden() -> Bool {
		return true
	}
	
	override func checkText() -> String? {
		return "add_device_confirm_insert_sim".lc_T
	}
	
	override func doNext() {
		//SIM卡添加直接进入连接云平台
		basePushToConnectCloudVC()
	}
}
