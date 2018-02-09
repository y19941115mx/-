//
//  MyDoctorTableViewCell.swift
//  PatientClient
//
//  Created by admin on 2017/10/20.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

enum DoctorType:Int {
    case 推荐医生 = 1
    case 抢单医生 = 2
    case 预选医生 = 4
    
    func getColor() -> UIColor{
        switch self {
        case .抢单医生:
            return UIColor.red
        case .预选医生:
            return UIColor.green
        default:
            return UIColor.brown
        }
    }
    func getText() -> String {
        switch self {
        case .抢单医生:
            return "抢单"
        case .预选医生:
            return "预选"
        default:
            return "推荐"
        }
    }
}

class MyDoctorTableViewCell: UITableViewCell {
    
    var triLabel:TriLabelView!

    @IBOutlet weak var avator: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hospitalLabel: UILabel!
    
    @IBOutlet weak var checkBtn: UIButton!
    
    var data:DoctorBean?
    var vc:BaseRefreshController<DoctorBean>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        triLabel = TriLabelView(frame: bounds)
        triLabel.isUserInteractionEnabled = false
        addSubview(triLabel)
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateView(mData:DoctorBean, vc:BaseRefreshController<DoctorBean>) {
        self.vc = vc
        self.data = mData
        priceLabel.text = "\(mData.preorderprice)元"
        nameLabel.text = mData.name
        hospitalLabel.text = mData.hospital
        triLabel.lengthPercentage = 50
        triLabel.textColor = UIColor.white
        triLabel.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 19)!
        
        let docType = DoctorType.init(rawValue: mData.preordertype)
        if let doc = docType {
            triLabel.labelText = doc.getText()
            triLabel.viewColor = doc.getColor()
        }else {
            triLabel.labelText = "推荐"
            triLabel.viewColor = UIColor.brown
        }
    
        checkBtn.addTarget(self, action: #selector(MyDoctorTableViewCell.checkedBtn(button:)), for: .touchUpInside)
        ImageUtil.setImage(path: mData.pix!, imageView: avator)
        
    }
    
    
    @objc func checkedBtn(button:UIButton) {
        AlertUtil.popAlert(vc: self.vc!, msg: "确定选择该医生", okhandler: {
            let id = self.data?.docId
            NetWorkUtil<BaseAPIBean>.init(method: API.getcalendar(id!)).newRequest(successhandler: { (bean, json) in
                let dataArray = json["data"].array
                
                if dataArray == nil || dataArray!.count == 0 {
                ToastError("该医生无日程安排")
                }else {
                    var stringArray = [String]()
                    var calenderIds = [Int]()
                    for data in dataArray! {
                        let date = data["doccalendarday"].stringValue
                        let time = data["doccalendartime"].stringValue
                        let price = data["doccalendarprice"].doubleValue
                        stringArray.append("\(date) \(time) 价格:\(price)元")
                        let id = data["doccalendarid"].intValue
                        calenderIds.append(id)
                    }
                    AlertUtil.popOptional(optional: stringArray, handler: { (str) in
                        let index = stringArray.index(of: str)
                        let calenderId = calenderIds[index!]
                        NetWorkUtil<BaseAPIBean>.init(method: .createorder(id!, calenderId)).newRequest(successhandler: { (bean, json) in
                            NavigationUtil<Date_main>.setTabBarSonController(index: 3, handler: { (vc) in
                                let sonvc = vc.vcs[0]
                                vc.slideSwitch.selectedIndex = 0
                                sonvc.refreshBtn()
                            })
                        })

                    })
                }
            })

        })
    }

}
