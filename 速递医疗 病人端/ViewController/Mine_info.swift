//
//  Mine_info.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_info: BaseTableInfoViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: BaseTableView!
    var textField = UITextField()
    var image = [UIImage]()
    var flag = 0
    
    @IBOutlet weak var confirmBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageUtil.setButtonDisabledImg(button: confirmBtn)
        let titles =  [["姓名","身份证","身份证照片","性别","年龄","具体地址"]]
        let tableData = [["","","","","", ""]]
        initViewController(tableTiles: titles, tableInfo: tableData, tableView: tableView) { (index_path) in
            self.handleClick(index_path: index_path)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let msg = user_default.typename.getStringValue()
        if msg == "已审核" || msg == "等待审核"{
            confirmBtn.isEnabled = false
            confirmBtn.setTitle(msg, for: .normal)
            self.tableView.allowsSelection = false
        }else {
            confirmBtn.isEnabled = true
            confirmBtn.setTitle("提交审核", for: .normal)
            self.tableView.allowsSelection = true
        }
        
        NetWorkUtil.init(method: .getinfo).newRequest(successhandler: { (bean, json) in
            let data = json["data"]
            let username = data["username"].string ?? self.tableInfo[0][0]
            let usercardnum = data["usercardnum"].string ?? self.tableInfo[0][1]
            
            if self.flag != 0 {
                self.tableInfo[0][2] = "已上传"
            }
            
            if data["usercardphoto"].string != nil && data["usercardphoto"].string != "" {
                var imageString = StringUTil.splitImage(str: data["usercardphoto"].string!)
                // 添加图片
                for str in imageString {
                    self.image.append(ImageUtil.URLToImg(url: URL.init(string: str)!))
                }
                
                self.tableInfo[0][2] = "已上传"
            }
            let usermale = data["usermale"].string ?? self.tableInfo[0][3]
            let userage = "\(data["userage"].intValue)"
            let useradrother = data["useradrother"].string ?? self.tableInfo[0][5]
            self.tableInfo = [[username, usercardnum, self.tableInfo[0][2], usermale, userage, useradrother]]
            self.tableView.reloadData()
        })
    }
    
    // 提交审核
    @IBAction func click_save(_ sender: UIButton) {
        for i in 0 ..< tableInfo[0].count - 1 {
            if tableInfo[0][i] == "" {
                showToast(self.view, "请输入完整信息")
                return
            }
        }
        let count = image.count
        if count > 0 {
            var datas = [Data]()
            for i in 0..<count{
                datas.append(ImageUtil.image2Data(image:image[i]))
            }
            NetWorkUtil.init(method: .editinfo(tableInfo[0][0], tableInfo[0][1], datas, tableInfo[0][3], Int(tableInfo[0][4])!, tableInfo[0][5])).newRequestWithOutHUD(successhandler: { (bean, json) in
                NetWorkUtil.init(method: .reviewinfo).newRequestWithOutHUD(successhandler: { (bean, sjon) in
                    self.dismiss(animated: false, completion: nil)
                    Toast(bean.msg!)
                },failhandler:{ (bean, sjon) in
                    showToast(self.view, bean.msg!)
                })
            },failhandler:{ (bean, sjon) in
                showToast(self.view, bean.msg!)
            })
        }else {
            showToast(self.view, "照片为空")
        }
    }
    
    
    
    private func  handleClick(index_path:IndexPath) {
        switch index_path.row {
        case 0:
            self.textField.placeholder = "请输入姓名"
            self.textField.keyboardType = .default
            AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                let text = textfields[0].text ?? ""
                if text != "" {
                    self.tableInfo[0][0] = text
                    self.tableView.reloadRows(at: [index_path], with: .none)
                }
            })
        case 1:
            self.textField.placeholder = "请输入身份证号"
            self.textField.keyboardType = .default
            AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                let text = textfields[0].text ?? ""
                if text != "" {
                    self.tableInfo[0][1] = text
                    self.tableView.reloadRows(at: [index_path], with: .none)
                }
            })
        case 2:
            // 跳转上传图片页面 传入 addPhoto
            let imagesData = image
            let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "addPhoto") as! Mine_info_photo
                vc.imgResource = imagesData
            image = [UIImage]()
            self.present(vc, animated: false, completion: nil)
        case 3:
            AlertUtil.popOptional(optional: ["男", "女"], handler: { (str) in
                self.tableInfo[0][3] = str
                self.tableView.reloadRows(at: [index_path], with: .none)

            })
        case 4:
            self.textField.placeholder = "请输入年龄"
            self.textField.keyboardType = .numberPad
            AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                let text = textfields[0].text ?? ""
                if text != "" {
                    self.tableInfo[0][4] = text
                    self.tableView.reloadRows(at: [index_path], with: .none)
                }
            })
        default:
            self.textField.placeholder = "请输入具体住址"
            self.textField.keyboardType = .default
            AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                let text = textfields[0].text ?? ""
                if text != "" {
                    self.tableInfo[0][5] = text
                    self.tableView.reloadRows(at: [index_path], with: .none)
                }
            })
        }
    }
    
}
