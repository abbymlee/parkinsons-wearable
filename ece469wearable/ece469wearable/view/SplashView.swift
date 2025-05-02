//
//  SplashView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isActive = false
    
    var body: some View {
        
        if isActive {
            ContentView()
        } else {
            
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
                    Image(systemName: "shoe.fill") // Logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 100)
                        .foregroundColor(.white)
                    Text("WalkIT")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                }
                .background(Color.clear)
                
            } // ZStack
            .onAppear {
                // Simulate loading for 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
            
        }
        
    }
    
    
}

#Preview {
    SplashView()
}
