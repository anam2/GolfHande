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

    public init() {
        viewModel = ScoreInputViewModel()
        contentView = ScoreInputView()
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
        contentView.courseNameTextField.delegate = self
        contentView.courseRatingTextField.delegate = self
        contentView.courseSlopeTextField.delegate = self
        contentView.userScoreTextField.delegate = self
    }

    private func setupButtonAction() {
        contentView.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        contentView.courseListButton.addTarget(self, action: #selector(courseListButtonAction), for: .touchUpInside)
    }

    // MARK: ACTIONS

    @objc private func courseListButtonAction() {
        navigationController?.pushViewController(CourseListViewController(), animated: true)
    }

    @objc private func submitButtonAction() {
        guard let courseName = contentView.courseNameTextField.text,
              let userScore = contentView.userScoreTextField.text,
              let courseSlope = contentView.courseSlopeTextField.text,
              let courseRating = contentView.courseRatingTextField.text,
              let scoreHandicap = viewModel.calculateHandicap(userScore: userScore,
                                                              courseRating: courseRating,
                                                              courseSlope: courseSlope)
        else {
            NSLog("A text field with empty string got passed")
            return
        }
        let scoreID = UUID().uuidString
        let courseID = UUID().uuidString
        let userScoreData = UserScoreData(id: scoreID,
                                          courseID: courseID,
                                          dateAdded: viewModel.getCurrentDateAsString(),
                                          score: userScore,
                                          handicap: scoreHandicap)
        let courseData = GolfCourseData(id: courseID,
                                        name: courseName,
                                        rating: courseRating,
                                        slope: courseSlope)
        ServiceCalls.addScore(userScoreData: userScoreData, courseData: courseData)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: TEXT FIELD DELEGATE

extension ScoreInputViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case contentView.courseSlopeTextField, contentView.userScoreTextField:
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
