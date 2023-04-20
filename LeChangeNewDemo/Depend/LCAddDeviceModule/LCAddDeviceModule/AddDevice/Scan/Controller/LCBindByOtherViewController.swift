//
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit

class LCBindByOtherViewController: LCAddBaseViewController {

	public static func storyboardInstance() -> LCBindByOtherViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCBindByOtherViewController") as? LCBindByOtherViewController {
            return controller
        }
		return LCBindByOtherViewController()
	}
	
	/// 被绑定的账号信息
	public var bindAccount: String = ""
    public var deviceId: String = ""
    public var isIot: Bool = false
    
	/// 左键操作类型
	public var leftAction: LCAddBaseLeftAction = .back
    public var isBluetooth:Bool = false
	
	@IBOutlet weak var bindAccountLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var tipView: UIView!
	@IBOutlet weak var warmTipLabel: UILabel!
	@IBOutlet weak var warmTipTextView: UITextView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lccolor_c43()
        // Do any additional setup after loading the view.
        topConstraint.constant = 20
        self.title = ""
		setupContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupContent() {
		let text = bindAccount
		bindAccountLabel.lc_setAttributedText(text: text, font: UIFont.boldSystemFont(ofSize: 15))
        bindAccountLabel.textColor = UIColor.lccolor_c2()
		
		warmTipLabel.text = "add_device_kindly_reminder".lc_T()
        warmTipTextView.textColor = UIColor.lccolor_c5()
		
		imageView.image = UIImage(lc_named: "adddevice_icon_device_default_new")
        imageView.contentMode = .scaleAspectFit
		
		//SMB：色值修改、隐藏提示
		tipView.isHidden = true
		warmTipLabel.textColor = UIColor.lccolor_c0() //UIColor.lccolor_c2()
	}
	
	// MARK: LCAddBaseVCProtocol
	override func isRightActionHidden() -> Bool {
		return true
	}
	
	override func leftActionType() -> LCAddBaseLeftAction {
		return leftAction
	}
}
