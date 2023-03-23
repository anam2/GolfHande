import UIKit

class ScoreInputView: UIView {

    var textFields = [UITextField]()

    // MARK: UI COMPONENTS

    private lazy var courseNameView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Name", textField: courseNameTextField)
    }()

    private lazy var userScoreView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Score", textField: userScoreTextField)
    }()

    private lazy var courseSlopeView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Slope", textField: courseSlopeTextField)
    }()

    private lazy var courseRatingView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Rating", textField: courseRatingTextField)
    }()

    lazy var courseNameTextField: UITextField = {
        let textField = CoreUI.textFieldView()
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        return textField
    }()


    lazy var userScoreTextField: UITextField = {
        let textField = CoreUI.textFieldView(informationButtonIsEnabled: true, buttonAction: #selector(testButtonClicked))
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()

    lazy var courseSlopeTextField: UITextField = {
        let textField = CoreUI.textFieldView(informationButtonIsEnabled: true, buttonAction: #selector(testButtonClicked))
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()

    lazy var courseRatingTextField: UITextField = {
        let textField = CoreUI.textFieldView(informationButtonIsEnabled: true, buttonAction: #selector(testButtonClicked))
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        textField.keyboardType = .decimalPad
        return textField
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

    lazy var courseListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.backgroundColor = .blue
        button.setTitle("Course List", for: .normal)
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
        addSubview(courseNameView)
        courseNameView.constrain(to: self, constraints: [.top(20), .leading(20), .trailing(-20)])

        addSubview(courseListButton)
        courseListButton.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseListButton.constrain(to: courseNameView, constraints: [.topToBottom(30)])

        addSubview(userScoreView)
        userScoreView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        userScoreView.constrain(to: courseListButton, constraints: [.topToBottom(30)])

        addSubview(courseSlopeView)
        courseSlopeView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseSlopeView.constrain(to: userScoreView, constraints: [.topToBottom(30)])

        addSubview(courseRatingView)
        courseRatingView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseRatingView.constrain(to: courseSlopeView, constraints: [.topToBottom(30)])

        addSubview(submitButton)
        submitButton.constrain(to: courseRatingView, constraints: [.topToBottom(40)])
        submitButton.constrain(to: self, constraints: [.centerX(.zero), .bottom(-20)])
    }

    // MARK: @OBJC FUNCTIONS

    @objc private func testButtonClicked(_ sender: UIButton) {
        print("Information button clicked")
    }

    @objc func textFieldsIsNotEmpty(_ sender: UITextField) {
        guard let courseName = courseNameTextField.text, !courseName.isEmpty,
              let courseSlope = courseSlopeTextField.text, !courseSlope.isEmpty,
              let courseRating = courseRatingTextField.text, !courseRating.isEmpty,
              let userScore = userScoreTextField.text, !userScore.isEmpty,
              intIsInbetween(range: (40...140), for: courseSlope),
              doubleIsInbetween(range: (40.0...95.0), for: courseRating),
              intIsInbetween(range: (40...140), for: userScore)
        else {
            showEmptyTextFieldError(for: sender)
            showTextFieldError(for: sender)
            self.submitButton.isEnabled = false
            return
        }
        // Hide any error and enable submit button if all UITextField is populated.
        sender.hideError()
        self.submitButton.isEnabled = true
    }

    // MARK: TEXT FIELD ERROR HANDLING

    private func showEmptyTextFieldError(for textField: UITextField) {
        textField.hideError()
        if let textFieldText = textField.text, textFieldText.isEmpty {
            textField.showError(with: "Cannot be empty")
        }
    }

    private func showTextFieldError(for textField: UITextField) {
        // Hide any previous errors.
        textField.hideError()
        switch textField {
        case userScoreTextField:
            guard let userScoreString = userScoreTextField.text,
                  let userScoreInt = Int(userScoreString) else {
                textField.showError(with: "Input needs to be a number")
                return
            }
            if !(40...140).contains(userScoreInt) {
                textField.showError(with: "Score needs to be between 40 and 140")
                return
            }
        case courseSlopeTextField:
            guard let courseSlopeString = courseSlopeTextField.text,
                  let courseSlopeInt = Int(courseSlopeString) else {
                textField.showError(with: "Input needs to be a number.")
                return
            }
            if !(40...140).contains(courseSlopeInt) {
                textField.showError(with: "Slope needs to be between 40 and 140")
                return
            }
        case courseRatingTextField:
            guard let courseRatingString = courseRatingTextField.text,
                  let courseRatingDouble = Double(courseRatingString) else {
                textField.showError(with: "Input needs to be a decimal number")
                return
            }
            if !(40.0...95.0).contains(courseRatingDouble) {
                textField.showError(with: "Slope needs to be between 40.0 and 95.0")
                return
            }
        default:
            textField.hideError()
            return
        }
    }

    private func intIsInbetween(range: ClosedRange<Int>, for num: String) -> Bool {
        guard let intNum = Int(num),
              range.contains(intNum) else { return false }
        return true
    }

    private func doubleIsInbetween(range: ClosedRange<Double>, for num: String) -> Bool {
        guard let doubleNum = Double(num),
              range.contains(doubleNum) else { return false }
        return true
    }
}
