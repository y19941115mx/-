//
//  ViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/7.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD
import Moya
import Toast_Swift
import ObjectMapper
import SwiftHash
import SwiftyJSON


class LoginViewController: BaseTextViewController {
    
    //MARK: - property register
    
    lazy var resetVc:ResetViewController = {
        let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "reset") as! ResetViewController
        vc.LoginVc = self
        return vc
    }()
    lazy var registerVc:RegisterViewController = {
        let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "register") as! RegisterViewController
         vc.LoginVc = self
        return vc
    }()
    
    @IBOutlet weak var tv_phone: UITextField!
    
    @IBOutlet weak var tv_pwd: UITextField!
    
    @IBOutlet weak var btn_login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonState()
        // 界面设置
        initTextFieldDelegate(tv_source: [tv_pwd, tv_phone], updateBtnState: updateButtonState)
        if user_default.phoneNum.getStringValue() != nil {
            tv_phone.text = user_default.phoneNum.getStringValue()
        }
    }
    
    //MARK: - action
    @IBAction func click_login(_ sender: Any) {
        self.view.endEditing(true)
        let phoneNum = tv_phone.text!
        let passNum =  tv_pwd.text!
        
        // FIXME:  需要做字符串验证
        // 登录
        NetWorkUtil<BaseAPIBean>.init(method: .login(phoneNum, MD5(passNum))).newRequest(successhandler: { (bean, json) in
            let data = json["data"]
            let userId = data["id"].intValue
            let typename = data["typename"].stringValue
            var account = data["huanxinaccount"].stringValue
            let pix = data["pix"].stringValue
            let token = data["token"].stringValue
            let username = data["username"].stringValue
            let title = data["title"].stringValue
            // 上传chanelid
            NetWorkUtil<BaseAPIBean>.init(method: API.updatechannelid(userId, user_default.channel_id.getStringValue()!)).newRequestWithOutHUD(successhandler: { (bean, json) in
                Toast(bean.msg!)
            })
            // 储存数据
            
            user_default.setUserDefault(key: .userId, value: String(userId))
            user_default.setUserDefault(key: .typename, value: typename)
            user_default.setUserDefault(key: .pix, value: pix)
            user_default.setUserDefault(key: .token, value: token)
            user_default.setUserDefault(key: .username, value: username)
            user_default.setUserDefault(key: .title, value: title)
            user_default.setUserDefault(key: .password, value: MD5(passNum))
            
            // 注册环信
            if account == "" {
                NetWorkUtil.init(method: .huanxinregister).newRequestWithOutHUD(successhandler: { (bean, sjon) in
                    account = "user_\(userId)"
                })
            }
            user_default.setUserDefault(key: .account, value: account)
            user_default.setUserDefault(key: .phoneNum, value: phoneNum)
            // 地理位置上传
            MapUtil.singleLocation(successHandler: { (location, code) in
                if let code = code {
                    if user_default.userId.getStringValue() != nil {
                        NetWorkUtil.init(method: API.updatelocation(APPLICATION.lon, APPLICATION.lat,code.province, code.city, code.district)).newRequestWithOutHUD(successhandler: nil)
                    }
                }
            }, failHandler: {})
            // 进入首页
            let vc_main = MainViewController()
            APPLICATION.window?.rootViewController = vc_main
            
        })
    }
    
    @IBAction func resetAction(_ sender: Any) {
        NavigationUtil.setRootViewController(vc: self.resetVc)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        NavigationUtil.setRootViewController(vc: self.registerVc)
    }
    
    
    //MARK: - private method
    private func updateButtonState() {
        // Disable the  button if the text field is empty.
        let phoneText = tv_phone.text ?? ""
        let password = tv_pwd.text ?? ""
        ImageUtil.setButtonDisabledImg(button: btn_login)
        btn_login.isEnabled = (!phoneText.isEmpty && !password.isEmpty)
        
    }
    
}

