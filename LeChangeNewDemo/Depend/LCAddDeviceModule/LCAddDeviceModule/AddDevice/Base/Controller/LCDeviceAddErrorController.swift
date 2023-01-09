//
//  Copyright © 2020 Imou. All rights reserved.
//

import UIKit

class LCDeviceAddErrorController: LCErrorBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig ? "device_manager_network_config".lc_T : "add_device_title".lc_T
    }

    // MARK: - LCAddBaseVCProtocol
    
    override func leftActionType() -> LCAddBaseLeftAction {
        return .back
    }
    
    override func isRightActionHidden() -> Bool {
        return false
    }
    
    // MARK: - LCErrorBaseVCProtocol
    
    override func errorImageName() -> String {
        return "adddevice_icon_hotspotexplain_fail"
    }
    
    override func errorContent() -> String {
        // todo: word
        return "connection_failure_prompt".lc_T
    }
    
    override func icConfirmHidden() -> Bool {
        return true
    }
    
    override func isQuitHidden() -> Bool {
        return true
    }
}
