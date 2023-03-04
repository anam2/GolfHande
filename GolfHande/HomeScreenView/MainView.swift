import UIKit

class MainView: UIView {

    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        setupUI()
        setupConstraints()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    private func setupUI() {
        addSubview(scoreInputViewButton)
        addSubview(courseNameLabel)
        addSubview(totalScoreLabel)
        addSubview(courseRatingLabel)
        addSubview(courseSlopeLabel)
    }

    private func setupConstraints() {
        let scoreInputViewButtonConstraint = [
            scoreInputViewButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            scoreInputViewButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ]

        let courseNameLabelConstraint = [
            courseNameLabel.topAnchor.constraint(equalTo: scoreInputViewButton.bottomAnchor, constant: 20),
            courseNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]

        let totalScoreLabelConstraint = [
            totalScoreLabel.topAnchor.constraint(equalTo: courseNameLabel.bottomAnchor, constant: 20),
            totalScoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]

        let courseRatingLabelConstraint = [
            courseRatingLabel.topAnchor.constraint(equalTo: totalScoreLabel.bottomAnchor, constant: 20),
            courseRatingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]

        let courseSlopeLabelConstraint = [
            courseSlopeLabel.topAnchor.constraint(equalTo: courseRatingLabel.bottomAnchor, constant: 20),
            courseSlopeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]

        NSLayoutConstraint.activate(scoreInputViewButtonConstraint)
        NSLayoutConstraint.activate(courseNameLabelConstraint)
        NSLayoutConstraint.activate(totalScoreLabelConstraint)
        NSLayoutConstraint.activate(courseRatingLabelConstraint)
        NSLayoutConstraint.activate(courseSlopeLabelConstraint)
    }

    // MARK: UI COMPONENTS

    private func getLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    lazy var courseNameLabel: UILabel = {
        let label = getLabel()
        label.text = "Couse Name: "
        return label
    }()

    lazy var totalScoreLabel: UILabel = {
        let label = getLabel()
        label.text = "Total Score: "
        return label
    }()

    lazy var courseRatingLabel: UILabel = {
        let label = getLabel()
        label.text = "Course Rating: "
        return label
    }()

    lazy var courseSlopeLabel: UILabel = {
        let label = getLabel()
        label.text = "Course Slope: "
        return label
    }()

    lazy var scoreInputViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Score Input View", for: .normal)
        return button
    }()
}
