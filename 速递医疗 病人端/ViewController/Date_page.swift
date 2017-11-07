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

class Date_page: BaseRefreshController<OrderBean>, UICollectionViewDataSource {
    
    @IBOutlet weak var mCollectionView: BaseCollectionView!
    var type:Int = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MineOrderCollectionViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MineOrderCollectionViewCell", owner: nil, options: nil)?.last as? MineOrderCollectionViewCell
            
        }
        let modelBean = data[indexPath.row]
        cell?.updateView(mdata: modelBean)
        
        return cell!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh(scrollView: self.mCollectionView, ApiMethod: API.getorder(selectedPage, LOGINID!, type), refreshHandler: {jsonobj in
            let bean = Mapper<OrderListBean>().map(JSONObject: jsonobj)
            if bean?.code == 100 {
                self.header?.endRefreshing()
                if bean?.OrderDataList == nil {
                    bean?.OrderDataList = [OrderBean]()
                }
                self.data = (bean?.OrderDataList)!
                if self.data.count == 0{
                    //隐藏tableView,添加刷新按钮
                    self.showRefreshBtn()
                }
                let collectionView = self.scrollView as! UICollectionView
                collectionView.reloadData()
            }else {
                self.header?.endRefreshing()
                showToast(self.view, (bean?.msg!)!)
            }
        }, getMoreHandler: getMoreData)
        self.header?.beginRefreshing()
    }
    
    // MARK: - Table view data source

    

    
    private func getMoreData() {
        let Provider = MoyaProvider<API>()
        Provider.request(API.getorder(selectedPage, LOGINID!, type)) { result in
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
                        let tableView = self.scrollView as! UICollectionView
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


