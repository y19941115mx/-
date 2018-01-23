//
//  Mine_setting.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class Mine_setting: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    lazy var messageObject:UMSocialMessageObject = {
        let shareObject = UMShareWebpageObject.shareObject(withTitle: "速递医运", descr: "让我们更容易找到专家，不再为挂号苦恼。", thumImage: #imageLiteral(resourceName: "logo_blue"))
        //设置网页地址
        shareObject?.webpageUrl = "http://www.dsdoc120.com/"
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject
        return messageObject
    }()
    
    @IBOutlet weak var tableView: BaseTableView!
    let tableTitle = ["应用分享","意见反馈", "退出登录"]
    var tableInfo = ["当前版本号：\(APPVERSION)" ,"让我们做的更好", "点击回到登录界面"]
    
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
        case 0:
            umengShare()
        case 1:
            let vc = FeedBackViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            user_default.logout("")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的设置")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func umengShare() {
        UMSocialUIManager.showShareMenuViewInWindow { (type, userinfo) in
            UMSocialManager.default().share(to: type, messageObject: self.messageObject, currentViewController: self, completion: { (data, error) in
                if error != nil {
                    ToastError("分享失败")
                }
            })
        }
    }
}

class FeedBackViewController:BaseViewController {
    let textView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "意见反馈")
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.APPGrey
        self.view.addSubview(textView)
        let myToolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        let finishBtn = UIBarButtonItem(title: "完成", style: .done, target:self, action: #selector(FeedBackViewController.clickBtn(button:)))
        finishBtn.tag = 10000
        myToolBar.setItems([finishBtn], animated: false)
        textView.inputAccessoryView = myToolBar
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(self.view).multipliedBy(0.4)
        }
        let submitButton = UIButton()
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("提交", for: .normal)
        submitButton.backgroundColor = UIColor.APPColor
        submitButton.addTarget(self, action: #selector(FeedBackViewController.clickBtn(button:)), for: .touchUpInside)
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    @objc func clickBtn(button:UIButton) {
        if button.tag == 10000 {
            self.textView.endEditing(true)
        }else {
            if StringUTil.trimmingCharactersWithWhiteSpaces(self.textView.text) != "" {
                NetWorkUtil.init(method: .addfeedback(self.textView.text)).newRequest(successhandler: { (bean, json) in
                    self.navigationController?.popViewController(animated: false)
                    Toast("提交成功")
                })
            }else {
                showToast(self.view, "信息为空")
            }
        }
    }
    
}
