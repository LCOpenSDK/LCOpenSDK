//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit
import LCOpenSDKDynamic

protocol LCAPWifiPasswordPresenterProtocol {
    var container: LCAPWifiPasswordViewController? {
        set get
    }
    
    init(container: LCAPWifiPasswordViewController)
    
    func updateContainerViewByNetwork()

    func setupSupportView()
    
    func nextStepAction(wifiSSID: String, wifiPassword: String?)
}

class LCApWifiPasswordPresenter: NSObject, LCAPWifiPasswordPresenterProtocol {
	
    var container: LCAPWifiPasswordViewController?
	
	/// 设备密码
    var devicePassword: String = "admin"
	
	/// 软AP WIFI列表中选中的WIFI
	var wifiSSID: String = ""
	
	/// 软AP WIFI列表选中WIFI的加密模式
    var encryptionAuthority: Int = 0
	
	/// 软AP 连接WIFI时的网卡，eth2或wlan0
	var netcardName: String = "eth2"
    
    var scDeviceIsInited: Bool = false
    
    var serachedDevice: LCOpenSDK_SearchDeviceInfo?
    
    required init(container: LCAPWifiPasswordViewController) {
        self.container = container
    }
	
	// MARK: LCWifiPasswordPresenterProtocol
	func updateContainerViewByNetwork() {
		
		if self.container?.nextButton == nil {
			// 可能还没有创建
			return
		}
		
		//软AP的WIFI名称是从上级界面选中的
		self.container?.wifiNameLabel.text = wifiSSID
		
		//【*】直接从保存的密码取：如果长度大于0，选中check，并填充密码
		if let password = LCUserManager.shareInstance().ssidPwd(by: wifiSSID), password.count > 0 {
			self.container?.checkButton.isSelected = true
			self.container?.passwordInputView.textField.text = password
		} else {
			self.container?.checkButton?.isSelected = false
			self.container?.passwordInputView.textField.text = nil
		}
	}
	
    func setupSupportView() {
		
    }
    
    func nextStepAction(wifiSSID: String, wifiPassword: String?) {
        //连接wifi
        let device = self.serachedDevice
        guard device != nil else {
			LCProgressHUD.showMsg("add_device_connect_failed".lc_T())
            return
        }
        
        LCProgressHUD.show(on: self.container?.view)
        
        if true == LCAddDeviceManager.sharedInstance.isSupportSC && false == self.scDeviceIsInited {
            LCNetSDKHelper.startSoftAPConfig(wifiSSID, wifiPwd: wifiPassword, wifiEncry: Int32(self.encryptionAuthority), netcardName: self.netcardName, deviceIp: device!.ip, devicePwd: LCAddDeviceManager.sharedInstance.regCode, isSC: true, handler: { result in
                LCProgressHUD.hideAllHuds(self.container?.view)
                if result == 0 {
                    self.devicePassword = LCAddDeviceManager.sharedInstance.initialPassword
                    self.connectWifiSuccessProcess()
                }else{
                    LCProgressHUD.showMsg("distribution_network_failure_retry".lc_T())
                }
            }, timeout: 5000 * 2)
        } else {
            LCNetSDKHelper.loginWithHighLevelSecurity(byIp: device!.ip, port: Int(device!.port), username: "admin", password: devicePassword, success: { (handle) in
                let ssid = wifiSSID
                let pwd = wifiPassword
                LCNetSDKHelper.startSoftAPConfig(ssid, wifiPwd: pwd, wifiEncry: Int32(self.encryptionAuthority), netcardName: self.netcardName, deviceIp: device!.ip, devicePwd: self.devicePassword, isSC: false, handler: { result in
                    LCProgressHUD.hideAllHuds(self.container?.view)
                    if result == 0 {
                        self.devicePassword = LCAddDeviceManager.sharedInstance.initialPassword
                        self.connectWifiSuccessProcess()
                    }else{
                        LCProgressHUD.showMsg("distribution_network_failure_retry".lc_T())
                    }
                }, timeout: 5000 * 2)
            }) { (description) in
                LCProgressHUD.hideAllHuds(self.container?.view)
                LCProgressHUD.showMsg("add_device_connect_failed".lc_T())
            }
        }
    }
	
	private func connectWifiSuccessProcess() {
		//【*】新方案不区分p2p、非p2p，进入连接乐橙云平台界面
		//【*】其他设备，进入连接乐橙云平台界面
		self.container?.basePushToConnectCloudVC(devicePassword: devicePassword)
	}
}
