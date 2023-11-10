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
        NavigationStack {
            ScrollView {
                Spacer()
                VStack {
                    if let user = profileVM.user {
                        Spacer()
                            .frame(height: 50)
                        if let urlString = user.images.last?.url, let imageURL = URL(string: urlString) {
                            WebImage(url: imageURL)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .clipShape(Circle())
                                .background { Circle().foregroundStyle(.foreground)
                                    .frame(width: 320, height: 320) }
                                .padding()
                        }
                        Text("\(user.display_name)")
                            .font(.custom("Teko", size: 25.0).bold())
                        Text("\(user.email)")
                            .font(.custom("Teko", size: 15.0))
                        Text("User ID: \(user.id)")
                            .font(.custom("Teko", size: 12.0))
                        Text("Origin: \(user.country)")
                            .font(.custom("Teko", size: 12.0))
                        Text("Plan: \(user.product)")
                            .font(.custom("Teko", size: 12.0))
                        Spacer()
                    } else {
                        Text("Refresh")
                            .font(.custom("Teko", size: 25.0).bold())
                            .onTapGesture {
                                profileVM.fetchProfile()
                            }
                    }
                    Spacer()
                }
            }
            .navigationTitle("Your own little bubble")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
        }
    }
}
