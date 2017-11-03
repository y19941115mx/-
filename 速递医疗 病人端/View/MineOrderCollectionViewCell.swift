//
//  MineOrderCollectionViewCell.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class MineOrderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btn_state: UILabel!
    @IBOutlet weak var label_desc: UILabel!
    @IBOutlet weak var label_time: UILabel!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(mdata:OrderBean) {
        label_desc.text = "病情描述：" + mdata.usersickdesc!
        label_name.text = mdata.familyname
        label_time.text = mdata.userorderappointment
        label_title.text = mdata.usersickdesc 
    }

}
