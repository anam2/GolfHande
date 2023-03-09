import UIKit

class ScoresTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    func setupCellData(with scoresData: ScoreData) {
        dateAddedLabel.text = scoresData.dateAdded
        courseNameLabel.text = scoresData.courseName
        courseRatingLabel.text = "Rating: " + scoresData.courseRating
        courseSlopeLabel.text = "Slope: " + scoresData.courseRating
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
        container.addSubview(handicapLabel)
        handicapLabel.constrain(to: container, constraints: [.top(0), .leading(0), .trailing(0)])
        container.addSubview(handicapValueLabel)
        handicapValueLabel.constrain(to: container, constraints: [.centerX(), .bottom(0)])
        handicapValueLabel.constrain(to: handicapLabel, constraints: [.topToBottom(5)])
        return container
    }()

    private lazy var handicapLabel: UILabel = {
        let label = UILabel()
        label.text = "Handicap"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private lazy var handicapValueLabel: UILabel = {
        let label = UILabel()
        label.text = "9.2"
        label.font = label.font.withSize(18)
        return label
    }()

    private lazy var borderView: UIView = { CoreUI.getBorderView() }()
}
