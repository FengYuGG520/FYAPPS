import UIKit

class FYTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        // 去掉 cell 选中的阴影
        self.selectionStyle = .none
    }
    
    func fy_cellOpenArrows() {
        /**
         *  cell 右边的配件
         *  UITableViewCellAccessoryNone                    无
         *  UITableViewCellAccessoryDisclosureIndicator     >
         *  UITableViewCellAccessoryDetailDisclosureButton  !>
         *  UITableViewCellAccessoryCheckmark               √
         *  UITableViewCellAccessoryDetailButton            !
         */
        // 给 cell 右边设置一个箭头
        self.accessoryType = .disclosureIndicator
    }
    
}
