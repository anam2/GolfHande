import UIKit

class CourseListViewController: UIViewController {

    private let contentView: CourseListView
    private let viewModel: CourseListViewModel

    // MARK: UI COMPONENTS

    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add,
                               target: self,
                               action: #selector(addButtonClicked(_:)))
    }()

    // MARK: INITIALIZER

    init() {
        contentView = CourseListView()
        viewModel = CourseListViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    // MARK: LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupUI()
        self.setupDelegates()
    }

    // TODO: NEED TO CACHE DATA IN FUTURE. USE A VARIABLE AS A FLAG AND INIT(PARAMS:?) IF NIL MAKE SERVICE CALL ELSE USE CACHE
    override func viewWillAppear(_ animated: Bool) {
        loadViewModel()
    }

    // MARK: SET UP

    private func loadViewModel() {
        self.showActivityIndicator()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.viewModel.loadViewModel { success in
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.contentView.courseListTableView.reloadData()
            self.hideActivityIndicator()
        }
    }

    private func setupNavigation() {
        navigationItem.title = "Course List"
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupDelegates() {
        contentView.courseListTableView.delegate = self
        contentView.courseListTableView.dataSource = self
    }

    private func setupUI() {
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        view.addSubview(contentView)
        contentView.constrain(to: view,
                              constraints: [.top(.zero), .leading(.zero), .trailing(.zero), .bottom(.zero)])
    }

    // MARK: NAV BAR ADD BUTTON

    @objc private func addButtonClicked(_ sender: UIBarButtonItem) {
        NSLog("Add course button clicked")
        navigationController?.pushViewController(CourseInputViewController(courseList: viewModel.courseList),
                                                 animated: true)
    }
}

// MARK: TABLE VIEW METHODS

extension CourseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.courseList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CourseListCell = tableView.dequeueReusableCell(withIdentifier: "courseListCell",
                                                                       for: indexPath) as? CourseListCell
        else { return UITableViewCell()}
        let courseName = viewModel.courseList[indexPath.row].name
        let courseSlope = viewModel.courseList[indexPath.row].slope
        let courseRating = viewModel.courseList[indexPath.row].rating
        cell.setupCell(courseName: courseName,
                       courseRating: courseRating,
                       courseSlope: courseSlope)
        return cell
    }
}

extension CourseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController,
              let scoreInputViewController
                = navigationController.viewControllers[navigationController.viewControllers.count - 2]
                as? ScoreInputViewController
        else { return }

        let selectedCourseID = viewModel.courseList[indexPath.row].id
        navigationController.popViewController(animated: true)
        scoreInputViewController.setSelectedCourseID(selectedCourseID: selectedCourseID)
    }
}
