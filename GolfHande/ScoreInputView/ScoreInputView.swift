import UIKit

class ScoreInputView: UIView {

    var textFields = [UITextField]()

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

        addSubview(numericInputsStackView)
        numericInputsStackView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        numericInputsStackView.constrain(to: courseNameView, constraints: [.topToBottom(30)])

        addSubview(submitButton)
        submitButton.constrain(to: numericInputsStackView, constraints: [.topToBottom(40)])
        submitButton.constrain(to: self, constraints: [.centerX(.zero)])
    }

    // MARK: UI COMPONENTS

    private lazy var numericInputsStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [totalScoreView, courseSlopeView, courseRatingView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()

    private lazy var courseNameView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Name", textField: courseNameTextField)
    }()

    private lazy var totalScoreView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Score", labelAlignment: .center, textField: totalScoreTextField)
    }()

    private lazy var courseSlopeView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Slope", labelAlignment: .center, textField: courseSlopeTextField)
    }()

    private lazy var courseRatingView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Rating", labelAlignment: .center, textField: courseRatingTextField)
    }()

    lazy var courseNameTextField: UITextField = {
        let textField = CoreUI.textFieldView()
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        return textField
    }()

    lazy var totalScoreTextField: UITextField = {
        let textField = CoreUI.textFieldView()
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        return textField
    }()

    lazy var courseSlopeTextField: UITextField = {
        let textField = CoreUI.textFieldView()
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        return textField
    }()

    lazy var courseRatingTextField: UITextField = {
        let textField = CoreUI.textFieldView()
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
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

    @objc func textFieldsIsNotEmpty(sender: UITextField) {

        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

        guard
            let courseName = courseNameTextField.text, !courseName.isEmpty,
            let courseSlope = courseSlopeTextField.text, !courseSlope.isEmpty,
            let courseRating = courseRatingTextField.text, !courseRating.isEmpty,
            let userScore = totalScoreTextField.text, !userScore.isEmpty
        else {
          self.submitButton.isEnabled = false
          return
        }
        // Enable submit button if all UITextField is populated.
        self.submitButton.isEnabled = true
       }

}
