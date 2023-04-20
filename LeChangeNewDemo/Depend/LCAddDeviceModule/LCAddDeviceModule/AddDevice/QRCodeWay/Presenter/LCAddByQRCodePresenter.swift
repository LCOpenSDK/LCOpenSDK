//
//  Copyright © 2018年 Imou. All rights reserved.
//

import Foundation
import UIKit

class LCAddByQRCodePresenter: NSObject, ILCAddByQRCodePresenter {

    var qrCodeContent: String? {
        get {
            let sn: NSString = LCAddDeviceManager.sharedInstance.deviceId as NSString
            let randomNum = Int(arc4random_uniform(89_999_999) + 10_000_000) //八位随机数
            let nonce: NSString = "\(randomNum)" as NSString
            let ssid: NSString = LCAddDeviceManager.sharedInstance.wifiSSID! as NSString
            let pwd: NSString = LCAddDeviceManager.sharedInstance.wifiPassword! as NSString
            let iv: NSString = "0000000000000000"
            
            let strToEncypt: NSString = "\(nonce),\(ssid),\(pwd)" as NSString
            let MD5Data = sn.lc_MD5Data()
            let nonceData = nonce.data(using: String.Encoding.utf8.rawValue)
            let mutableData: NSMutableData = NSMutableData()
            mutableData.append(nonceData!)
            mutableData.append(MD5Data!)
            
            let sha265Data = (mutableData as NSData).lc_SHA256()
            let keyData = (sha265Data! as NSData).reverse()
            let ivData = iv.data(using: String.Encoding.utf8.rawValue)
            let srcData = strToEncypt.data(using: String.Encoding.utf8.rawValue)
            let desData = (srcData! as NSData).aes256CBCOperation(CCOperation(kCCEncrypt), keyData: keyData, ivData: ivData)
            let base64 = desData?.base64EncodedString()
            let result = (nonce as String) + base64!
            return result
        }
    }
    
    weak var container: (UIViewController & ILCAddByQRCodeView)?
    
    
    func goNext() {
        let controller = LCWifiConnectViewController.storyboardInstance()
        controller.showPlayAudio = false
        self.container?.navigationController?.pushViewController(controller, animated: true)
    }
    
}
