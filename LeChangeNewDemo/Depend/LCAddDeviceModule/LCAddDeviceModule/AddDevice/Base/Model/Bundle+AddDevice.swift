//
//  Copyright © 2020 Imou. All rights reserved.
//

import Foundation

extension Bundle {
	
	static var bundle: Bundle? = nil
	
    class func lc_addDeviceBundle() -> Bundle? {

		if self.bundle == nil, let path = Bundle(for: LCAddDeviceModule.classForCoder()).path(forResource: "LCAddDeviceModuleBundle", ofType: "bundle") {
			self.bundle = Bundle(path: path)
		}
		
		return self.bundle
	}
	
    
    
    // 获取app当前版本
    class func appVersion() -> String {
        var versionString = ""
        guard let dict = main.infoDictionary else {
            return versionString
        }
        
        if  dict["CFBundleShortVersionString"] is String {
            versionString = dict["CFBundleShortVersionString"] as! String
        }
        
        return versionString
    }
}

// MARK: UIImage扩展，内部使用。
extension UIImage {
	
	/// 加载当前Bundle的图片
	///
	/// - Parameter named: 图片名称
	convenience init?(lc_bundle bundle: Bundle? = Bundle.lc_addDeviceBundle(), lc_named named: String) {
		self.init(named: named, in: bundle, compatibleWith: nil)
	}
}
