//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	WIFI配置引导：手机音量设置检查

import UIKit
import AVFoundation

class LCPhoneVolumeCheckViewController: LCGuideBaseViewController {

    // 定时器
    fileprivate var timer: Timer?
    var btnTitleNum = 5
	var isPushed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		adjustConstraint()
        let tipText = "common_next".lc_T
        let beginNum = "(5s)"
        let newTip = "\(tipText)\(beginNum)"
        guideView.nextButton.setTitle(newTip, for: .normal)
        startTimer()
		

    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private func adjustConstraint() {
		guideView.topImageView.contentMode = .scaleAspectFill
		guideView.updateTopImageViewConstraint(top: 0, width: view.bounds.width, maxHeight: 300)
	}
	
	private func pushToWifiConnectVC() {
		isPushed = true
		let controller = LCWifiConnectViewController.storyboardInstance()
        controller.showPlayAudio = LCAddDeviceManager.sharedInstance.isSupportSoundWave
		
		//【*】不支持声波
		//【*】支持声波的：国内，新旧声波提示（SMB只提示声波）
		//【*】支持声波的：海外提示
		if LCAddDeviceManager.sharedInstance.isSupportSoundWave == false {
			controller.descriptionContent = "add_device_keep_phone_close_to_device".lc_T
		} else {
			controller.descriptionContent = "add_device_adjust_phone_volume_to_hear_bugu".lc_T
		}
       
		self.navigationController?.pushViewController(controller, animated: true)
	}

	// MARK: - LCGuideBaseVCProtocol
	override func tipText() -> String? {
		if LCAddDeviceManager.sharedInstance.isSupportSoundWave {
			return "add_device_adjust_phone_volume".lc_T
		}
		
		return "add_device_keep_phone_close_to_device".lc_T
	}
	
	override func tipImageName() -> String? {
		if LCAddDeviceManager.sharedInstance.isSupportSoundWave {
			return "adddevice_netsetting_near"
		}
		return "adddevice_netsetting_closeto"
	}
	
	override func descriptionText() -> String? {
		//【*】不支持声波
		if LCAddDeviceManager.sharedInstance.isSupportSoundWave == false {
			return ""
		}
		
		//【*】提示声波
		//return "add_device_will_hear_volume".lc_T
        return "add_device_will_hear_bugu".lc_T
	}
	
	override func isCheckHidden() -> Bool {
		return true
	}
	
	override func doNext() {
		guard isPushed == false else {
			return
		}
		
		//支持声波配对才提示
		if LCAddDeviceManager.sharedInstance.isSupportSoundWave, checkPhoneVolueIsValid() == false {
			LCProgressHUD.showMsg("add_device_add_volume_tip".lc_T)
		}
		
		pushToWifiConnectVC()
	}
	
	override func rightActionType() -> [LCAddBaseRightAction] {
		var actions: [LCAddBaseRightAction] = [.restart]
		if LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
			actions.append(.switchToWired)
		}
		
		return actions
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
        
    }
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.syncDownloadStatus), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func syncDownloadStatus() {
        let next = "common_next".lc_T
        btnTitleNum -= 1
        let titleStr = "\(next)(\(btnTitleNum)s)"
        guideView.nextButton.setTitle(titleStr, for: .normal)
        if btnTitleNum == 0 {
            stopTimer()
            doNext()
        }
    }

	// MARK: - CheckVolume
	func checkPhoneVolueIsValid() -> Bool {
		var isValid = false
		let valume = AVAudioSession.sharedInstance().outputVolume
		print(" \(NSStringFromClass(self.classForCoder))::Phone volume:\(valume)")
		if valume >= 0.8 {
			isValid = true
		}
		
		return isValid
	}
}
