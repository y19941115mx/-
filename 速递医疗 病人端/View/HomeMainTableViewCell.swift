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
    
    var bean:DoctorBean?
    var vc:BaseRefreshController<DoctorBean>?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func updateViews(modelBean:DoctorBean, vc:BaseRefreshController<DoctorBean>) {
        self.bean = modelBean
        self.vc = vc
        label_desc.text = modelBean.docexpert
        label_name.text = modelBean.name
        label_distance.text = StringUTil.transformDistance(modelBean.distance)
        label_hospital.text = modelBean.hospital
        ImageUtil.setAvator(path: modelBean.pix!, imageView: pic)
        
    }
    
    @IBAction func BeginChat(_ sender: Any) {
        let viewController = ChatViewController.init(conversationChatter: bean?.account, conversationType: EMConversationTypeChat)
        viewController?.setUpNavTitle(title: (bean?.name)!)
        viewController?.hidesBottomBarWhenPushed = true
        self.vc?.navigationController?.pushViewController(viewController!, animated: false)
    }
    
}
