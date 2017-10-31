//
//  HomeViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class HomeViewController:BaseRefreshController, UITableViewDataSource{
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var sortByPatientBtn: UIButton!
    
    @IBOutlet weak var sortByTimeBtn: UIButton!
    
    @IBOutlet weak var sortByLocBtn: UIButton!
    //病情信息
    var patientData = [PatientMsgBean]()
    var selectedPage = 0
    var rows = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化navigationBar,添加按钮事件
        initView()

        patientData = getTestData()
        infoTableView.dataSource = self
        // 添加下拉刷新
        addRefreshView(mSourceView: infoTableView, refreshAction: {
            self.patientData += getTestData()
            self.infoTableView.reloadData()
        }, loadMoreAction: {
            self.patientData += getTestData()
            self.infoTableView.reloadData()
        })
        infoTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return patientData.count
    }
    //1,2,3,4,5分别是3 个label 1 个 UIimage
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let id = "reusedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let sexLabel = cell.viewWithTag(2) as! UILabel
        let timeLabel = cell.viewWithTag(3) as! UILabel
        let descLabel = cell.viewWithTag(4) as! UILabel
        let patientImg = cell.viewWithTag(5) as! UIImageView
        let result = patientData[indexPath.row]
        titleLabel.text = result.name
        sexLabel.text = result.sex
        timeLabel.text = getComparedTimeStr(str: result.time)
        descLabel.text = result.desc
        setImage(path: result.avator, imageView: patientImg)
        return cell
    }
    
    
    
    
    private func initData(){
        //获取默认数据
        let id  = getUserDefaultStringValue(key: "id", defaultValue: "")
        if id == ""{
            fatalError("userID出错")
        }
        homePage(id: Int(id)!, page: 1,
        successHandler: {value in
            let json = JSON(value)
            let data = json["data"].arrayValue
            for item in data {
                let patient = PatientMsgBean(avator:"http://192.168.2.2:8080/picture/1.jpg", desc: item["usersickdesc"].stringValue, sex: item["familymale"].stringValue, time: timestamp2string(timeStamp: item["usersickptime"].int!), name: item["familyname"].stringValue, age: item["familyage"].int!, sickpic: [])
                self.patientData.append(patient)
            }
            dPrint(message: self.patientData)
            self.infoTableView.reloadData()
        },
        
        failHandler: { error in
            dPrint(message: error)
        })
        
    }
    
    private func initView(){
        setUpNavigation()
        sortByLocBtn.addTarget(self, action: #selector(HomeViewController.clickBtn(button:)), for: .touchUpInside)
        sortByTimeBtn.addTarget(self, action: #selector(HomeViewController.clickBtn(button:)), for: .touchUpInside)
        sortByPatientBtn.addTarget(self, action: #selector(HomeViewController.clickBtn(button:)), for: .touchUpInside)
    }
    
    private func cleanButton(){
        sortByLocBtn.setTitleColor(UIColor.black, for: .normal)
        sortByTimeBtn.setTitleColor(UIColor.black, for: .normal)
        sortByPatientBtn.setTitleColor(UIColor.black, for: .normal)
    }
    
    private func setUpNavigation(){
        //
        navigationController?.navigationBar.barTintColor = UIColor(red:0.39, green:0.73, blue:1.00, alpha:1.00)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        label.text = "速递医运"
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        navigationItem.titleView = label
    }
    
    
    
    //MARK: - action
    func clickBtn(button:UIButton){
        switch button.tag {
        // 推荐病人
        case 10001:
            cleanButton()
            sortByPatientBtn.setTitleColor(UIColor.AppBlue, for: .normal)
        // 时间
        case 10002:
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.AppBlue, for: .normal)
            popMenu(vc: self, title: "选择性别", msg: "选择性别", btns: ["男","女"], handler: {value in
                dPrint(message: value)
            })
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.AppBlue, for: .normal)
            
        default:
            showToast(vc: self, text: "error")
        }
    
    }
    
    //MARK: - navigation Methond
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let SelectedIndexPath = infoTableView.indexPathForSelectedRow
            let patient = patientData[SelectedIndexPath!.row]
            let vc = segue.destination as! DoctorDetailViewController
            vc.patientBean = patient
        }
    }
}

