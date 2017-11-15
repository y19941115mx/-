//
//  PopUp.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/13.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit
import STPopup
import SwiftyJSON
import Moya
import ObjectMapper
import SVProgressHUD

class PopUpDepartment: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker_view: UIPickerView!
    
    var departData = [String:[String]]()
    var proIndex:Int = 0
    var oneDepart = ""
    var twoDepart = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        // Do any additional setup after loading the view.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "选择科室"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: .plain, target: self, action: #selector(click))
        self.contentSizeInPopup = CGSize.init(width: 300, height: 300)
        self.landscapeContentSizeInPopup = CGSize.init(width: 400, height: 200)
        
    }
    
    func initData() {
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
                    self.picker_view.reloadAllComponents()
                }
            }
        }, failture:{ error in dPrint(message: error)
        })
        
        
    }
    
    @objc func click(){
        let vc = self.presentingViewController as! Publish_add
        vc.oneDepart = oneDepart
        vc.twoDepart = twoDepart
    }
    
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
            self.picker_view.reloadComponent(1)
        }
        //获取选中的一级科室
        let oneDepart = Array(departData.keys)[row]
        //获取选中的二级科室
        let twoDeparts = departData[oneDepart]
        if  twoDeparts?.count != 0{
            let row = pickerView.selectedRow(inComponent: 1)
            self.oneDepart = oneDepart
            self.twoDepart = (twoDeparts?[row])!
        
        }else{
            self.oneDepart = oneDepart

        }
        
    }


    
}
