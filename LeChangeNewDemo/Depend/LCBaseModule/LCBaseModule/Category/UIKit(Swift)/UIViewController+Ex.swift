//
//  Copyright © 2017 dahua. All rights reserved.
//

import UIKit

public extension UIViewController {

    /// 是否可见，当处于导航栈顶时可见
	@objc var dh_isVisible: Bool {
    
        if let viewController = self.navigationController?.dh_topViewController {
            if viewController == self ||
			   viewController == self.parent {
                return true
            }
        }
        
        return false
    }
    
    /// 获取Storyboard的VC
	@objc static func dh_storyboardVC(_ storyboardName: String, vcName: String) -> UIViewController? {
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        
        return storyBoard.instantiateViewController(withIdentifier: vcName)
    }
	
	
	/// 跳转到自己
	@objc func dh_popToSelf() {
		navigationController?.popToViewController(self, animated: true)
	}
	
	/// 隐藏导航栏
	///
	/// - Parameter animated: 是否显示动画
	@objc func dh_hideNavigationBar(animated: Bool) {
		
        if dh_isVisible,
            let vc = self as? DHBaseViewController {
            vc.navigationBarHidden = true
           
        }
	}
	
	/// 显示导航栏
	///
	/// - Parameter animated: 是否显示动画
	@objc func dh_recoverNavigationBar(animated: Bool) {
		
		if navigationController?.navigationBar.isHidden ?? true,
			let nextVc = self.navigationController?.viewControllers.last {
			
			if nextVc.isKind(of: DHBaseViewController.self) {
				guard let nextVc = nextVc as? DHBaseViewController else {
					return
				}
				
				if nextVc.navigationBarHidden {
					return
				}
				
			} else if nextVc.isKind(of: DHBaseTableViewController.self) {
				
				guard let nextVc = nextVc as? DHBaseTableViewController else {
					return
				}
				
				if nextVc.navigationBarHidden {
					return
				}
			} else {
				return
			}
			
			navigationController?.setNavigationBarHidden(false, animated: animated)
		}
	}
    
    func dh_dismissToRootVC() {
        var rootVC = self.presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        rootVC?.dismiss(animated: true, completion: nil)
    }
}
