//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	网络连接超时的按钮

import UIKit


enum LCLightButtonType {
	case redConstant
	case redRotate
	case redTwinkling
	case greenConstant
	case greenTwinkling
	case yellowTwinkling
	case blueConstant
	case greenBlueConstant
    case qrCodeBtn
    
	func animateType() -> LCLightButtonAnimateType {
		var type: LCLightButtonAnimateType = .constant
		switch self {
		case .redTwinkling, .greenTwinkling, .yellowTwinkling:
			type = .twinkling
		
		case .redRotate:
			type = .rotate
			
		default:
			type = .constant
		}
		
		return type
	}
	
	func color() -> UIColor {
		var color = UIColor.orange
        color = UIColor.lccolor_c1()
        switch self {
        case .greenConstant, .greenTwinkling, .greenBlueConstant:
            color = UIColor.lccolor_c11()
        case .yellowTwinkling:
            color = UIColor.lccolor_c33()
        case .blueConstant:
            color = UIColor.lccolor_c32()
        case .qrCodeBtn:
            color = UIColor.lccolor_c5()
        default:
            color = UIColor.lccolor_c12()
        }
		
		return color
	}
    
    func bgColor() -> UIColor {
        
        var color = UIColor.clear
        if self == .qrCodeBtn {
            color = UIColor.lccolor_c1()
        }
        return color
    }
    
    func titleColor() -> UIColor {
        
        var color = UIColor.black
        color = UIColor.lccolor_c2()
        if self == .qrCodeBtn {
            color = UIColor.lccolor_c43()
        } else {
            color = self.color()
        }
        return color
    }
    
    func borderColor() -> UIColor {
        
        var color = UIColor.black
        color = UIColor.lccolor_c2()
        if self == .qrCodeBtn {
            color = UIColor.clear
        } else {
            color = self.color()
        }
        return color
    }
	
	func imageNameAndTitle() -> (imageName: String, title: String) {
        switch self {
        case .redTwinkling:
            return ("adddevice_light_redflash", "add_device_red_light_twinkle".lc_T())
        case .redRotate:
            return ("adddevice_light_redflash", "add_device_red_light_rotate".lc_T())
        case .greenConstant:
            return ("adddevice_light_greenalways", "add_device_green_light_always".lc_T())
        case .greenTwinkling:
            return ("adddevice_light_greenflash", "add_device_green_light_twinkle".lc_T())
        case .yellowTwinkling:
            return ("adddevice_light_yellowflash", "add_device_yellow_light_twinkle".lc_T())
        case .greenBlueConstant:
            return ("adddevice_light_greenalways", "add_device_green_blue_light_always".lc_T())
        case .blueConstant:
            return ("adddevice_light_bluealways", "add_device_blue_light_always".lc_T())
        case .qrCodeBtn:
            return ("adddevice_icon_code", "add_device_timeout_add_by_qrcode".lc_T())
        default:
            return ("adddevice_light_redalways", "add_device_red_light_always".lc_T())
        }
	}
}

/// 指示灯动画类型
enum LCLightButtonAnimateType {
	case constant	//常亮
	case twinkling	//闪烁
	case rotate		//旋转
}

class LCLightButton: UIButton {

	/// 指示灯类型
	public var lightType: LCLightButtonType = .redConstant {
		didSet {
			layer.borderColor = lightType.color().cgColor
			autoSet()
			startAnimation()
            setTitleColor(lightType.titleColor(), for: .normal)
            self.backgroundColor = lightType.bgColor()
            layer.borderColor = lightType.borderColor().cgColor
		}
	}
	
	/// 设置灯图片
	public var dotImage: UIImage? {
		didSet {
			dotImageView.image = dotImage
		}
	}
	
	private var dotImageView: UIImageView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubviews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupSubviews()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
	}
	
	func setupSubviews() {
		layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		layer.borderColor = lightType.borderColor().cgColor
        backgroundColor = lightType.bgColor()
		layer.borderWidth = 0.5
		layer.masksToBounds = true
		
		
		dotImageView = UIImageView()
		addSubview(dotImageView)
		
		dotImageView.snp.makeConstraints { make in
			make.left.equalTo(20)
			make.centerY.equalTo(self)
			make.height.width.equalTo(25)
		}
		
		titleLabel?.numberOfLines = 2
	}
	
	// MARK: Animation
	public func startAnimation() {
//        if lightType.animateType() == .twinkling {
//            let animation = CABasicAnimation(keyPath: "opacity")
//            animation.fromValue = 1
//            animation.toValue = 0
//            animation.autoreverses = true
//            animation.duration = 1
//            animation.repeatCount = MAXFLOAT
//            animation.isRemovedOnCompletion = false
//            animation.fillMode = kCAFillModeForwards
//            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
//            dotImageView.layer.add(animation, forKey: "BreathLight")
//        }
	}
	
	public func stopAnimation() {
		dotImageView.layer.removeAllAnimations()
	}
	
	// MARK: AutoSetImage
	public func autoSet() {
		setTitleColor(lightType.color(), for: .normal)
		setTitle(lightType.imageNameAndTitle().title, for: .normal)
		dotImageView.image = UIImage(lc_named: lightType.imageNameAndTitle().imageName)
	}
}
