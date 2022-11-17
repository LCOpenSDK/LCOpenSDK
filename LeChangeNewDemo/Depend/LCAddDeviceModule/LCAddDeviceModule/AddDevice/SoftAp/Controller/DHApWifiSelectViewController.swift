//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	AP配置：wifi选择界面

import UIKit
import LCBaseModule
import LCOpenSDKDynamic

public class DHAppWifiCell: UITableViewCell {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var qualityImageView: UIImageView!
	
	public func setup(wifiInfo: LCOpenSDK_WifiInfo) {
		nameLabel.text = wifiInfo.name
		nameLabel.textColor = UIColor.lccolor_c2()
		var imageName: String = ""
        
		//强度不使用拼接方式，防止资源被清理
		if wifiInfo.linkQuality < 25 {
			imageName = wifiInfo.autoConnect ? "wifi_bad_unlock" : "wifi_bad_lock"
		} else if wifiInfo.linkQuality < 55 {
			imageName = wifiInfo.autoConnect ? "wifi_weak_unlock" : "wifi_weak_lock"
		} else if wifiInfo.linkQuality < 75 {
			imageName = wifiInfo.autoConnect ? "wifi_good_unlock" : "wifi_good_lock"
		} else {
			imageName = wifiInfo.autoConnect ?  "wifi_nice_unlock" : "wifi_nice_lock"
		}
		
		qualityImageView.image = UIImage(named: imageName)
	}
}

class LCApWifiSelectViewController: LCAddBaseViewController,
                                    UITableViewDelegate,
                                    UITableViewDataSource {

	public static func storyboardInstance() -> LCApWifiSelectViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: Bundle.lc_addDeviceBundle())
        if let controller = storyboard.instantiateViewController(withIdentifier: "LCApWifiSelectViewController") as? LCApWifiSelectViewController {
            return controller
        }
        
		return LCApWifiSelectViewController()
	}
	
	@IBOutlet weak var tableView: UITableView!
	
    /// WIFI列表，可由上级界面传入
    public var wifiList = [LCOpenSDK_WifiInfo]()
    public var devicePassword: String = ""
	
	private var headerView = LCApWifiHeaderView()
	private var isLoading = false
	private var abnormalView: UIView?
    private var ip: String?
    private var port: Int32 = 0
    
    public var scDeviceIsInited = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
		tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.lccolor_c8()
        tableView.register(LCWiFiConfigHeader.self, forHeaderFooterViewReuseIdentifier: "LCWiFiConfigHeader")
        
        if wifiList.count == 0 {
            loadWifiList()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func setupNaviRightItem() {
		btnNaviRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		btnNaviRight.contentHorizontalAlignment = .right
		btnNaviRight.setImage(UIImage(named: "common_image_nav_refresh"), for: .normal)
		btnNaviRight.setImage(UIImage(named: "common_image_nav_refresh"), for: .highlighted)
		btnNaviRight.setImage(UIImage(named: "common_image_nav_refresh_disable"), for: .disabled)
		btnNaviRight.addTarget(self, action: #selector(onRefreshAction), for: .touchUpInside)
		let item = UIBarButtonItem(customView: btnNaviRight)
		self.navigationItem.lc_rightBarButtonItems = [item]
		
		btnNaviRight.isHidden = self.isRightActionHidden()
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
		btnNaviRight.lc_enable = false
		headerView.indicatorView.startAnimating()
		let deviceIp = LCAddDeviceManager.sharedInstance.getLocalDevice()?.deviceIP ?? ""
		let gatewayIp = UIDevice.lc_getRouterAddress()
        ip = deviceIp.count == 0 ? gatewayIp : deviceIp
        port = LCAddDeviceManager.sharedInstance.getLocalDevice()?.port ?? 37_777
		
//        print("gatewayIp :" + gatewayIp!)
        
		// IP没有获取到，延迟执行
		guard ip != nil else {
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self.isLoading = false
				self.btnNaviRight.lc_enable = true
				self.headerView.indicatorView.stopAnimating()
				
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
        LCNetSDKHelper.getSoftApWifiList(ip ?? "", port: Int(port), devicePassword: devicePassword, isSC: isSc) { [weak self] list in
            LCProgressHUD.hideAllHuds(self?.view)
            self?.wifiListDidLoad(wifiList: list, error: 0)
        } failure: { [weak self] errorCode, desc in
            LCProgressHUD.hideAllHuds(self?.view)
            self?.wifiListDidLoad(wifiList: nil, error: errorCode)
        }
	}
    
    func wifiListDidLoad(wifiList list: [LCOpenSDK_WifiInfo]?, error errorCode: NSInteger) {
        if list != nil {
            self.wifiList.append(contentsOf: list!)
        }
        
        self.tableView.reloadData()
        self.isLoading = false
        self.btnNaviRight.lc_enable = true
        self.headerView.indicatorView.stopAnimating()
        
        if errorCode != 0 {
            self.showAbnormalView()
        }
    }
	
	// MARK: Abnormal View
	func showAbnormalView() {
		let result = UIView()
		abnormalView = result
		result.backgroundColor = UIColor.lccolor_c43()
		self.view.addSubview(result)
		
		result.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
		
		let imageView = UIImageView()
		imageView.image = UIImage(named: "common_pic_nointernet")
		result.addSubview(imageView)
		imageView.snp.makeConstraints({ (make) in
			make.centerX.equalTo(result)
			make.centerY.equalTo(result).offset(-70)
		})
		
		let tipLabel = UILabel()
		tipLabel.textAlignment = .center
		tipLabel.textColor = UIColor.lccolor_c5()
		tipLabel.text = "add_device_connect_error_and_quit_retry".lc_T
		tipLabel.font = UIFont.lcFont_t4()
		tipLabel.numberOfLines = 0
		result.addSubview(tipLabel)
		
		tipLabel.snp.makeConstraints({ (make) in
			make.top.equalTo(imageView.snp.bottom)
			make.height.equalTo(30)
			make.left.right.equalTo(self.view)
		})
		self.view.addSubview(abnormalView!)
	}
	
	func hideAbnormalView() {
		abnormalView?.removeFromSuperview()
		abnormalView = nil
	}
		
	// MARK: - UITableViewDelegate
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LCAddDeviceManager.sharedInstance.netConfigMode == .softAp ? wifiList.count + 1 : wifiList.count
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 186.0
        } else {
            return 44
        }
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
        if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp && indexPath.row == wifiList.count {
            let vc = LCAddOtherWifiController()
            if true == LCAddDeviceManager.sharedInstance.isSupportSC && false == self.scDeviceIsInited {
                vc.devicePassword = LCAddDeviceManager.sharedInstance.initialPassword
            }
            else{
                vc.devicePassword = devicePassword
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let controller = LCWifiPasswordViewController.storyboardInstance()
            let presenter = LCApWifiPasswordPresenter(container: controller)
            presenter.devicePassword = devicePassword
            presenter.wifiSSID = wifiList[indexPath.row].name
            presenter.encryptionAuthority = wifiList[indexPath.row].encryptionAuthority
            presenter.netcardName = wifiList[indexPath.row].netcardName ?? ""
            presenter.scDeviceIsInited = self.scDeviceIsInited
            controller.setup(presenter: presenter)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
	
	// MARK: - UITableViewDataSource
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp && indexPath.row == wifiList.count {
            let cell = UITableViewCell()
            cell.textLabel?.text = "hidden_wifi_other".lc_T
            cell.textLabel?.textColor = UIColor.lccolor_c0()
            cell.selectionStyle = .none
            return cell
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DHAppWifiCell", for: indexPath) as? DHAppWifiCell {
            let wifiInfo = wifiList[indexPath.row]
            cell.setup(wifiInfo: wifiInfo)
            return cell
        }
		
        return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LCWiFiConfigHeader") as? LCWiFiConfigHeader else {
            return nil
        }
        header.isAddNetwordTitle = true
        header.delegate = self
        return header
	}
	
	// MARK: LCAddBaseVCProtocol
	override func leftActionType() -> LCAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
}

extension LCApWifiSelectViewController: LCApWifiHeaderViewDelegate {
    func iconClicked(headView: LCApWifiHeaderView) {
        let vc = LCWifiInfoExplainController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LCApWifiSelectViewController: LCWiFiConfigHeaderDelegate {
    func iconDidClicked(type: LCWiFiConfigHeaderClickType) {
        switch type {
        case .fiveGDesc:
            let supportVc = LCWiFiUnsupportVC()
            self.navigationController?.pushViewController(supportVc, animated: true)
        case .wifiDesc:
            let vc = LCWifiInfoExplainController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
