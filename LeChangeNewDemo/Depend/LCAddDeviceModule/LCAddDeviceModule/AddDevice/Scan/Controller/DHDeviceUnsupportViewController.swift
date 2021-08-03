//
//  Copyright © 2020 dahua. All rights reserved.
//

import UIKit

class DHDeviceUnsupportViewController: DHErrorBaseViewController {
	
	/// 是否返回到扫描界面
	var backToSacn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		errorView.updateTopImageViewConstraint(top: 70)
    }
    
    // MARK: DHAddBaseVCProtocol
	override func leftActionType() -> DHAddBaseLeftAction {
		return backToSacn ? .backToScan : .back
	}
	
	override func isRightActionHidden() -> Bool {
		return true
	}
	
	// MARK: DHErrorBaseVCProtocol
	override func errorImageName() -> String {
		return "adddevice_icon_device_default"
	}
	
	override func errorContent() -> String {
		return "add_devices_device_unsupport".lc_T
	}
	
	override func errorDescription() -> String? {
		return nil
	}
	
	override func icConfirmHidden() -> Bool {
		return true
	}
	
	
	override func isQuitHidden() -> Bool {
		return true
	}
}
