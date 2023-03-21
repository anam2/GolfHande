import UIKit

class ScoresTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    func setupCellData(dateAdded: String,
                       courseName: String,
                       courseRating: String,
                       courseSlope: String,
                       userScoreValue: String) {
        dateAddedLabel.text = dateAdded
        courseNameLabel.text = courseName
        courseRatingLabel.text = "Rating: " + courseRating
        courseSlopeLabel.text = "Slope: " + courseSlope
        userScoreValueLabel.text = userScoreValue
        setupUI()
    }

    private func setupUI() {
        setupCellContentView()
        self.contentView.addSubview(containerView)
        containerView.constrain(to: self.contentView,
                                constraints: [.top(10), .leading(10),.bottom(-10)])
        self.contentView.addSubview(handicapContainer)
        handicapContainer.constrain(to: self.contentView,
                                    constraints: [.centerY(), .trailing(-10)])
        handicapContainer.constrain(to: containerView, constraints: [.leadingToTrailing(5)])
    }

    private func setupCellContentView() {
        self.contentView.backgroundColor = .white
    }

    // MARK: UI COMPONENTS:

    private lazy var containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        dateAddedLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        courseNameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        courseSlopeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        courseRatingLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        container.addSubview(dateAddedLabel)
        dateAddedLabel.constrain(to: container, constraints: [.top(10), .leading(10)])

        container.addSubview(courseNameLabel)
        courseNameLabel.constrain(to: container, constraints: [.leading(10)])
        courseNameLabel.constrain(to: dateAddedLabel, constraints: [.topToBottom(5)])

        container.addSubview(courseSlopeLabel)
        courseSlopeLabel.constrain(to: courseNameLabel, constraints: [.topToBottom(5)])
        courseSlopeLabel.constrain(to: container, constraints: [.leading(10)])

        container.addSubview(courseRatingLabel)
        courseRatingLabel.constrain(to: courseSlopeLabel, constraints: [.topToBottom(5)])
        courseRatingLabel.constrain(to: container, constraints: [.leading(10), .bottom(-10)])

        return container
    }()

    private lazy var dateAddedLabel: UILabel = {
        let label = CoreUI.defaultUILabel(fontSize: 14)
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()

    private lazy var courseNameLabel: UILabel = {
        CoreUI.defaultUILabel(fontSize: 14)
    }()

    private lazy var courseSlopeLabel: UILabel = {
        CoreUI.defaultUILabel(fontSize: 10)
    }()

    private lazy var courseRatingLabel: UILabel = {
        CoreUI.defaultUILabel(fontSize: 10)
    }()

    private lazy var handicapContainer: UIView = {
        let container = UIView()
        container.addSubview(userScoreLabel)
        userScoreLabel.constrain(to: container, constraints: [.top(0), .leading(0), .trailing(0)])
        container.addSubview(userScoreValueLabel)
        userScoreValueLabel.constrain(to: container, constraints: [.centerX(), .bottom(0)])
        userScoreValueLabel.constrain(to: userScoreLabel, constraints: [.topToBottom(5)])
        return container
    }()

    private lazy var userScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private lazy var userScoreValueLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(18)
        return label
    }()

    private lazy var borderView: UIView = { CoreUI.getBorderView() }()
}
