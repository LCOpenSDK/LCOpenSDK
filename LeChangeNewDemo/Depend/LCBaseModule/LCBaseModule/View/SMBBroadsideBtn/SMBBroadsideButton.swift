//
//  SMBBroadsideButton.swift
//  DHBaseModule
//
//  Created by imou on 2020/4/23.
//  Copyright © 2020 jm. All rights reserved.
//

import UIKit

@objc public class SMBBroadsideButton: UIButton {
    public typealias SMBBroadsideButtonClickBlock = (_ button: SMBBroadsideButton) -> Void
    private var _clickBlock: SMBBroadsideButtonClickBlock!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc public func clickResult(clickBlock: @escaping SMBBroadsideButtonClickBlock) -> SMBBroadsideButton {
        _clickBlock = clickBlock
        addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return self
    }


    @objc public func title(title: String, state: UIControlState) -> SMBBroadsideButton {
        setTitle(title, for: state)

        return self
    }

    @objc public func image(image: String, state: UIControlState) -> SMBBroadsideButton {
        setImage(UIImage(named: image)!, for: state)
        return self
    }

    // MARK: - Private Methods

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureView()
    }
    private func configureView() {
        backgroundColor = .dhcolor_c2()
        titleLabel?.font = UIFont.dhFont_t7()
        setTitleColor(.dhcolor_c0(), for: .normal)
        setCornerRadius(corners: [.topRight, .bottomRight], radius: dh_height / 2.0)
        self.setUIButtonImageRightWithTitleLeftUI()
    }

    func showBtn() {
        
    }

    func dismissBtn() {
    }

    // MARK: - Action Methods

    @objc func btnClick(btn: SMBBroadsideButton) {
        if _clickBlock != nil {
            _clickBlock(btn)
        }
    }
}
