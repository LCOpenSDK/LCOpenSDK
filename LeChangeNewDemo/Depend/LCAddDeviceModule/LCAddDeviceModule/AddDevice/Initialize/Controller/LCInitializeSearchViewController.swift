//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	设备初始化：搜索界面

import UIKit
import SnapKit

class LCInitializeSearchViewController: LCAddBaseViewController, LCCycleTimerViewDelegate, LCCommonErrorViewDelegate {

	@IBOutlet weak var topImageView: UIImageView!
	@IBOutlet weak var cycleTimerView: LCCycleTimerView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var scanImageView: UIImageView!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    public static func storyboardInstance() -> LCInitializeSearchViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
		let controller = storyboard.instantiateViewController(withIdentifier: "LCInitializeSearchViewController")
		return controller as! LCInitializeSearchViewController
	}
	
	private lazy var errorView: LCCommonErrorView = {
		let view = LCCommonErrorView.xibInstance()
        view.contentMode = .scaleAspectFit
		view.imageView.image = UIImage(named: "adddevice_fail_undetectable")
		view.frame = self.view.bounds
        if lc_screenHeight < 667 {
            view.contentLabel.lc_setAttributedText(text: "add_device_detect_safe_network_config_failed".lc_T, font: UIFont.systemFont(ofSize: 18))
            view.updateTopImageViewConstraint(top: 5, width: 220, height: 220)
        } else {
            view.contentLabel.lc_setAttributedText(text: "add_device_detect_safe_network_config_failed".lc_T, font: UIFont.lcFont_t1())
        }
		
		view.delegate = self
		return view
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lccolor_c43()
        // Do any additional setup after loading the view.
		configCustomContents()
		configCycleTimerView()
		startSearchDevices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		cycleTimerView.stopTimer()
		stopScanAnimation()
		
		//由于页面是在父视图显示的，需要单独区分超时与未超时的情况
	}
	
	public func startSearchDevices() {
		self.cycleTimerView.startTimer()
		startScanAnimation()
	}
	
	private func configCustomContents() {
//        topImageView.snp.updateConstraints { make in
//            make.top.equalTo(self.customNavView.snp.bottom)
//        }
        
        contentLabel.textColor = UIColor.lccolor_c2()
        if lc_screenHeight < 667 {
            labelTopConstraint.constant = 5
            labelBottomConstraint.constant = 15
            contentLabel.font = UIFont.systemFont(ofSize: 18)
        }

		contentLabel.text = "add_device_detecting_network_safety".lc_T
		topImageView.image = UIImage(named: "adddevice_netsetting_detection")
		scanImageView.image = UIImage(named: "adddevice_netsetting_detection_1")
	}
	
	private func configCycleTimerView() {
		cycleTimerView.maxTime = LCAddConfigTimeout.initialSearch
		cycleTimerView.delegate = self
	}
	
	private func startScanAnimation() {
		let animation = CABasicAnimation()
		animation.fromValue = 0
		animation.toValue = topImageView.bounds.height - scanImageView.bounds.height - 50
		animation.repeatCount = MAXFLOAT
		animation.duration = 3
		animation.isRemovedOnCompletion = false
		animation.autoreverses = true
		animation.fillMode = kCAFillModeForwards
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		scanImageView.layer.add(animation, forKey: "transform.translation.y")
	}
	
	private func stopScanAnimation() {
		scanImageView.layer.removeAllAnimations()
	}

	private func pushToInitializePasswordVC() {
		let controller = LCInitializePasswordViewController.storyboardInstance()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: LCAddBaseVCProtocol
	override func leftActionType() -> LCAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
}

extension LCInitializeSearchViewController {
	
	func cycleTimerViewTimeout(cycleView: LCCycleTimerView) {
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: Capture timeout...")
		errorView.showOnView(superView: self.view, animated: true)
		
	}
	
	func cycleTimerView(cycleView: LCCycleTimerView, tick: Int) {
		let deviceId = LCAddDeviceManager.sharedInstance.deviceId
		let device = LCNetSDKSearchManager.sharedInstance().getNetInfo(byID: deviceId)
		guard device != nil else {
			return
		}
		
		// *避免刚进入就跳其他界面了
		if tick == 0 {
			return
		}
		
		cycleTimerView.stopTimer()
		
		// * 无初始化能力、已经初始化、支持SC，进入连接云平台界面
		// * 未初始化进入初始化密码设置界面
		if device!.deviceInitStatus == .noAbility || device!.deviceInitStatus == .init || LCAddDeviceManager.sharedInstance.isSupportSC {
			//【*】软Ap：无初始化能力集，并且是国内的，跳转免密码选择wifi界面； 其他进入登录界面
			//【*】新方案所有普通设备进入连接乐橙云平台界面
			//【*】其他设备进入连接乐橙云平台界面
			LCAddDeviceManager.sharedInstance.isContainInitializeSearch = true
			
			if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp {
				if device!.deviceInitStatus == .noAbility, LCModuleConfig.shareInstance().isChinaMainland {
					self.pushToWifiSelectVcWithPassword()
				} else {
					self.pushToApLoginVC()
				}
			} else {
				self.basePushToConnectCloudVC(devicePassword: nil)
			}
		} else {
			self.pushToInitializePasswordVC()
		}
	}
	
	/// 跳转wifi选择，内部填充admin
	private func pushToWifiSelectVcWithPassword() {
		let controller = LCApWifiSelectViewController.storyboardInstance()
		controller.devicePassword = "admin"
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func pushToApLoginVC() {
		let controller = LCAuthPasswordViewController.storyboardInstance()
		controller.presenter = LCApAuthPasswordPresenter(container: controller)
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func pushToAuthPasswordVC() {
		let controller = LCAuthPasswordViewController.storyboardInstance()
		controller.presenter = LCAuthPasswordPresenter(container: controller)
		self.navigationController?.pushViewController(controller, animated: true)
	}

	// MARK: LCCommonErrorViewDelegate
	func errorViewOnConfirm(errorView: LCCommonErrorView) {
		errorView.dismiss(animated: true)
		startSearchDevices()
		
	}
	
	func errorViewOnFAQ(errorView: LCCommonErrorView) {
		basePushToFAQ()
	}
	
	func errorViewOnQuit(errorView: LCCommonErrorView) {
		baseExitAddDevice()
	}
    
    func errorViewOnBackRoot(errorView: LCCommonErrorView) {
        baseBackToAddDeviceRoot()
    }
}
