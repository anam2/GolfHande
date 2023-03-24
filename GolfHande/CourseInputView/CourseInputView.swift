import UIKit

class CourseInputView: UIView {

    // MARK: UI COMPONENTS

    private lazy var courseNameLabel: UILabel = {
        return CoreUI.createTextFieldLabel(text: "COURSE NAME")
    }()

    private lazy var courseNameTextField: UITextField = {
        let textField = CoreUI.createTextField(delegate: self)
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                            for: .editingChanged)
        return textField
    }()

    private lazy var courseSlopeLabel: UILabel = {
        return CoreUI.createTextFieldLabel(text: "COURSE SLOPE")
    }()

    private lazy var courseSlopeTextField: UITextField = {
        let textField = CoreUI.createTextField(delegate: self)
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                            for: .editingChanged)
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()

    private lazy var courseRatingLabel: UILabel = {
        return CoreUI.createTextFieldLabel(text: "COURSE RATING")
    }()

    private lazy var courseRatingTextField: UITextField = {
        let textField = CoreUI.createTextField(delegate: self)
        textField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                            for: .editingChanged)
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var submitButton: UIButton = {
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

    // MARK: TEXT FIELD ERROR HANDLING

    @objc func textFieldsIsNotEmpty(_ sender: UITextField) {
        guard let courseName = courseNameTextField.text, !courseName.isEmpty,
              let courseSlope = courseSlopeTextField.text, !courseSlope.isEmpty,
              let courseRating = courseRatingTextField.text, !courseRating.isEmpty,
              intIsInbetween(range: (40...140), for: courseSlope),
              doubleIsInbetween(range: (40.0...95.0), for: courseRating)
        else {
            showTextFieldError(for: sender)
            self.submitButton.isEnabled = false
            return
        }
        // Hide any error and enable submit button if all UITextField is populated.
        sender.hideError()
        self.submitButton.isEnabled = true
    }

    private func showTextFieldError(for textField: UITextField) {
        // Hide any previous errors.
        textField.hideError()
        if let textFieldText = textField.text, textFieldText.isEmpty {
            textField.showError(with: "Cannot be empty")
            return
        }
        switch textField {
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

extension CourseInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case courseSlopeTextField:
            // Can only be numbers and have a max length of 3.
            let containsNumbersOnly = containsDecimalDigitOnly(inputString: string)
            let limitStringLength = limitTextFieldLength(maxLength: 3,
                                                         textField: textField,
                                                         range: range,
                                                         inputString: string)
            return containsNumbersOnly && limitStringLength ? true : false
        case courseRatingTextField:
            // Can only be numbers with decimal point and have a max length of 4.
            let allowedChars = setAllowedChars(as: "1234567890.", inputString: string)
            let limitStringLength = limitTextFieldLength(maxLength: 4,
                                                         textField: textField,
                                                         range: range,
                                                         inputString: string)
            return allowedChars && limitStringLength ? true : false
        default:
            return true
        }
    }

    /// Returns a BOOL value that indicates whether `inputString` contains only `CharacterSet.decimalDeigits`.
    private func containsDecimalDigitOnly(inputString: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: inputString)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    /// Returns a BOOL value that indicates whether `inputString` contains only `as characters: String`.
    private func setAllowedChars(as characters: String, inputString: String) -> Bool {
        let set = NSCharacterSet(charactersIn: characters).inverted
        return inputString.rangeOfCharacter(from: set) == nil
    }

    /// Limits the character length in UITextField.
    private func limitTextFieldLength(maxLength: Int,
                                      minLength: Int = 0,
                                      textField: UITextField,
                                      range: NSRange,
                                      inputString: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText)
        else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + inputString.count
        let lengthRange = minLength...maxLength
        return lengthRange.contains(count) ? true : false
    }
}
