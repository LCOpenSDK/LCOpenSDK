//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit
import LCBaseModule.LCModule

class LCAddFAQViewController: LCAddBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Device_AddDevice_Add_Help".lc_T()
		setupWebVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	public func setupWebVC() {

	}
	
	// MARK: - LCAddBaseVCProtocol
	override func isRightActionHidden() -> Bool {
		return true
	}
}
