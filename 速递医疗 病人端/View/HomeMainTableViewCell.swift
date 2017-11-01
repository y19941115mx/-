//
//  HomeMainTableViewCell.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/1.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class HomeMainTableViewCell: UITableViewCell {

    @IBOutlet weak var label_desc: UILabel!
    @IBOutlet weak var label_hospital: UILabel!
    @IBOutlet weak var label_distance: UILabel!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var label_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func updateViews(modelBean:DoctorBean) {
        label_desc.text = modelBean.docexpert
        label_name.text = modelBean.name
        label_distance.text = "9"
        label_hospital.text = modelBean.hospital
        ImageUtil.setAvator(path: modelBean.pix!, imageView: pic)
        
    }
    
}
