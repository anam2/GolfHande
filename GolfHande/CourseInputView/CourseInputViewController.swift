import UIKit

class CourseInputViewController: UIViewController {

    private let contentView: CourseInputView
    private let courseList: [GolfCourseData]

    // MARK: UI COMPONENTS

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // MARK: INITIALIZER

    init(courseList: [GolfCourseData]) {
        self.courseList = courseList
        contentView = CourseInputView()
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setupNavbar()
        setupDelegates()
        setupAddTargets()
        setupUI()
    }

    // MARK: UI SETUP

    private func setupNavbar() {
        navigationItem.title = "Add Course"
    }

    private func setupUI() {
        edgesForExtendedLayout = []
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.constrain(to: view,
                             constraints: [.top(.zero), .leading(.zero), .trailing(.zero), .bottom(.zero)])
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])

        scrollView.addSubview(contentView)
        contentView.constrain(to: scrollView,
                              constraints: [.top(.zero), .leading(.zero), .trailing(.zero), .bottom(.zero)])
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    private func setupDelegates() {
        contentView.courseNameTextField.delegate = self
        contentView.courseSlopeTextField.delegate = self
        contentView.courseRatingTextField.delegate = self
    }

    private func setupAddTargets() {
        contentView.courseNameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                                  for: .editingChanged)
        contentView.courseSlopeTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                                  for: .editingChanged)
        contentView.courseRatingTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                                  for: .editingChanged)
        contentView.submitButton.addTarget(self, action: #selector(submitButtonPressed),
                                           for: .touchUpInside)
    }

    // MARK: SUBMIT BUTTON

    @objc private func submitButtonPressed(_ sender: UIButton) {
        guard let courseName = contentView.courseNameTextField.text,
              let courseSlope = contentView.courseSlopeTextField.text,
              let courseRating = contentView.courseRatingTextField.text
        else { return }
        let courseData = GolfCourseData(id: UUID().uuidString,
                                        name: courseName.capitalized,
                                        rating: courseRating,
                                        slope: courseSlope)
        ServiceCalls.addCourse(courseData: courseData) { success in
            if !success { return }
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: KEYBOARD FUNCTIONS

    private func setupKeyboard() {
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

// MARK: TEXT FIELD METHODS

extension CourseInputViewController: UITextFieldDelegate {
    @objc func textFieldsIsNotEmpty(_ sender: UITextField) {
        guard let courseName = contentView.courseNameTextField.text, !courseName.isEmpty,
              let courseSlope = contentView.courseSlopeTextField.text, !courseSlope.isEmpty,
              let courseRating = contentView.courseRatingTextField.text, !courseRating.isEmpty,
              intIsInbetween(range: (40...140), for: courseSlope),
              doubleIsInbetween(range: (40.0...95.0), for: courseRating)
        else {
            showTextFieldError(for: sender)
            contentView.submitButton.isEnabled = false
            return
        }
        // Hide any error and enable submit button if all UITextField is populated.
        sender.hideError()
        contentView.submitButton.isEnabled = true
    }

    private func showTextFieldError(for textField: UITextField) {
        // Hide any previous errors.
        textField.hideError()
        if let textFieldText = textField.text, textFieldText.isEmpty {
            textField.showError(with: "Cannot be empty")
            return
        }
        switch textField {
        case contentView.courseSlopeTextField:
            guard let courseSlopeString = contentView.courseSlopeTextField.text,
                  let courseSlopeInt = Int(courseSlopeString) else {
                textField.showError(with: "Input needs to be a number.")
                return
            }
            if !(40...140).contains(courseSlopeInt) {
                textField.showError(with: "Slope needs to be between 40 and 140")
                return
            }
        case contentView.courseRatingTextField:
            guard let courseRatingString = contentView.courseRatingTextField.text,
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case contentView.courseSlopeTextField:
            // Can only be numbers and have a max length of 3.
            let containsNumbersOnly = containsDecimalDigitOnly(inputString: string)
            let limitStringLength = limitTextFieldLength(maxLength: 3,
                                                         textField: textField,
                                                         range: range,
                                                         inputString: string)
            return containsNumbersOnly && limitStringLength ? true : false
        case contentView.courseRatingTextField:
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
