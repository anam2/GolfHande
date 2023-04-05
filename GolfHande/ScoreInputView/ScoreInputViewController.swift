import UIKit

enum ScoreInputViewControllerState: String {
    case edit
    case add
}

class ScoreInputViewController: UIViewController {

    private let contentView: ScoreInputView
    private let viewModel: ScoreInputViewModel
    private let viewControllerState: ScoreInputViewControllerState

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // MARK: INITIAZLIER

    public init(_ viewModel: ScoreInputViewModel,
                viewControllerState: ScoreInputViewControllerState = .add) {
        self.viewModel = viewModel
        self.contentView = ScoreInputView()
        self.viewControllerState = viewControllerState
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        setupButtons(viewControllerState: viewControllerState)
        setupTextFieldDelegates()
        setupButtonAction()
        setupInputViewForEdit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        validationForSubmitButton()
    }

    // MARK: SETUP FUNCTIONS

    private func setupInputViewForEdit() {
        if let selectedScoreData = viewModel.dataModel.selectedScoreData,
           viewControllerState == .edit {
            contentView.userScoreTextField.text = selectedScoreData.userScore
        }
    }

    private func setupNavbar() {
        navigationItem.title = "Add Score"
    }

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
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupButtons(viewControllerState: ScoreInputViewControllerState) {
        switch viewControllerState {
        case .add:
            contentView.scoreInputViewButton.setTitle("Submit", for: .normal)
            contentView.scoreInputViewButton.addTarget(self,
                                                       action: #selector(submitButtonAction),
                                                       for: .touchUpInside)
            return
        case .edit:
            contentView.scoreInputViewButton.setTitle("Edit", for: .normal)
            contentView.scoreInputViewButton.addTarget(self,
                                                       action: #selector(editButtonAction),
                                                       for: .touchUpInside)
            return
        }
    }

    private func setupTextFieldDelegates() {
        contentView.userScoreTextField.delegate = self
    }

    private func setupButtonAction() {
        let courseInfoViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(courseInfoViewAction))
        let emptyCourseInfoViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(emptyCourseListAction))
        contentView.courseInfoView.addGestureRecognizer(courseInfoViewTapGesture)
        contentView.emptyCourseInfoView.addGestureRecognizer(emptyCourseInfoViewTapGesture)
        contentView.userScoreTextField.addTarget(self, action: #selector(validationForScoreTextField), for: .editingChanged)
    }

    // MARK: INTERNAL FUNCTIONS

    func setSelectedCourseID(selectedCourseID: String) {
        viewModel.dataModel.selectedScoreData?.courseID = selectedCourseID
        guard let selectedCourseData = viewModel.selectedCourse else { return }
        contentView.setCourseInfoText(courseName: selectedCourseData.name,
                                      courseRating: selectedCourseData.rating,
                                      courseSlope: selectedCourseData.slope)
    }

    // MARK: BUTTON FUNCTIONS

    @objc func validationForSubmitButton() {
        if let userScore = contentView.userScoreTextField.text,
           !userScore.isEmpty,
           viewModel.intIsInbetween(range: (40...140), for: userScore),
           viewModel.selectedCourse != nil {
            contentView.scoreInputViewButton.isEnabled = true
        } else {
            contentView.scoreInputViewButton.isEnabled = false
        }
    }

    @objc func validationForScoreTextField(_ sender: UITextField) {
        guard let userScore = contentView.userScoreTextField.text,
              !userScore.isEmpty,
              viewModel.intIsInbetween(range: (40...140), for: userScore)
        else {
            showEmptyTextFieldError(for: sender)
            showTextFieldError(for: sender)
            validationForSubmitButton()
            return
        }
        // Hide any error and enable submit button if all UITextField is populated.
        sender.hideError()
        validationForSubmitButton()
    }

    @objc private func emptyCourseListAction() {
        navigationController?.pushViewController(CourseListViewController(), animated: true)
    }

    @objc private func submitButtonAction() {
        guard let userScore = contentView.userScoreTextField.text,
              let selectedScoreData = viewModel.dataModel.selectedScoreData,
              let scoreHandicap = viewModel.calculateHandicap(courseID: selectedScoreData.courseID,
                                                              userScore: userScore)
        else {
            NSLog("A text field with empty string got passed")
            return
        }
        let scoreID = UUID().uuidString
        let userScoreData = UserScoreData(id: scoreID,
                                          courseID: selectedScoreData.courseID,
                                          dateAdded: viewModel.getCurrentDateAsString(),
                                          score: userScore,
                                          handicap: scoreHandicap)
        ServiceCalls.shared.addScore(userScoreData: userScoreData)
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func editButtonAction() {
        NSLog("Edit Button Clicked")
        guard let selectedScoreData = viewModel.dataModel.selectedScoreData,
              let userInputScore = contentView.userScoreTextField.text else { return }
        let editedScoreData = SelectedScoreInput(scoreID: selectedScoreData.scoreID,
                                                 courseID: selectedScoreData.courseID,
                                                 userScore: userInputScore)
        ServiceCalls.shared.editScore(selectedScoreData: editedScoreData)
        navigationController?.popViewController(animated: true)
    }

    @objc private func courseInfoViewAction(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(CourseListViewController(), animated: true)
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
