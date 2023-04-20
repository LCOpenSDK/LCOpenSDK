//
//  LCMotionDetectionViewController.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/28.
//  Copyright © 2022 Imou. All rights reserved.
//

import LCBaseModule
import SnapKit

@objcMembers public class LCMotionDetectionVC: LCBasicViewController {
    public var presenter: LCMotionDetectionPresenter?
    public var tableView: UITableView = UITableView.init(frame: .zero, style: .grouped)
    
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 83))
        view.backgroundColor = UIColor.lccolor_c8()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        label.text = "device_manager_defence_setting".lc_T
        return label
    }()
    
    deinit {
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
        }
        
        self.setupTableView()
        self.tableView.tableHeaderView = self.topView
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.presenter?.updateMotionDetectionStatus()
        self.lcCreatNavigationBar(with: LCNAVIGATION_STYLE_DEFAULT, buttonClick: nil)
    }
    
    func setupTableView() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(LCTableViewCell.self, forCellReuseIdentifier: "LCTableViewCell")
        tableView.register(LCSubImageTableViewCell.self, forCellReuseIdentifier: "LCSubImageTableViewCell")
        tableView.register(LCLocalStorageTableViewCell.self, forCellReuseIdentifier: "LCLocalStorageTableViewCell")
        tableView.register(LCSwitchTableViewCell.self, forCellReuseIdentifier: "LCSwitchTableViewCell")
        tableView.register(LCTableViewSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "LCTableViewSectionHeaderView")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension LCMotionDetectionVC: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter?.adapter.numberOfSections() ?? 0;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.adapter.numberOfRowsInSection(section: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.presenter?.adapter.modelForRowAtIndexPath(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel?.reuseIdentifier ?? "", for: indexPath)
        cell.selectionStyle = .none
        (cell as? UITableViewCellProtocol)?.updateCellModel(model: cellModel)
        return cell
    }
}

extension LCMotionDetectionVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = self.presenter?.adapter.modelForRowAtIndexPath(indexPath: indexPath)
        return cellModel?.height ?? 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: LCTableViewSectionHeaderView? = tableView.dequeueReusableHeaderFooterView(withIdentifier:  "LCTableViewSectionHeaderView") as? LCTableViewSectionHeaderView
        view?.model = self.presenter?.adapter.sectionsModel[section]
        view?.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: view?.model?.height ?? 0)
        if view?.model?.title == nil || view?.model?.title?.length == 0 {
            return nil
        }
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = self.presenter?.adapter.sectionsModel[section].height ?? 0
        return height
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.presenter?.adapter.cellsModel[indexPath.section][indexPath.row]
        if let action = model?.selectAction {
            action()
        }
    }
}
