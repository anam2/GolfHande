import UIKit

class CourseInputView: UIView {

    // MARK: UI COMPONENTS

    private lazy var courseNameLabel: UILabel = {
        let label = createUILabel(text: "COURSE NAME")
        return label
    }()

    private lazy var courseNameTextField: UITextField = {
        let textField = getTextField()
        return textField
    }()

    private lazy var courseSlopeLabel: UILabel = {
        let label = createUILabel(text: "COURSE SLOPE")
        return label
    }()

    private lazy var courseSlopeTextField: UITextField = {
        let textField = getTextField()
        return textField
    }()

    private lazy var courseRatingLabel: UILabel = {
        let label = createUILabel(text: "COURSE RATING")
        return label
    }()

    private lazy var courseRatingTextField: UITextField = {
        let textField = getTextField()
        return textField
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.isEnabled = false
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.backgroundColor = .blue
        button.setTitle("Submit", for: .normal)
        return button
    }()

    private func createUILabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.text = text
        return label
    }

    private func getTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.textAlignment = .left
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.backgroundColor = .lightGrayBackground
        return textField
    }

    // MARK: INITIALIZER

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

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
        submitButton.constrain(to: courseRatingTextField, constraints: [.topToBottom(40)])
    }
}

extension CourseInputView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
}
