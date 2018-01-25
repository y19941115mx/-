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
import ObjectMapper
import Moya

enum HomeType:Int {
    case sortByPatient, sortByDept,sortByLoc
}

class Home_main:BaseRefreshController<DoctorBean>, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var sortByPatientBtn: UIButton!
    
    
    @IBOutlet weak var sortByDept: UIButton!
    @IBOutlet weak var sortByLocBtn: UIButton!
    
    var city:String = ""
    var province:String = ""
    var area:String = ""
    
    var oneDepart = ""
    var twoDepart = ""
    
    //所以地址数据集合
    var addressArray = [[String: AnyObject]]()
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    // 科室索引
    var proIndex:Int = 0
    
    let cityPicker = UIPickerView()
    let cityToolBar = UIToolbar()
    
    let deptPicker = UIPickerView()
    let deptToolBar = UIToolbar()
    
    var sortType:HomeType = HomeType.sortByPatient
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        APPLICATION.homeMainVc = self
        //添加按钮事件
        initView()
        // 初始化navigationBar
        setUpNavTitle(title: "首页")
        // 初始化消息按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "message"), style: .plain, target: self, action: #selector(self.showContantList))
        initRefresh(scrollView: infoTableView, ApiMethod: API.getdoctorlist(selectedPage, APPLICATION.lon, APPLICATION.lat), refreshHandler: {
            switch self.sortType {
            case .sortByPatient:
                self.ApiMethod = API.getdoctorlist(self.selectedPage, APPLICATION.lon, APPLICATION.lat)
            case .sortByLoc:
                self.ApiMethod = API.getdoctorlistByLoc(self.selectedPage, APPLICATION.lon, APPLICATION.lat, self.province, self.city, self.area)
            case .sortByDept:
                self.ApiMethod = API.getdoctorlistByDept(self.selectedPage, APPLICATION.lon, APPLICATION.lat, self.oneDepart, self.twoDepart)
            }
            
        }, getMoreHandler:{
            switch self.sortType {
            case .sortByPatient:
                self.getMoreMethod = API.getdoctorlist(self.selectedPage, APPLICATION.lon, APPLICATION.lat)
            case .sortByLoc:
                self.getMoreMethod = API.getdoctorlistByLoc(self.selectedPage, APPLICATION.lon, APPLICATION.lat, self.province, self.city, self.area)
            case .sortByDept:
                self.getMoreMethod = API.getdoctorlistByDept(self.selectedPage, APPLICATION.lon, APPLICATION.lat, self.oneDepart, self.twoDepart)
            }
        })
        // 登录环信
        loginHuanxin()
        // 获取数据
        self.header?.beginRefreshing()
        // 初始化地址数据
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
        cityPicker.tag = 1
        deptPicker.tag = 2
        infoTableView.dataSource = self
        infoTableView.delegate = self
    }
    
    // 更新环信会话列表状态
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeMainTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("HomeMainTableViewCell", owner: nil, options: nil)?.last as? HomeMainTableViewCell
        }
        let modelBean = self.data[indexPath.row]
        cell?.updateViews(modelBean: modelBean, vc: self)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    
    //MARK: - 重写父类方法 保存数据库
    
    override func getData() {
        //刷新数据
        self.selectedPage = 1
        let Provider = NetWorkUtil.setRequestTimeout()
        if self.refreshHandler != nil {
            self.refreshHandler!()
        }
        Provider.request(self.ApiMethod!) { result in
            switch result {
            case let .success(response):
                do {
                    self.header?.endRefreshing()
                    let bean = Mapper<BaseListBean<DoctorBean>>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        if bean?.dataList == nil {
                            bean?.dataList = [DoctorBean]()
                        }
                        self.data = (bean?.dataList)!
                        if self.data.count == 0{
                            //隐藏tableView,添加刷新按钮
                            self.showRefreshBtn()
                        }else {
                            // 保存数据库
                            for bean in self.data {
                                UserInfo.updateUserInfo(user_id: bean.account!, nick_name: bean.name!, user_photo: bean.pix!)
                            }
                        }
                        
                        if self.isTableView {
                            let tableView = self.scrollView as! UITableView
                            tableView.reloadData()
                        }else {
                            let collectionView = self.scrollView as! UICollectionView
                            collectionView.reloadData()
                        }
                        self.footer?.resetNoMoreData()
                        
                    }else {
                        ToastError((bean?.msg!)!)
                    }
                    
                }catch {
                    //隐藏tableView,添加刷新按钮
                    if self.data.count == 0{
                        self.showRefreshBtn()
                    }
                    ToastError(CATCHMSG)
                }
            case let .failure(error):
                self.header?.endRefreshing()
                if self.data.count == 0{
                    self.showRefreshBtn()
                }
                ToastError(ERRORMSG)
            }
        }
    }
    
    override func getMoreData() {
        self.selectedPage += 1
        
        //获取更多数据
        getMoreHandler()
        let Provider = NetWorkUtil.setRequestTimeout()
        Provider.request(self.getMoreMethod!) { result in
            switch result {
            case let .success(response):
                self.footer?.endRefreshing()
                do {
                    let bean = Mapper<BaseListBean<DoctorBean>>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        if bean?.dataList?.count == 0 || bean?.dataList == nil{
                            self.footer!.endRefreshingWithNoMoreData()
                            return
                        } else {
                            // 保存数据库
                            for bean in (bean?.dataList)! {
                                UserInfo.updateUserInfo(user_id: bean.account!, nick_name: bean.name!, user_photo: bean.pix!)
                            }
                        }
                        self.data += (bean?.dataList)!
                        
                        if self.isTableView {
                            let tableView = self.scrollView as! UITableView
                            tableView.reloadData()
                        }else {
                            let CollectionView = self.scrollView as! UICollectionView
                            CollectionView.reloadData()
                        }
                        
                    }else {
                        ToastError((bean?.msg!)!)
                    }
                }catch {
                    self.footer?.endRefreshing()
                    ToastError(CATCHMSG)
                }
            case let .failure(error):
                self.footer?.endRefreshing()
                dPrint(message: "error:\(error)")
                ToastError(ERRORMSG)
            }
        }
    }
    
    
    
    
    
    //MARK: - 私有方法
    private func loginHuanxin() {
        // 环信登录
        let account = user_default.account.getStringValue()
        let pass = user_default.password.getStringValue()
        
        EMClient.shared().login(withUsername: account!, password: pass, completion: { (name, error) in
            if error != nil {
                // 弹出提示
                AlertUtil.popAlert(vc: self, msg: "环信服务绑定失败", hasCancel:false, okhandler: {
                })
            }
        })
        
        
    }
    
    func updateView(){
        // 获取所有会话
        let conversations:([EMConversation])? = EMClient.shared().chatManager.getAllConversations() as? [EMConversation]
        if conversations != nil {
            var count:Int32 = 0
            for conversation in conversations! {
                count += conversation.unreadMessagesCount
            }
            if count == 0 {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "message"), style: .plain, target: self, action: #selector(self.showContantList))
            }else {
                let buttonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "message"), style: .plain, target: self, action: #selector(self.showContantList))
                buttonItem.tintColor = UIColor.red
                self.navigationItem.rightBarButtonItem = buttonItem
            }
        }
    }
    
    private func initView(){
        sortByLocBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByPatientBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByDept.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
    }
    
    private func cleanButton(){
        sortByLocBtn.setTitleColor(UIColor.darkGray, for: .normal)
        sortByPatientBtn.setTitleColor(UIColor.darkGray, for: .normal)
        sortByDept.setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    //MARK: - action
    @objc func clickBtn(button:UIButton){
        switch button.tag {
        // 推荐病人
        case 10001:
            self.cityPicker.isHidden = true
            self.cityToolBar.isHidden = true
            self.deptPicker.isHidden = true
            self.deptToolBar.isHidden = true
            self.sortType = .sortByPatient
            self.refreshBtn()
            cleanButton()
            sortByPatientBtn.setTitleColor(UIColor.APPColor, for: .normal)
        // 地点
        case 10003:
            self.deptPicker.isHidden = true
            self.deptToolBar.isHidden = true
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.APPColor, for: .normal)
            // 显示地点选择器
            showUIPickView(type: 1)
        case 10004:
            self.cityPicker.isHidden = true
            self.cityToolBar.isHidden = true
            cleanButton()
            sortByDept.setTitleColor(UIColor.APPColor, for: .normal)
            // 显示地点选择器
            showUIPickView(type: 2)
        default:
            if button.tag == 1 {
                // 完成地点选择
                self.cityPicker.isHidden = true
                self.cityToolBar.isHidden = true
                //获取选中的省
                let p = self.addressArray[provinceIndex]
                province = "\(p["state"]! as! String)省"
                //获取选中的市
                let c = (p["cities"] as! NSArray)[cityIndex] as! [String: AnyObject]
                city = "\((c["city"] as? String)!)市"
                //获取选中的县（地区）
                area = ""
                if (c["areas"] as! [String]).count > 0 {
                    area = (c["areas"] as! [String])[areaIndex]
                }
                self.sortType = .sortByLoc
                self.refreshBtn()
            }else {
                self.deptPicker.isHidden = true
                self.deptToolBar.isHidden = true
                self.sortType = .sortByDept
                self.refreshBtn()
            }
        }
        
    }
    
    // 显示环信会话列表
    @objc private func showContantList() {
        let viewController = ConversationListViewController()
        viewController.setUpNavTitle(title: "会话列表")
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    // 显示pickerView
    private func showUIPickView(type:Int) {
        if type == 1 {
            self.cityPicker.isHidden = false
            self.cityToolBar.isHidden = false
            self.view.addSubview(self.cityPicker)
            cityPicker.snp.makeConstraints { (make) in
                make.bottom.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(SCREEN_HEIGHT/3)
            }
            self.view.addSubview(self.cityToolBar)
            cityToolBar.snp.makeConstraints { (make) in
                make.height.equalTo(44)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(self.cityPicker.snp.top)
            }
            let finishBtn = UIBarButtonItem(title: "完成", style: .done, target:self, action: #selector(self.clickBtn(button:)))
            finishBtn.tag = 1
            cityToolBar.setItems([finishBtn], animated: false)
            cityPicker.delegate = self
            cityPicker.dataSource = self
            cityPicker.backgroundColor = UIColor.white
        }else {
            
            
            self.deptPicker.isHidden = false
            self.deptToolBar.isHidden = false
            self.view.addSubview(self.deptPicker)
            deptPicker.snp.makeConstraints { (make) in
                make.bottom.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(SCREEN_HEIGHT/3)
            }
            self.view.addSubview(self.deptToolBar)
            deptToolBar.snp.makeConstraints { (make) in
                make.height.equalTo(44)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(self.deptPicker.snp.top)
            }
            let finishBtn = UIBarButtonItem(title: "完成", style: .done, target:self, action: #selector(self.clickBtn(button:)))
            finishBtn.tag = 2
            deptToolBar.setItems([finishBtn], animated: false)
            deptPicker.delegate = self
            deptPicker.dataSource = self
            deptPicker.backgroundColor = UIColor.white
            // 默认显示
            let oneDepart = Array(APPLICATION.departData.keys)[0]
            let twoDeparts = APPLICATION.departData[oneDepart]
            if  twoDeparts?.count != 0{
                self.oneDepart = oneDepart
                self.twoDepart = (twoDeparts?[0])!
            }else{
                self.oneDepart = oneDepart
            }
        }
        
    }
    
    //MARK: - navigation Methond
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let SelectedIndexPath = infoTableView.indexPathForSelectedRow
            let doctor = data[SelectedIndexPath!.row]
            let vc = segue.destination as! Home_DoctorDetail
            vc.doctorId = doctor.docId
        }
    }
    
    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            return 3
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            if component == 0 {
                return self.addressArray.count
            } else if component == 1 {
                let province = self.addressArray[provinceIndex]
                return province["cities"]!.count
            } else {
                let province = self.addressArray[provinceIndex]
                if let city = (province["cities"] as! NSArray)[cityIndex]
                    as? [String: AnyObject] {
                    return city["areas"]!.count
                } else {
                    return 0
                }
            }
        } else {
            //判断当前是第几列
            if (component == 0) {
                // 一级科室的数量
                return APPLICATION.departData.keys.count
            }else{
                //二级科室的数量
                let key = Array(APPLICATION.departData.keys)[proIndex]
                return (APPLICATION.departData[key]?.count)!
            }
        }
    }
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            if component == 0 {
                return self.addressArray[row]["state"] as? String
            }else if component == 1 {
                let province = self.addressArray[provinceIndex]
                let city = (province["cities"] as! NSArray)[row]
                    as! [String: AnyObject]
                return city["city"] as? String
            }else {
                let province = self.addressArray[provinceIndex]
                let city = (province["cities"] as! NSArray)[cityIndex]
                    as! [String: AnyObject]
                return (city["areas"] as! NSArray)[row] as? String
            }
        }else {
            if (component == 0) {
                // 一级科室
                return Array(APPLICATION.departData.keys)[row]
            }else{
                //取出选中的二级科室
                let key = Array(APPLICATION.departData.keys)[proIndex]
                return APPLICATION.departData[key]?[row]
            }
        }
        
        
    }
    
    //选中项改变事件（将在滑动停止后触发）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        
        if pickerView.tag == 1 {
            //根据列、行索引判断需要改变数据的区域
            switch (component) {
            case 0:
                provinceIndex = row;
                cityIndex = 0;
                areaIndex = 0;
                pickerView.reloadComponent(1);
                pickerView.reloadComponent(2);
                pickerView.selectRow(0, inComponent: 1, animated: false)
                pickerView.selectRow(0, inComponent: 2, animated: false)
            case 1:
                cityIndex = row;
                areaIndex = 0;
                pickerView.reloadComponent(2);
                pickerView.selectRow(0, inComponent: 2, animated: false)
            case 2:
                areaIndex = row;
            default:
                break;
            }
        }else {
            if (component == 0) {
                //选中第一列
                proIndex = pickerView.selectedRow(inComponent: 0)
                self.deptPicker.reloadComponent(1)
            }
            //获取选中的一级科室
            let oneDepart = Array(APPLICATION.departData.keys)[proIndex]
            //获取选中的二级科室
            let twoDeparts = APPLICATION.departData[oneDepart]
            if  twoDeparts?.count != 0{
                let row = pickerView.selectedRow(inComponent: 1)
                self.oneDepart = oneDepart
                self.twoDepart = (twoDeparts?[row])!
            }else{
                self.oneDepart = oneDepart
            }
        }
        
    }
    
}


