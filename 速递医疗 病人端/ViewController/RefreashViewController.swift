//
//  RefreashViewController.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/4.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import MJRefresh
import Moya
import SnapKit
import ObjectMapper

// 下拉刷新
class TableRefreshController:BaseViewController {
    var header:MJRefreshStateHeader?
    var footer:MJRefreshAutoStateFooter?
    var data = [DoctorBean]()
    var tableView:UITableView?
    var selectedPage = 1
    var ApiMethod:API?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initRefresh(tableView:UITableView, ApiMethod:API) {
        self.tableView = tableView
        self.ApiMethod = ApiMethod
        self.header = MJRefreshNormalHeader(refreshingBlock: self.refreshData)
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true;
        self.tableView?.mj_header = self.header
        
        self.footer = MJRefreshAutoNormalFooter(refreshingBlock: self.getMoreData)
        self.footer?.isRefreshingTitleHidden = true
        self.footer?.setTitle("", for: MJRefreshState.idle)
        self.tableView?.mj_footer = self.footer
    }
    
    private func showRefreshBtn() {
        self.tableView?.isHidden = true
        let button = UIButton()
        //label
        button.setTitle("无内容，点击刷新", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(refreshBtn(button:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
    }
    
    private func refreshData(){
        self.selectedPage = 1
        //刷新数据
        let Provider = MoyaProvider<API>()
        
        Provider.request(ApiMethod!) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<DoctorListBean>().map(JSONObject: try response.mapJSON())
                    
                    if bean?.code == 100 {
                        self.header?.endRefreshing()
                        if bean?.doctorDataList == nil {
                            bean?.doctorDataList = [DoctorBean]()
                        }
                        self.data = (bean?.doctorDataList)!
                        if self.data.count == 0{
                            //隐藏tableView,添加刷新按钮
                            self.showRefreshBtn()
                            return
                        }
                        self.tableView?.reloadData()
                    }else {
                        self.header?.endRefreshing()
                        showToast(self.view, (bean?.msg!)!)
                    }
                }catch {
                    self.header?.endRefreshing()
                    //                    dPrint(message: bean)
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
        
        Provider.request(self.ApiMethod!) { result in
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
                        self.tableView?.reloadData()
                        
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
    @objc func refreshBtn(button:UIButton) {
        // 点击刷新
        self.tableView?.isHidden = false
        button.removeFromSuperview()
        self.header?.beginRefreshing()
    }
    
    
}


// 下拉刷新
class CollectionRefreshController:BaseViewController {
    var header:MJRefreshStateHeader?
    var footer:MJRefreshAutoStateFooter?
    var data = [OrderBean]()
    var collectionView:UICollectionView?
    var selectedPage = 1
    var ApiMethod:API?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initRefresh(collectionView:UICollectionView, ApiMethod:API) {
        self.collectionView = collectionView
        self.ApiMethod = ApiMethod
        self.header = MJRefreshNormalHeader(refreshingBlock: self.refreshData)
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true;
        self.collectionView?.mj_header = self.header
        
        self.footer = MJRefreshAutoNormalFooter(refreshingBlock: self.getMoreData)
        self.footer?.isRefreshingTitleHidden = true
        self.footer?.setTitle("", for: MJRefreshState.idle)
        self.collectionView?.mj_footer = self.footer
    }
    
    private func showRefreshBtn() {
        self.collectionView?.isHidden = true
        let button = UIButton()
        //label
        button.setTitle("无内容，点击刷新", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(refreshBtn(button:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
    }
    
    private func refreshData(){
        self.selectedPage = 1
        //刷新数据
        let Provider = MoyaProvider<API>()
        
        Provider.request(ApiMethod!) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<OrderListBean>().map(JSONObject: try response.mapJSON())
                    
                    if bean?.code == 100 {
                        self.header?.endRefreshing()
                        if bean?.OrderDataList == nil {
                            bean?.OrderDataList = [OrderBean]()
                        }
                        self.data = (bean?.OrderDataList)!
                        if self.data.count == 0{
                            //隐藏tableView,添加刷新按钮
                            self.showRefreshBtn()
                            return
                        }
                        self.collectionView?.reloadData()
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
        
        Provider.request(self.ApiMethod!) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<OrderListBean>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        self.footer?.endRefreshing()
                        if bean?.OrderDataList?.count == 0{
                            showToast(self.view, "已经到底了")
                            return
                        }
                        self.footer?.endRefreshing()
                        self.data += (bean?.OrderDataList)!
                        self.selectedPage += 1
                        self.collectionView?.reloadData()
                        
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
    @objc func refreshBtn(button:UIButton) {
        // 点击刷新
        self.collectionView?.isHidden = false
        button.removeFromSuperview()
        self.header?.beginRefreshing()
    }
    
    
}
