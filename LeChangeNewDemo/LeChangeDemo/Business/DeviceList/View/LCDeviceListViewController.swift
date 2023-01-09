//
//  LCDeviceListViewController.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/24.
//  Copyright © 2022 Imou. All rights reserved.
//

import SnapKit
import LCBaseModule
import KVOController
import UIKit

@objcMembers class LCDeviceListViewController : LCBasicViewController {
    /// presenter
    lazy var presenter: LCDeviceListPresenter = {
        let p = LCDeviceListPresenter()
        p.listContainer = self
        return p
    }()
    /// 设备列表视图
    lazy var deviceListView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self.presenter
        tableView.delegate = self.presenter
        tableView.register(LCDeviceListCell.self, forCellReuseIdentifier: "LCDeviceListCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 0
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 15))
        tableView.lc_setEmyptImageName("common_pic_nodevice", andDescription: "device_manager_list_no_device".lc_T)
        let header = LCRefreshHeader.init {[weak self] in
            self?.presenter.refreshData()
        }
        tableView.mj_header = LCRefreshHeader.init {[weak self] in
            self?.presenter.refreshData()
        }
        tableView.mj_footer = LCRefreshFooter.init(refreshingBlock: { [weak self] in
            self?.presenter.loadMoreData()
        })
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.initSDKLog()
        self.presenter.initSDK()
        self.setupDeviceListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.deviceListView.mj_header?.beginRefreshing()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBarBackgroundColor(color: .white)
        self.lcCreatNavigationBar(with: LCNAVIGATION_STYLE_DEVICELIST) {[weak self] index in
            if index == 1 {
                self?.navigationController?.pushToAddDeviceScanPage()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupDeviceListView() {
        self.view.addSubview(self.deviceListView)
        self.deviceListView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(LC_bottomSafeMargin)
        })
    }

    deinit {
        
    }
    
}
