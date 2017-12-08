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

let maxImageNum = 4

// 添加病情页面

class Publish_add: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var departTextField: UITextField!
    // 病情描述
    @IBOutlet weak var textView: UITextView!
    var deptPicker = UIPickerView()
    var flagPatient = false
    var dapartPatient = false
    // 科室信息
    var departData = [String:[String]]()
    var proIndex:Int = 0
    // 就诊人信息
    var familyData = [familyBean]()
    // 就诊人ID
    var family:Int = 0
    // 病情图片
    var imgResource = [UIImage]()
    //科室名
    var oneDepart = ""
    var twoDepart = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        initData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private Method
    func setInputView(mPicker:UIPickerView, mTextField:UITextField){
        // 关联textfield 与 pickerView
        let myToolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - 44 - mPicker.frame.size.height , width: view.frame.size.width, height: 44))
        let finishBtn = UIBarButtonItem(title: "完成", style: .done, target:self, action: #selector(clickBtn(button:)))
        finishBtn.tag = mPicker.tag
        myToolBar.setItems([finishBtn], animated: false)
        
        mPicker.delegate = self
        mPicker.dataSource = self
        //样式尺寸
        mPicker.backgroundColor = UIColor.white
        mTextField.inputView = mPicker
        mTextField.inputAccessoryView = myToolBar
    }
    
    func initData() {
        imgResource.append(#imageLiteral(resourceName: "add"))
         //获取部门数据
       NetWorkUtil.getDepartMent(success: { response in
            let json = JSON(response)
            let data = json["data"].arrayValue
            for i in 0..<data.count{
                // 处理数据
                let one = data[i]["first"].stringValue
                let two = data[i]["second"].arrayObject as! [String]
                if one != "" {
                    self.departData[one] = two
                    self.deptPicker.reloadAllComponents()
                }
            }
        }, failture:{ error in dPrint(message: error)
        })
        // 关联 UIPicker 和 textField
        setInputView(mPicker:deptPicker, mTextField:departTextField)
        // 获取亲属信息
        let Provider = MoyaProvider<API>()
        Provider.request(API.findfamily(Int(user_default.userId.getStringValue()!)!)) { result in
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
    
    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        //判断当前是第几列
        if (component == 0) {
            // 一级科室的数量
            return departData.keys.count
        }else{
            //二级科室的数量
            let key = Array(departData.keys)[proIndex]
            return (departData[key]?.count)!
        }
        
    }
    
    //MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
            if (component == 0) {
                // 一级科室
                return Array(departData.keys)[row]
            }else{
                //取出选中的二级科室
                let key = Array(departData.keys)[proIndex]
                return departData[key]?[row]
            }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
            if (component == 0) {
                //选中第一列
                proIndex = pickerView.selectedRow(inComponent: 0)
                self.deptPicker.reloadComponent(1)
            }
            //获取选中的一级科室
            let oneDepart = Array(departData.keys)[proIndex]
            //获取选中的二级科室
            let twoDeparts = departData[oneDepart]
            if  twoDeparts?.count != 0{
                let row = pickerView.selectedRow(inComponent: 1)
                self.oneDepart = oneDepart
                self.twoDepart = (twoDeparts?[row])!
                departTextField.text = "\(oneDepart) \(twoDeparts?[row] ?? "")"
            }else{
                self.oneDepart = oneDepart
                departTextField.text = oneDepart
            }
        
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
    
    // MARK: - Action
    
    @objc func clickBtn(button:UIButton){
        // 选择科室
        departTextField.endEditing(true)
    }
    
    // 添加病情
    @IBAction func saveBtn(_ sender: UIButton) {
        var datas:[Data]?
        let count = imgResource.count
        if count > 1 {
            datas = [Data]()
            for i in 0..<(count-1){
                datas?.append(ImageUtil.image2Data(image:imgResource[i]))
            }
        }
        NetWorkUtil<BaseAPIBean>.init(method: .addsick(datas, textView.text, oneDepart, twoDepart, family)).newRequest { (bean, json) in
            if bean.code == 100 {
                self.dismiss(animated: false, completion: nil)
            }
            Toast(bean.msg!)
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

   

}
