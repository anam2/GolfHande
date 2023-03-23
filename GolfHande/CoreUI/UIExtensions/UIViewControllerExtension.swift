import UIKit

extension UIViewController {

    /// Hides keyboard when user taps outside of keyboard.
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() { view.endEditing(true) }

    func showActivityIndicator() {
        let activityView = UIActivityIndicatorView()
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }

    func hideActivityIndicator(){
        DispatchQueue.main.async {
            for subview in self.view.subviews {
                if let activityIndicator = subview as? UIActivityIndicatorView {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            }
        }
    }
}
