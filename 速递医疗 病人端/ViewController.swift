//
//  ViewController.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/10/29.
//  Copyright © 2017 victor. All rights reserved.
//

import UIKit

class ViewController:BaseViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 界面控制
        let userid =  UserDefaultUtil.getUserDefaultStringValue(key: "userId", defaultValue: "")
        if userid == "" {
            // 跳转到登录页面
            let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            APPLICATION.window?.rootViewController = vc_login
        }else {
            let vc_main = MainViewController()
            APPLICATION.window?.rootViewController = vc_main
        }
        
    }
    

}

