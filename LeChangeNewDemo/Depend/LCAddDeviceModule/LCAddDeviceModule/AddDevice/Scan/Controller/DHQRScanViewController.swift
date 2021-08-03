//
//  Copyright © 2018年 dahua. All rights reserved.
//

import UIKit
import DHScanner

class DHQRScanViewController: DHAddBaseViewController, DHScannerViewControllerDelegate, DHIdentifyContainerProtocol {
	
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    private var childScanVC: DHScannerViewController!
    private var menuView: DHQRScanMenuView!
	
	private var presenter: DHIdentifyPresenter!
	
	@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var scanWidth: NSLayoutConstraint!
    
//    @IBOutlet weak var inputSnButton: UIButton!
    @IBOutlet weak var inputSnView: UIView!
    @IBOutlet weak var inputSnLabel: UILabel!
    
    public static func storyboardInstance() -> DHQRScanViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "DHQRScanViewController") as? DHQRScanViewController {
            return controller
        }
		return DHQRScanViewController()
	}
	
	deinit {
		presenter.stopSearchDevices()
		NotificationCenter.default.removeObserver(self)
		DHAddDeviceManager.sharedInstance.gatewayIdNeedReset = true
        DHNetSDKHelper.stopNetSDKReport()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		title = "add_device_title".lc_T
		setupScannerView()
        setupMenuView()
		setupPresenter()
        setupNaviRightItem()
        setupInputSNButton()
		addObserver()
		setupCustomContents()
		
		//开启局域网搜索
		presenter.startSearchDevices()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        //每次都要重置
        DHAddDeviceManager.sharedInstance.reset()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		switchBtn.isSelected = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		//开启局域网搜索
		presenter.startSearchDevices()
		
		//更新失败，需要再次更新
		DHOMSConfigManager.sharedManager.checkUpdateDeviceModels()
	}
	
	override func onLeftNaviItemClick(_ button: UIButton) {
		super.onLeftNaviItemClick(button)
		presenter.stopSearchDevices()
	}
	
	func setupCustomContents() {
		tipLabel.text = "add_device_scan_device_qr_code".lc_T
        tipLabel.textColor = UIColor.dhcolor_c43()
        
        switchBtn.titleLabel?.font = UIFont.dhFont_t5()
        switchBtn.setTitleColor(UIColor.white, for: .normal)
        switchBtn.setTitle("add_device_falshlight_off".lc_T, for: .normal)
        switchBtn.setTitle("add_device_falshlight_on".lc_T, for: .selected)
        switchBtn.setImage(UIImage(named: "adddevice_icon_falshlight_n"), for: .normal)
        switchBtn.setImage(UIImage(named: "adddevice_icon_falshlight_h"), for: .selected)
        switchBtn.addTarget(self, action: #selector(onTorchAction), for: .touchUpInside)
        switchBtn.setUIButtonImageUpWithTitleDownUI()
	}
	
	func setupPresenter() {
		self.presenter = DHIdentifyPresenter()
		self.presenter.setup(container: self)
	}
	
	func setupScannerView() {
		imageView.image = UIImage(named: "adddevice_pic_qrcode")
		
		childScanVC = DHScannerViewController()
		childScanVC.delegate = self
		
		childScanVC.viewStyle.animationViewType = .net
		childScanVC.viewStyle.scanningImage = UIImage(named: "adddevice_qrcode_scanline")
		childScanVC.viewStyle.rectangleTop = topConstraint.constant

		//适配ipad显示
		if UIDevice.current.userInterfaceIdiom == .pad {
			scanWidth.constant = view.bounds.width - 400
		} else {
			scanWidth.constant = imageView.bounds.width + 40
		}

		childScanVC.viewStyle.rectangleLeft = (view.bounds.width - scanWidth.constant) / 2.0
		childScanVC.viewStyle.showRectangleBorder = false
		childScanVC.viewStyle.cornerLineWith = 4
        childScanVC.viewStyle.cornerLineColor = UIColor.dhcolor_c43()
        childScanVC.viewStyle.cornerWidth = 40
        childScanVC.viewStyle.cornerHeight = 40
        childScanVC.viewStyle.backgroundColor = UIColor.dhcolor_c51()
  
        addChildViewController(childScanVC)
        view.addSubview(childScanVC.view)
        childScanVC.view.frame = view.bounds
        
        view.sendSubview(toBack: childScanVC.view)
	}
    
    func setupMenuView() {
        let serialModel = QRScanMenuModel.init(title: "add_device_add_bySn".lc_T, imageName: "adddevice_icon_number", menuType: .serialNumber)
        let photoAlbumModel = QRScanMenuModel.init(title: "add_device_add_byPhotoAlbum".lc_T, imageName: "adddevice_icon_photo", menuType: .photoAlbum)
        menuView = DHQRScanMenuView.init(qrScanMenuModels: [serialModel, photoAlbumModel])
        menuView.delegate = self
        view.addSubview(menuView)
        
        menuView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
			make.bottom.equalToSuperview().offset(-dh_bottomSafeMargin)
            make.height.equalTo(90.0)
        }
    }
	
    override func setupNaviRightItem() {
        
    }
    
    func setupInputSNButton() {
        inputSnView.isHidden = true
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(onInPutSnAction))
        inputSnView.addGestureRecognizer(tapGes)
        inputSnView.backgroundColor = UIColor.clear
        inputSnView.layer.borderColor = UIColor.dhcolor_c43().cgColor
        inputSnView.layer.borderWidth = 1
        inputSnView.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
    }

    
    @objc func onInPutSnAction() {
        DHAddDeviceManager.sharedInstance.isEnterByQrcode = false
        let vc = DHInputSNViewController.storyboardInstance()
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
	
	// MARK: DHIdentifyContainerProtocol
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
    
    func showAddBoxGuidView(needShoeBox: @escaping ((Bool) -> Void)) {
        let addBoxGuideView = LCAddBoxGudieView(frame: UIScreen.main.bounds) { (isShowAgain) in
            needShoeBox(isShowAgain)
            self.presenter.addOnlineDevice(devicePassword: "")
        }
        self.navigationVC()?.view.superview?.addSubview(addBoxGuideView!)
    }
	
	func retry() {
		
	}
    
    func smb_updateUI(deviceInfo: DHUserDeviceBindInfo) {
    
    }
}

extension DHQRScanViewController {
	func scanResult(text: String, outputImage: UIImage?) {
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Scan code \(text)")
        
        addDeviceStartLog(text: text)
        
		_ = presenter.checkQRCode(codeString: text)
        DHAddDeviceManager.sharedInstance.isEnterByQrcode = true
	}
	
    private func addDeviceStartLog(text: String) {
        let model = DHAddDeviceLogModel()
        model.bindDeviceType = StartAddType.QRCode
        model.inputData = text
        DHAddDeviceLogManager.shareInstance.addDeviceStartLog(model: model)
    }
    
	// MARK: Notifications
	func addObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
	}
	
	@objc func enterBackground() {
		switchBtn.isSelected = false
	}
}

extension DHQRScanViewController: DHQRScanMenuViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - DHQRScanMenuViewDelegate
    func qrScanMenu(_ menuView: DHQRScanMenuView, didSelectedMenuAt type: QRScanMenuType) {
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
                LCProgressHUD.showMsg("add_device_scanning_error_tip".lc_T)
            }
        }
    }
}

