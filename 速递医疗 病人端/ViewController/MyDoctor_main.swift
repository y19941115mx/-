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
        let Provider = MoyaProvider<API>()
        SVProgressHUD.show()
        Provider.request(API.getredoctor) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let bean = Mapper<DoctorListBean>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        self.data = (bean?.doctorDataList)!
                        self.infoTableView.reloadData()
                    }else {
                        showToast(self.view, bean!.msg!)
                    }
                    
                }catch {
                    SVProgressHUD.dismiss()
                    self.view.makeToast(CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                self.view.makeToast(ERRORMSG)
            }
        }
    }
    
    
    
}


