//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	基类需要重写的方法

import Foundation

protocol LCGuideBaseVCProtocol: NSObjectProtocol {
	
	// MARK: 设备顶部的图片和文字
	func tipImageName() -> String?
	
	func tipImageUrl() -> String?
	
	func tipText() -> String?
	
	// MARK: 设备描述性文字、隐藏/显示
	func descriptionText() -> String?
	
	// MARK: 设备详情图片URL、按钮文字、隐藏/显示
	
	/// 详情图片地址
	///
	/// - Returns: 图片的url
	func detailImageUrl() -> String?
	
	func detailText() -> String?
	
	func isDetailHidden() -> Bool
	
	func isCheckHidden() -> Bool
	
	// MARK: 设置下一步按钮文字、隐藏/显示
	func nextStepText() -> String?
	
	func isNextStepHidden() -> Bool
	
	// MARK: 操作
	
	/// 下一步按钮点击操作
	func doNext()
	
	/// 详情按钮点击操作
	func doDetail()
}
