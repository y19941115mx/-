//
//  BaseViewController.swift


import UIKit

class BaseViewController: UIViewController {

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
//        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
