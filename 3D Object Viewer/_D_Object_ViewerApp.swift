//
//  _D_Object_ViewerApp.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/19/24.
//

import SwiftUI
import SwiftData

@main
struct _D_Object_ViewerApp: App {
    @StateObject private var authService = AuthService()
    @StateObject private var authViewModel: AuthViewModel
    
    var container: ModelContainer = {
        let schema = Schema([
            ScanModel.self, User.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(for: schema,
                                      configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
    // Initialize authViewModel
    init() {
        let viewModel = AuthViewModel(
            authService: AuthService(),
            modelContext: container.mainContext
        )
        _authViewModel = StateObject(wrappedValue: viewModel)
    }
    
    // inject dependencies into child views
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated{
                GalleryView()
                    .preferredColorScheme(.dark)
                    .modelContainer(container)
                    .environmentObject(authViewModel)
            } else {
                AuthView()
                    .preferredColorScheme(.dark)
                    .modelContainer(container)
                    .environmentObject(authViewModel)
            }
        }
    }
}

