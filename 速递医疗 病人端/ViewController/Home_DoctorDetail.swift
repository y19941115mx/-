//
//  PatientDetailViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Home_DoctorDetail: BaseViewController {
    var doctorBean:DoctorBean?
    
    @IBOutlet weak var avator: UIImageView!
    @IBOutlet weak var label_hospital: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var describeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let doctor = doctorBean{
            nameLabel.text = doctor.name
            describeLabel.text = doctor.docexpert
            label_hospital.text = doctor.hospital
            ImageUtil.setAvator(path: doctor.pix!, imageView: avator)
        }
        
    }
    
    
    @IBAction func click_opt(_ sender: UIButton) {
        NetWorkUtil<BaseAPIBean>.init(method: API.optdoctor((doctorBean?.docId)!), vc: self).newRequest{ bean in
            showToast(self.view, bean.msg!)
        }
    }
    
}

