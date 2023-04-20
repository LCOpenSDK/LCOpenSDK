//
//  Copyright © 2018年 iblue. All rights reserved.
//	网络连接(配置)超时/失败页面

import UIKit
import SnapKit
class LCNetConnectFailureView: UIView {

	@IBOutlet weak var imageView: UIImageView!
	
    var showQrcodeBtn: Bool = false
    
	/// 失败按钮操作类型【注意循环引用的问题】
	public var action: ((LCNetConnectFailureType, LCNetConnectFailureOperationType) -> ())?
	
	/// 帮助
	public var help: (() -> ())?
	
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var quiteBtn: UIButton!
    
    private var buttonHeight = CGFloat(45)
	private var buttonVerticalSpace = CGFloat(10)
	
	private var buttonTuples = [LCNetConnectFailureTuple]()
	
	private var failureType: LCNetConnectFailureType = .tp1
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func awakeFromNib() {
		super.awakeFromNib()
        backgroundColor = UIColor.lccolor_c43()
		contentLabel.text = "add_device_connect_timeout".lc_T()
        contentLabel.textColor = UIColor.lccolor_c2()
		detailLabel.text = "add_device_operation_by_voice_or_light".lc_T()
        detailLabel.textColor = UIColor.lccolor_c5()
        
        quiteBtn.layer.borderWidth = 1.0
        quiteBtn.layer.borderColor = UIColor.lccolor_c0().cgColor
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	public static func xibInstance() -> LCNetConnectFailureView {
        if let view = Bundle.lc_addDeviceBundle()?.loadNibNamed("LCNetConnectFailureView", owner: nil, options: nil)!.first as? LCNetConnectFailureView {
            return view
        }
		return LCNetConnectFailureView()
	}
	
	// MARK: Buttons Config
	
	/// 使用定义好的类型设置按钮
	///
	/// - Parameter type: 错误类型
	public func setFailureType(type: LCNetConnectFailureType) {
		failureType = type
		
		if failureType == .commonWithWired || failureType == .commonWithoutWired {
			detailLabel.text = "add_device_try_again_or_use_other_way".lc_T()
		} else if failureType == .accessory {
            contentLabel.text = "add_device_connect_timeout".lc_T()
        } else if failureType == .cloudTimeout {
            contentLabel.text = "add_device_config_failed".lc_T()
        } else {
			contentLabel.text = "add_device_connect_timeout".lc_T()
			detailLabel.text = "add_device_operation_by_voice_or_light".lc_T()
		}

		buttonTuples.removeAll()
		buttonTuples.append(contentsOf: failureType.buttonTuples())
        if showQrcodeBtn {
            let button = LCLightButton()
            button.lightType = .qrCodeBtn
            buttonTuples.insert((button, .qrCode), at: 0)
        }
	}

	/// 通用按钮配置（不包含指示灯）
	///
	/// - Parameter byTuples: [(按钮标题,操作类型)]
	/// - Returns: 返回通用按钮，用于外部配置
	public func setup(byTuples: [(title: String, action: LCNetConnectFailureOperationType)]) -> [UIButton] {
		let tuples = LCNetConnectFailureType.commonButtons(config: byTuples)
		buttonTuples.removeAll()
		buttonTuples.append(contentsOf: tuples)
		
		var tag = 0
		var buttons = [UIButton]()
		for tuple in buttonTuples {
			tuple.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
			tuple.button.titleLabel?.font = UIFont.lcFont_t4()
			tuple.button.tag = tag
			tag += 1
			buttons.append(tuple.button)
		}
		
		return buttons
	}

	// MARK: Actions
	@objc private func buttonClicked(button: UIButton) {
		guard button.tag < buttonTuples.count else {
			return
		}
		
		let tuple = buttonTuples[button.tag]
		print(" \(NSStringFromClass(self.classForCoder)):: OperationType:\(tuple.operation)")
		action?(failureType, tuple.operation)
	}
}

