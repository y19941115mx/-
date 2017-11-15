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
    var vc:UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateView(mData:DoctorBean, vc:UIViewController) {
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
            NetWorkUtil<BaseAPIBean>.init(method: API.createorder((self.data?.docId)!, "2017年12月1日 上午"), vc: self.vc!).newRequest(handler: { bean in
                速递医疗_病人端.showToast((self.vc?.view)!, bean.msg!)
            })
        })
    }

}
