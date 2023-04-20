//
//  LCMessageNavBar.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/10.
//

import UIKit
import SnapKit

protocol LCMessageNavBarDelegate:NSObjectProtocol {
    
    func callBack(_ navBar:LCMessageNavBar)
    
    func gotoEdit(_ navBar:LCMessageNavBar)
}

class LCMessageNavBar: UIView {
    
    weak var delegate:LCMessageNavBarDelegate?

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
        self.addSubview(editBtn)
        
        leftBackBtn.snp.makeConstraints { make in
            make.leading.equalTo(10.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32.0, height: 32.0))
        }
        
        titleLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        editBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-10.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32.0, height: 32.0))
        }
    }
    
    //MARK: - @objc Func
    @objc func leftBackClick() {
        self.delegate?.callBack(self)
    }
    
    @objc func editBtnClick() {
        self.delegate?.gotoEdit(self)
    }
    
    //MARK: - Lazy Var
    lazy var leftBackBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "icon_fanhui"), for: .normal)
        btn.addTarget(self, action: #selector(leftBackClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLbl:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lc_color(withHexString: "#2c2c2c")
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var editBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "icon_bianji"), for: .normal)
        btn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        return btn
    }()
}
