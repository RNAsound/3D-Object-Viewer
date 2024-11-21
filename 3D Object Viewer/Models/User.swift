//
//  User.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/21/24.
//
// Description:
//      SwiftData Model for the User Data. If we were using AWS,
//      User would conform to Codable to store JSON data for API calls
//
import Foundation
import SwiftData

// User model for authentication
@Model
final class User: Identifiable {
    var id: UUID
    var email: String
    var password: String
    
    init(id: UUID = UUID(), email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}
