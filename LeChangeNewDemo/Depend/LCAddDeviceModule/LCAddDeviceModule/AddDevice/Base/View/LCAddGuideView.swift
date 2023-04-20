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
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var topTipLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    lazy var errorButton: UIButton = {
        let errorButton = UIButton()
//
        errorButton.setTitle("automatic_connection_failed".lc_T(), for: .normal)
        errorButton.setTitleColor(UIColor.lccolor_c2(), for: .normal)
        errorButton.setImage(UIImage(lc_named: "adddevice_icon_help"), for: .normal)
        errorButton.addTarget(self, action: #selector(errorButtonClicked), for: .touchUpInside)
        errorButton.isHidden = true
        
        return errorButton
    }()
    
    public weak var delegate: LCAddGuideViewDelegate?
    private var tapUnderlineAction: (() -> Void)? = nil
    private var rects: [CGRect] = []    // 存储下划线字段的点击rect
        deinit {
            debugPrint("LCAddGuideView", "Deinit Success:", self)
        }
    
    public static func xibInstance() -> LCAddGuideView {
		if let view = Bundle.lc_addDeviceBundle()?.loadNibNamed("LCAddGuideView", owner: nil, options: nil)!.first as? LCAddGuideView {
            return view
        }
        return LCAddGuideView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(errorButton)
        self.nextButton.setTitle("common_next".lc_T(), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        errorButton.setUIButtonImageRightWithTitleLeftUI()
        
        if let image = self.topImageView.image {
            let height = (self.topImageView.frame.size.width / image.size.width) * image.size.height
            self.topImageView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().offset(-25)
                make.top.equalToSuperview()
                make.width.equalTo(self.topImageView.frame.size.width)
                make.height.equalTo(height)
            }
        }
    }

    @IBAction func onNextAction(_ sender: Any) {
        delegate?.guideView(view: self, action: .next)
    }
    
    @IBAction func onDetailAction(_ sender: Any) {
        delegate?.guideView(view: self, action: .detail)
    }
    
    @objc private func onTapDescriptionLabelAction(tapGesture: UIGestureRecognizer) {
        if tapGesture.view is UILabel {
            self.tapUnderlineAction?()
        }
    }
    
    @objc func errorButtonClicked() {
        delegate?.guideView(view: self, action: .error)
    }
    
    public func setDetailButtonHidden(hidden: Bool) {
        detailButton.isHidden = hidden
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
    private func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        print(URL)
        return true
    }

}
