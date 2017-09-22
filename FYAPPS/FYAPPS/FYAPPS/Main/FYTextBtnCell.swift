// 继承并设置需要改变的属性
// 设置文本数组
// 记录高度
// 注意: 如果要设置 属性或者 btnNoClickBoolArr, 请先设置 属性和 btnNoClickBoolArr
// 然后才能设置 textArr
// 最后拿到 cellHeight 记得记录

import UIKit

class FYTextBtnCell: UITableViewCell {
    
    // 设置文本的内边距
    var textTopPad: CGFloat = FYLen.inUI(4.0)
    var textLeftPad: CGFloat = FYLen.inUI(12.0)
    // 设置文本的外边距
    var textRightMag: CGFloat = FYLen.inUI(12.0)
    var textBottomMag: CGFloat = FYLen.inUI(14.0)
    // 设置文字的大小
    var textFont: CGFloat = FYLen.inUI(14.0)
    // 设置视图缩进 上左下右
    var viewEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(FYLen.inUI(20), FYLen.inUI(68), FYLen.inUI(20), FYLen.inUI(20))
    // 按钮的radius
    var btnRadius: CGFloat = FYLen.inUI(6)
    
    // 这里得到 cell 的高度
    var cellHeight: CGFloat = 0.0
    
    var clickBlock: ((_ text: String, _ btn: UIButton, _ btnArrIndex: Int)->())?
    
    let baseTextBtnTag = 45620
    
    var btnNoClickBoolArr: [Bool]?
    
    var textArr: [String]? {
        
        didSet {
            guard textArr != nil else {
                return
            }
            // 清空 cell 里面全部的子控件
            for subView in self.subviews {
                subView.removeFromSuperview()
            }
            // 临时记录按钮行数
            var line: CGFloat = 1
            // 临时记录btn的x
            var btnX: CGFloat = viewEdgeInsets.left
            // 记录文字高度
            var btnHeight: CGFloat = 0
            // 记录最后一个按钮的y
            var lastBtnY: CGFloat = 0
            
            for i in 0..<(textArr?.count)! {
                
                // 得到当前按钮的Size
                let textSize = FYSize.fy_text(textArr?[i], font: textFont)
                let btnWidth = textSize.width + (textLeftPad * 2)
                btnHeight = textSize.height + (textTopPad * 2)
                // 得到下个按钮的Width
                var nextTextSize: CGSize = CGSize(width: 0, height: 0)
                if i + 1 != textArr?.count {
                    nextTextSize = FYSize.fy_text(textArr?[i + 1], font: textFont)
                }
                let nextBtnWidth = nextTextSize.width  + (textLeftPad * 2)
                
                let btn = UIButton()
                btn.tag = i + baseTextBtnTag
                btn.backgroundColor = UIColor.white
                btn.setTitle(textArr![i], for: .normal)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.titleLabel?.textAlignment = .center
                btn.titleLabel?.font = UIFont.systemFont(ofSize: textFont)
                btn.fy_border(color: UIColor.black, width: 1)
                btn.fy_radius(btnRadius)
                btn.addTarget(self, action: #selector(click(btn: )), for: .touchUpInside)
                
                btn.frame = CGRect(x: btnX, y: (line - 1) * (btnHeight + textBottomMag) + viewEdgeInsets.top, width: btnWidth, height: btnHeight)
                
                if btnNoClickBoolArr != nil && btnNoClickBoolArr![i] {
                    btn.isUserInteractionEnabled = false
                    btn.setTitleColor(UIColor.gray, for: .normal)
                    btn.fy_border(color: UIColor.gray, width: 1)
                }
                self.addSubview(btn)
                
                if btnX + btnWidth + textRightMag + nextBtnWidth + viewEdgeInsets.right > screenWidth {
                    line += 1
                    btnX = viewEdgeInsets.left
                } else {
                    btnX += (btnWidth + textRightMag)
                }
                
                if i == (textArr?.count)! - 1 {
                    lastBtnY = btn.frame.origin.y
                }
                
                
            }
            
            // 计算视图高度
            self.cellHeight = lastBtnY + btnHeight + viewEdgeInsets.bottom
        }
        
    }
    
    func click(btn: UIButton) {
        
        for btn in self.subviews {
            if btn.isMember(of: UIButton.self) {
                let b = btn as! UIButton
                if b.isUserInteractionEnabled {
                    b.backgroundColor = UIColor.white
                    b.setTitleColor(UIColor.black, for: .normal)
                }
            }
        }
        
        btn.backgroundColor = UIColor.black
        btn.setTitleColor(UIColor.white, for: .normal)
        
        if clickBlock != nil {
            clickBlock!((btn.titleLabel?.text)!, btn, btn.tag - baseTextBtnTag)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
