//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	引导信息解析

import UIKit

public class DHIntroductionParser: NSObject {
	
	/// 更新时间
	var updateTime: String = ""
	
	/// 网络配置：WIFI配置超时
	var errorType: DHNetConnectFailureType?
	
	/// 软Ap错误码【兼容G1，既支持软AP，又支持SmartConfig】
	var softApErrorType: DHNetConnectFailureType?
	
	/// 设备指示灯闪烁相关信息
	var lightCheckInfo: DHOMSLightCheckInfo = DHOMSLightCheckInfo()
	
	/// 设备指示灯重置相关信息
	var lightResetInfo: DHOMSLightResetInfo = DHOMSLightResetInfo()
	
	/// 设备配对（如UB配件）指示灯相关信息
	var accessoryPairLightCheckInfo: DHOMSLightCheckInfo = DHOMSLightCheckInfo()
	
	/// 设备配对（如UB配件）指示灯重置相关信息
	var accessoryPairLightResetInfo: DHOMSLightResetInfo = DHOMSLightResetInfo()
	
	/// 完成相关信息
	var doneInfo: DHOMSDoneInfo = DHOMSDoneInfo()
	
	/// SoftAp引导步骤
	var softApGuideInfo: DHOMSSoftApGuideInfo = DHOMSSoftApGuideInfo()
	
	/// 设备本地配网引导
	var localGuideInfo: DHOMSSLocalGuideInfo = DHOMSSLocalGuideInfo()
	
	/// NBIoT配网引导
	var nbGuideInfo: DHOMSSNBIoTGuideInfo = DHOMSSNBIoTGuideInfo()
	
	private var introduction: DHOMSIntroductionInfo!
	
	required public init(introduction: DHOMSIntroductionInfo) {
		super.init()
		
		self.introduction = introduction
		self.updateTime = introduction.updateTime
		
		//解析图片
		if let images = introduction.images as? [DHOMSIntroductionImageItem] {
			for item in images {
				self.parserLightCheckInfo(imageItem: item)
				self.parserLightResetInfo(imageItem: item)
				self.parserAccessoryPairLightCheckInfo(imageItem: item)
				self.parserAccessoryPairLightResetInfo(imageItem: item)
				self.parserAccessoryPairDoneInfo(imageItem: item)
				self.parserLocalGuideInfo(imageItem: item)
				self.parserNBGuideInfo(imageItem: item)
			}
			
			for index in 0..<DHOMSSoftApGuideStep.keySoftApGuideMaxStep {
				self.parserSoftApStep(step: index, imageItems: images)
			}
		}
		
		//解析文案
		if let contens = introduction.contens as? [DHOMSIntroductionContentItem] {
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
			
			for index in 0..<DHOMSSoftApGuideStep.keySoftApGuideMaxStep {
				self.parserSoftApStep(step: index, contentItems: contens)
			}
		}
	}
	
	// MARK: 解析错误类型
	func parserErrorType(item: DHOMSIntroductionContentItem) {
	
		// 国内：解析WifiErrorTipsType及SoftAPErrorTipsType
		// 海外：解析ErrorTipsType
		var uppercaseString = ""
		var omsType: DHOMSErrorType? = nil
		
		if DHModuleConfig.shareInstance().isLeChange {
			if item.introductionName.dh_caseInsensitiveSame(string: DHOMSErrorType.wifi.rawValue) {
				omsType = .wifi
				uppercaseString = item.introductionContent!
			} else if item.introductionName.dh_caseInsensitiveSame(string: DHOMSErrorType.softAp.rawValue) {
				omsType = .softAp
				uppercaseString = item.introductionContent!
			}
		} else {
			if item.introductionName.dh_caseInsensitiveSame(string: DHOMSErrorType.old.rawValue) {
				omsType = .old
				uppercaseString = item.introductionContent!
			}
		}
		
		if uppercaseString.count == 0 {
			return
		}
		
		//默认通用带有线
		var errorType: DHNetConnectFailureType?
		
        if uppercaseString.dh_caseInsensitiveSame(string: "TP1S Mode") {
			errorType = .tp1s
        } else if uppercaseString.dh_caseInsensitiveSame(string: "TP1 Mode") {
			errorType = .tp1
        } else if uppercaseString.dh_caseInsensitiveSame(string: "G1 Mode") {
			errorType = .g1
        } else if uppercaseString.dh_caseInsensitiveSame(string: "K5 Mode") {
			errorType = .door
        } else if uppercaseString.dh_caseInsensitiveSame(string: "IPC General") {
            errorType = .ipcGeneral
        } else if uppercaseString.dh_caseInsensitiveSame(string: "A Mode") {
			errorType = .overseasA
        } else if uppercaseString.dh_caseInsensitiveSame(string: "CK Mode") {
			errorType = .overseasC
        } else if uppercaseString.dh_caseInsensitiveSame(string: "Doorbell") {
			errorType = .overseasDoorbell
        } else if uppercaseString.dh_caseInsensitiveSame(string: "Small Bell") {
			errorType = .overseasDoorbell
        } else if uppercaseString.dh_caseInsensitiveSame(string: "Accessory General") {
			errorType = .accessory
        }
		
		if omsType == .wifi || omsType == .old {
			self.errorType = errorType
		} else if omsType == .softAp {
			self.softApErrorType = errorType
		}
	}
	
	// MARK: 解析设备指示灯
	func parserLightCheckInfo(imageItem: DHOMSIntroductionImageItem) {
		//【*】WIFi、HUB、配件等
		let keyImageUlrs: [String] = [DHOMSLightCheckInfo.keyWifiModeImageUrl,
									  DHOMSLightCheckInfo.keyHubModeImageUrl,
									  DHOMSLightCheckInfo.keyAccessoryModeImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.dh_caseInsensitiveSame(string: keyImage) {
				self.lightCheckInfo.lightTwinkleImageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserLightCheckInfo(contentItem: DHOMSIntroductionContentItem) {
		//【*】WIFi、HUB、配件等
		let keyContents: [String] = [DHOMSLightCheckInfo.keyWifiModeContent,
									 DHOMSLightCheckInfo.keyHubModeContent,
									 DHOMSLightCheckInfo.keyAccessoryModeContent]
		for keyContent in keyContents {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.lightCheckInfo.lightTwinkleContent = contentItem.introductionContent
				return
			}
		}
		
		let keyConfirms: [String] = [DHOMSLightCheckInfo.keyWifiModeConfirm,
								  DHOMSLightCheckInfo.keyHubModeConfirm,
								  DHOMSLightCheckInfo.keyAccessoryModeConfirm]
		for keyConfirm in keyConfirms {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyConfirm), contentItem.introductionContent.count > 0 {
				self.lightCheckInfo.lightTwinklConfirm = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析设备重置
	func parserLightResetInfo(imageItem: DHOMSIntroductionImageItem) {
		//解析设备重置
		let keyImageUlrs: [String] = [DHOMSLightResetInfo.keyWifiModeImageUrl,
									  DHOMSLightResetInfo.keyHubModeImageUrl,
									  DHOMSLightResetInfo.keySoftApModeImageUrl,
									  DHOMSLightResetInfo.keyAccessoryModeImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.dh_caseInsensitiveSame(string: keyImage) {
				self.lightResetInfo.resetImageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserLightResetInfo(contentItem: DHOMSIntroductionContentItem) {
		//【*】WIFi、HUB、配件等
		let keyGuides: [String] = [DHOMSLightResetInfo.keyWifiModeGuide,
								   DHOMSLightResetInfo.keyHubModeGuide,
								   DHOMSLightResetInfo.keySoftApModeGuide,
								   DHOMSLightResetInfo.keyAccessoryModeGuide]
		for keyGuide in keyGuides {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyGuide), contentItem.introductionContent.count > 0 {
				self.lightResetInfo.resetGuide = contentItem.introductionContent
				return
			}
		}
		
		let keyOperations: [String] = [DHOMSLightResetInfo.keyWifiModeOperation,
									   DHOMSLightResetInfo.keyHubModeOperation,
									   DHOMSLightResetInfo.keySoftApModeOperation,
									   DHOMSLightResetInfo.keyAccessoryModeOperation]
		for keyOperation in keyOperations {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyOperation), contentItem.introductionContent.count > 0 {
				self.lightResetInfo.resetOperation = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析配对设备指示灯
	func parserAccessoryPairLightCheckInfo(imageItem: DHOMSIntroductionImageItem) {
		// 目前只配置了HUB配对
		let keyImageUlrs: [String] = [DHOMSLightCheckInfo.keyHubModeAccessoryImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.dh_caseInsensitiveSame(string: keyImage) {
				self.accessoryPairLightCheckInfo.lightTwinkleImageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserAccessoryPairLightCheckInfo(contentItem: DHOMSIntroductionContentItem) {
		// 目前只配置了HUB配对
		let keyContents: [String] = [DHOMSLightCheckInfo.keyHubModeAccessoryContent]
		for keyContent in keyContents {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.accessoryPairLightCheckInfo.lightTwinkleContent = contentItem.introductionContent
				return
			}
		}
		
		let keyConfirms: [String] = [DHOMSLightCheckInfo.keyHubModeAccessoryConfirm]
		for keyConfirm in keyConfirms {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyConfirm), contentItem.introductionContent.count > 0 {
				self.accessoryPairLightCheckInfo.lightTwinklConfirm = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析配对重置信息
	func parserAccessoryPairLightResetInfo(imageItem: DHOMSIntroductionImageItem) {
		// 目前只配置了HUB配对
		let keyImageUlrs: [String] = [DHOMSLightResetInfo.keyHubModeAccessoryImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.dh_caseInsensitiveSame(string: keyImage) {
				self.accessoryPairLightResetInfo.resetImageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserAccessoryPairLightResetInfo(contentItem: DHOMSIntroductionContentItem) {
		// 目前只配置了HUB配对
		let keyGuides: [String] = [DHOMSLightResetInfo.keyHubModeAccessoryGuide]
		for keyGuide in keyGuides {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyGuide), contentItem.introductionContent.count > 0 {
				self.accessoryPairLightResetInfo.resetGuide = contentItem.introductionContent
				return
			}
		}
		
		let keyOperations: [String] = [DHOMSLightResetInfo.keyHubModeAccessoryOperation]
		for keyOperation in keyOperations {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyOperation), contentItem.introductionContent.count > 0 {
				self.accessoryPairLightResetInfo.resetOperation = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析完成信息
	func parserAccessoryPairDoneInfo(imageItem: DHOMSIntroductionImageItem) {
		//WIFI、SoftAp、配件、Local（猫眼）
		let keyImageUlrs: [String] = [DHOMSDoneInfo.keyWifiModeDoneImageUrl,
									  DHOMSDoneInfo.keySoftApModePairDoneImageUrl,
									  DHOMSDoneInfo.keyAccessoryModePairDoneImageUrl,
									  DHOMSDoneInfo.keyLocalModePairdDoneImageUrl,
									  DHOMSDoneInfo.keyNBModePairDoneImageUrl]
		for keyImage in keyImageUlrs {
			if imageItem.imageName.dh_caseInsensitiveSame(string: keyImage) {
				self.doneInfo.imageUrl = imageItem.imageURI
				return
			}
		}
		
		//【*】特殊处理，hub配对的完成图
		if imageItem.imageName.dh_caseInsensitiveSame(string: DHOMSDoneInfo.keyHubModePairDoneImageUrl) {
			self.doneInfo.hubPairImageUrl = imageItem.imageURI
		}
		
		//【*】特殊的处理，p2p软AP的完成页引导图
		if imageItem.imageName.dh_caseInsensitiveSame(string: DHOMSDoneInfo.keySoftApModePairDoneGuideImageUrl) {
			self.doneInfo.guideImageUrl = imageItem.imageURI
		}
	}
	
	func parserAccessoryPairDoneInfo(contentItem: DHOMSIntroductionContentItem) {
		// Hub、SoftAp
		let keyGuides: [String] = [DHOMSDoneInfo.keyHubModePairDoneRepairGuide,
								   DHOMSDoneInfo.keySoftApModePairDoneRepairGuide]
		for keyGuide in keyGuides {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyGuide), contentItem.introductionContent.count > 0 {
				self.doneInfo.guide = contentItem.introductionContent
				return
			}
		}
		
		let keyContents: [String] = [DHOMSDoneInfo.keyHubModePairDoneContent,
									 DHOMSDoneInfo.keySoftApModePairDoneContent]
		for keyContent in keyContents {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.doneInfo.content = contentItem.introductionContent
				return
			}
		}
	}
	
	// MARK: 解析SoftAp步骤信息【需要先解析图片，进行数组填充】
	func parserSoftApStep(step: NSInteger, imageItems: [DHOMSIntroductionImageItem]) {
		guard step < DHOMSSoftApGuideStep.keySoftApGuideMaxStep else {
			return
		}
		
		
		//解析图片
		let keyImages: [String] = [DHOMSSoftApGuideStep.keySoftApStepOneImageUrl,
								   DHOMSSoftApGuideStep.keySoftApStepTwoImageUrl,
								   DHOMSSoftApGuideStep.keySoftApStepThreeImageUrl,
								   DHOMSSoftApGuideStep.keySoftApStepFourImageUrl ]
		
		for item in imageItems {
			if item.imageName.dh_caseInsensitiveSame(string: keyImages[step]) {
				if self.softApGuideInfo.guideSteps.count > step {
					self.softApGuideInfo.guideSteps[step].imageUrl = item.imageURI
				} else {
					var guideStep = DHOMSSoftApGuideStep()
					guideStep.imageUrl = item.imageURI
					self.softApGuideInfo.guideSteps.append(guideStep)
				}

				break
			}
		}
	}
	
	func parserSoftApStep(step: NSInteger, contentItems: [DHOMSIntroductionContentItem]) {
		guard step < DHOMSSoftApGuideStep.keySoftApGuideMaxStep else {
			return
		}
		
		//解析内容
		let keyGuides: [String] = [DHOMSSoftApGuideStep.keySoftApStepOneGuide,
								   DHOMSSoftApGuideStep.keySoftApStepTwoGuide,
								   DHOMSSoftApGuideStep.keySoftApStepThreeGuide,
								   DHOMSSoftApGuideStep.keySoftApStepFourGuide ]
		
		for item in contentItems {
			if item.introductionName.dh_caseInsensitiveSame(string: keyGuides[step]), item.introductionContent.count > 0 {
				if self.softApGuideInfo.guideSteps.count > step {
					self.softApGuideInfo.guideSteps[step].content = item.introductionContent
				} else {
					var guideStep = DHOMSSoftApGuideStep()
					guideStep.content = item.introductionContent
					self.softApGuideInfo.guideSteps.append(guideStep)
				}
				
				break
			}
		}
	}
	
	// MARK: SoftAp Wifi
	func parserSoftApWifi(item: DHOMSIntroductionContentItem) {
		if item.introductionName.dh_caseInsensitiveSame(string: DHOMSSoftApGuideInfo.keyWifiName) == false {
			return
		}
		
		if item.introductionContent == nil || item.introductionContent.count == 0 {
			return
		}
		
		self.softApGuideInfo.wifiName = item.introductionContent
	}
	
    // MARK: SoftAp Wifi model version
    func parserSoftApWifiModelVersion(item: DHOMSIntroductionContentItem) {
        if item.introductionName.dh_caseInsensitiveSame(string: DHOMSSoftApGuideInfo.keyWifiModelVersion) == false {
            return
        }
        
        if item.introductionContent == nil || item.introductionContent.count == 0 {
            return
        }
        
        self.softApGuideInfo.wifiModelVersion = item.introductionContent
    }
    
	// MARK: Local Guide
	func parserLocalGuideInfo(contentItem: DHOMSIntroductionContentItem) {
		let keyContents: [String] = [DHOMSSLocalGuideInfo.keyLocalModeContent]
		for keyContent in keyContents {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.localGuideInfo.content = contentItem.introductionContent
				return
			}
		}
	}
	
	func parserLocalGuideInfo(imageItem: DHOMSIntroductionImageItem) {
		let keyImages: [String] = [DHOMSSLocalGuideInfo.keyLocalModeImageUrl]
		for keyImage in keyImages {
			if imageItem.imageName.dh_caseInsensitiveSame(string: keyImage), imageItem.imageURI.count > 0 {
				self.localGuideInfo.imageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	// MARK: - NBIoT
	func parserNBGuideInfo(imageItem: DHOMSIntroductionImageItem) {
		let keyImages: [String] = [DHOMSSNBIoTGuideInfo.keyNBIoTModeImageUrl]
		for keyImage in keyImages {
			if imageItem.imageName.dh_caseInsensitiveSame(string: keyImage), imageItem.imageURI.count > 0 {
				self.nbGuideInfo.imageUrl = imageItem.imageURI
				return
			}
		}
	}
	
	func parserNBGuideInfo(contentItem: DHOMSIntroductionContentItem) {
		let keyContents: [String] = [DHOMSSNBIoTGuideInfo.keyNBIoTModeContent]
		for keyContent in keyContents {
			if contentItem.introductionName.dh_caseInsensitiveSame(string: keyContent), contentItem.introductionContent.count > 0 {
				self.nbGuideInfo.content = contentItem.introductionContent
				return
			}
		}
	}
}
