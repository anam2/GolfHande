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

    static func textFieldView() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
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
}
