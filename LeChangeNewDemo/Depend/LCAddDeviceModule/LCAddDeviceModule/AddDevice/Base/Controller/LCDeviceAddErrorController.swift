//
//  Copyright © 2020 dahua. All rights reserved.
//

import UIKit

class LCDeviceAddErrorController: DHErrorBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig ? "device_manager_network_config".lc_T : "add_device_title".lc_T
    }

    // MARK: - DHAddBaseVCProtocol
    
    override func leftActionType() -> DHAddBaseLeftAction {
        return .back
    }
    
    override func isRightActionHidden() -> Bool {
        return false
    }
    
    // MARK: - DHErrorBaseVCProtocol
    
    override func errorImageName() -> String {
        return "adddevice_icon_hotspotexplain_fail"
    }
    
    override func errorContent() -> String {
        // todo: word
        return "如您自动连接失败，请尝试打开wifi列表，不保存密码，尝试重新输入密码".lc_T
    }
    
    override func icConfirmHidden() -> Bool {
        return true
    }
    
    override func isQuitHidden() -> Bool {
        return true
    }
}
