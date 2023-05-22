//
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit
import CoreLocation

class LCApGuideViewController: LCAddBaseViewController {
    private let guideView: LCAddGuideView = LCAddGuideView.xibInstance()
    
	private lazy var locationManager: CLLocationManager = {
		let location = CLLocationManager()
		return location
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        guideView.topTipLabel.text = "add_device_network_config_guide".lc_T()
        guideView.descriptionLabel.text = "add_device_softap_tip".lc_T()
        guideView.nextButton.setTitle("common_next".lc_T(), for: .normal)
        guideView.detailButton.setTitle("add_device_network_config_guide_light_error".lc_T(), for: .normal)
        guideView.delegate = self
        guideView.topImageView.image = UIImage(lc_named: "adddevice_softap_guide")
        if !NSString.lc_currentLanguageCode().contains("zh") {
               guideView.topImageView.image = UIImage(lc_named: "adddevice_softap_guide_en")
           }
        setupNaviRightItem()
    }
}

extension LCApGuideViewController: LCAddGuideViewDelegate {
	
	func guideView(view: LCAddGuideView, action: LCAddGuideActionType) {
        if action == .detail {
            LCSheetGuideView(title: "add_device_network_config_guide_tips".lc_T(), message: "add_device_network_config_guide_alert".lc_T(), image: UIImage(lc_named: "adddevice_netsetting_guide_reset"), cancelButtonTitle: "Alert_Title_Button_Confirm1".lc_T()).show()
        } else if action == .next {                //iOS13界面：
            if #available(iOS 13.0, *) {
                let status = CLLocationManager.authorizationStatus()
                if status == .notDetermined {
                    //申请权限
                    locationManager.requestWhenInUseAuthorization()
                } else if status == .denied {
                    //被拒绝后，重新申请
                    LCSetJurisdictionHelper.setJurisdictionAlertView("mobile_common_permission_apply".lc_T(), message: "mobile_common_permission_explain_access_location_usage".lc_T())
                } else {
                    //有位置访问权限，跳转下一步
                    goLastStep()
                }
            } else {
                goLastStep()
            }
        }
	}
	
	func goLastStep() {
        // 离线配网，支持sc，且sc为空时，需要用户手动输入sc
        if LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
            // iot视频类设备都是TCM设备，都有SC码，非ioT设备支持SCCode
            if LCAddDeviceManager.sharedInstance.productId?.isEmpty != true ||
                LCAddDeviceManager.sharedInstance.isSupportSC && LCAddDeviceManager.sharedInstance.initialPassword.length == 0 {
                let controller = LCAuthPasswordViewController.storyboardInstance()
                controller.presenter = LCApAuthPasswordPresenter(container: controller)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            let controller = LCApWifiCheckViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
	}
}
