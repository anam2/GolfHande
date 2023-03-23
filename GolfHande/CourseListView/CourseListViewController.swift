import UIKit

class CourseListViewController: UIViewController {

    private let contentView: CourseListView
    private let viewModel: CourseListViewModel

    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add,
                               target: self,
                               action: #selector(addButtonClicked(_:)))
    }()

    @objc private func addButtonClicked(_ sender: UIBarButtonItem) {
        NSLog("Add course button clicked")
        navigationController?.pushViewController(CourseInputViewController(), animated: true)
    }

    init() {
        contentView = CourseListView()
        viewModel = CourseListViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        loadViewModel()
        setupDelegates()
        setupUI()
    }

    private func loadViewModel() {
        self.showActivityIndicator()
        viewModel.loadViewModel { success in
            self.contentView.courseListTableView.reloadData()
            self.hideActivityIndicator()
        }
    }

    private func setupNavigation() {
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
}

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
        cell.setupCell(topText: courseName,
                       bottomText: courseSlope + " | " + courseRating)
        return cell
    }
}

extension CourseListViewController: UITableViewDelegate {

}
