//
//  Copyright © 2017 dahua. All rights reserved.
//


import UIKit

public extension CALayer {
    
    var dh_width: CGFloat {
        get {
            return self.frame.width
        }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var dh_height: CGFloat {
        get {
            return self.frame.height
        }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var dh_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var dh_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var dh_size: CGSize {
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    /// 删除所有子图层
    func lc_removeAllSublayer() {
        if let sublayers = self.sublayers {
            
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
}
