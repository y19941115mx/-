//
//  Mine_setting.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_setting: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    lazy var shareArray: [Any] = {
        var shareArray = [Any]()
        ///使用预制默认图片、title和分享事件
        shareArray.append(PlatformNameSms)
        shareArray.append(PlatformNameEmail)
        shareArray.append(PlatformNameSina)
        shareArray.append(PlatformNameWechat)
        
        ///自定义图片和title,使用预制默认分享事件
        shareArray.append(ShareItem(image: UIImage(named: "IFMShareImage.bundle/share_qq")!, title: "QQ", actionName: PlatformHandleQQ))
        
        ///自定义图片、title和事件
//        shareArray.append(ShareItem(image: UIImage(named: "IFMShareImage.bundle/share_alipay")!, title: "支付宝", callBack: {(_ item: ShareItem) -> Void in
//            ShareView.alertMsg("提示", "点击了支付宝", self)
//        }))
        return shareArray
    }()
    
    
    @IBOutlet weak var tableView: BaseTableView!
    let tableTitle = ["应用分享", "退出登录"]
    var tableInfo = ["当前版本号：\(APPVERSION)" , "点击回到登录界面"]
    
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
//            应用分享
            showSquaredStyle()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的设置")
        // Do any additional setup after loading the view.
    }
    
    func showSquaredStyle() {
        var shareView = ShareView(items: shareArray, countEveryRow: 4)
        shareView.itemImageSize = CGSize(width: 45, height: 45)
        shareView = addShareContent(shareView)
        //    shareView.itemSpace = 10;
        shareView.show(fromControlle: self)
    }
    
    func addShareContent(_ shareView: ShareView) -> ShareView {
        shareView.addText("分享测试")
        shareView.addUrl(URL(string: "http://www.baidu.com"))
        shareView.addImage(UIImage(named: "function_collection"))
        return shareView
    }

    
   

}
