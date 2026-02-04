//
//  LCBluetoothSearchViewController.swift
//  LCAddDeviceModule
//
//  Created on 2026/1/22.
//  Copyright © 2026 Imou. All rights reserved.
//

import UIKit
import LCBaseModule
import SnapKit

class LCBluetoothSearchViewController: LCAddBaseViewController, LCBluetoothSearchContainerProtocol {
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_title".lc_T()
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var searchStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    // 搜索中状态组件
    private lazy var searchIndicator: UIImageView = {
        let imageView = UIImageView()
        // 使用加载动画图片（对应.add_icon_loading.png）
        imageView.image = UIImage(named: "bluetooth_loading")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var searchStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_searching".lc_T
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var searchTipLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_search_tip".lc_T
        label.textColor = UIColor.lc_color(withHexString: "#8F8F8F")
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // 超时状态组件
    private lazy var timeoutIconImageView: UIImageView = {
        let imageView = UIImageView()
        // 使用系统图标创建红色感叹号，如果没有切图的话
        imageView.image = UIImage(named: "adddevice_img_searching_none")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var timeoutStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_no_device_found".lc_T
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private lazy var timeoutSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_manual_add".lc_T
        label.textColor = UIColor.lc_color(withHexString: "#8F8F8F")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add_icon_refresh"), for: .normal)
        button.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var faqButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add_btn_list_faq"), for: .normal)
        button.addTarget(self, action: #selector(faqButtonClicked), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.lc_color(withHexString: "#FFFFFF")
        table.separatorStyle = .none
        table.layer.cornerRadius = 15
        table.layer.masksToBounds = true
        table.register(LCBluetoothDeviceCell.self, forCellReuseIdentifier: "LCBluetoothDeviceCell")
        return table
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("common_next".lc_T, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.lc_color(withHexString: "#F18D00")
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lc_color(withHexString: "#F6F6F6")
        view.isHidden = true
        
        let imageView = UIImageView()
        // 使用空值图
        imageView.image = UIImage(named: "bluetooth_searching_none")
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(130)
            make.size.equalTo(CGSize(width: 125, height: 125))
        }
        
        let label = UILabel()
        label.text = "add_device_bluetooth_no_device_retry".lc_T
        label.textColor = UIColor.lc_color(withHexString: "#8F8F8F")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 添加点击手势，点击重试
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(emptyViewTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    // MARK: - Properties
    private var presenter: LCBluetoothSearchPresenter?
    
    // MARK: - Toast and Sheet
    private var toastView: LCBluetoothToastView?
    private var permissionSheetView: LCBluetoothPermissionSheetView?
    private var faqSheetView: LCBluetoothFAQSheetView?
    
    // MARK: - Constraint
    private var searchStatusViewTopConstraint: Constraint?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置导航栏背景色
        self.navigationController?.navigationBar.setBarBackgroundColor(color: UIColor.lc_color(withHexString: "#F6F6F6"))
        
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    // MARK: - Setup
    private func setupPresenter() {
        let presenter = LCBluetoothSearchPresenter(container: self)
        self.presenter = presenter
        presenter.setup()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // 隐藏导航栏标题
        self.title = ""
        
        // 设置页面背景色
        view.backgroundColor = UIColor.lc_color(withHexString: "#F6F6F6")
        
        view.addSubview(titleLabel)
        view.addSubview(searchStatusView)
        searchStatusView.addSubview(searchIndicator)
        searchStatusView.addSubview(searchStatusLabel)
        searchStatusView.addSubview(searchTipLabel)
        searchStatusView.addSubview(timeoutIconImageView)
        searchStatusView.addSubview(timeoutStatusLabel)
        searchStatusView.addSubview(timeoutSubtitleLabel)
        searchStatusView.addSubview(refreshButton)
        searchStatusView.addSubview(faqButton)
        view.addSubview(tableView)
        view.addSubview(nextButton)
        view.addSubview(emptyView)
        
        // Toast会在需要时动态添加
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        // searchStatusView的top约束需要动态调整，当Toast显示时，应该相对于Toast，否则相对于titleLabel
        var topConstraint: Constraint?
        searchStatusView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            topConstraint = make.top.equalTo(titleLabel.snp.bottom).offset(20).constraint
            make.height.equalTo(80)
        }
        searchStatusViewTopConstraint = topConstraint
        
        searchIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        searchStatusLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchIndicator.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(20)
        }
        
        searchTipLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchStatusLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(searchStatusLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 超时状态组件约束
        // 警告图标在左侧，与主标题水平对齐
        timeoutIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        // 主标题：与警告图标水平对齐，在警告图标右侧
        timeoutStatusLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeoutIconImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(20)
            make.trailing.lessThanOrEqualTo(refreshButton.snp.leading).offset(-12)
        }
        
        // 副标题：在主标题下方，向右略微缩进
        timeoutSubtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeoutStatusLabel)
            make.top.equalTo(timeoutStatusLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualTo(faqButton.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 刷新图标：在右侧，与主标题水平对齐
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        // FAQ问号图标：在副标题右侧，与副标题水平对齐
        faqButton.snp.makeConstraints { make in
            make.leading.equalTo(timeoutSubtitleLabel.snp.trailing).offset(4)
            make.centerY.equalTo(timeoutSubtitleLabel)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(searchStatusView.snp.bottom).offset(12)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-(20 + LC_bottomSafeMargin))
            make.height.equalTo(45)
        }
        
        emptyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchStatusView.snp.bottom)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
    }
    
    // MARK: - LCAddBaseVCProtocol
    override func leftActionType() -> LCAddBaseLeftAction {
        return .quit
    }
    
    override func isLeftActionShowAlert() -> Bool {
        return true
    }
    
    // MARK: - Actions
    @objc private func emptyViewTapped() {
        // 点击空值图，重新开始搜索
        presenter?.startBluetoothSearch()
    }
    
    @objc private func refreshButtonClicked() {
        // 点击刷新按钮，重新开始搜索
        presenter?.refreshSearch()
    }
    
    @objc private func faqButtonClicked() {
        // 点击FAQ按钮，显示帮助弹窗
        presenter?.handleFAQButtonClicked()
    }
    
    @objc private func nextButtonClicked() {
        presenter?.handleNextButtonClicked()
    }
    
    @objc private func onToastTapped() {
        presenter?.handleToastTapped()
    }
    
    // MARK: - LCBluetoothSearchContainerProtocol Implementation
    func updateDeviceList() {
        tableView.reloadData()
    }
    
    func updateSearchStatusViewToSearching() {
        // 显示搜索中状态
        searchIndicator.isHidden = false
        searchStatusLabel.isHidden = false
        searchTipLabel.isHidden = false
        // 隐藏超时状态
        timeoutIconImageView.isHidden = true
        timeoutStatusLabel.isHidden = true
        timeoutSubtitleLabel.isHidden = true
        refreshButton.isHidden = true
        faqButton.isHidden = true
    }
    
    func updateSearchStatusViewToTimeout() {
        // 隐藏搜索中状态
        searchIndicator.isHidden = true
        searchStatusLabel.isHidden = true
        searchTipLabel.isHidden = true
        // 显示超时状态
        timeoutIconImageView.isHidden = false
        timeoutStatusLabel.isHidden = false
        timeoutSubtitleLabel.isHidden = false
        refreshButton.isHidden = false
        faqButton.isHidden = false
    }
    
    func showEmptyView(_ show: Bool) {
        emptyView.isHidden = !show
    }
    
    func showTableView(_ show: Bool) {
        tableView.isHidden = !show
    }
    
    func updateNextButtonState(enabled: Bool) {
        nextButton.isEnabled = enabled
        nextButton.backgroundColor = UIColor.lc_color(withHexString: "#F18D00")
        nextButton.alpha = enabled ? 1.0 : 0.6
    }
    
    func startLoadingAnimation() {
        // 使用缩放动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSNumber(value: 1.1)
        scaleAnimation.toValue = NSNumber(value: 0.8)
        scaleAnimation.duration = 0.6
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = Float.greatestFiniteMagnitude
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        searchIndicator.layer.add(scaleAnimation, forKey: "scaleAnimation")
    }
    
    func stopLoadingAnimation() {
        searchIndicator.layer.removeAnimation(forKey: "scaleAnimation")
    }
    
    func showToast() {
        // 如果Toast已显示，不重复显示
        if toastView != nil && toastView?.superview != nil {
            return
        }
        
        let toast = LCBluetoothToastView()
        toast.tapAction = { [weak self] in
            self?.onToastTapped()
        }
        toast.show(in: view, below: titleLabel, offset: 20)
        toastView = toast
        
        // 确保Toast已经添加到视图层级后再更新约束
        view.layoutIfNeeded()
        
        // 更新searchStatusView的约束，使其相对于Toast
        searchStatusViewTopConstraint?.deactivate()
        searchStatusView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            searchStatusViewTopConstraint = make.top.equalTo(toast.snp.bottom).offset(20).constraint
            make.height.equalTo(80)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideToast() {
        guard let toast = toastView else { return }
        toast.hide()
        toastView = nil
        
        // 恢复searchStatusView的约束，使其相对于titleLabel
        searchStatusViewTopConstraint?.deactivate()
        searchStatusView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            searchStatusViewTopConstraint = make.top.equalTo(titleLabel.snp.bottom).offset(20).constraint
            make.height.equalTo(80)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showPermissionSheet(hasPermission: Bool, isBluetoothPoweredOn: Bool, setupAction: @escaping () -> Void) {
        let sheet = LCBluetoothPermissionSheetView()
        sheet.hasPermission = hasPermission
        sheet.isBluetoothPoweredOn = isBluetoothPoweredOn
        sheet.setupAction = setupAction
        sheet.dismissAction = { [weak self] in
            self?.permissionSheetView = nil
        }
        sheet.show(in: view)
        permissionSheetView = sheet
    }
    
    func showFAQSheet() {
        let sheet = LCBluetoothFAQSheetView()
        sheet.dismissAction = { [weak self] in
            self?.faqSheetView = nil
        }
        sheet.show(in: view)
        faqSheetView = sheet
    }
    
    func showErrorMessage(_ message: String) {
        LCProgressHUD.showMsg(message)
    }
    
    func navigateToWifiPassword(device: LCBluetoothDeviceModel) {
        // 跳转到WiFi密码输入页面
        let wifiPasswordVC = LCWifiPasswordViewController.storyboardInstance()
        let presenter = LCWifiPasswordPresenter(container: wifiPasswordVC)
        wifiPasswordVC.setup(presenter: presenter)
        navigationController?.pushViewController(wifiPasswordVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension LCBluetoothSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.devices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LCBluetoothDeviceCell", for: indexPath) as! LCBluetoothDeviceCell
        if let devices = presenter?.devices, indexPath.row < devices.count {
            let device = devices[indexPath.row]
            cell.deviceModel = device
            // 确保UI更新
            cell.updateUI()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LCBluetoothSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let devices = presenter?.devices, indexPath.row < devices.count else { return }
        
        let device = devices[indexPath.row]
        
        // 单选逻辑：如果点击的不是已选中的设备，则选中该设备
        if !device.isSelected {
            presenter?.selectDevice(device)
        }
        // 如果点击的是已选中的设备，保持选中状态（不取消选中）
    }
}
