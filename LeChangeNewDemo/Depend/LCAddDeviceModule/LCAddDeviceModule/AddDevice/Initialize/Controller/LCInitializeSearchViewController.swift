//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	设备初始化：搜索界面

import UIKit
import SnapKit
import LCOpenSDKDynamic

class LCInitializeSearchViewController: LCAddBaseViewController, LCCycleTimerViewDelegate {

	@IBOutlet weak var topImageView: UIImageView!
	@IBOutlet weak var cycleTimerView: LCCycleTimerView!
	@IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var startOverBtn: UIButton!
    
    var searchedDevice: LCOpenSDK_SearchDeviceInfo?
    
    public static func storyboardInstance() -> LCInitializeSearchViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
		let controller = storyboard.instantiateViewController(withIdentifier: "LCInitializeSearchViewController")
		return controller as! LCInitializeSearchViewController
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
		configCustomContents()
		configCycleTimerView()
		startSearchDevices()
        
        if let image = self.topImageView.image {
            let height = (self.topImageView.frame.size.width / image.size.width) * image.size.height
            self.topImageView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().offset(-25)
                make.top.equalToSuperview()
                make.width.equalTo(self.topImageView.frame.size.width)
                make.height.equalTo(height)
            }
        }
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
	}
	
	public func startSearchDevices() {
		self.cycleTimerView.startTimer()
        LCOpenSDK_SearchDevices.share().start(withDeviceId: LCAddDeviceManager.sharedInstance.deviceId, timeOut: 60*2) {[weak self] deviceInfo in
            self?.searchedDevice = deviceInfo
            
            LCOpenSDK_SearchDevices.share().stop()
        }
	}
	
	private func configCustomContents() {
//#if DEBUG
//        self.createDebugView()
//#endif
        self.contentLabel.text = "add_device_detecting_network_safety".lc_T()
        self.tryAgainBtn.titleLabel?.text = "add_device_try_again".lc_T()
        self.startOverBtn.titleLabel?.text = "add_device_re_add".lc_T()
        self.startOverBtn.layer.borderWidth = 1.0
        self.startOverBtn.layer.borderColor = UIColor.lccolor_c0().cgColor
	}
	
	private func configCycleTimerView() {
		cycleTimerView.maxTime = LCAddConfigTimeout.initialSearch
		cycleTimerView.delegate = self
	}
	
	private func pushToInitializePasswordVC() {
		let controller = LCInitializePasswordViewController.storyboardInstance()
        controller.searchedDevice = searchedDevice
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: LCAddBaseVCProtocol
	override func leftActionType() -> LCAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
    
    @IBAction func tryAgain(_ sender: Any) {
        tryAgainBtn.isHidden = true
        startOverBtn.isHidden = true
        cycleTimerView.isHidden = false
        cycleTimerView.stopTimer()
        cycleTimerView.startTimer()
        contentLabel.text = "add_device_detecting_network_safety".lc_T()
    }
    
    @IBAction func startOver(_ sender: Any) {
        self.baseExitAddDevice()
    }
    
    private func initializeFailure() {
        tryAgainBtn.isHidden = false
        startOverBtn.isHidden = false
        cycleTimerView.isHidden = true
        contentLabel.text = "add_device_initialize_failed".lc_T()
    }
}

extension LCInitializeSearchViewController {
	func cycleTimerViewTimeout(cycleView: LCCycleTimerView) {
		print(" \(NSStringFromClass(self.classForCoder)):: Capture timeout...")
        self.initializeFailure()
	}
	
	func cycleTimerView(cycleView: LCCycleTimerView, tick: Int) {
        if self.searchedDevice == nil {
            return
        }
        
        guard let deviceInfo = self.searchedDevice  else {
			return
		}
		
		// *避免刚进入就跳其他界面了
		if tick == 0 {
			return
		}
		
		cycleTimerView.stopTimer()
		
		// * 无初始化能力、已经初始化、支持SC，进入连接云平台界面
		// * 未初始化进入初始化密码设置界面
		if deviceInfo.deviceInitStatus == .noAbility || deviceInfo.deviceInitStatus == .init || LCAddDeviceManager.sharedInstance.isSupportSC {
			//【*】软Ap：无初始化能力集，并且是国内的，跳转免密码选择wifi界面； 其他进入登录界面
			//【*】新方案所有普通设备进入连接乐橙云平台界面
			//【*】其他设备进入连接乐橙云平台界面
			if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp {
                self.pushToApLoginVC()
			} else {
				self.basePushToConnectCloudVC(devicePassword: nil)
			}
		} else {
			self.pushToInitializePasswordVC()
		}
	}
	
	private func pushToApLoginVC() {
		let controller = LCAuthPasswordViewController.storyboardInstance()
		controller.presenter = LCApAuthPasswordPresenter(container: controller)
		self.navigationController?.pushViewController(controller, animated: true)
	}
}


// MARK: - Debug
//extension LCInitializeSearchViewController {
//    private func createDebugView() {
//        let debug_Success: UIButton = {
//            let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 40))
//            btn.backgroundColor = UIColor.white
//            btn.titleLabel?.font = UIFont.lcFont_t3()
//            btn.setTitle("连接云平台".lc_T(), for: .normal)
//            btn.setTitleColor(UIColor.lccolor_c0(), for: .normal)
//            btn.addTarget(self, action: #selector(debugSuccess), for: .touchUpInside)
//            return btn
//        }()
//
//        let debug_Failure: UIButton = {
//            let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 40))
//            btn.backgroundColor = UIColor.white
//            btn.titleLabel?.font = UIFont.lcFont_t3()
//            btn.setTitle("设置密码".lc_T(), for: .normal)
//            btn.setTitleColor(UIColor.lccolor_c0(), for: .normal)
//            btn.addTarget(self, action: #selector(debugFailure), for: .touchUpInside)
//            return btn
//        }()
//
//        self.view.addSubview(debug_Success)
//        self.view.addSubview(debug_Failure)
//
//        debug_Failure.snp.makeConstraints({ (make) in
//            make.centerX.equalTo(self.view)
//            make.bottom.equalTo(self.view).offset(-LC_bottomSafeMargin)
//        })
//
//        debug_Success.snp.makeConstraints({ (make) in
//            make.centerX.equalTo(self.view)
//            make.bottom.equalTo(debug_Failure.snp.top).offset(-10)
//        })
//    }
//
//    @objc private func debugSuccess() {
//        self.basePushToConnectCloudVC(devicePassword: nil)
//    }
//
//    @objc private func debugFailure() {
//        self.pushToInitializePasswordVC()
//    }
//}
