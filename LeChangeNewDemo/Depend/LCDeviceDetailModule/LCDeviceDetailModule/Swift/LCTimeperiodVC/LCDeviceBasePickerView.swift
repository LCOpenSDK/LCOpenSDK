//

//  LCIphoneAdhocIP
//
//  Created by lechech on 9/7/18.
//  Copyright © 2018 Imou. All rights reserved.
//

import Foundation
import SnapKit

fileprivate let HEIGHT_CONTENT: CGFloat = 335.0
fileprivate let HEIGHT_PICKER: CGFloat = 258.0
fileprivate let HEIGHT_TITLE: CGFloat = 77.0
fileprivate let WIDTH_BUTTON: CGFloat = 95.0

fileprivate let ANIM_DURATION = 0.4

class LCDeviceBasePickerView: UIView {
    
    public var titleLabel: UILabel!
    public var cancelButton: UIButton!
    public var confirmButton: UIButton!
    public var pickerView: UIPickerView!
    
    private var bgView: UIView!
    private var contentView: UIView!
    
    //标题
    public var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    // 界面初始化
    func setUp() {
        
        // 背景
        bgView = UIView()
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickBgView)))
        
        // 内容容器
        contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15.0
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-18)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(HEIGHT_CONTENT)
        }
        
        // Picker容器
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.lccolor_c43()
        pickerView.showsSelectionIndicator = true
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.layer.masksToBounds = true
        contentView.addSubview(pickerView)
        
        pickerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        // 标题容器
        let titleView = UIView()
        titleView.backgroundColor = .clear
        contentView.addSubview(titleView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(HEIGHT_TITLE)
        }
        
        // 取消按钮
        cancelButton = UIButton()
        cancelButton.setTitle("common_cancel".lc_T, for: .normal)
        cancelButton.setTitleColor(UIColor(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        cancelButton.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        titleView.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(WIDTH_BUTTON)
        }
        
        // 确定按钮
        confirmButton = UIButton()
        confirmButton.setTitle("common_confirm".lc_T, for: .normal)
        confirmButton.setTitleColor(UIColor.lccolor_confirm(), for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmButton.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        confirmButton.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        titleView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalTo(titleView)
            make.width.equalTo(WIDTH_BUTTON)
        }
        
        // 标题
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleView)
            make.bottom.equalTo(titleView)
            make.trailing.equalTo(confirmButton.snp.leading)
            make.leading.equalTo(cancelButton.snp.trailing)
        }
    }
    
    func show(in superView: UIView?) {
        if let superView = superView {
            superView.addSubview(self)
            self.snp.makeConstraints { (make) in
                make.edges.equalTo(superView)
            }
        }
        
        // 内容弹出动画
        let animation = CATransition()
        animation.duration = ANIM_DURATION
        animation.timingFunction = CAMediaTimingFunction.init(name: "easeInEaseOut")
        animation.type = "push"
        animation.subtype = "fromTop"
        
        contentView.alpha = 1.0
        contentView.layer.add(animation, forKey: "PickerViewAnim")
        // 背景动画
        bgView.backgroundColor = UIColor(white: 0.1, alpha: 0.0)
        
        UIView.animate(withDuration: ANIM_DURATION, animations: {
            self.bgView.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        })
        
    }
    
    func dismiss() {
        // 内容隐藏动画
        let animation = CATransition()
        animation.duration = ANIM_DURATION
        animation.timingFunction = CAMediaTimingFunction.init(name: "easeInEaseOut")
        animation.type = "push"
        animation.subtype = "fromBottom"
        
        contentView.alpha = 0.0
        contentView.layer.add(animation, forKey: "PickerViewAnim")
        // 背景消失动画
        UIView.animate(withDuration: ANIM_DURATION, animations: {
            self.bgView.backgroundColor = UIColor(white: 0.1, alpha: 0.0)
        }) { finished in
            self.removeFromSuperview()
        }
    }
    // MARK: - 点击事件
    
    // 点击背景
    @objc func clickBgView() {
        dismiss()
    }
    
    // 点击取消
    @objc func clickCancel() {
        dismiss()
    }
    
    // 点击确定
    @objc func clickConfirm() {
        dismiss()
    }
    
}
