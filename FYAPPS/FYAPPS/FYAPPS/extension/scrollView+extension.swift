import UIKit

enum FY_Direction: Int {
    case top = 0
    case left = 1
    case bottom = 2
    case right = 3
}

extension UIScrollView {
    
    /**
     禁用滚动条
     */
    func fy_scrollCutBar() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    /**
     禁用反弹效果
     */
    func fy_scrollCutBounces() {
        self.bounces = false
    }
    
    /**
     开启分页
     */
    func fy_scrollOpenPaging() {
        self.isPagingEnabled = true
    }
    
    // 设置缩放倍数
    func fy_scrollZoom(min: CGFloat, max: CGFloat) {
        self.minimumZoomScale = min
        self.maximumZoomScale = max
    }
    
    // 设置内容缩进 (上, 左, 下, 右)
    func fy_scrollInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    // 滚动 scrollView 到某个方向
    func fy_scrollTo(direction: FY_Direction, animated: Bool) {
        var off = self.contentOffset
        switch direction {
        case .top:
            off.y = 0 - self.contentInset.top
            break
        case .left:
            off.x = 0 - self.contentInset.left
            break
        case .right:
            off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right
            break
        default:
            off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
            break
        }
        self.setContentOffset(off, animated: animated)
    }
    
}
