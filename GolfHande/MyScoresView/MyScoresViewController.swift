import FirebaseDatabase
import UIKit

class MyScoresViewController: UIViewController {
    private var viewModel: MyScoresViewModel
    private let contentView: MyScoresView

    // MARK: UI COMPONENTS

    private var activityView = UIActivityIndicatorView(style: .large)

    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add,
                               target: self,
                               action: #selector(addButtonClicked(_:)))
    }()

    private lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Edit",
                               style: .plain,
                               target: self,
                               action: #selector(editButtonClicked(_:)))
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
        setupNavigationBar()
        setupUI()
        setupDelegates()
        // Make service calls to populate view model.
        showActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadViewModel()
    }

    private func loadViewModel() {
        self.showActivityIndicator()
        viewModel.loadViewModel { status in
            DispatchQueue.main.async {
                if self.viewModel.userScoreArray.isEmpty {
                    self.editButton.title = "Edit"
                    self.editButton.isEnabled = false
                    self.contentView.scoresTableView.isEditing = false
                } else {
                    self.editButton.isEnabled = true
                }
            }
            self.contentView.handicapValueLabel.text = self.viewModel.getUsersHandicap()
            self.contentView.scoresTableView.reloadData()
            self.hideActivityIndicator()
        }
    }

    // MARK: SETUP UI

    private func setupUI() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .none
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    private func setupDelegates() {
        contentView.scoresTableView.delegate = self
        contentView.scoresTableView.dataSource = self
    }

    // MARK: NAV BAR SETUP

    private func setupNavigationBar() {
        navigationController?.view.backgroundColor = .systemBackground
        navigationItem.title = "Scores View"
        navigationItem.rightBarButtonItems = [editButton, addButton]
    }

    @objc private func addButtonClicked(_ selector: UIBarButtonItem) {
        NSLog("Print Button Clicked:\n")
        let scoreInputDataModel = ScoreInputDataModel(golfCourses: viewModel.golfCourseArray,
                                                      selectedScoreData: SelectedScoreInput())
        let scoreInputViewModel = ScoreInputViewModel(scoreInputDataModel)
        let scoreInputViewController = ScoreInputViewController(navigationTitle: "Add Score", scoreInputViewModel)
        navigationController?.pushViewController(scoreInputViewController, animated: true)
    }

    @objc private func editButtonClicked(_ selector: UIBarButtonItem) {
        NSLog("Edit button clicked")
        contentView.scoresTableView.isEditing = !contentView.scoresTableView.isEditing

        if self.contentView.scoresTableView.isEditing {
            selector.title = "Done"
        } else {
            selector.title = "Edit"
        }
    }
}

// MARK: TABLE VIEW DELEGATE

extension MyScoresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.userScoreArray.isEmpty {
            return tableView.frame.height
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: tableView.frame.width-10,
                                              height: tableView.frame.height))
        headerView.addSubview(contentView.handicapLabel)
        contentView.handicapLabel.constrain(to: headerView, constraints: [.top(10), .centerX(.zero)])

        headerView.addSubview(contentView.handicapValueLabel)
        contentView.handicapValueLabel.constrain(to: headerView,
                                                 constraints: [.centerX(.zero), .bottom(-10)])
        contentView.handicapValueLabel.constrain(to: contentView.handicapLabel,
                                                 constraints: [.topToBottom(5)])
        return headerView
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if viewModel.userScoreArray.isEmpty { return .none }
        return .delete
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        // Perform the corresponding action for each row when editing is enabled
        if editingStyle == .delete {
            NSLog("Delete action?")
            print(viewModel.userScoreArray[indexPath.row])
            let scoreID = viewModel.userScoreArray[indexPath.row].id
            ServiceCalls.shared.deleteScore(for: scoreID) { success in
                if !success {
                    NSLog("Failed to delete score.")
                    return
                }
                self.loadViewModel()
            }
        }
    }
}

extension MyScoresViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userScoreArray.isEmpty ? 1 : viewModel.userScoreArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.userScoreArray.isEmpty {
            guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell",
                                                                for: indexPath) as? EmptyCell
            else { return UITableViewCell() }

            return emptyCell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scoresTableViewCell",
                                                       for: indexPath) as? ScoresTableViewCell,
              let courseID = viewModel.getCourseID(for: indexPath.row),
              let courseInfo = viewModel.getCourseInfo(for: courseID)
        else { return UITableViewCell() }

        cell.setupCellData(dateAdded: viewModel.userScoreArray[indexPath.row].dateAdded,
                           courseName: courseInfo.name,
                           courseRating: courseInfo.rating,
                           courseSlope: courseInfo.slope,
                           userScoreValue: viewModel.userScoreArray[indexPath.row].score)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedScore = viewModel.userScoreArray[indexPath.row]
        let selectedScoreData = SelectedScoreInput(scoreID: selectedScore.id,
                                                   courseID: selectedScore.courseID,
                                                   userScore: selectedScore.score)
        let scoreInputDataModel = ScoreInputDataModel(golfCourses: viewModel.golfCourseArray,
                                                      selectedScoreData: selectedScoreData)
        let scoreInputViewModel = ScoreInputViewModel(scoreInputDataModel)
        let scoreInputViewController = ScoreInputViewController(navigationTitle: "Edit Score",
                                                                scoreInputViewModel,
                                                                viewControllerState: .edit)
        scoreInputViewController.setSelectedCourseID(selectedCourseID: selectedScore.courseID)
        navigationController?.pushViewController(scoreInputViewController, animated: true)
    }
}
