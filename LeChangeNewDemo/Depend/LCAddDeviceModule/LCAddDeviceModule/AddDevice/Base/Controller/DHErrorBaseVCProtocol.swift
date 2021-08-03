//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	通用错误界面配置协议

import Foundation

protocol DHErrorBaseVCProtocol: NSObjectProtocol {
	
	func errorImageName() -> String
	
	func errorContent() -> String
	
	func errorDescription() -> String?
	
	func icConfirmHidden() -> Bool
	
	func confirmText() -> String
	
	func isQuitHidden() -> Bool
	
	func quitText() -> String
	
	func doConfirm()
	
	func doQuit()
	
	func doFAQ() 
}
