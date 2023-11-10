//
//  ContentView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI

struct ContentView: View {
    @State var signedIn: Bool = false
    
    init() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: "Teko", size: 11)! ], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Teko", size: 17)!]
    }
    
    var body: some View {
        if AuthManager.shared.isSignedIn || signedIn {
            TabView {
                MainMenuView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                SearchView()
                    .tabItem {
                        Label("Explore", systemImage: "safari")
                    }
                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "book.pages")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
        } else {
            OnboardingView(signedIn: $signedIn)
        }
    }
}

#Preview {
    ContentView()
}
