import UIKit

class ScoreInputView: UIView {

    // MARK: INITIAZLIER

    init() {
        super.init(frame: .zero)
        setupView()
        setupUI()
        setupConstraints()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    // MARK: SETUP UI

    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
    }

    private func setupUI() {
        addSubview(courseNameTextField)
        addSubview(totalScoreTextField)
        addSubview(courseRatingTextField)
        addSubview(slopeRatingTextField)
        addSubview(submitButton)
    }

    private func setupConstraints() {
        setupConstraintsForCourseNameTextField()
        setupConstraintsForTotalScoreTextField()
        setupConstraintsForCourseRatingTextField()
        setupConstraintsForSlopeRatingTextField()
        setupConstraintsForSubmitButton()
    }

    private func setupConstraintsForCourseNameTextField() {
        NSLayoutConstraint.activate([
            courseNameTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            courseNameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    private func setupConstraintsForTotalScoreTextField() {
        NSLayoutConstraint.activate([
            totalScoreTextField.topAnchor.constraint(equalTo: courseNameTextField.bottomAnchor, constant: 20),
            totalScoreTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    private func setupConstraintsForCourseRatingTextField() {
        NSLayoutConstraint.activate([
            courseRatingTextField.topAnchor.constraint(equalTo: totalScoreTextField.bottomAnchor, constant: 20),
            courseRatingTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    private func setupConstraintsForSlopeRatingTextField() {
        NSLayoutConstraint.activate([
            slopeRatingTextField.topAnchor.constraint(equalTo: courseRatingTextField.bottomAnchor, constant: 20),
            slopeRatingTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    private func setupConstraintsForSubmitButton() {
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: slopeRatingTextField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    // MARK: UI COMPONENTS

    private func getTextFieldView(text: String) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = text
        textField.textAlignment = .center
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }

    lazy var courseNameTextField: UITextField = {
        getTextFieldView(text: "Course Name")
    }()

    lazy var courseRatingTextField: UITextField = {
        getTextFieldView(text: "Course Rating")
    }()

    lazy var slopeRatingTextField: UITextField = {
        getTextFieldView(text: "Slope Rating")
    }()

    lazy var totalScoreTextField: UITextField = {
        getTextFieldView(text: "Total Score")
    }()

    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.backgroundColor = .blue
        button.setTitle("Enter", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

}
