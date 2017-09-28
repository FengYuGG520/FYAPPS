import UIKit

extension UITableView {
    
    func fy_tableRegisterXib(_ xibName: String, _ reuseId: String) {
        self.register(UINib.init(nibName: xibName, bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    func fy_target(_ target: Any) {
        self.delegate = target as? UITableViewDelegate
        self.dataSource = target as? UITableViewDataSource
    }
    
    func fy_cutSeparator() {
        self.separatorStyle = .none
    }
    
    func fy_reload(row: Int, section: Int, animation: UITableViewRowAnimation) {
        self.reloadRows(at: [IndexPath.init(row: row, section: section)], with: animation)
    }
    
    func fy_tableScrollTo(row: Int, section: Int) {
        self.scrollToRow(at: IndexPath.init(row: row, section: section), at: .top, animated: true)
    }
    
}
