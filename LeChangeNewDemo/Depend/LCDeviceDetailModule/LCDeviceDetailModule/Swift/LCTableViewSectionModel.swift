//
//  LCTableViewSectionModel.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/22.
//  Copyright © 2022 Imou. All rights reserved.
//

import Foundation

public class LCTableViewSectionModel: NSObject {
    var title: String?
    var height: CGFloat = 0
    
    init(title: String?, height: CGFloat = 35.0) {
        super.init()
        
        self.title = title
        self.height = height
    }
}
