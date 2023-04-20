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
}

extension UIImage {
	convenience init?(lc_bundle bundle: Bundle? = Bundle.lc_addDeviceBundle(), lc_named named: String) {
        if #available(iOS 13, *) {
            self.init(named: named, in: bundle, with: nil)
        } else {
            self.init(named: named, in: bundle, compatibleWith: nil)
        }
	}
}


extension String {
    func lc_T() -> String {
        let bundle: Bundle = Bundle.lc_addDeviceBundle() ?? Bundle.main
        guard let path = bundle.path(forResource: currentLanguageCode(), ofType: ".lproj") else { return self }
        let str = Bundle(path: path)?.localizedString(forKey: self, value: nil, table: nil) ?? self
        return str
    }
    
    private func currentLanguageCode() -> String {
        let cCode = Locale.preferredLanguages.first
        if cCode?.hasPrefix("zh") == true {
            return "zh-Hans"
        }
        return "en"
    }
}

