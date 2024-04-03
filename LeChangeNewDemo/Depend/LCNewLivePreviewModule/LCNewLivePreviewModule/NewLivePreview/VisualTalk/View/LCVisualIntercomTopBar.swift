//
//  LCVisualIntercomTopBar.swift
//  LCNewLivePreviewModule
//
//  Created by dahua on 2024/3/21.
//

import UIKit

class LCVisualIntercomTopBar: UIView {
    
    //MARK: - lift cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(clockView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        clockView.snp.makeConstraints { make in
            make.center.equalTo(subTitleLabel)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
    }
    
    //MARK: - func
    
    public func configIntercomInfo(_ title: String?) {
        titleLabel.text = title
    }
    
    public func startTimer() {
        self.clockView.isHidden = false
        self.subTitleLabel.isHidden = true
        self.clockView.startTimer()
    }
    
    public func stopTimer() {
        self.clockView.stopTimer()
    }
    
    //MARK: - var & lazy
    
    fileprivate lazy var titleLabel: UILabel = {
        let result = UILabel()
        result.font = UIFont.lcFont_t3Bold()
        result.textColor = UIColor.lccolor_c43()
        return result
    }()
    
     lazy var subTitleLabel: UILabel = {
        let result = UILabel()
        result.font = UIFont.lcFont_t5()
        result.textColor = UIColor.lccolor_c43()
        result.text = "呼叫中".lc_T
        return result
    }()
    
    fileprivate lazy var clockView: LCVisualIntercomClockView = {
        let result = LCVisualIntercomClockView(frame: .zero)
        result.backgroundColor = .black
        result.isHidden = true
        return result
    }()
}
