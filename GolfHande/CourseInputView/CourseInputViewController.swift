import UIKit

class CourseInputViewController: UIViewController {
    private let contentView: CourseInputView
    private let viewModel: CourseInputViewModel

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    init() {
        viewModel = CourseInputViewModel()
        contentView = CourseInputView()
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupUI()
    }

    private func setupNavbar() {
        navigationItem.title = "Add Course"
    }

    private func setupUI() {
        edgesForExtendedLayout = []
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.constrain(to: view, constraints: [.top(.zero), .leading(.zero), .trailing(.zero), .bottom(.zero)])
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])

        scrollView.addSubview(contentView)
        contentView.constrain(to: scrollView, constraints: [.top(.zero), .leading(.zero), .trailing(.zero), .bottom(.zero)])
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}
