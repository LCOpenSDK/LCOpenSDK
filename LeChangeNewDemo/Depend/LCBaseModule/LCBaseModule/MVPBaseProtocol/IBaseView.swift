//
//  Copyright © 2018年 jm. All rights reserved.
//

import UIKit

/// ViewController需要实现的基础协议
public protocol IBaseView: class {
	
	/// 返回导航控制器
	func mainNavigationController() -> UINavigationController?
	
	/// 返回Controller的View
	func mainView() -> UIView
	
	/// 返回当前的Controller
	func mainViewController() -> UIViewController
}

