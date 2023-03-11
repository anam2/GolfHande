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

        addSubview(golfHoleButtonView)
        golfHoleButtonView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        golfHoleButtonView.constrain(to: courseNameView, constraints: [.topToBottom(30)])

        addSubview(userScoreView)
        userScoreView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        userScoreView.constrain(to: golfHoleButtonView, constraints: [.topToBottom(30)])

        addSubview(courseSlopeView)
        courseSlopeView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseSlopeView.constrain(to: userScoreView, constraints: [.topToBottom(30)])

        addSubview(courseRatingView)
        courseRatingView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        courseRatingView.constrain(to: courseSlopeView, constraints: [.topToBottom(30)])

        addSubview(submitButton)
        submitButton.constrain(to: courseRatingView, constraints: [.topToBottom(40)])
        submitButton.constrain(to: self, constraints: [.centerX(.zero)])
    }

    // MARK: UI COMPONENTS

    private lazy var golfHoleButtonView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [eightTeenHoleButton, nineHoleButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        return stackView
    }()

    private lazy var eightTeenHoleButton: UIButton = {
        let button = CoreUI.selectionButton(text: "18 Hole", isSelected: true,
                                            action: #selector(golfHoleSelectionClicked))
        return button
    }()

    private lazy var nineHoleButton: UIButton = {
        let button = CoreUI.selectionButton(text: "9 Hole", isSelected: false,
                                            action: #selector(golfHoleSelectionClicked))
        return button
    }()

    @objc private func golfHoleSelectionClicked(_ sender: UIButton) {
        switch sender {
        case eightTeenHoleButton:
            sender.isEnabled = false
            nineHoleButton.isEnabled = true
            return
        case nineHoleButton:
            sender.isEnabled = false
            eightTeenHoleButton.isEnabled = true
            return
        default:
            return
        }
    }

    private lazy var courseNameView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Name", textField: courseNameTextField)
    }()

    private lazy var userScoreView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Score", textField: totalScoreTextField)
    }()

    private lazy var courseSlopeView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Slope", textField: courseSlopeTextField)
    }()

    private lazy var courseRatingView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Course Rating", textField: courseRatingTextField)
    }()

    lazy var courseNameTextField: UITextField = {
        let textField = CoreUI.textFieldView(informationButtonIsEnabled: true)
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
        guard let courseName = courseNameTextField.text, !courseName.isEmpty,
              let courseSlope = courseSlopeTextField.text, !courseSlope.isEmpty,
              let courseRating = courseRatingTextField.text, !courseRating.isEmpty,
              let userScore = totalScoreTextField.text, !userScore.isEmpty,
              sender.isEnabled == false
        else {
          self.submitButton.isEnabled = false
          return
        }
        // Enable submit button if all UITextField is populated.
        self.submitButton.isEnabled = true
       }

}
