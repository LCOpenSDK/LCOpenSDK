//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	插网线引导页

import UIKit
import LCBaseModule
import LCOpenSDKDynamic

class LCWiredOrSIMGuideViewController: LCAddBaseViewController, LCAddGuideViewDelegate {
    func guideView(view: LCAddGuideView, action: LCAddGuideActionType) {
        if action == .next {
            self.doNext()
        }
    }
    
    private let guideView: LCAddGuideView = LCAddGuideView.xibInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        guideView.delegate = self
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        let netConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
        if netConfigMode == .lan || netConfigMode == .iotLan {
            guideView.topImageView.image = UIImage(lc_named: "adddevice_power")
            guideView.topTipLabel.text = "add_device_plug_cable_to_device".lc_T()
            guideView.descriptionLabel.text = "add_device_plug_cable_to_device_tip".lc_T()
            guideView.nextButton.setTitle("common_next".lc_T(), for: .normal)
            guideView.detailButton.isHidden = true
        }
        
        if netConfigMode == .iot4G {
            guideView.topImageView.image = UIImage(lc_named: "adddevice_netsetting_guide_4G")
            guideView.topTipLabel.text = "add_device_add_device".lc_T()
            guideView.descriptionLabel.text = "add_device_sim_tip".lc_T()
            guideView.nextButton.setTitle("common_next".lc_T(), for: .normal)
            guideView.detailButton.isHidden = true
        }
        
        setupNaviRightItem()
    }
    
    func doNext() {
        if LCAddDeviceManager.sharedInstance.isSupportSC {
            basePushToConnectCloudVC()
        } else {
            //跳转设备初始化界面
            basePushToInitializeSearchVC()
        }
    }
}
