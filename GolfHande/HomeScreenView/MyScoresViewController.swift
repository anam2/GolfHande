import FirebaseDatabase
import UIKit

class MyScoresViewController: UIViewController {
    private var viewModel: MyScoresViewModel
    private let contentView: MyScoresView

    public init() {
        viewModel = MyScoresViewModel()
        contentView = MyScoresView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    // MARK: LIFE CYCLE

    /// Called ONCE when view is first loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupUI()
        // Constraint Setups
        self.setupDelegates()
        self.setupConstraintsForContentView()

    }

    private func setupDelegates() {
        contentView.scoresTableView.delegate = self
        contentView.scoresTableView.dataSource = self
    }

    /// Will be called everytime view appears.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }

    private func fetchData() {
        self.showActivityIndicator()
        viewModel.fetchScores { success in
            if success {
                self.contentView.scoresTableView.reloadData()
                self.hideActivityIndicator()
            }
        }
    }

    // MARK: SETUP UI

    private lazy var MyScoresPlusButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(myScoresPlusButtonClicked(_:)))
        return barButtonItem
    }()

    @objc private func myScoresPlusButtonClicked(_ selector: UIBarButtonItem) {
        NSLog("Print Button Clicked:\n")
        navigationController?.pushViewController(ScoreInputViewController(), animated: true)
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = MyScoresPlusButton
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
}

extension MyScoresViewController: UITableViewDelegate, UITableViewDataSource {
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

