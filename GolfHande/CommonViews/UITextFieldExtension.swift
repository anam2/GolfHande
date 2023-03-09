import UIKit

extension UITextField {
    func displayError(_ displayError: Bool) {
        if displayError {
            self.borderStyle = .roundedRect
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.red.cgColor
        } else {
            self.layer.borderWidth = 0.0
        }
    }
}
