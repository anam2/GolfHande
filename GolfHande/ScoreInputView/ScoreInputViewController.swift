import UIKit

class ScoreInputViewController: UIViewController {

    private let contentView: ScoreInputView
    private let viewModel: ScoreInputViewModel

    public init() {
        viewModel = ScoreInputViewModel()
        contentView = ScoreInputView()
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraintsForContentView()
        setupButtonAction()
    }

    private func setupUI() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
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

    private func setupButtonAction() {
        contentView.submitButton.addTarget(self, action: #selector(submitButtonAction),
                                           for: .touchUpInside)
    }

    // MARK: ACTIONS

    @objc private func submitButtonAction() {
        guard let courseName = contentView.courseNameTextField.text,
              let courseRating = contentView.courseRatingTextField.text,
              let totalScore = contentView.totalScoreTextField.text,
              let slopeRating = contentView.slopeRatingTextField.text else {
            // TODO: Need to handle error case for when some of text field are not filled out by user.
            return
        }
        print("Submit Button Tapped\nCourse Rating: \(viewModel.courseRating)\nTotal Score: \(viewModel.totalScore)\nSlope Rating: \(viewModel.slopeRating)")
        let scoreData = ScoreData(courseName: courseName,
                                  totalScore: totalScore,
                                  slopeRating: slopeRating,
                                  courseRating: courseRating)
        viewModel.addScoreToDatabase(scoreData: scoreData)
    }
}

// MARK: TEXT FIELD DELEGATE

extension ScoreInputViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch(textField) {
        case contentView.courseRatingTextField:
            viewModel.courseRating = contentView.courseRatingTextField.text ?? ""
        case contentView.totalScoreTextField:
            viewModel.totalScore = contentView.totalScoreTextField.text ?? ""
        default:
            return
        }
    }
}
