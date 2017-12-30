//
//  Date_main.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/4.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Date_main: SegmentedSlideViewController {

    private let types = ["等待医生确认","待确认", "进行中", "待评价"]
    private var vcs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置navigation
        setUpNavTitle(title: "我的日程")
        // 设置分栏
        let vc1 = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "order") as! Date_page
        vc1.type = 4
        let vc2 = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "order") as! Date_page
        vc2.type = 1
        let vc3 = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "order") as! Date_page
        vc3.type = 2
        let vc4 = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "order") as! Date_page
        vc4.type = 3
        vcs = [vc1, vc2, vc3, vc4]
        setUpSlideSwitchNoNavigation(titles: types, vcs: vcs)
//        setUpSlideSwitch(titles: types, vcs: vcs)
    }

}
