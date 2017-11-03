//
//  HomeViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Toast_Swift
import SVProgressHUD

class Home_main:BaseRefreshController<DoctorBean>, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var infoTableView: UITableView!

    @IBOutlet weak var sortByPatientBtn: UIButton!

    @IBOutlet weak var sortByTimeBtn: UIButton!

    @IBOutlet weak var sortByDept: UIButton!
    @IBOutlet weak var sortByLocBtn: UIButton!
    
    
    let textfield_zero = UITextField.init(frame: CGRect.zero)
    
    let picker_dept = UIPickerView()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //添加按钮事件
        initView()
        // 初始化navigationBar
        setUpNavTitle(title: "首页")
        // 添加下拉刷新
        initRefresh(tableView: infoTableView)
        // 获取数据
        self.header?.beginRefreshing()
        infoTableView.dataSource = self
        infoTableView.delegate = self
        self.textfield_zero.isHidden = true
        // 获取dept数据,关联UIpicker
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return doctorData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeMainTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("HomeMainTableViewCell", owner: nil, options: nil)?.last as? HomeMainTableViewCell
        }
        let modelBean = self.doctorData[indexPath.row]
        cell?.updateViews(modelBean: modelBean)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    
    
    
    private func initView(){
        sortByLocBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByTimeBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByPatientBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByDept.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
    }

    private func cleanButton(){
        sortByLocBtn.setTitleColor(UIColor.darkGray, for: .normal)
        sortByTimeBtn.setTitleColor(UIColor.darkGray, for: .normal)
        sortByPatientBtn.setTitleColor(UIColor.darkGray, for: .normal)
        sortByDept.setTitleColor(UIColor.darkGray, for: .normal)
    }

    //MARK: - action
    @objc func clickBtn(button:UIButton){
        switch button.tag {
        // 推荐病人
        case 10001:
            cleanButton()
            sortByPatientBtn.setTitleColor(UIColor.APPColor, for: .normal)
        // 时间
        case 10002:
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.APPColor, for: .normal)
            showToast(self.view, "按照时间排序")
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.APPColor, for: .normal)
        
        case 10004:
            cleanButton()
            sortByDept.setTitleColor(UIColor.APPColor, for: .normal)
        default:
            dPrint(message: "error")
        }

    }

    //MARK: - navigation Methond

    @IBAction func unwindToHome(sender: UIStoryboardSegue){

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let SelectedIndexPath = infoTableView.indexPathForSelectedRow
            let doctor = doctorData[SelectedIndexPath!.row]
            let vc = segue.destination as! Home_DoctorDetail
            vc.doctorBean = doctor
        }
    }
        
    // MARK: - Private Method

    
    func setInputView(mPicker:UIPickerView, mTextField:UITextField){
        // 关联textfield 与 pickerView
        let myToolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - 44 - mPicker.frame.size.height , width: view.frame.size.width, height: 44))
        let finishBtn = UIBarButtonItem(title: "完成", style: .done, target:self, action: #selector(clickBtn(button:)))
        finishBtn.tag = mPicker.tag
        myToolBar.setItems([finishBtn], animated: false)
        
//        mPicker.delegate = self
//        mPicker.dataSource = self
        //样式尺寸
        mPicker.backgroundColor = UIColor.white
        mTextField.inputView = mPicker
        mTextField.inputAccessoryView = myToolBar
    }
}


