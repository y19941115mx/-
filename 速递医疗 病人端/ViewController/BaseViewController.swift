//
//  BaseViewController.swift


import UIKit
import MJRefresh
import Moya
import SnapKit
import ObjectMapper

class BaseViewController: UIViewController {
    var updateBtnState: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //设置导航栏颜色和字体
        navigationController?.navigationBar.barTintColor = UIColor.APPColor
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
    func setUpNavTitle(title:String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        label.text = title
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        navigationItem.titleView = label
    }
    
    
}

// 输入框

class BaseTextViewController:BaseViewController, UITextFieldDelegate {
    var tv_source = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initTextFieldDelegate(tv_source:[UITextField]) {
        self.tv_source = tv_source
        if tv_source.count != 0 {
            for textField in tv_source {
                textField.delegate = self
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if tv_source.count != 0 {
            for textField in tv_source {
                textField.resignFirstResponder()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBtnState()
    }
}

// 下拉刷新
class BaseRefreshController<T>:BaseViewController {
    var header:MJRefreshStateHeader?
    var footer:MJRefreshAutoStateFooter?
    var doctorData = [T]()
    var tableView:UITableView?
    var selectedPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initRefresh(tableView:UITableView) {
        self.tableView = tableView
        self.header = MJRefreshNormalHeader(refreshingBlock: self.refreshData)
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true;
        self.tableView?.mj_header = self.header
        
        self.footer = MJRefreshAutoNormalFooter(refreshingBlock: self.getMoreData)
        self.footer?.isRefreshingTitleHidden = true
        self.footer?.setTitle("", for: MJRefreshState.idle)
        self.tableView?.mj_footer = self.footer
    }
    
    private func showRefreshBtn() {
        self.tableView?.isHidden = true
        let button = UIButton()
        //label
        button.setTitle("无内容，点击刷新", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(refreshBtn(button:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
    }
    
    private func refreshData(){
        self.selectedPage = 1
        //刷新数据
        let Provider = MoyaProvider<API>()
        
        Provider.request(API.getdoctorlist(1, "0", "0")) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<listBean<T>>().map(JSONObject: try response.mapJSON())
                    
                    if bean?.code == 100 {
                        self.header?.endRefreshing()
                        self.doctorData = (bean?.dataList)!
                        if self.doctorData.count == 0{
                            //隐藏tableView,添加刷新按钮
                            self.showRefreshBtn()
                            return
                        }
                        self.tableView?.reloadData()
                    }else {
                        self.header?.endRefreshing()
                        showToast(self.view, (bean?.msg!)!)
                    }
                }catch {
                    self.header?.endRefreshing()
//                    dPrint(message: bean)
                    showToast(self.view,CATCHMSG)
                }
            case let .failure(error):
                self.header?.endRefreshing()
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
        
    }
    
    private func getMoreData(){
        //获取更多数据
        let Provider = MoyaProvider<API>()
        
        Provider.request(API.getdoctorlist(selectedPage, "0", "0")) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<
                    listBean<T>>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        self.footer?.endRefreshing()
                        if bean?.dataList?.count == 0{
                            showToast(self.view, "已经到底了")
                            return
                        }
                        self.footer?.endRefreshing()
                        self.doctorData += (bean?.dataList)!
                        self.selectedPage += 1
                        self.tableView?.reloadData()
                        
                    }else {
                        self.footer?.endRefreshing()
                        showToast(self.view, (bean?.msg!)!)
                    }
                }catch {
                    self.footer?.endRefreshing()
                    showToast(self.view, CATCHMSG)
                }
            case let .failure(error):
                self.footer?.endRefreshing()
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
        
    }
    @objc func refreshBtn(button:UIButton) {
        // 点击刷新
        self.tableView?.isHidden = false
        button.removeFromSuperview()
        self.header?.beginRefreshing()
    }
    
    
}
