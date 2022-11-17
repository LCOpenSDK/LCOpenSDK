//
//  LCMessageDefine.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/11.
//

import Foundation

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let kIs_iPhoneX = SCREEN_HEIGHT >= 375.0 && SCREEN_HEIGHT >= 812.0

let kStatusBarHeight = kIs_iPhoneX ? 44.0 : 20.0

/*底部安全区域远离高度*/
let kBottomSafeHeight = kIs_iPhoneX ? 34.0 : 0
