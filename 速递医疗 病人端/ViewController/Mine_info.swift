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
    var image:Data?
//    var flags = [fal]
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles =  [["姓名","身份证","身份证照片","性别","年龄","具体地址"]]
        let tableData = [["输入姓名","输入身份证","未上传","选择性别","0", "输入具体地址"]]
        initViewController(tableTiles: titles, tableInfo: tableData, tableView: tableView) { (index_path) in
            self.handleClick(index_path: index_path)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func click_save(_ sender: UIButton) {
        NetWorkUtil.init(method: .editinfo(tableInfo[0][0], tableInfo[0][1], self.image!, tableInfo[0][3], Int(tableInfo[0][4])!, tableInfo[0][5])).newRequest { (bean, json) in
            showToast(self.view, bean.msg!)
            if bean.code == 100 {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func  handleClick(index_path:IndexPath) {
        switch index_path.row {
        case 0:
            self.textField.placeholder = "请输入姓名"
            self.textField.keyboardType = .default
            AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                let text = textfields[0].text ?? ""
                self.tableInfo[0][0] = text
                self.tableView.reloadRows(at: [index_path], with: .none)
            })
        case 1:
            self.textField.placeholder = "请输入身份证号"
            self.textField.keyboardType = .default
            AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                let text = textfields[0].text ?? ""
                self.tableInfo[0][1] = text
                self.tableView.reloadRows(at: [index_path], with: .none)
            })
        case 2:
            pickImageFromPhotoLib()
        case 3:
            AlertUtil.popMenu(vc: self, title: "选择性别", msg: "", btns: ["男", "女"], handler: { (str) in
                self.tableInfo[0][3] = str
                self.tableView.reloadRows(at: [index_path], with: .none)
            })
        case 4:
            self.textField.placeholder = "请输入年龄"
            self.textField.keyboardType = .numberPad
            AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                let text = textfields[0].text ?? ""
                self.tableInfo[0][4] = text
                self.tableView.reloadRows(at: [index_path], with: .none)
            })
        default:
            self.textField.placeholder = "请输入具体住址"
            self.textField.keyboardType = .default
            AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                let text = textfields[0].text ?? ""
                self.tableInfo[0][5] = text
                self.tableView.reloadRows(at: [index_path], with: .none)
            })
        }
    }
        
        override func viewDidAppear(_ animated: Bool) {
            NetWorkUtil.init(method: .getinfo).newRequest { (bean, json) in
                let data = json["data"]
                let username = data["username"].string ?? self.tableInfo[0][0]
                let usercardnum = data["usercardnum"].string ?? self.tableInfo[0][1]
                
                if data["usercardphoto"].string != nil {
                    self.tableInfo[0][2] = "已上传"
                }
                let usermale = data["usermale"].string ?? self.tableInfo[0][3]
                let userage = data["userage"].string ?? self.tableInfo[0][4]
                let useradrother = data["useradrother"].string ?? self.tableInfo[0][5]
                self.tableInfo = [[username, usercardnum, self.tableInfo[0][2], usermale, userage, useradrother]]
                self.tableView.reloadData()
            }
            
        }
        
       private func pickImageFromPhotoLib() {
            let imagePickerController = UIImagePickerController()
            
            // Only allow photos to be picked, not taken.
            imagePickerController.sourceType = .photoLibrary
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
            
        }
        
        //MARK:- UIImagePickerControllerDelegate
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
            // Dismiss the picker if the user canceled.
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            // 储存选中的图片
            self.image = ImageUtil.image2Data(image: selectedImage)
            self.tableInfo[0][2] = "已上传"
            self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
            // Dismiss the picker.
            dismiss(animated: true, completion: nil)
        }
        
    @IBAction func click_confirm(_ sender: Any) {
        // 提交审核
        NetWorkUtil.init(method: .reviewinfo).newRequest { (bean, json) in
            if bean.code == 100 {
                self.dismiss(animated: false, completion: nil)
            }
            showToast(self.view, bean.msg!)
        }
    }
    
}
