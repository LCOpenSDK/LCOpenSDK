//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	引导信息解析

import UIKit

public class LCIntroductionParser: NSObject {
	
	/// 更新时间
	var updateTime: String = ""
	
	/// 网络配置：WIFI配置超时
	var errorType: LCNetConnectFailureType?
	
	/// 软Ap错误码【兼容G1，既支持软AP，又支持SmartConfig】
	var softApErrorType: LCNetConnectFailureType?
	
	/// 设备指示灯闪烁相关信息
	var lightCheckInfo: LCOMSLightCheckInfo = LCOMSLightCheckInfo()
	
	/// 设备指示灯重置相关信息
	var lightResetInfo: LCOMSLightResetInfo = LCOMSLightResetInfo()
	
	/// 设备配对（如UB配件）指示灯相关信息
	var accessoryPairLightCheckInfo: LCOMSLightCheckInfo = LCOMSLightCheckInfo()
	
	/// 设备配对（如UB配件）指示灯重置相关信息
	var accessoryPairLightResetInfo: LCOMSLightResetInfo = LCOMSLightResetInfo()
	
	/// 完成相关信息
	var doneInfo: LCOMSDoneInfo = LCOMSDoneInfo()
	
	/// SoftAp引导步骤
	var softApGuideInfo: LCOMSSoftApGuideInfo = LCOMSSoftApGuideInfo()
	
	/// 设备本地配网引导
	var localGuideInfo: LCOMSSLocalGuideInfo = LCOMSSLocalGuideInfo()
	
	/// NBIoT配网引导
	var nbGuideInfo: LCOMSSNBIoTGuideInfo = LCOMSSNBIoTGuideInfo()
	
	private var introduction: LCOMSIntroductionInfo!
	
	required public init(introduction: LCOMSIntroductionInfo) {
		super.init()
		
		self.introduction = introduction
		self.updateTime = introduction.updateTime
		
		//解析图片
		if let images = introduction.images as? [LCOMSIntroductionImageItem] {
			for item in images {
				self.parserLightCheckInfo(imageItem: item)
				self.parserLightResetInfo(imageItem: item)
				self.parserAccessoryPairLightCheckInfo(imageItem: item)
				self.parserAccessoryPairLightResetInfo(imageItem: item)
				self.parserAccessoryPairDoneInfo(imageItem: item)
				self.parserLocalGuideInfo(imageItem: item)
				self.parserNBGuideInfo(imageItem: item)
			}
			
			for index in 0..<LCOMSSoftApGuideStep.keySoftApGuideMaxStep {
				self.parserSoftApStep(step: index, imageItems: images)
			}
		}
		
		//解析文案
		if let contens = introduction.contens as? [LCOMSIntroductionContentItem] {
			for item in contens {
				self.parserErrorType(item: item)
				self.parserLightCheckInfo(contentItem: item)
				self.parserLightResetInfo(contentItem: item)
				self.parserAccessoryPairLightCheckInfo(contentItem: item)
				self.parserAccessoryPairLightResetInfo(contentItem: item)
				self.parserAccessoryPairDoneInfo(contentItem: item)
				self.parserSoftApWifi(item: item)
                self.parserSoftApWifiModelVersion(item: item)
				self.parserLocalGuideInfo(contentItem: item)
				self.parserNBGuideInfo(contentItem: item)
			}
			
			for index in 0..<LCOMSSoftApGuideStep.keySoftApGuideMaxStep {
				self.parserSoftApStep(step: index, contentItems: contens)
			}
		}
	}
	
	// MARK: 解析错误类型
	func parserErrorType(item: LCOMSIntroductionContentItem) {
	
		// 国内：解析WifiErrorTipsType及SoftAPErrorTipsType
		// 海外：解析ErrorTipsType
		var uppercaseString = ""
		var omsType: LCOMSErrorType? = nil
		
		if LCModuleConfig.shareInstance().isChinaMainland {
			if item.introductionName.lc_caseInsensitiveSame(string: LCOMSErrorType.wifi.rawValue) {
				omsType = .wifi
				uppercaseString = item.introductionContent!
			} else if item.introductionName.lc_caseInsensitiveSame(string: LCOMSErrorType.softAp.rawValue) {
				omsType = .softAp
				uppercaseString = item.introductionContent!
			}
		} else {
			if item.introductionName.lc_caseInsensitiveSame(string: LCOMSErrorType.old.rawValue) {
				omsType = .old
				uppercaseString = item.introductionContent!
			}
		}
		
		if uppercaseString.count == 0 {
			return
		}
		
		//默认通用带有线
		var errorType: LCNetConnectFailureType?
		
        if uppercaseString.lc_caseInsensitiveSame(string: "TP1S Mode") {
			errorType = .tp1s
        } else if uppercaseString.lc_caseInsensitiveSame(string: "TP1 Mode") {
			errorType = .tp1
        } else if uppercaseString.lc_caseInsensitiveSame(string: "G1 Mode") {
			errorType = .g1
        } else if uppercaseString.lc_caseInsensitiveSame(string: "K5 Mode") {
			errorType = .door
        } else if uppercaseString.lc_caseInsensitiveSame(string: "IPC General") {
            errorType = .ipcGeneral
        } else if uppercaseString.lc_caseInsensitiveSame(string: "A Mode") {
			errorType = .overseasA
        } else if uppercaseString.lc_caseInsensitiveSame(string: "CK Mode") {
			errorType = .overseasC
        } else if uppercaseString.lc_caseInsensitiveSame(string: "Doorbell") {
			errorType = .overseasDoorbell
        } else if uppercaseString.lc_caseInsensitiveSame(string: "Small Bell") {
			errorType = .overseasDoorbell
        } else if uppercaseString.lc_caseInsensitiveSame(string: "Accessory General") {
			errorType = .accessory
        }
		
		if omsType == .wifi || omsType == .old {
			self.errorType = errorType
		} else if omsType == .softAp {
			self.softApErrorType = errorType
		}
	}
	
	// MARK: 解析设备指示灯
	func parserLightCheckInfo(imageItem: LCOMSIntroductionImageItem) {
		//【*】WIFi、HUB、配件等
		let keyImageUlrs: [String] = [LCOMSLightCheckInfo.keyWifiModeImageUrl,
									  LCOMSLightCheckInfo.keyHubModeImageUrl,
									  LCOMSLightCheckInfo.keyAccessoryModeImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.lc_caseInsensitiveSame(string: keyImage) {
				self.lightCheckInfo.lightTwinkleImageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserLightCheckInfo(contentItem: LCOMSIntroductionContentItem) {
		//【*】WIFi、HUB、配件等
		let keyContents: [String] = [LCOMSLightCheckInfo.keyWifiModeContent,
									 LCOMSLightCheckInfo.keyHubModeContent,
									 LCOMSLightCheckInfo.keyAccessoryModeContent]
		for keyContent in keyContents {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.lightCheckInfo.lightTwinkleContent = contentItem.introductionContent
				return
			}
		}
		
		let keyConfirms: [String] = [LCOMSLightCheckInfo.keyWifiModeConfirm,
								  LCOMSLightCheckInfo.keyHubModeConfirm,
								  LCOMSLightCheckInfo.keyAccessoryModeConfirm]
		for keyConfirm in keyConfirms {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyConfirm), contentItem.introductionContent.count > 0 {
				self.lightCheckInfo.lightTwinklConfirm = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析设备重置
	func parserLightResetInfo(imageItem: LCOMSIntroductionImageItem) {
		//解析设备重置
		let keyImageUlrs: [String] = [LCOMSLightResetInfo.keyWifiModeImageUrl,
									  LCOMSLightResetInfo.keyHubModeImageUrl,
									  LCOMSLightResetInfo.keySoftApModeImageUrl,
									  LCOMSLightResetInfo.keyAccessoryModeImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.lc_caseInsensitiveSame(string: keyImage) {
				self.lightResetInfo.resetImageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserLightResetInfo(contentItem: LCOMSIntroductionContentItem) {
		//【*】WIFi、HUB、配件等
		let keyGuides: [String] = [LCOMSLightResetInfo.keyWifiModeGuide,
								   LCOMSLightResetInfo.keyHubModeGuide,
								   LCOMSLightResetInfo.keySoftApModeGuide,
								   LCOMSLightResetInfo.keyAccessoryModeGuide]
		for keyGuide in keyGuides {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyGuide), contentItem.introductionContent.count > 0 {
				self.lightResetInfo.resetGuide = contentItem.introductionContent
				return
			}
		}
		
		let keyOperations: [String] = [LCOMSLightResetInfo.keyWifiModeOperation,
									   LCOMSLightResetInfo.keyHubModeOperation,
									   LCOMSLightResetInfo.keySoftApModeOperation,
									   LCOMSLightResetInfo.keyAccessoryModeOperation]
		for keyOperation in keyOperations {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyOperation), contentItem.introductionContent.count > 0 {
				self.lightResetInfo.resetOperation = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析配对设备指示灯
	func parserAccessoryPairLightCheckInfo(imageItem: LCOMSIntroductionImageItem) {
		// 目前只配置了HUB配对
		let keyImageUlrs: [String] = [LCOMSLightCheckInfo.keyHubModeAccessoryImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.lc_caseInsensitiveSame(string: keyImage) {
				self.accessoryPairLightCheckInfo.lightTwinkleImageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserAccessoryPairLightCheckInfo(contentItem: LCOMSIntroductionContentItem) {
		// 目前只配置了HUB配对
		let keyContents: [String] = [LCOMSLightCheckInfo.keyHubModeAccessoryContent]
		for keyContent in keyContents {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.accessoryPairLightCheckInfo.lightTwinkleContent = contentItem.introductionContent
				return
			}
		}
		
		let keyConfirms: [String] = [LCOMSLightCheckInfo.keyHubModeAccessoryConfirm]
		for keyConfirm in keyConfirms {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyConfirm), contentItem.introductionContent.count > 0 {
				self.accessoryPairLightCheckInfo.lightTwinklConfirm = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析配对重置信息
	func parserAccessoryPairLightResetInfo(imageItem: LCOMSIntroductionImageItem) {
		// 目前只配置了HUB配对
		let keyImageUlrs: [String] = [LCOMSLightResetInfo.keyHubModeAccessoryImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.lc_caseInsensitiveSame(string: keyImage) {
				self.accessoryPairLightResetInfo.resetImageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserAccessoryPairLightResetInfo(contentItem: LCOMSIntroductionContentItem) {
		// 目前只配置了HUB配对
		let keyGuides: [String] = [LCOMSLightResetInfo.keyHubModeAccessoryGuide]
		for keyGuide in keyGuides {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyGuide), contentItem.introductionContent.count > 0 {
				self.accessoryPairLightResetInfo.resetGuide = contentItem.introductionContent
				return
			}
		}
		
		let keyOperations: [String] = [LCOMSLightResetInfo.keyHubModeAccessoryOperation]
		for keyOperation in keyOperations {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyOperation), contentItem.introductionContent.count > 0 {
				self.accessoryPairLightResetInfo.resetOperation = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析完成信息
	func parserAccessoryPairDoneInfo(imageItem: LCOMSIntroductionImageItem) {
		//WIFI、SoftAp、配件、Local（猫眼）
		let keyImageUlrs: [String] = [LCOMSDoneInfo.keyWifiModeDoneImageUrl,
									  LCOMSDoneInfo.keySoftApModePairDoneImageUrl,
									  LCOMSDoneInfo.keyAccessoryModePairDoneImageUrl,
									  LCOMSDoneInfo.keyLocalModePairdDoneImageUrl,
									  LCOMSDoneInfo.keyNBModePairDoneImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.lc_caseInsensitiveSame(string: keyImage) {
				self.doneInfo.imageUrl = imageItem.imageURI
				return
			}
		}
		
		//【*】特殊处理，hub配对的完成图
		if imageItem.imageName.lc_caseInsensitiveSame(string: LCOMSDoneInfo.keyHubModePairDoneImageUrl) {
			self.doneInfo.hubPairImageUrl = imageItem.imageURI
		}
		
		//【*】特殊的处理，p2p软AP的完成页引导图
		if imageItem.imageName.lc_caseInsensitiveSame(string: LCOMSDoneInfo.keySoftApModePairDoneGuideImageUrl) {
			self.doneInfo.guideImageUrl = imageItem.imageURI
		}
	}
	
	func parserAccessoryPairDoneInfo(contentItem: LCOMSIntroductionContentItem) {
		// Hub、SoftAp
		let keyGuides: [String] = [LCOMSDoneInfo.keyHubModePairDoneRepairGuide,
								   LCOMSDoneInfo.keySoftApModePairDoneRepairGuide]
		for keyGuide in keyGuides {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyGuide), contentItem.introductionContent.count > 0 {
				self.doneInfo.guide = contentItem.introductionContent
				return
			}
		}
		
		let keyContents: [String] = [LCOMSDoneInfo.keyHubModePairDoneContent,
									 LCOMSDoneInfo.keySoftApModePairDoneContent]
		for keyContent in keyContents {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.doneInfo.content = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析SoftAp步骤信息【需要先解析图片，进行数组填充】
	func parserSoftApStep(step: NSInteger, imageItems: [LCOMSIntroductionImageItem]) {
		guard step < LCOMSSoftApGuideStep.keySoftApGuideMaxStep else {
			return
		}
		
		
		//解析图片
		let keyImages: [String] = [LCOMSSoftApGuideStep.keySoftApStepOneImageUrl,
								   LCOMSSoftApGuideStep.keySoftApStepTwoImageUrl,
								   LCOMSSoftApGuideStep.keySoftApStepThreeImageUrl,
								   LCOMSSoftApGuideStep.keySoftApStepFourImageUrl ]
		
		for item in imageItems {
			if item.imageName.lc_caseInsensitiveSame(string: keyImages[step]) {
				if self.softApGuideInfo.guideSteps.count > step {
					self.softApGuideInfo.guideSteps[step].imageUrl = item.imageURI
				} else {
					var guideStep = LCOMSSoftApGuideStep()
					guideStep.imageUrl = item.imageURI
					self.softApGuideInfo.guideSteps.append(guideStep)
				}

				break
			}
		}
	}
	
	func parserSoftApStep(step: NSInteger, contentItems: [LCOMSIntroductionContentItem]) {
		guard step < LCOMSSoftApGuideStep.keySoftApGuideMaxStep else {
			return
		}
		
		//解析内容
		let keyGuides: [String] = [LCOMSSoftApGuideStep.keySoftApStepOneGuide,
								   LCOMSSoftApGuideStep.keySoftApStepTwoGuide,
								   LCOMSSoftApGuideStep.keySoftApStepThreeGuide,
								   LCOMSSoftApGuideStep.keySoftApStepFourGuide ]
		
		for item in contentItems {
			if item.introductionName.lc_caseInsensitiveSame(string: keyGuides[step]), item.introductionContent.count > 0 {
				if self.softApGuideInfo.guideSteps.count > step {
					self.softApGuideInfo.guideSteps[step].content = item.introductionContent
				} else {
					var guideStep = LCOMSSoftApGuideStep()
					guideStep.content = item.introductionContent
					self.softApGuideInfo.guideSteps.append(guideStep)
				}
				
				break
			}
		}
	}
	
	// MARK: SoftAp Wifi
	func parserSoftApWifi(item: LCOMSIntroductionContentItem) {
		if item.introductionName.lc_caseInsensitiveSame(string: LCOMSSoftApGuideInfo.keyWifiName) == false {
			return
		}
		
		if item.introductionContent == nil || item.introductionContent.count == 0 {
			return
		}
		
		self.softApGuideInfo.wifiName = item.introductionContent
	}
	
    // MARK: SoftAp Wifi model version
    func parserSoftApWifiModelVersion(item: LCOMSIntroductionContentItem) {
        if item.introductionName.lc_caseInsensitiveSame(string: LCOMSSoftApGuideInfo.keyWifiModelVersion) == false {
            return
        }
        
        if item.introductionContent == nil || item.introductionContent.count == 0 {
            return
        }
        
        self.softApGuideInfo.wifiModelVersion = item.introductionContent
    }
    
	// MARK: Local Guide
	func parserLocalGuideInfo(contentItem: LCOMSIntroductionContentItem) {
		let keyContents: [String] = [LCOMSSLocalGuideInfo.keyLocalModeContent]
		for keyContent in keyContents {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.localGuideInfo.content = contentItem.introductionContent
				return
			}
		}
	}
	
	func parserLocalGuideInfo(imageItem: LCOMSIntroductionImageItem) {
		let keyImages: [String] = [LCOMSSLocalGuideInfo.keyLocalModeImageUrl]
		for keyImage in keyImages {
			if imageItem.imageName.lc_caseInsensitiveSame(string: keyImage), imageItem.imageURI.count > 0 {
				self.localGuideInfo.imageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	// MARK: - NBIoT
	func parserNBGuideInfo(imageItem: LCOMSIntroductionImageItem) {
		let keyImages: [String] = [LCOMSSNBIoTGuideInfo.keyNBIoTModeImageUrl]
		for keyImage in keyImages {
			if imageItem.imageName.lc_caseInsensitiveSame(string: keyImage), imageItem.imageURI.count > 0 {
				self.nbGuideInfo.imageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserNBGuideInfo(contentItem: LCOMSIntroductionContentItem) {
		let keyContents: [String] = [LCOMSSNBIoTGuideInfo.keyNBIoTModeContent]
		for keyContent in keyContents {
			if contentItem.introductionName.lc_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.nbGuideInfo.content = contentItem.introductionContent
				return
			}
		}
	}
}
