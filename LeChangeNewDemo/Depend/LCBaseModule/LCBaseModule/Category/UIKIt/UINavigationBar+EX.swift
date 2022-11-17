//
//  UINavigationBar+EX.swift
//  LCBaseModule
//
//  Created by yyg on 2022/10/17.
//  Copyright © 2022 jm. All rights reserved.
//

import Foundation

public extension UINavigationBar {
    @objc func setBarBackgroundColor(color: UIColor, titleColor: UIColor = .lccolor_c40()) {
        if #available(iOS 15, *) {
            let app = UINavigationBarAppearance.init()
            app.configureWithOpaqueBackground()  // 重置背景和阴影颜色
            app.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: titleColor
            ]
            app.backgroundColor = color  // 设置导航栏背景色
            app.shadowImage = UIImage.lc_createImage(with: .clear)  //
            app.backgroundColor = color
            self.setBackgroundImage(UIImage.lc_createImage(with: color), for: UIBarMetrics.default)
            self.scrollEdgeAppearance = app  // 带scroll滑动的页面
            self.standardAppearance = app // 常规页面
        } else {
            // 设置导航栏背景色
            self.barTintColor = color
            // 设置导航条上的标题
            self.titleTextAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
            // 取消半透明效果
            self.isTranslucent  = false
            // 设置导航栏返回按钮的颜色
            self.tintColor = UIColor.black
            // 设置导航栏下边界分割线透明
            self.setBackgroundImage(UIImage.lc_createImage(with: color), for: UIBarMetrics.default)
            self.shadowImage = UIImage()
        }
    }
}
