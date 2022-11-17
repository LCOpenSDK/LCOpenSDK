//
//  Copyright © 2018 Imou. All rights reserved.
//

import Foundation


protocol ILCWiFiConfigPresenter {
    //关联容器
    func setContainer(container: ILCWiFiConfigContainer)
    //加载wifi列表
    func loadWiFiList()
    //前往连接Wifi
    func connectWifi(indexPath: IndexPath)
    // 前往连接隐藏Wifi
    func connectHideWifi()
    // 前往5g 说明
    func  explain5GInfo()
    // 前往wifi 说明
    func explainWifiInfo()
    //是否已经配置过wifi
    func hasConfigedWifi() -> Bool
    
    //返回组个数
    func sectionNumber() -> Int
    //返回cell个数
    func numberOfRowsInSection(section: Int) -> Int
    //配置cell
    func configCell(cell: UITableViewCell, indexPath: IndexPath)
    //界面刷新
    func refresh()
}


protocol ILCWiFiConfigContainer: class {
    // MARK: 补充协议
    func refreshEnable(isEnable: Bool)
    
    func navigationVC() -> UINavigationController?
    func mainView() -> UIView
    func mainController() -> UIViewController
    func table() -> UITableView
}
