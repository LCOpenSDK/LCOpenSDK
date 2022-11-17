//
//  Copyright © 2018年 Imou. All rights reserved.
//

import Foundation
import UIKit

protocol ILCAddByQRCodeView: AnyObject {
    var presenter: ILCAddByQRCodePresenter? {
        get set
    }
}

protocol ILCAddByQRCodePresenter: AnyObject {
    var qrCodeContent: String? {
        get
    }
    
    var container: (ILCAddByQRCodeView & UIViewController)? {
        get set
    }
    
    func goNext()
}
