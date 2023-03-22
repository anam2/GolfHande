import FirebaseDatabase
import UIKit

class MyScoresViewController: UIViewController {
    private var viewModel: MyScoresViewModel
    private let contentView: MyScoresView

    // MARK: UI COMPONENTS

    private var activityView = UIActivityIndicatorView(style: .large)

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
        self.setupNavigationBar()
        self.setupUI()
        self.setupDelegates()
        // Make service calls to populate view model.
        self.showActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showActivityIndicator()
        viewModel.loadViewModel {
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
        contentView.constrain(to: self.view,
                              constraints: [.top(.zero), .leading(.zero),
                                            .trailing(.zero), .bottom(.zero)])
    }

    private func setupDelegates() {
        contentView.scoresTableView.delegate = self
        contentView.scoresTableView.dataSource = self
    }

    // MARK: NAV BAR SETUP

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addButtonClicked(_:)))
        let editButton = UIBarButtonItem(title: "Edit",
                                         style: .plain,
                                         target: self,
                                         action: #selector(editButtonClicked(_:)))
        navigationItem.rightBarButtonItems = [editButton, addButton]
    }

    @objc private func addButtonClicked(_ selector: UIBarButtonItem) {
        NSLog("Print Button Clicked:\n")
        navigationController?.pushViewController(ScoreInputViewController(), animated: true)
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
        // Specify the editing style for each row
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
            ServiceCalls.deleteScore(for: scoreID) { success in
                if !success {
                    NSLog("Failed to delete score.")
                    return
                }
                self.showActivityIndicator()
                self.viewModel.loadViewModel {
                    self.contentView.handicapValueLabel.text = self.viewModel.getUsersHandicap()
                    self.contentView.scoresTableView.reloadData()
                    self.hideActivityIndicator()
                    return
                }
            }
        }
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

        cell.setupCellData(dateAdded: viewModel.userScoreArray[indexPath.row].dateAdded,
                           courseName: courseInfo.name,
                           courseRating: courseInfo.rating,
                           courseSlope: courseInfo.slope,
                           userScoreValue: viewModel.userScoreArray[indexPath.row].score)
        return cell
    }
}
