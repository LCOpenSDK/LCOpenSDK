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
	@IBOutlet weak var scollView: UIScrollView!
	@IBOutlet weak var faqContainerView: UIView!
	@IBOutlet weak var faqContainerBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var needHelpButton: UIButton!
	
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
		faqContainerView.backgroundColor = UIColor.clear
		needHelpButton.setTitle("add_device_i_need_help".lc_T, for: .normal)
        needHelpButton.setTitleColor(UIColor.lccolor_c2(), for: .normal)
	
		scollView.bounces = false
        scollView.showsVerticalScrollIndicator = false
		if lc_isiPhoneX {
			faqContainerBottomConstraint.constant += 15
		}
		
		imageView.image = UIImage(named: "adddevice_failhrlp_default")
		contentLabel.text = "add_device_connect_timeout".lc_T
        contentLabel.textColor = UIColor.lccolor_c2()
		detailLabel.text = "add_device_operation_by_voice_or_light".lc_T
        detailLabel.textColor = UIColor.lccolor_c5()
        
        
		
		//开放平台隐藏needHelp
		needHelpButton.isHidden = true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layoutButtons()
	}
	
	public static func xibInstance() -> LCNetConnectFailureView {
        if let view = Bundle.lc_addDeviceBundle()?.loadNibNamed("DHNetConnectFailureView", owner: nil, options: nil)!.first as? LCNetConnectFailureView {
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
			detailLabel.text = "add_device_try_again_or_use_other_way".lc_T
		} else if failureType == .accessory {
            contentLabel.text = "add_device_connect_timeout".lc_T
        } else if failureType == .cloudTimeout {
            contentLabel.text = "add_device_config_failed".lc_T
        } else {
			contentLabel.text = "add_device_connect_timeout".lc_T
			detailLabel.text = "add_device_operation_by_voice_or_light".lc_T
		}

		buttonTuples.removeAll()
		buttonTuples.append(contentsOf: failureType.buttonTuples())
        if showQrcodeBtn {
            let button = DHLightButton()
            button.lightType = .qrCodeBtn
            buttonTuples.insert((button, .qrCode), at: 0)
        }

		var tag = 0
		for tuple in buttonTuples {
			tuple.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
			tuple.button.titleLabel?.font = UIFont.lcFont_t4()
			tuple.button.tag = tag
			tag += 1
			scollView.addSubview(tuple.button)
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
			scollView.addSubview(tuple.button)
		}
		
		return buttons
	}

	// MARK: Layout subviews
	private func layoutButtons() {
		
		let scrollHeight = scollView.bounds.height
		let height = CGFloat(buttonTuples.count) * buttonHeight + CGFloat(buttonTuples.count - 1) * buttonVerticalSpace
		if height > scrollHeight {
			scollView.contentSize = CGSize(width: scollView.bounds.width, height: height)
		} else {
			//居中
			//y = (scrollHeight - height) / 2
		}
		
        var topView: UIView = self.detailLabel
		for tuple in buttonTuples {
            tuple.button.snp.makeConstraints { (make) in
                make.left.equalTo(0.0)
                make.width.equalTo(self.scollView)
                make.height.equalTo(self.buttonHeight)
                make.top.equalTo((topView.snp.bottom)).offset(buttonVerticalSpace)
                
                if tuple == buttonTuples.last! {
                    make.bottom.equalTo(self.scollView)
                    make.right.equalTo(self.scollView)
                }
            }
            topView = tuple.button
		}

    }

	// MARK: Actions
	@objc private func buttonClicked(button: UIButton) {
		guard button.tag < buttonTuples.count else {
			return
		}
		
		let tuple = buttonTuples[button.tag]
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: OperationType:\(tuple.operation)")
		action?(failureType, tuple.operation)
	}
	
	@IBAction func onHelpAction(_ sender: Any) {
		help?()
	}
}

