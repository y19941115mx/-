//
//  HomeViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Toast_Swift
import SVProgressHUD
import ObjectMapper
import Moya

class Home_main:BaseRefreshController<DoctorBean>, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var infoTableView: UITableView!

    @IBOutlet weak var sortByPatientBtn: UIButton!

    @IBOutlet weak var sortByTimeBtn: UIButton!

    @IBOutlet weak var sortByDept: UIButton!
    @IBOutlet weak var sortByLocBtn: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //添加按钮事件
        initView()
        // 初始化navigationBar
        setUpNavTitle(title: "首页")
        // 添加下拉刷新
        initRefresh(scrollView: infoTableView, ApiMethod: API.getdoctorlist(selectedPage, "0", "0"), refreshHandler: {jsonobj in
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
        }, getMoreHandler:getMoreData)
        // 获取数据
        self.header?.beginRefreshing()
        infoTableView.dataSource = self
        infoTableView.delegate = self
        // 获取dept数据,关联UIpicker
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeMainTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("HomeMainTableViewCell", owner: nil, options: nil)?.last as? HomeMainTableViewCell
        }
        let modelBean = self.data[indexPath.row]
        cell?.updateViews(modelBean: modelBean)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    
    
    
    private func initView(){
        sortByLocBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByTimeBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByPatientBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByDept.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
    }

    private func cleanButton(){
        sortByLocBtn.setTitleColor(UIColor.darkGray, for: .normal)
        sortByTimeBtn.setTitleColor(UIColor.darkGray, for: .normal)
        sortByPatientBtn.setTitleColor(UIColor.darkGray, for: .normal)
        sortByDept.setTitleColor(UIColor.darkGray, for: .normal)
    }

    //MARK: - action
    @objc func clickBtn(button:UIButton){
        switch button.tag {
        // 推荐病人
        case 10001:
            cleanButton()
            sortByPatientBtn.setTitleColor(UIColor.APPColor, for: .normal)
        // 时间
        case 10002:
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.APPColor, for: .normal)
            showToast(self.view, "按照时间排序")
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.APPColor, for: .normal)
        
        case 10004:
            cleanButton()
            sortByDept.setTitleColor(UIColor.APPColor, for: .normal)
        default:
            dPrint(message: "error")
        }

    }

    //MARK: - navigation Methond

    @IBAction func unwindToHome(sender: UIStoryboardSegue){

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let SelectedIndexPath = infoTableView.indexPathForSelectedRow
            let doctor = data[SelectedIndexPath!.row]
            let vc = segue.destination as! Home_DoctorDetail
            vc.doctorBean = doctor
        }
    }
        
    // MARK: - Private Method
    
    private func getMoreData() {
        let Provider = MoyaProvider<API>()
        Provider.request(API.getdoctorlist(selectedPage, "0", "0")) { result in
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


