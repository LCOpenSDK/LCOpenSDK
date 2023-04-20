//
//  Copyright © 2018 Imou. All rights reserved.
//

public extension UIStoryboard {
	
    static func lc_vc(storyboardName: String, vcIdentifier: String, bundle: Bundle? = nil) -> UIViewController {
		
		let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
		
		return storyboard.instantiateViewController(withIdentifier: vcIdentifier)
	}
	
}
