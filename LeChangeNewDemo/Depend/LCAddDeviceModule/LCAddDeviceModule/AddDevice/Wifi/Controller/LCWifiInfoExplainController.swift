//
//  Copyright © 2020 dahua. All rights reserved.
//

import UIKit

class LCWifiInfoExplainController: DHErrorBaseViewController {

    public var myTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myTitle != "" {
            title = myTitle
        }
    }
    
    // MARK: - DHAddBaseVCProtocol
    
    override func leftActionType() -> DHAddBaseLeftAction {
        return .back
    }
    
    override func isRightActionHidden() -> Bool {
		return myTitle.count > 0
    }
    
    // MARK: - DHErrorBaseVCProtocol
    
    override func errorImageName() -> String {
        return "adddevice_icon_wifiexplain_choosewifi"
    }
    
    override func errorContent() -> String {
        return "如您的wifi名称中有表情等特殊符号，如🌹❤️😊❄️可能会导致您的设备无法正常连接，建议删除wifi名称内的特殊符号。".lc_T
    }
    
    override func icConfirmHidden() -> Bool {
        return true
    }
    
    override func isQuitHidden() -> Bool {
        return true
    }

}
