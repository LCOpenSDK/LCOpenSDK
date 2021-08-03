//
//  Copyright © 2018年 dahua. All rights reserved.
//

import UIKit

class DHBindByOtherViewController: DHAddBaseViewController {

	public static func storyboardInstance() -> DHBindByOtherViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.dh_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "DHBindByOtherViewController") as? DHBindByOtherViewController {
            return controller
        }
		return DHBindByOtherViewController()
	}
	
	/// 被绑定的账号信息
	public var bindAccount: String = ""
	
	/// 左键操作类型
	public var leftAction: DHAddBaseLeftAction = .back
	
	@IBOutlet weak var bindAccountLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var tipView: UIView!
	@IBOutlet weak var warmTipLabel: UILabel!
	@IBOutlet weak var warmTipTextView: UITextView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dhcolor_c43()
        // Do any additional setup after loading the view.
		if dh_screenHeight < 667 {
			topConstraint.constant = 40
		}
		
		setupContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupContent() {
		let text = bindAccount
		bindAccountLabel.dh_setAttributedText(text: text, font: UIFont.boldSystemFont(ofSize: 15))
        bindAccountLabel.textColor = UIColor.dhcolor_c2()
		
		warmTipLabel.text = "add_device_kindly_reminder".lc_T
		warmTipTextView.text = "add_device_unbind_warm_tip".lc_T
        warmTipTextView.textColor = UIColor.dhcolor_c5()
		
		imageView.image = UIImage(named: "adddevice_icon_device_default")
		
		//SMB：色值修改、隐藏提示
		tipView.isHidden = true
		warmTipLabel.textColor = UIColor.dhcolor_c0() //UIColor.dhcolor_c2()
	}
	
	// MARK: DHAddBaseVCProtocol
	override func isRightActionHidden() -> Bool {
		return true
	}
	
	override func leftActionType() -> DHAddBaseLeftAction {
		return leftAction
	}
}
