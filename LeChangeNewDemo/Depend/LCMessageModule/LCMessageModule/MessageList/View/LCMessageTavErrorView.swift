//
//  LCMessageTavErrorView.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/15.
//

import UIKit
import LCBaseModule

class LCMessageTavErrorView: UIView {
    
    var retryHandle:(()->Void)?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - private func
    private func setupUI() {
        self.addSubview(errorImv)
        self.addSubview(tipLabel)
        
        errorImv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(130.0)
            make.size.equalTo(CGSize(width: 125.0, height: 125.0))
        }
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalTo(errorImv)
            make.top.equalTo(errorImv.snp.bottom).offset(15.0)
        }
        
        let attr1: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor:
                                                    UIColor.lc_color(withHexString: "#8f8f8f"),
                                                    NSAttributedString.Key.font:
                                                    UIFont.systemFont(ofSize: 16.0)]
        let text = "loading_failed".lc_T
        let rang1 = NSMakeRange(0, text.count)
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        style.lineSpacing = 5
        let attr2:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor:
                                                    UIColor.lc_color(withHexString: "#f18d00"),
                                                    NSAttributedString.Key.font:
                                                    UIFont.systemFont(ofSize: 16.0), NSAttributedString.Key.paragraphStyle: style]
        let text2 = "tap_and_try_again".lc_T
        let range2 = NSMakeRange(text.count, text2.count)
        
        let attrText = NSMutableAttributedString(string: "\(text)\(text2)")
        attrText.addAttributes(attr1, range: rang1)
        attrText.addAttributes(attr2, range: range2)
        
        tipLabel.attributedText = attrText
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tipLabelClick))
        tipLabel.addGestureRecognizer(tap)
        
    }
    
    //MARK: - @objc func
    @objc func tipLabelClick() {
        self.retryHandle?()
    }
    
    //MARK: - Lazy Var
    lazy var errorImv:UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "pic_quesheng2")
        return imv
    }()
    
    lazy var tipLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lc_color(withHexString: "#8f8f8f")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
}
