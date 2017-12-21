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
    let tableTitle = ["绑定支付宝", "版本更新", "退出登录"]
    var tableInfo = ["未设置","更新软件版本" , "点击回到登录界面"]
    
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
        case 0:
            // 绑定支付宝
            let textField = UITextField()
            textField.placeholder = "输入支付宝账号"
            // 绑定支付宝
            AlertUtil.popTextFields(vc: self, title: "输入支付宝账号", textfields: [textField], okhandler: { (textFields) in
                let account = textFields[0].text ?? ""
                if account == "" {
                    showToast(self.view, "请填写账号")
                }else {
                    NetWorkUtil.init(method: API.updatealipayaccount(account)).newRequest(handler: { (bean, json) in
                        showToast(self.view, bean.msg!)
                        if bean.code == 100 {
                            self.tableInfo[0] = account
                            self.tableView.reloadData()
                        }
                        
                    })
                }
                
            })
        case 1:
            showToast(self.view, "功能完善中")
        default:
            logout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的设置")
        NetWorkUtil.init(method: .getalipayaccount).newRequestWithOutHUD { (bean, json) in
            let data = json["data"]
            let str = data["alipayaccount"].stringValue
            if str != "" {
                self.tableInfo[0] = str
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    
    private func logout() {
        NetWorkUtil<BaseAPIBean>.init(method: .exit).newRequest { (bean, json) in
            if bean.code == 100 {
                user_default.clearUserDefaultValue()
                let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
                EMClient.shared().logout(false, completion: { (error)
                    in
                    if error == nil {
                        Toast("环信退出成功")
                    }else {
                        Toast("环信退出失败")
                    }
                })
                APPLICATION.window?.rootViewController = vc_login
            }else {
                Toast(bean.msg!)
            }
        }
        
    }

}
