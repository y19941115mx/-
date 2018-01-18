//
//  MyDoctorViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import SVProgressHUD


import UIKit


class MyDoctor_main: BaseRefreshController<DoctorBean>, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infoTableView: BaseTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的医生")
        // 添加上拉刷新
        initRefresh(scrollView: infoTableView, ApiMethod: .getredoctor(self.selectedPage), refreshHandler: {}, getMoreHandler: {
            self.getMoreMethod = API.getredoctor(self.selectedPage)
        })
        //刷新数据
        self.header?.beginRefreshing()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! MyDoctorTableViewCell
        let doctor = data[indexPath.row]
        cell.updateView(mData: doctor, vc:self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = data[indexPath.row]
        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Detail") as! Home_DoctorDetail
        vc.doctorId = bean.docId
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    
}


