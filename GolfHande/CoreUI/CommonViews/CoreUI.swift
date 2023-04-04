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

    static func defaultUILabel(fontSize: CGFloat,
                               numberOfLines: Int = 0,
                               lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = lineBreakMode
        label.numberOfLines = numberOfLines
        label.font = label.font.withSize(fontSize)
        return label
    }

    // Might genreate constraint error.
    static func createLabelTextFieldView(labelText: String,
                                         labelAlignment: NSTextAlignment = .natural,
                                         textField: UITextField) -> UIView {
        let labelTextFieldView = UIView()
        let labelView = UILabel()
        labelView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        labelView.text = labelText
        labelView.textAlignment = labelAlignment

        labelTextFieldView.addSubview(labelView)
        labelView.constrain(to: labelTextFieldView, constraints: [.top(.zero), .leading(.zero), .trailing(.zero)])

        labelTextFieldView.addSubview(textField)
        textField.constrain(to: labelTextFieldView, constraints: [.leading(5),
                                                                  .trailing(.zero),
                                                                  .bottom(.zero)])
        textField.constrain(to: labelView, constraints: [.topToBottom(5)])
        return labelTextFieldView
    }

    static func selectionButton(text: String, isSelected: Bool, action: Selector) -> UIButton {
        let button = UIButton()
        // Flipped. If button is disabled = SELECTED. If button is enabled = NOT selected.
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(UIColor.white, for: .disabled)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.isEnabled = !isSelected
        button.backgroundColor = .blue
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
