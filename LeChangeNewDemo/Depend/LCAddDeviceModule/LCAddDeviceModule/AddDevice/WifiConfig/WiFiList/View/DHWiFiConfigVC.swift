//
//  Copyright © 2018 Imou. All rights reserved.
//

import UIKit
import LCBaseModule

class LCWiFiConfigVC: LCBasicViewController {
    
    // todo: 修改wifi内容显示
    
    var refreshButton: LCButton?
    @IBOutlet weak var tableView: UITableView!
    private var presenter: LCWiFiConfigPresenter!
    public var deviceId: String = ""
    
    // MARK: - 🍇public method
    
    public static func storyboardInstance() -> LCWiFiConfigVC {
        let storyboard = UIStoryboard(name: "DHHomePage", bundle: Bundle.lc_addDeviceBundle())
        let controller = storyboard.instantiateViewController(withIdentifier: "LCWiFiConfigVC")
        return controller as! LCWiFiConfigVC
    }
    
    deinit {
        tableView.lc_clearTipsView()
        print(self)
    }
    
    // MARK: - 🍎override method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建返回按钮
        let backBtn = LCButton.createButton(with: LCButtonTypeCustom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backBtn.setImage(UIImage(named: "common_icon_nav_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(navigationBarClick), for: .touchUpInside)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backBtn), animated: false)
        
        //创建返回按钮
        self.refreshButton = LCButton.createButton(with: LCButtonTypeCustom)
        self.refreshButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.refreshButton?.setImage(UIImage(named: "common_image_nav_refresh"), for: .normal)
        self.refreshButton?.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: self.refreshButton!), animated: false)
        
        title = "mobile_common_network_config".lc_T
        //获取数据
        presenter = LCWiFiConfigPresenter.init(deviceId: self.deviceId)
        presenter.setContainer(container: self)
        presenter.loadWiFiList()
        //设置UI
        initTable()
    }
    
    @objc private func navigationBarClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 🍎private method
    private func initTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.lccolor_c8()
		tableView.backgroundColor = UIColor.lccolor_c7()
        tableView.register(LCWiFiConfigHeader.self, forHeaderFooterViewReuseIdentifier: "LCWiFiConfigHeader")
    }

    @objc func iconClicked() {
        presenter.explainWifiInfo()
    }
  
    // MARK: - 🍉action
    
    @objc private func refreshAction() {
        self.presenter.refresh()
    }
    
}

// MARK: - 🍑container protocol

extension LCWiFiConfigVC: ILCWiFiConfigContainer {
    func mainController() -> UIViewController {
        return self
    }
    
    func table() -> UITableView {
        return tableView
    }
    
    func navigationVC() -> UINavigationController? {
        return navigationController
    }
    
    func mainView() -> UIView {
        return view
    }
    
    func refreshEnable(isEnable: Bool) {
        if !isEnable {
            self.refreshButton?.isEnabled = false
            var img = UIImage(named: "common_image_nav_refresh_disable")
            img = img?.withRenderingMode(.alwaysOriginal)
            self.refreshButton?.setImage(img, for: .normal)
        } else {
            self.refreshButton?.isEnabled = true
            var img = UIImage(named: "common_image_nav_refresh")
            img = img?.withRenderingMode(.alwaysOriginal)
            self.refreshButton?.setImage(img, for: .normal)
        }
    }
    
}

// MARK: - 🍑table view datasource

// todo: 改了之后写得不好，需要修改
extension LCWiFiConfigVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sectionNumber()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != (presenter.sectionNumber() - 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LCWiFiConfigListCell")
            presenter.configCell(cell: cell!, indexPath: indexPath)
            return cell!
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "hidden_wifi_other".lc_T
            cell.textLabel?.textColor = UIColor.lccolor_c0()
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - 🍑table view delegate

extension LCWiFiConfigVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !presenter.hasConfigedWifi(), indexPath.section == 0, presenter.sectionNumber() != 1 {
            return 0
        }
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !presenter.hasConfigedWifi(), section == 0, LCAddDeviceManager.sharedInstance.isSupport5GWifi {
            return 0.01
        } else if !LCAddDeviceManager.sharedInstance.isSupport5GWifi, section == 0 {
            return presenter.hasConfigedWifi() ? 186.0 : 156.0
        } else if section != (presenter.sectionNumber() - 1) {
            return 40.0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if !LCAddDeviceManager.sharedInstance.isSupport5GWifi, section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LCWiFiConfigHeader") as? LCWiFiConfigHeader else {
                return nil
            }
            header.delegate = self
            header.titleImageView.image = LCAddDeviceManager.sharedInstance.isSupport5GWifi ? UIImage(named: "adddevice_icon_wifipassword") : UIImage(named: "adddevice_icon_wifipassword_nosupport5g")
            header.titleLabel.isHidden = LCAddDeviceManager.sharedInstance.isSupport5GWifi
            header.iconImageView.isHidden = LCAddDeviceManager.sharedInstance.isSupport5GWifi
            header.descButton.isHidden = !presenter.hasConfigedWifi()
            return header
        } else if !presenter.hasConfigedWifi(), section == 0 {
            return nil
        } else if section != (presenter.sectionNumber() - 1) {
            let headerview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: lc_screenWidth, height: 40))
            let headerLabel = UILabel()
            headerview.clipsToBounds = true
            headerLabel.font = UIFont.lcFont_t5()
            headerLabel.textAlignment = .left
            headerLabel.text = ((section == 0) ? "device_manager_connected_wifi".lc_T : "device_manager_select_wifi".lc_T)
            headerview.addSubview(headerLabel)
            headerLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(headerview)
                make.left.equalTo(headerview).offset(16)
            }
            let iconImage = UIImageView()
            iconImage.image = UIImage(named: "adddevice_icon_help")
            iconImage.isUserInteractionEnabled = true
            headerview.addSubview(iconImage)
            iconImage.snp.makeConstraints { (make) in
                make.centerY.equalTo(headerview)
                make.left.equalTo(headerLabel.snp.right).offset(2)
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(iconClicked))
            iconImage.addGestureRecognizer(tap)
            iconImage.isHidden = (section == 0)
            return headerview
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != (presenter.sectionNumber() - 1) {
            presenter.connectWifi(indexPath: indexPath)
        } else {
            presenter.connectHideWifi()
        }
    }
}

extension LCWiFiConfigVC: LCWiFiConfigHeaderDelegate {
    func iconDidClicked(type: LCWiFiConfigHeaderClickType) {
        presenter.explain5GInfo()
    }
}
