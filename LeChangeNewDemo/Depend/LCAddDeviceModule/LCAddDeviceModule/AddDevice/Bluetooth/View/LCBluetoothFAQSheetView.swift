//
//  LCBluetoothFAQSheetView.swift
//  LCAddDeviceModule
//
//  Created on 2026/1/22.
//  Copyright © 2026 Imou. All rights reserved.
//

import UIKit
import LCBaseModule
import SnapKit

class LCBluetoothFAQSheetView: UIView {
    
    var dismissAction: (() -> Void)?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lc_color(withHexString: "#000000").withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_faq_title".lc_T
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var scrollContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = true
        return scroll
    }()
    
    private lazy var contentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var faqLabels: [UILabel] = []
    
    private lazy var okButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Alert_Title_Button_Confirm1".lc_T, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.lc_color(withHexString: "#F18D00")
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(contentView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-LC_bottomSafeMargin)
            make.height.equalTo(UIScreen.main.bounds.height * 0.6)
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(scrollContainerView)
        contentView.addSubview(okButton)
        
        scrollContainerView.addSubview(scrollView)
        scrollView.addSubview(contentContainerView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        // scrollContainerView 作为 ScrollView 的容器，有明确的高度约束
        scrollContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(okButton.snp.top).offset(-20)
        }
        
        // ScrollView 填充 scrollContainerView
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // contentContainerView 的约束：宽度等于 ScrollView，高度由内容决定
        contentContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        okButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        // 添加FAQ内容
        setupFAQContent()
    }
    
    private func setupFAQContent() {
        let items = [
            "add_device_bluetooth_faq_item1".lc_T,
            "add_device_bluetooth_faq_item2".lc_T,
            "add_device_bluetooth_faq_item3".lc_T,
            "add_device_bluetooth_faq_item4".lc_T
        ]
        
        var previousLabel: UILabel?
        
        for (index, item) in items.enumerated() {
            let label = createFAQLabel(number: index + 1, text: item)
            contentContainerView.addSubview(label)
            faqLabels.append(label)
            
            label.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                
                if let previous = previousLabel {
                    make.top.equalTo(previous.snp.bottom).offset(16)
                } else {
                    make.top.equalToSuperview().offset(0)
                }
                
                // 最后一个label需要约束到底部
                if index == items.count - 1 {
                    make.bottom.equalToSuperview().offset(-20)
                }
            }
            
            previousLabel = label
        }
    }
    
    private func createFAQLabel(number: Int, text: String) -> UILabel {
        let label = UILabel()
        label.text = "\(number). \(text)"
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }
    
    @objc private func backgroundTapped() {
        dismiss()
    }
    
    @objc private func okButtonClicked() {
        dismiss()
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 动画显示
        backgroundView.alpha = 0
        contentView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.height)
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.contentView.transform = .identity
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.bounds.height)
        }) { _ in
            self.removeFromSuperview()
            self.dismissAction?()
        }
    }
}
