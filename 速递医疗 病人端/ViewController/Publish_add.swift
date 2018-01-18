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
import HJPhotoBrowser

let maxImageNum = 4

// 添加病情页面

class Publish_add: BasePickImgViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource,HJPhotoBrowserDelegate {
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var departTextField: UITextField!
    
    var parentVc: Publish_main!
    // 病情描述
    @IBOutlet weak var textView: UITextView!
    var deptPicker = UIPickerView()
    var proIndex:Int = 0
    var departData = APPLICATION.departData
    // 就诊人信息
    var familyData = [familyBean]()
    // 就诊人ID
    var family:Int = 0
    // 病情图片
    var imgResource = [UIImage]()
    //科室名
    var oneDepart = ""
    var twoDepart = ""
    // 标志
    var descFlag = false
    var patientFlag = false
    var departFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        handler = {image in
            // 显示选中的图片
            self.imgResource.insert(image, at: 0)
            self.collectionView.reloadData()
        }
        initData()
        // Do any additional setup after loading the view.
    }
    
    func photoBrowser(_ browser: HJPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return imgResource[index]
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
        imgResource.append(#imageLiteral(resourceName: "add_picture"))
        // 关联 UIPicker 和 textField
        setInputView(mPicker:deptPicker, mTextField:departTextField)
        // 获取亲属信息
        let Provider = MoyaProvider<API>()
        Provider.request(API.findfamily) { result in
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
        if row == 0 && component == 0 {
            // 默认显示
            let oneDepart = Array(APPLICATION.departData.keys)[0]
            let twoDeparts = APPLICATION.departData[oneDepart]
            if  twoDeparts?.count != 0{
                self.oneDepart = oneDepart
                self.twoDepart = (twoDeparts?[0])!
                departTextField.text = "\(oneDepart) \(twoDepart)"
            }else{
                self.oneDepart = oneDepart
                departTextField.text = oneDepart
            }
        }
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
        descFlag = true
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
            descFlag = false
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
                updatePicture()
            }else {
                showToast(self.view, "请上传不多于四张图片")
            }
        } else {
            let count = imgResource.count;
            let browser = HJPhotoBrowser()
            browser.sourceImagesContainerView = collectionView
            browser.imageCount = count - 1
            browser.currentImageIndex = indexPath.row;
            browser.delegate = self
            browser.show()
        }
    }
    
    // MARK: - Action
    
    @objc func clickBtn(button:UIButton){
        // 选择科室
        departTextField.endEditing(true)
        departFlag = true
    }
    
    // 添加病情
    @IBAction func saveBtn(_ sender: UIButton) {
        textView.resignFirstResponder()
        if descFlag && departFlag && patientFlag {
            var datas:[Data]?
            let count = imgResource.count
            if count > 1 {
                datas = [Data]()
                for i in 0..<(count-1){
                    datas?.append(ImageUtil.image2Data(image:imgResource[i]))
                }
            }
            NetWorkUtil<BaseAPIBean>.init(method: .addsick(datas, textView.text, oneDepart, twoDepart, family)).newRequest(successhandler: { (bean, json) in
                    self.dismiss(animated: false, completion: nil)
                
                self.parentVc.vcs[0].refreshBtn()
            }, failhandler:{ (bean, json) in
                showToast(self.view, bean.msg!)
            })
        }else {
            showToast(self.view, "请填写完整病情信息")
            return
        }
        
    }
    
    // 添加就诊人
    @IBAction func addPatient(_ sender: UIButton) {
        textView.resignFirstResponder()
        var titles = [String]()
        if familyData.count == 0 {
            showToast(self.view, "候选就诊人为空，请添加亲属信息")
            return
        }
        for bean in familyData {
            titles.append(bean.familyname!)
        }
        AlertUtil.popMenu(vc: self, title: "添加就诊人", msg: "", btns: titles, handler: {result in
            let index = titles.index(of: result)!
            self.patientFlag = true
            self.family = self.familyData[index].familyid
            sender.setTitle(result, for: .normal)
        })
    }
    
    
    
}
