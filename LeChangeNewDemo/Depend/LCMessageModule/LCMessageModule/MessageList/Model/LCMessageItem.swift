//
//  LCMessageItem.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/12.
//

import UIKit
import LCNetworkModule

class LCMessageItem: NSObject {
    
    var title:String?
    
    var timeStr:String?
    
    var deviceId:String?
    
    var productId:String?
    
    var thumbUrl:String?
    
    //cell是否被选中(编辑页使用)
    var isSelected:Bool = false
    
    init(_ messageInfo:LCMessageInfo, deviceId:String, productId:String?) {
        super.init()
        self.deviceId = deviceId
        self.productId = productId
        let msgType:String? = messageInfo.msgType
        self.title = (msgType?.count ?? 0) > 0 ? msgType : "message_module_other".lcMessage_T
        self.thumbUrl = messageInfo.thumbUrl
        self.timeStr = transformTimeStr(messageInfo.localDate)
    }
    
    func transformTimeStr(_ localDate:String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: localDate)
//        let date = NSDate.init(timeIntervalSince1970: timeInter)
//        let timeStr = NSDate.lc_string(ofTimeInterval: timeInter, format: "HH:mm:ss")
        let timeStr = (date as? NSDate)?.string(withFormat: "HH:mm:ss")
        return timeStr
    }

}