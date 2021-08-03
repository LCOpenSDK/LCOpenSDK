//
//  Copyright © 2018年 dahua. All rights reserved.
//

import Foundation
import UIKit

protocol IDHAddByQRCodeView: AnyObject {
    var presenter: IDHAddByQRCodePresenter? {
        get set
    }
}

protocol IDHAddByQRCodePresenter: AnyObject {
    var qrCodeContent: String? {
        get
    }
    
    var container: (IDHAddByQRCodeView & UIViewController)? {
        get set
    }
    
    func goNext()
}
