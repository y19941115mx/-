//
//  MyDateTableViewCell.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class MyDateTableViewCell: UITableViewCell {

    @IBOutlet weak var stateDescLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var hosTypeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hospitalLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var vc:BaseRefreshController<OrderBean>?
    var data:OrderBean?
    var flag:Int? // 4 待医生确认 1 病人确认 2 正在进行 3 待评价
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stateLabel.isHidden = true
        stateDescLabel.isHidden = true
        self.selectionStyle = .none
        button.addTarget(self, action: #selector(self.delAction(_:)), for: .touchUpInside)
        
    }
    
    func updateViews(vc:BaseRefreshController<OrderBean>, data:OrderBean) {
        self.vc = vc
        self.data = data
        nameLabel.text = data.familyname!
        descLabel.text = data.usersickdesc!
        priceLabel.text = "\(data.userorderprice!)"
        hospitalLabel.text = data.docaddresslocation!
        timeLabel.text = data.userorderappointment!
        // 动态添加按钮
        if flag == 1 {
            let confirmButton = UIButton()
            confirmButton.layer.cornerRadius = 5
            confirmButton.layer.borderColor = UIColor.red.cgColor
            confirmButton.layer.borderWidth = 1
            confirmButton.setTitle("确认", for: .normal)
            confirmButton.setTitleColor(.red, for: .normal)
            self.contentView.addSubview(confirmButton)
            confirmButton.snp.makeConstraints { (make) in
                make.height.equalTo(30)
                make.width.equalTo(50)
                make.bottom.equalTo(-10)
                make.right.equalTo(-80)
            }
            confirmButton.addTarget(self, action: #selector(self.confirmAction(_:)), for: .touchUpInside)
        } else if flag == 3 {
            button.isHidden = true
            let evaluateButton = UIButton()
            evaluateButton.layer.cornerRadius = 5
            evaluateButton.layer.borderColor = UIColor.blue.cgColor
            evaluateButton.layer.borderWidth = 1
            evaluateButton.setTitle("评价", for: .normal)
            evaluateButton.setTitleColor(.blue, for: .normal)
            self.contentView.addSubview(evaluateButton)
            evaluateButton.snp.makeConstraints { (make) in
                make.height.equalTo(30)
                make.width.equalTo(50)
                make.bottom.equalTo(-10)
                make.right.equalTo(-20)
            }
            evaluateButton.addTarget(self, action: #selector(self.evaluateAction(_:)), for: .touchUpInside)
        }else if flag == 2 {
            if data.userorderstateid! > 4 {
                self.button.isHidden = true
                self.hosTypeLabel.text = "住院地点："
                self.hospitalLabel.text = data.inhospname
                stateLabel.isHidden = false
                stateDescLabel.isHidden = false
                stateDescLabel.text = data.userorderstatename
            }
            if data.userorderstateid! == 5 {
                let evaluateButton = UIButton()
                evaluateButton.layer.cornerRadius = 5
                evaluateButton.layer.borderColor = UIColor.orange.cgColor
                evaluateButton.layer.borderWidth = 1
                evaluateButton.setTitle("取消", for: .normal)
                evaluateButton.setTitleColor(.orange, for: .normal)
                self.contentView.addSubview(evaluateButton)
                evaluateButton.snp.makeConstraints { (make) in
                    make.height.equalTo(30)
                    make.width.equalTo(50)
                    make.bottom.equalTo(-10)
                    make.right.equalTo(-20)
                }
                evaluateButton.addTarget(self, action: #selector(self.delHospAction(_:)), for: .touchUpInside)
            }

            if data.userorderstateid! == 6 {
                let confirmButton = UIButton()
                confirmButton.layer.cornerRadius = 5
                confirmButton.layer.borderColor = UIColor.red.cgColor
                confirmButton.layer.borderWidth = 1
                confirmButton.setTitle("确认", for: .normal)
                confirmButton.setTitleColor(.red, for: .normal)
                self.contentView.addSubview(confirmButton)
                confirmButton.snp.makeConstraints { (make) in
                    make.height.equalTo(30)
                    make.width.equalTo(50)
                    make.bottom.equalTo(-10)
                    make.right.equalTo(-80)
                }
                confirmButton.addTarget(self, action: #selector(self.confirmHospAction(_:)), for: .touchUpInside)
            }
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func delAction(_ sender: UIButton) {
        
        AlertUtil.popAlert(vc: self.vc!, msg: "确认取消订单 该操作不可撤销") {
            let id = self.data?.userorderid
            NetWorkUtil.init(method: API.cancelorder(id!)).newRequest(successhandler: { (bean, josn) in
                    self.vc?.refreshBtn()
            })
        }
    }
    // 支付医院押金
    @objc func confirmHospAction(_ sender: UIButton) {
        AlertUtil.popAlert(vc: self.vc!, msg: "确认支付订单 需要支付\(priceLabel.text ?? "0" )元") {
            let id = self.data?.userorderid
            NetWorkUtil.init(method: API.payhospital(id!)).newRequest(successhandler: { (bean, json) in
                    let str = json["data"].stringValue
                    let alipayUtils = AliPayUtils.init(context: self.vc!);
                    alipayUtils.pay(sign:str)
                
            })
        }
        
    }
    
    
    // 取消住院
    @objc func delHospAction(_ sender: UIButton) {
        
        AlertUtil.popAlert(vc: self.vc!, msg: "确认取消住院 该操作不可撤销") {
            let id = self.data?.userorderid
            NetWorkUtil.init(method: API.cancelhospital(id!)).newRequest(successhandler: {
                (bean, josn) in
                    self.vc?.refreshBtn()
            })
        }
    }
    @objc func confirmAction(_ sender: UIButton) {
        AlertUtil.popAlert(vc: self.vc!, msg: "确认支付订单 需要支付\(priceLabel.text ?? "0" )元") {
            let id = self.data?.userorderid
            NetWorkUtil.init(method: API.confirmorder(id!)).newRequest(successhandler: { (bean, json) in
                    let str = json["data"].stringValue
                    let alipayUtils = AliPayUtils.init(context: self.vc!);
                    alipayUtils.pay(sign:str)
            })
        }
        
    }
    // 跳转到评价页面
    @objc func evaluateAction(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "evaluate") as! UINavigationController
        let vc2 = vc.viewControllers[0] as! EvaluateViewController
        vc2.OdrderId = data?.userorderid
        self.vc?.present(vc, animated: false, completion: nil)
    }
    
}
