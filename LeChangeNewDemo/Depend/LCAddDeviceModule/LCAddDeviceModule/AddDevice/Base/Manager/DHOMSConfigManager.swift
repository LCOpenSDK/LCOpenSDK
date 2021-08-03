//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	OMS配置信息
//	1、型号信息文件 Support/OMS/Models/[Language]
//	2、引导信息文件 Support/OMS/Introductions/[MarketModel_Language]

import UIKit

class DHOMSConfigManager: NSObject, DHOMSConfigManagerProtocol {

	/// 由于和DHServiceProtocol协议相冲突，这里使用sharedManager替代
	@objc static let sharedManager = DHOMSConfigManager()
	
	var types: [DHOMSDeviceType] = [DHOMSDeviceType]()
	
	/// 市场型号对应的引导信息
	var dicIntoductions: [String: DHIntroductionParser] =  [String: DHIntroductionParser]()
	
	/// 市场型号对应的引导状态
	var dicIntroductionStatus = [String: Bool]()
	
	/// 标记设备型号是否更新成功
	var isUpdatedSuccessfully: Bool = false
	
	/// 更新型号列表时间
	private var updateTime: String = ""

	override init() {
		super.init()
		loadModelInfos()
	}
	
	static func isSingleton() -> Bool {
		return true
	}
	
	static func sharedInstance() -> Any! {
		return sharedManager
	}

	@objc func checkUpdateDeviceModels() {
        self.updateDeviceModels()
		//【*】使用本地时间进行检验
		//【*】更新列表
		if self.updateTime.count == 0 {
			self.updateDeviceModels()
		} else {
            LCAddDeviceInterface.checkDeviceIntroduction(withUpdateTime: self.updateTime, success: { (isUpdated) in
                if isUpdated {
                    self.updateDeviceModels()
                } else {
                    self.isUpdatedSuccessfully = true
                }
            }) { (error) in
                self.updateDeviceModels()
                self.addDeviceEndLog()
            }
		}
	}
	
	@objc func checkUpdateIntrodution(byMarketModel model: String) {
		//【*】异常处理
		if model.count == 0 {
			return
		}
		
		//【*】如果字典中没有引导信息，先从缓存文件进行加载
		if dicIntoductions[model] == nil {
			self.loadIntroduction(byMarketModel: model)
		}
		
		// 【*】正在更新，不需要处理
		if dicIntroductionStatus[model] == true {
			return
		}
		
		dicIntroductionStatus[model] = true
		
		//【*】如果加载了引导信息，进行check.
		if let introdctionParser = dicIntoductions[model] {
			if introdctionParser.updateTime.count == 0 {
				self.updateIntroduction(byMarketModel: model)
			} else {
                LCAddDeviceInterface.checkDeviceIntroduction(withUpdateTime: introdctionParser.updateTime, success: { (isUpdated) in
                                        if isUpdated {
                        self.updateIntroduction(byMarketModel: model)
                    } else {
                        self.dicIntroductionStatus[model] = false
                    }
                }) { (error) in
                    self.updateIntroduction(byMarketModel: model)
                }
			}
		} else {
			self.updateIntroduction(byMarketModel: model)
		}
	}
	
	// MARK: 取引导信息
	
	/// 根据市场型号获取具体引导信息
	///
	/// - Parameters:
	///   - marketModel: 市场型号
	func getIntroductionParser(marketModel: String) -> DHIntroductionParser? {
		return self.dicIntoductions[marketModel]
	}
	
	/// 登录后，加载指定的型号，如果缓存里面已经有，则不更新
	func preloadIntroductions() {
		let preloadModels = DHModuleConfig.shareInstance().preloadIntroductionModels()
		let language = currentLanguageCode()
		
		for marketModel in preloadModels {
			let path = self.deviceIntroductionInfosPath(byLanguage: language, marketModel: marketModel)
			if FileManager.default.fileExists(atPath: path) == false {
				checkUpdateIntrodution(byMarketModel: marketModel)
			}
		}
	}
	
	// MARK: Private
	private func updateDeviceModels() {
        LCAddDeviceInterface.queryAllProduct(withDeviceType: nil, success: { (dic) in
            if let time = dic["updateTime"] as? String {
                self.updateTime = time
            }
            if let deviceTypeConfigs = dic["deviceTypeConfigs"] as? [DHOMSDeviceType], deviceTypeConfigs.count > 0 {
                self.types.removeAll()
                self.types.append(contentsOf: deviceTypeConfigs)
                self.isUpdatedSuccessfully = true
                self.saveModelInfos()

                DispatchQueue.main.async {
                    let notification = NSNotification.Name(rawValue: "LCNotificationOMSIModelsUpdated")
                    NotificationCenter.default.post(name: notification, object: nil)
                }
            }
        }) { (error) in
            
        }
	}
	
	private func updateIntroduction(byMarketModel model: String) {
		let notification = NSNotification.Name(rawValue: "LCNotificationOMSIntrodutionUpdated")
        LCAddDeviceInterface.getDeviceIntroduction(forDeviceModel: model, success: { (introduction) in
            self.dicIntoductions[model] = DHIntroductionParser(introduction: introduction)
            self.dicIntroductionStatus[model] = false

            //updateTime有值时才缓存，可能返回的数据为空，用此进行判断
            if introduction.updateTime.count > 0 {
                self.saveIntroduction(byMarketModel: model, introduction: introduction)
            }

            NotificationCenter.default.post(name: notification, object: nil, userInfo: ["MarketModel": model])
        }) { (error) in
            self.dicIntroductionStatus[model] = false
            NotificationCenter.default.post(name: notification, object: nil, userInfo: ["MarketModel": model])
            print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Update introduction failed...")
        }
	}
	
	// MARK: OMS Cache
	@objc func clearOMSCache() {
		let folder = cacheFolderPath()
	
		do {
			try FileManager.default.removeItem(atPath: folder)
			//清除缓存成功，同时清除内存缓存
			self.dicIntoductions.removeAll()
		} catch {
			print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Clear oms cache failed...")
		}
	}
	
	@objc func cacheFolderPath() -> String {
		let folder = (DHFileManager.supportFolder() as NSString).appendingPathComponent("OMS")
		return folder
	}
	
	// MARK: Save & Load
	private func deviceModelInfosPath(byLanguage: String) -> String {
		let folder = (cacheFolderPath() as NSString).appendingPathComponent("Models")
		if FileManager.default.fileExists(atPath: folder) == false {
			try?FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
		}
		let filePath = (folder as NSString).appendingPathComponent(byLanguage)
		return filePath
	}
	
	private func deviceIntroductionInfosPath(byLanguage: String, marketModel: String) -> String {
		let folder = (cacheFolderPath() as NSString).appendingPathComponent("Introductions")
		if FileManager.default.fileExists(atPath: folder) == false {
			try?FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
		}
		let filePath = (folder as NSString).appendingPathComponent("\(marketModel)_\(byLanguage)")
		return filePath
	}
	
	private func loadModelInfos() {
		let language = currentLanguageCode()
		let path = self.deviceModelInfosPath(byLanguage: language)
		if let dic = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [String: Any] {
			if let time = dic["updateTime"] as? String {
				self.updateTime = time
			}
			
			if let deviceTypeConfigs = dic["deviceTypeConfigs"] as? [DHOMSDeviceType] {
				self.types = deviceTypeConfigs
			}
		}
	}
	
	private func saveModelInfos() {
		let language = currentLanguageCode()
		let path = self.deviceModelInfosPath(byLanguage: language)
		let dic = ["updateTime": updateTime, "deviceTypeConfigs": types] as [String: Any]
	
		let result = NSKeyedArchiver.archiveRootObject(dic, toFile: path)
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Save models,result:\(result)")
	}
	
	private func loadIntroduction(byMarketModel marketModel: String) {
		let language = currentLanguageCode()
		let path = self.deviceIntroductionInfosPath(byLanguage: language, marketModel: marketModel)
		if let introduction = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? DHOMSIntroductionInfo {
			let parser = DHIntroductionParser(introduction: introduction)
			self.dicIntoductions[marketModel] = parser
		}
	}
	
	private func saveIntroduction(byMarketModel marketModel: String, introduction: DHOMSIntroductionInfo) {
		let language = currentLanguageCode()
		let path = self.deviceIntroductionInfosPath(byLanguage: language, marketModel: marketModel)
		let result = NSKeyedArchiver.archiveRootObject(introduction, toFile: path)
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Save models,result:\(result)")
	}
    
    
    // MARK: 添加设备结束log
    private func addDeviceEndLog() {
		
    }
}


extension DHOMSConfigManager {
	func currentLanguageCode() -> String {
		if let language = NSLocale.preferredLanguages.first {
			if language.hasPrefix("zh") {
				return language.contains("zh-Hant") ? "zh-TW" : "zh-CN"
			}
			
			return language
		}
		
		return ""
	}
}
