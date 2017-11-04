//
//  DoctorPageViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/20.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit


class MyDoctor_page: BaseRefreshController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infoTableView: BaseTableView!
    var type:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh(tableView: infoTableView, ApiMethod: .getredoctor(LOGINID!, type))
        // 获取数据
        self.header?.beginRefreshing()
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! MyDoctorTableViewCell
        let doctor = data[indexPath.row]
        cell.nameLabel.text = doctor.name
        cell.hospitalLabel.text = doctor.hospital
        cell.idLabel.text = "\(doctor.docId)"
        ImageUtil.setImage(path: doctor.pix!, imageView: cell.avator)
        cell.checkBtn.tag = indexPath.row
        cell.checkBtn.addTarget(self, action: #selector(self.checkedBtn(button:)), for: .touchUpInside)
        return cell
    }

    
    @objc func checkedBtn(button:UIButton) {
        AlertUtil.popAlert(vc: self, msg: "确定选择该医生: \(data[button.tag].name ?? "" )", okhandler: { dPrint(message: "点击确认") })
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

