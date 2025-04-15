//
//  LoginView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/14/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark
                    ? [Color(red: 0.1, green: 0.1, blue: 0.1), Color(red: 0.3, green: 0.3, blue: 0.3)] // Dark
                    : [Color(red: 0.78, green: 0.88, blue: 1.0), Color(red: 1.0, green: 0.96, blue: 0.88)]  // Light
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                Text("Welcome Back")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                
                // Email Field
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                
                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                
                // Forgot Password
                HStack {
                    Spacer()
                    Button(action: {
                        print("Forgot password tapped")
                    }) {
                        Text("Forgot Password?")
                            .font(.subheadline)
                            .foregroundColor(false ? Color.blue : Color.gray.opacity(0.5))
                    }
                    .padding(.trailing, 30)
                    .disabled(true)
                }
                
                Spacer()

                // Login Button
                Button(action: {
                    print("Log in tapped")
                    
                    
                    
                    
                }) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 100)
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    LoginView()
}

