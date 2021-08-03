//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

/// 错误类型
enum DHOMSErrorType: String {
	case old = "ErrorTipsType" /** 旧的错误类型 */
	case wifi = "WifiErrorTipsType" /** WIFI错误类型 */
	case softAp = "SoftAPErrorTipsType" /** 软AP的错误类型 */
}

struct DHOMSLightCheckInfo {
	/// 设备指示灯闪烁图片url
	var lightTwinkleImageUrl: String?
	
	/// 设备指示灯闪烁内容
	var lightTwinkleContent: String?
	
	/// 设备指示灯闪烁确认
	var lightTwinklConfirm: String?
	
	static let keyWifiModeImageUrl = "WifiModeGuidingLightImage"
	static let keyWifiModeContent = "WifiModeConfigIntroduction"
	static let keyWifiModeConfirm = "WifiModeConfigConfirmIntroduction"
	
	static let keyHubModeImageUrl = "HubModePairStatusImage"
	static let keyHubModeContent = "HubModePairOperationIntroduction"
	static let keyHubModeConfirm = "HubModeAccsesoryConfigConfirmIntroduction"
	
	static let keyHubModeAccessoryImageUrl = "HubAccessoryModePairStatusImage"
	static let keyHubModeAccessoryContent = "HubAccessoryModePairOperationIntroduction"
	static let keyHubModeAccessoryConfirm = "HubModeAccsesoryConfigConfirmIntroduction"
	
	static let keyAccessoryModeImageUrl = "AccessoryModePairStatusImage"
	static let keyAccessoryModeContent = "AccessoryModePairOperationIntroduction"
	static let keyAccessoryModeConfirm = "AccessoryModePairConfirmIntroduction"
}

struct DHOMSLightResetInfo {
	var resetImageUrl: String?
	var resetGuide: String?
	var resetOperation: String?
	
	static let keyWifiModeImageUrl = "WifiModeResetImage"
	static let keyWifiModeGuide = "WifiModeResetGuideIntroduction"
	static let keyWifiModeOperation = "WifiModeResetOperationIntroduction"
	
	static let keyHubModeImageUrl = "HubModeResetImage"
	static let keyHubModeGuide = "HubModeResetGuideIntroduction"
	static let keyHubModeOperation = "HubModeResetOperationIntroduction"
	
	static let keyHubModeAccessoryImageUrl = "HubAccessoryModeResetImage"
	static let keyHubModeAccessoryGuide = "HubAccessoryModeResetGuideIntroduction"
	static let keyHubModeAccessoryOperation = "HubAccessoryModeResetOperationIntroduction"
	
	static let keySoftApModeImageUrl = "SoftAPModeResetImage"
	static let keySoftApModeGuide = "SoftAPModeResetGuideIntroduction"
	static let keySoftApModeOperation = "SoftAPModeResetOperationIntroduction"
	
	static let keyAccessoryModeImageUrl = "AccessoryModeResetImage"
	static let keyAccessoryModeGuide = "AccessoryModeResetGuideIntroduction"
	static let keyAccessoryModeOperation = "AccessoryModeResetOperationIntroduction"
}

/// 配对、添加完成信息
struct DHOMSDoneInfo {
	var imageUrl: String?
	
	/// 增加Hub与电池相机配对的完成图（只有这个比较特殊，hub添加与电池相册配对，都使用的hub型号）；
	var hubPairImageUrl: String?
	
	var content: String?
	var guide: String?
	
	/// 软AP（p2p）完成引导页的图片
	var guideImageUrl: String?
	
	static let keyWifiModeDoneImageUrl = "WifiModeFinishDeviceImage"
	
	static let keyHubModePairDoneImageUrl = "HUBModeResultPromptImage"
	static let keyHubModePairDoneContent = "HUBModeResultIntroduction"
	static let keyHubModePairDoneRepairGuide = "HUBModeConfirmIntroduction"
	
	static let keySoftApModePairDoneImageUrl = "SoftAPModeResultPromptImage"
	static let keySoftApModePairDoneGuideImageUrl = "SoftAPModeResultIntroductionImage"
	static let keySoftApModePairDoneContent = "SoftAPModeResultIntroduction"
	static let keySoftApModePairDoneRepairGuide = "SoftAPModeConfirmIntroduction"
	
	static let keyAccessoryModePairDoneImageUrl = "AccessoryModeFinishDeviceImage"
	
	static let keyLocalModePairdDoneImageUrl = "LocationModeFinishDeviceImage"
	
	static let keyNBModePairDoneImageUrl = "ThirdPartyPlatformModeResultPromptImage"
}

/// SoftAP引导
struct DHOMSSoftApGuideInfo {
    var wifiName: String?
    var wifiModelVersion: String?
    var guideSteps: [DHOMSSoftApGuideStep] = [DHOMSSoftApGuideStep]()
    
    static let keyWifiName = "SoftAPModeWifiName"
    static let keyWifiModelVersion = "SoftAPModeWifiVersion"
}

/// SoftAP引导：步骤
struct DHOMSSoftApGuideStep {
	var imageUrl: String?
	var content: String?
	
	static let keySoftApGuideMaxStep: Int = 4
	
	static let keySoftApStepOneGuide = "SoftAPModeGuidingStepOneIntroduction"
	static let keySoftApStepOneImageUrl = "SoftAPModeGuidingStepOneImage"
	
	static let keySoftApStepTwoGuide = "SoftAPModeGuidingStepTwoIntroduction"
	static let keySoftApStepTwoImageUrl = "SoftAPModeGuidingStepTwoImage"
	
	static let keySoftApStepThreeGuide = "SoftAPModeGuidingStepThreeIntroduction"
	static let keySoftApStepThreeImageUrl = "SoftAPModeGuidingStepThreeImage"
	
	static let keySoftApStepFourGuide = "SoftAPModeGuidingStepFourIntroduction"
	static let keySoftApStepFourImageUrl = "SoftAPModeGuidingStepFourImage"
}


// MARK: - Local Guide
struct DHOMSSLocalGuideInfo {
	var content: String?
	var imageUrl: String?
	
	static let keyLocalModeImageUrl = "LocationOperationImages"
	static let keyLocalModeContent = "LocationOperationIntroduction"
}

// MARK: - NBIoT Guide
struct DHOMSSNBIoTGuideInfo {
	var imageUrl: String?
	var content: String?

	static let keyNBIoTModeImageUrl = "ThirdPartyPlatformModeGuidingLightImage"
	static let keyNBIoTModeContent = "ThirdPartyPlatformModeConfigIntroduction"
}

// MARK: 默认值分类IPC
///通用IPC指示灯默认值
struct DHIPCLightCheckDefault {
	static let imagename = "adddevice_default_wps"
	static let twinkleContent = "add_device_operation_by_instructions".lc_T
	static let twinkleConfirm = "add_device_complete_related_operations".lc_T
}

/// 通用IPC指示灯重置默认值
struct DHIPCLightResetDefault {
	static let imagename = "adddevice_default_reset"
	static let guide = ""
	static let operation = ""
}

/// 通用IPC完成默认值
struct DHIPCDoneDefault {
	static let imagename = "adddevice_device_default"
}

// MARK: 默认值分类Hub
/// Hub指示灯默认值
struct DHHubLightCheckDefault {
	static let imagename = "adddevice_default_wps"
	static let twinkleContent = "add_device_operation_by_instructions".lc_T
	static let twinkleConfirm = ""
}

/// Hub指示灯重置默认值
struct DHHubLightResetDefault {
	static let imagename = "adddevice_default_reset"
	static let guide = ""
	static let operation = ""
}

/// Hub配件指示灯默认值
struct DHHubAccessoryLightCheckDefault {
	static let imagename = "adddevice_default_wps"
	static let twinkleContent = "add_device_operation_by_instructions".lc_T
	static let twinkleConfirm = ""
}

/// Hub配件指示灯重置默认值
struct DHHubAccessoryLightResetDefault {
	static let imagename = "adddevice_default_reset"
	static let guide = ""
	static let operation = ""
}

/// Hub配对完成默认值
struct DHOMSHubPairDoneDefault {
	static let imagename = "adddevice_default"
	static let content = "add_device_operation_by_instructions".lc_T
	static let guide = "add_device_re_add".lc_T
}

// MARK: 默认值分类SoftAP
/// SoftAp默认值
struct DHOMSSoftApGuideDefault {
	static let wifiname = "add_device_mode_xxxx".lc_T
	static let imagename = "adddevice_common"
	static let content = "add_device_operation_by_ap_instructions".lc_T
}

/// Soft重置默认值
struct DHSoftApResetDefault {
	static let imagename = "adddevice_default_reset"
	static let guide = ""
	static let operation = ""
}

/// SoftAp完成默认值
struct DHOMSSoftAPDoneDefault {
	static let imagename = "adddevice_default_success"
	static let content = "add_device_operation_by_instructions".lc_T
	static let guide = "add_device_complete_related_operations".lc_T
}

// MARK: 默认值分类 配件
///配件指示灯默认值
struct DHAccessoryLightCheckDefault {
	static let imagename = "adddevice_default_wps"
	static let twinkleContent = "add_device_operation_by_instructions".lc_T
	static let twinkleConfirm = "add_device_complete_related_operations".lc_T
}

/// 配件指示灯重置默认值
struct DHAccessoryResetDefault {
	static let imagename = "adddevice_default_reset"
	static let guide = ""
	static let operation = ""
}

/// 配件完成默认值
struct DHAccessoryDoneDefault {
	static let imagename = "adddevice_default_success"
}

///MARK: 本地配网默认分类
struct DHOMSSLocalGuideDefault {
	static let imagename = "adddevice_netsetting_networkcable"
	static let content = "抱歉，您的设备未完成配网流程。请先在设备上配网完成后再用手机添加".lc_T
}

///MARK: NB配网默认分类
struct DHOMSSNBGuideDefault {
	static let imagename = "adddevice_default"
	static let content = "请先按设备的自检/消音按钮".lc_T
}



