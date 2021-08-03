//
//  Copyright © 2018 dahua. All rights reserved.
//

import Foundation

protocol IDHWiFiConnectOnlinePresenter {
    func setContainer(container: DHWifiConnectOnlineVC)
    func updateContainerViewByWifiInfo()
    func setupSupportView()
    func nextStepAction(wifiSSID: String, wifiPassword: String?)
}

protocol IDHWiFiConnectOnlineContainer {
    
    
}

