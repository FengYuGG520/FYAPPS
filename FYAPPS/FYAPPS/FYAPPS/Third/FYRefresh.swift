import UIKit
import MJRefresh

// 刷新数据的文字颜色
private let refreshColor = UIColor.gray
// 设置动画图像的普通状态
private var idleImages = { ()->[UIImage] in
    var imageArr: [UIImage] = []
    for i in 1..<19 {
        let image = UIImage.init(named: String.init(format: "Preloader_4_%05d", i))
        imageArr.append(image!)
    }
    return imageArr
}()
// 设置动画图像的拉动状态（松开时输入刷新状态）
private var pullingImages = { ()->[UIImage] in
    var imageArr: [UIImage] = []
    for i in 1..<19 {
        if i % 3 != 1 {
            let image = UIImage.init(named: String.init(format: "Preloader_4_%05d", i))
            imageArr.append(image!)
        }
    }
    return imageArr
}()
// 设置动画图像的刷新状态
private var refreshingImages = { ()->[UIImage] in
    var imageArr: [UIImage] = []
    for i in 1..<19 {
        if i % 9 == 5 {
            let image = UIImage.init(named: String.init(format: "Preloader_4_%05d", i))
            imageArr.append(image!)
        }
    }
    return imageArr
}()

typealias refreshBlock = (Int)->()

class FYRefreshTable: UITableView {
    
    var pageNum: Int = 1
    
    func setRefresh(header: @escaping refreshBlock, footer: @escaping refreshBlock) {
        
        let h = MJRefreshGifHeader.init {
            self.pageNum = 1
            header(self.pageNum)
            self.mj_header.endRefreshing()
        }
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.stateLabel.textColor = refreshColor
        
        let f = MJRefreshAutoGifFooter.init(refreshingBlock: {
            self.pageNum += 1
            footer(self.pageNum)
            self.mj_footer.endRefreshing()
        })
        
        f?.setTitle("", for: .idle)
        f?.setTitle("", for: .refreshing)
        f?.setTitle("没有更多了哦", for: .noMoreData)
        f?.setImages(idleImages, for: .idle)
        f?.setImages(pullingImages, for: .refreshing)
        f?.isRefreshingTitleHidden = true
        
        self.mj_header = h
        self.mj_footer = f
    }
    
    func setRefresh(page: Int, header: @escaping refreshBlock, footer: @escaping refreshBlock) {
        
        let h = MJRefreshGifHeader.init {
            self.pageNum = 1
            header(self.pageNum)
            self.mj_header.endRefreshing()
        }
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.stateLabel.textColor = refreshColor
        
        self.pageNum = page
        let f = MJRefreshAutoGifFooter.init(refreshingBlock: {
            self.pageNum += 1
            footer(self.pageNum)
            self.mj_footer.endRefreshing()
        })
        
        f?.setTitle("", for: .idle)
        f?.setTitle("", for: .refreshing)
        f?.setTitle("没有更多了哦", for: .noMoreData)
        f?.setImages(idleImages, for: .idle)
        f?.setImages(pullingImages, for: .refreshing)
        f?.isRefreshingTitleHidden = true
        
        self.mj_header = h
        self.mj_footer = f
    }
    
    func setGifRefresh(header: @escaping refreshBlock, footer: @escaping refreshBlock) {
        
        let h = MJRefreshGifHeader.init {
            self.pageNum = 1
            header(self.pageNum)
            self.mj_header.endRefreshing()
        }
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.setImages(idleImages, for: .idle)
        h?.setImages(pullingImages, for: .pulling)
        h?.setImages(refreshingImages, for: .refreshing)
        h?.setTitle("加载数据中..", for: .idle)
        h?.setTitle("加载数据中..", for: .pulling)
        h?.setTitle("加载数据中..", for: .refreshing)
        h?.stateLabel.textColor = refreshColor
        
        let f = MJRefreshAutoGifFooter.init(refreshingBlock: {
            self.pageNum += 1
            footer(self.pageNum)
            self.mj_footer.endRefreshing()
        })
        
        f?.setTitle("", for: .idle)
        f?.setTitle("", for: .refreshing)
        f?.setTitle("没有更多了哦", for: .noMoreData)
        f?.setImages(idleImages, for: .idle)
        f?.setImages(pullingImages, for: .refreshing)
        f?.isRefreshingTitleHidden = true
        
        self.mj_header = h
        self.mj_footer = f
    }
    
}

class FYRefreshCollection: UICollectionView {
    
    var pageNum: Int = 1
    
    func setRefresh(header: @escaping refreshBlock, footer: @escaping refreshBlock) {
        
        let h = MJRefreshGifHeader.init {
            self.pageNum = 1
            header(self.pageNum)
            self.mj_header.endRefreshing()
        }
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.stateLabel.textColor = refreshColor
        
        let f = MJRefreshAutoGifFooter.init(refreshingBlock: {
            self.pageNum += 1
            footer(self.pageNum)
            self.mj_footer.endRefreshing()
        })
        
        f?.setTitle("", for: .idle)
        f?.setTitle("", for: .refreshing)
        f?.setTitle("没有更多了哦", for: .noMoreData)
        f?.setImages(idleImages, for: .idle)
        f?.setImages(pullingImages, for: .refreshing)
        f?.isRefreshingTitleHidden = true
        
        self.mj_header = h
        self.mj_footer = f
    }
    
    func setRefresh(page: Int, header: @escaping refreshBlock, footer: @escaping refreshBlock) {
        
        let h = MJRefreshGifHeader.init {
            self.pageNum = 1
            header(self.pageNum)
            self.mj_header.endRefreshing()
        }
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.stateLabel.textColor = refreshColor
        
        self.pageNum = page
        let f = MJRefreshAutoGifFooter.init(refreshingBlock: {
            self.pageNum += 1
            footer(self.pageNum)
            self.mj_footer.endRefreshing()
        })
        
        f?.setTitle("", for: .idle)
        f?.setTitle("", for: .refreshing)
        f?.setTitle("没有更多了哦", for: .noMoreData)
        f?.setImages(idleImages, for: .idle)
        f?.setImages(pullingImages, for: .refreshing)
        f?.isRefreshingTitleHidden = true
        
        self.mj_header = h
        self.mj_footer = f
    }
    
    func setGifRefresh(header: @escaping refreshBlock, footer: @escaping refreshBlock) {
        
        let h = MJRefreshGifHeader.init {
            self.pageNum = 1
            header(self.pageNum)
            self.mj_header.endRefreshing()
        }
        h?.lastUpdatedTimeLabel.isHidden = true
        h?.setImages(idleImages, for: .idle)
        h?.setImages(pullingImages, for: .pulling)
        h?.setImages(refreshingImages, for: .refreshing)
        h?.setTitle("加载数据中..", for: .idle)
        h?.setTitle("加载数据中..", for: .pulling)
        h?.setTitle("加载数据中..", for: .refreshing)
        h?.stateLabel.textColor = refreshColor
        
        let f = MJRefreshAutoGifFooter.init(refreshingBlock: {
            self.pageNum += 1
            footer(self.pageNum)
            self.mj_footer.endRefreshing()
        })
        
        f?.setTitle("", for: .idle)
        f?.setTitle("", for: .refreshing)
        f?.setTitle("没有更多了哦", for: .noMoreData)
        f?.setImages(idleImages, for: .idle)
        f?.setImages(pullingImages, for: .refreshing)
        f?.isRefreshingTitleHidden = true
        
        self.mj_header = h
        self.mj_footer = f
    }
    
}
