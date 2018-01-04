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
    
    //MARK: - property
    
    
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
        NetWorkUtil<BaseAPIBean>.init(method: .login(phoneNum, MD5(passNum))).newRequest { (bean, json) in
            if bean.code == 100 {
                let data = json["data"]
                let userId = data["id"].intValue
                let typename = data["typename"].stringValue
                var account = data["huanxinaccount"].stringValue
                let pix = data["pix"].stringValue
                let token = data["token"].stringValue
                let username = data["username"].stringValue
                let title = data["title"].stringValue
                
                NetWorkUtil<BaseAPIBean>.init(method: API.updatechannelid(userId, user_default.channel_id.getStringValue()!)).newRequestWithOutHUD(handler: { (bean, json) in
                    Toast(bean.msg!)
                })
                user_default.setUserDefault(key: .userId, value: String(userId))
                user_default.setUserDefault(key: .typename, value: typename)
                user_default.setUserDefault(key: .pix, value: pix)
                user_default.setUserDefault(key: .token, value: token)
                user_default.setUserDefault(key: .username, value: username)
                user_default.setUserDefault(key: .title, value: title)
                user_default.setUserDefault(key: .password, value: MD5(passNum))
                // 服务器环信注册失败 重新注册
                if account == "" {
                    NetWorkUtil<BaseAPIBean>.init(method: API.huanxinregister).newRequestWithOutHUD(handler: { (bean, json) in
                        if bean.code == 100 {
                            account = "doc_\(userId)"
                            user_default.setUserDefault(key: .account, value: account)
                            // 注册后登录
                            EMClient.shared().login(withUsername: account, password: MD5(passNum), completion: { (name, error) in
                                if error == nil {
                                    Toast("环信登录成功")
                                }else {
                                    dPrint(message:"环信错误码:\(error?.code.rawValue)")
                                    Toast("环信登录失败")
                                }
                            })
                            
                        }else {
                            Toast("环信注册失败")
                        }
                    })
                } else {
                    user_default.setUserDefault(key: .account, value: account)
                    // 环信直接登录
                    EMClient.shared().login(withUsername: account, password: MD5(passNum), completion: { (name, error) in
                        if error == nil {
                            Toast("环信登录成功")
                        }else {
                            dPrint(message:"环信错误码:\(error?.code.rawValue)")
                            Toast("环信登录失败")
                        }
                    })
                }
                
                user_default.setUserDefault(key: .phoneNum, value: phoneNum)
                // 上传位置信息
                MapUtil.singleLocation(successHandler: {location, reGeocode in
                    if reGeocode != nil {
                        if user_default.userId.getStringValue() != nil {
                            NetWorkUtil.init(method: API.updatelocation(APPLICATION.lon, APPLICATION.lat, (reGeocode?.province)!, (reGeocode?.city)!, (reGeocode?.district)!)).newRequestWithOutHUD(handler: { (bean, json) in
                                if bean.code != 100 {
                                    Toast(bean.msg!)
                                }
                            })
                        }
                    }
                }, failHandler: {})
                let vc_main = MainViewController()
                APPLICATION.window?.rootViewController = vc_main
                
            }else {
                showToast(self.view, bean.msg!)
            }
        }
        
    }
    
    //MARK: - navigation
    @IBAction func unwindToLogin (segue: UIStoryboardSegue) {
        //nothing goes here
        
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

