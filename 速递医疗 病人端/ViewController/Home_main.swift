//
//  HomeViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Moya
import Toast_Swift
import SVProgressHUD
import ObjectMapper
import SnapKit

class Home_main:BaseRefreshController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var infoTableView: UITableView!

    @IBOutlet weak var sortByPatientBtn: UIButton!

    @IBOutlet weak var sortByTimeBtn: UIButton!

    @IBOutlet weak var sortByDept: UIButton!
    @IBOutlet weak var sortByLocBtn: UIButton!
    //医生信息
    var doctorData = [DoctorBean]()
    //当前页面
    var selectedPage = 1

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //添加按钮事件
        initView()
        // 初始化navigationBar
        setUpNavTitle(title: "首页")
        // 添加下拉刷新
        initRefresh(tableView: infoTableView, headerAction:
            self.refreshData, footerAction: self.getMoreData)
        // 获取数据
        self.header?.beginRefreshing()
        infoTableView.dataSource = self
        infoTableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return doctorData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeMainTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("HomeMainTableViewCell", owner: nil, options: nil)?.last as? HomeMainTableViewCell
        }
        let modelBean = self.doctorData[indexPath.row]
        cell?.updateViews(modelBean: modelBean)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    
    private func showRefreshBtn() {
        self.infoTableView.isHidden = true
        let button = UIButton()
        button.tag = 10006
        //label
        button.setTitle("无内容，点击刷新", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
    }

    private func refreshData(){
        self.selectedPage = 1
        //刷新数据
        let Provider = MoyaProvider<API>()
        
        Provider.request(API.getdoctorlist(1, "0", "0")) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<DoctorListBean>().map(JSONObject: try response.mapJSON())

                    if bean?.code == 100 {
                        self.header?.endRefreshing()
                        self.doctorData = (bean?.doctorDataList)!
                        if self.doctorData.count == 0{
                            //隐藏tableView,添加刷新按钮
                            self.showRefreshBtn()
                            return
                        }
                        self.infoTableView.reloadData()
                    }else {
                        self.header?.endRefreshing()
                        showToast(self.view, (bean?.msg!)!)
                    }
                }catch {
                    self.header?.endRefreshing()
                    showToast(self.view,CATCHMSG)
                }
            case let .failure(error):
                self.header?.endRefreshing()
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }

    }
    
    private func getMoreData(){
        //获取更多数据
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
                        self.doctorData += (bean?.doctorDataList)!
                        self.selectedPage += 1
                        self.infoTableView.reloadData()
                    
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
        // 科室
        case 10004:
            cleanButton()
            sortByDept.setTitleColor(UIColor.APPColor, for: .normal)
        // 点击刷新
        case 10006:
            self.infoTableView.isHidden = false
            button.removeFromSuperview()
            self.header?.beginRefreshing()
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
            let doctor = doctorData[SelectedIndexPath!.row]
            let vc = segue.destination as! Home_DoctorDetail
            vc.doctorBean = doctor
        }
    }
}


