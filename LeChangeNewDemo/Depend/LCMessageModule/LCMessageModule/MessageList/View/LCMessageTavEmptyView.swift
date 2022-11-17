//
//  LCMessageTavEmptyView.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/14.
//

import UIKit

class LCMessageTavEmptyView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lc_color(withHexString: "#FFFFFF")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Func
    private func setupUI() {
        self.addSubview(emptyImv)
        self.addSubview(tipLabel)
        
        emptyImv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(130.0)
            make.size.equalTo(CGSize(width: 125.0, height: 125.0))
        }
        tipLabel.snp.makeConstraints { make in
            make.centerX.equalTo(emptyImv)
            make.top.equalTo(emptyImv.snp.bottom).offset(15.0)
        }
    }
    
    //MARK: - Lazy Var
    lazy var emptyImv:UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "pic_quesheng1")
        return imv
    }()
    
    lazy var tipLabel:UILabel = {
        let label = UILabel()
        label.text = "no_message".lc_T
        label.textColor = UIColor.lc_color(withHexString: "#8f8f8f")
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .center
        return label
    }()
    
}
