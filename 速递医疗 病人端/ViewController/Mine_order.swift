//
//  Mine_order.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import SVProgressHUD
import ObjectMapper

class Mine_order: BaseRefreshController<OrderBean>,UITableViewDataSource {
    
    @IBOutlet weak var tableView: BaseTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRefresh(scrollView: tableView, ApiMethod: API.gethistoryorder(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = API.gethistoryorder(self.selectedPage)
        })
        self.header?.beginRefreshing()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let stateLabel = cell.viewWithTag(2) as! UILabel
        let timeLabel = cell.viewWithTag(3) as! UILabel
        let descLabel = cell.viewWithTag(4) as! UILabel
        let res = data[indexPath.row]
        nameLabel.text = res.familyname
        stateLabel.text = res.userorderstatename
        timeLabel.text = res.userorderappointment
        descLabel.text = res.usersickdesc
        return cell
    }
    
    
}
