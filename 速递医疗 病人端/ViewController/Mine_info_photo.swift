//
//  Mine_info_photo.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_info_photo: BasePickImgViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    

    @IBOutlet weak var collectionView2: UICollectionView!
    var imgResource = [UIImage]()
    
    @IBOutlet weak var label: UILabel!
    
    
    
    @IBAction func addPicture(_ sender: UIButton) {
        self.updatePicture()
    }
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imgResource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusedCell", for: indexPath)
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = imgResource[indexPath.row]
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        AlertUtil.popAlert(vc: self, msg: "是否移除该图片") {
            self.imgResource.remove(at: indexPath.row)
            self.collectionView2.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "请上传身份证照片"
        self.handler = { selectedImage in
            self.imgResource.append(selectedImage)
            // 显示选中的图片
            self.collectionView2.reloadData()
        }
    }

   
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 0 {
            self.dismiss(animated: false, completion: nil)
        }else {
            // 保存
            let count = imgResource.count
            if count > 0 {
                self.dismiss(animated: false, completion: nil)
                let vc = self.presentingViewController as! Mine_info
                vc.image = self.imgResource
                vc.flag = 1
            }else {
                showToast(self.view, "照片为空")
            }
        }
    }
    
}
