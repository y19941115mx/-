//
//  Mine_pocket.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class Trade_recode: BaseRefreshController<MineTradeBean>, UICollectionViewDataSource {


    
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
        setUpNavTitle(title: "交易记录")
        initRefresh(scrollView: collectionView, ApiMethod: API.listtraderecord(selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = API.listtraderecord(self.selectedPage)
        }, isTableView: false)
        self.header?.beginRefreshing()
    }

}

class Mine_pocket: BaseTableViewController {
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var flagLabel: RedPointLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的钱包")
        NetWorkUtil.init(method: .getalipayaccount).newRequestWithOutHUD(successhandler: { (bean, json) in
            let data = json["data"]
            let str = data["alipayaccount"].stringValue
            if str != "" {
                self.stateLabel.text = str
            }else {
                self.flagLabel.isRedPoint = true
            }
        }) 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let textField = UITextField()
            textField.placeholder = "输入支付宝账号"
            let textField2 = UITextField()
            textField2.placeholder = "输入支付宝认证的姓名"
            // 绑定支付宝
            AlertUtil.popTextFields(vc: self, title: "输入支付宝账号", textfields: [textField, textField2], okhandler: { (textFields) in
                let account = textFields[0].text ?? ""
                let name = textFields[1].text ?? ""
                if account == "" || name == ""{
                    showToast(self.view, "请填写完整信息")
                }else {
                    NetWorkUtil.init(method: API.updatealipayaccount(account, name)).newRequest(successhandler:{ (bean, json) in
                        self.stateLabel.text = account
                    })
                }
                
            })
        }
    }
    
    
    
    
    
    @IBAction func back_action(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
}
