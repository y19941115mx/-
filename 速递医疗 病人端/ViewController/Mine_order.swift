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

class Mine_order: UIViewController, UICollectionViewDataSource {
    var data = [OrderBean]()
    var type:Int = 0
    
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
        getData()
    }
    
    private func getData() {
        let Provider = MoyaProvider<API>()
        SVProgressHUD.show()
        Provider.request(API.getorder(1, Int(user_default.userId.getStringValue()!)!, type)) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let bean = Mapper<OrderListBean>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        if bean?.OrderDataList == nil {
                            bean?.OrderDataList = [OrderBean]()
                        }
                        self.data = (bean?.OrderDataList)!
                        self.collectionView.reloadData()
                    }else {
                        showToast(self.view, bean!.msg!)
                    }
                }catch {
                    SVProgressHUD.dismiss()
                    showToast(self.view,CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
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
