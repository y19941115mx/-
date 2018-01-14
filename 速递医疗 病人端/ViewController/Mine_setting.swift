//
//  Mine_setting.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_setting: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: BaseTableView!
    let tableTitle = ["意见反馈", "退出登录"]
    var tableInfo = ["让我们做的更好" , "点击回到登录界面"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label1 = cell.viewWithTag(1) as! UILabel
        let label2 = cell.viewWithTag(2) as! UILabel
        label1.text = tableTitle[indexPath.row]
        label2.text = tableInfo[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            user_default.logout("")
        default:
            Toast("功能完善中")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的设置")
        // Do any additional setup after loading the view.
    }

    
   

}
