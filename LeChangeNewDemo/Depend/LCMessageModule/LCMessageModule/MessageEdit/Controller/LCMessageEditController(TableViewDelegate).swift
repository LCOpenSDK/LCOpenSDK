//
//  LCMessageEditController(TableViewDelegate).swift
//  LCMessageModule
//
//  Created by lei on 2022/10/14.
//

import Foundation
import LCBaseModule

extension LCMessageEditController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.messageInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LCMessageEditCell.cellID(), for: indexPath) as! LCMessageEditCell
        if indexPath.row < self.presenter.messageInfos.count {
            let messageInfo = self.presenter.messageInfos[indexPath.row]
            let messageItem = LCMessageItem(messageInfo, deviceId: presenter.deviceInfo.deviceId, productId: presenter.deviceInfo.productId, playtoken: presenter.deviceInfo.playToken)
            messageItem.isSelected = presenter.selectedAlarmIds.contains(messageInfo.alarmId)
            cell.updateData(messageItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < presenter.messageInfos.count else {
            return
        }
        let messageInfo = presenter.messageInfos[indexPath.row]
        if presenter.selectedAlarmIds.contains(messageInfo.alarmId) {
            //取消选中
            presenter.selectedAlarmIds.removeAll(where: {$0 == messageInfo.alarmId})
        }else {
            presenter.selectedAlarmIds.append(messageInfo.alarmId)
        }
        self.reloadData()
        self.deleteBtn.lc_enable = presenter.selectedAlarmIds.count > 0
    }
}
