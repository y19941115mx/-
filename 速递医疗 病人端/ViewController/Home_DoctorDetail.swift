//
//  PatientDetailViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class Home_DoctorDetail: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var opt_btn: UIButton!
    var doctorId:Int!
    var account:String?
    var docName:String?
    var dates = [MineCalendarBean]()
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var avator: UIImageView!
    @IBOutlet weak var label_hospital: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var absLabel: UILabel!
    @IBOutlet weak var expertLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SetDateCollectionViewCell
        let bean = dates[indexPath.row]
        cell.updateView(data: bean)
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "医生详情")
        collectionView.showsVerticalScrollIndicator = true
        let buttonItem = UIBarButtonItem.init(title: "评价", style: .plain, target: self, action: #selector(getEvaluate(_:)))
        self.navigationItem.rightBarButtonItem = buttonItem
        NetWorkUtil<BaseListBean<MineCalendarBean>>.init(method: .getcalendar(doctorId))
            .newRequest(successhandler: { (bean, json) in
                if bean.dataList != nil {
                    self.dates = bean.dataList!
                    self.collectionView.reloadData()
                }
                // 更新top constrains
                if self.dates.count == 0 {
                    self.collectionView.isHidden = true
                    self.height.constant -= 220
                }
            })
        NetWorkUtil.init(method: API.doctorinfo((doctorId)!)).newRequestWithOutHUD(successhandler: { (bean, json) in
            if bean.code == 100 {
                let data = json["data"]
                let abs = data["docabs"].stringValue
                self.account = data["dochuanxinaccount"].stringValue
                self.absLabel.text = "简介：\(abs)"
                self.docName = data["docname"].stringValue
                self.nameLabel.text = self.docName
                self.titleLabel.text = data["doctitle"].stringValue
                let flag = data["selected"].boolValue
                if flag {
                    self.opt_btn.setTitle("已经预选", for: .normal)
                    self.opt_btn.backgroundColor = UIColor.gray
                    self.opt_btn.isEnabled = false
                }
                self.deptLabel.text = "\(data["docprimarydept"].stringValue) \(data["docseconddept"].stringValue)"
                self.label_hospital.text = data["dochosp"].stringValue
                
                self.expertLabel.text = "擅长： \(data["docexpert"].stringValue)"
                ImageUtil.setAvator(path: data["docloginpix"].stringValue, imageView: self.avator)
            }
        }) 
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bean = dates[indexPath.row]
        let str = bean.doccalendaraffair ?? ""
        var inset:CGFloat = 0
        if str != "" {
            inset = str.getTextRectSize(font: UIFont.systemFont(ofSize: 14), size: CGSize.init(width: SCREEN_WIDTH - 10, height: 600)).height
        }
        
        return CGSize(width: SCREEN_WIDTH - 40, height: 50 + inset)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bean = dates[indexPath.row]
        AlertUtil.popAlert(vc: self, msg: "确定选择该日程 需要支付\(bean.doccalendarprice)元") {
            AlertUtil.popMenu(vc: self, title: "选择支付方式", msg: "", btns: ["支付宝","微信"], handler: { (str) in
                var type = 1
                if str == "微信" {
                    type = 2
                }
                NetWorkUtil.init(method: API.createquickorder(self.doctorId, bean.doccalendarid, type)).newRequest(successhandler: { (bean, json) in
                    let paystr = json["data"].stringValue
                    NavigationUtil<Date_main>.setTabBarSonController(index: 3, handler: { (vc) in
                        let sonvc = vc.vcs[2]
                        vc.slideSwitch.selectedIndex = 2
                        if type == 1 {
                            let manager = AliPayManager.sharedManager(context: sonvc)
                            manager.pay(sign:paystr)
                        }else {
                            let manager = WeChatPayManager.sharedManager(context: sonvc)
                            manager.pay(ResJson: json["data"])
                        }
                    
                    })
                })
            })
        }
    }
    
    // 获取评价
    @objc func getEvaluate(_ sender:UIButton) {
        let vc = EvaluateTableViewController()
        vc.docId = self.doctorId
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func sixin(_ sender: UIButton) {
        if account == nil || account == "" {
            Toast("环信账号异常")
            return
        }
        let viewController = ChatViewController.init(conversationChatter: self.account, conversationType: EMConversationTypeChat)
        viewController?.setUpNavTitle(title: (self.docName)!)
        viewController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController!, animated: false)
    }
    
    @IBAction func click_opt(_ sender: UIButton) {
        NetWorkUtil<BaseAPIBean>.init(method: API.optdoctor(doctorId)).newRequest(successhandler: { bean,json in
            NavigationUtil<MyDoctor_main>.setTabBarSonController(index: 2, handler: { (vc) in
                vc.refreshBtn()
            })
        
        })
    }
    
}

