import UIKit

class MainView: UIView {
    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupMainView()
        setupUI()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    private func setupUI() {
        addSubview(scoreInputViewButton)
        scoreInputViewButton.constrain(to: self, constraints: [.top(20), .centerX(0)])

        addSubview(scoresTableView)
        scoresTableView.constrain(to: scoreInputViewButton,
                                  constraints: [.topToBottom(20)])
        scoresTableView.constrain(to: self,
                                  constraints: [.leading(20), .trailing(-20), .bottom(0)])
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

    lazy var scoreInputViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Score Input View", for: .normal)
        return button
    }()
}
