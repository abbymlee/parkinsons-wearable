//
//  SettingsView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var email: String = ""
    @State private var password: String = "p"
    @State private var creationDate: String = "d"
    @State private var useMetric: Bool = true
    
    
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
            
            VStack {
                
                Text("Account Settings")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    
                
                Form {
                    Section(header: Text("ACCOUNT").font(.caption).foregroundColor(.gray)) {
                        HStack {
                            Text("Email")
                            Spacer()
                            TextField("Email", text: $email)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(Color.gray)
                        }
                        
                        HStack {
                            Text("Password")
                            Spacer()
                            SecureField("Password", text: $password)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(Color.gray)
                        }
                        
                        HStack {
                            Text("Created On")
                            Spacer()
                            Text(creationDate)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(Color.gray)
                        }
                    }
                    
                    Section(header: Text("MEASUREMENTS").font(.caption).foregroundColor(.gray)) {
                        Toggle(isOn: $useMetric) {
                            Text("Use Metric (cm)")
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .padding(.horizontal, 0)
                
                Spacer()
            }
            .background(Color.clear)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        } // ZStack

    }
}

#Preview {
    SettingsView()
}
