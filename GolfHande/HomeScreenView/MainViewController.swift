import FirebaseDatabase
import UIKit

class MainViewController: UIViewController {
    private var viewModel: MainViewModel
    private let contentView: MainView

    public init() {
        viewModel = MainViewModel()
        contentView = MainView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    // MARK: LIFE CYCLE

    /// Called ONCE when view is first loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupButtonActions()
        self.setupUI()
        // Constraint Setups
        self.setupDelegates()
        self.setupConstraintsForContentView()
    }

    /// Will be called everytime view appears.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getScoresFromDatabase {
            self.contentView.scoresTableView.reloadData() 
            self.hideActivityIndicator()
        }
        self.showActivityIndicator()
    }

    private func setupDelegates() {
        contentView.scoresTableView.delegate = self
        contentView.scoresTableView.dataSource = self
    }

    // MARK: SETUP UI

    private func setupNavigation() {
        self.navigationController?.navigationBar.barTintColor = .white
    }

    private func setupUI() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .none
        self.view.addSubview(contentView)
    }

    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupButtonActions() {
        contentView.scoreInputViewButton.addTarget(self, action: #selector(scoreInputButtonAction), for: .touchUpInside)
    }

    // MARK: SPINNING INDICATOR

    var activityView = UIActivityIndicatorView(style: .large)

    func showActivityIndicator() {
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }

    func hideActivityIndicator(){
        activityView.stopAnimating()
    }

    // MARK: ACTIONS

    @objc private func scoreInputButtonAction() {
        self.navigationController?.pushViewController(ScoreInputViewController(), animated: true)
    }

    @objc func navBarDoneAction() {
        print("done clicked")
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.scoresData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ScoresTableViewCell = tableView.dequeueReusableCell(withIdentifier: "scoresTableViewCell",
                                                                            for: indexPath) as? ScoresTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCellData(with: viewModel.scoresData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

