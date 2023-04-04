import UIKit

class ScoreInputView: UIView {

    // MARK: UI COMPONENTS

    private lazy var courseNameLabel: UILabel = {
        let courseNameLabel = CoreUI.defaultUILabel(fontSize: 14.0,
                                                    numberOfLines: 1,
                                                    lineBreakMode: .byTruncatingMiddle)
        return courseNameLabel
    }()
    private lazy var emptyLabel: UILabel = {
        let emptyLabel = CoreUI.defaultUILabel(fontSize: 14.0)
        emptyLabel.text = "SELECT A COURSE"
        return emptyLabel
    }()

    lazy var emptyCourseInfoView: UIView = {
        let emptyCourseInfoView = UIView()
        emptyCourseInfoView.layer.borderWidth = 5.0
        emptyCourseInfoView.layer.borderColor = UIColor.lightGrayBackground.cgColor
        emptyCourseInfoView.addSubview(emptyLabel,
                                       constraints: [.centerX(.zero), .top(20), .bottom(-20)])
        return emptyCourseInfoView
    }()

    lazy var courseInfoView: UIView = {
        let courseInfoView = UIView()
        courseInfoView.layer.borderWidth = 2.0
        courseInfoView.layer.borderColor = UIColor.lightGrayBackground.cgColor
        courseInfoView.addSubview(courseNameLabel,
                                  constraints: [.top(20), .leading(20), .trailing(-20), .bottom(-20)])
        return courseInfoView
    }()

    private lazy var userScoreTextFieldLabel: UILabel = {
        return CoreUI.createTextFieldLabel(text: "SCORE")
    }()

    lazy var userScoreTextField: UITextField = {
        let textField = CoreUI.createTextField()
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()

    private lazy var userScoreView: UIView = {
        let userScoreView = UIView()
        userScoreView.addSubview(userScoreTextFieldLabel,
                                 constraints: [.top(.zero), .leading(.zero), .trailing(.zero)])
        userScoreView.addSubview(userScoreTextField,
                                 constraints: [.leading(.zero), .trailing(.zero), .bottom(.zero)])
        userScoreTextField.constrain(to: userScoreTextFieldLabel,
                                     constraints: [.topToBottom(5)])
        return userScoreView
    }()

    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.isEnabled = false
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.backgroundColor = .blue
        button.setTitle("Submit", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

    // MARK: INITIAZLIER

    init() {
        super.init(frame: .zero)
        setupView()
        setupUI()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    // MARK: SETUP UI

    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
    }

    private func setupUI() {
        addSubview(emptyCourseInfoView, constraints: [.top(20), .leading(20), .trailing(-20)])
        addSubview(userScoreView, constraints: [.leading(20), .trailing(-20)])
        userScoreView.constrain(to: emptyCourseInfoView, constraints: [.topToBottom(20)])
        addSubview(submitButton, constraints: [.centerX(.zero), .bottom(-20)])
        submitButton.constrain(to: userScoreView, constraints: [.topToBottom(30)])
    }

    // MARK: FUNCTIONS

    func setCourseInfoText(courseName: String, courseRating: String, courseSlope: String) {
        courseNameLabel.text = "\(courseName) (\(courseRating) | \(courseSlope))"
        replaceEmptyCourseInfoView()
    }

    private func replaceEmptyCourseInfoView() {
        addSubview(courseInfoView, constraints: [.top(20), .leading(20), .trailing(-20)])
        userScoreView.constrain(to: courseInfoView, constraints: [.topToBottom(20)])
        emptyCourseInfoView.removeFromSuperview()
        self.layoutIfNeeded()
    }
}
