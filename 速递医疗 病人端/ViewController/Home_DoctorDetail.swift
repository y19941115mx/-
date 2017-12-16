//
//  PatientDetailViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Home_DoctorDetail: BaseViewController,UICollectionViewDataSource {
    var doctorBean:DoctorBean?
    var dates = [MineCalendarBean]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let doctor = doctorBean{
            nameLabel.text = doctor.name
            titleLabel.text = doctor.docLevel
            deptLabel.text = "\(doctor.primary ?? "") \(doctor.dept ?? "")"
            label_hospital.text = doctor.hospital
            absLabel.text = "简介：\(doctor.docabs ?? "")"
            expertLabel.text = "擅长： \(doctor.docexpert ?? "")"
            ImageUtil.setAvator(path: doctor.pix!, imageView: avator)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetWorkUtil<BaseListBean<MineCalendarBean>>.init(method: .getcalendar((doctorBean?.docId)!)).newRequest { (bean, json) in
            if bean.code == 100 {
                if bean.dataList != nil {
                    self.dates = bean.dataList!
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func click_opt(_ sender: UIButton) {
        NetWorkUtil<BaseAPIBean>.init(method: API.optdoctor((doctorBean?.docId)!)).newRequest{ bean,json in
            showToast(self.view, bean.msg!)
        }
    }
    
}

