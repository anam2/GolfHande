import UIKit

class ScoreInputViewController: UIViewController {

    private let contentView: ScoreInputView
    private let viewModel: ScoreInputViewModel

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // MARK: INITIAZLIER

    public init(_ viewModel: ScoreInputViewModel) {
        self.viewModel = viewModel
        self.contentView = ScoreInputView()
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init?(coder aDecoder: NSCoder) { nil }

    // MARK: LIFE CYCLE FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        hideKeyboardWhenTappedAround()
        setupNavbar()
        setupUI()
        setupConstraintsForContentView()
        setupTextFieldDelegates()
        setupButtonAction()
    }

    // MARK: SETUP FUNCTIONS

    private func setupUI() {
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        scrollView.addSubview(contentView)
    }

    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupNavbar() {
        navigationItem.title = "Add Score"
    }

    private func setupTextFieldDelegates() {
        contentView.userScoreTextField.delegate = self
    }

    private func setupButtonAction() {
        contentView.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        contentView.courseListButton.addTarget(self, action: #selector(courseListButtonAction), for: .touchUpInside)
        contentView.userScoreTextField.addTarget(self, action: #selector(validationForSubmitButton),
                                                 for: .editingChanged)
    }

    // MARK: BUTTON FUNCTIONS

    @objc private func testButtonClicked(_ sender: UIButton) {
        print("Information button clicked")
    }

    @objc func validationForSubmitButton(_ sender: UITextField) {
        guard let userScore = contentView.userScoreTextField.text,
              !userScore.isEmpty,
              viewModel.intIsInbetween(range: (40...140), for: userScore),
              !viewModel.selectedCourseID.isEmpty
        else {
            showEmptyTextFieldError(for: sender)
            showTextFieldError(for: sender)
            contentView.submitButton.isEnabled = false
            return
        }
        // Hide any error and enable submit button if all UITextField is populated.
        sender.hideError()
        contentView.submitButton.isEnabled = true
    }

    @objc private func courseListButtonAction() {
        navigationController?.pushViewController(CourseListViewController(), animated: true)
    }

    @objc private func submitButtonAction() {
        guard let userScore = contentView.userScoreTextField.text,
              !viewModel.selectedCourseID.isEmpty,
              let scoreHandicap = viewModel.calculateHandicap(courseID: viewModel.selectedCourseID,
                                                              userScore: userScore)
        else {
            NSLog("A text field with empty string got passed")
            return
        }
        let scoreID = UUID().uuidString
        let userScoreData = UserScoreData(id: scoreID,
                                          courseID: viewModel.selectedCourseID,
                                          dateAdded: viewModel.getCurrentDateAsString(),
                                          score: userScore,
                                          handicap: scoreHandicap)
        ServiceCalls.addScore(userScoreData: userScoreData)
        navigationController?.popToRootViewController(animated: true)
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
        case contentView.userScoreTextField:
            guard let userScoreString = contentView.userScoreTextField.text,
                  let userScoreInt = Int(userScoreString) else {
                textField.showError(with: "Input needs to be a number")
                return
            }
            if !(40...140).contains(userScoreInt) {
                textField.showError(with: "Score needs to be between 40 and 140")
                return
            }
        default:
            textField.hideError()
            return
        }
    }

    // MARK: KEYBOARD FUNCTIONS

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
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

// MARK: TEXT FIELD DELEGATE

extension ScoreInputViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case contentView.userScoreTextField:
            // Can only be numbers and have a max length of 3.
            let containsNumbersOnly = containsDecimalDigitOnly(inputString: string)
            let limitStringLength = limitTextFieldLength(maxLength: 3,
                                                         textField: textField,
                                                         range: range,
                                                         inputString: string)
            return containsNumbersOnly && limitStringLength ? true : false
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
