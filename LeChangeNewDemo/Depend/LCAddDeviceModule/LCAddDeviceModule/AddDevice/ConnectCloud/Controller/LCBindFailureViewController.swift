//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

class LCBindFailureViewController: LCErrorBaseViewController {
	
	var imagename: String = "adddevice_fail_rest"
	
	var content: String? = ""
    
    var isExitAddDevice: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	// MARK: - LCErrorBaseVCProtocol
	override func errorImageName() -> String {
		return self.imagename
	}
	
	override func errorContent() -> String {
		return self.content ?? ""
	}
	
	override func icConfirmHidden() -> Bool {
		return false
	}
	
	override func isQuitHidden() -> Bool {
		return true
	}
	
	override func confirmText() -> String {
		return "common_confirm".lc_T()
	}
	
	override func doConfirm() {
        if isExitAddDevice {
            baseExitAddDevice(showAlert: false)
        } else {
            baseBackToAddDeviceRoot()
        }
	}
}
