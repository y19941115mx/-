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


class LoginViewController: BaseTextViewController {
    
    //MARK: - property
    
    @IBOutlet weak var view_form: UIView!
    
    @IBOutlet weak var tv_phone: UITextField!
    
    @IBOutlet weak var tv_pwd: UITextField!
    
    @IBOutlet weak var btn_login: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonState()
        initTextFieldDelegate(tv_source: [tv_pwd, tv_phone])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btn_login.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.view_form.center.y = self.view_form.center.y - 100
        })
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.view_form.center.y = self.view_form.center.y + 100
        })
    }
    
    
    
    //MARK: - action
    
    @IBAction func click_login(_ sender: Any) {
        let phoneNum = tv_phone.text!
        let passNum =  tv_pwd.text!
        
        SVProgressHUD.show()
        let Provider = MoyaProvider<API>()
        
        Provider.request(API.login(phoneNum, passNum)) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let bean = Mapper<BaseAPIBean>().map(JSONObject: try response.mapJSON())
                    self.view.makeToast(bean!.msg!)
                }catch {
                    SVProgressHUD.dismiss()
                    self.view.makeToast(CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                self.view.makeToast(ERRORMSG)
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
        
        btn_login.isEnabled = (!phoneText.isEmpty && !password.isEmpty)
        
    }
    
}

