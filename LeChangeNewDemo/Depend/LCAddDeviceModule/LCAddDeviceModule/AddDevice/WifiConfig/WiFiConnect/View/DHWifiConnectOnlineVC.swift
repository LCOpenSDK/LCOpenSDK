//
//  Copyright © 2018 dahua. All rights reserved.
//

import UIKit

class DHWifiConnectOnlineVC: DHBaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inputPwdLabel: UILabel!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
    @IBOutlet weak var passwordInputView: LCInputView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var supportTipButton: UIButton!
    @IBOutlet weak var autoKeyboardView: DHAutoKeyboardView!
    @IBOutlet weak var checkWidthConstraint: NSLayoutConstraint!
    var wifiInfo: LCWifiInfo!

    private var presenter: IDHWiFiConnectOnlinePresenter?
    
    public static func storyboardInstance() -> DHWifiConnectOnlineVC {
        let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        let controller = storyboard.instantiateViewController(withIdentifier: "DHWifiConnectOnlineVC")
        return controller as! DHWifiConnectOnlineVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.dhcolor_c7()
		title = "mobile_common_network_config".lc_T
        setupCustomContents()
        setupInputView()
        presenter?.setupSupportView()
        presenter?.updateContainerViewByWifiInfo()
        autoKeyboardView.relatedView = nextButton
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }


    public func setPresenter(presenter: IDHWiFiConnectOnlinePresenter) {
        self.presenter = presenter
    }

    func setupCustomContents() {
        imageView.image = DHAddDeviceManager.sharedInstance.isSupport5GWifi ? UIImage(named: "adddevice_icon_wifipassword") : UIImage(named: "adddevice_icon_wifipassword_nosupport5g")
        wifiNameLabel.text = nil
        wifiNameLabel.textColor = UIColor.dhcolor_c2()
        inputPwdLabel.text = "add_device_input_wifi_password".lc_T
        inputPwdLabel.textColor = UIColor.dhcolor_c2()
        wifiLabel.text = "add_device_wifi_ssid".lc_T
        wifiLabel.textColor = UIColor.dhcolor_c5()
        checkButton.setTitle("add_device_remember_password".lc_T, for: .normal)
        checkButton.setTitleColor(UIColor.dhcolor_c5(), for: .normal)
        supportTipButton.setTitle("add_device_device_not_support_5g".lc_T, for: .normal)
        supportTipButton.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
        passwordInputView.textField.placeholder = "add_device_input_wifi_password".lc_T
        nextButton.setTitle("device_manager_connect".lc_T, for: .normal)
        nextButton.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
        passwordInputView.textField.textAlignment = .left
        passwordInputView.textField.font = UIFont.dhFont_t3()
        passwordInputView.textField.textColor = UIColor.dhcolor_c2()
        
        bottomLine.backgroundColor = UIColor.dhcolor_c8()
        topLine.backgroundColor = UIColor.dhcolor_c8()

        checkButton.setImage(UIImage(named: "adddevice_box_checkbox"), for: .normal)
        checkButton.setImage(UIImage(named: "adddevice_box_checkbox_checked"), for: .selected)

        //按钮样式配置
        nextButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
        nextButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()

        //支持多行显示
        checkButton.titleLabel?.numberOfLines = 2
        supportTipButton.titleLabel?.numberOfLines = 2
        supportView.backgroundColor = UIColor.clear
		
		//DTS000273198 优先显示WifiLabel
		wifiLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
		wifiNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    func setupInputView() {
        passwordInputView.backgroundColor = UIColor.clear
        passwordInputView.textField.returnKeyType = .done
        passwordInputView.textField.delegate = self

        //密码国内默认为明文，可点击隐藏，海外默认为暗文
        passwordInputView.openBtnState = DHModuleConfig.shareInstance().isLeChange
    }
    
    // MARK: Actions
    @IBAction func onCheckAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        //【*】清除当前对应的WIFI密码
        if checkButton.isSelected == false, let ssid = wifiNameLabel.text {
            DHUserManager.shareInstance().removeSSID(ssid)
        }
    }


    @IBAction func onNextAction(_ sender: Any) {
   
        self.view.endEditing(true)
        
        let wifiSSID = wifiNameLabel.text
        let wifiPassword = passwordInputView.textField.text
        DHAddDeviceManager.sharedInstance.wifiSSID = wifiSSID
        DHAddDeviceManager.sharedInstance.wifiPassword = wifiPassword
        
        //统一下一步记住密码
        if checkButton.isSelected, wifiSSID != nil, wifiPassword != nil {
            DHUserManager.shareInstance().addSSID(wifiSSID, ssidPwd: wifiPassword)
        }
        
        //解释器处理下一步
        self.presenter?.nextStepAction(wifiSSID: wifiSSID ?? "", wifiPassword: wifiPassword)
        
    }
    

}

extension DHWifiConnectOnlineVC: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    @nonobjc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

