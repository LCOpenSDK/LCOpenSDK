//
//  Copyright © 2018 Imou. All rights reserved.
//

import Foundation

class LCWiFiConnectOnlinePresenter: ILCWiFiConnectOnlinePresenter {
 
    public var successHandler: (() -> (Void))?
    var wifiStatus: LCWifiInfo?  //wifi信息
    var deviceId: String?
    weak var container: LCWifiConnectOnlineVC?
    
    func setContainer(container: LCWifiConnectOnlineVC) {
        self.container = container
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init(connectWifiInfo: LCWifiInfo, deviceId: String) {
        self.wifiStatus = connectWifiInfo
        self.deviceId = deviceId
    }
    
    
    // MARK: LCWifiPasswordPresenterProtocol
    func updateContainerViewByWifiInfo() {
        
        if let wifiName = wifiStatus?.ssid {
            self.container?.nextButton.lc_enable = true
            self.container?.wifiNameLabel.text = wifiName
            
            //【*】直接从保存的密码取：如果长度大于0，选中check，并填充密码
            if let password = LCUserManager.shareInstance().ssidPwd(by: self.container?.wifiNameLabel.text), password.count > 0 {
                self.container?.checkButton.isSelected = true
                self.container?.passwordInputView.textField.text = password
            } else {
                self.container?.checkButton.isSelected = false
                self.container?.passwordInputView.textField.text = nil
            }
        } else {
            self.container?.nextButton.lc_enable = false
            self.container?.wifiNameLabel.text = ""
            self.container?.passwordInputView.textField.text = ""
        }
    }
    
    func setupSupportView() {
        container?.supportView.isHidden = true
		container?.checkWidthConstraint.constant = 250
    }
    
    func nextStepAction(wifiSSID: String, wifiPassword: String?) {

        var password: String?
        if let text = self.container?.passwordInputView.textField.text,
            text.count > 0 {
            password = self.container?.passwordInputView.textField.text
        }
        

		//国内需求变更：连接后3s toast提示 WIFI连接中，请稍后刷新查看
        let connectSession = LCWifiConnectSession()
        connectSession.bssid = wifiStatus?.bssid ?? ""
        connectSession.ssid = wifiStatus?.ssid ?? ""
        connectSession.linkEnable = LCLinkHandle(rawValue: LCLinkHandle.RawValue(truncating: NSNumber(booleanLiteral: true)))
        connectSession.password = password ?? ""
        
        LCDeviceHandleInterface.controlDeviceWifi(for: deviceId ?? "", connestSession: connectSession, success: {
            print("NetworkSettings：",Date.init(),"\(#function):: 连接成功  password：\(connectSession.password),bssid：\(connectSession.bssid),linkEnable：\(connectSession.linkEnable),ssid：\(connectSession.ssid)")
        }) { (error) in
            print("NetworkSettings：",Date.init(),"\(#function):: 连接失败 password：\(connectSession.password),bssid：\(connectSession.bssid),linkEnable：\(connectSession.linkEnable),ssid：\(connectSession.ssid)")
        }
        LCProgressHUD.showMsg("device_manager_wifi_connetting_tip".lc_T(), duration: 3.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.container?.navigationController?.popViewController(animated: true)
            
        }
        print("NetworkSettings：",Date.init(),"\(#function)::尝试连接WiFi:",connectSession.ssid,connectSession.password)
    }
}
