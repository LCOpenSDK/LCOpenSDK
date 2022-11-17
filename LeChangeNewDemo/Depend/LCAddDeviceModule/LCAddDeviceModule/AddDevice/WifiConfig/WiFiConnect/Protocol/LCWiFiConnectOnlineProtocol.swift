//
//  Copyright © 2018 Imou. All rights reserved.
//

import Foundation

protocol ILCWiFiConnectOnlinePresenter {
    func setContainer(container: LCWifiConnectOnlineVC)
    func updateContainerViewByWifiInfo()
    func setupSupportView()
    func nextStepAction(wifiSSID: String, wifiPassword: String?)
}

protocol ILCWiFiConnectOnlineContainer {
    
    
}

