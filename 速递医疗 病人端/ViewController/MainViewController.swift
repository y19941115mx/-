//
//  MainViewController.swift


import UIKit


class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }

    // MARK: - Private Method
    
    func setUpTabBar(){
        // 设置tabBar
        let vc_home = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController()!
        vc_home.tabBarItem = UITabBarItem.init(title: "首页", image:#imageLiteral(resourceName: "index_home") , tag: 0)
        self.viewControllers = [vc_home]
    }

}
