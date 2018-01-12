//
//  PatientDetailViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class Home_DoctorDetail: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var opt_btn: UIButton!
    var doctorId:Int!
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetWorkUtil<BaseListBean<MineCalendarBean>>.init(method: .getcalendar(doctorId))
            .newRequest { (bean, json) in
                if bean.code == 100 {
                    if bean.dataList != nil {
                        self.dates = bean.dataList!
                        self.collectionView.reloadData()
                    }
                }
                // 更新top constrains
                if self.dates.count == 0 {
                    self.collectionView.isHidden = true
                    self.height.constant -= 220
                }
        }
        NetWorkUtil.init(method: API.doctorinfo((doctorId)!)).newRequestWithOutHUD { (bean, json) in
            if bean.code == 100 {
                let data = json["data"]
                let abs = data["docabs"].stringValue
                self.absLabel.text = "简介：\(abs)"
                self.nameLabel.text = data["docname"].stringValue
                self.titleLabel.text = data["doctitle"].stringValue
                self.deptLabel.text = "\(data["docprimarydept"].stringValue) \(data["docseconddept"].stringValue)"
                self.label_hospital.text = data["dochosp"].stringValue
                
                self.expertLabel.text = "擅长： \(data["docexpert"].stringValue)"
                            ImageUtil.setAvator(path: data["docloginpix"].stringValue, imageView: self.avator)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH - 50, height: 100)
    }
    
    @IBAction func click_opt(_ sender: UIButton) {
        NetWorkUtil<BaseAPIBean>.init(method: API.optdoctor(doctorId)).newRequest{ bean,json in
            showToast(self.view, bean.msg!)
        }
    }
    
}

