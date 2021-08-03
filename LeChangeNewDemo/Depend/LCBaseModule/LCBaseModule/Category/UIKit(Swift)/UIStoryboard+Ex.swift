//
//  Copyright © 2018 dahua. All rights reserved.
//

public extension UIStoryboard {
	
    static func dh_vc(storyboardName: String, vcIdentifier: String, bundle: Bundle? = nil) -> UIViewController {
		
		let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
		
		return storyboard.instantiateViewController(withIdentifier: vcIdentifier)
	}
	
}
