//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Pavel Akulenak on 16.08.21.
//

import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()

    func insertUser(user: User) {
        database.child("users").child(user.uid).setValue(["firstName": user.firstName, "lastName": user.lastName, "email": user.email])
    }
}
