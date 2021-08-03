//
//  Copyright © 2018 dahua. All rights reserved.
//

import Foundation

class DHWiFiConnectOnlinePresenter: IDHWiFiConnectOnlinePresenter {
 
    public var successHandler: (() -> (Void))?
    var wifiStatus: LCWifiInfo?  //wifi信息
    var deviceId: String?
    weak var container: DHWifiConnectOnlineVC?
    
    func setContainer(container: DHWifiConnectOnlineVC) {
        self.container = container
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init(connectWifiInfo: LCWifiInfo, deviceId: String) {
        self.wifiStatus = connectWifiInfo
        self.deviceId = deviceId
    }
    
    
    // MARK: DHWifiPasswordPresenterProtocol
    func updateContainerViewByWifiInfo() {
        
        if let wifiName = wifiStatus?.ssid {
            self.container?.nextButton.dh_enable = true
            self.container?.wifiNameLabel.text = wifiName
            
            //【*】直接从保存的密码取：如果长度大于0，选中check，并填充密码
            if let password = DHUserManager.shareInstance().ssidPwd(by: self.container?.wifiNameLabel.text), password.count > 0 {
                self.container?.checkButton.isSelected = true
                self.container?.passwordInputView.textField.text = password
            } else {
                self.container?.checkButton.isSelected = false
                self.container?.passwordInputView.textField.text = nil
            }
        } else {
            self.container?.nextButton.dh_enable = false
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
            
        }) { (error) in
            
        }
        LCProgressHUD.showMsg("device_manager_wifi_connetting_tip".lc_T, duration: 3.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.container?.navigationController?.popViewController(animated: true)
        }
    }
}
