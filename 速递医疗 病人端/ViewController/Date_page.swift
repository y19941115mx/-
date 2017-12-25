//
//  DoctorPageViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/20.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper

class Date_page: BaseRefreshController<OrderBean>, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MyDateTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("MyDateTableViewCell", owner: nil, options: nil)?.last as? MyDateTableViewCell
        }
        let bean = data[indexPath.row]
        cell?.flag = self.type!
        cell?.updateViews(vc: self, data: bean)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "OrderDetail") as! Order_Detail
        vc.userorderId = data[indexPath.row].userorderid
        self.present(vc, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    var type:Int?
    
    @IBOutlet weak var tableView: BaseTableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh(scrollView: self.tableView, ApiMethod: API.getorder(selectedPage, Int(user_default.userId.getStringValue()!)!, type!), refreshHandler: {
            
        },getMoreHandler: {
            self.getMoreMethod = API.getorder(self.selectedPage, Int(user_default.userId.getStringValue()!)!, self.type!)
        })
        
        self.header?.beginRefreshing()

    }
    
}


