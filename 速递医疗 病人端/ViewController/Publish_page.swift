//
//  AddPageViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit


// 病情展示分页

class Publish_page: SickCollectionRefreshController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var type: Int = 0
    
    @IBOutlet weak var infoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh(collectionView: infoCollectionView, ApiMethod: API.getsick(type))
        self.header?.beginRefreshing()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusedCell", for: indexPath) as? PublishCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PublishCell", owner: nil, options: nil)?.last as? PublishCell
        }
        let sickBean = data[indexPath.row]
        cell?.updataView(sickBean: sickBean, vc: self)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sickBean = data[indexPath.row]
        if sickBean.usersickpic == nil {
            return CGSize(width: SCREEN_WIDTH - 20, height: 150)
        }else{
            return CGSize(width: SCREEN_WIDTH - 20, height: 240)
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
//            let SelectedIndexPath = collectionView.indexPathsForSelectedItems
//            checkedIndexRow = SelectedIndexPath?[0].row
//            let sick = data[checkedIndexRow!]
//            let vc = segue.destination as! EditViewController
//            vc.descString = sick.desc
        }
    }
    
    //MARK: - navigation Methond
    @IBAction func unwindToPublishPage(sender: UIStoryboardSegue){
        // 编辑病情
//        if let sourceViewController = sender.source as? EditViewController, let editString = sourceViewController.editString {
//            data[checkedIndexRow!].desc = editString
//            collectionView.reloadData()
//        }
        // 保存病情
        
    }
    
}

