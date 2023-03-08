import UIKit

class MyScoresView: UIView {
    private let viewModel: MyScoresViewModel

    init(viewModel: MyScoresViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupMainView()
        setupUI()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    private func setupUI() {
        addSubview(scoresTableView)
        scoresTableView.constrain(to: self,
                                  constraints: [.top(20), .leading(20), .trailing(-20), .bottom(0)])
    }

    private func setupMainView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
    }

    // MARK: UI COMPONENTS

    lazy var scoresTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScoresTableViewCell.self, forCellReuseIdentifier: "scoresTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        return tableView
    }()
}
