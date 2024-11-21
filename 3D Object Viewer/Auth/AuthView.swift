//
//  AuthView.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/19/24.
//
//  Description:
//      The View where you sign in.
//      email: user@example.com
//      password: password
//
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.quaternary)
                .ignoresSafeArea()
                
            VStack(spacing: 20) {
                Image(systemName: "scanner")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.orange)
                    
                Text("Welcome to ScanView 3D")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                                    
                TextField("Email", text: $authViewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    
                SecureField("Password", text: $authViewModel.password)
                    .textFieldStyle(.roundedBorder)
                Button {
                    authViewModel.signIn()
                } label: {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var modelContext

    let mockAuthViewModel = AuthViewModel(authService: AuthService(),
                                          modelContext: modelContext) 

    AuthView()
        .environmentObject(mockAuthViewModel)
}
