//
//  SignUpViewModel.swift
//  GolfHande
//
//  Created by Andy Nam on 4/10/23.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var popBackToLoginView: Bool = false

    @Published var displayError: Bool = false
    @Published var errorDisplayText: String = ""

    func createAccount(userInformation: UserInformation,
                       completion: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        LoginHandler.shared.createNewAccount(email: userInformation.email,
                                             password: userInformation.password) { success, error in
            if !success {
                NSLog("Creating account for user: \(userInformation) has failed with error: \(error.debugDescription)")
                self.errorDisplayText = error?.localizedDescription ?? ""
                self.displayError = true
                completion(false, error?.localizedDescription)
                return
            }
            NSLog("Account for user: \(userInformation) created successfully.")
            self.displayError = false
            self.popBackToLoginView = true
            completion(true, nil)
        }
    }
}
