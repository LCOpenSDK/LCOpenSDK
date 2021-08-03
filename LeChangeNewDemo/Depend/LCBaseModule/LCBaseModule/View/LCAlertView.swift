//
//  Copyright © 2019 jm. All rights reserved.
//

import UIKit
import SnapKit

open class LCAlertView: UIView {
    
    // MARK: life cycle
    
    convenience init(title: String, message: String, cancelTitle: String? = nil, confirmTitle: String? = nil, moreView: UIView? = nil, cancelHandler: (() -> ())? = nil, confirmHandler: (() -> ())? = nil) {
        self.init(frame: CGRect.zero)
        
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.moreView = moreView
        self.cancelTitle = cancelTitle
        self.confirmTitle = confirmTitle
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        self.confirmButton.setTitle(confirmTitle, for: .normal)
        self.cancelHandler = cancelHandler
        self.confirmHandler = confirmHandler
        
        loadSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let statusLabelText: NSString = NSString(string: self.messageLabel.text ?? "")
        let attrButes = [NSAttributedStringKey.font: UIFont.dhFont_t5()]
        let size: CGRect = statusLabelText.boundingRect(with: CGSize(width: 275, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrButes as [NSAttributedStringKey: Any], context: nil)
    
        var height = size.height + 155
        if let `moreView` = moreView {
            height += (moreView.dh_height + 13)
        }
        
        return CGSize(width: 305, height: height)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    
    private func loadSubviews() {
        backgroundColor = UIColor.dhcolor_c43()
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(padding15)
            make.centerX.equalTo(self)
        }
        
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding20)
            make.left.equalTo(self).offset(padding15)
            make.centerX.equalTo(self)
        }
        
        if let `moreView` = moreView {
            addSubview(moreView)
            moreView.snp.makeConstraints({ (make) in
                make.top.equalTo(messageLabel.snp.bottom).offset(24)
                make.centerX.equalTo(self)
                make.size.equalTo(moreView.dh_size)
            })
        }

        addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(1 / UIScreen.main.scale)
            make.top.equalTo(messageLabel.snp.bottom).offset(moreView == nil ? padding35 : (48 + (moreView?.dh_height ?? 0)))
        }

        if cancelTitle == nil || confirmTitle == nil {

            if cancelTitle == nil {
                addSubview(confirmButton)
                confirmButton.snp.makeConstraints { (make) in
                    make.top.equalTo(horizontalLine.snp.bottom)
                    make.left.right.bottom.equalTo(self)
                    make.height.equalTo(buttonHeight)
                }
            } else if confirmTitle == nil {
                addSubview(cancelButton)
                cancelButton.snp.makeConstraints { (make) in
                    make.top.equalTo(horizontalLine.snp.bottom)
                    make.left.right.bottom.equalTo(self)
                    make.height.equalTo(buttonHeight)
                }
            }

        } else {
            addSubview(verticalLine)
            verticalLine.snp.makeConstraints { (make) in
                make.top.equalTo(horizontalLine.snp.bottom)
                make.left.equalTo(self).offset(sizeThatFits(CGSize.zero).width / 2)
                make.width.equalTo(1 / UIScreen.main.scale)
                make.height.equalTo(buttonHeight)
                make.bottom.equalToSuperview()
            }
            
            addSubview(cancelButton)
            cancelButton.snp.makeConstraints { (make) in
                make.top.equalTo(horizontalLine.snp.bottom)
                make.left.equalTo(self)
                make.right.equalTo(verticalLine.snp.left)
                make.height.equalTo(verticalLine.snp.height)
            }

            addSubview(confirmButton)
            confirmButton.snp.makeConstraints { (make) in
                make.top.equalTo(horizontalLine.snp.bottom)
                make.right.equalTo(self)
                make.height.equalTo(verticalLine.snp.height)
                make.left.equalTo(verticalLine.snp.right)
            }
        }
    }
    
    @objc func cancelButtonClicked() {
        if isCanClicked {
            cancelHandler?()
            isCanClicked = false
            resetButton()
        }
    }
    
    @objc func confirmButtonClicked() {
        if isCanClicked {
            confirmHandler?()
            isCanClicked = false
            resetButton()
        }
    }
    
    private func resetButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isCanClicked = true
        }
    }
    
    // MARK: - lazy ui
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.dhFont_t2()
        titleLabel.textColor = UIColor.dhcolor_c2()
        
        return titleLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.font = UIFont.dhFont_t5()
        messageLabel.textColor = UIColor.dhcolor_c2()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.lineBreakMode = .byWordWrapping
        
        return messageLabel
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.titleLabel?.font = UIFont.dhFont_t2()
        cancelButton.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        
        return cancelButton
    }()
    
    lazy var horizontalLine: UIView = {
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = UIColor.dhcolor_c8()
        
        return horizontalLine
    }()
    
    lazy var verticalLine: UIView = {
        let verticalLine = UIView()
        verticalLine.backgroundColor = UIColor.dhcolor_c8()
        
        return verticalLine
    }()
    
    lazy var confirmButton: UIButton = {
        let confirmButton = UIButton()
        confirmButton.titleLabel?.font = UIFont.dhFont_t2()
        confirmButton.setTitleColor(UIColor.dhcolor_c0(), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        
        return confirmButton
    }()
    
    // MARK: - private var
    
    private var moreView: UIView? = nil
    private var cancelHandler: (() -> ())? = nil
    private var confirmHandler: (() -> ())? = nil
    private var cancelTitle: String? = nil {
        didSet {
            guard let `cancelTitle` = cancelTitle else {
                return
            }
            
            if oldValue != cancelTitle {
                self.cancelButton.setTitle(cancelTitle, for: .normal)
            }
        }
    }
    
    private var confirmTitle: String? = nil {
        didSet {
            guard let `confirmTitle` = confirmTitle else {
                return
            }
            
            if oldValue != confirmTitle {
                self.confirmButton.setTitle(confirmTitle, for: .normal)
            }
        }
    }
    
    private var isCanClicked: Bool = true
    private var horizontalLineBottomConstraint: Constraint?
    private let buttonHeight: CGFloat = 50.0
    private let padding35: CGFloat = 35.0
    private let padding20: CGFloat = 20.0
    private let padding15: CGFloat = 15.0
}
