//
//  LCDeviceAddItemModel.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/17.
//  Copyright © 2022 Imou. All rights reserved.
//

import Foundation
import ObjectMapper

// item model
public class LCDeviceAddItemModel: Mappable {
    
    open var communicate: String?                   // "配网方式，配网方式:lan,wifi, bluetooth"
    open var units: [LCDeviceAddUnitModel]?         // LCDeviceAddUnitModel数组
    open var defaultCommunicate: String?            // 默认配网模式
    open var productIcon: String?                   // 添加成功的设备图
    open var version: String?                       // 接口版本号，用于区分softAP自动连接流程处理
    
    required public init?(map: Map) {
        
    }
    
    public init() {
        
    }
    
    public func mapping(map: Map) {
        version            <- map["version"]
        productIcon        <- map["productIcon"]
        defaultCommunicate <- map["defaultCommunicate"]
        communicate        <- map["communicate"]
        units              <- map["units"]
    }
}
/// unit model
public class LCDeviceAddUnitModel: Mappable {
    open var order: Int?                        // "组件在整个配网流程中的顺序编号"
    open var steps: [LCDeviceAddStepModel]?     // [LCDeviceAddStepModel]
    open var identifier: String?                // "组件唯一标识符"
    open var name: String?
    open var type: Int?                         // [int]组件类型（0-引导组件，1-配网组件，2-平台注册组件，3-添加完成组件，4-新手引导组件"
    public required init?(map: Map) {
    }
    
    public init() {
        
    }
    public func mapping(map: Map) {
        order           <- map["order"]
        steps           <- map["steps"]
        identifier      <- map["identifier"]
        name            <- map["name"]
        type            <- map["type"]
    }
}
/// step model
public class LCDeviceAddStepModel: Mappable {
    
    open var id: Int?                    // 步骤id
    open var elementSeq: [String]?       // ["stepTitle","stepButton","stepOperate","stepIcon"]
    open var stepButton: [String]?       // ["button的文案"]
    open var stepIcon: [String]?         // ["icon url"]
    open var stepError: String?          // "连接失败提示内容"
    open var stepTitle: String?          // "该步骤标题"
    open var stepOperate: String?
    open var help: LCDeviceAddHelpModel?
    open var linkedFunctions: String?    // 新手引导ref
    open var isFallback: Int?            // 1是成功 0是失败
    open var scenes: [LCDeviceAddScenesModel]?                      // 使用场景
    
    public required init?(map: Map) {
    }
    
    public init() {
        
    }
    public func mapping(map: Map) {
        stepTitle       <- map["stepTitle"]
        stepError       <- map["stepError"]
        stepOperate     <- map["stepOperate"]
        elementSeq      <- map["elementSeq"]
        stepIcon        <- map["stepIcon"]
        stepButton      <- map["stepButton"]
        id              <- map["id"]
        help            <- map["help"]
        linkedFunctions <- map["linkedFunctions"]
        isFallback      <- map["isFallback"]
        scenes          <- map["scenes"]
    }
}
// help model
public class LCDeviceAddHelpModel: Mappable {
    open var helpTitle: String?          // "帮助标题"
    open var helpUrlTitle: String?       // "帮助链接名称"
    open var helpUrl: String?            // "帮助连接（h5链接）"
    open var helpH5Content: String?      // "帮助连接（h5链接）"
    public required init?(map: Map) {
    }
    
    public init() {
        
    }
    public func mapping(map: Map) {
        helpTitle       <- map["helpTitle"]
        helpUrlTitle    <- map["helpUrlTitle"]
        helpUrl         <- map["helpUrl"]
        helpH5Content   <- map["helpH5Content"]
    }
}
// scence model
public class LCDeviceAddScenesModel: Mappable {
    open var name: String?          // "帮助标题"
    open var icon: String?          // "帮助链接名称"
    open var key: String?           // "帮助连接（h5链接）"
    public required init?(map: Map) {
    }
    
    public init() {
        
    }
    public func mapping(map: Map) {
        name        <- map["name"]
        icon        <- map["icon"]
        key         <- map["key"]
    }
}
