
//
//  AuthViewModel.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/20/24.
//
//  Description:
//      Interfaces with AuthService (which would make calls to AWS)
//      & handles SwiftData storage of the User, in order to persist login state
//
import SwiftUI
import SwiftData

final class AuthViewModel: ObservableObject {
    private let authService: AuthService
    private var modelContext: ModelContext

    var email: String = ""
    var password: String = ""
    @Published var isAuthenticated: Bool = false

    init(authService: AuthService, modelContext: ModelContext) {
        self.authService = authService
        self.modelContext = modelContext
        checkForSavedUser()
    }

    // Check for saved user credentials and sign in if available
    private func checkForSavedUser() {
        if let savedUser = fetchSavedUser() {
            print("logging in saved user: \(savedUser.email)")
            authService.currentUser = savedUser
            isAuthenticated = true
        }
    }
    
    // Fetch saved user from ModelContext
    private func fetchSavedUser() -> User? {
        do {
            let savedUsers = try modelContext.fetch(FetchDescriptor<User>())
            if let savedUser = savedUsers.first {
                print("Fetched saved user: \(savedUser.email)")
                return savedUser
            }
        } catch {
            print("Failed to fetch saved user: \(error)")
        }
        return nil
    }
    
    // Saved user to ModelContext
    private func saveUserCredentials(_ user: User, modelContext: ModelContext) {
        modelContext.insert(user)
        do {
            try modelContext.save()
            print("Credentials saved for: \(user.email)")
        } catch {
            print("Failed to save credentials: \(error)")
        }
    }

    // Handle user sign-in 
    func signIn() {
        Task {
            do {
                let user = try await authService.signIn(email: email,
                                                        password: password)
                print("User signed in: \(user.email)")
                
                // Save user credentials to modelContext
                saveUserCredentials(user, modelContext: modelContext)
                
                isAuthenticated = true
            } catch {
                print("Failed to sign in: \(error)")
                isAuthenticated = false
            }
        }
    }
    
    // Handle user sign-out
    func signOut() {
        // Clear the current user in AuthService
        authService.currentUser = nil

        // Reset authentication state
        isAuthenticated = false
        email = ""
        password = ""

        // remove user data from the modelContext
        do {
            if let savedUser = try modelContext.fetch(FetchDescriptor<User>()).first {
                modelContext.delete(savedUser)
                try modelContext.save()
                print("User data removed from context.")
            }
        } catch {
            print("Failed to remove user data: \(error)")
        }

        print("User signed out.")
    }
}
