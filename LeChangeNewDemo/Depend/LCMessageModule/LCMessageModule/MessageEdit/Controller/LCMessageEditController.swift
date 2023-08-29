//
//  LCMessageEditController.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/14.
//

import UIKit
import LCNetworkModule
import LCBaseModule

class LCMessageEditController: UIViewController {
    
    var presenter:ILCMessageEditPresenter!
    
    //MARK: - 初始化Func
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.presenter = LCMessageEditPresenter(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.presenter = LCMessageEditPresenter(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Life Style
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lc_color(withHexString: "#FFFFFF")
        setupUI()
        initialData()
    }
    
    //MARK: - Public Func
    public func configData(_ deviceInfo:LCDeviceInfo, _ channel:LCChannelInfo, messageInfos:[LCMessageInfo]) {
        self.presenter.deviceInfo = deviceInfo
        self.presenter.channelInfo = channel
        self.presenter.messageInfos = messageInfos
    }
    
    //MARK: - Private Func
    private func setupUI() {
        self.view.addSubview(navBar)
        self.view.addSubview(messageEditTav)
        self.view.addSubview(deleteBtn)
        
        navBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(kStatusBarHeight)
            make.height.equalTo(44.0)
        }
        messageEditTav.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(10.0)
            make.bottom.equalTo(deleteBtn.snp.top).offset(-5.0)
        }
        deleteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-32.0 - kBottomSafeHeight)
            make.size.equalTo(CGSize(width: 300.0, height: 45.0))
        }
    }
    
    private func initialData() {
        navBar.configTitle(presenter.channelInfo.channelName)
    }
    
    //MARK: - @objc func
    @objc func deleteClick() {
        LCAlertView.lc_ShowAlert(title: "message_module_delete_message_tip".lcMessage_T, detail: "message_module_delete_message_confirm".lcMessage_T, confirmString: "mobile_common_delete".lcMessage_T, cancelString: "message_module_cancel".lcMessage_T) { isConfirmSelected in
            if isConfirmSelected {
                self.presenter.deleteMessageAlarms()
            }
        }
    }
    
    //MARK: - Lazy Var
    lazy var navBar:LCMessageEditNavBar = {
        let bar = LCMessageEditNavBar()
        bar.delegate = self
        return bar
    }()
    
    lazy var messageEditTav:UITableView = {
        let tav = UITableView(frame: .zero, style: .plain)
        tav.delegate = self
        tav.dataSource = self
        tav.separatorStyle = .none
        tav.showsHorizontalScrollIndicator  = false
        tav.showsVerticalScrollIndicator = false
        tav.register(LCMessageEditCell.classForCoder(), forCellReuseIdentifier: LCMessageEditCell.cellID())
        
        return tav
    }()
    
    lazy var deleteBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.lc_color(withHexString: "#f18d00")
        btn.setTitle("mobile_common_delete".lcMessage_T, for: .normal)
        btn.layer.cornerRadius = 22.5
        btn.clipsToBounds = true
        btn.lc_enable = false
        btn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
        return btn
    }()

}

extension LCMessageEditController:ILCMessageEditController {
    
    func mainView() -> UIView {
        return self.view
    }
    
    func mainVC() -> UIViewController {
        return self
    }
    
    func reloadData() {
        self.navBar.updateSelectedAll(selectedAll: self.presenter.messageInfos.count == self.presenter.selectedAlarmIds.count)
        self.messageEditTav.reloadData()
    }
    
}

extension LCMessageEditController:LCMessageEditNavBarDelegate {
    
    func selectAll(_ navBar:LCMessageEditNavBar) {
        
        if presenter.selectedAlarmIds.count == presenter.messageInfos.count {
            presenter.selectedAlarmIds.removeAll()
        } else {
            presenter.selectedAlarmIds = presenter.messageInfos.map({$0.alarmId})
        }
        self.reloadData()
        self.deleteBtn.lc_enable = presenter.selectedAlarmIds.count > 0
    }
    
    func dismiss(_ navBar:LCMessageEditNavBar) {
        self.navigationController?.popViewController(animated: true)
    }
}
