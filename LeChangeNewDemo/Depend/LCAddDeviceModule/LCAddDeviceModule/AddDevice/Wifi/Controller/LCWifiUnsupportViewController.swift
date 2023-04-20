//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

class LCWifiUnsupportViewController: LCErrorBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorView.updateTopImageViewConstraint(top: 20, width: 255, height: 255)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: LCAddBaseVCProtocol
	override func leftActionType() -> LCAddBaseLeftAction {
		return .back
	}
	
	override func isRightActionHidden() -> Bool {
		return false
	}

	// MARK: LCErrorBaseVCProtocol
	override func errorImageName() -> String {
		return "adddevice_fail_configurationfailure"
	}
	
	override func errorContent() -> String {
        
        return "add_device_device_not_support_5g".lc_T()
//        return "不支持5G WIFI情况的详细图文说明"
	}
	
	override func icConfirmHidden() -> Bool {
		return true
	}
	
	override func isQuitHidden() -> Bool {
		return true
	}
}
