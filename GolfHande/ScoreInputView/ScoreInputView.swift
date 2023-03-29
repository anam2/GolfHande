import UIKit

class ScoreInputView: UIView {

    var textFields = [UITextField]()

    // MARK: UI COMPONENTS

    private lazy var userScoreView: UIView = {
        CoreUI.createLabelTextFieldView(labelText: "Score", textField: userScoreTextField)
    }()

    lazy var userScoreTextField: UITextField = {
        let textField = CoreUI.textFieldView(informationButtonIsEnabled: true)
        textField.keyboardType = .asciiCapableNumberPad
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
        // Course List Button
        addSubview(courseListButton)
        courseListButton.constrain(to: self, constraints: [.top(20), .leading(20), .trailing(-20)])
        // User Score View
        addSubview(userScoreView)
        userScoreView.constrain(to: self, constraints: [.leading(20), .trailing(-20)])
        userScoreView.constrain(to: courseListButton, constraints: [.topToBottom(30)])
        // Submit Button
        addSubview(submitButton)
        submitButton.constrain(to: userScoreView, constraints: [.topToBottom(40)])
        submitButton.constrain(to: self, constraints: [.centerX(.zero), .bottom(-20)])
    }
}
