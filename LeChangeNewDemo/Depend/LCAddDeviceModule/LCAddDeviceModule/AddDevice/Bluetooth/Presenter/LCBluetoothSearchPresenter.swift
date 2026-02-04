//
//  LCBluetoothSearchPresenter.swift
//  LCAddDeviceModule
//
//  Created on 2026/1/26.
//  Copyright © 2026 Imou. All rights reserved.
//

import UIKit
import LCBaseModule
import CoreBluetooth
import LCOpenSDKDynamic

/// 蓝牙搜索容器(UIViewController)需要实现的协议
protocol LCBluetoothSearchContainerProtocol: NSObjectProtocol {
    /// 更新设备列表
    func updateDeviceList()
    
    /// 更新搜索状态视图为搜索中状态
    func updateSearchStatusViewToSearching()
    
    /// 更新搜索状态视图为超时状态
    func updateSearchStatusViewToTimeout()
    
    /// 显示/隐藏空值视图
    func showEmptyView(_ show: Bool)
    
    /// 显示/隐藏表格视图
    func showTableView(_ show: Bool)
    
    /// 更新下一步按钮状态
    func updateNextButtonState(enabled: Bool)
    
    /// 开始加载动画
    func startLoadingAnimation()
    
    /// 停止加载动画
    func stopLoadingAnimation()
    
    /// 显示 Toast
    func showToast()
    
    /// 隐藏 Toast
    func hideToast()
    
    /// 显示权限设置弹窗
    func showPermissionSheet(hasPermission: Bool, isBluetoothPoweredOn: Bool, setupAction: @escaping () -> Void)
    
    /// 显示 FAQ 弹窗
    func showFAQSheet()
    
    /// 显示错误提示
    func showErrorMessage(_ message: String)
    
    /// 跳转到 WiFi 密码输入页面
    func navigateToWifiPassword(device: LCBluetoothDeviceModel)
}

class LCBluetoothSearchPresenter: NSObject {
    
    // MARK: - Properties
    private weak var container: LCBluetoothSearchContainerProtocol?
    
    private var deviceList: [LCBluetoothDeviceModel] = []
    private var selectedDevice: LCBluetoothDeviceModel?
    private var searchTimer: Timer?
    private let searchTimeout: TimeInterval = 60.0
    private var isSearching = false
    // 用于记录正在请求的 productId，避免重复请求
    private var requestingProductIds: Set<String> = []
    
    // MARK: - Bluetooth Manager (用于状态监听)
    private var bluetoothStateManager: CBCentralManager?
    private var bluetoothStateTimer: Timer?
    private let bluetoothStateCheckInterval: TimeInterval = 1.0 // 每秒检查一次
    
    // MARK: - Computed Properties
    var devices: [LCBluetoothDeviceModel] {
        return deviceList
    }
    
    var selectedDeviceModel: LCBluetoothDeviceModel? {
        return selectedDevice
    }
    
    // MARK: - Initialization
    init(container: LCBluetoothSearchContainerProtocol) {
        super.init()
        self.container = container
    }
    
    deinit {
        stopBluetoothSearch()
        stopBluetoothStateMonitoring()
    }
    
    // MARK: - Setup
    func setup() {
        startBluetoothSearch()
    }
    
    // MARK: - Lifecycle
    func viewWillAppear() {
        startBluetoothStateMonitoring()
    }
    
    func viewWillDisappear() {
        stopBluetoothSearch()
        stopBluetoothStateMonitoring()
    }
    
    // MARK: - Bluetooth Search
    func startBluetoothSearch() {
        isSearching = true
        container?.startLoadingAnimation()
        deviceList.removeAll()
        selectedDevice = nil
        requestingProductIds.removeAll() // 清空正在请求的 productId 列表
        container?.updateNextButtonState(enabled: false)
        container?.updateDeviceList()
        container?.showEmptyView(false)
        container?.showTableView(true)
        container?.updateSearchStatusViewToSearching()
        
        // 开始搜索蓝牙设备
        LCOpenSDK_Bluetooth.startSearchDevice(Int(searchTimeout)) { [weak self] bleName, pid in
            print("stratSearchDevice--> bleName: \(bleName) pid: \(pid)")
            // 每次搜索到设备时的回调
            DispatchQueue.main.async {
                self?.onDeviceFound(bleName: bleName, pid: pid)
            }
        } finished: { [weak self] success, message in
            // 搜索结束或超时后的回调
            DispatchQueue.main.async {
                self?.onSearchFinished(success: success, message: message)
            }
        }
    }
    
    private func onDeviceFound(bleName: String, pid: String) {
        // 检查参数有效性
        guard !bleName.isEmpty, !pid.isEmpty else {
            return
        }
        
        // 生成设备ID（使用蓝牙名称作为唯一标识，或者可以组合pid和bleName）
        // 注意：如果SDK后续提供deviceId，应该使用SDK提供的deviceId
        let deviceId = "\(pid)-\(bleName)"
        
        // 检查是否已经存在该设备（避免重复添加）
        let existingDevice = deviceList.first { existingDevice in
            existingDevice.deviceId == deviceId ||
            (existingDevice.productId == pid && existingDevice.bluetoothName == bleName)
        }
        
        // 如果设备已存在，直接返回，避免重复请求
        if existingDevice != nil {
            return
        }
        
        // 检查是否正在请求该 productId，避免重复请求
        if requestingProductIds.contains(pid) {
            return
        }
        
        // 标记该 productId 正在请求中
        requestingProductIds.insert(pid)
        
        // 接口校验
        LCAddDeviceInterface.getProductModel(pid) { [weak self] isSupportWeakBind, isSupportSelfDiscover in
            guard let self = self else { return }
            
            // 请求完成，移除标记
            self.requestingProductIds.remove(pid)
            
            print("getProductModel--->pid: \(pid) isSupportWeakBind: \(isSupportWeakBind) isSupportSelfDiscover:\(isSupportSelfDiscover)")
            if(isSupportSelfDiscover == true) {
                LCAddDeviceManager.sharedInstance.isSupportWeakBind = true
                // 创建设备模型
                let device = LCBluetoothDeviceModel(productId: pid, deviceId: deviceId, bluetoothName: bleName)
                // 添加到列表
                self.addDevice(device)
            }
        } failure: { [weak self] error in
            guard let self = self else { return }
            
            // 请求失败，移除标记
            self.requestingProductIds.remove(pid)
        }
    }
    
    private func onSearchFinished(success: Bool, message: String?) {
        // 停止搜索状态
        stopBluetoothSearch()
        
        // 如果搜索失败，显示提示
        if !success, let msg = message, !msg.isEmpty {
            // 可以根据message判断是否是蓝牙未开启等错误
            if msg.contains("蓝牙") || msg.contains("Bluetooth") || msg.contains("bluetooth") {
                container?.showToast()
            } else {
                container?.showErrorMessage(msg)
            }
        }
        
        // 如果没有搜索到设备，显示超时状态和空值图
        if deviceList.isEmpty {
            container?.updateSearchStatusViewToTimeout()
            container?.showEmptyView(true)
            container?.showTableView(false)
        } else {
            container?.updateSearchStatusViewToSearching()
            container?.showEmptyView(false)
            container?.showTableView(true)
        }
    }
    
    func stopBluetoothSearch() {
        isSearching = false
        container?.stopLoadingAnimation()
        searchTimer?.invalidate()
        searchTimer = nil
        // 停止蓝牙搜索
        LCOpenSDK_Bluetooth.stopSearchDevice()
    }
    
    // MARK: - Device Management
    private func addDevice(_ device: LCBluetoothDeviceModel) {
        // 检查是否已存在（根据deviceId或组合pid和bleName来判断）
        let existingDevice = deviceList.first { existingDevice in
            existingDevice.deviceId == device.deviceId ||
            (existingDevice.productId == device.productId && existingDevice.bluetoothName == device.bluetoothName)
        }
        
        if existingDevice != nil {
            return
        }
        
        // 添加到列表
        deviceList.append(device)
        
        // 如果是第一个设备，默认选中
        let isFirstDevice = deviceList.count == 1
        if isFirstDevice {
            device.isSelected = true
            selectedDevice = device
            container?.updateNextButtonState(enabled: true)
        }
        
        // 通知容器更新设备列表
        container?.updateDeviceList()
        
        container?.showEmptyView(false)
        container?.showTableView(true)
    }
    
    func selectDevice(_ device: LCBluetoothDeviceModel) {
        // 取消之前选中的设备
        deviceList.forEach { $0.isSelected = false }
        
        // 选中当前设备
        device.isSelected = true
        selectedDevice = device
        
        container?.updateNextButtonState(enabled: true)
        container?.updateDeviceList()
    }
    
    func refreshSearch() {
        // 清空设备列表，重新开始搜索
        deviceList.removeAll()
        selectedDevice = nil
        requestingProductIds.removeAll() // 清空正在请求的 productId 列表
        container?.updateNextButtonState(enabled: false)
        container?.updateDeviceList()
        startBluetoothSearch()
    }
    
    // MARK: - Bluetooth State Monitoring
    func startBluetoothStateMonitoring() {
        // 初始化蓝牙管理器用于状态监听
        if bluetoothStateManager == nil {
            bluetoothStateManager = CBCentralManager(delegate: self, queue: nil)
        }
        
        // 立即检查一次状态
        checkBluetoothState()
        
        // 启动定时器定期检查蓝牙状态
        stopBluetoothStateMonitoring() // 先停止之前的定时器
        bluetoothStateTimer = Timer.scheduledTimer(withTimeInterval: bluetoothStateCheckInterval, repeats: true) { [weak self] _ in
            self?.checkBluetoothState()
        }
    }
    
    func stopBluetoothStateMonitoring() {
        bluetoothStateTimer?.invalidate()
        bluetoothStateTimer = nil
    }
    
    private func checkBluetoothState() {
        // 检查蓝牙状态
        if let manager = bluetoothStateManager {
            handleBluetoothState(manager.state)
        } else {
            // 如果manager不存在，重新初始化
            bluetoothStateManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    private func handleBluetoothState(_ state: CBManagerState) {
        switch state {
        case .poweredOff:
            container?.showToast()
            stopBluetoothSearch()
        case .unauthorized:
            container?.showToast()
            stopBluetoothSearch()
        case .poweredOn:
            container?.hideToast()
        case .resetting, .unknown:
            // 状态未知，等待状态更新
            break
        case .unsupported:
            container?.showErrorMessage("add_device_bluetooth_unsupported".lc_T)
            stopBluetoothSearch()
        @unknown default:
            break
        }
    }
    
    // MARK: - Permission & Settings
    func checkBluetoothPermission() -> Bool {
        // 在iOS 13+，可以通过CBCentralManager的authorization属性检查权限
        if #available(iOS 13.1, *) {
            let authStatus = CBCentralManager.authorization
            return authStatus == .allowedAlways
        }
        // iOS 13.0以下，默认有权限
        return true
    }
    
    func handleToastTapped() {
        // 检查蓝牙权限状态
        let hasPermission = checkBluetoothPermission()
        // 检查蓝牙是否已开启
        let isBluetoothPoweredOn = bluetoothStateManager?.state == .poweredOn
        
        container?.showPermissionSheet(hasPermission: hasPermission, isBluetoothPoweredOn: isBluetoothPoweredOn) { [weak self] in
            self?.openSettings()
        }
    }
    
    func openSettings() {
        // 跳转到系统设置页面
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // MARK: - Navigation
    func handleNextButtonClicked() {
        guard let device = selectedDevice else {
            return
        }
        
        // 停止搜索
        stopBluetoothSearch()
        
        // 设置自发现配网标识和设备信息
        let manager = LCAddDeviceManager.sharedInstance
        manager.isEntryFromBluetoothDiscovery = true
        manager.bluetoothDeviceName = device.bluetoothName
        manager.bluetoothProductId = device.productId
        manager.productId = device.productId
        
        // 跳转到WiFi密码输入页面
        container?.navigateToWifiPassword(device: device)
    }
    
    func handleFAQButtonClicked() {
        container?.showFAQSheet()
    }
}

// MARK: - CBCentralManagerDelegate (用于蓝牙状态监听)
extension LCBluetoothSearchPresenter: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // 蓝牙状态变化时立即处理
        handleBluetoothState(central.state)
    }
}
