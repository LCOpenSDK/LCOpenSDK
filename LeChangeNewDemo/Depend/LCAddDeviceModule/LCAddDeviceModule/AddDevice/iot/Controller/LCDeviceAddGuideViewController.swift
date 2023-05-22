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

class LCDeviceAddGuideViewController: LCAddBaseViewController, LCAddGuideViewDelegate {
    func guideView(view: LCAddGuideView, action: LCAddGuideActionType) {
        if action == .next {
            self.goNextStep()
        }
        if action == .detail {

        }
    }
    
    @objc var productId: String = ""
    
    private let guideView: LCAddGuideView = LCAddGuideView.xibInstance()

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
//        self.setupNaviRightItem();
        
        guideView.delegate = self
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        if LCAddDeviceManager.sharedInstance.netConfigMode == .iotBluetooth {
            guideView.topImageView.image = UIImage(lc_named: "adddevice_guide_bluetooth")
            if !NSString.lc_currentLanguageCode().contains("zh") {
                guideView.topImageView.image = UIImage(lc_named: "adddevice_guide_bluetooth_en")
            }
            guideView.topTipLabel.text = "add_device_bluetooth".lc_T()
            guideView.descriptionLabel.text = "add_device_bluetooth_tip".lc_T()
            guideView.detailButton.isHidden = true
        }
    }

    private func goNextStep() {
        if LCAddDeviceManager.sharedInstance.netConfigMode == .iotBluetooth || LCAddDeviceManager.sharedInstance.netConfigMode == .wifi {
            let controller = LCDeviceLightCheckViewController()
            controller.productId = productId
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
