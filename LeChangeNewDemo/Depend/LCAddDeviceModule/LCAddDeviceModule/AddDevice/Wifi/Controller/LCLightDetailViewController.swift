//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	指示灯：详细说明界面

import UIKit

class LCLightDetailViewController: LCAddBaseViewController, LCCommonErrorViewDelegate {
	/// 错误类型
	public var failureType: LCNetConnectFailureType = .commonWithWired {
		didSet {
			setupWithFailureType()
		}
	}
	
	/// 操作类型
	public var operationType: LCNetConnectFailureOperationType = .redLightConstantDetail {
		didSet {
			setupWithOperationType()
		}
	}

	private var errorView: LCCommonErrorView!
	
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
		errorView = LCCommonErrorView.init()
		errorView.delegate = self
		view.addSubview(errorView)
		
		errorView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
	}
	
	private func setupCustomContents() {
		errorView.tryAgainButton.setTitle("add_devices_smartconfig_restart".lc_T(), for: .normal)
		setupWithOperationType()
		setupWithFailureType()
	}
	
	/// 根据操作类型设置文字
	private func setupWithOperationType() {
		guard errorView != nil else {
			return //避免作为子Controller引起未赋值问题
		}
		
		var text = "add_device_red_light_rotate".lc_T()
		if operationType == .readLightRotateDetail {
			text = "add_device_red_light_rotate".lc_T()
		} else if operationType == .redLightTwinkleDetail {
			text = "add_device_red_light_rotate".lc_T()
		} else if operationType == .redLightConstantDetail {
			text = "add_device_red_light_always".lc_T()
		} else {
			text = "add_device_red_light_always".lc_T()
		}
		
		errorView.titleLabel.lc_setAttributedText(text: text, font: UIFont.lcFont_t2())
	}
	
	/// 根据设备类型，设置详细说明和图片
	private func setupWithFailureType() {
		guard errorView != nil else {
			return //避免作为子Controller引起未赋值问题
		}
		
		//默认显示的文案、图片
		var imagename = "adddevice_netsetting_power"
		var deatilText = "add_device_disconnect_power_and_restart".lc_T()
	
		//目前只有G1类型特殊
		if failureType == .g1 {
			imagename = "adddevice_failhrlp_g1"
			deatilText = "add_device_g1_reset_tip".lc_T()
		} else {
			errorView.updateTopImageViewConstraint(top: 0, width: 375, height: 300)
		}
		
		errorView.imageView.image = UIImage(lc_named: imagename)
	}
	
	// MARK: - LCAddBaseVCProtocol
	override func rightActionType() -> [LCAddBaseRightAction] {
		var actions: [LCAddBaseRightAction] = [.restart]
        // TODO: 切换配网方式需要修改
//		if LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
//			actions.append(.switchToWired)
//		}
		
		return actions
	}
}

extension LCLightDetailViewController {
	// MARK: - LCCommonErrorViewDelegate
	func errorViewOnTryAgain(errorView: LCCommonErrorView) {
		baseBackToAddDeviceRoot()
	}
	
	
	func errorViewOnQuit(errorView: LCCommonErrorView) {
		baseExitAddDevice()
	}
    
//    func errorViewOnBackRoot(errorView: LCCommonErrorView) {
//        baseBackToAddDeviceRoot()
//    }
}
