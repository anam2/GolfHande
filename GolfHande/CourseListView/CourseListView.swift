import UIKit

class CourseListView: UIView {

    // MARK: INITIALIZER

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    // MARK: UI COMPONENTS

    lazy var courseListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CourseListCell.self, forCellReuseIdentifier: "courseListCell")
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: SETUP UI

    private func setupUI() {
        addSubview(courseListTableView)
        courseListTableView.constrain(to: self,
                                      constraints: [.top(20), .leading(20), .trailing(-20), .bottom(-20)])
    }
}
