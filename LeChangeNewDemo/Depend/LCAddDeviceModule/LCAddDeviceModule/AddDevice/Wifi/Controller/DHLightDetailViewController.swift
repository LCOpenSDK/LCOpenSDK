//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	指示灯：详细说明界面

import UIKit

class DHLightDetailViewController: DHAddBaseViewController, DHCommonErrorViewDelegate {
	/// 错误类型
	public var failureType: DHNetConnectFailureType = .commonWithWired {
		didSet {
			setupWithFailureType()
		}
	}
	
	/// 操作类型
	public var operationType: DHNetConnectFailureOperationType = .redLightConstantDetail {
		didSet {
			setupWithOperationType()
		}
	}

	private var errorView: DHCommonErrorView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupErrorView()
		setupCustomContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupErrorView() {
		errorView = DHCommonErrorView.xibInstance()
		errorView.delegate = self
		view.addSubview(errorView)
		
		errorView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
	}
	
	private func setupCustomContents() {
		errorView.confrimButton.setTitle("add_devices_smartconfig_restart".lc_T, for: .normal)
		setupWithOperationType()
		setupWithFailureType()
	}
	
	/// 根据操作类型设置文字
	private func setupWithOperationType() {
		guard errorView != nil else {
			return //避免作为子Controller引起未赋值问题
		}
		
		var text = "add_device_red_light_rotate".lc_T
		if operationType == .readLightRotateDetail {
			text = "add_device_red_light_rotate".lc_T
		} else if operationType == .redLightTwinkleDetail {
			text = "add_device_red_light_rotate".lc_T
		} else if operationType == .redLightConstantDetail {
			text = "add_device_red_light_always".lc_T
		} else {
			text = "add_device_red_light_always".lc_T
		}
		
		errorView.contentLabel.dh_setAttributedText(text: text, font: UIFont.dhFont_t2())
	}
	
	/// 根据设备类型，设置详细说明和图片
	private func setupWithFailureType() {
		guard errorView != nil else {
			return //避免作为子Controller引起未赋值问题
		}
		
		//默认显示的文案、图片
		var imagename = "adddevice_netsetting_power"
		var deatilText = "add_device_disconnect_power_and_restart".lc_T
	
		//目前只有G1类型特殊
		if failureType == .g1 {
			imagename = "adddevice_failhrlp_g1"
			deatilText = "add_device_g1_reset_tip".lc_T
		} else {
			errorView.updateTopImageViewConstraint(top: 0, width: 375, height: 300)
		}
		
		errorView.imageView.image = UIImage(named: imagename)
		errorView.detailLabel.dh_setAttributedText(text: deatilText, font: UIFont.dhFont_t3())
	}
	
	// MARK: - DHAddBaseVCProtocol
	override func rightActionType() -> [DHAddBaseRightAction] {
		var actions: [DHAddBaseRightAction] = [.restart]
		if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
			actions.append(.switchToWired)
		}
		
		return actions
	}
}

extension DHLightDetailViewController {
	// MARK: - DHCommonErrorViewDelegate
	func errorViewOnConfirm(errorView: DHCommonErrorView) {
		baseBackToAddDeviceRoot()
	}
	
	func errorViewOnFAQ(errorView: DHCommonErrorView) {
		basePushToFAQ()
	}
	
	func errorViewOnQuit(errorView: DHCommonErrorView) {
		baseExitAddDevice()
	}
    
    func errorViewOnBackRoot(errorView: DHCommonErrorView) {
        baseBackToAddDeviceRoot()
    }
}
