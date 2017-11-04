//
//  BaseViewController.swift


import UIKit


class BaseViewController: UIViewController {

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
    var updateBtnState: () -> Void = {}
    
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



class SegmentedSlideViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 初始化分栏
    func setUpSlideSwitch(titles:[String], vcs:[UIViewController])
    {
        let slideSwitch = XLSegmentedSlideSwitch(frame: CGRect(x: 0,  y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), titles: titles, viewControllers: vcs)
        slideSwitch?.tintColor = UIColor.APPColor
        slideSwitch?.show(in: self)
    }
    
    func setUpSlideSwitchWithNavigation(titles:[String], vcs:[UIViewController])
    {
        let slideSwitch = XLSegmentedSlideSwitch(frame: CGRect(x: 0,  y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), titles: titles, viewControllers: vcs)
        slideSwitch?.tintColor = UIColor.APPColor
        slideSwitch?.show(in: self)
    }
    
    
}

