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
        container.backgroundColor = .lightGray
        container.addSubview(topLabel)
        topLabel.constrain(to: container, constraints: [.top(10), .leading(10)])
        container.addSubview(bottomLabel)
        bottomLabel.constrain(to: container, constraints: [.leading(10), .bottom(-10)])
        bottomLabel.constrain(to: topLabel, constraints: [.topToBottom(5)])

        NSLayoutConstraint.activate([
            topLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: 10),
            bottomLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: 10)
        ])
        return container
    }()

    private lazy var topLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func setupCell(topText: String, bottomText: String) {
        topLabel.text = topText
        bottomLabel.text = bottomText
    }

    private func setupUI() {
        contentView.addSubview(mainContainer)
        mainContainer.constrain(to: contentView, constraints: [.top(10), .leading(0), .trailing(0), .bottom(-10)])
    }
}
