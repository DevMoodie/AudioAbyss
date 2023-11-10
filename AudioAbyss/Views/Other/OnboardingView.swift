//
//  OnboardingView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isPresentAuthView = false
    @Binding var signedIn: Bool
    
    var body: some View {
        VStack {
            Button(action: signIn) {
                RoundedRectangle(cornerRadius: 15.0)
                    .frame(height: 65)
                    .padding()
            }
        }
        .sheet(isPresented: $isPresentAuthView) {
            if let authURL = AuthManager.shared.signInURL {
                AuthView(url: authURL, signedIn: $signedIn)
                    .ignoresSafeArea()
            }
        }
    }
    
    func signIn() {
        isPresentAuthView.toggle()
    }
}
