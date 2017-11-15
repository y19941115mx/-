//
//  AddPublishViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
import ObjectMapper
import SVProgressHUD
import STPopup

let maxImageNum = 4

// 添加病情页面

class Publish_add: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var departTextField: UITextField!
    // 病情描述
    @IBOutlet weak var textView: UITextView!
    var deptPicker = UIPickerView()
    var flagPatient = false
    var dapartPatient = false
    // 就诊人信息
    var familyData = [familyBean]()
    // 就诊人ID
    var family:Int = 0
    // 病情图片
    var imgResource = [UIImage]()
    //科室名
    var oneDepart = ""
    var twoDepart = ""
    var vc_main:STPopupController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        initData()
        let vc_popup1 = UIStoryboard.init(name: "PopUP", bundle: nil).instantiateViewController(withIdentifier: "department")

        vc_main = STPopupController.init(rootViewController:vc_popup1 )
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private Method
    
    
    func initData() {
        imgResource.append(#imageLiteral(resourceName: "add"))
        // 获取亲属信息
        let Provider = MoyaProvider<API>()
        Provider.request(API.findfamily(LOGINID!)) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<familyListBean>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        if bean?.familyDataList == nil {
                            bean?.familyDataList = [familyBean]()
                        }
                        self.familyData = (bean?.familyDataList)!
                    }else{
                        showToast(self.view, bean!.msg!)
                    }
                    
                }catch {
                    showToast(self.view, CATCHMSG)
                }
            case .failure:
                showToast(self.view,ERRORMSG)
            }
        }
        
    }
    
    func pickImageFromPhotoLib() {
        // 从图片库获取图片
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)

    }
    
    
    
    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // 显示选中的图片
        imgResource.insert(selectedImage, at: 0)
        collectionView.reloadData()
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - UITextViewDelegate
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView){
        // 输入文字
        placeHolderLabel.isHidden = true
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 开始编辑文字
        placeHolderLabel.isHidden = true
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
        // 点击了最后一个添加图片
        if indexPath.row == imgResource.count - 1 {
            if imgResource.count <= maxImageNum {
                pickImageFromPhotoLib()
            }else {
                showToast(self.view, "请上传不多于四张图片")
            }
            
        }
    }
    
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        SVProgressHUD.show()
        let Provider = MoyaProvider<API>()
        var datas:[Data]?
        let count = imgResource.count
        if count > 1 {
            datas = [Data]()
            for i in 0..<(count-1){
                datas?.append(ImageUtil.image2Data(image:imgResource[i]))
            }
        }
        
        Provider.request(API.addsick(datas, textView.text, oneDepart, twoDepart, family)) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let bean = Mapper<BaseAPIBean>().map(JSONObject: try response.mapJSON())
                    showToast(self.view, bean!.msg!)
                }catch {
                    SVProgressHUD.dismiss()
                    showToast(self.view, CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
        
    }
    
    // 添加就诊人
    @IBAction func addPatient(_ sender: UIButton) {
        var titles = [String]()
        for bean in familyData {
            titles.append(bean.familyname!)
        }
        AlertUtil.popMenu(vc: self, title: "添加就诊人", msg: "", btns: titles, handler: {result in
            self.flagPatient = true
            let index = titles.index(of: result)!
            self.family = self.familyData[index].familyid
            sender.setTitle(result, for: .normal)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if oneDepart != "" {
            departTextField.text = "\(oneDepart) \(twoDepart)"
        }
    }

   
    @IBAction func click_depart(_ sender: Any) {
        vc_main?.present(in: self)
    }
    
}
