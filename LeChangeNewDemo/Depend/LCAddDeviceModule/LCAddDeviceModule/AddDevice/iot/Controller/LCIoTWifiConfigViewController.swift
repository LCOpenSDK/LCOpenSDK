//
//  LCIoTWifiConfigViewController.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/17.
//  Copyright © 2022 Imou. All rights reserved.
//  无线配置、软AP配置：WIFI密码输入

import UIKit
import CoreLocation
import LCBaseModule

class LCIoTWifiConfigViewController: LCAddBaseViewController {
    var isInRequest = false
    
    @IBOutlet var passwordLab: UILabel!
    @IBOutlet var wifiNameView: UIView!
    @IBOutlet var inputPwdLabel: UILabel!
    @IBOutlet var wifiLabel: UILabel!

    @IBOutlet var wifiNameTextField: UITextField!
    @IBOutlet var passwordInputView: LCInputView!
    
    @IBOutlet var passwordBackgroundView: UIView!
//    @IBOutlet var checkButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var supportView: UIView!
    @IBOutlet var supportTipButton: UIButton!
    @IBOutlet var autoKeyboardView: LCAutoKeyboardView!
    @IBOutlet var switchWifiBtn: UIButton!
    
    lazy var checkButton: UIButton = {
        let checkButton = UIButton.init(type: .custom)
        checkButton.titleLabel?.font = UIFont.lcFont_t5()
        checkButton.titleLabel?.lineBreakMode = .byWordWrapping
        checkButton.setTitle("add_device_remember_password".lc_T(), for: .normal)
        checkButton.contentHorizontalAlignment = .left
        checkButton.titleLabel?.textAlignment = .left
        checkButton.setTitleColor(UIColor.lccolor_c41(), for: .normal)
        checkButton.alpha = 1
        checkButton.setImage(UIImage(lc_named: "adddevice_box_checkbox"), for: .normal)
        checkButton.setImage(UIImage(lc_named: "adddevice_box_checkbox_checked"), for: .selected)
        checkButton.addTarget(self, action: #selector(onCheckAction), for: UIControlEvents.touchUpInside)
        return checkButton
    }()
    
    @IBOutlet weak var doubltBtn: UIButton!
    /// wifi信息配置完成的回调
    public typealias wifiConfitBlock = () -> Void
    
    //声明
    public var wifiConfigBlock: wifiConfitBlock?

    private var isSelected: Bool = false
    private lazy var locationManager: CLLocationManager = {
        let location = CLLocationManager()
        return location
    }()
    
    public static func storyboardInstance() -> LCIoTWifiConfigViewController {
        let storyboard = UIStoryboard(name: "AddIOTDevice", bundle: Bundle.lc_addDeviceBundle())
        let controller = storyboard.instantiateViewController(withIdentifier: "LCIoTWifiConfigViewController")
        return controller as! LCIoTWifiConfigViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        setupCustomContents()
        setupInputView()
        print("LCIOT-Add-WIFI-VC: viewDidLoad: lastWifiName = \(lastWifiName)  lc_lastWifiName = \(LCNetWorkHelper.sharedInstance().lc_lastWifiName)")
        updateWifiInfo(wifiName: LCNetWorkHelper.sharedInstance().lc_lastWifiName ?? "")
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged(notice:)), name: NSNotification.Name(rawValue: "LCNotificationWifiNetWorkDidSwitch"), object: nil)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func rightActionType() -> [LCAddBaseRightAction] {
        return [.restart]
    }

    @objc func didBecomeActive() {
        print("LCIOT-Add-WIFI-VC: didBecomeActive: lastWifiName = \(lastWifiName)  lc_lastWifiName = \(LCNetWorkHelper.sharedInstance().lc_lastWifiName)")
        updateWifiInfo(wifiName: LCNetWorkHelper.sharedInstance().lc_lastWifiName ?? "")
    }
    
    @objc func networkChanged(notice:Notification) {
        print("LCIOT-Add-WIFI-VC: networkChanged: notice.object = \(notice.object)  lc_lastWifiName = \(LCNetWorkHelper.sharedInstance().lc_lastWifiName)")
        updateWifiInfo(wifiName: LCNetWorkHelper.sharedInstance().lc_lastWifiName ?? "")
    }

    func updateWifiInfo(wifiName: String) {
        if UIViewController.lc_top().isKind(of: LCIoTWifiConfigViewController.self) {
            if LCNetWorkHelper.sharedInstance().currentNetworkStatus() == 2 {
                LCNetWorkHelper.sharedInstance().interfaceQueue.async { [weak self] in
                    DispatchQueue.main.async {
                        self?.wifiNameTextField.text = wifiName

                        if wifiName == "" {
                            self?.nextButton.lc_enable = false
                        } else {
                            self?.nextButton.lc_enable = true
                        }
                        // 【*】直接从保存的密码取：如果长度大于0，选中check，并填充密码
                        if let password = LCUserManager.shareInstance().ssidPwd(by: self?.wifiNameTextField.text), password.count > 0 {
                            self?.checkButton.isSelected = true
                            self?.passwordInputView.textField.text = password
                        } else {
                            self?.checkButton.isSelected = false
                            self?.passwordInputView.textField.text = nil
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.wifiNameTextField.text == "" {
                LCProgressHUD.showMsg("add_device_connect_wifi".lc_T(), duration: 1.5)
            }
        }
    }
    
    func getLocationStatus() {
        if #available(iOS 13.0, *) {
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined || status == .restricted {
                //申请权限
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            } else if status == .denied {
                alert()
            }
        }
    }

    func alert() {
        LCPermissionHelper.showUnPermissionLocationAlert("permisssion_request_location_ssid_message".lc_T())
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isSelected == true {
            checkButton.isSelected = true
        }
        getLocationStatus()
    }

    func baseStackContainControllers() -> [UIViewController] {
        var controllers: [UIViewController] = [UIViewController]()
        if let naviVc = self.navigationController as? LCNavigationController {
            controllers.append(contentsOf: naviVc.viewControllers)
        }
        return controllers
    }

    func setupCustomContents() {
        wifiNameTextField.text = nil
        inputPwdLabel.text = "add_device_connect_wifi".lc_T()
        inputPwdLabel.numberOfLines = 0
        wifiNameTextField.placeholder = "device_add_wifi_name".lc_T()
        wifiNameTextField.font = .lcFont_t3()
        
        supportTipButton.setTitle("add_device_iot_wifi_2_4g_only".lc_T(), for: .normal)
        supportTipButton.snp.updateConstraints { (make) in
            make.leading.equalTo(supportView)
            make.width.lessThanOrEqualTo(lc_scaleSize(260))
        }
        supportView.snp.updateConstraints { make in
            make.width.equalTo(lc_screenWidth / 2)
        }

        wifiNameTextField.delegate = self
        passwordInputView.textField.placeholder = "device_add_wifi_password".lc_T()
        nextButton.setTitle("common_next".lc_T(), for: .normal)

        // 设置颜色规范
        passwordInputView.textField.textColor = UIColor.lccolor_c40()
        wifiNameTextField.textColor = UIColor.lccolor_c40()
//        wifiLabel.textColor = UIColor.lccolor_c40()
//        wifiLabel.font = UIFont.lcFont_t5()
        wifiNameView.backgroundColor = UIColor.lc_color(withHexString: "f6f6f6")
        wifiNameTextField.backgroundColor = .clear
//        passwordLab.textColor = UIColor.lccolor_c40()
        inputPwdLabel.textColor = UIColor.lccolor_c40()
        inputPwdLabel.font = UIFont.lcFont_t1Bold()
//        passwordLab.font = UIFont.lcFont_t5()
        supportTipButton.setTitleColor(UIColor.lccolor_c41(), for: .normal)
        supportTipButton.titleLabel?.font = UIFont.lcFont_t5()
        isBarShadowHidden = true
        passwordInputView.tfUnSecureImg = UIImage(lc_named: "common_icon_close_small")
        passwordInputView.tfSecureImg = UIImage(lc_named: "adddevice_common_icon_open_small")
//        btnNaviRight.isHidden = true

        wifiNameView.lc_setRadius(10)
        passwordInputView.lc_setRadius(10)
        passwordBackgroundView.lc_setRadius(10)
        nextButton.lc_setRadius(22.5)

        switchWifiBtn.setImage(UIImage(lc_named: "adddevice_wifi_refresh"), for: .normal)
        doubltBtn.setImage(UIImage(lc_named: "common_btn_doubt"), for: .normal)
        
        // 按钮样式配置
        nextButton.lc_setRadius(22.5)
        nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        nextButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        nextButton.lc_enable = false
        // 支持多行显示
        supportTipButton.titleLabel?.numberOfLines = 2
        supportView.backgroundColor = UIColor.clear

        view.addSubview(checkButton)
        checkButton.sizeToFit()
        checkButton.snp.remakeConstraints { (make) in
            make.leading.equalTo(passwordInputView).offset(5)
            make.top.equalTo(passwordInputView.snp.bottom).offset(10)
            make.height.equalTo(22)
            make.width.equalTo(160)
        }
        checkButton.layoutButton(with: .left, imageTitleSpace: 11)
    }
     
    func setupInputView() {
        passwordInputView.backgroundColor = UIColor.lc_color(withHexString: "f6f6f6")
        passwordBackgroundView.backgroundColor = UIColor.lc_color(withHexString: "f6f6f6")
        passwordInputView.textField.returnKeyType = .done
        passwordInputView.textField.delegate = self
        // 密码国内默认为明文，可点击隐藏，海外默认为暗文
         passwordInputView.openBtnState = false
    }

    // MARK: Actions

    @objc func onCheckAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        // 【*】清除当前对应的WIFI密码
        if checkButton.isSelected == false, let ssid = wifiNameTextField.text {
            LCUserManager.shareInstance().removeSSID(ssid)
        }

        isSelected = sender.isSelected
    }

    @IBAction func onWifiSwitchAction(_ sender: Any) {
        print("LCWifiPasswordViewController onWifiSwitchAction")
        let url = URL(string: UIApplicationOpenSettingsURLString)!
        if #available(iOS 10.0, *) {
            // 先判断是否有iOS10SDK的方法，如果有，则实现iOS10的跳转
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @IBAction func onSupportTipAction(_ sender: Any) {
        LCIotWiFiUnSupportView().show()
    }

    @IBAction func onNextAction(_ sender: Any) {
        self.view.resignFirstResponder()

        checkSavePassword()
        self.wifiConfigBlock!()
    }

    func checkSavePassword() {
        let wifiSSID = wifiNameTextField.text
        let wifiPassword = passwordInputView.textField.text

        // 统一下一步记住密码
        if wifiSSID != nil, wifiPassword != nil && checkButton.isSelected {
            LCUserManager.shareInstance().addSSID(wifiSSID, ssidPwd: wifiPassword)
        }
        LCAddDeviceManager.sharedInstance.wifiSSID = wifiSSID
        LCAddDeviceManager.sharedInstance.wifiPassword = wifiPassword
        isSelected = checkButton.isSelected
    }

}

extension LCIoTWifiConfigViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == wifiNameTextField {
            let nsString: NSString = (textField.text as NSString?)!
            let newStr: NSString = (nsString.replacingCharacters(in: range, with: string)) as NSString
            nextButton.lc_enable = newStr.length > 0 ? true : false
            
            if newStr.length > 32 {
                return false
            }
        }
        return true
    }
}

extension LCIoTWifiConfigViewController: CLLocationManagerDelegate {
    private func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if isTopController() {
            if status == .denied {
                alert()
            }
        }
    }
}

