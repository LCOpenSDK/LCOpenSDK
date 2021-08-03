//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

import UIKit

extension DHModuleConfig {
	
	/// 预加载的市场型号对应的引导信息，对应DHModuleConfig.plist中的PreloadIntroductionModels数组
	///
	/// - Returns: ["A46", "A35"...]
	func preloadIntroductionModels() -> [String] {
		
		if let loadModels = self.dicConfigs.object(forKey: "PreloadIntroductionModels") as? [Any] {
			return loadModels as! [String]
		}
		
		//默认返回值
		if (self.isLeChange) {
			return ["A46"]
		}
		
		return ["TP1", "TP5"]
	}
	
	/// 是否显示帮助电话
	func addDevice_showServiceCall() -> Bool {
		return false
	}
}
