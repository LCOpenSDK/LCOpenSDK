//
//  Copyright © 2018年 Imou. All rights reserved.
//	电源引导页：如果此时搜索到了设备，直接走有线添加

import UIKit
import CoreLocation
import LCBaseModule
import AFNetworking

class LCPowerGuideViewController: LCAddBaseViewController, LCAddGuideViewDelegate {
    func guideView(view: LCAddGuideView, action: LCAddGuideActionType) {
        if action == .next {
            self.doNext()
        }
    }
    
    private let guideView: LCAddGuideView = LCAddGuideView.xibInstance()
    
	private lazy var locationManager: CLLocationManager = {
		let location = CLLocationManager()
		return location
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        guideView.delegate = self
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        guideView.topImageView.image = UIImage(lc_named: "adddevice_power")
        guideView.topTipLabel.text = "add_device_plug_power".lc_T()
        guideView.descriptionLabel.text = "add_device_plug_power_tip".lc_T()
        guideView.nextButton.setTitle("common_next".lc_T(), for: .normal)
        guideView.detailButton.isHidden = true
        
        setupNaviRightItem()
    }
    
    func doNext() {
		//【*】iOS13兼容：点一步，如果是WIFI配网，则判断
        if #available(iOS 13.0, *), (LCAddDeviceManager.sharedInstance.supportWifi() || LCAddDeviceManager.sharedInstance.supportSoftAP()) {
			let status = CLLocationManager.authorizationStatus()
			if status == .notDetermined {
				//申请权限
				locationManager.requestWhenInUseAuthorization()
			} else if status == .denied {
				//被拒绝后，重新申请
				LCSetJurisdictionHelper.setJurisdictionAlertView("mobile_common_permission_apply".lc_T(), message: "mobile_common_permission_explain_access_location_usage".lc_T())
			} else {
				//有位置访问权限，跳转下一步
				goNextStep()
			}
		} else {
			goNextStep()
		}
	}
	
    private func goNextStep() {
        let netConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
        if netConfigMode == .lan || netConfigMode == .iotLan || netConfigMode == .iot4G {
            let plugVc = LCWiredOrSIMGuideViewController()
            self.navigationController?.pushViewController(plugVc, animated: true)
        } else if netConfigMode == .soundWave || netConfigMode == .soundWaveV2 || netConfigMode == .smartConfig {
                let passwordVc = LCWifiPasswordViewController.storyboardInstance()
                let presenter = LCWifiPasswordPresenter(container: passwordVc)
                passwordVc.setup(presenter: presenter)
                self.navigationController?.pushViewController(passwordVc, animated: true)
        } else if netConfigMode == .softAp {
            let controller = LCApGuideViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func addDeviceStartLog() {
        let result = "{SN: \(LCAddDeviceManager.sharedInstance.deviceId)，deviceModelName: \(LCAddDeviceManager.sharedInstance.deviceModel)}"
        let model = LCAddDeviceLogModel()
        model.bindDeviceType = StartAddType.NetworkConfig
        model.inputData = result
        LCAddDeviceLogManager.shareInstance.addDeviceStartLog(model: model)
    }
}
