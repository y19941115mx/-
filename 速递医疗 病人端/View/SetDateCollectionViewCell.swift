//
//  SetDateCollectionViewCell.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/9.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class SetDateCollectionViewCell: UICollectionViewCell {
    var data:MineCalendarBean?
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func updateView(data:MineCalendarBean) {
        self.data = data
        descLabel.text = self.data!.doccalendaraffair ?? ""
        timeLabel.text = "\( self.data!.doccalendarday!) \(self.data!.doccalendartime!)"
        locLabel.text =  self.data!.docaddresslocation!
    }
    
}
