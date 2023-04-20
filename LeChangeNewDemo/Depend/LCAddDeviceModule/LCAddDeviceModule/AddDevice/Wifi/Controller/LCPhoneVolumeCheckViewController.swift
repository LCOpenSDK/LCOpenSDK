//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	WIFI配置引导：手机音量设置检查

import UIKit
import AVFoundation

class LCPhoneVolumeCheckViewController: LCAddBaseViewController, LCAddGuideViewDelegate {
    func guideView(view: LCAddGuideView, action: LCAddGuideActionType) {
        if action == .next {
            pushToWifiConnectVC()
        }
    }
    
    // 定时器
    fileprivate var timer: Timer?
    var btnTitleNum = 5
    
    private let guideView: LCAddGuideView = LCAddGuideView.xibInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        guideView.delegate = self
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        guideView.topImageView.image = UIImage(lc_named: "adddevice_netsetting_guide_voice")
        guideView.topTipLabel.text = "add_device_network_config_guide_sound".lc_T()
        guideView.descriptionLabel.text = "add_device_network_config_guide_sound_tip".lc_T()
        let newTip = "\("common_next".lc_T())(5s)"
        guideView.nextButton.setTitle(newTip, for: .normal)
        guideView.detailButton.isHidden = true
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if LCAddDeviceManager.sharedInstance.isSupportSoundWave, checkPhoneVolueIsValid() == false {
            LCProgressHUD.showMsg("add_device_add_volume_tip".lc_T())
        }
    }

	private func pushToWifiConnectVC() {
		let controller = LCWifiConnectViewController.storyboardInstance()
        controller.showPlayAudio = LCAddDeviceManager.sharedInstance.isSupportSoundWave
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	override func rightActionType() -> [LCAddBaseRightAction] {
		var actions: [LCAddBaseRightAction] = [.restart]
		if LCAddDeviceManager.sharedInstance.supportWired() {
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
        let next = "common_next".lc_T()
        btnTitleNum -= 1
        let titleStr = "\(next)(\(btnTitleNum)s)"
        guideView.nextButton.setTitle(titleStr, for: .normal)
        if btnTitleNum == 0 {
            stopTimer()
            pushToWifiConnectVC()
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
