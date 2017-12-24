//
//  EvaluateViewController.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/12/16.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class EvaluateViewController: BaseViewController {
    
    var OdrderId:Int?
    
    @IBOutlet weak var doccommentservicelevel: RatingController!
    @IBOutlet weak var priceLevel: RatingController!
    @IBOutlet weak var professionallevel: RatingController!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "订单评价")
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let serviceLevel = doccommentservicelevel.rating
        let professionlevel = professionallevel.rating
        let mPriceLevel = priceLevel.rating
        if serviceLevel != 0 && professionlevel != 0 && mPriceLevel != 0 && textView.text != "" {
            NetWorkUtil.init(method:API.evaluate(self.OdrderId!, serviceLevel, professionlevel, mPriceLevel, textView.text!)).newRequest(handler: { (bean, json) in
                showToast(self.view, bean.msg!)
                if bean.code == 100 {
                    self.dismiss(animated: false, completion: nil)
                }
            })
        } else {
            showToast(self.view, "请填写完整信息")
        }
    }
    
}
