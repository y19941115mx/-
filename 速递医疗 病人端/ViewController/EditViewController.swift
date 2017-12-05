//
//  EditViewController.swift
//  速递医疗 病人端
//
//  Created by hongyiting on 2017/12/5.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class EditViewController: BaseViewController {
    @IBOutlet weak var textView: UITextView!
    var bean:SickBean?
    var vc:BaseRefreshController<SickBean>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sick = bean {
            textView.text = sick.usersickdesc
        }
    }
    
    //MARK: - Action
    
    @IBAction func Save_action(_ sender: Any) {
        let text = textView.text ?? ""
        NetWorkUtil<BaseAPIBean>.init(method: .editsick((bean?.usersickid)!, text)).newRequest { (bean, json) in
            if bean.code == 100 {
                self.dismiss(animated: false, completion: nil)
            }
            self.vc?.header?.beginRefreshing()
            Toast(bean.msg!)
            
        }
    }
    @IBAction func Back_acion(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
