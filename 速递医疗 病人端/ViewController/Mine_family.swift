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

class Mine_family: BaseRefreshController<familyBean>, UITableViewDataSource {
    
    @IBOutlet weak var tableView: BaseTableView!
    
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
            NetWorkUtil.init(method: API.addfamily( textFields[0].text!, textFields[1].text!, Int(textFields[2].text!)!)).newRequestWithOutHUD(handler: { (bean, josn) in
                showToast(self.view, bean.msg!)
                if bean.code == 100 {
                    self.refreshData()
                }
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
}

