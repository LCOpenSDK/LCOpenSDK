//
//  Copyright © 2020 jm. All rights reserved.
//

import Foundation

// MARK: - protocol IDHTableViewCell
public protocol IDHTableViewCell {
    static func dh_cellID() -> String
}

public extension IDHTableViewCell {
    static func dh_cellID() -> String {
        return String(describing: Self.self)
    }
}

public enum DHDeviceCellType: String {
    case normal = "normal"     //左边有titile    右边有content  有arrow
    case switch_ = "switch"    //左边有titile    右边有switch
    case image = "image"      //左边有titile    右边有image    有arrow
    case copy = "copy"         //左右有titile  右边有content和复制按钮
    case mark = "mark"         //左边title,右边图片
    case check = "check"       //左边title, 右边对勾
    case dynamic = "dynamic"
}

public enum DHDeviceStateType: String {
    case normal = "normal"     //左边有titile    右边有content  有arrow
    case loading = "loading"    //左边有titile    右边有switch
    case loadFail = "loadFail"      //左边有titile    右边有image    有arrow
}

public enum DHDeviceCellState: String {
    case loading = "loading"
    case loadfail = "loadfail"
    case normal = "normal"
    case noAuth = "noAuth"      //无权限
    case disable = "disable"
}

// MARK: - protocol IDHDeviceDetailItem
public protocol IDHDeviceDetailItem: class {
    //索引
    var keyId: String {get set}
    var itemIndex: Int {get set}
    
    //常用属性
    var itemName: String {get set}           //左侧标题名称
    var contentStr: String {get set}         //右侧内容
    var cellType: DHDeviceCellType {get set} //cell类型
    var isSwitchOn: Bool {get set}            //cell类型为switch时的开关状态
    var imageItem: IDHImageItem {get set}    //cell类型为Image时的图片状态
    var state: DHDeviceStateType {get set}  //cell的状态  正常 加载中 加载失败
    var isContentDiable: Bool {get set}      //右侧内容是否置灰
    var isEnable: Bool {get set}             //cell是否可响应点击
    var imageName: String {get set}          //本地图片名称
    
    
    //不常用的属性
    var isShowArrow: Bool {get set}  //右箭头一直显示 默认false
    var desString: String {get set}  //cell下方的文字描述
    var showRedDot: Bool {get set}   //红点展示
}

//用于图片描述
public protocol IDHImageItem: class {
    var imageUrl: String {get set}
    var placeHolder: String {get set}
    var encryPtKey: String {get set}
    var deviceId: String {get set}
    var devicePwd: String {get set}
    var filePath: String {get set}
    var isUseFilePath: Bool {get set}  //false 表示使用imageUrl true 表示使用filePath
}
