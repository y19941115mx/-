//
//  Mine_main.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import SVProgressHUD
import SnapKit

class Mine_main: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var img_photo: UIImageView!
    @IBOutlet weak var infoTable: UITableView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_id: UILabel!
    
    var msg:String = ""
    
    // 审核状态label
    lazy var stateLabelView:TriLabelView = {
        let triLabelView = TriLabelView()
        triLabelView.position = .BottomRight
        triLabelView.labelText = "审核中"
        triLabelView.viewColor = UIColor.orange
        triLabelView.textColor = UIColor.white
        triLabelView.labelFont = UIFont.systemFont(ofSize: 12)
        triLabelView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(Mine_main.click_state_label))
        triLabelView.addGestureRecognizer(gesture)
        titleView.addSubview(triLabelView)
        triLabelView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(120)
            make.width.equalTo(120)
        }
        return triLabelView
    }()
    
    private let tableCell:[String] = ["个人信息", "亲属信息", "历史订单", "我的钱包", "我的消息","我的设置"]
    private var flags = [false,false,false,false,false,false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 界面初始化
        updateView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        // 更新账号审核状态
        NetWorkUtil.init(method: .getreviewinfo).newRequestWithOutHUD(successhandler: { (bean, json) in
            let data = json["data"]
            let name = data["typename"].stringValue


            let type = data["type"].intValue
            if type == 4 {
                self.stateLabelView.labelText = "审核失败"
                self.msg = data["msg"].stringValue
            }else {
                self.stateLabelView.labelText = name
            }
        })
        
        NetWorkUtil.init(method: .getalipayaccount).newRequestWithOutHUD(successhandler:  { (bean, json) in
            let data = json["data"]
            let str = data["alipayaccount"].stringValue
            
            self.flags[3] = ( str == "" )
            
            self.infoTable.reloadData()
        })
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let text = tableCell[indexPath.row]
        let flag = flags[indexPath.row]
        if let imgView = cell.imageView as? RedPointImageView {
            imgView.isRedPoint = flag
        }
        cell.imageView?.image = UIImage(named: text)
        cell.textLabel?.text = text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: tableCell[indexPath.row], sender: self)
    }
    // 更换头像按钮
    @IBAction func click_photo(_ sender: UIButton) {
        AlertUtil.popMenu(vc: self, title: "上传图片", msg: "上传图片", btns: ["拍照","从图库选择"]) {msg in
            if msg == "拍照" {
                self.pickImageFromPhotoLib(type: 1)
            }else {
                self.pickImageFromPhotoLib(type: 0)
            }
        }
        
    }
    
    
    func pickImageFromPhotoLib(type:Int) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        if type == 1 {
            imagePickerController.sourceType = .camera
        }
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
        // 显示选中的图片
        img_photo.image = selectedImage
        // 上传图片
        let Provider = NetWorkUtil.setRequestTimeout()
        SVProgressHUD.show()
        Provider.request(API.updateinfo(ImageUtil.image2Data(image: selectedImage))) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let bean = Mapper<BaseAPIBean>().map(JSONObject: try response.mapJSON())
                    showToast(self.view, bean!.msg!)
                }catch {
                    SVProgressHUD.dismiss()
                    showToast(self.view, CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: error)
                showToast(self.view, ERRORMSG)
            }
        }
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
    
    
    private func updateView() {
        self.label_id.text = user_default.userId.getStringValue()
        self.label_name.text = user_default.username.getStringValue()
        ImageUtil.setAvator(path: user_default.pix.getStringValue()!, imageView: self.img_photo)
    }
    
    @IBAction func unwindToMine(sender: UIStoryboardSegue) {
        
        
    }
    
    @objc func click_state_label() {
        if msg != "" {
            AlertUtil.popAlert(vc: self, msg: msg, hasCancel: false,okhandler: {})
        }
    }
    
    
}
