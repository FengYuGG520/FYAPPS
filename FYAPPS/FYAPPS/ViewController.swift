//
//  ViewController.swift
//  FYAPPS
//
//  Created by FengYu on 2017/9/15.
//  Copyright © 2017年 FengYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let fYCollectionViewCell = "fYCollectionViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
                
        self.collectionView.fy_target(self)
        self.collectionView.fy_collectionRegisterXib("FYCollectionViewCell", "fYCollectionViewCell")
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }


}

extension ViewController: UICollectionViewDataSource {
    
    // 返回组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    // 返回行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    // 返回 item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fYCollectionViewCell, for: indexPath)
        cell.backgroundColor = UIColor.fy_colorRandom()
        
        return cell
    }
    
}

