import UIKit

struct CoreUI {
    static func getBorderView(color: CGColor? = UIColor.black.cgColor) -> UIView {
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = color
        return borderView
    }

    static func defaultUILabel(fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.font = label.font.withSize(fontSize)
        return label
    }
}
