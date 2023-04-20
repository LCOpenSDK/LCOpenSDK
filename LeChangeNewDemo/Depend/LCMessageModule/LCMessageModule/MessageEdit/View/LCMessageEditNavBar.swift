//
//  LCMessageEditNavBar.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/14.
//

import UIKit

protocol LCMessageEditNavBarDelegate:NSObjectProtocol {
    func selectAll(_ navBar:LCMessageEditNavBar)
    func dismiss(_ navBar:LCMessageEditNavBar)
}

class LCMessageEditNavBar: UIView {

    weak var delegate:LCMessageEditNavBarDelegate?

    //MARK: - Init
    required init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Func
    public func configTitle(_ text:String?) {
        self.titleLbl.text = text
    }
    
    //MARK: - private func
    private func setupUI() {
        self.addSubview(leftBackBtn)
        self.addSubview(titleLbl)
        self.addSubview(dismissBtn)
        
        leftBackBtn.snp.makeConstraints { make in
            make.leading.equalTo(15.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 100.0, height: 32.0))
        }
        
        titleLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        dismissBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-10.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32.0, height: 32.0))
        }
    }
    
    //MARK: - @objc Func
    @objc func leftBackClick() {
        self.leftBackBtn.isSelected = !self.leftBackBtn.isSelected
        self.delegate?.selectAll(self)
    }
    
    @objc func dismissBtnClick() {
        self.delegate?.dismiss(self)
    }
    
    //MARK: - Lazy Var
    lazy var leftBackBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("SelectAll".lcMessage_T, for: .normal)
        btn.setTitle("SelectNone".lcMessage_T, for: .selected)
        btn.setTitleColor(UIColor.lc_color(withHexString: "#2c2c2c"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(leftBackClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLbl:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lc_color(withHexString: "#2c2c2c")
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var dismissBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "icon_quxiao"), for: .normal)
        btn.addTarget(self, action: #selector(dismissBtnClick), for: .touchUpInside)
        return btn
    }()

    func updateSelectedAll(selectedAll: Bool) {
        if selectedAll == true {
            self.leftBackBtn.isSelected = true
        } else {
            self.leftBackBtn.isSelected = false
        }
    }
}
