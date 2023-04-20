//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

class LCWiFiUnsupportVC: LCErrorBaseViewController {
    
    public var myTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myTitle != "" {
            title = myTitle
        }
        // Do any additional setup after loading the view.
        errorView.updateTopImageViewConstraint(top: 5, width: 255, height: 255)
        errorView.titleLabel.textAlignment = .left
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - LCAddBaseVCProtocol
    override func leftActionType() -> LCAddBaseLeftAction {
        return .back
    }
    
    override func isRightActionHidden() -> Bool {
		return myTitle.count > 0
    }
    
    // MARK: - LCErrorBaseVCProtocol
    override func errorImageName() -> String {
        return "adddevice_icon_wifiexplain"
    }
    
    override func errorContent() -> String {
        return "add_device_tip_not_support_5g_1".lc_T() + "\n\n" + "add_device_tip_not_support_5g_2".lc_T()
    }
    
    override func icConfirmHidden() -> Bool {
        return true
    }
    
    override func isQuitHidden() -> Bool {
        return true
    }
}
