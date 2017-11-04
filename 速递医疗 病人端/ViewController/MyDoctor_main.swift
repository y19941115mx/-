//
//  MyDoctorViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import SVProgressHUD

let ident = "reusedCell"

// 我的医生主界面

class MyDoctor_main: SegmentedSlideViewController {

    private let types = ["预选医生", "抢单医生", "系统推荐", "医生推荐"]
    private var vcs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置navigation
        setUpNavTitle(title: "我的医生")
//         设置分栏
        let vc1 = UIStoryboard.init(name: "MyDoctor", bundle: nil).instantiateViewController(withIdentifier: "tableView") as! MyDoctor_page
        vc1.type = 4
        let vc2 = UIStoryboard.init(name: "MyDoctor", bundle: nil).instantiateViewController(withIdentifier: "tableView") as! MyDoctor_page
        vc2.type = 2
        let vc3 = UIStoryboard.init(name: "MyDoctor", bundle: nil).instantiateViewController(withIdentifier: "tableView") as! MyDoctor_page
        vc3.type = 1
        let vc4 = UIStoryboard.init(name: "MyDoctor", bundle: nil).instantiateViewController(withIdentifier: "tableView") as! MyDoctor_page
        vc4.type = 3
        vcs = [vc1, vc2, vc3, vc4]
        setUpSlideSwitchWithNavigation(titles: types, vcs: vcs)
        
    }
    
    
    // MARK: - TableViewDataSource
    
    private func getDoctorData(_ type:Int) {
        let Provider = MoyaProvider<API>()
        
        Provider.request(API.getredoctor(LOGINID!, type)) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let bean = Mapper<BaseAPIBean>().map(JSONObject: try response.mapJSON())
                    showToast(self.view, bean!.msg!)
                }catch {
                    SVProgressHUD.dismiss()
                    self.view.makeToast(CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                self.view.makeToast(ERRORMSG)
            }
        }
    }
 

}
