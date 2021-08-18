//
//  AuthenticationManager.swift
//  Messenger
//
//  Created by Pavel Akulenak on 18.08.21.
//

import FirebaseAuth

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private let auth = FirebaseAuth.Auth.auth()
    
    func createUser(email: String, password: String, firstName: String, lastName: String, completion: @escaping ((Error?) -> Void)) {
        auth.createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                completion(error)
            } else if let result = authDataResult {
                DatabaseManager.shared.insertUser(user: User(email: email, firstName: firstName, lastName: lastName, uid: result.user.uid))
            }
        }
    }

    func logIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }
}
