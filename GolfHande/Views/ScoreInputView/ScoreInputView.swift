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

    lazy var scoreInputViewButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.layer.cornerRadius = 5
        button.backgroundColor = .blue
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.isEnabled = false
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

        addSubview(scoreInputViewButton, constraints: [.centerX(.zero), .bottom(-20)])
        scoreInputViewButton.constrain(to: userScoreView, constraints: [.topToBottom(30)])
    }

    // MARK: FUNCTIONS

    /**
      Set's the course information text of the selected course by user.
     - Parameters:
        - courseName: [String] Course name text that is going to be displayed.
        - courseRating: [String] Coursse rating text that is going to be displayed.
        - courseSlope: [String] Course slope text that is going to be displayed.
     */
    func setCourseInfoText(courseName: String, courseRating: String, courseSlope: String) {
        courseNameLabel.text = "\(courseName) (\(courseRating) | \(courseSlope))"
        replaceEmptyCourseInfoView()
    }

    /**
     Replaces the EmptyCourseInfoView and replaced it with CourseInfoView.
     */
    private func replaceEmptyCourseInfoView() {
        addSubview(courseInfoView, constraints: [.top(20), .leading(20), .trailing(-20)])
        userScoreView.constrain(to: courseInfoView, constraints: [.topToBottom(20)])
        emptyCourseInfoView.removeFromSuperview()
        self.layoutIfNeeded()
    }
}
