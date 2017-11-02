//
//  BaseViewController.swift


import UIKit
import MJRefresh

class BaseViewController: UIViewController {
    var updateBtnState: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpNavTitle(title:String) {
        view.backgroundColor = UIColor.white
        //设置导航栏颜色和字体
        navigationController?.navigationBar.barTintColor = UIColor.APPColor
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        label.text = title
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        navigationItem.titleView = label
    }
}

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

class BaseTableViewController:BaseViewController {
    var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // 消除上部分间隔
        self.navigationController?.navigationBar.isTranslucent = false
        self.tableView?.tableFooterView = UIView()
    }
}

class BaseRefreshController:BaseTableViewController {
    var header:MJRefreshStateHeader?
    var footer:MJRefreshAutoStateFooter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initRefresh(tableView:UITableView, headerAction:@escaping ()->Void, footerAction:@escaping ()->Void) {
        self.tableView = tableView
        self.header = MJRefreshNormalHeader(refreshingBlock: headerAction)
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true;
        self.tableView?.mj_header = self.header
        
        self.footer = MJRefreshAutoNormalFooter(refreshingBlock: footerAction)
        self.footer?.isRefreshingTitleHidden = true
        self.footer?.setTitle("", for: MJRefreshState.idle)
        self.tableView?.mj_footer = self.footer
    }
    
    
}
