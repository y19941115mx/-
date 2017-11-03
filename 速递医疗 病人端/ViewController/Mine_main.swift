//
//  Mine_main.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_main: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var img_photo: UIImageView!
    @IBOutlet weak var infoTable: UITableView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_id: UILabel!
    
    
    private let tableCell:[String] = ["个人信息", "亲属信息", "我的订单", "我的钱包", "我的设置"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 界面初始化
        updateView()
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let text = tableCell[indexPath.row]
//        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.image = UIImage(named: text)
        cell.textLabel?.text = text
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: tableCell[indexPath.row], sender: self)
    }
    // 更换头像按钮
    @IBAction func click_photo(_ sender: UIButton) {
        AlertUtil.popMenu(vc: self, title: "上传图片", msg: "上传图片", btns: ["拍照","从图库选择"], handler: {_ in })
        
    }
    private func updateView() {
        self.label_id.text = user_default.userId.getStringValue()
        self.label_name.text = user_default.username.getStringValue()
        ImageUtil.setAvator(path: user_default.pix.getStringValue()!, imageView: self.img_photo)
    }
    
    @IBAction func unwindToMine(sender: UIStoryboardSegue) {
        
        
    }
    
    
}
