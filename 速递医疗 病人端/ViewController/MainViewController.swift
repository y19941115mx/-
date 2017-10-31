//
//  MainViewController.swift


import UIKit


class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Private Method
    
    func setUpTabBar(){
        // 设置tabBar
        
        viewControllers = []
    }

}
