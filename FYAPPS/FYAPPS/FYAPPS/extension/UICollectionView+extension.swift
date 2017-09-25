import UIKit

extension UICollectionView {
    
    func fy_collectionRegisterXib(_ xibName: String, _ reuseId: String) {
        self.register(UINib.init(nibName: xibName, bundle: nil), forCellWithReuseIdentifier: reuseId)
    }
    
    func fy_target(_ target: Any) {
        self.delegate = target as? UICollectionViewDelegate
        self.dataSource = target as? UICollectionViewDataSource
    }
    
    func fy_cutPrefetch() {
        if #available(iOS 10.0, *) {
            self.isPrefetchingEnabled = false
        }
    }
    
}
