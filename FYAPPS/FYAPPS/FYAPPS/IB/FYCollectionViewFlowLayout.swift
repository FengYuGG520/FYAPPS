import UIKit
// 使用方式
// IB 中设置 cellLayout 后, 把下面的代码复制到自定义的 layout 里面再修改
class FYCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        self.minimumInteritemSpacing = FYLen.inUI(0.0)
        self.minimumLineSpacing = FYLen.inUI(0.0)
        self.itemSize = CGSize(width: FYLen.inUI(120), height: FYLen.inUI(200))
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.sectionInset = UIEdgeInsets(top: FYLen.inUI(0.0), left: FYLen.inUI(0.0), bottom: FYLen.inUI(0.0), right: FYLen.inUI(0.0))
        self.scrollDirection = .vertical
    }
    
}
