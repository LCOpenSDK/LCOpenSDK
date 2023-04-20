//
//  Copyright © 2020 Imou. All rights reserved.
//

import UIKit

class LCWifiInfoExplainController: LCErrorBaseViewController {

    public var myTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myTitle != "" {
            title = myTitle
        }
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
        return "adddevice_icon_wifiexplain_choosewifi"
    }
    
    override func errorContent() -> String {
        return "special_symbols_such_as_facial_expressions".lc_T()
    }
    
    override func icConfirmHidden() -> Bool {
        return true
    }
    
    override func isQuitHidden() -> Bool {
        return true
    }

}
