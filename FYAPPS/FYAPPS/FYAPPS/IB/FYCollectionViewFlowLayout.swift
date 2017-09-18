import UIKit

class FYCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        self.minimumInteritemSpacing = FYLen.fy_lenInUI(0.0)
        self.minimumLineSpacing = FYLen.fy_lenInUI(0.0)
        self.itemSize = CGSize(width: FYLen.fy_lenInUI(120), height: FYLen.fy_lenInUI(200))
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.sectionInset = UIEdgeInsets(top: FYLen.fy_lenInUI(0.0), left: FYLen.fy_lenInUI(0.0), bottom: FYLen.fy_lenInUI(0.0), right: FYLen.fy_lenInUI(0.0))
        self.scrollDirection = .vertical
    }
    
}
