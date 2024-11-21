//
//  AuthService.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/21/24.
//
//  Description:
//      Handles authentication logic.
//      Currently just checks against mock user & password
//      This would be the component that connects to AWS
//
import Foundation

final class AuthService: ObservableObject {
    @Published var currentUser: User? = nil
        
    // Simulate signing in a user
    func signIn(email: String, password: String) async throws -> User {
        // We would replace this logic with AWS database calls
        guard email == "user@example.com", password == "password" else {
            throw AuthError.invalidCredentials
        }
        let user = User(email: email, password: password)
        currentUser = user
        return user
    }

    enum AuthError: Error {
        case invalidCredentials
    }
}
