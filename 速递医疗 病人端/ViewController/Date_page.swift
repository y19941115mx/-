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
        initRefresh(scrollView: self.mCollectionView, ApiMethod: API.getorder(selectedPage, Int(user_default.userId.getStringValue()!)!, type), refreshHandler: {
            
        },getMoreHandler: {
            self.getMoreMethod = API.getorder(self.selectedPage, Int(user_default.userId.getStringValue()!)!, self.type)
        }, isTableView: false)
        
        self.header?.beginRefreshing()

    }
    
    // MARK: - Table view data source


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


