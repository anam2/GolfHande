import UIKit

class CourseListView: UIView {

    // MARK: INITIALIZER

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    // MARK: UI COMPONENTS

    private lazy var footerView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return footerView
    }()

    lazy var courseListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CourseListCell.self, forCellReuseIdentifier: "courseListCell")
        tableView.register(EmptyCell.self, forCellReuseIdentifier: "emptyCell")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = footerView
        return tableView
    }()

    // MARK: SETUP UI

    private func setupUI() {
        addSubview(courseListTableView, constraints: [.top(20), .leading(20), .trailing(-20), .bottom(-20)])
    }
}
