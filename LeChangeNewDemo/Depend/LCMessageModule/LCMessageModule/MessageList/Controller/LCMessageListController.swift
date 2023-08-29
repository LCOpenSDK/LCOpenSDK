//
//  LCMessageListController.swift
//  LCMessageModule
//
//  Created by lei on 2022/10/10.
//

import UIKit
import LCNetworkModule
import LCBaseModule

class LCMessageListController: UIViewController {
    
    var presenter:ILCMessagePresenter!
    
    //MARK: - 初始化Func
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.presenter = LCMessageListPresenter.init(with: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.presenter = LCMessageListPresenter.init(with: self)
    }
    
    deinit {
//        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Life Style
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        initialData()
        self.messageListTav.mj_header?.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    //MARK: - Public Func
    public func configData(_ deviceInfo:LCDeviceInfo, index:Int) {
        guard index >= 0 && index < deviceInfo.channels.count else {
            return
        }
        self.presenter.deviceInfo = deviceInfo
        self.presenter.channelInfo = deviceInfo.channels[index]
    }
    
    //MARK: - Private Func
    private func setupUI() {
        self.view.backgroundColor = UIColor.lc_color(withHexString: "#FFFFFF")
        
        self.view.addSubview(navBar)
        self.view.addSubview(calendarView)
        self.view.addSubview(messageListTav)
        
        navBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(kStatusBarHeight)
            make.height.equalTo(44.0)
        }
        calendarView.snp.makeConstraints { make in
            make.leading.equalTo(15.0)
            make.top.equalTo(navBar.snp.bottom).offset(10.0)
            make.trailing.equalTo(-15.0)
            make.height.equalTo(114.0)
        }
        messageListTav.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(calendarView.snp.bottom)
            make.bottom.equalToSuperview().offset(-kBottomSafeHeight)
        }
        
        messageListTav.mj_header = LCMessageRefreshHeader.init(refreshingBlock: { [weak self] in
            self?.presenter.refreshMessageList()
        })
        
        messageListTav.mj_footer = LCMessageRefreshFooter.init(refreshingBlock: { [weak self] in
            self?.presenter.loadMoreMessageList()
        })
    }
    
    private func initialData() {
        if (self.presenter.deviceInfo.multiFlag) {
            navBar.configTitle(self.presenter.deviceInfo.name)
        } else {
            navBar.configTitle(self.presenter.channelInfo.channelName)
        }
    }
    
    private func retry() {
        self.messageListTav.mj_header?.beginRefreshing()
    }
    
    //MARK: - Lazy Var
    lazy var navBar:LCMessageNavBar = {
        let nav = LCMessageNavBar()
        nav.delegate = self
        return nav
    }()
    
    lazy var calendarView:MMMessageCalendarView = {
        let view = MMMessageCalendarView(frame: .zero)
        view.layer.cornerRadius = 10.0
        view.delegate = self
        return view
    }()
    
    lazy var messageListTav:UITableView = {
        let tav = UITableView(frame: .zero, style: .plain)
        tav.backgroundColor = UIColor.lc_color(withHexString: "#FFFFFF")
        tav.delegate = self
        tav.dataSource = self
        tav.separatorStyle = .none
        tav.showsHorizontalScrollIndicator  = false
        tav.showsVerticalScrollIndicator = false
        tav.register(LCMessageListCell.classForCoder(), forCellReuseIdentifier: LCMessageListCell.cellID())
        
        return tav
    }()
    
    lazy var emptyView:LCMessageTavEmptyView = {
        let view = LCMessageTavEmptyView()
        return view
    }()
    
    lazy var errorView:LCMessageTavErrorView = {
        let view = LCMessageTavErrorView()
        view.retryHandle = { [weak self] in
            self?.retry()
        }
        return view
    }()

}

//MARK: - ILCMessageListController
extension LCMessageListController:ILCMessageListController {
    
    func mainView() -> UIView? {
        return self.view
    }
    
    func mainVC() -> UIViewController? {
        return self
    }
    
    func reloadData() {
        endRefresh()
        
        emptyView.snp.removeConstraints()
        emptyView.removeFromSuperview()
        errorView.snp.removeConstraints()
        errorView.removeFromSuperview()
        
        self.messageListTav.reloadData()
    }
    
    func endRefresh() {
        self.messageListTav.mj_header?.endRefreshing()
        self.messageListTav.mj_footer?.endRefreshing()
    }
    
    func showNoMoreData() {
        self.messageListTav.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    func showEmptyView() {
        endRefresh()
        self.messageListTav.reloadData()
        guard !messageListTav.subviews.contains(emptyView) else {
            return
        }
        
        if messageListTav.subviews.contains(errorView) {
            errorView.snp.removeConstraints()
            errorView.removeFromSuperview()
        }
        
        messageListTav.addSubview(emptyView)
        emptyView.snp.remakeConstraints { make in
            make.leading.top.equalToSuperview()
            make.size.equalToSuperview()
        }
    }
    
    func showErrorView() {
        endRefresh()
        self.messageListTav.reloadData()
        guard !messageListTav.subviews.contains(errorView) else {
            return
        }
        
        if messageListTav.subviews.contains(emptyView) {
            emptyView.snp.removeConstraints()
            emptyView.removeFromSuperview()
        }
        
        messageListTav.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.size.equalToSuperview()
        }
        
    }
    
}

extension LCMessageListController: LCMessageNavBarDelegate {
    
    func callBack(_ navBar:LCMessageNavBar) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotoEdit(_ navBar:LCMessageNavBar) {
        if presenter.showMessageInfos.count > 0 {
            let editVC = LCMessageEditController()
            editVC.configData(presenter.deviceInfo, presenter.channelInfo, messageInfos: presenter.showMessageInfos)
            self.navigationController?.pushViewController(editVC, animated: true)
        } else {
            LCProgressHUD.showMsg("no_message".lc_T, in: self.view)
        }
    }
}

extension LCMessageListController: MMMessageCalendarViewDelegate {
    func messageCalendarViewChangeClick(_ messageCalendarView: MMMessageCalendarView!, withResult selectIndex: String!) {
        let selectedDate = NSDate.lcMessage_date(from: messageCalendarView.dateStr, format: "yyyy-MM-dd")
        let currentDateStr = NSDate.lc_string(of: Date(), format: "yyyy-MM-dd")
        self.presenter.currentDate = selectedDate
        if (self.presenter.messageInfosDic[presenter.currentDateStr]?.count ?? 0) == 0 || messageCalendarView.dateStr == currentDateStr {
            self.messageListTav.mj_header?.beginRefreshing()
        }else {
            self.reloadData()
        }
    }
    
    func messageTypeBtnclick(_ messageCalendarView: MMMessageCalendarView!, button typeSeleceBtn: UIButton!) {
        //
    }
    
    
}
