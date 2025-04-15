//
//  SplashView.swift
//  parkinsonwalker
//
//  Created by Emily Shao on 4/5/25.
//


import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Image(systemName: "shoe.fill") // Logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
                    .foregroundColor(.yellow)
                Text("WalkIT")
                    .font(.largeTitle)
                    .bold()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
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

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
