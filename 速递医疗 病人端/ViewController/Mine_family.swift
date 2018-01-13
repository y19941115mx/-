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

class Mine_family: BaseRefreshController<familyBean>, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: BaseTableView!
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = data[indexPath.row]
            let id = user.familyid
            NetWorkUtil.init(method: .deletefamily(id)).newRequest(successhandler: { (bean, json) in
                    self.data.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .none)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label_name = cell.viewWithTag(1) as! UILabel
        let label_sex = cell.viewWithTag(2) as! UILabel
        let label_age = cell.viewWithTag(3) as! UILabel
        let bean = data[indexPath.row]
        label_name.text = bean.familyname
        label_age.text = String(bean.familyage)
        label_sex.text = bean.familymale
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNoFooterRefresh(scrollView: tableView, ApiMethod: .findfamily, isTableView: true)
        self.header?.beginRefreshing()
    }
    

    @IBAction func clickSaveButton() {
        AlertUtil.popInfoTextFields(vc: self, okhandler:{ textFields in
            // FIXME: 服务器字符校验
            NetWorkUtil.init(method: API.addfamily( textFields[0].text!, textFields[1].text!, Int(textFields[2].text!)!)).newRequestWithOutHUD(successhandler: { (bean, josn) in
                    self.refreshBtn()
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
}

