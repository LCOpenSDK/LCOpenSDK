//
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit
import DHScanner

class LCQRScanViewController: LCAddBaseViewController, DHScannerViewControllerDelegate, LCIdentifyContainerProtocol {
    
    private var childScanVC: DHScannerViewController!
    
    private var menuView: LCQRScanMenuView!
    
    private var presenter: LCIdentifyPresenter!

    public static func storyboardInstance() -> LCQRScanViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCQRScanViewController") as? LCQRScanViewController {
            return controller
        }
		return LCQRScanViewController()
	}
    var bindToken: NSString = ""
    var loginToken: NSString = ""
	deinit {
//		presenter.stopSearchDevices()
		NotificationCenter.default.removeObserver(self)
		LCAddDeviceManager.sharedInstance.gatewayIdNeedReset = true
        LCNetSDKHelper.stopNetSDKReport()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
		setupScannerView()
        setupMenuView()
        setupCustomTips()
		setupPresenter()
		addObserver()
        setupNavBar()
		//开启局域网搜索
// 		presenter.startSearchDevices()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		//开启局域网搜索
//		presenter.startSearchDevices()
	}
	
	override func onLeftNaviItemClick(_ button: UIButton) {
		super.onLeftNaviItemClick(button)
//		presenter.stopSearchDevices()
	}
    
	func setupPresenter() {
		self.presenter = LCIdentifyPresenter()
		self.presenter.setup(container: self)
	}
	
	func setupScannerView() {
		childScanVC = DHScannerViewController()
		childScanVC.delegate = self
        childScanVC.pureQRCode = true
		childScanVC.viewStyle.animationViewType = .net
		childScanVC.viewStyle.scanningImage = UIImage(lc_named: "adddevice_qrcode_scanline")
		childScanVC.viewStyle.rectangleTop = 232
        if #available(iOS 13.0, *) {
            childScanVC.scannerType = .system
        }
        childScanVC.viewStyle.rectangleLeft = 45.0
		childScanVC.viewStyle.showRectangleBorder = false
        childScanVC.viewStyle.cornerLineWith = 2
        childScanVC.viewStyle.cornerLineColor = UIColor.lccolor_c43().withAlphaComponent(0.7)
        childScanVC.viewStyle.cornerWidth = 8
        childScanVC.viewStyle.cornerHeight = 8
        childScanVC.viewStyle.backgroundColor = UIColor.lccolor_c51()
  
        addChildViewController(childScanVC)
        view.addSubview(childScanVC.view)
        childScanVC.view.frame = view.bounds
        view.sendSubview(toBack: childScanVC.view)
	}
    
    func setupCustomTips() {
        let switchBtn = LCButton.createButton(with: LCButtonTypeVertical)
        switchBtn.titleLabel?.font = UIFont.lcFont_t6()
        switchBtn.setTitleColor(UIColor.white, for: .normal)
        switchBtn.setTitle("add_device_falshlight_off".lc_T(), for: .normal)
        switchBtn.setTitle("add_device_falshlight_on".lc_T(), for: .selected)
        switchBtn.setImage(UIImage(lc_named: "adddevice_icon_falshlight_n"), for: .normal)
        switchBtn.setImage(UIImage(lc_named: "adddevice_icon_falshlight_h"), for: .selected)
        switchBtn.addTarget(self, action: #selector(onTorchAction), for: .touchUpInside)
        self.view.addSubview(switchBtn)
        let width = self.view.bounds.width
        switchBtn.snp.updateConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(width - 45*2 + 232 - 60 - 8)
            make.height.equalTo(60)
        }
        
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.layer.cornerRadius = 10
        container.clipsToBounds = true
        
        let tmpview = UIView()
        tmpview.backgroundColor = UIColor.black.withAlphaComponent(0.3);
        
        let tipLabel = UILabel()
        tipLabel.textColor = UIColor.lccolor_c43()
        tipLabel.font = UIFont.lcFont_t6()
        tipLabel.text = "add_device_scan_device_qr_code_tip".lc_T()
        tipLabel.numberOfLines = 2
        
        let qrcodeIconImg = UIImageView()
        qrcodeIconImg.image = UIImage(lc_named: "adddevice_qrcode_icon_tip")
        
        self.view.addSubview(container)
        container.addSubview(tmpview)
        tmpview.addSubview(tipLabel)
        tmpview.addSubview(qrcodeIconImg)
        self.view.bringSubview(toFront: container)
        container.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: width - 45*2, height: 60))
            make.top.equalTo(width - 45*2 + 232 + 21)
        }
        tmpview.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
        qrcodeIconImg.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 59.5, height: 43))
        }
        tipLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(qrcodeIconImg.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setupMenuView() {
        let serialModel = QRScanMenuModel.init(title: "add_device_add_bySn".lc_T(), imageName: "adddevice_scan_input_sn", menuType: .serialNumber)
        let photoAlbumModel = QRScanMenuModel.init(title: "add_device_add_byPhotoAlbum".lc_T(), imageName: "adddevice_icon_photo", menuType: .photoAlbum)
        menuView = LCQRScanMenuView.init(qrScanMenuModels: [serialModel, photoAlbumModel])
        menuView.delegate = self
        view.addSubview(menuView)
        
        menuView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview().offset(-LC_bottomSafeMargin - 5)
            make.height.equalTo(110)
        }
    }
    
    fileprivate func setupNavBar() {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        let navView = UIView()
        navView.backgroundColor = UIColor.clear
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.lccolor_c43()
        titleLabel.font = UIFont.lcFont_t2()
        titleLabel.text = "add_device_title".lc_T()
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage.init(named: "common_icon_backarrow_white"), for: .normal)
        backBtn.addTarget(self, action: #selector(onLeftNaviItemClick(_:)), for: .touchUpInside)
        self.view.addSubview(container)
        container.addSubview(navView)
        navView.addSubview(titleLabel)
        navView.addSubview(backBtn)
        self.view.bringSubview(toFront: container)
        container.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(LC_navViewHeight)
        }
        navView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(lc_navBarHeight)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
    }

    @objc func onInPutSnAction() {
                LCAddDeviceManager.sharedInstance.isEnterByQrcode = false
                let vc = LCInputSNViewController.storyboardInstance()
                navigationVC()?.pushViewController(vc, animated: true)
    }
    
    func onPhotoAlbumAction() {
        LCPermissionHelper.requestAlbumPermission({ (granted) in
            guard granted else {
                return
            }

            let albumPicker = UIImagePickerController()
            albumPicker.delegate = self
            albumPicker.modalPresentationStyle = .currentContext
            albumPicker.isNavigationBarHidden = true
            albumPicker.isToolbarHidden = true
            albumPicker.allowsEditing = true
            albumPicker.sourceType = .photoLibrary

            self.present(albumPicker, animated: true, completion: nil)
        })
    }
    
	@objc func onTorchAction(button: UIButton) {
		button.isSelected = !button.isSelected
		childScanVC.torchOn = button.isSelected
	}
	
	// MARK: LCIdentifyContainerProtocol
	func navigationVC() -> UINavigationController? {
		return self.navigationController
	}
	
	func mainView() -> UIView {
		return self.view
	}
	
	func mainController() -> UIViewController {
		return self
	}
	
	func pauseIdentify() {
		self.childScanVC.pauseScanning()
	}
	
	func resumeIdenfity() {
		self.childScanVC.resumeScanning()
	}
	
	func retry() {
		
	}
    
    func smb_updateUI(deviceInfo: LCUserDeviceBindInfo) {
    
    }
}

extension LCQRScanViewController {
	func scanResult(text: String, outputImage: UIImage?) {
		print(" \(NSStringFromClass(self.classForCoder))::Scan code \(text)")
        //每次重新扫描都要重置
        LCAddDeviceManager.sharedInstance.reset()
        
        addDeviceStartLog(text: text)
		_ = presenter.checkQRCode(codeString: text)
        LCAddDeviceManager.sharedInstance.isEnterByQrcode = true
	}
	
    private func addDeviceStartLog(text: String) {
        let model = LCAddDeviceLogModel()
        model.bindDeviceType = StartAddType.QRCode
        model.inputData = text
        LCAddDeviceLogManager.shareInstance.addDeviceStartLog(model: model)
    }
    
	// MARK: Notifications
	func addObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
	}
	
	@objc func enterBackground() {

	}
}

extension LCQRScanViewController: LCQRScanMenuViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - LCQRScanMenuViewDelegate
    func qrScanMenu(_ menuView: LCQRScanMenuView, didSelectedMenuAt type: QRScanMenuType) {
        switch type {
        case .serialNumber:
            self.onInPutSnAction()
        case .photoAlbum:
            self.onPhotoAlbumAction()
        default:
            break
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        LCProgressHUD.show(on: view)
        if let resultStr = DHScannerUtils.decodeImage(image: image), resultStr.count > 0 {
            print("110801====DHScannerUtils:\(resultStr)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                LCProgressHUD.hideAllHuds(self.view)
                self.scanResult(text: resultStr, outputImage: image)
            }
        } else {
            let ciImage : CIImage = CIImage(image: image)!
            let context = CIContext(options: nil)
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
            let features = detector?.features(in: ciImage)
            if let feature = features?.first as? CIQRCodeFeature, let resultStr = feature.messageString, resultStr.count > 0 {
                print("110801======CIQRCodeFeature:\(resultStr)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    LCProgressHUD.hideAllHuds(self.view)
                    self.scanResult(text: resultStr, outputImage: image)
                }
            }else {
                LCProgressHUD.hideAllHuds(view)
                LCProgressHUD.showMsg("add_device_scanning_error_tip".lc_T())
            }
        }
    }
}

