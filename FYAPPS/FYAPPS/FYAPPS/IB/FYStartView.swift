import UIKit

class FYStartView: UIView {
    
    @IBInspectable var imageLight: UIImage = UIImage(named: "selectedStar")!// 评分选中图片
    @IBInspectable var imageDark: UIImage = UIImage(named: "normalStar")!// 评分背景图片
    
    @IBInspectable var rating: CGFloat = 0 {// 当前数值
        didSet {
            if 0 > rating { rating = 0 }
            else if ratingMax < rating { rating = ratingMax }
            // 回调给代理
            delegate?.ratingDidChange(self, rating: rating)
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var ratingMax: CGFloat = 5// 总数值, 必须为 numStars 的倍数
    @IBInspectable var numStars: Int = 5 // 星星总数
    @IBInspectable var canAnimation: Bool = false// 是否开启动画模式
    @IBInspectable var animationTimeInterval: TimeInterval = 0.2// 动画时间
    @IBInspectable var incomplete:Bool = false// 评分时是否允许不是整颗星星
    @IBInspectable var isIndicator:Bool = false// RatingBar 是否是一个指示器 (不需要更改)
    
    var foregroundRatingView: UIView!
    var backgroundRatingView: UIView!
    
    var delegate: FYStartViewDelegate?
    var isDrew = false
    
    func buildView() {
        if isDrew { return }
        isDrew = true
        self.backgroundRatingView = self.createRatingView(imageDark)
        self.foregroundRatingView = self.createRatingView(imageLight)
        animationRatingChange()
        self.addSubview(self.backgroundRatingView)
        self.addSubview(self.foregroundRatingView)
        // 加入单击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FYStartView.tapRateView(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildView()
        let animationTimeInterval = self.canAnimation ? self.animationTimeInterval : 0
        // 开启动画改变foregroundRatingView可见范围
        UIView.animate(withDuration: animationTimeInterval, animations: { self.animationRatingChange() })
    }
    
    // 改变foregroundRatingView可见范围
    func animationRatingChange() {
        let realRatingScore = self.rating / self.ratingMax
        self.foregroundRatingView.frame = CGRect(x: 0, y: 0,width: self.bounds.size.width * realRatingScore, height: self.bounds.size.height)
    }
    
    // 根据图片名，创建一列RatingView
    func createRatingView(_ image: UIImage) ->UIView {
        let view = UIView(frame: self.bounds)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        // 开始创建子Item,根据numStars总数
        for position in 0 ..< numStars {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: CGFloat(position) * self.bounds.size.width / CGFloat(numStars), y: 0, width: self.bounds.size.width / CGFloat(numStars), height: self.bounds.size.height)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            view.addSubview(imageView)
        }
        return view
    }
    
    // 点击编辑分数后，通过手势的x坐标来设置数值
    func tapRateView(_ sender: UITapGestureRecognizer) {
        if isIndicator { return }// 如果是指示器，就不能交互
        let tapPoint = sender.location(in: self)
        let offset = tapPoint.x
        // 通过x坐标判断分数
        let realRatingScore = offset / (self.bounds.size.width / ratingMax)
        self.rating = self.incomplete ? realRatingScore : round(realRatingScore)
    }
}

protocol FYStartViewDelegate {
    func ratingDidChange(_ ratingBar: FYStartView,rating: CGFloat)
}
