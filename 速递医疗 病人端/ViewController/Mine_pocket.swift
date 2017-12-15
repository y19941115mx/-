//
//  Mine_pocket.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class Mine_pocket: BaseRefreshController<MineTradeBean>, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: BaseCollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MinePocketCollectionViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MinePocketCollectionViewCell", owner: nil, options: nil)?.last as? MinePocketCollectionViewCell
        }
        let bean = data[indexPath.row]
        cell?.updataView(bean:bean)
        
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initRefresh(scrollView: collectionView, ApiMethod: API.listtraderecord(selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = API.listtraderecord(self.selectedPage)
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
