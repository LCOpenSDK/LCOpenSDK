//
//  UINavigationController+BarItem.swift
//  LCBaseModule
//
//  Created by yyg on 2022/10/18.
//  Copyright © 2022 jm. All rights reserved.
//

import Foundation

public extension UINavigationController {
    @objc func setupDefaultLeftItems(action: Selector? = nil) {
        let btn = UIButton.init(type: .custom)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.setImage(UIImage(named: "common_icon_nav_back"), for: .normal)
        if let ac = action {
            btn.addTarget(self, action: ac, for: .touchUpInside)
        } else {
            btn.addTarget(self, action: #selector(onLeftNaviItemClick), for: .touchUpInside)
        }
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: btn)]
    }
    
    @objc func onLeftNaviItemClick() {
        self.popViewController(animated: true)
    }
}
