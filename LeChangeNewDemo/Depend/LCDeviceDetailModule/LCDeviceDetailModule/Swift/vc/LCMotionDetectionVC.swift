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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 84))
        view.backgroundColor = UIColor.lccolor_c8()
        
        let contentView = UIView(frame: CGRect(x: (self.view.frame.size.width - 250)/2.0, y: 17, width: 250, height: 50))
        contentView.backgroundColor = UIColor.lc_color(withHexString: "#E5E5E5")
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 15
        view.addSubview(contentView)
        
        let bt1 = UIButton(type: .custom)
        bt1.layer.masksToBounds = true
        bt1.layer.cornerRadius = 10
        bt1.backgroundColor = UIColor.lccolor_c0()
        bt1.setTitleColor(.lccolor_c41(), for: .normal)
        bt1.setTitleColor(.white, for: .selected)
        bt1.frame = CGRect(x: 5, y: 5, width: 120, height: 40)
        bt1.isSelected = true
        bt1.tag = 100
        bt1.setTitle("device_detail_camera_name_pt_lens".lc_T, for: .normal)
        bt1.titleLabel?.font = .systemFont(ofSize: 14)
        bt1.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
        let bt2 = UIButton(type: .custom)
        bt2.layer.masksToBounds = true
        bt2.layer.cornerRadius = 10
        bt2.backgroundColor = .clear
        bt2.setTitleColor(.lccolor_c41(), for: .normal)
        bt2.setTitleColor(.white, for: .selected)
        bt2.frame = CGRect(x: 125, y: 5, width: 120, height: 40)
        bt2.setTitle("device_detail_camera_name_fixed_lens".lc_T, for: .normal)
        bt2.titleLabel?.font = .systemFont(ofSize: 14)
        bt2.tag = 101
        bt2.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
        contentView.addSubview(bt1)
        contentView.addSubview(bt2)
        
        return view
    }()
    
    @objc func btnClick(btn: UIButton) {
        let selected = self.view.viewWithTag(btn.tag) as? UIButton
        if (selected?.isSelected == true) {
            return;
        }
        
        if btn.tag == 100 {
            let otherBtn = self.view.viewWithTag(101) as? UIButton
            btn.isSelected = true
            otherBtn?.isSelected = false
            btn.backgroundColor = .lccolor_c0()
            otherBtn?.backgroundColor = .clear
            self.presenter?.selectedChannelId = "0"
        }
        
        if btn.tag == 101 {
            let otherBtn = self.view.viewWithTag(100) as? UIButton
            btn.isSelected = true
            otherBtn?.isSelected = false
            btn.backgroundColor = .lccolor_c0()
            otherBtn?.backgroundColor = .clear
            self.presenter?.selectedChannelId = "1"
        }
        
        self.presenter?.updateMotionDetectionStatus()
    }
    
    deinit {
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "device_manager_defence_setting".lc_T
        
        self.setupTableView()
        if (self.presenter?.deviceInfo.multiFlag == true) {
            self.tableView.tableHeaderView = self.topView
        }
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
