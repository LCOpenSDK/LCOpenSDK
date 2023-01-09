//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

import UIKit

enum LCAddGuideActionType {
    case next
    case detail
    case check
    case error
}

protocol LCAddGuideViewDelegate: NSObjectProtocol {
    
    func guideView(view: LCAddGuideView, action: LCAddGuideActionType)
}

class LCAddGuideView: UIView {
    
    /// 是否选中
    public var isChecked: Bool {
        get {
            return checkButton.isSelected
        }
        set {
            checkButton.isSelected = newValue
        }
    }
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var topTipLabel: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    lazy var errorButton: UIButton = {
        let errorButton = UIButton()
//
        errorButton.setTitle("automatic_connection_failed".lc_T, for: .normal)
        errorButton.setTitleColor(UIColor.lccolor_c2(), for: .normal)
        errorButton.setImage(UIImage(named: "adddevice_icon_help"), for: .normal)
        errorButton.addTarget(self, action: #selector(errorButtonClicked), for: .touchUpInside)
        errorButton.isHidden = true
        
        return errorButton
    }()
    
    public weak var delegate: LCAddGuideViewDelegate?
    private var tapUnderlineAction: (() -> Void)? = nil
    private var rects: [CGRect] = []    // 存储下划线字段的点击rect
    
        deinit {
            debugPrint("🍻🍻🍻", "Deinit Success:", self)
        }
    
    public static func xibInstance() -> LCAddGuideView {
		if let view = Bundle.lc_addDeviceBundle()?.loadNibNamed("DHAddGuideView", owner: nil, options: nil)!.first as? LCAddGuideView {
            return view
        }
        return LCAddGuideView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.lccolor_c43()
        
        self.topImageView.contentMode = .scaleAspectFit
		self.topImageView.image = UIImage(named: "adddevice_netsetting_power")
        
        //清除默认显示的文字
        self.topTipLabel.textAlignment = .center
        self.topTipLabel.text = nil
        self.topTipLabel.isSelectable = false
        self.topTipLabel.isEditable = false
        self.topTipLabel.delegate = self
        self.topTipLabel.tintColor = UIColor.lccolor_c0()
        topTipLabel.isUserInteractionEnabled = true
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.text = nil
        self.detailButton.setTitle(nil, for: .normal)
        self.detailButton.setAttributedTitle(nil, for: .normal)
        self.nextButton.setTitle("common_next".lc_T, for: .normal)
        
        //多行显示
        self.checkButton.titleLabel?.numberOfLines = 2
        self.detailButton.titleLabel?.numberOfLines = 2
        
        //配置颜色、样式
        self.topTipLabel.textColor = UIColor.lccolor_c2()
        self.descriptionLabel.textColor = UIColor.lccolor_c5()
        self.detailButton.setTitleColor(UIColor.lccolor_c0(), for: .normal)
        self.checkButton.setTitleColor(UIColor.lccolor_c5(), for: .normal)
        self.nextButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        
        self.nextButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
        self.nextButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        self.checkButton.setImage(UIImage(named: "adddevice_box_checkbox"), for: .normal)
        self.checkButton.setImage(UIImage(named: "adddevice_box_checkbox_checked"), for: .selected)
        
        //默认不显示check按钮、描述文字、详情按钮、重置视图
        self.setCheckHidden(hidden: true)
        self.descriptionLabel.text = nil
        self.detailButton.setTitle("", for: .normal)
        self.setDetailButtonHidden(hidden: true)
        addSubview(errorButton)
        
        //配置默认约束
        self.setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        errorButton.setUIButtonImageRightWithTitleLeftUI()
    }
    
    private func setupConstraints() {
        topImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(40)
            make.width.equalTo(240)
            make.height.lessThanOrEqualTo(240)
        }
        
        errorButton.snp.makeConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom).offset(15)
            make.centerX.equalTo(self)
        }
        
        topTipLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(15)
            make.top.equalTo(errorButton.snp.bottom)
            make.centerX.equalTo(self)
            make.bottom.greaterThanOrEqualTo(descriptionLabel.snp.top).offset(-5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(13)
            make.centerX.equalTo(self)
            make.bottom.greaterThanOrEqualTo(detailButton.snp.top).offset(-5)
        }
        
        detailButton.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(15)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualTo(self).offset(-5)
            make.centerX.equalTo(self)
        }
        
        if lc_isiPhoneX {
            nextButtonBottomConstraint.constant += LC_bottomSafeMargin
        }
    }
    
    // MARK: Actions
    @IBAction func onCheckAction(_ sender: Any) {
        checkButton.isSelected = !checkButton.isSelected
        nextButton.lc_enable = checkButton.isSelected
        delegate?.guideView(view: self, action: .check)
    }
    
    @IBAction func onNextAction(_ sender: Any) {
        delegate?.guideView(view: self, action: .next)
    }
    
    @IBAction func onDetailAction(_ sender: Any) {
        delegate?.guideView(view: self, action: .detail)
    }
    
    @objc private func onTapDescriptionLabelAction(tapGesture: UIGestureRecognizer) {
        
        if let textView = tapGesture.view as? UITextView {
            if #available(iOS 10.0, *) {
                let tapLocation = tapGesture.location(in: textView)
                let textPosition = textView.closestPosition(to: tapLocation)
                guard textPosition != nil else {
                    return
                }
                
                let attr = textView.textStyling(at: textPosition!, in: .forward)
                if let url = attr?[NSAttributedStringKey.link.rawValue] as? String {
                    print("url: \(url)")
                    if url == "copy://" {
                        self.tapUnderlineAction?()
                    }
                }
            }else {
                self.tapUnderlineAction?()
            }
            
        }
    }
    
    @objc func errorButtonClicked() {
        delegate?.guideView(view: self, action: .error)
    }
    
    // MARK: Configurations
    /// 设置确认按钮隐藏，隐藏时nextButton直接可以点击
    ///
    /// - Parameter hidden: true/false
    public func setCheckHidden(hidden: Bool) {
        checkButton.isHidden = hidden
        nextButton.lc_enable = hidden
    }
    
    public func setDetailButtonHidden(hidden: Bool) {
        detailButton.isHidden = hidden
    }
    
    public func setCheck(checked: Bool) {
        checkButton.isSelected = checked
        nextButton.lc_enable = checked
    }
    
    /// 设置详情文字，如果文字内容为空，隐藏按钮，防止触发点击事件
    ///
    /// - Parameter text: 文字
    /// - useUnderline: 是否使用下划线
    /// - tap: 点击事件的回调
    public func setTopTipLabel(text: String, underlineString: String? = nil, shouldCopy: Bool = false, tap: (() -> Void)? = nil) {
        
        //IOS11 这个地方不能这么写errorButton显示隐藏应该由外部控制  这里先暂时
        if #available(iOS 11.0, *) { } else {
            
            errorButton.isHidden = true
        
        }
        
        topTipLabel.isHidden = false
        
        // Common
        let paragraph = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        paragraph?.alignment = .center
        paragraph?.lineSpacing = 10
        
        let attributedString: NSMutableAttributedString =
            NSMutableAttributedString(string: text, attributes: [
                NSAttributedString.Key.paragraphStyle: paragraph ?? NSParagraphStyle.default,
                NSAttributedString.Key.font: UIFont.lcFont_t3()
            ])
        
        // 字符串下划线
        if let _underlineString = underlineString {
            let userPolicyStr: NSMutableAttributedString = NSMutableAttributedString(string: _underlineString)
            let userPolicyStrRange: NSRange = NSRange(location: 0, length: _underlineString.length)
            userPolicyStr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.lccolor_c0()], range: userPolicyStrRange)
            if shouldCopy {
                userPolicyStr.addAttributes([NSAttributedStringKey.link: "copy://"], range: userPolicyStrRange)
                userPolicyStr.addAttributes([NSAttributedString.Key.underlineStyle: 1], range: userPolicyStrRange)
            }
            
            userPolicyStr.addAttributes([NSAttributedString.Key.font: UIFont.lcFont_t3()], range: userPolicyStrRange)
            attributedString.append(userPolicyStr)
            
            if shouldCopy {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage.init(named: "setting_icon_copy.png")?.withRenderingMode(.alwaysOriginal)
                imageAttachment.bounds = CGRect(x: 0, y: -4, width: 21, height: 21)
                let imageString = NSAttributedString(attachment: imageAttachment)
                attributedString.append(imageString)
            }
            
            topTipLabel.attributedText = attributedString
            
            
            
            topTipLabel.delegate = self
            
        } else {
            topTipLabel.attributedText = attributedString
        }
        
        // 点击事件
        if let closure = tap, shouldCopy {
            self.tapUnderlineAction = closure
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapDescriptionLabelAction(tapGesture:)))
            tapGesture.delegate = self
            topTipLabel.isUserInteractionEnabled = true
            topTipLabel.addGestureRecognizer(tapGesture)
        }
    }

    
    /// 设置详情按钮的文字，如果文字内容为空，隐藏按钮，防止触发点击事件
    ///
    /// - Parameter text: 文字
    /// - useUnderline: 是否使用下划线
    public func setDetailButton(text: String?, useUnderline: Bool = false) {
        if text == nil || text!.count == 0 {
            detailButton.isHidden = true
            return
        }
        
        detailButton.isHidden = false
        
        if useUnderline {
            let attrString = NSMutableAttributedString(string: text!)
            let range = NSMakeRange(0, text!.count)
            let number = NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue)
            
            attrString.addAttributes([NSAttributedStringKey.underlineStyle: number,
                                      NSAttributedStringKey.foregroundColor: UIColor.lccolor_c0()], range: range)
            detailButton.setAttributedTitle(attrString, for: .normal)
        } else {
            detailButton.setTitle(text, for: .normal)
        }
    }
    
    // MARK: Update constraint
    public func updateTopImageViewConstraint(top: CGFloat, width: CGFloat, maxHeight: CGFloat? = 0) {
        topImageView.snp.updateConstraints { make in
            make.top.equalTo(top)
            make.width.equalTo(width)
            if maxHeight != nil {
                make.height.lessThanOrEqualTo(maxHeight!)
            }
        }
    }
    
    public func updateContentLabelConstraint(top: CGFloat) {
        errorButton.snp.updateConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom).offset(top)
            make.centerX.equalTo(self)
        }
        
        topTipLabel.snp.updateConstraints { (make) in
            make.top.equalTo(errorButton.snp.bottom)
        }
    }
    
    public func updateDetailButtonlConstraint(bottom: CGFloat) {
        detailButton.snp.remakeConstraints { make in
            make.leading.equalTo(self).offset(13)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset( lc_isiPhoneX ? bottom - LC_bottomSafeMargin : bottom )
        }
        
        errorButton.snp.remakeConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom).offset(15)
            make.centerX.equalTo(self)
        }
        
        topTipLabel.snp.remakeConstraints { make in
            make.leading.equalTo(self).offset(15)
            make.top.equalTo(errorButton.snp.bottom)
            make.centerX.equalTo(self)
            make.bottom.greaterThanOrEqualTo(descriptionLabel.snp.top).offset(-5)
        }
        
        descriptionLabel.snp.remakeConstraints { make in
            make.leading.equalTo(self).offset(13)
            make.top.equalTo(topTipLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            //            make.bottom.greaterThanOrEqualTo(detailButton.snp.top).offset(-5)
        }
    }
}


extension LCAddGuideView: UIGestureRecognizerDelegate, UITextViewDelegate {
    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        guard let textView = gestureRecognizer.view as? UITextView else { return false }
//
//        let point = gestureRecognizer.location(in: textView)
//
//        for rect in self.rects {
//            if rect.contains(point) {
//                return true
//            }
//            return false
//        }
//
//        return false
//    }
    
    private func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        print(URL)
        return true
    }

}
