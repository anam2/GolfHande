import UIKit

extension CoreUI {
    static func createTextFieldLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.text = text
        return label
    }

    static func createTextField() -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGrayBackground.cgColor
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }
}
