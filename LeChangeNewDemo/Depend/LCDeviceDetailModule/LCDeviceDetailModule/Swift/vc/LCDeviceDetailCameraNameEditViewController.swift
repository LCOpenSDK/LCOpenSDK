//
//  LCDeviceDetailCameraNameEditViewController.swift
//  LCDeviceDetailModule
//
//  Created by yyg on 2023/7/27.
//

import UIKit
import SnapKit
import LCBaseModule
import LCNetworkModule

extension Bundle {
    static var bundle: Bundle? = nil
    class func lc_addDeviceDetailBundle() -> Bundle? {
        if self.bundle == nil, let path = Bundle.main.path(forResource: "LCDeviceDetailModuleBundle", ofType: "bundle") {
            self.bundle = Bundle(path: path)
        }
        return self.bundle
    }
}

public class LCDeviceDetailCameraNameEditViewController : LCBasicViewController {
    
    @IBOutlet weak var fixedTitleLabel: UILabel!
    @IBOutlet weak var fixedCameraInput: UITextField!
    
    @IBOutlet weak var mobileTitleLabel: UILabel!
    @IBOutlet weak var mobileCameraInput: UITextField!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    @objc public weak var deviceInfo: LCDeviceInfo?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @objc public static func xibInstance() -> LCDeviceDetailCameraNameEditViewController {
        return LCDeviceDetailCameraNameEditViewController.init(nibName: "LCDeviceDetailCameraNameEditViewController", bundle: Bundle.lc_addDeviceDetailBundle())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lcCreatNavigationBar(with: LCNAVIGATION_STYLE_SUBMIT, buttonClick: { [weak self]
            index in
            if index == 0 {
                self?.navigationController?.popViewController(animated: true)
            }
            if index == 1 {
                self?.tapView()
                LCProgressHUD.show(on: self?.view)
                LCDeviceManagerInterface.modifyDeviceCameraName(forDevice: self?.deviceInfo?.deviceId ?? "", productId: self?.deviceInfo?.productId ?? "", fixedCameraName: self?.fixedCameraInput.text ?? "", fixedCameraID: self?.cameraId(fixed: true)  ?? "1", mobileCameraName: self?.mobileCameraInput.text ?? "", mobileCameraId: self?.cameraId(fixed: false) ?? "0") {
                    LCProgressHUD.hideAllHuds(self?.view)
                    LCProgressHUD.showMsg("livepreview_localization_success".lc_T)
                    self?.lc_getRightBtn().lc_enable = false
                    self?.setCameraName(name: self?.fixedCameraInput.text, fixed: true)
                    self?.setCameraName(name: self?.mobileCameraInput.text, fixed: false)
                } failure: { error in
                    LCProgressHUD.hideAllHuds(self?.view)
                    LCProgressHUD.showMsg(error.errorMessage)
                }

            }
        })
        self.lc_getRightBtn().lc_enable = false
        
        self.title = "device_manager_defence_setting".lc_T
        self.fixedTitleLabel.text = "device_detail_camera_name_fixed_lens".lc_T
        self.mobileTitleLabel.text = "device_detail_camera_name_pt_lens".lc_T
        self.fixedCameraInput.text = cameraName(fixed: true)
        self.fixedCameraInput.delegate = self
        self.mobileCameraInput.text = cameraName(fixed: false)
        self.mobileCameraInput.delegate = self
        self.fixedCameraInput.clearButtonMode = .whileEditing
        self.mobileCameraInput.clearButtonMode = .whileEditing
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
        
        self.fixedCameraInput.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        self.mobileCameraInput.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
    }
    
    @objc func tapView() {
        self.fixedCameraInput.resignFirstResponder()
        self.mobileCameraInput.resignFirstResponder()
    }
    
    @objc func nameChanged() {
        if self.fixedCameraInput.text == cameraName(fixed: true) && self.mobileCameraInput.text == cameraName(fixed: false) {
            self.lc_getRightBtn().lc_enable = false
        } else {
            self.lc_getRightBtn().lc_enable = true
        }
    }
    
    func setCameraName(name: String?, fixed: Bool) {
        var channelName = name ?? ""
        self.deviceInfo?.channels.forEach({ info in
            if info.movable == !fixed {
                info.channelName = channelName
            }
        })
    }
    
    func cameraName(fixed: Bool) -> String {
        var channelName = ""
        self.deviceInfo?.channels.forEach({ info in
            if info.movable == !fixed {
                channelName = info.channelName
            }
        })
        return channelName
    }
    
    func cameraId(fixed: Bool) -> String {
        var channelId = ""
        self.deviceInfo?.channels.forEach({ info in
            if info.movable == !fixed {
                channelId = info.channelId
            }
        })
        return channelId
    }
}

extension LCDeviceDetailCameraNameEditViewController : UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text: NSString? = (textField.text as? NSString)
        text = text?.replacingCharacters(in: range, with: string) as NSString?
//        let rex = "[^\u{4e00}-\u{9fa5}]"
//        let res = text?.filterCharactor(((text ?? "") as String), withRegex:rex)
//        if string != "" && (res?.length ?? 0) > 64 {
//            return false
//        }
//            if string != "" && !string.isVaildDeviceName() {
//            return false
//        }
        
        return true
    }
}
