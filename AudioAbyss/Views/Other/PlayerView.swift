//
//  PlayerView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlayerView: View {
    @StateObject var playerVM: PlayerViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            if let track = playerVM.track {
                VStack {
                    Spacer()
                        .frame(height: 30)
                    if let urlString = track.album?.images.first?.url, let imageURL = URL(string: urlString) {
                        WebImage(url: imageURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(25.0)
                    } else if let imageURL = playerVM.albumImageURL {
                        WebImage(url: imageURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(25.0)
                    }
                    Text("\(track.name)")
                        .font(.custom("Teko", size: 15.0).bold())
                    Text("\(playerVM.joinArtists(track: track))")
                        .font(.custom("Teko", size: 15.0))
                    Divider()
                        .padding(.horizontal)
                    Spacer()
                }
            } else {
                Text("Player Not Working As Expected!")
                    .font(.custom("Teko", size: 15.0).bold())
            }
        }
        .navigationTitle("\(playerVM.track?.name ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }, label: { Image(systemName: "arrow.backward").foregroundStyle(.foreground) })
            }
        }
    }
}
