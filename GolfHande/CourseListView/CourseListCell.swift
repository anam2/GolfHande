import UIKit

class CourseListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    // MARK: UI COMPONENTS

    private lazy var mainContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .lightGrayBackground

        container.addSubview(courseNameLabel)
        courseNameLabel.constrain(to: container, constraints: [.top(10), .leading(10), .trailing(-10)])

        container.addSubview(courseInfoView)
        courseInfoView.constrain(to: container, constraints: [.centerX(.zero), .bottom(-10)])
        courseInfoView.constrain(to: courseNameLabel, constraints: [.topToBottom(10)])

        NSLayoutConstraint.activate([
            courseInfoView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 10),
            courseInfoView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -10)
        ])

        return container
    }()

    private lazy var courseNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        return label
    }()

    private lazy var courseInfoView: UIView = {
        let courseInfoView = UIView()
        courseInfoView.addSubview(courseSlopeView)
        courseInfoView.addSubview(courseRatingView)

        courseSlopeView.constrain(to: courseInfoView,
                                  constraints: [.top(.zero), .leading(.zero), .bottom(.zero)])
        courseRatingView.constrain(to: courseInfoView,
                                   constraints: [.top(.zero), .trailing(.zero), .bottom(.zero)])
        courseRatingView.constrain(to: courseSlopeView, constraints: [.leadingToTrailing(20)])
        return courseInfoView
    }()

    private lazy var courseSlopeView: UIView = {
        let slopeView = createDetailView(labelText: "Slope", valueLabelView: courseSlopeValueLabel)
        return slopeView
    }()

    private lazy var courseRatingView: UIView = {
        let ratingView = createDetailView(labelText: "Rating", valueLabelView: courseRatingValueLabel)
        return ratingView
    }()

    private lazy var courseRatingValueLabel: UILabel = {
        let label = createDetailSubtitleLabel()
        return label
    }()

    private lazy var courseSlopeValueLabel: UILabel = {
        let label = createDetailSubtitleLabel()
        return label
    }()

    // MARK: SETUP

    func setupCell(courseName: String, courseRating: String, courseSlope: String) {
        courseNameLabel.text = courseName
        courseRatingValueLabel.text = courseRating
        courseSlopeValueLabel.text = courseSlope
    }

    private func setupUI() {
        contentView.addSubview(mainContainer)
        mainContainer.constrain(to: contentView, constraints: [.top(10), .leading(0), .trailing(0), .bottom(-10)])
    }

    // MARK: CREATE UI VIEW FUNCS

    private func createDetailTitleLabel() -> UILabel {
        let detailLabel = UILabel()
        detailLabel.font = detailLabel.font.withSize(14.0)
        detailLabel.textAlignment = .center
        return detailLabel
    }

    private func createDetailSubtitleLabel() -> UILabel {
        let subtitleLabel = UILabel()
        subtitleLabel.font = subtitleLabel.font.withSize(16.0)
        subtitleLabel.textAlignment = .center
        return subtitleLabel
    }

    private func createDetailView(labelText: String,
                                  valueLabelView: UILabel) -> UIView {
        let ratingView = UIView()
        ratingView.layer.borderWidth = 2.0
        ratingView.layer.cornerRadius = 10.0
        let ratingLabel = createDetailTitleLabel()
        ratingLabel.text = labelText
        ratingView.addSubview(ratingLabel)
        ratingView.addSubview(valueLabelView)
        ratingLabel.constrain(to: ratingView, constraints: [.top(5), .leading(5), .trailing(-5)])
        valueLabelView.constrain(to: ratingView, constraints: [.leading(5), .trailing(-5), .bottom(-5)])
        valueLabelView.constrain(to: ratingLabel, constraints: [.topToBottom(5)])
        return ratingView
    }
}
