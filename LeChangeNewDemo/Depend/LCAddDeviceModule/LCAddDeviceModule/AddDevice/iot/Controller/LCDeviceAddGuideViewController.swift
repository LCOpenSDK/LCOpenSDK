//
//  LCDeviceAddGuideViewController.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/19.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import AFNetworking
import ObjectMapper

class LCDeviceAddGuideViewController: LCAddBaseViewController {
    @objc var productId: String = ""
    var guideStepModels = [LCDeviceAddStepModel]()
    var currentStep = 0

    open lazy var guideView: LCDeviceAddGuideView = {
        let guideImageView = LCDeviceAddGuideView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - LC_navViewHeight))
        guideImageView.delegate = self
        return guideImageView
    }()

    init(productID: String) {
        super.init(nibName: nil, bundle: nil)
        productId = productID
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.view.addSubview(guideView)
        if currentStep == 0 {
            loadGuideData()
        }else {
            self.guideView.updateGuideView(stepModel: guideStepModels[currentStep])
        }
    }

    func loadGuideData() {
        var communicate: String = "lan"
        if LCAddDeviceManager.sharedInstance.netConfigMode == .ble {
            communicate = "bluetooth"
        } else if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp {
            communicate = "wifi"
        } else if LCAddDeviceManager.sharedInstance.netConfigMode == .iot4G {
            communicate = "4G"
        }
        LCProgressHUD.show(on: self.view)
        LCAddDeviceInterface.getIotDeviceIntroduction(forProductID: LCAddDeviceManager.sharedInstance.productId ?? "", communicate:communicate,  language: NSString.lc_currentLanguageCode()) {[weak self] infos in
            guard let data = try? JSONSerialization.data(withJSONObject: infos as Any, options: .fragmentsAllowed) else {
                return
            }
            if let items: [LCDeviceAddStepModel] = Mapper<LCDeviceAddStepModel>().mapArray(JSONString: String.init(data: data, encoding: .utf8) ?? "") {
                self?.guideStepModels = items
                if let firstGuide = self?.guideStepModels.first {
                    self?.guideView.updateGuideView(stepModel: firstGuide)
                }
            }else {
                LCProgressHUD.showMsg("get_the_added_process_information_is_empty".lc_T)
            }
            LCProgressHUD.hideAllHuds(self?.view)
        } failure: {[weak self] error in
            LCProgressHUD.hideAllHuds(self?.view)
        }
    }

    // MARK: LCAddBaseVCProtocol
    override func rightActionType() -> [LCAddBaseRightAction] {
        return  [.restart]
    }

    private func goNextStep() {
        if LCAddDeviceManager.sharedInstance.netConfigMode == .ble {
            LCProgressHUD.show(on: self.view, tip: "device_bluetooth_distribution_network".lc_T)
            LCOpenSDK_Bluetooth.startAsyncBLEConfig(LCAddDeviceManager.sharedInstance.wifiSSID ?? "", wifiPwd: LCAddDeviceManager.sharedInstance.wifiPassword ?? "", productId: productId, deviceId: LCAddDeviceManager.sharedInstance.deviceId) { success, errorMessage in
                LCProgressHUD.hideAllHuds(self.view)
                if success {
                    LCProgressHUD.showMsg("equipment_distribution_network_succeeded".lc_T)
                    let controller = LCConnectCloudViewController.storyboardInstance()
                    controller.deviceInitialPassword = LCAddDeviceManager.sharedInstance.initialPassword
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    LCProgressHUD.showMsg("device_distribution_network_failure_retry".lc_T + errorMessage, duration: 5)
                }
            }
        } else if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp {
            if let lastModel = self.guideStepModels.last {
                let softAPConfigVc = LCSoftApConfigViewController.init(unitModels: [lastModel])
                self.navigationController?.pushViewController(softAPConfigVc, animated: true)
            }
        } else {
            self.basePushToConnectCloudVC(devicePassword: LCAddDeviceManager.sharedInstance.initialPassword)
        }
    }
}

extension LCDeviceAddGuideViewController: LCDeviceAddGuideViewDelegate {
    func addGuideViewConnectNext(_ addGuideView: LCDeviceAddGuideView) {
        if currentStep + 1 >= guideStepModels.count {
            goNextStep()
        }else {
            let guideVc = LCDeviceAddGuideViewController(productID: self.productId)
            guideVc.guideStepModels = self.guideStepModels
            guideVc.currentStep = currentStep + 1
            self.navigationController?.pushViewController(guideVc, animated: true)
        }
    }

    func addGuideViewOther(_ addGuideView: LCDeviceAddGuideView) {
        
    }

    func addGuideViewConnectHelp(_ addGuideView: LCDeviceAddGuideView) {
        let helpModel = addGuideView.helpModel
        if let count = helpModel.helpTitle?.count, count > 0 {
            let webVC: LCAddDeviceSheetWebVC = LCAddDeviceSheetWebVC()
            webVC.modalPresentationStyle = .overFullScreen
            webVC.playUrl = helpModel.helpUrl ?? ""
            self.navigationController?.present(webVC, animated: false, completion: nil)
        } else {
            let restView = LCRouterResetView.init(resetType: .guide)
            restView.show()
        }
    }


}
