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
        initRefresh(scrollView: infoTableView, ApiMethod: .getredoctor, refreshHandler: {jsonobj in
            let bean = Mapper<DoctorListBean>().map(JSONObject: jsonobj)
            if bean?.code == 100 {
                self.header?.endRefreshing()
                if bean?.doctorDataList == nil {
                    bean?.doctorDataList = [DoctorBean]()
                }
                self.data = (bean?.doctorDataList)!
                if self.data.count == 0{
                    //隐藏tableView,添加刷新按钮
                    self.showRefreshBtn()
                }
                let tableView = self.scrollView as! UITableView
                tableView.reloadData()
            }else {
                self.header?.endRefreshing()
                showToast(self.view, (bean?.msg!)!)
            }
        }, getMoreHandler: getMoreData)
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
    
    
    private func getMoreData() {
        let Provider = MoyaProvider<API>()
        Provider.request(API.getredoctor) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<DoctorListBean>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        self.footer?.endRefreshing()
                        if bean?.doctorDataList?.count == 0{
                            showToast(self.view, "已经到底了")
                            return
                        }
                        self.footer?.endRefreshing()
                        self.data += (bean?.doctorDataList)!
                        self.selectedPage += 1
                        let tableView = self.scrollView as! UITableView
                        tableView.reloadData()
                        
                    }else {
                        self.footer?.endRefreshing()
                        showToast(self.view, (bean?.msg!)!)
                    }
                }catch {
                    self.footer?.endRefreshing()
                    showToast(self.view, CATCHMSG)
                }
            case let .failure(error):
                self.footer?.endRefreshing()
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
    }
    
}


