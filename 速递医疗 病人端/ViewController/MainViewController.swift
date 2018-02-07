//
//  MainViewController.swift


import UIKit


class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        APPLICATION.tabBarController = self
    }

    // MARK: - Private Method
    
    func setUpTabBar(){
        // 设置tabBar
        let vc_home = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController()!
        vc_home.tabBarItem = UITabBarItem.init(title: "首页", image:#imageLiteral(resourceName: "index_home") , tag: 0)
        let vc_mine = UIStoryboard.init(name:"Mine", bundle:nil).instantiateInitialViewController()!
        vc_mine.tabBarItem = UITabBarItem.init(title: "我的", image:#imageLiteral(resourceName: "index_mine"), tag: 1)
        let vc_doctor = UIStoryboard.init(name:"MyDoctor", bundle:nil).instantiateInitialViewController()!
        vc_doctor.tabBarItem = UITabBarItem.init(title: "医生", image: #imageLiteral(resourceName: "index_yishen"), tag: 2)
        let vc_data = UIStoryboard.init(name: "Date", bundle: nil).instantiateInitialViewController()!
        vc_data.tabBarItem = UITabBarItem.init(title: "日程", image: #imageLiteral(resourceName: "index_dindan"), tag: 3)
        let vc_publish = UIStoryboard.init(name: "Publish", bundle: nil).instantiateInitialViewController()!
        vc_publish.tabBarItem = UITabBarItem.init(title: "病情", image: #imageLiteral(resourceName: "index_wdys_"), tag: 4)
        self.viewControllers = [vc_home,vc_publish,vc_doctor,vc_data, vc_mine]
        
    }

}
