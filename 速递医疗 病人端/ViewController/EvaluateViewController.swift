//
//  EvaluateViewController.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/12/16.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit
class EvaluateViewController: BaseViewController, UITextViewDelegate {
    
    var OdrderId:Int?
    
    @IBOutlet weak var PlaceHolderLabel: UILabel!
    @IBOutlet weak var doccommentservicelevel: RatingController!
    @IBOutlet weak var priceLevel: RatingController!
    @IBOutlet weak var professionallevel: RatingController!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "订单评价")
        textView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.PlaceHolderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView){
        // 输入文字
        PlaceHolderLabel.isHidden = true
        if textView.text.isEmpty {
            PlaceHolderLabel.isHidden = false
        }
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

class EvaluateTableViewController:BaseRefreshController<EvaluateBean>, UITableViewDataSource, UITableViewDelegate {
    var tableView:UITableView!
    var docId:Int!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? EvaluateTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("EvaluateTableViewCell", owner: nil, options: nil)?.last as? EvaluateTableViewCell
        }
        let bean = data[indexPath.row]
        cell?.updateView(data: bean)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mdata = data[indexPath.row]
        
        let res = StringUTil.getTextRectSize(text: mdata.doccommentwords! as NSString, font: UIFont.systemFont(ofSize: 14), size: CGSize.init(width: 300, height: 17))
        return 90 + res.height
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "评价")
        tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
        }
        initRefresh(scrollView: tableView, ApiMethod: .getevaluation(selectedPage, docId), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = .getevaluation(self.selectedPage, self.docId)
        })
        self.header?.beginRefreshing()
    }
    
}
