//
//  LCSoftApConfigViewController.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/20.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import LCBaseModule
import ObjectMapper

class LCSoftApConfigViewController: LCAddBaseViewController {
    var guideStepModels = [LCDeviceAddStepModel]()
    
    // 软ap配置流程helper
    lazy var softHelper: LCSoftAPConfigHelper = {
        let helper = LCSoftAPConfigHelper.init()
        return helper
    }()
    
    open lazy var guideView: LCDeviceAddGuideView = {
        let guideImageView = LCDeviceAddGuideView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - LC_navViewHeight))
        guideImageView.delegate = self
        return guideImageView
    }()
    
    init(unitModels: [LCDeviceAddStepModel]) {
        super.init(nibName: nil, bundle: nil)
        self.guideStepModels = unitModels
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.isBarShadowHidden = true
        self.title = ""
        setUpSubViews()
        
        softHelper.startNetworkConfig { success in
            if success == true {
                let controller = LCConnectCloudViewController.storyboardInstance()
                controller.deviceInitialPassword = LCAddDeviceManager.sharedInstance.initialPassword
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    deinit {
        print("softAP自动连接 控制器被释放 %%%%%%%%%%%%%%%%%%%%")
    }

    func setUpSubViews() {
        self.view.addSubview(guideView)
        self.guideView.updateGuideView(stepModel: guideStepModels[0])
        self.guideView.tempImageView.isHidden = false
        self.guideView.guideImageView.isHidden = true
        self.guideView.operateLab.text = "add_device_softap_connect_hotspot_title".lc_T
        self.guideView.desLab.text = "add_device_softap_connect_hotspot_des".lc_T
        self.guideView.nextButton.setTitle("add_device_softap_connect_hotspot_next".lc_T, for: .normal)
        self.guideView.helpUrlTitleBtn.isHidden = true
    }
    
    override func rightActionType() -> [LCAddBaseRightAction] {
        return [.restart]
    }
}

extension LCSoftApConfigViewController: LCDeviceAddGuideViewDelegate {
    public func addGuideViewOther(_ addGuideView: LCDeviceAddGuideView) {
        
    }
    
    public func addGuideViewConnectHelp(_ addGuideView: LCDeviceAddGuideView) {
        
    }
    
    public func addGuideViewConnectNext(_ addGuideView: LCDeviceAddGuideView) {
        // 手动跳转wifi列表时，现将isInRequest状态置为false，以便app回到前台时进行设备信息获取
        softHelper.isInRequest = false
        LCAddDeviceManager.sharedInstance.gotoConfigWifi()
    }
}
