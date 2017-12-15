//
//  Mine_order.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import SVProgressHUD
import ObjectMapper

class Mine_order: BaseRefreshController<OrderBean>, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: BaseCollectionView!
    
    
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
        initRefresh(scrollView: collectionView, ApiMethod: .gethistoryorder(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod  = .gethistoryorder(self.selectedPage)
        }, isTableView: false)
        self.header?.beginRefreshing()
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
