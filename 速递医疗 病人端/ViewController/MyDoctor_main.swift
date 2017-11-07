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


class MyDoctor_main: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infoTableView: BaseTableView!
    var type:Int = 0
    var data = [DoctorBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的医生")
        // 获取数据
        getData()
        
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
    
    
    private func getData() {
        NetWorkUtil<DoctorListBean>.init(method: API.getredoctor, vc: self).newRequest { bean in
            if bean.code == 100 {
                self.data = (bean.doctorDataList)!
                self.infoTableView.reloadData()
            }
            showToast(self.view, bean.msg!)
        }
    }
    
    
    
}


