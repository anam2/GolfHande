import UIKit

class CourseInputView: UIView {

    // MARK: UI COMPONENTS

    private lazy var courseNameLabel: UILabel = {
        return CoreUI.createTextFieldLabel(text: "COURSE NAME")
    }()

    lazy var courseNameTextField: UITextField = {
        let textField = CoreUI.createTextField()
        return textField
    }()

    private lazy var courseSlopeLabel: UILabel = {
        return CoreUI.createTextFieldLabel(text: "COURSE SLOPE")
    }()

    lazy var courseSlopeTextField: UITextField = {
        let textField = CoreUI.createTextField()
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()

    private lazy var courseRatingLabel: UILabel = {
        return CoreUI.createTextFieldLabel(text: "COURSE RATING")
    }()

    lazy var courseRatingTextField: UITextField = {
        let textField = CoreUI.createTextField()
        textField.keyboardType = .decimalPad
        return textField
    }()

    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.setTitle("Submit", for: .normal)
        button.isEnabled = false
        return button
    }()

    // MARK: INITIALIZER

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    // MARK: SETUP UI

    private func setupUI() {
        addSubview(courseNameLabel)
        courseNameLabel.constrain(to: self, constraints: [.top(20), .leading(20)])

        addSubview(courseNameTextField)
        courseNameTextField.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseNameTextField.constrain(to: courseNameLabel, constraints: [.topToBottom(5)])

        addSubview(courseSlopeLabel)
        courseSlopeLabel.constrain(to: self, constraints: [.leading(20)])
        courseSlopeLabel.constrain(to: courseNameTextField, constraints: [.topToBottom(20)])

        addSubview(courseSlopeTextField)
        courseSlopeTextField.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseSlopeTextField.constrain(to: courseSlopeLabel, constraints: [.topToBottom(5)])

        addSubview(courseRatingLabel)
        courseRatingLabel.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseRatingLabel.constrain(to: courseSlopeTextField, constraints: [.topToBottom(20)])

        addSubview(courseRatingTextField)
        courseRatingTextField.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseRatingTextField.constrain(to: courseRatingLabel, constraints: [.topToBottom(5)])

        addSubview(submitButton)
        submitButton.constrain(to: self, constraints: [.leading(20), .trailing(-20), .bottom(-20)])
        submitButton.constrain(to: courseRatingTextField, constraints: [.topToBottom(30)])
    }
}
