//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	AP配置：wifi选择界面

import UIKit
import LCBaseModule
import LCOpenSDKDynamic

public class LCAppWifiCell: UITableViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 0x2c/255.0, green: 0x2c/255.0, blue: 0x2c/255.0, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var lockImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(lc_named: "wifi_lock"))
        imageView.isHidden = true
        return imageView
    }()
    
	lazy var qualityImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(red: 0xef/255.0, green: 0xef/255.0, blue: 0xef/255.0, alpha: 1.0)
        return line
    }()

    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(nameLabel)
        self.addSubview(lockImageView)
        self.addSubview(qualityImageView)
        self.addSubview(lineView)
        
        lineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(-0.5)
        }
        
        qualityImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 28))
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-17.5)
        }
        
        lockImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 28))
            make.centerY.equalToSuperview()
            make.trailing.equalTo(qualityImageView.snp.leading).offset(-5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalTo(qualityImageView.snp.leading).offset(-25)
            make.centerY.equalToSuperview()
        }
    }
    
	public func setup(wifiInfo: LCOpenSDK_WifiInfo) {
		nameLabel.text = wifiInfo.name
		nameLabel.textColor = UIColor.lccolor_c2()
		var imageName: String = ""
        
		//强度不使用拼接方式，防止资源被清理
		if wifiInfo.linkQuality < 25 {
			imageName = "wifi_bad_unlock"
		} else if wifiInfo.linkQuality < 55 {
			imageName = "wifi_weak_unlock"
		} else if wifiInfo.linkQuality < 75 {
			imageName = "wifi_good_unlock"
		} else {
			imageName = "wifi_nice_unlock"
		}
		qualityImageView.image = UIImage(lc_named: imageName)
        
        if wifiInfo.autoConnect == true {
            lockImageView.isHidden = true
        } else {
            lockImageView.isHidden = false
        }
	}
}

class LCApWifiSelectViewController: LCAddBaseViewController {
    private lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.init(red: 0xf6/255.0, green: 0xf6/255.0, blue: 0xf6/255.0, alpha: 1.0)
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 13.0, *) {
            table.automaticallyAdjustsScrollIndicatorInsets = false
        }
        table.contentInset = UIEdgeInsets.zero
        return table
    }()
	
    /// WIFI列表，可由上级界面传入
    public var wifiList = [LCOpenSDK_WifiInfo]()
    public var devicePassword: String = ""
	
    private let headerView = LCApWifiHeaderView.xibInstance()
	private var isLoading = false
	private var abnormalView: UIView?
    private var ip: String?
    private var port: Int32 = 0
    public var scDeviceIsInited = false
    public var searchedDevice: LCOpenSDK_SearchDeviceInfo?
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBarBackgroundColor(color: UIColor.init(red: 0xf6, green: 0xf6, blue: 0xf6, alpha: 1.0))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBarBackgroundColor(color: UIColor.white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        setupNaviRightItem()
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(246.5)
        }
        
        tableView.register(LCAppWifiCell.self, forCellReuseIdentifier: "LCAppWifiCell")
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        if wifiList.count == 0 {
            loadWifiList()
        }
    }
    
    override func leftActionType() -> LCAddBaseLeftAction {
        return .quit
    }
    
    override func isLeftActionShowAlert() -> Bool {
        return true
    }
    
    override func setupNaviRightItem() {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(lc_named: "adddevice_wifi_refresh"), for: .normal)
        btn.addTarget(self, action: #selector(onRefreshAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }

	@objc func onRefreshAction() {
		loadWifiList()
	}
	
	// MARK: LoadWifi
	private func loadWifiList() {
		if isLoading {
			return
		}
		isLoading = true
        let deviceIp = self.searchedDevice?.ip ?? ""
		let gatewayIp = UIDevice.lc_getRouterAddress()
        ip = deviceIp.count == 0 ? gatewayIp : deviceIp
        port = self.searchedDevice?.port ?? 37_777
		
		// IP没有获取到，延迟执行
		guard ip != nil else {
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self.isLoading = false
				if self.wifiList.count == 0 {
					self.showAbnormalView()
				}
			}
			
			return
		}
		
		self.wifiList.removeAll()
		self.tableView.reloadData()
		self.hideAbnormalView()
        LCProgressHUD.show(on: self.view)
        var isSc = false
        if false == self.scDeviceIsInited && true == LCAddDeviceManager.sharedInstance.isSupportSC {
            isSc = true
        }else {
            if true == LCAddDeviceManager.sharedInstance.isSupportSC {
                devicePassword = LCAddDeviceManager.sharedInstance.initialPassword
            }
        }
        DispatchQueue.global().async {
            LCOpenSDK_SoftApConfig.getSoftApWifiList(self.ip ?? "", port: Int(self.port), devicePassword: self.devicePassword, isSC: isSc) {[weak self] list in
                DispatchQueue.main.async {
                    LCProgressHUD.hideAllHuds(self?.view)
                    self?.wifiListDidLoad(wifiList: list, error: 0)
                }
            } failure: {[weak self] errorCode, desc in
                DispatchQueue.main.async {
                    LCProgressHUD.hideAllHuds(self?.view)
                    self?.wifiListDidLoad(wifiList: nil, error: errorCode)
                }
            }
        }
	}
    
    func wifiListDidLoad(wifiList list: [LCOpenSDK_WifiInfo]?, error errorCode: NSInteger) {
        if list != nil {
            self.wifiList.append(contentsOf: list!)
        }
        self.tableView.reloadData()
        self.isLoading = false
        if errorCode != 0 {
            self.showAbnormalView()
        }
    }
}

extension LCApWifiSelectViewController {
    func showAbnormalView() {
        abnormalView = UIView()
        abnormalView?.backgroundColor = .lccolor_c43()
        self.view.addSubview(abnormalView!)
        abnormalView?.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(lc_named: "adddevice_wifi_list_error")
        abnormalView?.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(250)
            make.top.equalToSuperview().offset(85)
        })
        
        let tipLabel = UILabel()
        tipLabel.textAlignment = .center
        tipLabel.textColor = UIColor.lccolor_c5()
        tipLabel.font = UIFont.lcFont_t4()
        tipLabel.numberOfLines = 0
        abnormalView?.addSubview(tipLabel)
        // Common
        let paragraph = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        paragraph?.alignment = .center
        paragraph?.lineSpacing = 10
        let attributedString: NSMutableAttributedString =
        NSMutableAttributedString(string: "暂无WIFI网络，", attributes: [
            NSAttributedString.Key.paragraphStyle: paragraph ?? NSParagraphStyle.default,
            NSAttributedString.Key.font: UIFont.lcFont_t3()
        ])
        // 字符串下划线
        let _underlineString = "点击重试"
        let userPolicyStr: NSMutableAttributedString = NSMutableAttributedString(string: _underlineString)
        let userPolicyStrRange: NSRange = NSRange(location: 0, length: _underlineString.length)
        userPolicyStr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.lccolor_c0()], range: userPolicyStrRange)
        userPolicyStr.addAttributes([NSAttributedStringKey.underlineColor: UIColor.lccolor_c0()], range: userPolicyStrRange)
        userPolicyStr.addAttributes([NSAttributedString.Key.underlineStyle: 1], range: userPolicyStrRange)
        userPolicyStr.addAttributes([NSAttributedString.Key.font: UIFont.lcFont_t3()], range: userPolicyStrRange)
        attributedString.append(userPolicyStr)
        tipLabel.attributedText = attributedString
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onRefreshAction))
        tipLabel.isUserInteractionEnabled = true
        tipLabel.addGestureRecognizer(tapGesture)
        tipLabel.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(imageView.snp.bottom)
        })
    }
    
    func hideAbnormalView() {
        abnormalView?.removeFromSuperview()
        abnormalView = nil
    }
}

extension LCApWifiSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LCAddDeviceManager.sharedInstance.netConfigMode == .softAp ? wifiList.count + 1 : wifiList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp && indexPath.row == wifiList.count {
            let vc = LCAddOtherWifiController()
            vc.vcStyle = .newWifi
            vc.searchedDevice = self.searchedDevice
            if true == LCAddDeviceManager.sharedInstance.isSupportSC && false == self.scDeviceIsInited {
                vc.devicePassword = LCAddDeviceManager.sharedInstance.initialPassword
            } else {
                vc.devicePassword = devicePassword
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let controller = LCAPWifiPasswordViewController.storyboardInstance()
            let presenter = LCApWifiPasswordPresenter(container: controller)
            presenter.serachedDevice = self.searchedDevice
            presenter.devicePassword = devicePassword
            presenter.wifiSSID = wifiList[indexPath.row].name
            presenter.encryptionAuthority = wifiList[indexPath.row].encryptionAuthority
            presenter.netcardName = wifiList[indexPath.row].netcardName ?? ""
            presenter.scDeviceIsInited = self.scDeviceIsInited
            controller.setup(presenter: presenter)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp && indexPath.row == wifiList.count {
            let cell = UITableViewCell()
            cell.textLabel?.text = "hidden_wifi_other".lc_T()
            cell.textLabel?.textColor = UIColor.lccolor_c0()
            cell.selectionStyle = .none
            return cell
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LCAppWifiCell", for: indexPath) as? LCAppWifiCell {
            let wifiInfo = wifiList[indexPath.row]
            cell.setup(wifiInfo: wifiInfo)
            return cell
        }
        
        return UITableViewCell()
    }
        
}

