//
//  Mine_pocket.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class Mine_pocket: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MinePocketCollectionViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MinePocketCollectionViewCell", owner: nil, options: nil)?.last as? MinePocketCollectionViewCell
        }
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUIcolletionView()
        // Do any additional setup after loading the view.
    }
    
    
    private func initUIcolletionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: SCREEN_WIDTH - 20, height: 200)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        self.collectionView.collectionViewLayout = flowLayout
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UINib.init(nibName: "MinePocketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
