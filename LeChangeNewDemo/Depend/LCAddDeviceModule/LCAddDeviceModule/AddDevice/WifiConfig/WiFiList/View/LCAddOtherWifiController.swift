//
//  Copyright © 2020 Imou. All rights reserved.
//

import UIKit
import LCOpenSDKDynamic

struct AddOtherWifiModel {
    var devicePassword: String
    var ip: String?
    var port: Int32
}

enum LCAddOtherWifiControllerStyle {
    case newWifi
    case changeWifi
}

class LCAddOtherWifiController: LCAddBaseViewController {
    public var searchedDevice: LCOpenSDK_SearchDeviceInfo?
	/// 设备密码：设备添加过程中获取 
    public var devicePassword: String = "admin"
    public var myTitle: String = "add_device_title".lc_T()
	
    // MARK: - life cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.vcStyle = .changeWifi
    }
    
    convenience init(deviceId: String) {
        self.init()
        self.deviceId = deviceId
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = myTitle
        loadSubview()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        nextBtn.lc_setRadius(viewHeight/2.0)
    }
    
    // MARK: private method
    
    private func loadSubview() {
        view.backgroundColor = UIColor.lccolor_c7()
        view.addSubview(nameView)
        nameView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(viewHeight)
            make.top.equalTo(topPadding)
        }
        
        nameView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameView).offset(leftPadding)
            make.centerY.equalTo(nameView)
        }
        
        nameView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(nameView).offset(70)
            make.right.equalTo(nameView).offset(-leftPadding24)
            make.centerY.equalTo(nameView)
            make.height.equalTo(40)
        }
        
        view.addSubview(passwordView)
        passwordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(viewHeight)
            make.top.equalTo(nameView.snp.bottom)
        }

        passwordView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(passwordView).offset(leftPadding)
            make.centerY.equalTo(passwordView)
        }

        passwordView.addSubview(passwordInputView)
        passwordInputView.snp.makeConstraints { (make) in
            make.left.equalTo(passwordView).offset(70)
            make.right.equalTo(passwordView).offset(-leftPadding24)
            make.centerY.equalTo(passwordView)
            make.height.equalTo(40)
        }

        view.addSubview(descBtn)
        descBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordView.snp.bottom).offset(topPadding)
            make.right.equalTo(view).offset(-leftPadding24)
            make.width.equalTo(190)
        }
        descBtn.isHidden = LCAddDeviceManager.sharedInstance.isSupport5GWifi
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(descBtn.snp.bottom).offset(50)
            make.left.equalTo(view).offset(leftPadding24)
            make.height.equalTo(viewHeight)
        }
    }
    
    @objc func descBtnClicked() {
        let supportVc = LCWiFiUnsupportVC()
		supportVc.myTitle = myTitle
        self.navigationController?.pushViewController(supportVc, animated: true)
    }
    
    @objc func nextStep() {
		passwordInputView.textField.resignFirstResponder()
		
        let ssid = nameTextField.text
        let pwd = passwordInputView.textField.text
		//软AP，SC码设备：直接使用auto模式进行连接，SDK、设备内部使用szWPAKey适配WPA、WEP、开放式热点
        
        switch vcStyle {
        case .changeWifi:
            let connectSession = LCWifiConnectSession()
            connectSession.ssid = ssid ?? ""
            connectSession.bssid = ssid ?? ""
            connectSession.linkEnable = LCLinkHandle(rawValue: LCLinkHandle.RawValue(truncating: NSNumber(booleanLiteral: true)))
            connectSession.password = pwd ?? ""
            LCDeviceHandleInterface.controlDeviceWifi(for: deviceId ?? "", connestSession: connectSession, success: {
                
            }) { (error) in
                
            }

            LCProgressHUD.showMsg("device_manager_wifi_connetting_tip".lc_T(), duration: 3.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.navigationController?.popViewController(animated: true)
            }
        default:
            LCProgressHUD.show(on: self.view)
            if LCAddDeviceManager.sharedInstance.isSupportSC {
                let dId = LCAddDeviceManager.sharedInstance.deviceId
                guard self.searchedDevice != nil else {
                    LCProgressHUD.hideAllHuds(self.view)
                    LCProgressHUD.showMsg("add_device_connect_failed".lc_T())
                    return
                }
                if self.searchedDevice?.deviceInitStatus == .unInit {
                    LCNetSDKHelper.startSoftAPConfig(ssid, wifiPwd: pwd, wifiEncry: 12, netcardName:"" , deviceIp: self.searchedDevice?.ip ?? "", devicePwd: LCAddDeviceManager.sharedInstance.regCode, isSC: true, handler: { result in
                        LCProgressHUD.hideAllHuds(self.view)
                        if result == 0 {
                            self.pushToConnectCloud()
                        }else{
                            LCProgressHUD.showMsg("distribution_network_failure_retry".lc_T())
                        }
                    }, timeout: 5000 * 2)
                } else {
                    connectWifi()
                }
            } else {
                connectWifi()
            }
        }
    }
    
    private func connectWifi() {
        let ssid = nameTextField.text
        let pwd = passwordInputView.textField.text
        var encryptionAuthority = 12
        var netcardName = ""
        
        
        
        LCNetSDKHelper.loginDevice(byIp: self.searchedDevice?.ip ?? "", port: Int(self.searchedDevice?.port ?? 37777), username: "admin", password: devicePassword) { loginHandle in
            
            
            if !LCNetSDKInterface.querySupportWlanConfigV3(loginHandle) {
                
            } else {
                if let model = LCNetSDKInterface.queryWifi(byLoginHandle: loginHandle, mssId: ssid, errorCode: nil) {
                    encryptionAuthority = Int(model.encryptionAuthority)
                    netcardName = model.netcardName ?? ""
                }
            }
            LCNetSDKHelper.startSoftAPConfig(ssid, wifiPwd: pwd, wifiEncry: Int32(encryptionAuthority), netcardName:netcardName , deviceIp: self.searchedDevice?.ip ?? "", devicePwd: LCAddDeviceManager.sharedInstance.regCode, isSC: false, handler: { result in
                LCProgressHUD.hideAllHuds(self.view)
                self.pushToConnectCloud()
            }, timeout: 5000 * 2)
        } failure: { desc in
            
        }

    }
	
	private func pushToConnectCloud() {
		let controller = LCConnectCloudViewController.storyboardInstance()
		controller.deviceInitialPassword = devicePassword
		self.navigationController?.pushViewController(controller, animated: true)
	}
    
    // MARK: - lazy ui
    
    lazy var nameView: UIView = {
        let nameView = UIView()
        nameView.backgroundColor = UIColor.lccolor_c43()
        
        let toplineView = UIView()
        toplineView.backgroundColor = UIColor.lccolor_c42()
        nameView.addSubview(toplineView)
        toplineView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(nameView)
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
        
        let bottomlineView = UIView()
        bottomlineView.backgroundColor = UIColor.lccolor_c42()
        nameView.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(nameView)
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
        
        return nameView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        // todo: word
        nameLabel.text = "name1".lc_T()
        
        return nameLabel
    }()
    
    lazy var nameTextField: LCTextField = {
        let textField = LCTextField()
        textField.placeholder = "add_device_enter_wifi_password".lc_T()
        textField.font = UIFont.lcFont_t2()
        textField.customClearButton = true
        textField.textColor = UIColor.lccolor_c40()
        textField.lc_setInputRule(withRegEx: "", andInputLength: 256)
        textField.textChanged = { [weak self] (name) in
            if name?.length == 0 {
                self?.nextBtn.isEnabled = false
                self?.nextBtn.backgroundColor = UIColor.lccolor_c42()
            } else {
                self?.nextBtn.isEnabled = true
                self?.nextBtn.backgroundColor = UIColor.lccolor_c10()
            }
             
        }
        
        return textField
    }()
    
    lazy var passwordView: UIView = {
        let passwordView = UIView()
        passwordView.backgroundColor = UIColor.lccolor_c43()
        
        let bottomlineView = UIView()
        bottomlineView.backgroundColor = UIColor.lccolor_c42()
        passwordView.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(passwordView)
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
        
        return passwordView
    }()
    
    lazy var passwordLabel: UILabel = {
        let passwordLabel = UILabel()
        // todo: word
        passwordLabel.text = "password1".lc_T()
        
        return passwordLabel
    }()
    
    lazy var passwordInputView: LCInputView = {
        let inputView = LCInputView()
		inputView.openBtnState = true
		inputView.textField.placeholder = "add_device_input_wifi_password".lc_T()
        return inputView
    }()
    
    lazy var descBtn: UIButton = {
        let descBtn = UIButton()
        descBtn.titleLabel?.font = UIFont.lcFont_t5()
        descBtn.setTitle("add_device_device_not_support_5g".lc_T(), for: .normal)
        descBtn.setTitleColor(UIColor.lccolor_c42(), for: .normal)
        descBtn.setImage(UIImage(lc_named: "adddevice_icon_help"), for: .normal)
        descBtn.addTarget(self, action: #selector(descBtnClicked), for: .touchUpInside)
        descBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 162, 0, 0)
        descBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
        
        return descBtn
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton()
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = UIColor.lccolor_c42()
        nextBtn.setTitle("common_next".lc_T(), for: .normal)
        nextBtn.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        nextBtn.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
        return nextBtn
    }()

    // MARK: - private let
    
    public var vcStyle: LCAddOtherWifiControllerStyle = .newWifi
    private var deviceId: String?
    
    private let topPadding: CGFloat = 10.0
    private let leftPadding: CGFloat = 17.0
    private let leftPadding24: CGFloat = 24.0
    private let viewHeight: CGFloat = 55.0
    private let labelWidth: CGFloat = 150.0
}
