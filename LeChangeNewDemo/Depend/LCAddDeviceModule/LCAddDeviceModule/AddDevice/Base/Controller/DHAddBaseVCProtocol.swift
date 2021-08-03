//
//  Copyright © 2018年 dahua. All rights reserved.
//

import Foundation

enum DHAddBaseLeftAction {
	case back		//返回上一级
	case backToScan	//返回到扫描界面
	case quit		//退出
}

enum DHAddBaseRightAction: Int {
	case restart				//重新开始
	case switchToWireless		//切换到无线
	case switchToWired			//切换到有线
    case switchToSoftAp
	case showHelp				//显示帮助页面h5
	
	func title(isWifiConfig: Bool = false) -> String {
        switch self {
        case .switchToWireless:
            return isWifiConfig ? "add_device_switch_wireless_to_config".lc_T : "add_device_switch_to_wireless_add".lc_T
        case .switchToWired:
            return isWifiConfig ? "add_device_switch_wired_to_config".lc_T : "add_device_switch_to_wired_add".lc_T
        case .switchToSoftAp:
            return "add_device_switch_to_softAP_add".lc_T
        case .showHelp:
            return "common_help".lc_T
        default:
            return "add_device_restart".lc_T
        }
	}
}

protocol DHAddBaseVCProtocol: NSObjectProtocol {
	
	// MARK: 配置
	/// 返回键点击触发事件类型
	///
	/// - Returns: 事件类型
	func leftActionType() -> DHAddBaseLeftAction
	
	/// 左键返回操作是否需要提示框
	///
	/// - Returns: true/false
	func isLeftActionShowAlert() -> Bool
	
	/// 左键返回操作配置的提示文字
	///
	/// - Returns: String
	func leftActionAlertText() -> String?
	
	/// 右键点击触发事件类型
	///
	/// - Returns: [事件类型]
	func rightActionType() -> [DHAddBaseRightAction]
	
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
	
	// MARK: OMS更新
	func needUpdateCurrentOMSIntroduction()
	
	// MARK: 其他基本操作
	/// 退出添加流程：返回到进入添加流程的入口界面，需要区分国内、海外
	///
	/// - Parameters:
	///   - showAlert: 是否显示提示框，默认为false
	///   - backToMain: 是否需要返回到首页，默认为false
	func baseExitAddDevice(showAlert: Bool, backToMain: Bool)
}
