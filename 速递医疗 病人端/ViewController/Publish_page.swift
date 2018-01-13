//
//  AddPageViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import ObjectMapper
import HJPhotoBrowser


// 病情展示分页

class Publish_page: BaseRefreshController<SickBean>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    
    var type: Int = 0
    
    @IBOutlet weak var infoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initNoFooterRefresh(scrollView: infoCollectionView, ApiMethod: .getsick(type), isTableView:false)
        self.header?.beginRefreshing()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type == 2 {
            let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PublishCell2
            let sickBean = data[indexPath.row]
            cell.updataView(sickBean: sickBean, vc: self)
            return cell
        }else{
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PublishCell
            let sickBean = data[indexPath.row]
            cell.updataView(sickBean: sickBean, vc: self)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 单击进入 编辑页面
        if type == 1 {
            let vc = UIStoryboard.init(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "EditSick") as! EditViewController
            vc.bean = data[indexPath.row]
            vc.vc = self
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sickBean = data[indexPath.row]
        if sickBean.usersickpic == nil {
            return CGSize(width: SCREEN_WIDTH - 20, height: 150)
        }else{
            return CGSize(width: SCREEN_WIDTH - 20, height: 250)
        }
    }
    
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: self.infoCollectionView)
        if sender.state == .began {
            let indexPath = self.infoCollectionView.indexPathForItem(at: touchPoint)
            let bean = data[indexPath!.row]
            AlertUtil.popAlert(vc: self, msg: "确定删除病情"){
                NetWorkUtil.init(method: .deletesick(bean.usersickid)).newRequest(handler: { (bean, json) in
                    if bean.code == 100 {
                        self.refreshData()
                    }else {
                        showToast(self.view, bean.msg!)
                    }
                })
            }
        }
    }
    
    
    
    
}

