//
//  Copyright © 2018年 Imou. All rights reserved.
//

import Foundation

enum LCAddBaseLeftAction {
	case back		//返回上一级
	case backToScan	//返回到扫描界面
	case quit		//退出
}

enum LCAddBaseRightAction: Int {
	case restart				//重新开始
	case switchToWireless		//切换到无线
	case switchToWired			//切换到有线
    case switchToSoftAp
	case showHelp				//显示帮助页面h5
    
	func title() -> String {
        switch self {
        case .switchToWireless:
            return "add_device_switch_wireless_to_config".lc_T()
        case .switchToWired:
            return "add_device_switch_wired_to_config".lc_T()
        case .switchToSoftAp:
            return "add_device_switch_to_softAP_add".lc_T()
        case .showHelp:
            return "common_help".lc_T()
        default:
            return "add_device_restart".lc_T()
        }
	}
}

protocol LCAddBaseVCProtocol: NSObjectProtocol {
	
	// MARK: 配置
	/// 返回键点击触发事件类型
	///
	/// - Returns: 事件类型
	func leftActionType() -> LCAddBaseLeftAction
	
	/// 左键返回操作是否需要提示框
	///
	/// - Returns: true/false
	func isLeftActionShowAlert() -> Bool
	
	/// 右键点击触发事件类型
	///
	/// - Returns: [事件类型]
	func rightActionType() -> [LCAddBaseRightAction]
	
	/// 右键是否隐藏
	///
	/// - Returns: true/false
	func isRightActionHidden() -> Bool
	
	/// 是否启用右键
	///
	/// - Parameter enable: true/false
	func enableRightAction(enable: Bool)
	
	// MARK: 事件
	/// 右键点击事件
	///
	/// - Parameter button: UIButton
	func onRightAction(button: UIButton)
	
	// MARK: 其他基本操作
	/// 退出添加流程：返回到进入添加流程的入口界面，需要区分国内、海外
	///
	/// - Parameters:
	///   - showAlert: 是否显示提示框，默认为false
	func baseExitAddDevice(showAlert: Bool)
}
