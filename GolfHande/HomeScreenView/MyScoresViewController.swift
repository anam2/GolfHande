import FirebaseDatabase
import UIKit

class MyScoresViewController: UIViewController {
    private var viewModel: MyScoresViewModel
    private let contentView: MyScoresView

    // MARK: UI COMPONENTS

    private var activityView = UIActivityIndicatorView(style: .large)

    private lazy var MyScoresPlusButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(myScoresPlusButtonClicked(_:)))
        return barButtonItem
    }()

    // MARK: INITIALIZER

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
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.setupNavigationBar()
        self.setupUI()
        self.setupDelegates()
        // Make service calls to populate view model.
        self.showActivityIndicator()
        viewModel.loadViewModel {
            self.contentView.scoresTableView.reloadData()
            dispatchGroup.leave()

        }
        dispatchGroup.notify(queue: .main) {
            self.hideActivityIndicator()
        }
    }

    // MARK: SETUP UI

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = MyScoresPlusButton
    }

    private func setupUI() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .none
        self.view.addSubview(contentView)
        contentView.constrain(to: self.view,
                              constraints: [.top(.zero), .leading(.zero),
                                            .trailing(.zero), .bottom(.zero)])
    }

    private func setupDelegates() {
        contentView.scoresTableView.delegate = self
        contentView.scoresTableView.dataSource = self
    }

    // MARK: PLUS BUTTON FUNCTION

    @objc private func myScoresPlusButtonClicked(_ selector: UIBarButtonItem) {
        NSLog("Print Button Clicked:\n")
        navigationController?.pushViewController(ScoreInputViewController(), animated: true)
    }

    // MARK: SPINNING INDICATOR

    func showActivityIndicator() {
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }

    func hideActivityIndicator(){
        activityView.stopAnimating()
    }
}

// MARK: TABLE VIEW DELEGATE

extension MyScoresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MyScoresViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userScoreArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scoresTableViewCell",
                                                       for: indexPath) as? ScoresTableViewCell,
              let courseID = viewModel.getCourseID(for: indexPath.row),
              let courseInfo = viewModel.getCourseInfo(for: courseID)
        else { return UITableViewCell() }

        cell.setupCellData(dateAdded: "MM/DD/YY",
                           courseName: courseInfo.name,
                           courseRating: courseInfo.rating,
                           courseSlope: courseInfo.slope,
                           handicapValue: "T.E")
        return cell
    }
}
