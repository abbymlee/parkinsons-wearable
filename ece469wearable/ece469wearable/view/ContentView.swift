//
//  ContentView.swift
//  ece469wearable
//
//  Created by Emily Shao on 4/13/25.
//

import SwiftUI

enum Tab {
    case history
    case bluetooth
    case home
    case collect
    case settings
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    @StateObject private var db = DatabaseManager()
    @StateObject private var btManager = BluetoothManager()
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                PastHistoryView()
                    .tabItem { Label("History", systemImage: "chart.bar") }
                    .tag(Tab.history)
                    .padding(.bottom, 8)
                BluetoothView(db: db, btManager: btManager)
                    .tabItem { Label("Bluetooth", systemImage: "antenna.radiowaves.left.and.right") }
                    .tag(Tab.bluetooth)
                    .padding(.bottom, 8)
                HomeView(db: db, btManager: btManager, selectedTab: $selectedTab)
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(Tab.home)
                    .padding(.bottom, 8)
                CollectionView()
                    .tabItem { Label("Session", systemImage: "play.fill") }
                    .tag(Tab.collect)
                    .padding(.bottom, 8)
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                    .tag(Tab.settings)
                    .padding(.bottom, 8)
            }
//            .padding(.top, 10)
        }
    }
}

#Preview {
    ContentView()
}
