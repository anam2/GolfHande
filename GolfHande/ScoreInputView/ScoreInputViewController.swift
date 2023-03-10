import UIKit

class ScoreInputViewController: UIViewController {

    private let contentView: ScoreInputView
    private let viewModel: ScoreInputViewModel

    public init() {
        viewModel = ScoreInputViewModel()
        contentView = ScoreInputView()
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraintsForContentView()
        setupTextFieldDelegates()
        setupButtonAction()
    }

    private func setupUI() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        self.view.addSubview(contentView)
    }

    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupTextFieldDelegates() {
        contentView.courseNameTextField.delegate = self
        contentView.courseRatingTextField.delegate = self
        contentView.courseSlopeTextField.delegate = self
        contentView.totalScoreTextField.delegate = self
    }

    private func setupButtonAction() {
        contentView.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
    }

    // MARK: ACTIONS

    @objc private func submitButtonAction() {
        guard let courseName = contentView.courseNameTextField.text,
              let courseRating = contentView.courseRatingTextField.text,
              let totalScore = contentView.totalScoreTextField.text,
              let slopeRating = contentView.courseSlopeTextField.text else {
            // TODO: Need to handle error case for when some of text field are not filled out by user.
            return
        }
        NSLog("Submit Button Pressed:\nCourse Name: \(courseName)\nCourse Rating: \(courseRating)\nTotal Score: \(totalScore)\nSlope Rating: \(slopeRating)")
        let scoreData = ScoreData(scoreId: UUID().uuidString,
                                  courseName: courseName,
                                  totalScore: totalScore,
                                  slopeRating: slopeRating,
                                  courseRating: courseRating)
        viewModel.addScoreToDatabase(scoreData: scoreData)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: TEXT FIELD DELEGATE

extension ScoreInputViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldText = textField.text,
           textFieldText.isEmpty {
            textField.setupStringErrorDisplay("Cannot be empty.")
            return
        }
        textField.hideErrorDisplay()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        // Can ONLY be numbers
        // Need to limit between 55 and 155 ( Need to be done when enable / disable submit button )
        // Limit to 3 characters
        case contentView.courseSlopeTextField:
            let containsNumbersOnly = containsDecimalDigitOnly(inputString: string)
            let limitStringLength = limitTextFieldLength(maxLength: 3,
                                                         textField: textField,
                                                         range: range,
                                                         inputString: string)
            return containsNumbersOnly && limitStringLength ? true : false
        case contentView.totalScoreTextField:
            let containsNumbersOnly = containsDecimalDigitOnly(inputString: string)
            let limitStringLength = limitTextFieldLength(maxLength: 3,
                                                         textField: textField,
                                                         range: range,
                                                         inputString: string)
            return containsNumbersOnly && limitStringLength ? true : false
        case contentView.courseRatingTextField:
            // Need to define case that only allows one ".".
            // Maybe some formatting as well.
            let allowedChars =  setAllowedChars(as: "1234567890.", inputString: string)
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
