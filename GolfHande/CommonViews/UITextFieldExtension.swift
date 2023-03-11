import UIKit

extension UITextField {

    func showError(with displayErrorString: String) {
        // Constraints UILabel to UITextField.
        let errorLabel = UILabel()
        errorLabel.tag = 1
        errorLabel.text = displayErrorString
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.textColor = UIColor.red
        self.addSubview(errorLabel)
        errorLabel.constrain(to: self, constraints: [.leading(.zero),
                                                     .trailing(.zero),
                                                     .topToBottom(5)])

        // Makes border of text field red.
        self.borderStyle = .roundedRect
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.red.cgColor
    }

    func hideError() {
        // Removes error label.
        for subview in self.subviews {
            // Tag == 1 -> Error Label
            if subview.tag == 1 {
                subview.removeFromSuperview()
            }
        }
        // Hides border.
        self.layer.borderWidth = 0.0
    }
}