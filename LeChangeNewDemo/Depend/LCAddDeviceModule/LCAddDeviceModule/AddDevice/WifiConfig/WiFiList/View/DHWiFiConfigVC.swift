//
//  Copyright © 2018 dahua. All rights reserved.
//

import UIKit

class DHWiFiConfigVC: DHBaseViewController {
    
    // todo: 修改wifi内容显示
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var presenter: DHWiFiConfigPresenter!
    public var deviceId: String = ""
    
    // MARK: - 🍇public method
    
    public static func storyboardInstance() -> DHWiFiConfigVC {
        let storyboard = UIStoryboard(name: "DHHomePage", bundle: Bundle.dh_addDeviceBundle())
        let controller = storyboard.instantiateViewController(withIdentifier: "DHWiFiConfigVC")
        return controller as! DHWiFiConfigVC
    }
    
    deinit {
        tableView.lc_clearTipsView()
        print(self)
    }
    
    // MARK: - 🍎override method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "mobile_common_network_config".lc_T
        self.refreshButton.image = UIImage(named: "common_image_nav_refresh")
        //获取数据
        presenter = DHWiFiConfigPresenter.init(deviceId: self.deviceId)
        presenter.setContainer(container: self)
        presenter.loadWiFiList()
        //设置UI
        initTable()
    }
    // MARK: - 🍎private method
    
    private func initTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.dhcolor_c8()
		tableView.backgroundColor = UIColor.dhcolor_c7()
        tableView.register(DHWiFiConfigHeader.self, forHeaderFooterViewReuseIdentifier: "DHWiFiConfigHeader")
    }

    @objc func iconClicked() {
        presenter.explainWifiInfo()
    }
  
    // MARK: - 🍉action
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.presenter.refresh()
    }
    
}

// MARK: - 🍑container protocol

extension DHWiFiConfigVC: IDHWiFiConfigContainer {
    func table() -> UITableView {
        return tableView
    }
    
    func navigationVC() -> UINavigationController? {
        return navigationController
    }
    
    func mainView() -> UIView {
        return view
    }
    
    func mainController() -> UIViewController {
        return self
    }
    
    func refreshEnable(isEnable: Bool) {
        if !isEnable {
            self.refreshButton.isEnabled = false
            var img = UIImage(named: "common_image_nav_refresh_disable")
            img = img?.withRenderingMode(.alwaysOriginal)
            self.refreshButton.image = img
        } else {
            self.refreshButton.isEnabled = true
            var img = UIImage(named: "common_image_nav_refresh")
            img = img?.withRenderingMode(.alwaysOriginal)
            self.refreshButton.image = img
        }
    }
    
}

// MARK: - 🍑table view datasource

// todo: 改了之后写得不好，需要修改
extension DHWiFiConfigVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sectionNumber()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != (presenter.sectionNumber() - 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DHWiFiConfigListCell")
            presenter.configCell(cell: cell!, indexPath: indexPath)
            return cell!
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "其他..."
            cell.textLabel?.textColor = UIColor.dhcolor_c0()
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - 🍑table view delegate

extension DHWiFiConfigVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !presenter.hasConfigedWifi(), indexPath.section == 0, presenter.sectionNumber() != 1 {
            return 0
        }
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !presenter.hasConfigedWifi(), section == 0, DHAddDeviceManager.sharedInstance.isSupport5GWifi {
            return 0.01
        } else if !DHAddDeviceManager.sharedInstance.isSupport5GWifi, section == 0 {
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

        if !DHAddDeviceManager.sharedInstance.isSupport5GWifi, section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DHWiFiConfigHeader") as? DHWiFiConfigHeader else {
                return nil
            }
            header.delegate = self
            header.titleImageView.image = DHAddDeviceManager.sharedInstance.isSupport5GWifi ? UIImage(named: "adddevice_icon_wifipassword") : UIImage(named: "adddevice_icon_wifipassword_nosupport5g")
            header.titleLabel.isHidden = DHAddDeviceManager.sharedInstance.isSupport5GWifi
            header.iconImageView.isHidden = DHAddDeviceManager.sharedInstance.isSupport5GWifi
            header.descButton.isHidden = !presenter.hasConfigedWifi()
            return header
        } else if !presenter.hasConfigedWifi(), section == 0 {
            return nil
        } else if section != (presenter.sectionNumber() - 1) {
            let headerview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: dh_screenWidth, height: 40))
            let headerLabel = UILabel()
            headerview.clipsToBounds = true
            headerLabel.font = UIFont.dhFont_t5()
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

extension DHWiFiConfigVC: DHWiFiConfigHeaderDelegate {
    func iconDidClicked(type: DHWiFiConfigHeaderClickType) {
        presenter.explain5GInfo()
    }
}
