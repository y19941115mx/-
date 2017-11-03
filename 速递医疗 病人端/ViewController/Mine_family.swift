//
//  Mine_family.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import SVProgressHUD

class Mine_family: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: BaseTableView!
    
    var familyData = [familyBean]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label_name = cell.viewWithTag(1) as! UILabel
        let label_sex = cell.viewWithTag(2) as! UILabel
        let label_age = cell.viewWithTag(3) as! UILabel
        let bean = familyData[indexPath.row]
        label_name.text = bean.familyname
        label_age.text = String(bean.familyage)
        label_sex.text = bean.familymale
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    
    private func getData() {
        let Provider = MoyaProvider<API>()
        SVProgressHUD.show()
        Provider.request(API.findfamily(Int(user_default.userId.getStringValue()!)!)) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let bean = Mapper<familyListBean>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        self.familyData = (bean?.familyDataList!)!
                        self.tableView.reloadData()
                    }else{
                     showToast(self.view, bean!.msg!)
                    }
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
    
    @IBAction func clickSaveButton() {
        AlertUtil.popTextFields(vc: self, okhandler:{ textFields in
            // FIXME: 服务器字符校验
            let Provider = MoyaProvider<API>()
            let id = Int(user_default.userId.getStringValue()!)
            SVProgressHUD.show()
            Provider.request(API.addfamily(id!, textFields[0].text!, textFields[1].text!, Int(textFields[2].text!)!)) { result in
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
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
}

