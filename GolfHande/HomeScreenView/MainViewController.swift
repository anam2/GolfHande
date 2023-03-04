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
        self.setupConstraintsForContentView()
    }

    /// Will be called everytime view appears.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getScoresFromDatabase {
            self.updateValuesForView()
            self.hideActivityIndicator()
        }
        self.showActivityIndicator()
    }

    private func updateValuesForView() {
        contentView.courseNameLabel.text?.append(String(viewModel.scoresData[0].courseName))
        contentView.totalScoreLabel.text?.append(String(viewModel.scoresData[0].totalScore))
        contentView.courseSlopeLabel.text?.append(String(viewModel.scoresData[0].slopeRating))
        contentView.courseRatingLabel.text?.append(String(viewModel.scoresData[0].courseRating))
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

