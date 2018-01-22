//
//  EvaluateTableViewCell.swift
//  速递医疗 病人端
//
//  Created by hongyiting on 2018/1/13.
//  Copyright © 2018年 victor. All rights reserved.
//

import UIKit

class EvaluateTableViewCell: UITableViewCell {

    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var priceLevel: RatingController!
    @IBOutlet weak var professionLevel: RatingController!
    @IBOutlet weak var serviceLevel: RatingController!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateView(data:EvaluateBean) {
        nameLabel.text = data.doccommentpatientname
        professionLevel.rating = data.doccommentprofessionallevel!
        priceLevel.rating = data.doccommentpricelevel!
        serviceLevel.rating = data.doccommentservicelevel!
        commentLabel.text = data.doccommentwords
        let res = StringUTil.getTextRectSize(text: data.doccommentwords! as NSString, font: commentLabel.font, size: CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        dPrint(message: res.height)
        height.constant = res.height
    }
    
}
