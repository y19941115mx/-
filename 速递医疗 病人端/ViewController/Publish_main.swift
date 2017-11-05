//
//  PublicHomeViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/11.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Publish_main: SegmentedSlideViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["已添加","已发布"]
        let vc1 = UIStoryboard.init(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "tianjia") as!Publish_page
        vc1.type = 1
        let vc2 = UIStoryboard.init(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "tianjia") as!Publish_page
        vc2.type = 2
        let vcs = [vc1, vc2]
        setUpSlideSwitch(titles: titles, vcs: vcs)
    
    }

    

   

    

}
