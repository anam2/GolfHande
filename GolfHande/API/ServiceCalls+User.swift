//
//  ServiceCalls+User.swift
//  GolfHande
//
//  Created by Andy Nam on 4/15/23.
//
import FirebaseAuth

extension ServiceCalls {
    func addNewUser(userData: UserInformation,
                    completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        let userRef = usersRef.child(currentUser.uid)
        let userRefValues: [String: String] = [
            "email": userData.email,
            "name": userData.name ?? ""
        ]
        userRef.setValue(userRefValues)
        completion(true)
    }
}
