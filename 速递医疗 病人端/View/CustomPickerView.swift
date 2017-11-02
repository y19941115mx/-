//
//  CustomPickerView.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/2.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class CustomPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    static var data = [String]()
    static var pkView = UIPickerView()
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    class func getPickerView(pickerView:UIPickerView, mdata:[String]) {
        data = mdata
        pkView = pickerView
        pkView.dataSource = self
    }
    
    

    

}
