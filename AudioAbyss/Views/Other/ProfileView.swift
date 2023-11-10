//
//  ProfileView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject var profileVM: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            if let user = profileVM.user {
                HStack {
                    if let urlString = user.images.first?.url, let imageURL = URL(string: urlString) {
                        WebImage(url: imageURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75.0, height: 75.0)
                            .cornerRadius(15.0)
                            .padding()
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Full Name: \(user.display_name)")
                            .font(.custom("Teko", size: 25.0).bold())
                        Text("Email Address: \(user.email)")
                            .font(.custom("Teko", size: 15.0))
                    }
                    Spacer()
                }
                
//                Text("User ID: \(user.id)")
//                    .font(.custom("Teko", size: 15.0))
//                Text("Origin: \(user.country)")
//                    .font(.custom("Teko", size: 15.0))
//                Text("Plan: \(user.product)")
//                    .font(.custom("Teko", size: 15.0))
            } else {
                Text("Failed to load profile")
            }
            Spacer()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
