//
//  LCTableViewAdapter.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/20.
//  Copyright © 2022 Imou. All rights reserved.
//

import Foundation

class LCTableViewAdapter {
    
    var sectionsModel: [LCTableViewSectionModel] = [LCTableViewSectionModel]()
    
    var cellsModel: [[AnyObject]] = [[AnyObject]]()
    
    weak var tableview: UITableView?
    
    func numberOfSections() -> Int {
        return sectionsModel.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section < 0 || section >= cellsModel.count {
            return 0
        }
        return cellsModel[section].count
    }
    
    func modelForRowAtIndexPath(indexPath: IndexPath) -> AnyObject {
        if indexPath.section >= self.sectionsModel.count || indexPath.row >= self.cellsModel[indexPath.section].count {
            return LCTableViewCellModel(height: 0)
        }
        return self.cellsModel[indexPath.section][indexPath.row]
    }
    
    func modelForSection(section: NSInteger) -> LCTableViewSectionModel {
        if section >= self.sectionsModel.count {
            return LCTableViewSectionModel.init(title: "", height: 0)
        }
        
        return self.sectionsModel[section]
    }
    
    func classForCell() -> [String] {
        return ["UITableViewCell", "LCTableViewCell"]
    }
}

