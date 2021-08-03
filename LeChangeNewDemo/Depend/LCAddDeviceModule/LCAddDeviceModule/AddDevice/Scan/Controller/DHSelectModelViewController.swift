//
//  Copyright © 2018年 dahua. All rights reserved.
//	设备类型选择界面

import UIKit


class DHSelectModelViewController: DHAddBaseViewController,DHIdentifyContainerProtocol,UITextFieldDelegate {
	
    @IBOutlet weak var inputBtn: UIButton!
    @IBOutlet weak var inputModelField: UITextField!
    @IBOutlet weak var otherModelBtn: UIButton!
    @IBOutlet weak var modelTip: UILabel!
    @IBOutlet weak var sureButton: UIButton!
    
    var topTipLabel: UILabel!
    
    var secTipLabel: UILabel!
    
    var imageTipLabel: UILabel!
    
    var tipImageView: UIImageView!
    
    var deviceId: String = ""
	
	var dataSource = [DHOMSDeviceType]()
	
	/// 每行显示的个数，数据源不足的填空的cell
	private var horizontalItemNumber = Int(4)
	
	/// 分隔线尺寸【iPhone6及以下，0.5的分隔线显示不了】
	private var separatorSize = dh_screenHeight <= 667 ? CGSize(width: 0.75, height: 0.75) : CGSize(width: 0.5, height: 0.5)
	
	private var presenter: DHIdentifyPresenter!
	
	public static func storyboardInstance() -> DHSelectModelViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "DHSelectModelViewController") as? DHSelectModelViewController {
            return controller
        }
		return DHSelectModelViewController()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
        self.setupView()
		self.setupPresenter()
		
		//【*】如果平台未加载成功过，仍需要重新更新数据
		dataSource.append(contentsOf: DHOMSConfigManager.sharedManager.types)//【*】每个类型加上通用
        
		if DHOMSConfigManager.sharedManager.isUpdatedSuccessfully == false {
			DHOMSConfigManager.sharedManager.checkUpdateDeviceModels()
		}
		
		self.addModelsUpdatedObserver()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func addModelsUpdatedObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(omsModelsUpdated), name: NSNotification.Name(rawValue: "LCNotificationOMSIModelsUpdated"), object: nil)
	}
	
	@objc func omsModelsUpdated() {
		if DHOMSConfigManager.sharedManager.types.count > 0 {
			self.dataSource.removeAll()
			self.dataSource.append(contentsOf: DHOMSConfigManager.sharedManager.types)
			
		}
	}
	
    func setupView() {
        self.inputBtn.setImage(UIImage.init(named: "adddevice_box_checkbox"), for: .normal)
        self.inputBtn.setImage(UIImage.init(named: "adddevice_box_checkbox_checked"), for: .selected)
        self.inputBtn.addTarget(self, action: #selector(inputAction), for: .touchUpInside)
        self.otherModelBtn.setImage(UIImage.init(named: "adddevice_box_checkbox"), for: .normal)
        self.otherModelBtn.setImage(UIImage.init(named: "adddevice_box_checkbox_checked"), for: .selected)
        self.otherModelBtn.addTarget(self, action: #selector(otherAction), for: .touchUpInside)
        self.inputModelField.isUserInteractionEnabled = false
        self.inputModelField.returnKeyType = .done
        self.inputModelField.delegate = self
        
        self.modelTip.textColor = UIColor.dhcolor_c30()
        self.sureButton.backgroundColor = UIColor.dhcolor_c10()
        self.sureButton.setTitle("Button_Confirm".lc_T, for: .normal)
        self.sureButton.layer.cornerRadius = 22.5
        self.sureButton.layer.masksToBounds = true
        self.sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        
        self.topTipLabel = UILabel.init()
        self.topTipLabel.numberOfLines = 0
        self.view.addSubview(self.topTipLabel)
        self.topTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.modelTip)
            make.right.equalTo(self.modelTip)
            make.top.equalTo(self.modelTip.snp_bottom).offset(15)
        }
        let style = NSMutableParagraphStyle.init()
        let str = NSMutableAttributedString(string: "add_device_lechange_tip".lc_T, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
        str.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)], range: NSMakeRange(0, 19))
        str.addAttributes([NSAttributedStringKey.paragraphStyle:style], range: NSMakeRange(0, str.length))
        self.topTipLabel.attributedText = str
        
        self.secTipLabel = UILabel.init()
        self.secTipLabel.numberOfLines = 0
        self.view.addSubview(self.secTipLabel)
        self.secTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.topTipLabel)
            make.right.equalTo(self.topTipLabel)
            make.top.equalTo(self.topTipLabel.snp_bottom).offset(15)
        }
        let secStr = NSMutableAttributedString(string: "add_device_dahua_tip".lc_T, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
        secStr.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)], range: NSMakeRange(0, 17))
        secStr.addAttributes([NSAttributedStringKey.paragraphStyle:style], range: NSMakeRange(0, str.length))
        self.secTipLabel.attributedText = secStr
        
        self.imageTipLabel = UILabel.init()
        self.imageTipLabel.text = "add_device_image_tip".lc_T
        self.imageTipLabel.font = UIFont.dhFont_f2Bold()
        self.view.addSubview(self.imageTipLabel)
        self.imageTipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.topTipLabel)
            make.right.equalTo(self.topTipLabel)
            make.top.equalTo(self.secTipLabel.snp_bottom).offset(15)
        }
        
        self.tipImageView = UIImageView.init()
        self.tipImageView.image = UIImage.init(named: "adddevice_tip_image")
        self.tipImageView.contentMode = .scaleToFill
        self.view.addSubview(self.tipImageView)
        self.tipImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.imageTipLabel.snp_bottom)
            make.height.equalTo(self.tipImageView.snp_width).multipliedBy(0.57)
        }
        
    }
    
	func setupPresenter() {
		self.presenter = DHIdentifyPresenter()
		self.presenter.setup(container: self)
	}
	
	// MARK: Private
    @objc func inputAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.otherModelBtn.isSelected = false
            self.inputModelField.isUserInteractionEnabled = true
        }
    }
    
    @objc func otherAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.inputBtn.isSelected = false
            self.inputModelField.isUserInteractionEnabled = false
        }
    }
    
    @objc func sureAction(_ sender: UIButton) {
        //没有选中按钮
        if !self.inputBtn.isSelected && !self.otherModelBtn.isSelected {
            LCProgressHUD.showMsg("请选择设备类型".lc_T)
            return
        }
        //选中输入按钮
        if self.inputBtn.isSelected {
            if self.inputModelField.text?.count == 0 {
                LCProgressHUD.showMsg("请输入设备类型".lc_T)
                return
            } else {
                self.presenter.getDeviceInfo(deviceId: self.deviceId, qrModel: nil, ncCode: nil, marketModel: self.inputModelField.text ?? "", modeOptional: true)
            }
        }
        
        //选中其他按钮,取数组最后一项来进行设备添加
        if self.otherModelBtn.isSelected {
            if self.dataSource.count > 0 {
                let item = self.dataSource.last?.modelItems.lastObject as? DHOMSDeviceModelItem
                let modelName = item?.deviceModelName
                self.presenter.getDeviceInfo(deviceId: deviceId, qrModel: nil, ncCode: nil, marketModel: modelName, modeOptional: true)
            }
        }
    }
    
    //MARK: - UITextFieldDelegate
    @objc public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
	// MARK: - DHIdentifyContainerProtocol
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
		
	}
	
	func resumeIdenfity() {
		
	}
    
    func showAddBoxGuidView(needShoeBox: @escaping ((Bool) -> Void)) {
        
    }
	
	func retry() {
		
	}
    
    override func isRightActionHidden() -> Bool {
        return true
    }
    
    func smb_updateUI(deviceInfo: DHUserDeviceBindInfo) {
        
    }
}
