//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	输入5次密码后，设备被锁定

import UIKit

class LCDeviceLockViewController: LCErrorBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let height = 300 * lc_screenWidth / 375
		errorView.updateTopImageViewConstraint(top: 0, width: lc_screenWidth, height: height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	// MARK: LCErrorBaseVCProtocol
	override func errorImageName() -> String {
		return "adddevice_netsetting_power"
	}
	
	override func errorContent() -> String {
		return "add_device_device_locked_please_reboot".lc_T()
	}
	
	override func icConfirmHidden() -> Bool {
		return false
	}
	
	override func isQuitHidden() -> Bool {
		return true
	}
}
