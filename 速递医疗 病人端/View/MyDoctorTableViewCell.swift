//
//  MyDoctorTableViewCell.swift
//  PatientClient
//
//  Created by admin on 2017/10/20.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class MyDoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var avator: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var hospitalLabel: UILabel!
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var label_docType: UILabel!
    var data:DoctorBean?
    var vc:BaseRefreshController<DoctorBean>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateView(mData:DoctorBean, vc:BaseRefreshController<DoctorBean>) {
        self.vc = vc
        self.data = mData
        nameLabel.text = mData.name
        hospitalLabel.text = mData.hospital
        label_docType.text = mData.preordertypename
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
                        stringArray.append("\(date) \(time)")
                        let id = data["doccalendarid"].intValue
                        calenderIds.append(id)
                    }
                    AlertUtil.popMenu(vc: self.vc!, title: "选择医生日程", msg: "", btns: stringArray, handler: { (str) in
                        let index = stringArray.index(of: str)
                        let calenderId = calenderIds[index!]
                        NetWorkUtil<BaseAPIBean>.init(method: .createorder(id!, calenderId)).newRequest(successhandler: { (bean, json) in
                            Toast(bean.msg!)
                            self.vc?.refreshData()
                        })
                    })
                }
            })

        })
    }

}
