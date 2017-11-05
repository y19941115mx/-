//
//  PublishCell.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/5.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class PublishCell: UICollectionViewCell, UICollectionViewDataSource {

    @IBOutlet weak var label_desc: UILabel!
    @IBOutlet weak var label_age: UILabel!
    @IBOutlet weak var label_sex: UILabel!
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var btn_publish: UIButton!
    @IBOutlet weak var btn_del: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageSource = [String]()
    var data:SickBean?
    var vc:UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
    }
    
    func updataView(sickBean:SickBean, vc:UIViewController) {
        self.data = sickBean
        self.vc = vc
        label_name.text = sickBean.familyname
        label_sex.text = sickBean.familymale
        label_age.text = "\(sickBean.familyage)"
        label_desc.text = sickBean.usersickdesc
        if sickBean.usersickpic == nil {
            imageSource = []
        }else{
            // 子collectionView 数据绑定
            imageSource = StringUTil.splitImage(str: sickBean.usersickpic!)
        }
        btn_publish.addTarget(self, action: #selector(PublishAction(button:)), for: .touchUpInside)
        btn_del.addTarget(self, action: #selector(DelAction(button:)), for: .touchUpInside)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sonCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: imageSource[indexPath.row])
        return cell
    }
    
    @objc func PublishAction(button:UIButton) {
        AlertUtil.popAlert(vc: vc!, msg: "确认发布病情: \(data?.familyname)", okhandler: { dPrint(message: "点击确认") })
    }
    
    @objc func DelAction(button:UIButton) {
        AlertUtil.popAlert(vc: vc!, msg: "确认删除病情: \(data?.familyname)", okhandler: { dPrint(message: "点击删除") })
    }

}
