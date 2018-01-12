//
//  Mine_msg_main.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SwiftyJSON

class Mine_msg_main: BaseRefreshController<NotificationBean>,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: BaseTableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        let descLabel = cell.viewWithTag(3) as! UILabel
        let readFlag = cell.viewWithTag(4) as! UIView
        let bean = data[indexPath.row]
        if bean.notificationread! {
            readFlag.isHidden = true
        }
        titleLabel.text = bean.notificationtitle
        descLabel.text = bean.notificationwords
        timeLabel.text = bean.notificationcreatetime
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = data[indexPath.row]
        bean.notificationread = true
        tableView.reloadRows(at: [indexPath], with: .none)
        NetWorkUtil.init(method: .updatenotificationtoread(bean.notificationid!)).newRequestWithOutHUD { (bean, json) in
            if bean.code == 100 {
                UIApplication.shared.applicationIconBadgeNumber -= 1
            }
        }
        // 获取数据跳转对应页面
        let notificationdata = bean.notificationdata
        if notificationdata != "{}" && notificationdata != nil  {
            if let jsonData = notificationdata!.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                let json = JSON.init(data:jsonData)
                if json["order_id"].int != nil {
                    // 跳转到订单详情页
                    let vc = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "OrderDetail") as! Order_Detail
                            vc.userorderId = json["order_id"].intValue
                    self.present(vc, animated: false, completion: nil)
                }
                else if json["doc_id"].int != nil {
//                    // 跳转到医生页
                    let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Detail") as! Home_DoctorDetail
                    vc.doctorId = json["doc_id"].intValue
                    self.navigationController?.pushViewController(vc, animated: false)
                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                }
//                else if json["user_id"].int != nil {
//
//                }else if json["sick_id"].int != nil {
//
//                }
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        initRefresh(scrollView: tableView, ApiMethod: .listreceivenotification(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = .listreceivenotification(self.selectedPage)
        })
        self.header?.beginRefreshing()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cleanMsgAction(_ sender: Any) {
        AlertUtil.popAlert(vc: self, msg: "确认删除所有通知", okhandler: {
            NetWorkUtil.init(method: .deleteallreceivenotification).newRequest(handler: { (bean, json) in
                showToast(self.view, bean.msg!)
                UIApplication.shared.applicationIconBadgeNumber = 0
                self.refreshData()
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏navigation
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func BackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

