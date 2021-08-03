//
//  Copyright © 2018年 iblue. All rights reserved.
//	网络连接错误

import Foundation

/// 元组定义，按钮与操作类型对应
typealias DHNetConnectFailureTuple = (button: UIButton, operation: DHNetConnectFailureOperationType)

/// 网络连接按钮操作类型
enum DHNetConnectFailureOperationType {
	/// 输入WIFI密码
	case inputWifiPassword
	
	/// 红灯常亮详情
	case redLightConstantDetail
	
	/// 红灯旋转详情
	case readLightRotateDetail
	
	/// 红灯闪烁详情
	case redLightTwinkleDetail
	
	/// 继续等等（如重新计时）
	case continueToWait
	
	/// 再试一次（如连接路由器失败等）
	case tryAgain
	
	/// 切换到有线
	case switchToWired
	
	/// 进入设备密码检验
	case authDevicePassword
	
    /// 进入设备初始化界面
    case deviceInitialize
    
	/// 完成
	case complete
    
    /// 二维码扫描
    case qrCode
	
	/// 退出
	case quit
	
	/// 优化：A系的蓝灯长亮
	case blueConstantAction
	
	/// 优化：C系的绿灯长亮
	case greenConstantAction
}

/// 网络连接错误类型
enum DHNetConnectFailureType: String {
	
	case tp1 	= "TP1"
	case tp1s	= "TP1S"
	case g1		= "G1"
	case door	= "K5"
    case ipcGeneral = "ipcGeneral"
	case overseasA	= "FamilyA"
	case overseasC	= "FamilyC"
	case overseasDoorbell	= "Doorbell"
	case commonWithWired	= "DahuaCommonWithWired"
	case commonWithoutWired = "DahuaCommonWithoutWired"
	case accessory = "Accessory"
	case cloudTimeout = "ConnectCloudTimeout"
	
	func buttonTuples() -> [DHNetConnectFailureTuple] {
		var buttons: [DHNetConnectFailureTuple]!
        
        //开放平台需求z，只显示一个"再试一次"按钮
        buttons = commonTypeButtons(supportWired: false)
        
//		switch self {
//		case .tp1:
//			buttons = tp1TypeButtons()
//		case .tp1s:
//			buttons = tp1sTypeButtons()
//		case .g1:
//			buttons = g1TypeButtons()
//		case .door:
//			buttons = k5TypeButtons()
////        case .ipcGeneral:
////            buttons = ipcGeneralTypeButtons()
//		case .overseasA:
//			buttons = overseasATypeButtons()
//		case .overseasC:
//			buttons = overseasCTypeButtons()
//		case .overseasDoorbell:
//			buttons = overseasDoorbellButtons()
//
//		case .accessory:
//			buttons = accessoryTypeButtons()
//
//		case .cloudTimeout:
//			buttons = cloudTimeoutTypeButtons()
//
//		case .commonWithoutWired:
//			buttons = commonTypeButtons(supportWired: false)
//
//		default:
//			buttons = commonTypeButtons(supportWired: true)
//		}

        
		return buttons
	}
	
	// MARK: Buttons with type
	private func tp1TypeButtons() -> [DHNetConnectFailureTuple] {
		let config: [(DHLightButtonType, DHNetConnectFailureOperationType)] = [(.redTwinkling, .inputWifiPassword),
																				(.redConstant, .redLightConstantDetail),
																				(.greenTwinkling, .inputWifiPassword),
																				(.greenBlueConstant, .complete)]
		return lightButtons(config: config)
	}
	
	private func tp1sTypeButtons() -> [DHNetConnectFailureTuple] {
		
		let config: [(DHLightButtonType, DHNetConnectFailureOperationType)] = [(.yellowTwinkling, .inputWifiPassword),
																				(.redRotate, .readLightRotateDetail),
																				(.greenBlueConstant, .complete)]
		return lightButtons(config: config)
	}
	
	private func g1TypeButtons() -> [DHNetConnectFailureTuple] {
		let config: [(DHLightButtonType, DHNetConnectFailureOperationType)] = [(.redTwinkling, .redLightTwinkleDetail)]
		return lightButtons(config: config)
	}
	
	private func k5TypeButtons() -> [DHNetConnectFailureTuple] {
		let config: [(String, DHNetConnectFailureOperationType)] = [("add_device_connect_router_failed".lc_T, .tryAgain),
																	("add_device_connect_network_failed".lc_T, .continueToWait)]
		return DHNetConnectFailureType.commonButtons(config: config)
	}
    
//    private func ipcGeneralTypeButtons() -> [DHNetConnectFailureTuple] {
//        let config: [(String, DHNetConnectFailureOperationType)] = [("add_device_connect_router_failed".lc_T, .tryAgain),
//                                                                    ("add_device_add_by_wired".lc_T, .switchToWired)]
//        return DHNetConnectFailureType.commonButtons(config: config)
//    }
	
	private func overseasATypeButtons() -> [DHNetConnectFailureTuple] {
		let config: [(DHLightButtonType, DHNetConnectFailureOperationType)] = [(.yellowTwinkling, .inputWifiPassword),
																				(.redRotate, .readLightRotateDetail),
																				(.greenTwinkling, .inputWifiPassword),
																				(.blueConstant, .blueConstantAction)] 
		return lightButtons(config: config)
	}
	
	private func overseasCTypeButtons() -> [DHNetConnectFailureTuple] {
		let config: [(DHLightButtonType, DHNetConnectFailureOperationType)] = [(.redTwinkling, .inputWifiPassword),
																				(.redConstant, .redLightConstantDetail),
																				(.greenTwinkling, .inputWifiPassword),
																				(.greenConstant, .greenConstantAction)]
		return lightButtons(config: config)
	}
	
	private func overseasDoorbellButtons() -> [DHNetConnectFailureTuple] {
		let config: [(String, DHNetConnectFailureOperationType)] = [("add_device_try_again".lc_T, .tryAgain)]
		return DHNetConnectFailureType.commonButtons(config: config)
	}
	
	private func commonTypeButtons(supportWired: Bool) -> [DHNetConnectFailureTuple] {
//		var config: [(String, DHNetConnectFailureOperationType)] = [("add_device_try_again".lc_T, .tryAgain)]
//		if supportWired {
//			config.append(("add_device_add_by_wired".lc_T, .switchToWired))
//		}
        //demo调整为重新开始
		let config: [(String, DHNetConnectFailureOperationType)] = [("add_device_restart".lc_T, .quit)]
        
		return DHNetConnectFailureType.commonButtons(config: config)
	}
	
	private func accessoryTypeButtons() -> [DHNetConnectFailureTuple] {
		let config: [(String, DHNetConnectFailureOperationType)] = [("add_device_continue_to_wait".lc_T, .continueToWait),
																 ("add_device_try_again".lc_T, .tryAgain),
																 ("add_device_quit_add_process".lc_T, .quit)]
		return DHNetConnectFailureType.commonButtons(config: config)
	}
	
	private func cloudTimeoutTypeButtons() -> [DHNetConnectFailureTuple] {
		let config: [(String, DHNetConnectFailureOperationType)] = [("add_device_try_again".lc_T, .tryAgain),
																	("add_device_quit_add_process".lc_T, .quit)]
		return DHNetConnectFailureType.commonButtons(config: config)
	}
	
	// MARK: General DHLightButton
	private func lightButtons(config : [(type: DHLightButtonType, oper: DHNetConnectFailureOperationType)]) -> [DHNetConnectFailureTuple] {
		var tuples = [DHNetConnectFailureTuple]()
		
		for index in 0..<config.count {
			let button = DHLightButton()
			button.lightType = config[index].type
			tuples.append((button, config[index].oper))
		}
		
		return tuples
	}
	
	// MARK: General CommonButton
	public static func commonButtons(config: [(title: String, action: DHNetConnectFailureOperationType)]) -> [DHNetConnectFailureTuple] {
		var tuples = [DHNetConnectFailureTuple]()
		
		for index in 0..<config.count {
			let button = UIButton(type: .custom)
			button.setTitle(config[index].title, for: .normal)
			tuples.append((button, config[index].action))
			
			//最后一个按钮颜色配置
            //if index != 0, index == config.count - 1
            if DHAddDeviceManager.sharedInstance.netConfigMode == .softAp,
                (DHAddDeviceManager.sharedInstance.deviceModel.lowercased() == "k5" || DHAddDeviceManager.sharedInstance.deviceModel.lowercased() == "k8") {
                button.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
                button.backgroundColor = UIColor.dhcolor_c43()
                button.layer.borderColor = UIColor.dhcolor_c5().cgColor
                button.layer.borderWidth = 0.5
                button.layer.masksToBounds = true
                button.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
                continue
            }

			if index != 0 {
				button.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
				button.backgroundColor = UIColor.dhcolor_c43()
				button.layer.borderColor = UIColor.dhcolor_c5().cgColor
				button.layer.borderWidth = 0.5
				button.layer.masksToBounds = true
                button.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
			} else {
				button.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
				button.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
				button.layer.masksToBounds = true
                button.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
			}
		}
		
		return tuples
	}
}
